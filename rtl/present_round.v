`timescale 1ns/1ps
module present_round(
    input  wire [63:0] state_in,
    input  wire [63:0] round_key,
    input  wire        use_pd2_sbox,
    input  wire        last_round,
    output wire [63:0] state_out
);
    wire [63:0] after_add = state_in ^ round_key;

    wire [63:0] sbox_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : SBOX_LAYER
            wire [3:0] in_nibble = after_add[i*4 +: 4];
            wire [3:0] out_std;
            wire [3:0] out_pd2;
            present_sbox     s_std (.in(in_nibble), .out(out_std));
            present_sbox_pd2 s_pd2 (.in(in_nibble), .out(out_pd2));
            assign sbox_out[i*4 +: 4] = use_pd2_sbox ? out_pd2 : out_std;
        end
    endgenerate

    wire [63:0] player_out;
    present_player u_player (.in(sbox_out), .out(player_out));

    assign state_out = last_round ? sbox_out : player_out;
endmodule
