`timescale 1ns / 1ps

module ctrl_unit_tb();
    reg [31:0] inst;
    wire [2:0] BrType;
    wire Jump;
    wire [3:0] ImmSel;
    wire ALUSrcASel;
    wire ALUSrcBSel;
    wire [3:0] ALUCtrl;
    wire [2:0] MemRdCtrl;
    wire [1:0] MemWrCtrl;
    wire MemRW;
    wire RegWrite;
    wire [1:0] Mem2Reg;
    
    initial begin
        inst = 0;
        #10 inst = 32'b00000000000000000000000000110011; // add x0, x0, x0
        #10 inst = 32'b00000000000100001000000010110011; // add x1, x1, x1
    end
    CtrlUnit test_CtrlUnit(.inst(inst), .BrType(BrType), .Jump(Jump), .ImmSel(ImmSel), .ALUSrcASel(ALUSrcASel), .ALUSrcBSel(ALUSrcBSel), .ALUCtrl(ALUCtrl), .MemRdCtrl(MemRdCtrl), .MemWrCtrl(MemWrCtrl), .MemRW(MemRW), .RegWrite(RegWrite), .Mem2Reg(Mem2Reg));
endmodule
