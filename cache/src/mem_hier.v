`timescale 1ns / 1ps

module MemHier(
    input clk,
    input rst,
    
    input           read_req,
    input           write_req,
    input [31:0]    addr,
    input [ 1:0]    wr_ctrl,
    input [ 2:0]    rd_ctrl,
    input [31:0]    wr_data,
    output          rd_data_valid,
    output          wr_ready,
    output [31:0]   rd_data
);
    
    wire        mem_rd_data_valid;
    wire        mem_wr_data_ready;
    wire [31:0] mem_read_addr;
    wire [31:0] mem_write_addr;
    wire        mem_read;
    wire        mem_write;
    wire [127:0] mem_wr_data;
    wire [127:0] mem_rd_data;
    
    CacheController M_CacheController (
        .clk(clk),
        .rst(rst),
        .read_req(read_req),
        .write_req(write_req),
        .addr(addr),
        .wr_ctrl(wr_ctrl),
        .rd_ctrl(rd_ctrl),
        .wr_data(wr_data),
        .rd_data_valid(rd_data_valid),
        .wr_ready(wr_ready),
        .rd_data(rd_data),
        .mem_rd_data(mem_rd_data),
        .mem_rd_data_valid(mem_rd_data_valid),
        .mem_wr_data_ready(mem_wr_data_ready),
        .mem_read_addr(mem_read_addr),
        .mem_write_addr(mem_write_addr),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_wr_data(mem_wr_data)
    );
    
    Memory M_Memory (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .rd_addr(mem_read_addr),
        .wr_addr(mem_write_addr),
        .wr_data(wr_data),
        .mem_rd_data_valid(mem_rd_data_valid),
        .mem_wr_data_ready(mem_wr_data_ready),
        .rd_data(mem_rd_data)
    );
endmodule
