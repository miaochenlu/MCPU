`timescale 1ns / 1ps

`define RSALU_ENTRY_NUM 3
`define RSALU_ENTRY_WIDTH 2 
`define ALU_OP_WIDTH 4

`define RSBRA_ENTRY_NUM 3
`define RSBRA_ENTRY_WIDTH 2
`define BRA_OP_WIDTH 4

`define RSLSQ_ENTRY_NUM 3
`define RSLSQ_ENTRY_WIDTH 2
`define LSQ_OP_WIDTH 4

`define ROB_ENTRY_NUM 15
`define ROB_ENTRY_WIDTH 4


`define FU_EMP 3'd0 // empty
`define FU_ALU 3'd1 // integer ALU
`define FU_LSQ 3'd2 // load/store unit
`define FU_BRA 3'd3 // jump, branch

`define R_OP       7'b0110011
`define I_MEM_OP   7'b0000011
`define I_LOGIC_OP 7'b0010011
`define I_JALR_OP  7'b1100111
`define S_OP       7'b0100011
`define B_OP       7'b1100011
`define U_LUI_OP   7'b0110111
`define U_AUIPC_OP 7'b0010111
`define J_OP       7'b1101111

`define I_TYPE_IMM  3'b001
`define S_TYPE_IMM  3'b010
`define B_TYPE_IMM  3'b011
`define J_TYPE_IMM  3'b100
`define U_TYPE_IMM  3'b101

`define LB   4'b0001
`define LBU  4'b0010
`define LH   4'b0011
`define LHU  4'b0100
`define LW   4'b0101
`define SB   4'b1001
`define SH   4'b1010
`define SW   4'b1011

`define BEQ   4'b0010
`define BNE   4'b0011
`define BLT   4'b0100
`define BGE   4'b0101
`define BLTU  4'b0110
`define BGEU  4'b0111
`define JAL   4'b1001
`define JALR  4'b1010

`define ADD   4'b0001
`define SUB   4'b0010
`define AND   4'b0011
`define OR    4'b0100
`define XOR   4'b0101
`define SLL   4'b0110
`define SRL   4'b0111
`define SLT   4'b1000
`define SLTU  4'b1001
`define SRA   4'b1010
`define AP4   4'b1011
`define OUTB  4'b1100