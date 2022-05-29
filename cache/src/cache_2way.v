`timescale 1ns / 1ps

module Cache2Way # (
    parameter integer ADDR_WIDTH = 5,
    parameter integer WHOLE_DATA_WIDTH = 128,
    parameter integer BANK_DATA_WIDTH = 32,
    parameter integer DATA_BYTE_NUM = 4,
    parameter integer DATA_WORD_NUM = 4,
    parameter integer TAG_BITS = 23,
    parameter integer CACHE_WAY_BIT = 1,
    parameter integer CACHE_WAY_NUM = 2
)
(
    input clk,
    input wr_en,
    input wr_tag_en,
    input [ADDR_WIDTH - 1:0] addr,
    input [CACHE_WAY_NUM - 1:0] way_select,
    input [WHOLE_DATA_WIDTH - 1:0] wr_data,
    input [TAG_BITS - 1:0] wr_tag,
    input [DATA_WORD_NUM - 1:0] wr_word_en,
    input [DATA_BYTE_NUM - 1:0] wr_byte_en,  // byte enable
    // verilog does not support 2d array as ports
    output [TAG_BITS - 1:0] tag_data_way0,
    output [TAG_BITS - 1:0] tag_data_way1,
    output [WHOLE_DATA_WIDTH - 1:0] rd_data_way0,
    output [WHOLE_DATA_WIDTH - 1:0] rd_data_way1
);  

    CacheWay M_Cache_way0 (
        .clk(clk),
        .wr_en(wr_en & way_select[0]),
        .wr_tag_en(wr_tag_en & way_select[0]), 
        .addr(addr),
        .wr_data(wr_data),
        .wr_tag(wr_tag),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .tag_data(tag_data_way0),
        .rd_data(rd_data_way0)
    );
    
    CacheWay M_Cache_way1 (
        .clk(clk),
        .wr_en(wr_en & way_select[1]),
        .wr_tag_en(wr_tag_en & way_select[1]), 
        .addr(addr),
        .wr_data(wr_data),
        .wr_tag(wr_tag),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .tag_data(tag_data_way1),
        .rd_data(rd_data_way1)
    );
    
endmodule
