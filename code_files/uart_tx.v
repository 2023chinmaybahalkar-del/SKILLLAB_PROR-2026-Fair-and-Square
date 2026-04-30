module uart_tx #(parameter CLKS_PER_BIT = 868) (
    input  wire       clk,
    input  wire       start,     // Pulse HIGH to start sending
    input  wire [7:0] data,      // Byte to send
    output reg        tx,        // Physical TX pin
    output reg        busy       // HIGH while sending
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state = IDLE;
    reg [9:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] tx_data = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx   <= 1'b1; // Drive line high
                busy <= 1'b0;
                if (start) begin
                    tx_data <= data;
                    state   <= START;
                    busy    <= 1'b1;
                end
            end

            START: begin
                tx <= 1'b0; // Start bit
                if (clk_count < CLKS_PER_BIT-1)
                    clk_count <= clk_count + 1;
                else begin
                    clk_count <= 0;
                    state     <= DATA;
                end
            end

            DATA: begin
                tx <= tx_data[bit_index];
                if (clk_count < CLKS_PER_BIT-1)
                    clk_count <= clk_count + 1;
                else begin
                    clk_count <= 0;
                    if (bit_index < 7)
                        bit_index <= bit_index + 1;
                    else begin
                        bit_index <= 0;
                        state     <= STOP;
                    end
                end
            end

            STOP: begin
                tx <= 1'b1; // Stop bit
                if (clk_count < CLKS_PER_BIT-1)
                    clk_count <= clk_count + 1;
                else begin
                    clk_count <= 0;
                    state     <= IDLE;
                end
            end
        endcase
    end
endmodule
