`timescale 1ns/1ps
module tb_native30_frame;
    localparam integer H=2200, V=1125, FRAME=H*V;
    localparam integer VS_START=(1080-1+4)*H+1920+88;
    reg clk=0, reset=1;
    always #5 clk=~clk;
    wire [15:0] cx,cy;
    wire active;
    wire [9:0] b,g,r,clockword;
    wire [23:0] rgb=color(cx);
    video_only_tmds_tx #(
        .H_ACTIVE(1920),.H_FRONT(88),.H_SYNC(44),.H_BACK(148),
        .V_ACTIVE(1080),.V_FRONT(4),.V_SYNC(5),.V_BACK(36),
        .HSYNC_ACTIVE_LOW(1'b0),.VSYNC_ACTIVE_LOW(1'b0)
    ) dut(.pixel_clk(clk),.reset(reset),.rgb(rgb),.cx(cx),.cy(cy),.active(active),
          .tmds0(b),.tmds1(g),.tmds2(r),.clockword(clockword));
    function automatic [23:0] color(input integer x);
        case(x/240)
            0:color=24'hffffff; 1:color=24'hffff00;
            2:color=24'h00ffff; 3:color=24'h00ff00;
            4:color=24'hff00ff; 5:color=24'hff0000;
            6:color=24'h0000ff; default:color=24'h000000;
        endcase
    endfunction
    function automatic [7:0] video(input [9:0] code);
        reg [7:0] q,value;
        integer j;
        begin
            q=code[7:0] ^ {8{code[9]}};
            value[0]=q[0];
            for(j=1;j<8;j=j+1) value[j]=(q[j]^q[j-1])^!code[8];
            video=value;
        end
    endfunction
    function automatic [1:0] control(input [9:0] code);
        case(code)
            10'h354:control=0; 10'h0ab:control=1;
            10'h154:control=2; 10'h2ab:control=3;
            default:control=2'bxx;
        endcase
    endfunction
    function automatic [3:0] terc(input [9:0] code);
        case(code)
            10'h29c:terc=0; 10'h263:terc=1; 10'h2e4:terc=2; 10'h2e2:terc=3;
            10'h171:terc=4; 10'h11e:terc=5; 10'h18e:terc=6; 10'h13c:terc=7;
            10'h2cc:terc=8; 10'h139:terc=9; 10'h19c:terc=10; 10'h2c6:terc=11;
            10'h28e:terc=12; 10'h271:terc=13; 10'h163:terc=14; 10'h2c3:terc=15;
            default:terc=4'bxxxx;
        endcase
    endfunction
    integer i,x,y,pos,relative_vs;
    integer pixels=0, packet_symbols=0, synced=0, h_rises=0,h_falls=0;
    integer vs_rise=-1, vs_fall=-1;
    reg want_active, want_h, want_v, previous_h=0,previous_v=0;
    reg [1:0] observed_sync;
    reg [3:0] nibble;
    reg sync_available;
    initial begin
        repeat(4) @(posedge clk);
        @(negedge clk) reset=0;
        for(i=0;i<FRAME+32;i=i+1) begin
            if(i<32) begin x=H-32+i; y=V-1; end
            else begin x=(i-32)%H; y=(i-32)/H; end
            if(cx !== x || cy !== y) $fatal(1,"coordinate i=%0d got %0d,%0d expected %0d,%0d",i,cx,cy,x,y);
            want_active=x<1920 && y<1080;
            if(active !== want_active) $fatal(1,"active geometry i=%0d",i);
            want_h=x>=2008 && x<2052;
            pos=y*H+x;
            relative_vs=(pos-VS_START+FRAME)%FRAME;
            want_v=relative_vs<5*H;
            @(posedge clk); #1;
            if(clockword !== 10'b0000011111) $fatal(1,"clockword i=%0d",i);
            sync_available=0;
            if(want_active) begin
                if({video(r),video(g),video(b)} !== color(x)) $fatal(1,"RGB i=%0d x=%0d y=%0d",i,x,y);
                pixels=pixels+1;
            end else if(x>=1932 && x<1968) begin
                nibble=terc(b);
                if((^nibble) === 1'bx) $fatal(1,"TERC4 i=%0d",i);
                observed_sync=nibble[1:0];
                sync_available=1;
                if(x>=1934 && x<1966) begin
                    if((^terc(g))===1'bx || (^terc(r))===1'bx) $fatal(1,"payload symbol i=%0d",i);
                    packet_symbols=packet_symbols+1;
                end else if(g !== 10'h133 || r !== 10'h133) $fatal(1,"DI guard i=%0d",i);
            end else if(x>=H-2 && (y<1079 || y==V-1)) begin
                if({r,g,b} !== {10'h2cc,10'h133,10'h2cc}) $fatal(1,"video guard i=%0d",i);
            end else begin
                observed_sync=control(b);
                if((^observed_sync)===1'bx) $fatal(1,"control symbol i=%0d",i);
                sync_available=1;
            end
            if(sync_available) begin
                if(observed_sync !== {want_v,want_h}) $fatal(1,"positive sync contract i=%0d x=%0d y=%0d got=%b expected=%b",i,x,y,observed_sync,{want_v,want_h});
                synced=synced+1;
                if(i>=32) begin
                    if(!previous_h && observed_sync[0]) h_rises=h_rises+1;
                    if(previous_h && !observed_sync[0]) h_falls=h_falls+1;
                    if(!previous_v && observed_sync[1]) vs_rise=i-32;
                    if(previous_v && !observed_sync[1]) vs_fall=i-32;
                end
                previous_h=observed_sync[0]; previous_v=observed_sync[1];
            end
            @(negedge clk);
        end
        if(pixels!=2073600 || packet_symbols!=36000 || h_rises!=1125 || h_falls!=1125)
            $fatal(1,"counts RGB=%0d packet=%0d H=%0d/%0d",pixels,packet_symbols,h_rises,h_falls);
        if(vs_rise!=VS_START || vs_fall-vs_rise!=11000) $fatal(1,"VS edges %0d/%0d",vs_rise,vs_fall);
        if(cx!==0 || cy!==0) $fatal(1,"frame wrap %0d,%0d",cx,cy);
        $display("NATIVE30_FULL_FRAME_PASS cycles=%0d RGB=%0d packet_symbols=%0d H_rise=%0d H_fall=%0d VS_rise=%0d VS_fall=%0d sync_symbols=%0d",FRAME,pixels,packet_symbols,h_rises,h_falls,vs_rise,vs_fall,synced);
        $finish;
    end
endmodule
