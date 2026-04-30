`timescale 1ns / 1ps
module top_level (
    input  wire       clk,
    input  wire       UART_rxd,
    output wire       UART_txd,
    output wire [7:0] led
);
    // ?? Constants ?????????????????????????????????????????
    localparam N_PIXELS  = 16384;   // 128x128
    localparam N_BLOCKS  = 1024;    // 16384 / 16

    // ?? Boot delay: ignore first 500ms (board prints garbage on startup) ??
    reg [25:0] boot_cnt  = 0;
    reg        boot_done = 0;
    always @(posedge clk) begin
        if (!boot_done) begin
            boot_cnt <= boot_cnt + 1;
            if (boot_cnt == 26'd49_999_999)
                boot_done <= 1'b1;
        end
    end

    // ?? BRAM ??????????????????????????????????????????????
    reg [7:0] frame_buf  [0:16383];  // received image
    reg [7:0] result_buf [0:1023];   // edge results (0 or 1 per block)

    // ?? UART ??????????????????????????????????????????????
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

    // ?? Pixel buffer + split logic ?????????????????????????
    reg        pixel_valid = 0;
    reg  [7:0] pixel_in    = 0;
    wire [127:0] block_data;
    wire         block_ready;
    wire         split_needed;

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

    // ?? FSM ???????????????????????????????????????????????
    localparam S_BOOT      = 4'd0;   // waiting for boot delay
    localparam S_WAIT_FF   = 4'd1;   // waiting for 0xFF command
    localparam S_THRESH    = 4'd2;   // next byte = threshold
    localparam S_RX_IMG    = 4'd3;   // receiving 16384 pixels
    localparam S_PROC_LOAD = 4'd4;   // feeding pixels to pixel_buffer
    localparam S_PROC_WAIT = 4'd5;   // waiting for split_logic CDC result
    localparam S_STORE_RES = 4'd6;   // storing result byte
    localparam S_TX_LOAD   = 4'd7;   // loading result byte into TX
    localparam S_TX_WAIT   = 4'd8;   // waiting for tx_busy HIGH
    localparam S_TX_BUSY   = 4'd9;   // waiting for tx_busy LOW (byte done)

    reg [3:0]  state        = S_BOOT;
    reg [7:0]  threshold_reg = 8'd30;
    reg [13:0] rx_addr      = 0;
    reg [13:0] proc_addr    = 0;
    reg [9:0]  blk_addr     = 0;
    reg [9:0]  tx_addr      = 0;
    reg [3:0]  pix_in_block = 0;
    reg [3:0]  wait_cnt     = 0;

    always @(posedge clk) begin
        tx_start    <= 1'b0;
        pixel_valid <= 1'b0;

        case (state)

            // ?? Wait for board boot messages to finish ????
            S_BOOT: begin
                if (boot_done)
                    state <= S_WAIT_FF;
            end

            // ?? Wait for 0xFF start command ???????????????
            S_WAIT_FF: begin
                rx_addr      <= 0;
                proc_addr    <= 0;
                blk_addr     <= 0;
                tx_addr      <= 0;
                pix_in_block <= 0;
                if (rx_ready && rx_byte == 8'hFF)
                    state <= S_THRESH;
            end

            // ?? Receive threshold byte ????????????????????
            S_THRESH: begin
                if (rx_ready) begin
                    threshold_reg <= rx_byte;
                    state         <= S_RX_IMG;
                end
            end

            // ?? Receive all 16384 image pixels into BRAM ??
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

            // ?? Feed pixels one-by-one into pixel_buffer ??
            S_PROC_LOAD: begin
                pixel_in    <= frame_buf[proc_addr];
                pixel_valid <= 1'b1;
                pix_in_block <= pix_in_block + 1;

                if (proc_addr == 14'd16383)
                    proc_addr <= 0;
                else
                    proc_addr <= proc_addr + 1;

                if (pix_in_block == 4'd15) begin
                    pix_in_block <= 0;
                    wait_cnt     <= 0;
                    state        <= S_PROC_WAIT;
                end
            end

            // ?? Wait for CDC synchronizer to settle ???????
            // pixel_buffer fires block_ready for 1 cycle
            // split_logic has 3 sync FFs + edge detect = needs 4 cycles
            // We wait 10 cycles to be safe
            S_PROC_WAIT: begin
                wait_cnt <= wait_cnt + 1;
                if (wait_cnt == 4'd9)
                    state <= S_STORE_RES;
            end

            // ?? Store result, move to next block or TX ????
            S_STORE_RES: begin
                result_buf[blk_addr] <= {7'b0, split_needed};
                if (blk_addr == 10'd1023) begin
                    blk_addr <= 0;
                    state    <= S_TX_LOAD;
                end else begin
                    blk_addr <= blk_addr + 1;
                    state    <= S_PROC_LOAD;
                end
            end

            // ?? Transmit all 1024 result bytes back ???????
            S_TX_LOAD: begin
                tx_byte  <= result_buf[tx_addr];
                tx_start <= 1'b1;
                state    <= S_TX_WAIT;
            end

            S_TX_WAIT: begin
                if (tx_busy)
                    state <= S_TX_BUSY;
            end

            S_TX_BUSY: begin
                if (!tx_busy) begin
                    if (tx_addr == 10'd1023) begin
                        tx_addr <= 0;
                        state   <= S_WAIT_FF;   // ready for next frame
                    end else begin
                        tx_addr <= tx_addr + 1;
                        state   <= S_TX_LOAD;
                    end
                end
            end

        endcase
    end

    // LED: shows current FSM state for debugging
    assign led = {4'b0, state};

endmodule
