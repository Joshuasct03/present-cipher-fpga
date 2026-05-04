`timescale 1ns/1ps
module tb_present;

    reg clk = 0;
    always #5 clk = ~clk;

    reg        rst_n;
    reg        start;
    reg        user_mode;
    reg [63:0] plaintext;
    reg [79:0] key;

    wire [63:0] ciphertext;
    wire        done;
    wire        bist_pass_led;

    present_top dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .start        (start),
        .user_mode    (user_mode),
        .plaintext    (plaintext),
        .key          (key),
        .ciphertext   (ciphertext),
        .done         (done),
        .bist_pass_led(bist_pass_led)
    );

    integer t_bist_done;
    integer t_par_start, t_par_done;
    integer t_ser_start, t_ser_done;

    initial begin
        rst_n     = 0;
        start     = 0;
        user_mode = 0;
        plaintext = 64'h0000000000000000;
        key       = 80'h00000000000000000000;

        #20 rst_n = 1;

        // Wait for BIST
        @(posedge bist_pass_led);
        t_bist_done = $time;
        $display("BIST PASSED at t = %0d ns", t_bist_done);
        #50;

        // Test 1: Parallel mode
        $display("--- Test 1: Parallel Mode ---");
        user_mode   = 0;
        #10 start   = 1;
        t_par_start = $time;
        #10 start   = 0;
        @(posedge done);
        t_par_done  = $time;
        $display("Parallel Start = %0d ns", t_par_start);
        $display("Parallel Done  = %0d ns", t_par_done);
        $display("Parallel Latency = %0d ns (%0d cycles)", 
                  t_par_done - t_par_start,
                 (t_par_done - t_par_start)/10);
        $display("Ciphertext = %h", ciphertext);
        if (ciphertext == 64'h267e4d76d77c94f4)
            $display("PASS: Parallel correct");
        else
            $display("FAIL: Got %h", ciphertext);

        // Test 2: Serial mode
        #100;
        $display("--- Test 2: Serial Mode ---");
        user_mode   = 1;
        #10 start   = 1;
        t_ser_start = $time;
        #10 start   = 0;
        @(posedge done);
        t_ser_done  = $time;
        $display("Serial Start   = %0d ns", t_ser_start);
        $display("Serial Done    = %0d ns", t_ser_done);
        $display("Serial Latency = %0d ns (%0d cycles)",
                  t_ser_done - t_ser_start,
                 (t_ser_done - t_ser_start)/10);
        $display("Ciphertext = %h", ciphertext);
        if (ciphertext == 64'h267e4d76d77c94f4)
            $display("PASS: Serial correct");
        else
            $display("FAIL: Got %h", ciphertext);

        $display("--- Simulation Complete ---");
        $display("Serial is %0dx slower than Parallel",
                 (t_ser_done - t_ser_start)/(t_par_done - t_par_start));
        $stop;
    end

    initial begin
        #500000;
        $display("TIMEOUT");
        $stop;
    end

endmodule
