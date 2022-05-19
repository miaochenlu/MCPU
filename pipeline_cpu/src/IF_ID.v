`timescale 1ns / 1ps

module IF_ID(
    input clk,
    input rst,
    input EN,
    input [31:0] PC_IF,
    input [31:0] inst_IF,
    
    output [31:0] PC_ID,
    output [31:0] inst_ID
);

    reg [31:0] PC_ID_Reg;
    reg [31:0] inst_ID_Reg;
    
    always @(posedge clk) begin
        if(rst) begin
            PC_ID_Reg <= 0;
            inst_ID_Reg <= 0;
        end
        else if(EN) begin
            PC_ID_Reg <= PC_IF;
            inst_ID_Reg <= inst_IF;
        end
        else begin
            PC_ID_Reg <= PC_ID_Reg;
            inst_ID_Reg <= inst_ID_Reg;
        end
    end
    
    assign PC_ID = PC_ID_Reg;
    assign inst_ID = inst_ID_Reg;
    
endmodule
