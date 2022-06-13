`timescale 1ns / 1ps
`include "defines.vh"

module HazardUnit(
    input [2:0] FUType,
    input       ROB_full,
    input       RSALU_full,
    input       RSLSQ_full,
    input       RSBRA_full,
    input       MisPredict,

    output      PC_EN_IF,
    output      IF_ID_Stall,
    output      IF_ID_Flush,
    output      ID_RN_Flush,
    output      RN_RO_Flush,
    output      RO_DP_Flush,
    output      ROB_rollback,
    output      RAT_rollback,
    output      RSLSQ_rollback,
    output      RSALU_rollback,
    output      RSBRA_rollback
);

    wire ControlStall = ROB_full
                      | (FUType == `FU_ALU && RSALU_full)
                      | (FUType == `FU_LSQ && RSLSQ_full)
                      | (FUType == `FU_BRA && RSBRA_full);


    assign PC_EN_IF       = ~ControlStall;
    assign IF_ID_Stall    = ControlStall;
    assign IF_ID_Flush    = MisPredict;

    assign ROB_rollback   = MisPredict;
    assign RAT_rollback   = MisPredict;
    assign RSLSQ_rollback = MisPredict;
    assign RSALU_rollback = MisPredict;
    assign RSBRA_rollback = MisPredict;

    assign ID_RN_Flush    = MisPredict | ControlStall;
    assign RN_RO_Flush    = MisPredict | ControlStall;
    assign RO_DP_Flush    = MisPredict | ControlStall;


endmodule