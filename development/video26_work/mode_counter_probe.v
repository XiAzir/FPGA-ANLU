module mode_counter_probe(input video_clk,rst_all_reg,video_mode_press,video_restart_toggle,
output reg video_mode,media_reset_active,output reg [3:0] video_mode_press_count);
reg [4:0] media_reset_count; reg [1:0] video_restart_sync; reg video_restart_seen;
always @(posedge video_clk or posedge rst_all_reg) begin
    if(rst_all_reg) begin
        video_mode<=0;media_reset_active<=0;media_reset_count<=0;
        video_mode_press_count<=0;
        video_restart_sync<=0;video_restart_seen<=0;
    end else begin
        video_restart_sync<={video_restart_sync[0],video_restart_toggle};
        if(video_mode_press) video_mode_press_count<=video_mode_press_count+1'b1;
        if(video_mode_press || video_restart_sync[1]!=video_restart_seen) begin
            if(video_mode_press) video_mode<=~video_mode;
            video_restart_seen<=video_restart_sync[1];
            media_reset_active<=1;media_reset_count<=31;
        end else if(media_reset_active) begin
            if(media_reset_count==0) media_reset_active<=0;
            else media_reset_count<=media_reset_count-1'b1;
        end
    end
end

endmodule
