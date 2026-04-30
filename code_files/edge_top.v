`timescale 1ns / 1ps

// ============================================================
// UART RX
// ============================================================
module uart_rx #(parameter CLKS_PER_BIT = 868) (
    input  wire       clk,
    input  wire       rx,
    output reg  [7:0] data,
    output reg        ready
);
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state     = IDLE;
    reg [9:0] clk_count = 0;
    reg [2:0] bit_index = 0;

    always @(posedge clk) begin
        ready <= 1'b0;
        case (state)
            IDLE: begin
                clk_count <= 0;
                bit_index <= 0;
                if (rx == 1'b0) state <= START;
            end
            START: begin
                if (clk_count == (CLKS_PER_BIT-1)/2) begin
                    if (rx == 1'b0) begin
                        clk_count <= 0;
                        state     <= DATA;
                    end else state <= IDLE;
                end else clk_count <= clk_count + 1;
            end
            DATA: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count       <= 0;
                    data[bit_index] <= rx;
                    if (bit_index < 7) bit_index <= bit_index + 1;
                    else begin
                        bit_index <= 0;
                        state     <= STOP;
                    end
                end
            end
            STOP: begin
                if (clk_count < CLKS_PER_BIT-1) clk_count <= clk_count + 1;
                else begin
                    ready     <= 1'b1;
                    clk_count <= 0;
                    state     <= IDLE;
                end
            end
        endcase
    end
endmodule

// ============================================================
// UART TX
// ============================================================
module uart_tx #(parameter CLKS_PER_BIT = 868) (
    input  wire       clk,
    input  wire       start,
    input  wire [7:0] data,
    output reg        tx,
    output reg        busy
);
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state     = IDLE;
    reg [9:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] tx_data   = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx        <= 1'b1;
                busy      <= 1'b0;
                clk_count <= 0;
                bit_index <= 0;
                if (start) begin
                    tx_data <= data;
                    busy    <= 1'b1;
                    state   <= START;
                end
            end
            START: begin
                tx <= 1'b0;
                if (clk_count < CLKS_PER_BIT-1) clk_count <= clk_count + 1;
                else begin clk_count <= 0; state <= DATA; end
            end
            DATA: begin
                tx <= tx_data[bit_index];
                if (clk_count < CLKS_PER_BIT-1) clk_count <= clk_count + 1;
                else begin
                    clk_count <= 0;
                    if (bit_index < 7) bit_index <= bit_index + 1;
                    else begin bit_index <= 0; state <= STOP; end
                end
            end
            STOP: begin
                tx <= 1'b1;
                if (clk_count < CLKS_PER_BIT-1) clk_count <= clk_count + 1;
                else begin clk_count <= 0; state <= IDLE; end
            end
        endcase
    end
endmodule

// ============================================================
// PIXEL BUFFER - 4 pixels per block → 32-bit output
// ============================================================
module pixel_buffer (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  pixel_in,
    input  wire        pixel_valid,
    output reg  [31:0] block_data,
    output reg         block_ready
);
    reg [2:0]  pixel_count = 0;
    reg [31:0] shift_reg   = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pixel_count <= 0;
            block_ready <= 0;
            shift_reg   <= 0;
            block_data  <= 0;
        end else begin
            block_ready <= 1'b0;
            if (pixel_valid) begin
                shift_reg   <= {shift_reg[23:0], pixel_in};
                pixel_count <= pixel_count + 1;
                if (pixel_count == 3'd3) begin
                    block_data  <= {shift_reg[23:0], pixel_in};
                    block_ready <= 1'b1;
                end
            end
        end
    end
endmodule

// ============================================================
// SPLIT LOGIC - min/max over 4 pixels
// ============================================================
module split_logic (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  threshold,
    input  wire [31:0] block_data,
    input  wire        block_ready,
    output reg         split_needed
);
    integer i;
    reg [7:0] cur_pixel;
    reg [7:0] max_val;
    reg [7:0] min_val;

    reg sync1 = 0, sync2 = 0, sync3 = 0;
    wire block_ready_pulse = sync2 & ~sync3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync1 <= 0; sync2 <= 0; sync3 <= 0;
        end else begin
            sync1 <= block_ready;
            sync2 <= sync1;
            sync3 <= sync2;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            split_needed <= 0;
        end else if (block_ready_pulse) begin
            max_val = 8'd0;
            min_val = 8'd255;
            for (i = 0; i < 4; i = i + 1) begin
                cur_pixel = block_data[(i*8) +: 8];
                if (cur_pixel > max_val) max_val = cur_pixel;
                if (cur_pixel < min_val) min_val = cur_pixel;
            end
            split_needed <= ((max_val - min_val) > threshold) ? 1'b1 : 1'b0;
        end
    end
endmodule

// ============================================================
// TOP LEVEL
// ============================================================
module top_level (
    input  wire       clk,
    input  wire       UART_rxd,
    output wire       UART_txd,
    output wire [7:0] led
);
    localparam N_PIXELS = 16384;
    localparam N_BLOCKS = 4096;

    // Boot delay
    reg [25:0] boot_cnt  = 0;
    reg        boot_done = 0;
    always @(posedge clk) begin
        if (!boot_done) begin
            boot_cnt <= boot_cnt + 1;
            if (boot_cnt == 26'd49_999_999)
                boot_done <= 1'b1;
        end
    end

    // BRAM
    reg [7:0]  frame_buf  [0:16383];
    reg [7:0]  result_buf [0:4095];

    // UART
    wire [7:0] rx_byte;
    wire       rx_ready;
    reg        tx_start = 0;
    reg  [7:0] tx_byte  = 0;
    wire       tx_busy;

    uart_rx #(.CLKS_PER_BIT(868)) rx_inst (
        .clk(clk), .rx(UART_rxd),
        .data(rx_byte), .ready(rx_ready)
    );
    uart_tx #(.CLKS_PER_BIT(868)) tx_inst (
        .clk(clk), .start(tx_start),
        .data(tx_byte), .tx(UART_txd), .busy(tx_busy)
    );

    // Pixel buffer + split logic
    reg        pixel_valid = 0;
    reg  [7:0] pixel_in    = 0;
    wire [31:0] block_data;
    wire        block_ready;
    wire        split_needed;

    pixel_buffer buf_inst (
        .clk(clk), .rst_n(1'b1),
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .block_data(block_data),
        .block_ready(block_ready)
    );

    split_logic slc_inst (
        .clk(clk), .rst_n(1'b1),
        .threshold(threshold_reg),
        .block_data(block_data),
        .block_ready(block_ready),
        .split_needed(split_needed)
    );

    // FSM
    localparam S_BOOT      = 4'd0;
    localparam S_WAIT_FF   = 4'd1;
    localparam S_THRESH    = 4'd2;
    localparam S_RX_IMG    = 4'd3;
    localparam S_PROC_LOAD = 4'd4;
    localparam S_PROC_WAIT = 4'd5;
    localparam S_STORE_RES = 4'd6;
    localparam S_TX_LOAD   = 4'd7;
    localparam S_TX_WAIT   = 4'd8;
    localparam S_TX_BUSY   = 4'd9;

    reg [3:0]  state         = S_BOOT;
    reg [7:0]  threshold_reg = 8'd30;
    reg [13:0] rx_addr       = 0;
    reg [13:0] proc_addr     = 0;
    reg [11:0] blk_addr      = 0;
    reg [11:0] tx_addr       = 0;
    reg [2:0]  pix_in_block  = 0;
    reg [3:0]  wait_cnt      = 0;

    always @(posedge clk) begin
        tx_start    <= 1'b0;
        pixel_valid <= 1'b0;

        case (state)

            S_BOOT: begin
                if (boot_done) state <= S_WAIT_FF;
            end

            S_WAIT_FF: begin
                rx_addr      <= 0;
                proc_addr    <= 0;
                blk_addr     <= 0;
                tx_addr      <= 0;
                pix_in_block <= 0;
                if (rx_ready && rx_byte == 8'hFF)
                    state <= S_THRESH;
            end

            S_THRESH: begin
                if (rx_ready) begin
                    threshold_reg <= rx_byte;
                    state         <= S_RX_IMG;
                end
            end

            S_RX_IMG: begin
                if (rx_ready) begin
                    frame_buf[rx_addr] <= rx_byte;
                    if (rx_addr == 14'd16383) begin
                        rx_addr <= 0;
                        state   <= S_PROC_LOAD;
                    end else begin
                        rx_addr <= rx_addr + 1;
                    end
                end
            end

            S_PROC_LOAD: begin
                pixel_in     <= frame_buf[proc_addr];
                pixel_valid  <= 1'b1;
                pix_in_block <= pix_in_block + 1;
                if (proc_addr == 14'd16383)
                    proc_addr <= 0;
                else
                    proc_addr <= proc_addr + 1;
                if (pix_in_block == 3'd3) begin
                    pix_in_block <= 0;
                    wait_cnt     <= 0;
                    state        <= S_PROC_WAIT;
                end
            end

            S_PROC_WAIT: begin
                wait_cnt <= wait_cnt + 1;
                if (wait_cnt == 4'd9)
                    state <= S_STORE_RES;
            end

            S_STORE_RES: begin
                result_buf[blk_addr] <= {7'b0, split_needed};
                if (blk_addr == 12'd4095) begin
                    blk_addr <= 0;
                    state    <= S_TX_LOAD;
                end else begin
                    blk_addr <= blk_addr + 1;
                    state    <= S_PROC_LOAD;
                end
            end

            S_TX_LOAD: begin
                tx_byte  <= result_buf[tx_addr];
                tx_start <= 1'b1;
                state    <= S_TX_WAIT;
            end

            S_TX_WAIT: begin
                if (tx_busy) state <= S_TX_BUSY;
            end

            S_TX_BUSY: begin
                if (!tx_busy) begin
                    if (tx_addr == 12'd4095) begin
                        tx_addr <= 0;
                        state   <= S_WAIT_FF;
                    end else begin
                        tx_addr <= tx_addr + 1;
                        state   <= S_TX_LOAD;
                    end
                end
            end

        endcase
    end

    assign led = {4'b0, state};

endmodule