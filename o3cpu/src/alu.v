`timescale 1ns / 1ps
`include "defines.vh"

module ALU (
    input [`ALU_OP_WIDTH - 1:0]         ALUOp,
    input [31:0]                        ALUSrcA,
    input [31:0]                        ALUSrcB,
    input [`ROB_ENTRY_WIDTH - 1:0]      Dest_in,

    output reg                          busy,
    output reg                          res_ready,
    output reg [31:0]                   res,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out,
    output                              zero,
    output                              overflow
);


    always @(*) begin
        res_ready = 1'd0;
        busy      = (ALUOp == 0) ? 1'd0 : 1'd1;
        Dest_out  = Dest_in;

        case(ALUOp)
            `ADD:  res = ALUSrcA + ALUSrcB;
            `SUB:  res = ALUSrcA - ALUSrcB;
            `AND:  res = ALUSrcA & ALUSrcB;
            `OR :  res = ALUSrcA | ALUSrcB;
            `XOR:  res = ALUSrcA ^ ALUSrcB;
            `SLL:  res = ALUSrcA << ALUSrcB[4:0];
            `SRL:  res = ALUSrcA >> ALUSrcB[4:0];
            `SLT:  res = ($signed(ALUSrcA) < $signed(ALUSrcB)) ? 32'd1 : 32'd0;
            `SLTU: res = (ALUSrcA < ALUSrcB) ? 32'd1 : 32'd0;
            `SRA:  res = $signed(ALUSrcA) >>> ALUSrcB[4:0]; // arithemic shift >>>
            `OUTB: res = ALUSrcB;
            default: res = 32'd0;
        endcase
        res_ready = 1'd1;
    end

    // overflow detection
    wire addOverflow, subOverflow;
    assign addOverflow = ( ALUSrcA[31] &  ALUSrcB[31] & ~res[31]) 
                        |(~ALUSrcA[31] & ~ALUSrcB[31] &  res[31]);

    assign subOverflow = (~ALUSrcA[31] &  ALUSrcB[31] &  res[31])
                        |( ALUSrcA[31] & ~ALUSrcB[31] & ~res[31]);

    assign overflow = ((ALUOp == `ADD) & addOverflow)
                     |((ALUOp == `SUB) & subOverflow);

    assign zero = ~|res;

endmodule