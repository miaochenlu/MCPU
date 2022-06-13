`timescale 1ns / 1ps

module mcpu_tb();
    
    reg clk, rst;
    
    initial begin
        clk = 0; rst = 1;
        #10 clk = 1; rst = 1;
        #10 clk = 0; rst = 0;
        forever #10 clk = ~clk;
    end
    MCPU test_MCPU(.clk(clk), .rst(rst));
endmodule