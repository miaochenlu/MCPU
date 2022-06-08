`timescale 1ns / 1ps

module RSALU #(
    parameter integer RS_ENTRY_NUM = 2,
    parameter integer ROB_ENTRY_WIDTH = 8
) 
(
    input clk,
    input rst,
    output full,

    // issue in
    input [5:0] Op_in,
    input [31:0] Vj_in,
    input [31:0] Vk_in,
    input [ROB_ENTRY_WIDTH - 1:0] Qj_in,
    input [ROB_ENTRY_WIDTH - 1:0] Qk_in,
    input [ROB_ENTRY_WIDTH - 1:0] Dest_in,
    input [31:0] A_in

    // to function unit
    output [5:0] Op_out,
    output [31:0] Vj_out,
    output [31:0] Vk_out,

    output [ROB_ENTRY_WIDTH - 1:0] Dest_out,
    input [31:0] A_in
);
    reg Busy[RS_ENTRY_NUM - 1: 0];
    // the operation
    reg [5:0] Op[RS_ENTRY_NUM - 1: 0];
    // the value of the source operands
    reg [31:0] Vj[RS_ENTRY_NUM - 1: 0];
    reg [31:0] Vk[RS_ENTRY_NUM - 1: 0];
    // the reorder buffer index that produce the value 
    reg [ROB_ENTRY_WIDTH - 1:0] Qj[RS_ENTRY_NUM - 1: 0];
    reg [ROB_ENTRY_WIDTH - 1:0] Qk[RS_ENTRY_NUM - 1: 0];
    reg [ROB_ENTRY_WIDTH - 1:0] Dest[RS_ENTRY_NUM - 1: 0];
    // memory address
    reg [31:0] A[RS_ENTRY_NUM - 1: 0]; 
endmodule