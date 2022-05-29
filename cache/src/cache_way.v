`timescale 1ns / 1ps

module CacheWay # (
    parameter integer ADDR_WIDTH = 5,
    parameter integer WHOLE_DATA_WIDTH = 128,
    parameter integer BANK_DATA_WIDTH = 32,
    parameter integer DATA_BYTE_NUM = 4,
    parameter integer DATA_WORD_NUM = 4,
    parameter integer TAG_BITS = 23
)
(
    input clk,
    input wr_en,
    input wr_tag_en,
    input [ADDR_WIDTH - 1:0] addr,
    input [WHOLE_DATA_WIDTH - 1:0] wr_data,
    input [TAG_BITS - 1:0] wr_tag,
    input [DATA_WORD_NUM - 1:0] wr_word_en,
    input [DATA_BYTE_NUM - 1:0] wr_byte_en,  // byte enable
    output [TAG_BITS - 1:0] tag_data,
    output [WHOLE_DATA_WIDTH - 1:0] rd_data
);

    reg [TAG_BITS:0] TagValid[(1 << ADDR_WIDTH) - 1:0];
//    reg Dirty[(1 << ADDR_WIDTH) - 1:0];
    
    assign tag_data = TagValid[addr][0] ? TagValid[addr][TAG_BITS:1] : {TAG_BITS{0}};
    
    integer i;
    initial begin
        for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
            TagValid[i] <= 0;
//            Dirty[i] <= 0;
        end
    end
        
    
    always @(posedge clk) begin
        if(wr_tag_en) begin
            TagValid[addr][0] <= 1; // valid
            TagValid[addr][TAG_BITS:1] <= wr_tag;
        end
    end
    
    wire write_bank0, write_bank1, write_bank2, write_bank3;
    assign write_bank0 = wr_en & wr_word_en[0];
    assign write_bank1 = wr_en & wr_word_en[1];
    assign write_bank2 = wr_en & wr_word_en[2];
    assign write_bank3 = wr_en & wr_word_en[3];
    
    wire [31:0] write_data_bank0 = wr_data[31:0];
    wire [31:0] write_data_bank1 = wr_data[63:32];
    wire [31:0] write_data_bank2 = wr_data[95:64];
    wire [31:0] write_data_bank3 = wr_data[127:96];
    
    // 4 words per cache line
    CacheRAM Bank0 (
        .clk(clk), 
        .wr_en(write_bank0), 
        .wr_addr(addr), 
        .wr_data(write_data_bank0), 
        .wr_byte_en(wr_byte_en), 
        .rd_addr(addr), 
        .rd_data(rd_data[31:0])
    );
    
    CacheRAM Bank1 (
        .clk(clk), 
        .wr_en(write_bank1), 
        .wr_addr(addr), 
        .wr_data(write_data_bank1), 
        .wr_byte_en(wr_byte_en), 
        .rd_addr(addr), 
        .rd_data(rd_data[63:32])
    );
    
    CacheRAM Bank2 (
        .clk(clk), 
        .wr_en(write_bank2), 
        .wr_addr(addr), 
        .wr_data(write_data_bank2), 
        .wr_byte_en(wr_byte_en), 
        .rd_addr(addr), 
        .rd_data(rd_data[95:64])
    );
    
    CacheRAM Bank3 (
        .clk(clk), 
        .wr_en(write_bank3), 
        .wr_addr(addr), 
        .wr_data(write_data_bank3), 
        .wr_byte_en(wr_byte_en), 
        .rd_addr(addr), 
        .rd_data(rd_data[127:96])
    );
    
endmodule
