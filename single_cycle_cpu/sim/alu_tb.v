`timescale 1ns / 1ps

module alu_tb();
    reg [31:0] ALUSrcA, ALUSrcB;
    reg [3:0] ALUCtrl;
    wire [31:0] res;
    wire zero, overflow;
    
    
    initial begin
        //add
        #10 ALUCtrl = 4'b0001;
            ALUSrcA = 2; ALUSrcB = 3;
        #10 ALUSrcA = -5; ALUSrcB = 2;
        #10 ALUSrcA = 32'h7fffffff; ALUSrcB = 32'h7fffffff;
        //sub
        #10 ALUCtrl = 4'b0010;
            ALUSrcA = 2; ALUSrcB = 3;
        #10 ALUSrcA = -2; ALUSrcB = -5;
        #10 ALUSrcA = 32'hefffffff; ALUSrcB = -32'hefffffff;
        //SLT
        #10 ALUCtrl = 4'b1000;
            ALUSrcA = 2; ALUSrcB = 3;
        #10 ALUSrcA = -2; ALUSrcB = -3;
        #10 ALUSrcA = -2; ALUSrcB = -5;
        #10 ALUSrcA = 32'hefffffff; ALUSrcB = -32'hefffffff;
        //SRL
        #10 ALUCtrl = 4'b1010;
            ALUSrcA = 32'b0111111; ALUSrcB = 32'b00010;
        #10 ALUSrcA = 32'hff100000; ALUSrcB = 32'b00100; 
    end
    
    
    ALU test_ALU(.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUCtrl(ALUCtrl), .res(res), .zero(zero), .overflow(overflow));
endmodule
