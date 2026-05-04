`timescale 1ns/1ps
module mode_controller(
    input  wire bist_done,
    input  wire bist_pass,
    input  wire user_mode_select,
    output reg  active_mode
);
    always @(*) begin
        if (!bist_done)
            active_mode = 1'b1;
        else begin
            if (!bist_pass)
                active_mode = 1'b1;
            else
                active_mode = user_mode_select;
        end
    end
endmodule
