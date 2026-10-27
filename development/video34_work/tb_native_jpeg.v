`timescale 1ns/1ps
module jpeg_fixture_source #(parameter LENGTH=1, parameter GAP=11) (
    input clk,rst,input accept,
    output valid,output reg [31:0] data,output reg [3:0] strb,output last,
    output done
);
    reg [7:0] bytes [0:LENGTH-1];
    integer word_index=0, cycle=0, i;
    localparam WORDS=(LENGTH+3)/4;
    initial $readmemh("development/video34_work/native/fixture.hex",bytes);
    assign valid=!rst && word_index<=WORDS && cycle%GAP!=0;
    assign last=word_index==WORDS;
    assign done=word_index>WORDS;
    always @* begin
        data=0;strb=0;
        for(i=0;i<4;i=i+1) if(word_index*4+i<LENGTH) begin
            data[i*8+:8]=bytes[word_index*4+i];strb[i]=1;
        end
    end
    always @(posedge clk) begin
        if(rst) begin word_index<=0;cycle<=0;end
        else begin
            cycle<=cycle+1;
            if(valid && accept) word_index<=word_index+1;
        end
    end
endmodule

module tb_native_jpeg;
    parameter LENGTH=1;
    reg clk=0,rst=1;
    always #5 clk=~clk;
    integer cycle=0;
    wire v0,v1,v2,a0,a1,a2,l0,l1,l2,d0,d1,d2;
    wire [31:0] in0,in1,in2;
    wire [3:0] s0,s1,s2;
    wire rgb0,rgb1,idle0,idle1,idle2,nvalid;
    wire [15:0] x0,y0,x1,y1;
    wire [23:0] color0,color1;
    wire [31:0] nsample,nid;
    wire [5:0] nindex;
    wire block_space, word_valid;
    wire [20:0] word_address;
    wire [31:0] word_data;
    wire word_ready = cycle%97>=31;
    jpeg_fixture_source #(LENGTH,11) source0(clk,rst,a0,v0,in0,s0,l0,d0);
    jpeg_fixture_source #(LENGTH,17) source1(clk,rst,a1,v1,in1,s1,l1,d1);
    jpeg_fixture_source #(LENGTH,7) source2(clk,rst,a2,v2,in2,s2,l2,d2);
    jpeg_core_c32 #(.FIXED_MODE(2),.FIXED_WIDTH(16),.FIXED_HEIGHT(16)) reference (
        .clk_i(clk),.rst_i(rst),.inport_valid_i(v0),.inport_data_i(in0),.inport_strb_i(s0),.inport_last_i(l0),
        .outport_accept_i(cycle%13!=0),.inport_accept_o(a0),.outport_valid_o(rgb0),
        .outport_pixel_x_o(x0),.outport_pixel_y_o(y0),.outport_pixel_r_o(color0[23:16]),
        .outport_pixel_g_o(color0[15:8]),.outport_pixel_b_o(color0[7:0]),.idle_o(idle0));
    jpeg_core #(.FIXED_MODE(2),.FIXED_WIDTH(16),.FIXED_HEIGHT(16)) default_rgb (
        .clk_i(clk),.rst_i(rst),.inport_valid_i(v1),.inport_data_i(in1),.inport_strb_i(s1),.inport_last_i(l1),
        .outport_accept_i(cycle%19!=0),.inport_accept_o(a1),.outport_valid_o(rgb1),
        .outport_pixel_x_o(x1),.outport_pixel_y_o(y1),.outport_pixel_r_o(color1[23:16]),
        .outport_pixel_g_o(color1[15:8]),.outport_pixel_b_o(color1[7:0]),.idle_o(idle1));
    jpeg_core #(.FIXED_MODE(2),.FIXED_WIDTH(16),.FIXED_HEIGHT(16),.NATIVE_IDCT_OUTPUT(1)) native_yuv (
        .clk_i(clk),.rst_i(rst),.inport_valid_i(v2),.inport_data_i(in2),.inport_strb_i(s2),.inport_last_i(l2),
        .outport_accept_i(block_space && cycle%137>=23),.inport_accept_o(a2),
        .native_valid_o(nvalid),.native_sample_o(nsample),.native_index_o(nindex),.native_id_o(nid),.idle_o(idle2));
    idct_yuv420_block_buffer #(.FRAME_WIDTH(16),.FRAME_HEIGHT(16)) block_buffer (
        .clk(clk),.rst(rst),.frame_start(1'b0),.frame_base_word(21'd0),.block_space(block_space),
        .sample_valid(nvalid),.sample_data(nsample),.sample_index(nindex),.sample_id(nid),
        .word_valid(word_valid),.word_ready(word_ready),.word_address(word_address),.word_data(word_data));
    reg [55:0] pixels0[0:511],pixels1[0:511];
    reg [69:0] blocks0[0:1023],blocks1[0:1023];
    reg [7:0] golden_bytes[0:383];
    reg [31:0] stored_words[0:95];
    reg [95:0] stored_seen=0;
    integer p0=0,p1=0,b0=0,b1=0,i,byte_address,centered,words=0,eof_blocks=0;
    initial begin repeat(8) @(negedge clk);rst=0;end
    always @(posedge clk) if(!rst) begin
        cycle<=cycle+1;
        if(rgb0 && cycle%13!=0 && x0<16 && y0<16) begin pixels0[p0]={x0,y0,color0};p0=p0+1;end
        if(rgb1 && cycle%19!=0) begin
            if(x1>=16 || y1>=16) $fatal(1,"RGB_OUTSIDE_FRAME x=%0d y=%0d",x1,y1);
            pixels1[p1]={x1,y1,color1};p1=p1+1;
        end
        if(reference.output_inport_valid_w && reference.output_inport_id_w[31:30]!=3 &&
           reference.output_inport_id_w[29:16]<2) begin
            blocks0[b0]={reference.output_inport_id_w,reference.output_inport_idx_w,reference.output_outport_data_w};b0=b0+1;
            case(reference.output_inport_id_w[31:30])
                0:byte_address=({reference.output_inport_id_w[16],reference.output_inport_id_w[0]}*64)+reference.output_inport_idx_w;
                1:byte_address=256+reference.output_inport_idx_w;
                2:byte_address=320+reference.output_inport_idx_w;
            endcase
            centered=$signed(reference.output_outport_data_w)+128;
            golden_bytes[byte_address]=centered<0?0:(centered>255?255:centered);
        end
        if(nvalid) begin
            if(nid[31:30]!=3) begin
                if(nid[29:16]>=2) $fatal(1,"NATIVE_OUTSIDE_FRAME id=%08x",nid);
                blocks1[b1]={nid,nindex,nsample};b1=b1+1;
            end else if(nindex==0) eof_blocks=eof_blocks+1;
        end
        if(word_valid && word_ready) begin
            if(word_address>=96 || stored_seen[word_address]) $fatal(1,"WORD_ADDRESS addr=%0d",word_address);
            stored_words[word_address]=word_data;stored_seen[word_address]=1;words=words+1;
        end
        if(cycle>2000 && d0 && d1 && d2 && idle0 && idle1 && idle2 && !word_valid) begin
            if(p0!=256 || p1!=256 || b0!=384 || b1!=384 || words!=96 || eof_blocks!=1)
                $fatal(1,"COUNT p0=%0d p1=%0d b0=%0d b1=%0d words=%0d eof=%0d",p0,p1,b0,b1,words,eof_blocks);
            for(i=0;i<p0;i=i+1) if(pixels0[i]!==pixels1[i]) $fatal(1,"RGB_MISMATCH index=%0d",i);
            for(i=0;i<b0;i=i+1) if(blocks0[i]!==blocks1[i]) $fatal(1,"NATIVE_MISMATCH index=%0d",i);
            for(i=0;i<96;i=i+1) if(stored_words[i]!=={golden_bytes[i*4+3],golden_bytes[i*4+2],golden_bytes[i*4+1],golden_bytes[i*4]})
                $fatal(1,"YUV_WORD_MISMATCH addr=%0d",i);
            $display("PASS RGB_pixels=%0d native_samples=%0d YUV_words=%0d cycles=%0d",p0,b0,words,cycle);
            $finish;
        end
        if(cycle>200000) $fatal(1,"TIMEOUT p0=%0d p1=%0d b0=%0d b1=%0d",p0,p1,b0,b1);
    end
endmodule
