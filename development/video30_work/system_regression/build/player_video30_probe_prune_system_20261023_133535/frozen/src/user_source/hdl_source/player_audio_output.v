// WAV/tone source selection and HDMI PCM/ACR output.
module player_audio_output #(
    parameter integer PIXEL_HZ = 25000000,
    parameter integer SAMPLE_HZ = 48000,
    parameter integer PLAY_GATE = 0
)(
    input pixel_clk, sd_clk, rst, tone_toggle,
    input primed, sample_available,
    input play_enable,
    input [15:0] sample_data,
    output sample_take, underflow,
    output underflow_event,
    output audio_valid,
    output [23:0] audio_left, audio_right,
    output acr_valid,
    output [19:0] acr_cts, acr_n,
    output reg tone_mode
);
    wire wav_valid, tone_valid;
    wire [23:0] wav_left, wav_right, tone_left, tone_right;
    wav_pcm_bridge #(.PIXEL_HZ(PIXEL_HZ),.SAMPLE_HZ(SAMPLE_HZ),.PLAY_GATE(PLAY_GATE)) u_bridge (
        .pixel_clk(pixel_clk),.sd_clk(sd_clk),.rst(rst),
        .primed(primed),.sample_available(sample_available),.sample_data(sample_data),
        .play_enable(play_enable),
        .sample_take(sample_take),.audio_valid(wav_valid),
        .audio_left(wav_left),.audio_right(wav_right),.underflow(underflow),
        .underflow_event(underflow_event)
    );
    hdmi_audio_tone_pcm_scale #(.CLK_FREQ_HZ(PIXEL_HZ),
        .SAMPLE_RATE_HZ(SAMPLE_HZ),.AMP(24'sd1000000)) u_tone (
        .I_clk(pixel_clk),.I_rst(rst),.O_audio_valid(tone_valid),
        .O_audio_left_data(tone_left),.O_audio_right_data(tone_right)
    );
    assign audio_valid = tone_mode ? tone_valid : wav_valid;
    assign audio_left = tone_mode ? tone_left : wav_left;
    assign audio_right = tone_mode ? tone_right : wav_right;
    audio_arc_calculate #(.ACR_N(6144)) u_acr (
        .I_clk(pixel_clk),.I_rst(rst),.I_audio_valid(audio_valid),
        .O_acr_valid(acr_valid),.O_acr_cts(acr_cts),.O_acr_n(acr_n)
    );

    always @(posedge pixel_clk or posedge rst) begin
        if(rst) tone_mode <= 1'b0;
        else if(tone_toggle) tone_mode <= ~tone_mode;
    end
endmodule
