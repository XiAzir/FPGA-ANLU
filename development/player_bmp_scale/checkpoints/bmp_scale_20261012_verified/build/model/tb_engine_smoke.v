`timescale 1ns/1ps
module tb_engine_smoke;
reg clk=0, rst=1, start=0;
always #10 clk=~clk;
reg [15:0] source_width=5, source_height=2;
reg source_top_down=0;
reg [31:0] pixel_offset=510, file_size=542;
wire card_read;
wire [31:0] card_addr;
reg [7:0] card_data=0;
reg card_valid=0, card_end=0, file_error=0;
reg [31:0] cycle_count=0;
wire pixel_ready=(cycle_count%13>=4);
wire pixel_valid;
wire [23:0] pixel_rgb;
wire done, error;
reg [7:0] sectors [0:1023];
reg feeding=0, end_sent=0;
reg [9:0] feed_pos=0;
reg [31:0] active_sector=0;
integer request_count=0, received=0, row_build_count=0;
reg was_stalled=0;
reg [23:0] held_rgb=0;
integer i, x, y, sx;
reg [23:0] expected;

bmp_scale_engine #(.FRAME_WIDTH(8),.FRAME_HEIGHT(6),.PIXEL_INTERVAL(10)) dut(
    .clk(clk),.rst(rst),.start(start),.source_width(source_width),
    .source_height(source_height),.source_top_down(source_top_down),
    .pixel_offset(pixel_offset),.file_size(file_size),.pixel_ready(pixel_ready),
    .card_read(card_read),.card_addr(card_addr),.card_data(card_data),
    .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
    .pixel_valid(pixel_valid),.pixel_rgb(pixel_rgb),.done(done),.error(error));

function [23:0] expected_pixel;
    input integer index;
    integer px, py, source_x;
    begin
        px=index%8; py=index/8; source_x=(px*5)/8;
        if (py<2 || py>=5) expected_pixel=24'h000000;
        else if (py==2) expected_pixel={(8'h10+source_x),8'h00,8'h00};
        else expected_pixel={8'h00,8'h00,(8'h20+source_x)};
    end
endfunction

initial begin
    for(i=0;i<1024;i=i+1) sectors[i]=0;
    // pixel_offset=510. Two padded 5-pixel BGR rows, stride=16.
    for(i=0;i<5;i=i+1) begin
        sectors[510+i*3+0]=0; sectors[510+i*3+1]=0; sectors[510+i*3+2]=8'h10+i;
        sectors[526+i*3+0]=8'h20+i; sectors[526+i*3+1]=0; sectors[526+i*3+2]=0;
    end
    repeat(5) @(posedge clk); rst<=0;
    repeat(2) @(posedge clk); start<=1;
    @(posedge clk); start<=0;
    repeat(200000) begin
        @(posedge clk);
        if(done) begin
            if(error) $fatal(1,"engine reported error");
            if(received!=48) $fatal(1,"received %0d pixels, expected 48",received);
            if(row_build_count!=2) $fatal(1,"built %0d source rows, expected 2 (row reuse failed)",row_build_count);
            if(request_count!=2) $fatal(1,"requested %0d sectors, expected 2",request_count);
            $display("PASS pixels=%0d source_rows_built=%0d sectors=%0d bottom_offset=2 backpressure=exercised",received,row_build_count,request_count);
            $finish;
        end
        if(error) $fatal(1,"engine error before done");
    end
    $fatal(1,"timeout; pixels=%0d rows=%0d sectors=%0d",received,row_build_count,request_count);
end

always @(posedge clk) begin
    cycle_count<=cycle_count+1;
    if(rst) begin card_valid<=0; card_end<=0; feeding<=0; end_sent<=0; end
    else begin
        card_valid<=0; card_end<=0;
        if(!card_read) begin feeding<=0; end_sent<=0; end
        else if(!feeding && !end_sent) begin
            feeding<=1; feed_pos<=0; active_sector<=card_addr;
            request_count<=request_count+1;
        end else if(feeding) begin
            if(feed_pos<512) begin
                card_valid<=1;
                if(active_sector==0) card_data<=sectors[feed_pos];
                else if(active_sector==1) card_data<=sectors[512+feed_pos];
                else card_data<=0;
                feed_pos<=feed_pos+1'b1;
            end else begin card_end<=1; feeding<=0; end_sent<=1; end
        end
    end
    if(!rst && dut.state==12) begin
        row_build_count<=row_build_count+1;
    end
    if(!rst && pixel_valid && pixel_ready) begin
        expected=expected_pixel(received);
        if(pixel_rgb!==expected)
            $fatal(1,"pixel %0d (%0d,%0d) got %06x expected %06x",received,received%8,received/8,pixel_rgb,expected);
        received<=received+1;
    end
    if(!rst && was_stalled && (!pixel_valid || pixel_rgb!==held_rgb))
        $fatal(1,"valid/data changed while ready was low");
    was_stalled<=(!rst && pixel_valid && !pixel_ready);
    if(pixel_valid && !pixel_ready) held_rgb<=pixel_rgb;
end
endmodule
