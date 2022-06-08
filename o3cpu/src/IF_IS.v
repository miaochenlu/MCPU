`timescale 1ns / 1ps

module IF_IS(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,
    input [31:0] PC_IF,
    input [31:0] inst_IF,
    
    output reg [31:0] PC_IS,
    output reg [31:0] inst_IS
);

    always @(posedge clk) begin
        if(rst) begin
            PC_IS <= 0;
            inst_IS <= 0;
        end
        else if(EN) begin
            if(stall) begin
                PC_IS   <= PC_IS;
                inst_IS <= inst_IS;
            end
            else if(flush) begin
                PC_IS   <= PC_IS;
                inst_IS <= 32'h00002003; // nop lw zero, 0(zero)
            end
            else begin
                PC_IS   <= PC_IF;
                inst_IS <= inst_IF;
            end
        end
        else begin
            PC_IS   <= PC_IS;
            inst_IS <= inst_IS;
        end
    end
    
    
endmodule