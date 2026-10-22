`timescale 1ns/1ps
module tb_jpeg420_word_address;
    reg clk=0;always #10 clk=~clk;
    reg rst=1,start=0,take=0;
    reg [20:0] base=0;
    wire [20:0] addr;
    jpeg420_word_address dut(clk,rst,start,base,take,addr);
    integer b,n,expect_addr,my,mx,part,u,xx,yy,lane,checked=0;
    reg [230399:0] seen;
    reg [31:0] rng=32'h456789ab;
    reg [20:0] held;
    initial begin
        repeat(4) @(negedge clk);rst=0;
        for(b=0;b<2;b=b+1) begin
            base=b*230400;start=1;take=0;@(negedge clk);start=0;
            seen=0;
            for(n=0;n<230400;n=n+1) begin
                my=n/7680;mx=(n%7680)/192;part=(n%192)/48;u=n%48;
                xx=mx*4+(part%2)*2+(u%6)/3;
                yy=my*16+(part/2)*8+u/6;lane=u%3;
                expect_addr=base+yy*480+xx*3+lane;
                if(addr!==expect_addr) $fatal(1,"address mismatch n=%0d got=%0d expected=%0d",n,addr,expect_addr);
                if(seen[addr-base]) $fatal(1,"duplicate n=%0d addr=%0d",n,addr);
                seen[addr-base]=1;
                rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};
                if(rng[2:0]==0) begin
                    held=addr;take=0;@(negedge clk);
                    if(addr!==held) $fatal(1,"stall changed address");
                end
                take=1;@(negedge clk);take=0;checked=checked+1;
            end
            if(&seen!==1'b1) $fatal(1,"incomplete coverage");
        end
        $display("JPEG420_ADDRESS_PASS words=%0d frames=2 unique_addresses=460800 random_stalls=1",checked);
        $finish;
    end
endmodule
