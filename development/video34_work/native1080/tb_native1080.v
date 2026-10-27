`timescale 1ns/1ps
module tb_native1080 #(
 parameter integer JPEG_BYTES = 61664,
 parameter integer WORD_GAP = 1,
 parameter integer WORD_STALL_PERIOD = 13,
 parameter integer FRAME_WIDTH = 1920,
 parameter integer FRAME_HEIGHT = 1080,
 parameter integer ADDR_BITS = 21
);
 localparam integer MCU_COLUMNS=(FRAME_WIDTH+15)/16;
 localparam integer MCU_ROWS=(FRAME_HEIGHT+15)/16;
 localparam integer EXPECTED_BLOCKS=MCU_COLUMNS*MCU_ROWS*6;
 localparam integer Y_WORDS=MCU_COLUMNS*MCU_ROWS*64;
 localparam integer C_WORDS=MCU_COLUMNS*MCU_ROWS*16;
 localparam integer EXPECTED_WORDS=Y_WORDS+2*C_WORDS;
 localparam integer EXPECTED_SAMPLES=EXPECTED_BLOCKS*64;
 localparam integer DATA_WORDS=(JPEG_BYTES+3)/4;
 localparam integer SOURCE_WORDS=DATA_WORDS+1; // Final empty tail carries last=1.
 localparam integer MAX_CYCLES=((SOURCE_WORDS*WORD_GAP)>(EXPECTED_BLOCKS*180) ?
                               (SOURCE_WORDS*WORD_GAP) : (EXPECTED_BLOCKS*180))+
                               (EXPECTED_WORDS/12)+500000;

 reg clk=0; always #5 clk=~clk;
 reg rst=1;
 integer cycles=0;
 reg [7:0] jpeg_bytes[0:JPEG_BYTES-1];
 reg [31:0] source_word=0;
 reg [3:0] source_strb=0;
 integer source_index=0,gap_count=0,rawfd=0,i;
 integer init_i;
 integer cycle_limit=MAX_CYCLES;
 integer diagnostics=0;
 integer last_input_cycle=0,last_native_cycle=0,last_word_cycle=0;
 reg source_last=0,frame_seen=0;
 wire source_valid=(source_index<SOURCE_WORDS)&&(gap_count==0)&&!rst;
 wire source_done=(source_index==SOURCE_WORDS);
 wire source_accept;
 reg [8*512-1:0] frame_path,raw_path;

 reg word_ready;
 wire word_valid;
 wire [ADDR_BITS-1:0] word_address;
 wire [31:0] word_data;
 wire block_space;
 wire native_valid,core_idle;
 wire [31:0] native_sample,native_id;
 wire [5:0] native_index;
 integer native_blocks=0,native_samples=0,eof_blocks=0,eof_samples=0;
 integer word_count=0;
 reg native_block_open=0;
 reg [31:0] current_block_id=0;
 reg [63:0] current_index_mask=0;
 reg stall_prev=0;
 reg [ADDR_BITS-1:0] held_address=0;
 reg [31:0] held_data=0;
 reg seen[0:EXPECTED_WORDS-1];
 reg [31:0] data_by_address[0:EXPECTED_WORDS-1];
 integer p;
 wire [63:0] current_index_bit=(64'd1 << native_index);

 initial begin
  if(!$value$plusargs("FRAME_HEX=%s",frame_path)) $fatal(1,"+FRAME_HEX required");
  if(!$value$plusargs("RAW_OUT=%s",raw_path)) $fatal(1,"+RAW_OUT required");
  if(!$value$plusargs("STOP_CYCLES=%d",cycle_limit)) cycle_limit=MAX_CYCLES;
  if(!$value$plusargs("DIAGNOSTICS=%d",diagnostics)) diagnostics=0;
  $readmemh(frame_path,jpeg_bytes);
  for(init_i=0;init_i<EXPECTED_WORDS;init_i=init_i+1) seen[init_i]=1'b0;
  repeat(8) @(negedge clk);rst=0;
 end

 always @* begin
  source_word=0;source_strb=0;source_last=(source_index==DATA_WORDS);
  for(i=0;i<4;i=i+1) begin
   if(source_index<DATA_WORDS && (source_index*4+i)<JPEG_BYTES) begin
    source_word[i*8 +: 8]=jpeg_bytes[source_index*4+i];
    source_strb[i]=1'b1;
   end
  end
  if(WORD_STALL_PERIOD<=1) word_ready=1'b1;
  else word_ready=((cycles%WORD_STALL_PERIOD)!=(WORD_STALL_PERIOD-1));
 end

 always @(posedge clk) begin
  if(rst) begin
   cycles<=0;source_index<=0;gap_count<=0;frame_seen<=0;
   native_blocks<=0;native_samples<=0;eof_blocks<=0;eof_samples<=0;
   word_count<=0;native_block_open<=0;current_block_id<=0;
   current_index_mask<=0;stall_prev<=0;
  end else begin
   cycles<=cycles+1;
   if(core.img_start_w) frame_seen<=1;
   if(source_valid && source_accept) begin
    source_index<=source_index+1;
    last_input_cycle<=cycles;
    if(WORD_GAP>1) gap_count<=WORD_GAP-1;
   end else if(gap_count>0) gap_count<=gap_count-1;

   if(stall_prev) begin
    if(!word_valid || word_address!==held_address || word_data!==held_data)
     $fatal(1,"WORD_STABILITY_FAIL cycle=%0d previous_addr=%0d now_valid=%b addr=%0d",cycles,held_address,word_valid,word_address);
   end
   stall_prev<=word_valid && !word_ready;
   if(word_valid && !word_ready) begin held_address<=word_address;held_data<=word_data;end
   if(word_valid && word_ready) begin
    if(word_address>=EXPECTED_WORDS) $fatal(1,"FRAME_ADDRESS_OOB cycle=%0d addr=%0d",cycles,word_address);
    if(seen[word_address]) $fatal(1,"DUPLICATE_ADDRESS addr=%0d",word_address);
    seen[word_address]<=1'b1;
    data_by_address[word_address]<=word_data;
    word_count<=word_count+1;
    last_word_cycle<=cycles;
   end

   if(native_valid) begin
    last_native_cycle<=cycles;
    if(native_id[31:30]==2'd3) begin
     if(native_block_open) $fatal(1,"EOF_INTERLEAVED_IN_BLOCK id=%h",native_id);
     if(native_index==0) eof_samples<=eof_samples+1;
     if(native_index==63) eof_blocks<=eof_blocks+1;
    end else begin
     if(native_id[31:30]>2'd2) $fatal(1,"INVALID_COMPONENT_ID id=%h",native_id);
     if(native_index==0) begin
      if(native_block_open) $fatal(1,"BLOCK_START_BEFORE_PREVIOUS_END id=%h",native_id);
      native_block_open<=1;
      current_block_id<=native_id;
      current_index_mask<=current_index_bit;
     end else begin
      if(!native_block_open) $fatal(1,"SAMPLE_WITHOUT_BLOCK_START id=%h idx=%0d",native_id,native_index);
      if(native_id!==current_block_id) $fatal(1,"ID_CHANGED_WITHIN_BLOCK old=%h new=%h",current_block_id,native_id);
      if(current_index_mask[native_index]) $fatal(1,"DUPLICATE_SAMPLE_INDEX id=%h idx=%0d",native_id,native_index);
      current_index_mask<=current_index_mask|current_index_bit;
     end
     native_samples<=native_samples+1;
     if(native_index==63) begin
      if((current_index_mask|current_index_bit)!==64'hffff_ffff_ffff_ffff)
       $fatal(1,"INCOMPLETE_IDCT_INDEX_SET id=%h mask=%h",native_id,(current_index_mask|current_index_bit));
      native_block_open<=0;
      native_blocks<=native_blocks+1;
     end
    end
   end

   if(source_done && frame_seen && core_idle && !native_block_open &&
      eof_blocks==1 && native_blocks==EXPECTED_BLOCKS &&
      native_samples==EXPECTED_SAMPLES && word_count==EXPECTED_WORDS &&
      block_buffer.occupied==0 && block_buffer.ready==0) begin
    for(p=0;p<EXPECTED_WORDS;p=p+1)
     if(!seen[p]) $fatal(1,"MISSING_ADDRESS %0d",p);
    rawfd=$fopen(raw_path,"wb");
    if(rawfd==0) $fatal(1,"cannot open raw output %0s",raw_path);
    for(p=0;p<EXPECTED_WORDS;p=p+1)
     $fwrite(rawfd,"%c%c%c%c",data_by_address[p][7:0],data_by_address[p][15:8],data_by_address[p][23:16],data_by_address[p][31:24]);
    $fclose(rawfd);
    $display("NATIVE1080_PASS frame=%0s cycles=%0d input_words=%0d real_blocks=%0d real_samples=%0d eof_blocks=%0d eof_samples=%0d word_writes=%0d addr_first=0 addr_last=%0d",frame_path,cycles,source_index,native_blocks,native_samples,eof_blocks,eof_samples,word_count,EXPECTED_WORDS-1);
    $finish;
   end
   if(diagnostics && (cycles%100000==0))
    $display("PROGRESS cycle=%0d source_words=%0d/%0d data_words=%0d last_in=%0d native_blocks=%0d/%0d real_samples=%0d last_native=%0d eof_blocks=%0d eof_samples=%0d words=%0d/%0d last_word=%0d mcu_state=%0d coeff_idx=%0d eof_flag=%b mcu_type=%0d mcu_x=%0d mcu_y=%0d idct_active=%b idct_dc=%b idct_desc=%0d idct_rd=%0d idct_wr=%0d ram_ready=%b ram_rd=%0d ram_wr=%0d ram_state=%0d buffer_occ=%b buffer_ready=%b wb=%b rb=%b rw=%0d",cycles,source_index,SOURCE_WORDS,DATA_WORDS,last_input_cycle,native_blocks,EXPECTED_BLOCKS,native_samples,last_native_cycle,eof_blocks,eof_samples,word_count,EXPECTED_WORDS,last_word_cycle,core.u_jpeg_mcu_proc.state_q,core.u_jpeg_mcu_proc.coeff_idx_q,core.u_jpeg_mcu_proc.end_of_image_w,core.u_jpeg_mcu_proc.block_type_w,core.u_jpeg_mcu_proc.u_id.block_x_q,core.u_jpeg_mcu_proc.u_id.block_y_q,core.u_jpeg_idct.active_q,core.u_jpeg_idct.active_dc_q,core.u_jpeg_idct.desc_count_q,core.u_jpeg_idct.desc_rd_q,core.u_jpeg_idct.desc_wr_q,core.u_jpeg_idct.u_input.block_ready_q,core.u_jpeg_idct.u_input.block_rd_q,core.u_jpeg_idct.u_input.block_wr_q,core.u_jpeg_idct.u_input.state_q,block_buffer.occupied,block_buffer.ready,block_buffer.write_bank,block_buffer.read_bank,block_buffer.read_word);
   if(cycles>cycle_limit)
    $fatal(1,"DYNAMIC_STOP cycles=%0d limit=%0d source_words=%0d/%0d data_words=%0d last_in=%0d native_blocks=%0d/%0d real_samples=%0d last_native=%0d eof_blocks=%0d eof_samples=%0d words=%0d/%0d last_word=%0d mcu_state=%0d coeff_idx=%0d eof_flag=%b mcu_type=%0d mcu_x=%0d mcu_y=%0d idct_active=%b idct_dc=%b idct_desc=%0d idct_rd=%0d idct_wr=%0d ram_ready=%b ram_rd=%0d ram_wr=%0d ram_state=%0d ram_rdidx=%0d buffer_occ=%b buffer_ready=%b wb=%b rb=%b rw=%0d block_open=%b block_id=%h index_mask=%h",cycles,cycle_limit,source_index,SOURCE_WORDS,DATA_WORDS,last_input_cycle,native_blocks,EXPECTED_BLOCKS,native_samples,last_native_cycle,eof_blocks,eof_samples,word_count,EXPECTED_WORDS,last_word_cycle,core.u_jpeg_mcu_proc.state_q,core.u_jpeg_mcu_proc.coeff_idx_q,core.u_jpeg_mcu_proc.end_of_image_w,core.u_jpeg_mcu_proc.block_type_w,core.u_jpeg_mcu_proc.u_id.block_x_q,core.u_jpeg_mcu_proc.u_id.block_y_q,core.u_jpeg_idct.active_q,core.u_jpeg_idct.active_dc_q,core.u_jpeg_idct.desc_count_q,core.u_jpeg_idct.desc_rd_q,core.u_jpeg_idct.desc_wr_q,core.u_jpeg_idct.u_input.block_ready_q,core.u_jpeg_idct.u_input.block_rd_q,core.u_jpeg_idct.u_input.block_wr_q,core.u_jpeg_idct.u_input.state_q,core.u_jpeg_idct.u_input.rd_idx_q,block_buffer.occupied,block_buffer.ready,block_buffer.write_bank,block_buffer.read_bank,block_buffer.read_word,native_block_open,current_block_id,current_index_mask);
  end
 end

 jpeg_core #(.FIXED_MODE(2),.FIXED_WIDTH(FRAME_WIDTH),.FIXED_HEIGHT(FRAME_HEIGHT),.NATIVE_IDCT_OUTPUT(1)) core(
  .clk_i(clk),.rst_i(rst),.inport_valid_i(source_valid),.inport_data_i(source_word),
  .inport_strb_i(source_strb),.inport_last_i(source_last),.outport_accept_i(block_space),
  .inport_accept_o(source_accept),.native_valid_o(native_valid),.native_sample_o(native_sample),
  .native_index_o(native_index),.native_id_o(native_id),.idle_o(core_idle),
  .outport_valid_o(),.outport_width_o(),.outport_height_o(),.outport_pixel_x_o(),.outport_pixel_y_o(),
  .outport_pixel_r_o(),.outport_pixel_g_o(),.outport_pixel_b_o());

 idct_yuv420_block_buffer #(.FRAME_WIDTH(FRAME_WIDTH),.FRAME_HEIGHT(FRAME_HEIGHT),.ADDR_BITS(ADDR_BITS)) block_buffer(
  .clk(clk),.rst(rst),.frame_start(core.img_start_w),.frame_base_word({ADDR_BITS{1'b0}}),
  .block_space(block_space),.sample_valid(native_valid),.sample_data($signed(native_sample)),
  .sample_index(native_index),.sample_id(native_id),.word_valid(word_valid),.word_ready(word_ready),
  .word_address(word_address),.word_data(word_data));
endmodule
