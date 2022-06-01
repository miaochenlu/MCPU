`timescale 1ns / 1ps

module cache_2way_tb();

    parameter integer ADDR_WIDTH = 5;
    parameter integer WHOLE_DATA_WIDTH = 128;
    parameter integer BANK_DATA_WIDTH = 32;
    parameter integer DATA_BYTE_NUM = 4;
    parameter integer DATA_WORD_NUM = 4;
    parameter integer TAG_BITS = 23;
    parameter integer CACHE_WAY_BIT = 1;
    parameter integer CACHE_WAY_NUM = 2;
    
    reg clk;
    reg rst;
    reg wr_en;
    reg refill;
    reg [ADDR_WIDTH - 1:0] addr;
    reg [TAG_BITS - 1:0] in_tag;
    reg [CACHE_WAY_NUM - 1:0]    way_select;
    reg [WHOLE_DATA_WIDTH - 1:0] wr_data;
    reg [DATA_WORD_NUM - 1:0] wr_word_en;
    reg [DATA_BYTE_NUM - 1:0] wr_byte_en;
    
    wire [CACHE_WAY_NUM - 1:0]    valid;
    wire [CACHE_WAY_NUM - 1:0]    hit;
    wire [CACHE_WAY_NUM - 1:0]    modify;
    wire [TAG_BITS - 1:0]         out_tag_way0;
    wire [TAG_BITS - 1:0]         out_tag_way1;
    wire [WHOLE_DATA_WIDTH - 1:0] rd_data_way0;
    wire [WHOLE_DATA_WIDTH - 1:0] rd_data_way1;
    wire [CACHE_WAY_NUM - 1:0]    write_data_ready;
    wire [CACHE_WAY_NUM - 1:0]    refill_ready;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        #2 rst = 0;
        @(posedge clk) addr = 0; refill = 1; wr_en = 1; in_tag = 23'b111; way_select = 2'b01; wr_data = 128'b111; wr_word_en = 4'b1; wr_byte_en = 4'b1111;
        #2 wr_en = 1;
        #2 wr_en = 0;
    end 
    
    Cache2Way test_Cache2Way(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .refill(refill),
        .way_select(way_select),
        .addr(addr),
        .in_tag(in_tag),
        .wr_data(wr_data),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .valid(valid),
        .hit(hit),
        .modify(modify),
        .out_tag_way0(out_tag_way0),
        .out_tag_way1(out_tag_way1),
        .rd_data_way0(rd_data_way0),
        .rd_data_way1(rd_data_way1),
        .refill_ready(refill_ready),
        .write_data_ready(write_data_ready)
    );
    
endmodule
