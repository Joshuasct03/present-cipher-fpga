`timescale 1ns/1ps
module present_iterative_core(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [63:0] plaintext,
    input  wire [79:0] key_in,
    input  wire        use_pd2_sbox,
    output reg  [63:0] ciphertext,
    output reg         done
);
    reg [79:0] key_reg;
    reg [63:0] state_reg;
    reg [5:0]  round;
    reg        running;

    // round_key for current round = key_reg[79:16]
    wire [63:0] round_key = key_reg[79:16];
    wire [63:0] state_next;
    wire [79:0] key_next;

    present_round u_round (
        .state_in    (state_reg),
        .round_key   (round_key),
        .use_pd2_sbox(use_pd2_sbox),
        .last_round  (round == 6'd31),
        .state_out   (state_next)
    );

    key_schedule80 u_keysched (
        .key_in       (key_reg),
        .round_counter(round),
        .key_out      (key_next),
        .round_key    ()
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_reg    <= 80'd0;
            state_reg  <= 64'd0;
            round      <= 6'd0;
            running    <= 1'b0;
            done       <= 1'b0;
            ciphertext <= 64'd0;
        end else begin
            done <= 1'b0;

            if (start && !running) begin
                key_reg   <= key_in;          // K1 loaded
                state_reg <= plaintext ^ key_in[79:16]; // addRoundKey with K1
                round     <= 6'd1;
                running   <= 1'b1;
            end else if (running) begin
                // state_next = sbox(player(state_reg XOR round_key))
                // key_next   = KS(key_reg, round)
                if (round == 6'd31) begin
                    // Final: after sbox (no player), XOR with K32
                    ciphertext <= state_next ^ key_next[79:16];
                    done       <= 1'b1;
                    running    <= 1'b0;
                    round      <= 6'd0;
                end else begin
                    state_reg <= state_next;
                    key_reg   <= key_next;
                    round     <= round + 6'd1;
                end
            end
        end
    end
endmodule
