`timescale 1ns/1ps
module tb_audio_sd_observer;
    reg sd_card_clk=0;
    always #5 sd_card_clk=~sd_card_clk;
    reg rst_all=1;
    reg wav_card_read=0,wav_card_valid=0,wav_sample_take=0;
    reg [12:0] wav_fifo_level=13'd2048;
    wire [23:0] wav_first_wait_cycles,wav_max_first_wait_cycles;
    wire wav_first_wait_active,wav_read_previous,diag_wav_started;
    wire [11:0] wav_fifo_lowwater;
    audio_sd_observer dut (
        .sd_card_clk(sd_card_clk),.rst_all(rst_all),.wav_card_read(wav_card_read),
        .wav_card_valid(wav_card_valid),.wav_sample_take(wav_sample_take),
        .wav_fifo_level(wav_fifo_level),.wav_first_wait_cycles(wav_first_wait_cycles),
        .wav_max_first_wait_cycles(wav_max_first_wait_cycles),
        .wav_first_wait_active(wav_first_wait_active),.wav_read_previous(wav_read_previous),
        .diag_wav_started(diag_wav_started),.wav_fifo_lowwater(wav_fifo_lowwater)
    );
    task tick; begin @(posedge sd_card_clk); #1; end endtask
    task check_wait(input [23:0] current,input [23:0] maximum,input active,input [255:0] label_text);
        begin
            if(wav_first_wait_cycles!==current || wav_max_first_wait_cycles!==maximum || wav_first_wait_active!==active) begin
                $display("FAIL wait %0s current=%0d/%0d max=%0d/%0d active=%b/%b",label_text,
                    wav_first_wait_cycles,current,wav_max_first_wait_cycles,maximum,wav_first_wait_active,active);
                $fatal(1);
            end
        end
    endtask
    task check_fifo(input [11:0] minimum,input started,input [255:0] label_text);
        begin
            if(wav_fifo_lowwater!==minimum || diag_wav_started!==started) begin
                $display("FAIL FIFO %0s low=%0d/%0d started=%b/%b",label_text,wav_fifo_lowwater,minimum,diag_wav_started,started);
                $fatal(1);
            end
        end
    endtask
    initial begin
        tick(); rst_all=0; tick();
        check_wait(0,0,0,"reset"); check_fifo(2048,0,"reset baseline");

        // Low levels before the first consumed sample must not affect the metric.
        wav_fifo_level=100; repeat(3) tick();
        check_fifo(2048,0,"pre-take levels ignored");
        wav_sample_take=1; tick(); wav_sample_take=0;
        check_fifo(2048,1,"take arms observation");
        wav_fifo_level=1200; tick(); check_fifo(1200,1,"first post-take level");
        wav_fifo_level=400; tick(); check_fifo(400,1,"new low watermark");
        wav_fifo_level=1500; tick(); check_fifo(400,1,"higher level preserves minimum");

        // First read: rising edge, two no-valid clocks, then one valid.
        wav_card_read=1; tick(); check_wait(0,0,1,"request rising");
        repeat(2) tick(); check_wait(2,0,1,"delayed first valid");
        wav_card_valid=1; tick(); wav_card_valid=0;
        check_wait(2,2,0,"first valid records interval");
        // Valid pulses during one sustained read must not re-arm or overwrite.
        repeat(3) tick(); wav_card_valid=1; tick(); wav_card_valid=0;
        check_wait(2,2,0,"sustained request counts once");

        // A shorter later wait cannot overwrite the historical maximum.
        wav_card_read=0; tick(); wav_card_read=1; tick();
        tick(); wav_card_valid=1; tick(); wav_card_valid=0;
        check_wait(1,2,0,"short request preserves max");

        // A longer later delay replaces the maximum exactly once.
        wav_card_read=0; tick(); wav_card_read=1; tick();
        repeat(4) tick(); wav_card_valid=1; tick(); wav_card_valid=0;
        check_wait(4,4,0,"long request updates max");

        // Mid-request reset clears active wait and FIFO history.
        wav_card_read=0; tick(); wav_card_read=1; tick(); repeat(2) tick();
        rst_all=1; #1;
        check_wait(0,0,0,"asynchronous reset clears wait history");
        check_fifo(2048,0,"asynchronous reset clears FIFO history");
        tick(); rst_all=0; tick();
        $display("PASS SD observers: read-to-first-valid max, no repeat overwrite, take-gated FIFO minimum, reset");
        $finish;
    end
endmodule
