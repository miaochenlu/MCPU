`timescale 1ns / 1ps

module MCPU(
    input clk,
    input rst
);
    
    // IF
    wire PC_EN_IF;
    wire IF_ID_EN; 
    wire [31:0] PC_IF;
    wire [31:0] inst_IF;
    wire [31:0] NextPC;
    wire [31:0] PC_p4;
    
    // ID
    wire ID_EX_EN;
    wire [31:0] PC_ID;
    wire [31:0] inst_ID;
    wire [2:0] BrType_ID;
    wire Jump_ID;
    wire [3:0] ImmSel_ID;
    wire [31:0] imm_ID;
    wire ALUSrcASel_ID;
    wire ALUSrcBSel_ID;
    wire [3:0] ALUCtrl_ID;
    wire [2:0] MemRdCtrl_ID;
    wire [1:0] MemWrCtrl_ID;
    wire MemRW_ID;
    wire RegWrite_ID;
    wire [4:0] waddr_ID;
    wire Mem2Reg_ID;
    
    wire [31:0] rdata1_ID;
    wire [31:0] rdata2_ID;
    
    wire DoJump;
    wire [31:0] JumpPC;
    
    // EX
    wire EX_MEM_EN;
    wire [31:0] PC_EX;
    wire [31:0] inst_EX;
    wire [31:0] rdata1_EX;
    wire [31:0] rdata2_EX;
    wire [31:0] imm_EX;
    wire ALUSrcASel_EX;
    wire ALUSrcBSel_EX;
    wire [3:0] ALUCtrl_EX;
    wire [2:0] MemRdCtrl_EX;
    wire [1:0] MemWrCtrl_EX;
    wire MemRW_EX;
    wire RegWrite_EX;
    wire [4:0] waddr_EX;
    wire Mem2Reg_EX;
    
    wire [31:0] ALUSrcA_EX;
    wire [31:0] ALUSrcB_EX;
    wire [31:0] ALURes_EX;
    wire ALUZero_EX;
    wire ALUOverflow_EX;
    
    // MEM
    wire MEM_WB_EN;
    wire [31:0] PC_MEM;
    wire [31:0] inst_MEM;
    wire [31:0] ALURes_MEM;
    wire [31:0] rdata2_EX;
    wire [2:0] MemRdCtrl_MEM;
    wire [1:0] MemWrCtrl_MEM;
    wire MemRW_MEM;
    wire RegWrite_MEM;
    wire [4:0] waddr_MEM;
    wire Mem2Reg_MEM;
    
    wire [31:0] MemRdData_MEM;
    
    // WB
    wire [31:0] PC_WB;
    wire [31:0] inst_WB;
    wire [31:0] ALURes_WB;
    wire [31:0] MemRdData_WB;
    wire RegWrite_WB;
    wire [4:0] waddr_WB;
    wire Mem2Reg_WB;
    
    wire [31:0] wdata_WB;
    
    assign PC_EN_IF = 1;
    assign IF_ID_EN = 1;
    assign ID_EX_EN = 1;
    assign EX_MEM_EN = 1;
    assign MEM_WB_EN = 1;
    
    // ***********************IF*****************************
    PC M_PC(
        .clk(clk), 
        .rst(rst),
        .CE(PC_EN_IF),
        .pc_in(NextPC), 
        .pc_out(PC_IF)
    );
    
    ROM M_ROM (
        .addr(PC_IF[8:2]),
        .rd_data(inst_IF)
    );

    assign PC_p4 = PC_IF + 32'd4;
    
    Mux21_32 M_Mux21_32_PCSrc(
        .in0(PC_p4),
        .in1(JumpPC),
        .sel(DoJump),
        .out(NextPC)
    );
    
    IF_ID M_IF_ID (
        .clk(clk),
        .rst(rst),
        .EN(IF_ID_EN),
        .PC_IF(PC_IF),
        .inst_IF(inst_IF),
        .PC_ID(PC_ID),
        .inst_ID(inst_ID)
    );
    
    // ***********************ID*****************************
    CtrlUnit M_CtrlUnit (
        .inst(inst_ID),
        .BrType(BrType_ID),
        .Jump(Jump_ID),
        .ImmSel(ImmSel_ID),
        .ALUSrcASel(ALUSrcASel_ID),
        .ALUSrcBSel(ALUSrcBSel_ID),
        .ALUCtrl(ALUCtrl_ID),
        .MemRdCtrl(MemRdCtrl_ID),
        .MemWrCtrl(MemWrCtrl_ID),
        .MemRW(MemRW_ID),
        .RegWrite(RegWrite_ID),
        .Mem2Reg(Mem2Reg_ID)
    );
    
    assign waddr_ID = inst_ID[11:7];
    
    RegFile M_RegFile (
        .clk(~clk),
        .rst(rst),
        .we(RegWrite_WB), // attention
        .raddr1(inst_ID[19:15]),
        .rdata1(rdata1_ID),
        .raddr2(inst_ID[24:20]),
        .rdata2(rdata2_ID),
        .waddr(waddr_WB),
        .wdata(wdata_WB)
    );
    
    ImmGen M_ImmGen (
        .inst(inst_ID),
        .ImmSel(ImmSel_ID),
        .imm(imm_ID)
    );
    
    Branch M_Branch (
        .CmpSrcA(rdata1_ID),
        .CmpSrcB(rdata2_ID),
        .BrType(BrType_ID),
        .BranchRes(BranchRes)
    );
    
    assign DoJump = BranchRes || Jump_ID;
    assign JumpPC = PC_ID + imm_ID;
    
    ID_EX M_ID_EX (
        .clk(clk),
        .rst(rst),
        .EN(ID_EX_EN),
        // input
        .PC_ID(PC_ID),
        .inst_ID(inst_ID),
        .rdata1_ID(rdata1_ID),
        .rdata2_ID(rdata2_ID),
        .imm_ID(imm_ID),
        .ALUSrcASel_ID(ALUSrcASel_ID),
        .ALUSrcBSel_ID(ALUSrcBSel_ID),
        .ALUCtrl_ID(ALUCtrl_ID),
        .MemRdCtrl_ID(MemRdCtrl_ID),
        .MemWrCtrl_ID(MemWrCtrl_ID),
        .MemRW_ID(MemRW_ID),
        .RegWrite_ID(RegWrite_ID),
        .waddr_ID(waddr_ID),
        .Mem2Reg_ID(Mem2Reg_ID),
        // output
        .PC_EX(PC_EX),
        .inst_EX(inst_EX),
        .rdata1_EX(rdata1_EX),
        .rdata2_EX(rdata2_EX),
        .imm_EX(imm_EX),
        .ALUSrcASel_EX(ALUSrcASel_EX),
        .ALUSrcBSel_EX(ALUSrcBSel_EX),
        .ALUCtrl_EX(ALUCtrl_EX),
        .MemRdCtrl_EX(MemRdCtrl_EX),
        .MemWrCtrl_EX(MemWrCtrl_EX),
        .MemRW_EX(MemRW_EX),
        .RegWrite_EX(RegWrite_EX),
        .waddr_EX(waddr_EX),
        .Mem2Reg_EX(Mem2Reg_EX)
    );

    
    // ***********************EX*****************************
    Mux21_32 M_Mux21_32_ALUSrcA (
        .in0(PC_EX),
        .in1(rdata1_EX),
        .sel(ALUSrcASel_EX),
        .out(ALUSrcA_EX)
    );
    
    Mux21_32 M_Mux21_32_ALUSrcB (
        .in0(imm_EX),
        .in1(rdata2_EX),
        .sel(ALUSrcBSel_EX),
        .out(ALUSrcB_EX)
    );
        
    ALU M_ALU (
        .ALUSrcA(ALUSrcA_EX),
        .ALUSrcB(ALUSrcB_EX),
        .ALUCtrl(ALUCtrl_EX),
        .res(ALURes_EX),
        .zero(ALUZero_EX),
        .overflow(ALUOverflow_EX)
    );
    
    EX_MEM M_EX_MEM (
        .clk(clk),
        .rst(rst),
        .EN(EX_MEM_EN),
        .PC_EX(PC_EX),
        .inst_EX(inst_EX),
        .ALURes_EX(ALURes_EX),
        .rdata2_EX(rdata2_EX),
        .MemRW_EX(MemRW_EX),
        .MemRdCtrl_EX(MemRdCtrl_EX),
        .MemWrCtrl_EX(MemWrCtrl_EX),
        .RegWrite_EX(RegWrite_EX),
        .waddr_EX(waddr_EX),
        .Mem2Reg_EX(Mem2Reg_EX),
        .PC_MEM(PC_MEM),
        .inst_MEM(inst_MEM),
        .ALURes_MEM(ALURes_MEM),
        .rdata2_MEM(rdata2_MEM),
        .MemRW_MEM(MemRW_MEM),
        .MemRdCtrl_MEM(MemRdCtrl_MEM),
        .MemWrCtrl_MEM(MemWrCtrl_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .waddr_MEM(waddr_MEM),
        .Mem2Reg_MEM(Mem2Reg_MEM)
    );
    
    // ***********************MEM*****************************
    
    RAM M_RAM (
        .clk(clk),
        .wr_en(MemRW_MEM),
        .rd_ctrl(MemRdCtrl_MEM),
        .wr_ctrl(MemWrCtrl_MEM),
        .wr_addr(ALURes_MEM),
        .wr_data(rdata2_MEM),
        .rd_addr(ALURes_MEM),
        .rd_data(MemRdData_MEM)
    );
    
    MEM_WB M_MEM_WB (
        .clk(clk),
        .rst(rst),
        .EN(MEM_WB_EN),
        .PC_MEM(PC_MEM),
        .inst_MEM(inst_MEM),
        .ALURes_MEM(ALURes_MEM),
        .MemRdData_MEM(MemRdData_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .waddr_MEM(waddr_MEM),
        .Mem2Reg_MEM(Mem2Reg_MEM),
        
        .PC_WB(PC_WB),
        .inst_WB(inst_WB),
        .ALURes_WB(ALURes_WB),
        .MemRdData_WB(MemRdData_WB),
        .RegWrite_WB(RegWrite_WB),
        .waddr_WB(waddr_WB),
        .Mem2Reg_WB(Mem2Reg_WB)
    );
    
    // ***********************MEM*****************************
    
    Mux21_32 M_Mux21_32_Writeback (
        .in0(ALURes_WB),
        .in1(MemRdData_WB),
        .sel(Mem2Reg_WB),
        .out(wdata_WB)
    );

endmodule
