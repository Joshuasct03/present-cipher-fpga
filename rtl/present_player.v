`timescale 1ns/1ps
module present_player(
    input  [63:0] in,
    output reg [63:0] out
);
    always @(*) begin
        out[0]  = in[0];  out[1]  = in[16]; out[2]  = in[32]; out[3]  = in[48];
        out[4]  = in[1];  out[5]  = in[17]; out[6]  = in[33]; out[7]  = in[49];
        out[8]  = in[2];  out[9]  = in[18]; out[10] = in[34]; out[11] = in[50];
        out[12] = in[3];  out[13] = in[19]; out[14] = in[35]; out[15] = in[51];
        out[16] = in[4];  out[17] = in[20]; out[18] = in[36]; out[19] = in[52];
        out[20] = in[5];  out[21] = in[21]; out[22] = in[37]; out[23] = in[53];
        out[24] = in[6];  out[25] = in[22]; out[26] = in[38]; out[27] = in[54];
        out[28] = in[7];  out[29] = in[23]; out[30] = in[39]; out[31] = in[55];
        out[32] = in[8];  out[33] = in[24]; out[34] = in[40]; out[35] = in[56];
        out[36] = in[9];  out[37] = in[25]; out[38] = in[41]; out[39] = in[57];
        out[40] = in[10]; out[41] = in[26]; out[42] = in[42]; out[43] = in[58];
        out[44] = in[11]; out[45] = in[27]; out[46] = in[43]; out[47] = in[59];
        out[48] = in[12]; out[49] = in[28]; out[50] = in[44]; out[51] = in[60];
        out[52] = in[13]; out[53] = in[29]; out[54] = in[45]; out[55] = in[61];
        out[56] = in[14]; out[57] = in[30]; out[58] = in[46]; out[59] = in[62];
        out[60] = in[15]; out[61] = in[31]; out[62] = in[47]; out[63] = in[63];
    end
endmodule
