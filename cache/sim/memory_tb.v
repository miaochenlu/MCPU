`timescale 1ns / 1ps

module memory_tb();
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] rd_addr;
    reg [31:0] wr_addr;
    reg [127:0] wr_data;
    wire mem_rd_data_valid;
    wire mem_wr_data_ready;
    wire [127:0] rd_data;
    
    reg [4:0] index;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    integer i = 0;
    initial begin
//        for(i = 0; i < 32; i = i + 1) begin
//            index = i;
//            #1 rd_addr = {23'b0, index, 4'b0}; mem_read = 1;
//            #1;
//        end
        
        for(i = 0; i < 32; i = i + 1) begin
            index = i;
            #2 wr_addr = {23'b0, index, 4'b0}; mem_read = 0; mem_write = 1; wr_data = i;
            #2 mem_write = 0; mem_read = 0;
            #2 rd_addr = {23'b0, index, 4'b0}; mem_read = 1;
        end
    end
    
    Memory test_mem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .mem_rd_data_valid(mem_rd_data_valid),
        .mem_wr_data_ready(mem_wr_data_ready),
        .rd_data(rd_data)
    );
endmodule