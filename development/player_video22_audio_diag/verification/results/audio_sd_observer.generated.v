`timescale 1ns/1ps
module audio_sd_observer(
 input wire sd_card_clk,input wire rst_all,input wire wav_card_read,input wire wav_card_valid,
 input wire wav_sample_take,input wire [12:0] wav_fifo_level,
 output reg [23:0] wav_first_wait_cycles,output reg [23:0] wav_max_first_wait_cycles,
 output reg wav_first_wait_active,output reg wav_read_previous,output reg diag_wav_started,
 output reg [11:0] wav_fifo_lowwater
);
always @(posedge sd_card_clk or posedge rst_all) begin
    if(rst_all) begin
        wav_first_wait_cycles<=0;wav_max_first_wait_cycles<=0;
        wav_first_wait_active<=0;wav_read_previous<=0;
        diag_wav_started<=0;wav_fifo_lowwater<=2048;
    end else begin
        wav_read_previous<=wav_card_read;
        if(wav_sample_take) diag_wav_started<=1;
        if(diag_wav_started && wav_fifo_level<wav_fifo_lowwater)
            wav_fifo_lowwater<=wav_fifo_level[11:0];
        if(wav_card_read && !wav_read_previous) begin
            wav_first_wait_active<=1;wav_first_wait_cycles<=0;
        end else if(wav_first_wait_active) begin
            if(wav_card_valid) begin
                wav_first_wait_active<=0;
                if(wav_first_wait_cycles>wav_max_first_wait_cycles)
                    wav_max_first_wait_cycles<=wav_first_wait_cycles;
            end else wav_first_wait_cycles<=wav_first_wait_cycles+1'b1;
        end
    end
end
endmodule