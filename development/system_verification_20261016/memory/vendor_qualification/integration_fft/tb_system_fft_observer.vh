// Include inside tb_system after the top instance named `dut` and output declarations.
// The analyzer has been confirmed at dut.u_pcm_waveform.u_spectrum.
wire fft_capture_condition = (dut.u_pcm_waveform.u_spectrum.state == 5'd0) && dut.audio_valid;
wire fft_sample_accepted = dut.u_pcm_waveform.u_spectrum.sample_write_en;
wire fft_abort = dut.rst_all || dut.u_pcm_waveform.u_spectrum.fft_reset ||
                 dut.u_pcm_waveform.u_spectrum.source_change ||
                 dut.u_pcm_waveform.u_spectrum.timeout_pulse;
wire [31:0] fft_observed_accepted,fft_observed_frames,fft_observed_aborts;
fft_passive_observer u_fft_observer(
    .clk(dut.video_clk), .reset(dut.rst_all), .abort_frame(fft_abort),
    .capture_condition(fft_capture_condition), .accepted(fft_sample_accepted),
    .sample($signed(dut.audio_left_data[23:8])),
    .band_valid(dut.u_pcm_waveform.u_spectrum.band_valid),
    .band_index(dut.u_pcm_waveform.u_spectrum.band_index),
    .band_value(dut.u_pcm_waveform.u_spectrum.band_value),
    .frame_done(dut.u_pcm_waveform.u_spectrum.frame_done),
    .accepted_total(fft_observed_accepted), .completed_frames(fft_observed_frames),
    .aborted_captures(fft_observed_aborts));

// At the existing system PASS branch, before $finish, call:
//     u_fft_observer.finish_check;
