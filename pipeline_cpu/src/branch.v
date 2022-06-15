`timescale 1ns / 1ps
`include "defines.vh"

module Branch (
    input [31:0] CmpSrcA,
    input [31:0] CmpSrcB,
    input [ 2:0] BrType,
    output       BranchRes
);
    
    assign BranchRes = ((BrType == `BEQ ) & (CmpSrcA == CmpSrcB))
                     | ((BrType == `BNE ) & (CmpSrcA != CmpSrcB))
                     | ((BrType == `BLT ) & ($signed(CmpSrcA) < $signed(CmpSrcB)))
                     | ((BrType == `BGE ) & ($signed(CmpSrcA) > $signed(CmpSrcB)))
                     | ((BrType == `BLTU) & (CmpSrcA < CmpSrcB))
                     | ((BrType == `BGEU) & (CmpSrcA >= CmpSrcB));
                     
endmodule
