`timescale 1ns / 1ps
`include "defines.vh"

module HazardUnit(
    input [2:0] FUType,
    input       ROB_full,
    input       RSALU_full,
    input       RSLSQ_full,
    input       RSBRA_full,
    input       MisPredict,

    output reg  stall,
    output reg  flush
);

    always @(*) begin
        if(MisPredict) 
            flush = 1'd1
        else 
            flush = 1'd0;

        if(ROB_full) begin
            stall = 1'd1;
        end
        else if(FUType == `FU_ALU && RSALU_full) begin
            stall = 1'd1;
        end
        else if(FUType == `FU_LSQ && RSLSQ_full) begin
            stall = 1'd1;
        end
        else if(FUType == `FU_BRA && RSBRA_full) begin
            stall = 1'd1;
        end
        else 
            stall = 1'd0;
    end

endmodule