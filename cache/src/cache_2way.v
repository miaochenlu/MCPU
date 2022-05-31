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
    input refill,
    input [ADDR_WIDTH - 1:0]        addr,
    input [TAG_BITS - 1:0]          in_tag,
    input [CACHE_WAY_NUM - 1:0]     way_select,
    input [WHOLE_DATA_WIDTH - 1:0]  wr_data,
    input [DATA_WORD_NUM - 1:0]     wr_word_en,
    input [DATA_BYTE_NUM - 1:0]     wr_byte_en,

    output [CACHE_WAY_NUM - 1:0]    valid,
    output [CACHE_WAY_NUM - 1:0]    hit,
    output [CACHE_WAY_NUM - 1:0]    modify,
    output [TAG_BITS - 1:0]         out_tag_way0,
    output [TAG_BITS - 1:0]         out_tag_way1,
    output [WHOLE_DATA_WIDTH - 1:0] rd_data_way0,
    output [WHOLE_DATA_WIDTH - 1:0] rd_data_way1,
    output [CACHE_WAY_NUM - 1:0]    write_data_ready
);  

    CacheWay M_Cache_way0 (
        .clk        (clk),
        .wr_en      (wr_en & way_select[0]),
        .refill     (refill),
        .addr       (addr),
        .in_tag     (in_tag),
        .wr_data    (wr_data),
        .wr_word_en (wr_word_en),
        .wr_byte_en (wr_byte_en),
        .out_tag    (out_tag_way0),
        .rd_data    (rd_data_way0),
        .valid      (valid[0]),
        .hit        (hit[0]),
        .modify     (modify[0]),
        .write_data_ready(write_data_ready[0])
    );
    
    CacheWay M_Cache_way1 (
        .clk        (clk),
        .wr_en      (wr_en & way_select[1]),
        .refill     (refill),
        .addr       (addr),
        .in_tag     (in_tag),
        .wr_data    (wr_data),
        .wr_word_en (wr_word_en),
        .wr_byte_en (wr_byte_en),
        .out_tag    (out_tag_way1),
        .rd_data    (rd_data_way1),
        .valid      (valid[1]),
        .hit        (hit[1]),
        .modify     (modify[1]),
        .write_data_ready(write_data_ready[1])
    );
    
endmodule
