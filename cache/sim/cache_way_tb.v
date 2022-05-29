`timescale 1ns / 1ps

module cache_way_tb();
    parameter integer ADDR_WIDTH = 5;
    parameter integer WHOLE_DATA_WIDTH = 128;
    parameter integer BANK_DATA_WIDTH = 32;
    parameter integer DATA_BYTE_NUM = 4;
    parameter integer DATA_WORD_NUM = 4;
    parameter integer TAG_BITS = 23;
    
    reg clk;
    reg wr_en;
    reg wr_tag_en;
    reg [ADDR_WIDTH - 1:0] addr;
    reg [WHOLE_DATA_WIDTH - 1:0] wr_data;
    reg [TAG_BITS - 1:0] wr_tag;
    reg [DATA_WORD_NUM - 1:0] wr_word_en;
    reg [DATA_BYTE_NUM - 1:0] wr_byte_en;
    
    wire [TAG_BITS - 1:0] tag_data;
    wire [WHOLE_DATA_WIDTH - 1:0] rd_data;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        #1
        @(posedge clk) addr = 0; wr_en = 1; wr_tag_en = 1; wr_data = 128'b111; wr_tag = 23'b111; wr_word_en = 4'b1; wr_byte_en = 4'b1111;
        #2;
        #2;
    end 
        
    
    CacheWay test_CacheWay(
        .clk(clk),
        .wr_en(wr_en),
        .wr_tag_en(wr_tag_en),
        .addr(addr),
        .wr_data(wr_data),
        .wr_tag(wr_tag),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .tag_data(tag_data),
        .rd_data(rd_data)
    );
endmodule
