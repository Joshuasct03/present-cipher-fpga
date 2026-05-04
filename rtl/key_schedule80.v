`timescale 1ns/1ps
module key_schedule80(
    input  wire [79:0] key_in,
    input  wire [5:0]  round_counter,
    output wire [79:0] key_out,
    output wire [63:0] round_key
);
    // Step 1: Rotate left by 61 (equivalent to rotate right by 19)
    wire [79:0] rotated = {key_in[18:0], key_in[79:19]};

    // Step 2: S-box on top 4 bits [79:76]
    wire [3:0] sbox_in  = rotated[79:76];
    wire [3:0] sbox_out;
    present_sbox sbox_inst(.in(sbox_in), .out(sbox_out));

    wire [79:0] after_sbox = {sbox_out, rotated[75:0]};

    // Step 3: XOR round counter into bits [19:15]
    // PRESENT spec: K[19:15] ^= round_counter (bits 19 down to 15 from LSB side)
    assign key_out = {
        after_sbox[79:20],
        after_sbox[19:15] ^ round_counter[4:0],
        after_sbox[14:0]
    };

    // Round key = top 64 bits of CURRENT (input) key
    assign round_key = key_in[79:16];
endmodule
