`timescale 1ns/1ps
// Passive full-top observer. This module never drives the DUT or forces state.
module fft_passive_observer #(
    parameter SAMPLE_CSV = "fft_samples.csv",
    parameter BAND_CSV = "fft_bands.csv"
)(
    input wire clk,
    input wire reset,
    input wire abort_frame,
    input wire capture_condition, // state==ST_CAPTURE && audio_valid
    input wire accepted,          // exact analyzer sample_write_en
    input wire signed [15:0] sample,
    input wire band_valid,
    input wire [4:0] band_index,
    input wire [15:0] band_value,
    input wire frame_done,
    output reg [31:0] accepted_total,
    output reg [31:0] completed_frames,
    output reg [31:0] aborted_captures
);
    integer sample_fd, band_fd;
    integer sample_count, band_count, current_frame, n;
    reg started, was_in_reset;
    reg signed [15:0] sample_buffer [0:1023];
    realtime sample_time_ns [0:1023];

    initial begin
        accepted_total=0; completed_frames=0; aborted_captures=0;
        sample_count=0; band_count=0; current_frame=0;
        started=0; was_in_reset=0;
        sample_fd=$fopen(SAMPLE_CSV,"w");
        if(sample_fd==0) begin $display("FFT_OBSERVER FATAL cannot open %0s",SAMPLE_CSV); $fatal(1); end
        band_fd=$fopen(BAND_CSV,"w");
        if(band_fd==0) begin $display("FFT_OBSERVER FATAL cannot open %0s",BAND_CSV); $fatal(1); end
        $fdisplay(sample_fd,"frame,sample_index,pcm_signed,time_ns");
        $fdisplay(band_fd,"frame,band_index,band_value,frame_done,time_ns");
    end

    always @(posedge clk) begin
        if(reset===1'b1) begin
            if(started) begin $display("FFT_OBSERVER FATAL reset after observation started"); $fatal(1); end
            was_in_reset=1;
            sample_count=0; band_count=0; current_frame=0;
        end else begin
            started=1;
            if(reset!==1'b0 || abort_frame===1'bx || accepted===1'bx ||
               capture_condition===1'bx || band_valid===1'bx || frame_done===1'bx) begin
                $display("FFT_OBSERVER FATAL unknown control reset=%b abort=%b accept=%b capture=%b band_valid=%b frame_done=%b",
                    reset,abort_frame,accepted,capture_condition,band_valid,frame_done);
                $fatal(1);
            end
            if(accepted && !capture_condition) begin
                $display("FFT_OBSERVER FATAL sample_write_en outside ST_CAPTURE && audio_valid t=%0t",$time);
                $fatal(1);
            end
            if(abort_frame) begin
                if(sample_count!=0 || band_count!=0) aborted_captures=aborted_captures+1;
                sample_count=0; band_count=0;
            end else begin
                if(band_valid) begin
                    if((^band_index)===1'bx || (^band_value)===1'bx) begin
                        $display("FFT_OBSERVER FATAL unknown band output t=%0t index=%b value=%b",$time,band_index,band_value);
                        $fatal(1);
                    end
                    if(band_index!==band_count[4:0]) begin
                        $display("FFT_OBSERVER FATAL band order frame=%0d observed=%0d expected=%0d",
                            current_frame,band_index,band_count); $fatal(1);
                    end
                    if(frame_done !== (band_index==5'd23)) begin
                        $display("FFT_OBSERVER FATAL frame_done alignment frame=%0d band=%0d done=%b",
                            current_frame,band_index,frame_done); $fatal(1);
                    end
                    $fdisplay(band_fd,"%0d,%0d,%0d,%0d,%0t",current_frame,band_index,band_value,frame_done,$realtime);
                    band_count=band_count+1;
                    if(frame_done) begin
                        if(sample_count!=1024 || band_count!=24) begin
                            $display("FFT_OBSERVER FATAL incomplete frame=%0d samples=%0d bands=%0d",
                                current_frame,sample_count,band_count); $fatal(1);
                        end
                        for(n=0;n<1024;n=n+1)
                            $fdisplay(sample_fd,"%0d,%0d,%0d,%0.3f",current_frame,n,$signed(sample_buffer[n]),sample_time_ns[n]);
                        completed_frames=completed_frames+1;
                        current_frame=current_frame+1;
                        sample_count=0; band_count=0;
                    end
                end else if(frame_done) begin
                    $display("FFT_OBSERVER FATAL frame_done without band_valid frame=%0d",current_frame); $fatal(1);
                end
                if(accepted) begin
                    if((^sample)===1'bx) begin $display("FFT_OBSERVER FATAL unknown accepted PCM t=%0t",$time); $fatal(1); end
                    if(sample_count>=1024) begin $display("FFT_OBSERVER FATAL over-accepted frame=%0d",current_frame); $fatal(1); end
                    sample_buffer[sample_count]=sample;
                    sample_time_ns[sample_count]=$realtime;
                    sample_count=sample_count+1;
                    accepted_total=accepted_total+1;
                end
            end
        end
    end

    task finish_check;
        begin
            if(completed_frames==0) begin $display("FFT_OBSERVER FATAL zero completed frames"); $fatal(1); end
            if(sample_count!=0 || band_count!=0) begin
                $display("FFT_OBSERVER FATAL partial tail samples=%0d bands=%0d",sample_count,band_count); $fatal(1);
            end
            $fclose(sample_fd); $fclose(band_fd);
            $display("FFT_OBSERVER_DONE frames=%0d accepted=%0d aborted=%0d",completed_frames,accepted_total,aborted_captures);
        end
    endtask
endmodule
