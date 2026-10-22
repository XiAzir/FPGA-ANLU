from pathlib import Path
p=Path('development/video20_work/idct/tb_idct_width.sv')
s=p.read_text()
s=s.replace('wire xv_ref,xv_cand,yv_ref,yv_cand;','wire xv_ref,xv_cand,xv_b,xv_ab,yv_ref,yv_cand,yv_b,yv_ab;')
s=s.replace('wire [31:0] xo_ref,xo_cand,yo_ref,yo_cand;','wire [31:0] xo_ref,xo_cand,xo_b,xo_ab,yo_ref,yo_cand,yo_b,yo_ab;')
s=s.replace('wire [5:0] xidx_ref,xidx_cand,yidx_ref,yidx_cand;','wire [5:0] xidx_ref,xidx_cand,xidx_b,xidx_ab,yidx_ref,yidx_cand,yidx_b,yidx_ab;')
s=s.replace("jpeg_idct_x xcand(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_cand,xo_cand,xidx_cand);", "jpeg_idct_x xcand(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_cand,xo_cand,xidx_cand);\njpeg_idct_x_b xb(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_b,xo_b,xidx_b);\njpeg_idct_x_ab xab(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_ab,xo_ab,xidx_ab);")
s=s.replace("jpeg_idct_y ycand(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_cand,yo_cand,yidx_cand);", "jpeg_idct_y ycand(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_cand,yo_cand,yidx_cand);\njpeg_idct_y_b yb(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_b,yo_b,yidx_b);\njpeg_idct_y_ab yab(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_ab,yo_ab,yidx_ab);")
s=s.replace('if ({xv_ref,xo_ref,xidx_ref} !== {xv_cand,xo_cand,xidx_cand}) begin', 'if ({xv_ref,xo_ref,xidx_ref} !== {xv_cand,xo_cand,xidx_cand} || {xv_ref,xo_ref,xidx_ref} !== {xv_b,xo_b,xidx_b} || {xv_ref,xo_ref,xidx_ref} !== {xv_ab,xo_ab,xidx_ab}) begin')
s=s.replace('if ({yv_ref,yo_ref,yidx_ref} !== {yv_cand,yo_cand,yidx_cand}) begin', 'if ({yv_ref,yo_ref,yidx_ref} !== {yv_cand,yv_cand,yidx_cand} || {yv_ref,yo_ref,yidx_ref} !== {yv_b,yo_b,yidx_b} || {yv_ref,yo_ref,yidx_ref} !== {yv_ab,yo_ab,yidx_ab}) begin')
# Correct the candidate comparator if the literal replacement above produced a duplicated valid signal.
s=s.replace('{yv_cand,yv_cand,yidx_cand}', '{yv_cand,yo_cand,yidx_cand}')
p.write_text(s)
