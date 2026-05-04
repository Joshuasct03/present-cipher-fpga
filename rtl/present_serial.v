`timescale 1ns/1ps
module present_serial(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [63:0] plaintext,
    input  wire [79:0] key_in,
    input  wire        use_pd2_sbox,
    output wire [63:0] ciphertext,
    output wire        done
);
    present_serial_core u_serial_core (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start),
        .plaintext   (plaintext),
        .key_in      (key_in),
        .use_pd2_sbox(use_pd2_sbox),
        .ciphertext  (ciphertext),
        .done        (done)
    );
endmodule
