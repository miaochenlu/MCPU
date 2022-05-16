`timescale 1ns / 1ps

module pc_tb();
    reg clk, rst;
    reg [31:0] pc_in;
    wire [31:0] pc_out;
    
    integer i = 0;
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        pc_in = 0;
        rst = 0;
        repeat(10) begin
            @(posedge clk);
            #10 pc_in = i;
            #10 i = i + 1;
        end
    end
    
    PC test_PC(.clk(clk), .rst(rst), .pc_in(pc_in), .pc_out(pc_out));
endmodule
