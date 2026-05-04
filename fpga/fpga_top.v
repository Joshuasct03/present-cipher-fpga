`timescale 1ns/1ps
module fpga_top(
    input  wire        clk,
    input  wire        rst_btn,
    input  wire        start_btn,
    output wire [7:0]  led
);

wire rstn = ~rst_btn;

// Debounce
reg [19:0] db_cnt;
reg        db_stable;
reg        db_prev;
reg        start_pulse;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        db_cnt      <= 0;
        db_stable   <= 0;
        db_prev     <= 0;
        start_pulse <= 0;
    end else begin
        if (start_btn) begin
            if (db_cnt < 20'd1_000_000)
                db_cnt <= db_cnt + 1;
            else
                db_stable <= 1;
        end else begin
            db_cnt    <= 0;
            db_stable <= 0;
        end
        db_prev     <= db_stable;
        start_pulse <= db_stable & ~db_prev;
    end
end

wire [63:0] ciphertext;
wire        done;
wire        bist_led;

reg        done_latched;
reg [7:0]  ct_top_byte;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        done_latched <= 1'b0;
        ct_top_byte  <= 8'h00;
    end else if (done) begin
        done_latched <= 1'b1;
        ct_top_byte  <= ciphertext[63:56];
    end
end

assign led[7]   = bist_led;
assign led[6]   = done_latched;
assign led[5:0] = ct_top_byte[5:0];

present_top u_present (
    .clk           (clk),
    .rst_n         (rstn),
    .start         (start_pulse),
    .user_mode     (1'b0),
    .plaintext     (64'h0000000000000000),
    .key           (80'h00000000000000000000),
    .ciphertext    (ciphertext),
    .done          (done),
    .bist_pass_led (bist_led)
);

endmodule
