`timescale 1ns / 1ps
`include "defines.v"

module RAM (
    input clk,
    input wr_en,
    input [1:0] wr_ctrl,
    input [2:0] rd_ctrl,
    input [31:0] wr_addr,
    input [31:0] wr_data,
    input [31:0] rd_addr,
    output reg [31:0] rd_data
);
            
    reg [7:0] mem[127:0];
    
    initial begin
        $readmemh("ram.hex", mem);
    end
    
    always @(*) begin
        if(rd_addr[31:7]) rd_data = 0;
        else begin
            case(rd_ctrl)
                `LB:  rd_data = {{24{mem[rd_addr[6:0]][7]}}, mem[rd_addr[6:0]]}; //sign extension
                `LBU: rd_data = {24'b0, mem[rd_addr[6:0]]};
                `LH:  rd_data = {{16{mem[rd_addr[6:0] + 1]}}, mem[rd_addr[6:0] + 1], mem[rd_addr[6:0]]};
                `LHU: rd_data = {16'b0, mem[rd_addr[6:0] + 1], mem[rd_addr[6:0]]};
                `LW : rd_data = {mem[rd_addr[6:0] + 3], mem[rd_addr[6:0] + 2], mem[rd_addr[6:0] + 1], mem[rd_addr[6:0]]};
                default: rd_data = 32'b0;
            endcase
        end
    end
    
    always @(posedge clk) begin
        if(wr_en & ~|wr_addr[31:7]) begin
            case(wr_ctrl)
                `SB: mem[wr_addr[6:0]] <= wr_data[7:0];
                `SH: begin
                        mem[wr_addr[6:0] + 1] <= wr_data[15:8];
                        mem[wr_addr[6:0]] <= wr_data[7:0];
                    end
                `SW: begin
                        mem[wr_addr[6:0] + 3] <= wr_data[31:24];
                        mem[wr_addr[6:0] + 2] <= wr_data[23:16];
                        mem[wr_addr[6:0] + 1] <= wr_data[15:8];
                        mem[wr_addr[6:0]] <= wr_data[7:0];
                    end
                default: mem[wr_addr[6:0]] <= mem[wr_addr[6:0]];
            endcase
        end
    end
endmodule
