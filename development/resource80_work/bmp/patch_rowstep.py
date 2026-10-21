from pathlib import Path
root=Path(__file__).resolve().parent
s=(root/'bmp_scale_engine.base.v').read_text(encoding='utf-8-sig')
def sub(old,new,label):
 global s
 n=s.count(old)
 if n!=1: raise SystemExit(f'{label}: expected 1 match, got {n}')
 s=s.replace(old,new,1)
sub('reg [31:0] row_base;', 'reg [32:0] row_base;', 'row_base width')
sub("wire [21:0] row_offset = {12'd0,physical_row} * {10'd0,stride};\nwire [32:0] row_address_wide = {1'b0,pixel_offset} + {11'd0,row_offset};\n", "wire [32:0] top_row_address = {1'b0,pixel_offset} + {11'd0,image_bytes} - {21'd0,stride};\n", 'row address multiplier')
sub("wire [32:0] byte_address_wide = {1'b0,row_base} + col_offset;", "wire [32:0] byte_address_wide = {1'b0,row_base[31:0]} + col_offset;", 'byte address')
sub("row_base<=row_address_wide[31:0];\n                if (row_address_wide[32]) begin error<=1; state<=S_TERMINAL; failure_code<=8'h04; end\n                else begin src_col<=0; component<=0; state<=S_BYTE; end", "if (row_base[32]) begin error<=1; state<=S_TERMINAL; failure_code<=8'h04; end\n                else begin src_col<=0; component<=0; state<=S_BYTE; end", 'row check')
sub("""        S_SETUP: begin
            if (image_end> {1'b0,file_size}) begin
                error<=1; state<=S_TERMINAL; failure_code<=8'h03;
            end else if ((src_w*FRAME_HEIGHT)>=(src_h*FRAME_WIDTH)) begin""", """        S_SETUP: begin
            if (image_end> {1'b0,file_size}) begin
                error<=1; state<=S_TERMINAL; failure_code<=8'h03;
            end else begin
                row_base<=source_top_down ? top_row_address : {1'b0,pixel_offset};
                if ((src_w*FRAME_HEIGHT)>=(src_h*FRAME_WIDTH)) begin""", 'S_SETUP open')
sub("""                div_bit<=DIVIDEND_W-1; div_for_width<=1; state<=S_DIV;
            end
        end
        S_DIV: begin""", """                div_bit<=DIVIDEND_W-1; div_for_width<=1; state<=S_DIV;
                end
            end
        end
        S_DIV: begin""", 'S_SETUP close')
sub("""                y_phase<=y_phase-dh; src_bottom<=src_bottom+1'b1;
                physical_row<=source_top_down ? src_h-1'b1-(src_bottom+1'b1) : src_bottom+1'b1;""", """                y_phase<=y_phase-dh; src_bottom<=src_bottom+1'b1;
                physical_row<=source_top_down ? src_h-1'b1-(src_bottom+1'b1) : src_bottom+1'b1;
                row_base<=source_top_down ? row_base-{21'd0,stride} : row_base+{21'd0,stride};""", 'row stepping')
(root/'bmp_scale_engine.rowstep.v').write_text(s,encoding='utf-8',newline='\n')
print(root/'bmp_scale_engine.rowstep.v')
