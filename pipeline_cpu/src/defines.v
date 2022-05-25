`timescale 1ns / 1ps

`define R_OP       7'b0110011
`define I_MEM_OP   7'b0000011
`define I_LOGIC_OP 7'b0010011
`define I_JALR_OP  7'b1100111
`define S_OP       7'b0100011
`define B_OP       7'b1100011
`define U_LUI_OP   7'b0110111
`define U_AUIPC_OP 7'b0010111
`define J_OP       7'b1101111

`define LB   3'b001
`define LBU  3'b010
`define LH   3'b011
`define LHU  3'b100
`define LW   3'b101

`define SB  2'b01
`define SH  2'b10
`define SW  2'b11

`define BEQ  3'b010
`define BNE  3'b011
`define BLT  3'b100
`define BGE  3'b101
`define BLTU  3'b110
`define BGEU  3'b111

`define I_TYPE_IMM  3'b001
`define S_TYPE_IMM  3'b010
`define B_TYPE_IMM  3'b011
`define J_TYPE_IMM  3'b100
`define U_TYPE_IMM  3'b101

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

`define NOFORWARD 2'b00
`define FORWARD_A_MEM 2'b01
`define FORWARD_A_WB  2'b10
`define FORWARD_B_MEM 2'b01
`define FORWARD_B_WB  2'b10
`define FORWARD_WRITEMEM_MEM 2'b01
`define FORWARD_WRITEMEM_ALU 2'b10
