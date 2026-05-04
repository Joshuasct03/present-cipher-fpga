`timescale 1ns/1ps
module present_top(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        user_mode,
    input  wire [63:0] plaintext,
    input  wire [79:0] key,
    output wire [63:0] ciphertext,
    output wire        done,
    output wire        bist_pass_led
);
    wire bist_running, bist_done, bist_pass;
    wire active_mode;
    reg  start_bist_pulse;
    reg  start_parallel, start_serial;

    wire [63:0] ct_parallel, ct_serial;
    wire        done_parallel, done_serial;
    wire        use_pd2_sbox = 1'b0;

    present_parallel u_parallel (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start_parallel),
        .plaintext   (plaintext),
        .key_in      (key),
        .use_pd2_sbox(use_pd2_sbox),
        .ciphertext  (ct_parallel),
        .done        (done_parallel)
    );

    present_serial u_serial (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start_serial),
        .plaintext   (plaintext),
        .key_in      (key),
        .use_pd2_sbox(use_pd2_sbox),
        .ciphertext  (ct_serial),
        .done        (done_serial)
    );

    bist_controller u_bist (
        .clk         (clk),
        .rst_n       (rst_n),
        .start_bist  (start_bist_pulse),
        .bist_running(bist_running),
        .bist_pass   (bist_pass),
        .bist_done   (bist_done)
    );

    mode_controller u_mode (
        .bist_done       (bist_done),
        .bist_pass       (bist_pass),
        .user_mode_select(user_mode),
        .active_mode     (active_mode)
    );

    assign bist_pass_led = bist_pass;

    reg [1:0] ctrl_state;
    localparam CTL_IDLE  = 2'd0;
    localparam CTL_BIST  = 2'd1;
    localparam CTL_READY = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_state       <= CTL_IDLE;
            start_bist_pulse <= 1'b0;
            start_parallel   <= 1'b0;
            start_serial     <= 1'b0;
        end else begin
            start_bist_pulse <= 1'b0;
            start_parallel   <= 1'b0;
            start_serial     <= 1'b0;
            case (ctrl_state)
                CTL_IDLE: begin
                    start_bist_pulse <= 1'b1;
                    ctrl_state       <= CTL_BIST;
                end
                CTL_BIST: begin
                    if (bist_done) ctrl_state <= CTL_READY;
                end
                CTL_READY: begin
                    if (start) begin
                        if (active_mode == 1'b0)
                            start_parallel <= 1'b1;
                        else
                            start_serial   <= 1'b1;
                    end
                end
                default: ctrl_state <= CTL_IDLE;
            endcase
        end
    end

    assign ciphertext = (active_mode == 1'b0) ? ct_parallel : ct_serial;
    assign done       = (active_mode == 1'b0) ? done_parallel : done_serial;

endmodule
