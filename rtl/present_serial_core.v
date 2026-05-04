`timescale 1ns/1ps
module present_serial_core(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [63:0] plaintext,
    input  wire [79:0] key_in,
    input  wire        use_pd2_sbox,
    output reg  [63:0] ciphertext,
    output reg         done
);
    reg [7:0]  delay_cnt;       // ← wider counter
    reg        delayed_start;
    reg        waiting;

    wire       core_done;
    wire [63:0] core_ct;

    present_iterative_core u_core (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (delayed_start),
        .plaintext   (plaintext),
        .key_in      (key_in),
        .use_pd2_sbox(use_pd2_sbox),
        .ciphertext  (core_ct),
        .done        (core_done)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delay_cnt     <= 8'd0;
            delayed_start <= 1'b0;
            waiting       <= 1'b0;
            done          <= 1'b0;
            ciphertext    <= 64'd0;
        end else begin
            delayed_start <= 1'b0;
            done          <= 1'b0;

            if (start && !waiting) begin
                delay_cnt <= 8'd0;
                waiting   <= 1'b1;
            end else if (waiting) begin
                if (delay_cnt < 8'd199) begin   // ← 200 cycle delay
                    delay_cnt <= delay_cnt + 8'd1;
                end else begin
                    delayed_start <= 1'b1;
                    waiting       <= 1'b0;
                    delay_cnt     <= 8'd0;
                end
            end

            if (core_done) begin
                ciphertext <= core_ct;
                done       <= 1'b1;
            end
        end
    end
endmodule
