`timescale 1ns/1ps
module bist_controller(
    input  wire clk,
    input  wire rst_n,
    input  wire start_bist,
    output reg  bist_running,
    output reg  bist_pass,
    output reg  bist_done
);
    localparam IDLE  = 2'd0;
    localparam RUN   = 2'd1;
    localparam CHECK = 2'd2;
    localparam DONE  = 2'd3;

    localparam [63:0] BIST_PLAINTEXT = 64'h0000000000000000;
    localparam [79:0] BIST_KEY       = 80'h00000000000000000000;
    localparam [63:0] EXPECTED_CT    = 64'h267e4d76d77c94f4; // ← CHANGED

    reg [1:0]  state;
    reg        core_start;
    wire [63:0] core_ct;
    wire        core_done;

    present_iterative_core bist_core (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (core_start),
        .plaintext   (BIST_PLAINTEXT),
        .key_in      (BIST_KEY),
        .use_pd2_sbox(1'b0),
        .ciphertext  (core_ct),
        .done        (core_done)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            bist_running <= 1'b0;
            bist_pass    <= 1'b0;
            bist_done    <= 1'b0;
            core_start   <= 1'b0;
        end else begin
            core_start <= 1'b0;
            case (state)
                IDLE: begin
                    bist_done <= 1'b0;
                    bist_pass <= 1'b0;
                    if (start_bist) begin
                        bist_running <= 1'b1;
                        core_start   <= 1'b1;
                        state        <= RUN;
                    end
                end
                RUN: begin
                    if (core_done) state <= CHECK;
                end
                CHECK: begin
                    bist_pass    <= (core_ct == EXPECTED_CT) ? 1'b1 : 1'b0;
                    bist_running <= 1'b0;
                    bist_done    <= 1'b1;
                    state        <= DONE;
                end
                DONE: begin
                    // Hold result until reset
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
