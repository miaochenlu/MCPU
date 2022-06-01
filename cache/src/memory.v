`timescale 1ns / 1ps

`define MEM_INDEX_MSB 10
`define MEM_INDEX_LSB 4

module Memory (
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] rd_addr,
    input [31:0] wr_addr,
    input [127:0] wr_data,
    output reg mem_rd_data_valid,
    output reg mem_wr_data_ready,
    output reg [127:0] rd_data
);
            
    reg [127:0] mem[127:0];
    wire [6:0] rd_index = rd_addr[`MEM_INDEX_MSB:`MEM_INDEX_LSB];
    wire [6:0] wr_index = wr_addr[`MEM_INDEX_MSB:`MEM_INDEX_LSB];
    initial begin
        $readmemh("ram.hex", mem);
    end
    
    always @(posedge clk) begin
        mem_rd_data_valid = 0;
        if(mem_read) begin
            rd_data <= mem[rd_index];
            mem_rd_data_valid <= 1;
        end
    end

    always @(negedge clk) begin
        mem_wr_data_ready <= 0;
        if(mem_write) begin
            mem[wr_index] <= wr_data;
            mem_wr_data_ready <= 1;
        end
    end
   
endmodule