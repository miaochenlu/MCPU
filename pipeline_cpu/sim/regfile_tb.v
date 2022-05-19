`timescale 1ns / 1ps

module regfile_tb();
    reg clk, rst, we;
    reg [4:0] raddr1, raddr2, waddr;
    wire [31:0] rdata1, rdata2;
    reg [31:0] wdata;
    
    integer i = 0;
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        raddr1 = 0; raddr2 = 0; waddr = 0;
        rst = 0; we = 0;
        wdata = 0;
        
        #10;
        repeat(32) begin
            @(posedge clk);
            raddr1 = 0; raddr2 = 0;
            we = 1; waddr = i; wdata = i;
            @(posedge clk);
            we = 0; waddr = 0; wdata = 0;
            raddr1 = i;
            raddr2 = (i - 1 >= 0) ? i - 1 : i;
            i = i + 1;
        end
    end
    
    RegFile test_regfile(.clk(clk), .rst(rst), .we(we), .raddr1(raddr1), .rdata1(rdata1), .raddr2(raddr2), .rdata2(rdata2), .waddr(waddr), .wdata(wdata));
endmodule
