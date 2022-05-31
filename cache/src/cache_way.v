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
    input wr_en,                                // enable write
    input refill,                               // refill using memory read data?
    input [ADDR_WIDTH - 1:0] addr,              // index
    input [TAG_BITS - 1:0] in_tag,              // input tag
    input [WHOLE_DATA_WIDTH - 1:0] wr_data,     // write data
    input [DATA_WORD_NUM - 1:0] wr_word_en,     // word enable
    input [DATA_BYTE_NUM - 1:0] wr_byte_en,     // byte enable                               
    output [TAG_BITS - 1:0] out_tag,            // read tag
    output [WHOLE_DATA_WIDTH - 1:0] rd_data,    // read data
    output valid,                               // valid data ?
    output hit,                                 // cache hit ?
    output modify                               // data modified ?
);

    /******************** Tag & Valid & Dirty *************************/
    reg [TAG_BITS - 1:0] Tag[(1 << ADDR_WIDTH) - 1:0];
    reg Valid[(1 << ADDR_WIDTH) - 1:0];
    reg Dirty[(1 << ADDR_WIDTH) - 1:0];
    
    /******************* judge hit miss ... **************************/
    assign valid = Valid[addr];
    assign hit = valid && (Tag[addr] == in_tag);
    assign modify = valid && Dirty[addr];
    assign out_tag = Tag[addr];
    

    integer i;
    initial begin
        for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
            Tag[i]   <= 0;
            Valid[i] <= 0;
            Dirty[i] <= 0;
        end
    end
        
    
    always @(posedge clk) begin
        if(wr_en) begin
            // if write tag when read miss, dirty is 0
            if(refill) begin
                Valid[addr] <= 1; Dirty[addr] <= 0; Tag[addr]   <= in_tag;
            end
            /***********************************why********************************/
            else if(modify && ~hit) begin
                Valid[addr] <= 1; Dirty[addr] <= 1; Tag[addr] <= in_tag;
            end
            else begin
                Valid[addr] <= 1; Dirty[addr] <= 1;
            end
        end
    end

    wire write_bank0 = wr_en & wr_word_en[0];
    wire write_bank1 = wr_en & wr_word_en[1];
    wire write_bank2 = wr_en & wr_word_en[2];
    wire write_bank3 = wr_en & wr_word_en[3];
    
    wire [31:0] write_data_bank0 = wr_data[ 31: 0];
    wire [31:0] write_data_bank1 = wr_data[ 63:32];
    wire [31:0] write_data_bank2 = wr_data[ 95:64];
    wire [31:0] write_data_bank3 = wr_data[127:96];
    
    // 4 words per cache line
    CacheRAM Bank0 (.clk(clk), .wr_en(write_bank0), .wr_addr(addr), .wr_data(write_data_bank0), .wr_byte_en(wr_byte_en), .rd_addr(addr), .rd_data(rd_data[31:0]));
    CacheRAM Bank1 (.clk(clk), .wr_en(write_bank1), .wr_addr(addr), .wr_data(write_data_bank1), .wr_byte_en(wr_byte_en), .rd_addr(addr), .rd_data(rd_data[63:32]));
    CacheRAM Bank2 (.clk(clk), .wr_en(write_bank2), .wr_addr(addr), .wr_data(write_data_bank2), .wr_byte_en(wr_byte_en), .rd_addr(addr), .rd_data(rd_data[95:64]));
    CacheRAM Bank3 (.clk(clk), .wr_en(write_bank3), .wr_addr(addr), .wr_data(write_data_bank3), .wr_byte_en(wr_byte_en), .rd_addr(addr), .rd_data(rd_data[127:96]));
    
endmodule
