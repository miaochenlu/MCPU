`timescale 1ns / 1ps

module ALU (
    input [31:0] ALUSrcA,
    input [31:0] ALUSrcB,
    input [3:0]  ALUCtrl,
    output reg [31:0] res,
    output zero,
    output overflow
);

    localparam ADD  = 4'b0001;
    localparam SUB  = 4'b0010;
    localparam AND  = 4'b0011;
    localparam OR   = 4'b0100;
    localparam XOR  = 4'b0101;
    localparam SLL  = 4'b0110;
    localparam SRL  = 4'b0111;
    localparam SLT  = 4'b1000;
    localparam SLTU = 4'b1001;
    localparam SRA  = 4'b1010;
    localparam AP4  = 4'b1011;
    localparam OUTB = 4'b1100;


    always @(*) begin
        case(ALUCtrl)
            ADD:  res = ALUSrcA + ALUSrcB;
            SUB:  res = ALUSrcA - ALUSrcB;
            AND:  res = ALUSrcA & ALUSrcB;
            OR :  res = ALUSrcA | ALUSrcB;
            XOR:  res = ALUSrcA ^ ALUSrcB;
            SLL:  res = ALUSrcA << ALUSrcB[4:0];
            SRL:  res = ALUSrcA >> ALUSrcB[4:0];
            SLT:  res = ($signed(ALUSrcA) < $signed(ALUSrcB)) ? 32'd1 : 32'd0;
            SLTU: res = (ALUSrcA < ALUSrcB) ? 32'd1 : 32'd0;
            SRA:  res = $signed(ALUSrcA) >>> ALUSrcB[4:0]; // arithemic shift >>>
            AP4:  res = ALUSrcA + 32'd4;
            OUTB: res = ALUSrcB;
            default: res = 32'd0;
        endcase
    end

    // overflow detection
    wire addOverflow, subOverflow;
    assign addOverflow = ( ALUSrcA[31] &  ALUSrcB[31] & ~res[31]) 
                        |(~ALUSrcA[31] & ~ALUSrcB[31] &  res[31]);
    assign subOverflow = (~ALUSrcA[31] &  ALUSrcB[31] &  res[31])
                        |( ALUSrcA[31] & ~ALUSrcB[31] & ~res[31]);
    assign overflow = ((ALUCtrl == ADD | ALUCtrl == AP4) & addOverflow)
                     |((ALUCtrl == SUB) & subOverflow);

    assign zero = ~|res;

endmodule

