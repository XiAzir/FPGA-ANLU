`timescale 1ns/1ps
module tb_cadence;
    parameter integer FIXED_MAX_DELAY = 0;
    localparam integer FRAME_PERIOD = 4032;
    localparam integer SAMPLES_PER_FRAME = 3200;
    localparam integer SAMPLE_PERIOD = 5;
    localparam integer MAX_FRAME_BYTES = 43231;
    localparam integer MAX_DELAY_CYCLES = 12596; // ceil(52.48111 ms / 66.666... ms * 16000)

    reg clk=0;
    reg rst=1;
    reg catalog_ready=1, video_found=1, wav_primed=1;
    reg file_ready=1;
    reg reader_frame_sent=0, decoder_idle=1;
    reg write_finish_toggle=0, display_finish_toggle;
    reg sample_take=0;
    reg write_req_ack;
    reg read_req=0, read_req_ack=0;
    reg [8:0] source_count=0;
    reg source_auto=0, source_video=1;
    wire reader_start, reader_next, decoder_reset;
    wire write_req;
    wire [1:0] write_buffer, display_buffer;
    wire display_valid, audio_go;
    wire [3:0] state_code;
    wire [8:0] displayed_frame;
    wire frame_late;
    wire read_req_out, wipe_active;
    wire [8:0] wipe_rows;
    wire [1:0] wipe_new_buffer, frame_buffer, frame_image;
    wire [2:0] frame_count;
    wire frame_auto, frame_valid;
    wire osd_display_finish_toggle;
    integer frame_length[0:299];
    integer start_cycle[0:299];
    integer done_cycle[0:299];
    integer delay_cycle[0:299];
    integer deadline_cycle[0:300];
    integer cycle_count=0;
    integer frames_started=0;
    integer active_frame=-1;
    integer decode_age=0;
    integer current_delay=0;
    integer decode_busy=0;
    integer sample_div=0;
    integer sample_count=0;
    integer due_count=0;
    integer sample_audio_seen=0;
    integer due_in_decode=0;
    integer commits=0;
    integer last_valid=0;
    integer last_buffer=0;
    integer fd;
    integer i;
    reg [8:0] display_buffer_before;

    always #5 clk=~clk;
    assign write_req_ack=write_req;
    assign display_finish_toggle=osd_display_finish_toggle;

    player_video_schedule u_schedule(
        .clk(clk),.rst(rst),.enable(1'b1),
        .catalog_ready(catalog_ready),.video_found(video_found),.wav_primed(wav_primed),
        .file_ready(file_ready),.reader_frame_sent(reader_frame_sent),.decoder_idle(decoder_idle),
        .reader_start(reader_start),.reader_next(reader_next),.decoder_reset(decoder_reset),
        .write_finish_toggle(write_finish_toggle),.display_finish_toggle(display_finish_toggle),
        .sample_take(sample_take),.write_req(write_req),.write_req_ack(write_req_ack),
        .write_buffer(write_buffer),.display_buffer(display_buffer),
        .display_valid(display_valid),.audio_go(audio_go),.state_code(state_code),
        .displayed_frame(displayed_frame),.frame_late(frame_late)
    );

    // Same RTL mailbox, frame-edge selection, read-ACK synchronization and
    // release-toggle logic. The memory backend's request ACK is modeled as
    // arriving three abstract cycles after each frame-boundary read request.
    player_osd_state #(.FRAME_HEIGHT(480),.WIPE_STEP_ROWS(8)) u_osd(
        .sd_clk(clk),.pixel_clk(clk),.rst(rst),
        .source_buffer(display_buffer),.source_image(2'd0),.source_count(source_count),
        .source_auto(source_auto),.source_valid(display_valid),.source_video(source_video),
        .read_req(read_req),.read_req_ack(read_req_ack),.read_req_out(read_req_out),
        .frame_buffer(frame_buffer),.frame_image(frame_image),.frame_count(frame_count),
        .frame_auto(frame_auto),.frame_valid(frame_valid),
        .wipe_active(wipe_active),.wipe_rows(wipe_rows),.wipe_new_buffer(wipe_new_buffer),
        .display_finish_toggle(osd_display_finish_toggle)
    );

    initial begin
        $readmemh("frame_lengths.mem",frame_length);
        for(i=0;i<300;i=i+1) begin
            start_cycle[i]=-1;
            done_cycle[i]=-1;
            delay_cycle[i]=0;
        end
        for(i=0;i<=300;i=i+1) deadline_cycle[i]=-1;
        repeat(5) @(posedge clk);
        @(negedge clk); rst=0;
    end

    // Abstract common clock preserves the measured ratios exactly:
    // one frame refresh = 4032 ticks; one PCM sample = 5 ticks.
    always @(negedge clk) begin
        cycle_count=cycle_count+1;
        if(rst) begin
            read_req=0;read_req_ack=0;sample_take=0;sample_div=0;sample_audio_seen=0;
            reader_frame_sent=0;decoder_idle=1;decode_busy=0;active_frame=-1;decode_age=0;
        end else begin
            read_req=((cycle_count%FRAME_PERIOD)<4);
            read_req_ack=((cycle_count%FRAME_PERIOD)==3);
            if(!audio_go) begin
                sample_take=0;sample_div=0;sample_audio_seen=0;
            end else if(!sample_audio_seen) begin
                sample_audio_seen=1;sample_take=1;sample_div=1;
            end else if(sample_div==SAMPLE_PERIOD-1) begin
                sample_take=1;sample_div=0;
            end else begin
                sample_take=0;sample_div=sample_div+1;
            end

            reader_frame_sent=0;
            if(reader_next && !decode_busy && frames_started<300) begin
                active_frame=frames_started;
                frames_started=frames_started+1;
                start_cycle[active_frame]=cycle_count;
                decode_age=0;
                decode_busy=1;
                decoder_idle=0;
                if(active_frame==0) current_delay=8;
                else if(FIXED_MAX_DELAY) current_delay=MAX_DELAY_CYCLES;
                else current_delay=((MAX_DELAY_CYCLES*frame_length[active_frame])+MAX_FRAME_BYTES-1)/MAX_FRAME_BYTES;
                delay_cycle[active_frame]=current_delay;
            end else if(decode_busy) begin
                if(decode_age+1>=current_delay) begin
                    done_cycle[active_frame]=cycle_count;
                    decode_busy=0;
                    decoder_idle=1;
                    reader_frame_sent=1;
                    write_finish_toggle=~write_finish_toggle;
                end else decode_age=decode_age+1;
            end
        end
    end

    always @(posedge clk) begin
        if(!rst) begin
            if(audio_go && sample_take) begin
                if(sample_count==SAMPLES_PER_FRAME-1) begin
                    sample_count=0;
                    due_count=due_count+1;
                    deadline_cycle[due_count]=cycle_count;
                    if(state_code==4) due_in_decode=due_in_decode+1;
                    $display("DUE n=%0d cycle=%0d state=%0d current_frame=%0d",due_count,cycle_count,state_code,active_frame);
                end else sample_count=sample_count+1;
            end
            if(display_valid && (!last_valid || display_buffer!=last_buffer)) commits=commits+1;
            last_valid=display_valid;
            last_buffer=display_buffer;
            if(due_count>=300) begin
                repeat(16) @(posedge clk);
                if(FIXED_MAX_DELAY) fd=$fopen("fixed_max_deadlines.csv","w");
                else fd=$fopen("byte_scaled_deadlines.csv","w");
                $fdisplay(fd,"frame_index,jpeg_bytes,delay_cycles,start_cycle,deadline_cycle,budget_cycles,done_cycle,done_by_deadline");
                for(i=1;i<300;i=i+1) begin
                    if(start_cycle[i]>=0 && deadline_cycle[i]>=0) begin
                        $fdisplay(fd,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",i,frame_length[i],delay_cycle[i],start_cycle[i],deadline_cycle[i],deadline_cycle[i]-start_cycle[i],done_cycle[i],(done_cycle[i]>=0 && done_cycle[i]<=deadline_cycle[i]));
                    end else begin
                        $fdisplay(fd,"%0d,%0d,%0d,%0d,%0d,-1,%0d,0",i,frame_length[i],delay_cycle[i],start_cycle[i],deadline_cycle[i],done_cycle[i]);
                    end
                end
                $fclose(fd);
                $display("SUMMARY mode=%0d frames_started=%0d deadlines=%0d commits=%0d frame_late=%0d due_while_decode=%0d final_cycle=%0d",FIXED_MAX_DELAY,frames_started,due_count,commits,frame_late,due_in_decode,cycle_count);
                $finish;
            end
        end
    end

    initial begin
        repeat(6200000) @(posedge clk);
        $display("TIMEOUT mode=%0d frames_started=%0d deadlines=%0d state=%0d",FIXED_MAX_DELAY,frames_started,due_count,state_code);
        $finish;
    end
endmodule
