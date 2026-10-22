`timescale 1ns/1ps
module tb_gate_compare;
reg clk=0; always #10 clk=~clk;
reg rst=1, img_start=0, in_valid=0;
reg [31:0] d0=0,d1=0,d2=0,d3=0; reg [2:0] idx=0;
wire rv; wire [31:0] rd; wire [5:0] ri; wire gv; wire [31:0] gd; wire [5:0] gi;
integer seed=32'h51D7C0DE, cyc=0, sent=0, cc=0, rc=0, total_c=0,total_r=0,errors=0;
integer ccyc[0:1023]; reg [31:0] cdata[0:1023]; reg [5:0] cidx[0:1023];
reg [20:0] a,b,c,d; integer k,seg,receipt;

idct_y_area_top u_gate(clk,img_start,d0,d1,d2,d3,idx,in_valid,rst,gd,gi,gv);

jpeg_idct_y_reference #(.OUT_SHIFT(11)) u_ref(clk,rst|img_start,img_start,1'b0,in_valid,d0,d1,d2,d3,idx,rv,rd,ri);

always @(posedge clk) begin
  cyc=cyc+1;
  if(rst || img_start) begin
    total_c=total_c+cc; total_r=total_r+rc; cc=0; rc=0;
  end else begin
    if(gv) begin cdata[cc]=gd; cidx[cc]=gi; ccyc[cc]=cyc; cc=cc+1; end
    if(rv) begin
      if(cc<=rc || cdata[rc]!==rd || cidx[rc]!==ri || cyc-ccyc[rc]!=1) begin
        $display("GATE_DIFF beat=%0d ref=%h/%0d@%0d gate=%h/%0d@%0d",rc,rd,ri,cyc,cdata[rc],cidx[rc],ccyc[rc]); errors=errors+1;
      end
      rc=rc+1;
    end
  end
end

initial begin
  receipt=$fopen("input_receipt.csv","w");
  $fwrite(receipt,"segment,ordinal,idx,a,b,c,d\n");
  repeat(5) @(negedge clk); rst=0;
  for(seg=0;seg<3;seg=seg+1) begin
    while(sent < (seg+1)*256) begin
      @(negedge clk);
      if(($random(seed)&7)!=0) begin
        in_valid=1; idx=sent%8;
        a=$random(seed); b=$random(seed); c=$random(seed); d=$random(seed);
        case(sent%32)
          0: begin a=21'h100000;b=21'h0fffff;c=0;d=21'h1fffff; end
          1: begin a=21'h0fffff;b=21'h100000;c=21'h1fffff;d=0; end
          2: begin a=0;b=21'h1fffff;c=21'h100000;d=21'h0fffff; end
          3: begin a=21'h1fffff;b=0;c=21'h0fffff;d=21'h100000; end
          4: begin a=21'h1fffff;b=21'h1fffff;c=21'h1fffff;d=21'h1fffff; end
          5: begin a=21'h100000;b=21'h100000;c=21'h100000;d=21'h100000; end
        endcase
        d0={{11{a[20]}},a}; d1={{11{b[20]}},b}; d2={{11{c[20]}},c}; d3={{11{d[20]}},d};
        $fwrite(receipt,"%0d,%0d,%0d,%06h,%06h,%06h,%06h\n",seg,sent,idx,a,b,c,d);
        sent=sent+1;
      end else in_valid=0;
    end
    @(negedge clk); in_valid=0;
    repeat(2200) @(negedge clk);
    if(seg<2) begin
      rst=1; img_start=1; repeat(3) @(negedge clk); rst=0; img_start=0;
      repeat(2) @(negedge clk);
    end
  end
  repeat(80) @(negedge clk);
  total_c=total_c+cc; total_r=total_r+rc;
  $fclose(receipt);
  if(total_r!=768 || total_c!=768) begin
    $display("COUNT ref=%0d gate=%0d sent=%0d",total_r,total_c,sent); errors=errors+1;
  end
  $display("GATE_Y_RESULT sent=%0d ref=%0d gate=%0d errors=%0d",sent,total_r,total_c,errors);
  if(errors) $fatal(1,"gate Y mismatch");
  $finish;
end
endmodule
