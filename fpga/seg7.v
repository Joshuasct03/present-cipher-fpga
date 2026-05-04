`timescale 1ns/1ps
module seg7(
    input  [3:0] hex,
    output reg [6:0] seg
);
always @(*) begin
    case(hex)
        4'h0: seg = 7'b1111110;
        4'h1: seg = 7'b0110000;
        4'h2: seg = 7'b1101101;
        4'h3: seg = 7'b1111001;
        4'h4: seg = 7'b0110011;
        4'h5: seg = 7'b1011011;
        4'h6: seg = 7'b1011111;
        4'h7: seg = 7'b1110000;
        4'h8: seg = 7'b1111111;
        4'h9: seg = 7'b1111011;
        4'ha: seg = 7'b1110111;
        4'hb: seg = 7'b0011111;
        4'hc: seg = 7'b1001110;
        4'hd: seg = 7'b0111101;
        4'he: seg = 7'b1001111;
        4'hf: seg = 7'b1000111;
    endcase
end
endmodule
