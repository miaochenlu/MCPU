`timescale 1ns / 1ps
`include "defines.vh"

module BRA(
    input [`BRA_OP_WIDTH - 1:0]         BRAOp,
    input [31:0]                        BRASrcA,
    input [31:0]                        BRASrcB,
    input [31:0]                        PC,
    input [31:0]                        Offset,
    input [`ROB_ENTRY_WIDTH - 1:0]      Dest_in,

    output reg                          busy,
    output reg                          res_ready,
    output reg                          Jump_en,
    output reg [31:0]                   JumpAddr,
    output reg [31:0]                   Dest_val,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out
);
    always @(*) begin
        busy      = (BRAOp == 0) ? 1'd0 : 1'd1;
        Jump_en   = 0;
        JumpAddr  = 0;
        Dest_val  = 0;
        res_ready = 1'd0;
        
        Dest_out  = Dest_in;

        case(BRAOp)
            `BEQ:  begin
                Jump_en = (BRASrcA == BRASrcB);
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `BNE:  begin
                Jump_en = (BRASrcA != BRASrcB);
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `BLT: begin
                Jump_en = ($signed(BRASrcA) < $signed(BRASrcB));
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `BGE: begin
                Jump_en = ($signed(BRASrcA) > $signed(BRASrcB));
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `BLTU:  begin
                Jump_en = (BRASrcA < BRASrcB);
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `BGEU:  begin
                Jump_en = (BRASrcA >= BRASrcB);
                JumpAddr = Jump_en ? PC + Offset : PC + 32'd4;
            end
            `JAL: begin
                Jump_en = 1'd1;
                JumpAddr = PC + Offset;
                Dest_out = Dest_in;
                Dest_val = PC + 32'd4;
            end
            `JALR: begin
                Jump_en = 1'd1;
                JumpAddr = BRASrcA + Offset;
                Dest_out = Dest_in;
                Dest_val = PC + 32'd4;
            end
            default: begin
                Jump_en = 1'd0;
                Dest_out = 0;
            end
        endcase
        res_ready = 1'd1;
    end

endmodule
