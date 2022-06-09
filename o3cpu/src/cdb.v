`timescale 1ns / 1ps
`include "defines.vh"

module CDB #(
    parameter integer RS_ENTRY_NUM = 2,
    parameter integer RS_ENTRY_WIDTH = 1,
    parameter integer ROB_ENTRY_WIDTH = 8
) 
(
    input           ALURes_ready,
    input [31:0]    ALUData_in,
    input [ROB_ENTRY_WIDTH - 1:0] ALUDest_in,
    output          ALURes_rec,
    output [31:0]   ALUData_out,
    output [ROB_ENTRY_WIDTH - 1:0] ALUDest_out
);

    assign ALUData_out = ALURes_ready ? ALUData_in : 32'd0;
    assign ALUDest_out = ALURes_ready ? ALUDest_in : {ROB_ENTRY_WIDTH{0}};
    assign ALURes_rec  = ALURes_ready;

endmodule