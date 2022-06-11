`timescale 1ns / 1ps

module BRA(
    input [ 3:0]  BRAOp,
    input [31:0] BRASrcA,
    input [31:0] BRASrcB,
    input [31:0] PC,
    input [31:0] Offset,
    input [`ROB_ENTRY_WIDTH - 1:0] Dest_in,

    output reg busy,
    output reg Jump_en,
    output reg [31:0] JumpAddr,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out
);
    always @(*) begin
        busy = (BRAOp == 0) ? 1'd0 : 1'd1;
        Dest_out = Dest_in;

        case(BRAOp)
            `BEQ:  begin
                Jump_en = (BRASrcA == BRASrcB);
                if(Jump_en) 
                    JumpAddr = PC + Offset;
                else 
                    JumpAddr = PC + 32'd4;
            end
            `BNE:  begin
                Jump_en = (BRASrcA != BRASrcB);
                if(Jump_en) 
                    JumpAddr = PC + Offset;
                else 
                    JumpAddr = PC + 32'd4;
            end
        endcase
    end

endmodule
