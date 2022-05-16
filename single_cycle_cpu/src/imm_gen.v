`timescale 1ns / 1ps

module ImmGen(
    input [31:0] inst,
    input [2:0] ImmSel,
    output [31:0] imm
);
    
    parameter I_TYPE_IMM = 3'b001;
    parameter S_TYPE_IMM = 3'b010;
    parameter B_TYPE_IMM = 3'b011;
    parameter J_TYPE_IMM = 3'b100;
    parameter U_TYPE_IMM = 3'b101;
    
    assign imm = ({32{ImmSel == I_TYPE_IMM}} & ({{20{inst[31]}}, inst[31:20]}))
                |({32{ImmSel == S_TYPE_IMM}} & ({{20{inst[31]}}, inst[31:25], inst[11:7]}))
                |({32{ImmSel == J_TYPE_IMM}} & ({{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0}))
                |({32{ImmSel == B_TYPE_IMM}} & ({{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}))
                |({32{ImmSel == U_TYPE_IMM}} & ({inst[31:12], 12'b0}))
                ;
endmodule
