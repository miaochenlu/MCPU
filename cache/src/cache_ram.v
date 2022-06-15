`timescale 1ns / 1ps

module CacheRAM #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH = 5,
    parameter integer DATA_BYTE_NUM = 4
)
(
    input clk,
    input rst,
    input                           wr_en,
    input [ADDR_WIDTH - 1:0]        wr_addr,
    input [DATA_WIDTH - 1:0]        wr_data,
    input [DATA_BYTE_NUM - 1:0]     wr_byte_en,  // byte enable
    input [ADDR_WIDTH - 1:0]        rd_addr,
    output reg                      write_ready,
    output reg [DATA_WIDTH - 1:0]   rd_data
);
    
    // data store
    reg [DATA_WIDTH - 1:0] mem[(1 << ADDR_WIDTH) - 1:0];
    
    integer i;
    initial begin
        for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
            mem[i] = 0;
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
                mem[i] = 0;
            end
        end
        else begin
            // write
            if(wr_en) begin
                for(i = 0; i < DATA_BYTE_NUM; i = i + 1) begin
                    if(wr_byte_en[i])
                        mem[wr_addr][i * 8 + 7 -: 8] <= wr_data[i * 8 + 7 -: 8];
                end
                write_ready <= 1;
            end
            else begin
                // read
                rd_data     <= mem[rd_addr];
                write_ready <= 0;
            end
        end
    end

endmodule
