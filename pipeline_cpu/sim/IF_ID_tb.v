`timescale 1ns / 1ps

module IF_ID_tb();
    reg clk, rst, EN;
    reg [31:0] PC_IF;
    reg [31:0] inst_IF;
    wire [31:0] PC_ID;
    wire [31:0] inst_ID;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        rst = 1; EN = 1;
        #2 rst = 0;
    end
    
    integer i;
    
    initial begin
        PC_IF = 0;
        inst_IF = 0;
        #2;
        for(i = 0; i < 10; i = i + 1) begin
            #2 PC_IF = PC_IF + 32'd4;
            inst_IF = inst_IF + 32'd16;
        end
    end
    
//    module IF_ID(
//    input clk,
//    input rst,
//    input EN,
//    input [31:0] PC_IF,
//    input [31:0] inst_IF,
    
//    output [31:0] PC_ID,
//    output [31:0] inst_ID
//);
    IF_ID IF_ID_test(.clk(clk), .rst(rst), .EN(EN), .PC_IF(PC_IF), .inst_IF(inst_IF), .PC_ID(PC_ID), .inst_ID(inst_ID));
endmodule