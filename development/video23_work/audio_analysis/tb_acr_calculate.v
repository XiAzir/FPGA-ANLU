`timescale 1ns/1ps
module tb_acr_calculate;
    reg clk=0, rst=1;
    reg audio_valid=0;
    wire acr_valid;
    wire [19:0] acr_cts, acr_n;
    integer cyc=0, audio_count=0, update_count=0;
    integer last_update=-1, delta;
    integer bad=0, min_cts=2000000, max_cts=0, last_update_audio=-1;
    reg [31:0] sample_acc=0;
    reg [31:0] acc_sum;
    audio_arc_calculate #(.ACR_N(6144)) dut(
      .I_clk(clk), .I_rst(rst), .I_audio_valid(audio_valid),
      .O_acr_valid(acr_valid), .O_acr_cts(acr_cts), .O_acr_n(acr_n));
    always #20 clk=~clk;
    always @(posedge clk) begin
      cyc=cyc+1;
      if (rst) begin
        sample_acc=0;
        audio_valid=0;
      end else begin
        acc_sum=sample_acc+48000;
        if(acc_sum>=25000000) begin
          sample_acc=acc_sum-25000000;
          audio_valid=1;
          audio_count=audio_count+1;
        end else begin
          sample_acc=acc_sum;
          audio_valid=0;
        end
      end
      #1;
      if(!rst && acr_valid===1'b1) begin
        update_count=update_count+1;
        if(acr_cts<min_cts) min_cts=acr_cts;
        if(acr_cts>max_cts) max_cts=acr_cts;
        if(acr_n!==20'd6144) begin
          $display("FAIL N=%0d at cycle=%0d",acr_n,cyc); bad=bad+1;
        end
        if(update_count>1) begin
          if(acr_cts!==20'd25000 && acr_cts!==20'd25001) begin
            $display("FAIL CTS=%0d at cycle=%0d",acr_cts,cyc); bad=bad+1;
          end
          if(audio_count-last_update_audio!=48) begin
            $display("FAIL update sample interval=%0d",audio_count-last_update_audio); bad=bad+1;
          end
          delta=cyc-last_update;
          if(delta!=25000 && delta!=25001) begin
            $display("FAIL update interval=%0d clocks",delta); bad=bad+1;
          end
        end
        last_update=cyc; last_update_audio=audio_count;
      end
      if(cyc==1500100) begin
        if(update_count<50 || audio_count<2800) begin
          $display("FAIL insufficient coverage updates=%0d samples=%0d",update_count,audio_count); bad=bad+1;
        end
        if(bad==0) $display("ACR_TEST_PASS cycles=%0d audio_samples=%0d updates=%0d cts_min=%0d cts_max=%0d N=%0d",cyc,audio_count,update_count,min_cts,max_cts,acr_n);
        else $display("ACR_TEST_FAIL bad=%0d samples=%0d updates=%0d",bad,audio_count,update_count);
        $finish;
      end
    end
    initial begin
      repeat(4) @(posedge clk);
      #2 rst=0;
    end
endmodule

