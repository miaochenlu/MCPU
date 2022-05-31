`timescale 1ns / 1ps

`define TAG_MSB 31
`define TAG_LSB 9
`define INDEX_MSB 8
`define INDEX_LSB 4

module CacheContoller # (
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
    // cpu side port
    input wr_en,
    input [31:0] addr,
    input [1:0] wr_ctrl,
    input [2:0] rd_ctrl,
    input [31:0] wr_data,
    output reg [31:0] rd_data,

    // mem side port
    input  [31:0] mem_addr,
    input  [127:0] mem_rd_data,
    output mem_read,
    output mem_write,
    output [127:0] mem_wr_data,
);
    localparam integer
        ST_IDLE = 3'd0,
        ST_LKUP = 3'd1,
        ST_WBAC = 3'd2,
        ST_REFL = 3'd3;

    wire [1:0] wr_word_en = addr[3:2];
    wire [1:0] wr_byte_en = addr[1:0];
    wire [4:0] set_index  = addr[INDEX_MSB:INDEX_LSB];
    wire [TAG_BITS - 1] addr_tag = addr[TAG_MSB:TAG_LSB];

    reg cache_write;
    reg refill;
    reg [CACHE_WAY_NUM - 1:0]    way_select,
    reg [CACHE_WAY_NUM - 1:0]    valid,
    reg [CACHE_WAY_NUM - 1:0]    hit,
    reg [CACHE_WAY_NUM - 1:0]    modify,
    reg [TAG_BITS - 1:0]         out_tag_way0,
    reg [TAG_BITS - 1:0]         out_tag_way1,
    reg [WHOLE_DATA_WIDTH - 1:0] rd_data_way0,
    reg [WHOLE_DATA_WIDTH - 1:0] rd_data_way1



    Cache2Way M_Cache2Way (
        .clk(clk),
        .wr_en(cache_write),
        .refill(refill),
        .addr(set_index),
        .in_tag(addr_tag),
        .way_select(way_select),
        .wr_data(wr_data),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .valid(valid),
        .hit(hit),
        .modify(modify),
        .out_tag_way0(out_tag_way0),
        .out_tag_way1(out_tag_way1),
        .rd_data_way0(rd_data_way0),
        .rd_data_way1(rd_data_way1)
    );
endmodule