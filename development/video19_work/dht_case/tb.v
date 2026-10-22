module tb;reg [15:0] code;integer i;wire [4:0] y_dcw,y_dcr;wire [7:0] y_dcv,y_dcs;
jpeg_dht_std_y_dc a_y_dc(code,y_dcw,y_dcv);jpeg_dht_std_y_dc_reference r_y_dc(code,y_dcr,y_dcs);
wire [4:0] y_acw,y_acr;wire [7:0] y_acv,y_acs;
jpeg_dht_std_y_ac a_y_ac(code,y_acw,y_acv);jpeg_dht_std_y_ac_reference r_y_ac(code,y_acr,y_acs);
wire [4:0] cx_dcw,cx_dcr;wire [7:0] cx_dcv,cx_dcs;
jpeg_dht_std_cx_dc a_cx_dc(code,cx_dcw,cx_dcv);jpeg_dht_std_cx_dc_reference r_cx_dc(code,cx_dcr,cx_dcs);
wire [4:0] cx_acw,cx_acr;wire [7:0] cx_acv,cx_acs;
jpeg_dht_std_cx_ac a_cx_ac(code,cx_acw,cx_acv);jpeg_dht_std_cx_ac_reference r_cx_ac(code,cx_acr,cx_acs);
initial begin for(i=0;i<65536;i=i+1)begin code=i;#1;
if({y_dcw,y_dcv}!=={y_dcr,y_dcs})$fatal(1,"DHT mismatch y_dc code=%h",code);
if({y_acw,y_acv}!=={y_acr,y_acs})$fatal(1,"DHT mismatch y_ac code=%h",code);
if({cx_dcw,cx_dcv}!=={cx_dcr,cx_dcs})$fatal(1,"DHT mismatch cx_dc code=%h",code);
if({cx_acw,cx_acv}!=={cx_acr,cx_acs})$fatal(1,"DHT mismatch cx_ac code=%h",code);
end $display("DHT_CASE_PASS 4 tables 65536 inputs each");$finish;end endmodule
