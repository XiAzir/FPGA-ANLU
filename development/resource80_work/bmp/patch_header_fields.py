from pathlib import Path
root=Path(__file__).resolve().parent
s=(root/'tf_bmp_file_player.header_base.v').read_text(encoding='utf-8-sig')
def sub(old,new,label):
 global s
 n=s.count(old)
 if n!=1: raise SystemExit(f'{label}: expected 1 match, got {n}')
 s=s.replace(old,new,1)
sub('reg [15:0] magic, planes, bit_count;\nreg [31:0] declared_size, dib_size, pixel_offset, width, height, compression;', '''reg [31:0] declared_size, dib_size, pixel_offset;
reg magic_ok, planes_ok, bit_count_ok, compression_ok;
reg [10:0] width_low;
reg width_high_nonzero;
reg [9:0] height_low;
reg height_sign, height_high_one, height_high_zero;''','raw header fields')
sub("wire [31:0] abs_height=height[31] ? (~height+32'd1) : height;", "wire [9:0] abs_height=height_sign ? (~height_low+10'd1) : height_low;\nwire width_invalid=width_high_nonzero || width_low>11'd1024;\nwire height_invalid=height_high_zero && height_sign ? 1'b1 :\n    (height_high_one && !height_sign) || (abs_height==0) ||\n    (height_sign && height_low==0) || (abs_height>10'd768);", 'narrow abs height')
sub("wire [11:0] source_stride=((({1'b0,width[10:0]}*14'd3)+14'd3)>>2)<<2;", "wire [11:0] source_stride=((({1'b0,width_low}*14'd3)+14'd3)>>2)<<2;", 'source stride')
sub("(magic==16'h4d42) && (dib_size>=40) &&", "magic_ok && (dib_size>=40) &&", 'header magic validation')
sub("(planes==1) && (bit_count==24) && (compression==0) &&", "planes_ok && bit_count_ok && compression_ok &&", 'header fixed field validation')
sub("(width!=0) && (width<=1024) && (abs_height!=0) &&\n    (height!=32'h80000000) && (abs_height<=768) &&", "(width_low!=0 || width_high_nonzero) && !width_invalid && !height_invalid &&", 'header valid geometry')
sub(".source_height(abs_height[15:0]),.source_top_down(height[31]),", ".source_height({6'd0,abs_height}),.source_top_down(height_sign),", 'scale inputs')
sub(".source_width(width[15:0]),", ".source_width({5'd0,width_low}),", 'scale width input')
sub("""wire [15:0] header_failure_mask={5'd0,
    (declared_size>file_size),({1'b0,declared_size}<pixel_end),
    (pixel_end>{1'b0,file_size}),
    (abs_height==0 || height==32'h80000000 || abs_height>768),
    (width==0 || width>1024),(compression!=0),(bit_count!=24),
    (planes!=1),({1'b0,pixel_offset}<33'd14+{1'b0,dib_size}),
    (dib_size<40),(magic!=16'h4d42)};""", """wire [15:0] header_failure_mask={5'd0,
    (declared_size>file_size),({1'b0,declared_size}<pixel_end),
    (pixel_end>{1'b0,file_size}),height_invalid,
    ((width_low==0 && !width_high_nonzero) || width_invalid),!compression_ok,!bit_count_ok,
    !planes_ok,({1'b0,pixel_offset}<33'd14+{1'b0,dib_size}),
    (dib_size<40),!magic_ok};""", 'all diagnostic mask fields')
sub("        magic<=0; planes<=0; bit_count<=0; declared_size<=0; dib_size<=0;", "        magic_ok<=1; planes_ok<=1; bit_count_ok<=1; compression_ok<=1;\n        declared_size<=0; dib_size<=0;", 'reset fixed header fields')
sub("        pixel_offset<=0; width<=0; height<=0; compression<=0;", "        pixel_offset<=0; width_low<=0; width_high_nonzero<=0;\n        height_low<=0; height_sign<=0; height_high_one<=0; height_high_zero<=0;", 'reset geometry header fields')
sub("                    magic<=0; planes<=0; bit_count<=0; declared_size<=0;", "                    magic_ok<=1; planes_ok<=1; bit_count_ok<=1; compression_ok<=1;\n                    declared_size<=0;", 'new file fixed fields')
sub("                    dib_size<=0; pixel_offset<=0; width<=0; height<=0; compression<=0;", "                    dib_size<=0; pixel_offset<=0; width_low<=0; width_high_nonzero<=0;\n                    height_low<=0; height_sign<=0; height_high_one<=0; height_high_zero<=0;", 'new file geometry fields')
sub("0: magic[7:0]<=card_data; 1: magic[15:8]<=card_data;", "0: magic_ok<=magic_ok && (card_data==8'h42); 1: magic_ok<=magic_ok && (card_data==8'h4d);", 'magic byte reductions')
sub("26: planes[7:0]<=card_data; 27: planes[15:8]<=card_data;", "26: planes_ok<=planes_ok && (card_data==8'd1); 27: planes_ok<=planes_ok && (card_data==8'd0);", 'planes byte reductions')
sub("28: bit_count[7:0]<=card_data; 29: bit_count[15:8]<=card_data;", "28: bit_count_ok<=bit_count_ok && (card_data==8'd24); 29: bit_count_ok<=bit_count_ok && (card_data==8'd0);", 'bit count byte reductions')
sub("30: compression[7:0]<=card_data; 31: compression[15:8]<=card_data;\n                        32: compression[23:16]<=card_data; 33: compression[31:24]<=card_data;", "30: compression_ok<=compression_ok && (card_data==8'd0); 31: compression_ok<=compression_ok && (card_data==8'd0);\n                        32: compression_ok<=compression_ok && (card_data==8'd0); 33: compression_ok<=compression_ok && (card_data==8'd0);", 'compression byte reductions')
sub("""                        18: width[7:0]<=card_data; 19: width[15:8]<=card_data;
                        20: width[23:16]<=card_data; 21: width[31:24]<=card_data;
                        22: height[7:0]<=card_data; 23: height[15:8]<=card_data;
                        24: height[23:16]<=card_data; 25: height[31:24]<=card_data;""", """                        18: width_low[7:0]<=card_data; 19: begin
                            width_low[10:8]<=card_data[2:0];
                            width_high_nonzero<=|card_data[7:3];
                        end
                        20: width_high_nonzero<=width_high_nonzero || (|card_data);
                        21: width_high_nonzero<=width_high_nonzero || (|card_data);
                        22: height_low[7:0]<=card_data; 23: begin
                            height_low[9:8]<=card_data[1:0];
                            height_high_one<=|card_data[7:2];
                            height_high_zero<=~&card_data[7:2];
                        end
                        24: begin
                            height_high_one<=height_high_one || (|card_data);
                            height_high_zero<=height_high_zero || (~&card_data);
                        end
                        25: begin
                            height_sign<=card_data[7];
                            height_high_one<=height_high_one || (|card_data[6:0]);
                            height_high_zero<=height_high_zero || (~&card_data[6:0]);
                        end""", 'header byte capture')
import re
if re.search(r'\b(width|height)\[', s): raise SystemExit('unreplaced width/height use remains')
(root/'tf_bmp_file_player.header.v').write_text(s,encoding='utf-8',newline='\n')
print(root/'tf_bmp_file_player.header.v')



