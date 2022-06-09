`timescale 1ns / 1ps
`include "defines.vh"

module ALU (
    input [ 3:0]  ALUOp,
    input [31:0] ALUSrcA,
    input [31:0] ALUSrcB,
    input [`ROB_ENTRY_WIDTH - 1:0] Dest_in,

    output reg busy,
    output reg [31:0] res,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out,
    output zero,
    output overflow
);


    always @(*) begin
        busy = (ALUCtrl == 0) ? 1'd0 : 1'd1;
        Dest_out = Dest_in;

        case(ALUCtrl)
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
            `AP4:  res = ALUSrcA + 32'd4;
            `OUTB: res = ALUSrcB;
            default: res = 32'd0;
        endcase
    end

    // overflow detection
    wire addOverflow, subOverflow;
    assign addOverflow = ( ALUSrcA[31] &  ALUSrcB[31] & ~res[31]) 
                        |(~ALUSrcA[31] & ~ALUSrcB[31] &  res[31]);
    assign subOverflow = (~ALUSrcA[31] &  ALUSrcB[31] &  res[31])
                        |( ALUSrcA[31] & ~ALUSrcB[31] & ~res[31]);
    assign overflow = ((ALUCtrl == `ADD | ALUCtrl == `AP4) & addOverflow)
                     |((ALUCtrl == `SUB) & subOverflow);

    assign zero = ~|res;

endmodule