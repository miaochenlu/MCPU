`timescale 1ns / 1ps
`include "defines.vh"

module CDB (
    // ALU
    input [31:0]                    CDB_ALUData_in,
    input [`ROB_ENTRY_WIDTH - 1:0]  CDB_ALUDest_in,
    output [31:0]                   CDB_ALUData_out,
    output [`ROB_ENTRY_WIDTH - 1:0] CDB_ALUDest_out,

    // LSQ
    input [31:0]                    CDB_LSQData_in,
    input [`ROB_ENTRY_WIDTH - 1:0]  CDB_LSQDest_in,
    output [31:0]                   CDB_LSQData_out,
    output [`ROB_ENTRY_WIDTH - 1:0] CDB_LSQDest_out,

    // BRA
    input                           CDB_BRAJump_en_in,
    input [31:0]                    CDB_BRAJumpAddr_in,
    input [31:0]                    CDB_BRAData_in,
    input [`ROB_ENTRY_WIDTH - 1:0]  CDB_BRADest_in,
    output                          CDB_BRAJump_en_out,
    output [31:0]                   CDB_BRAJumpAddr_out,    
    output [31:0]                   CDB_BRAData_out,
    output [`ROB_ENTRY_WIDTH - 1:0] CDB_BRADest_out
);

    assign CDB_ALUData_out            = CDB_ALUData_in;
    assign CDB_ALUDest_out            = CDB_ALUDest_in;

    assign CDB_LSQData_out            = CDB_LSQData_in;
    assign CDB_LSQDest_out            = CDB_LSQDest_in;

    assign CDB_BRAJump_en_out         = CDB_BRAJump_en_in;
    assign CDB_BRAJumpAddr_out        = CDB_BRAJumpAddr_in;
    assign CDB_BRAData_out            = CDB_BRAData_in;
    assign CDB_BRADest_out            = CDB_BRADest_in;

endmodule