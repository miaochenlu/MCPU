`timescale 1ns / 1ps

module MCPU(
    input clk,
    input rst
);
    wire [31:0] pc, pc_plus4, jump_pc, next_pc;
    
    wire [31:0] inst;
    
    wire RegWrite;
    wire [31:0] rdata1, rdata2, wdata;
    
    wire [2:0] ImmSel;
    wire [31:0] ImmOut;
    
    wire ALUSrcASel, ALUSrcBSel;
    wire [31:0] ALUSrcA, ALUSrcB;
    
    wire [3:0] ALUCtrl;
    wire [31:0] ALURes;
    wire ALUZero, ALUOverflow;
    
    wire MemRW;
    wire [2:0] MemRdCtrl;
    wire [1:0] MemWrCtrl;
    wire [31:0] MemRdData;
    
    wire [1:0] Mem2Reg;
    
    wire [2:0] BrType;
    wire BranchRes; 
    wire Jump;
    
    PC M_PC(
        .clk(clk), 
        .rst(rst), 
        .pc_in(next_pc), 
        .pc_out(pc)
    );
    
    ROM M_ROM (
        .addr(pc[8:2]),
        .rd_data(inst)
    );

    CtrlUnit M_CtrlUnit (
        .inst(inst),
        .BrType(BrType),
        .Jump(Jump),
        .ImmSel(ImmSel),
        .ALUSrcASel(ALUSrcASel),
        .ALUSrcBSel(ALUSrcBSel),
        .ALUCtrl(ALUCtrl),
        .MemRdCtrl(MemRdCtrl),
        .MemWrCtrl(MemWrCtrl),
        .MemRW(MemRW),
        .RegWrite(RegWrite),
        .Mem2Reg(Mem2Reg)
    );
    
    RegFile M_RegFile (
        .clk(~clk),
        .rst(rst),
        .we(RegWrite),
        .raddr1(inst[19:15]),
        .rdata1(rdata1),
        .raddr2(inst[24:20]),
        .rdata2(rdata2),
        .waddr(inst[11:7]),
        .wdata(wdata)
    );
    
    ImmGen M_ImmGen (
        .inst(inst),
        .ImmSel(ImmSel),
        .imm(ImmOut)
    );
    
    Mux21_32 M_Mux21_32_ALUSrcA (
        .in0(pc),
        .in1(rdata1),
        .sel(ALUSrcASel),
        .out(ALUSrcA)
    );
    
    Mux21_32 M_Mux21_32_ALUSrcB (
        .in0(ImmOut),
        .in1(rdata2),
        .sel(ALUSrcBSel),
        .out(ALUSrcB)
    );
    
    Branch M_Branch (
        .CmpSrcA(rdata1),
        .CmpSrcB(rdata2),
        .BrType(BrType),
        .BranchRes(BranchRes)
    );
    
    assign DoJump = BranchRes || Jump;
    assign pc_plus4 = pc + 32'd4;
    assign jump_pc = pc + ImmOut;
    assign next_pc = DoJump ?  jump_pc : pc_plus4;
        
    ALU M_ALU (
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUCtrl(ALUCtrl),
        .res(ALURes),
        .zero(ALUZero),
        .overflow(ALUOverflow)
    );
    
    RAM M_RAM (
        .clk(clk),
        .wr_en(MemRW),
        .rd_ctrl(MemRdCtrl),
        .wr_ctrl(MemWrCtrl),
        .wr_addr(ALURes),
        .wr_data(rdata2),
        .rd_addr(ALURes),
        .rd_data(MemRdData)
    );
    
    Mux41_32 M_Mux41_32_Writeback (
        .in0(32'd0),
        .in1(pc_plus4),
        .in2(ALURes),
        .in3(MemRdData),
        .sel(Mem2Reg),
        .out(wdata)
    );

endmodule
