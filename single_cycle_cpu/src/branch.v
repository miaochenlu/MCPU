`timescale 1ns / 1ps

module Branch (
    input [31:0] CmpSrcA,
    input [31:0] CmpSrcB,
    input [2:0] BrType,
    output BranchRes
);
    
    parameter BEQ = 3'b010;
    parameter BNE = 3'b011;
    parameter BLT = 3'b100;
    parameter BGE = 3'b101;
    parameter BLTU = 3'b110;
    parameter BGEU = 3'b111;
    
    assign BranchRes = ((BrType == BEQ) & (CmpSrcA == CmpSrcB))
                     | ((BrType == BNE) & (CmpSrcA != CmpSrcB))
                     | ((BrType == BLT) & ($signed(CmpSrcA) < $signed(CmpSrcB)))
                     | ((BrType == BGE) & ($signed(CmpSrcA) > $signed(CmpSrcB)))
                     | ((BrType == BLTU) & (CmpSrcA < CmpSrcB))
                     | ((BrType == BGEU) & (CmpSrcA >= CmpSrcB));
                     
endmodule
