// Passive atomic evidence. This module drives only diagnostic display inputs.
module player_fault_snapshot #(
    parameter integer FFT_WAIT_SAMPLES=4096
)(
    input clk,rst,tone_mode,audio_valid,axis_valid,axis_user,hdmi_locked,
    input [23:0] progress,accepted,events,frames,
    input [7:0] control,
    output reg snapshot_valid,
    output reg [27:0] snapshot_header,
    output reg [23:0] snapshot_prev_progress,snapshot_progress,
    output reg [23:0] snapshot_prev_accepted,snapshot_accepted,
    output reg [23:0] snapshot_frames,snapshot_events
);
    // control: 7 local reset, 6 source change, 5 timeout, 4 capture write,
    //          3 frame done, 2 band valid, 1 Hann seen, 0 twiddle seen.
    localparam integer AGE_W=(FFT_WAIT_SAMPLES<2)?1:$clog2(FFT_WAIT_SAMPLES+1);
    reg [AGE_W-1:0] audio_age;
    reg [1:0] sof_count;
    reg prev_user,prev_tone,prev_valid;
    reg [23:0] prev_progress,prev_accepted;
    reg [7:0] prev_control;
    wire sof=axis_valid && axis_user && !prev_user;
    wire [23:0] expected_accepted=(prev_accepted==24'hffffff)?prev_accepted:prev_accepted+24'd1;
    wire [9:0] expected_count=prev_progress[18:9]+10'd1;
    wire capture_mismatch=prev_valid && prev_control[4] &&
        !(|prev_control[7:5]) && !(|control[7:5]) &&
        ((accepted!=expected_accepted)||(progress[18:9]!=expected_count));
    wire video_deadline=sof && sof_count==3;
    wire fft_deadline=audio_valid && !control[3] && audio_age==FFT_WAIT_SAMPLES-1;
    wire sealed=snapshot_valid && snapshot_header[27:24]!=4'd1;
    reg [3:0] reason;
    always @* begin
        reason=0;
        if(capture_mismatch) reason=4;
        else if(video_deadline && !hdmi_locked) reason=2;
        else if(fft_deadline) reason=3;
        else if(video_deadline && hdmi_locked && frames!=0 && !snapshot_valid) reason=1;
    end
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            audio_age<=0;sof_count<=0;prev_user<=0;prev_tone<=0;prev_valid<=0;
            prev_progress<=0;prev_accepted<=0;prev_control<=0;
            snapshot_valid<=0;snapshot_header<=0;
            snapshot_prev_progress<=0;snapshot_progress<=0;
            snapshot_prev_accepted<=0;snapshot_accepted<=0;
            snapshot_frames<=0;snapshot_events<=0;
        end else begin
            prev_user<=axis_valid && axis_user;prev_tone<=tone_mode;
            prev_progress<=progress;prev_accepted<=accepted;prev_control<=control;
            if(tone_mode!=prev_tone)begin
                audio_age<=0;sof_count<=0;prev_valid<=0;
                snapshot_valid<=0;snapshot_header<=0;
                snapshot_prev_progress<=0;snapshot_progress<=0;
                snapshot_prev_accepted<=0;snapshot_accepted<=0;
                snapshot_frames<=0;snapshot_events<=0;
            end else begin
                prev_valid<=1;
                if(sof && sof_count!=3)sof_count<=sof_count+1'b1;
                if(control[3])audio_age<=0;
                else if(audio_valid && audio_age<FFT_WAIT_SAMPLES)audio_age<=audio_age+1'b1;
                if(!sealed && reason!=0)begin
                    snapshot_valid<=1;
                    snapshot_header<={reason,tone_mode,hdmi_locked,audio_valid,(frames!=0),prev_control,control,4'd0};
                    snapshot_prev_progress<=prev_progress;snapshot_progress<=progress;
                    snapshot_prev_accepted<=prev_accepted;snapshot_accepted<=accepted;
                    snapshot_frames<=frames;snapshot_events<=events;
                end
            end
        end
    end
endmodule
