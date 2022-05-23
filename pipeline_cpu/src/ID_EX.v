`timescale 1ns / 1ps

module ID_EX(
    input clk,
    input rst,
    input EN,
    input flush,
    input [31:0] PC_ID,
    input [31:0] inst_ID,
    input [31:0] rdata1_ID,
    input [31:0] rdata2_ID,
    input [31:0] imm_ID,
    input ALUSrcASel_ID,
    input ALUSrcBSel_ID,
    input [3:0] ALUCtrl_ID,
    input MemRW_ID,
    input [2:0] MemRdCtrl_ID,
    input [1:0] MemWrCtrl_ID,
    input RegWrite_ID,
    input [4:0] waddr_ID,
    input Mem2Reg_ID,
    
    output reg [31:0] PC_EX,
    output reg [31:0] inst_EX,
    output reg [31:0] rdata1_EX,
    output reg [31:0] rdata2_EX,
    output reg [31:0] imm_EX,
    output reg ALUSrcASel_EX,
    output reg ALUSrcBSel_EX,
    output reg [3:0] ALUCtrl_EX,
    output reg MemRW_EX,
    output reg [2:0] MemRdCtrl_EX,
    output reg [1:0] MemWrCtrl_EX,
    output reg RegWrite_EX,
    output reg [4:0] waddr_EX,
    output reg Mem2Reg_EX
);
    
    always @(posedge clk) begin
        if(rst) begin
            PC_EX           <= 0;
            inst_EX         <= 0;
            rdata1_EX       <= 0;
            rdata2_EX       <= 0;
            imm_EX          <= 0;
            ALUSrcASel_EX   <= 0;
            ALUSrcBSel_EX   <= 0;
            ALUCtrl_EX      <= 0;
            MemRW_EX        <= 0;
            MemRdCtrl_EX    <= 0;
            MemWrCtrl_EX    <= 0;
            RegWrite_EX     <= 0;
            waddr_EX        <= 0;
            Mem2Reg_EX      <= 0;
        end
        else begin
            if(EN) begin
                if(flush) begin
                    PC_EX           <= PC_EX;
                    inst_EX         <= 32'h00000000;
                    rdata1_EX       <= 0;
                    rdata2_EX       <= 0;
                    imm_EX          <= 0;
                    ALUSrcASel_EX   <= 0;
                    ALUSrcBSel_EX   <= 0;
                    ALUCtrl_EX      <= 0;
                    MemRW_EX        <= 0;
                    MemRdCtrl_EX    <= 0;
                    MemWrCtrl_EX    <= 0;
                    RegWrite_EX     <= 0;
                    waddr_EX        <= 0;
                    Mem2Reg_EX      <= 0;
                end
                else begin
                    PC_EX           <= PC_ID;
                    inst_EX         <= inst_ID;
                    rdata1_EX       <= rdata1_ID;
                    rdata2_EX       <= rdata2_ID;
                    imm_EX          <= imm_ID;
                    ALUSrcASel_EX   <= ALUSrcASel_ID;
                    ALUSrcBSel_EX   <= ALUSrcBSel_ID;
                    ALUCtrl_EX      <= ALUCtrl_ID;
                    MemRW_EX        <= MemRW_ID;
                    MemRdCtrl_EX    <= MemRdCtrl_ID;
                    MemWrCtrl_EX    <= MemWrCtrl_ID;
                    RegWrite_EX     <= RegWrite_ID;
                    waddr_EX        <= waddr_ID;
                    Mem2Reg_EX      <= Mem2Reg_ID;
                end
            end
            else begin
                PC_EX           <= PC_EX;
                inst_EX         <= inst_EX;
                rdata1_EX       <= rdata1_EX;
                rdata2_EX       <= rdata2_EX;
                imm_EX          <= imm_EX;
                ALUSrcASel_EX   <= ALUSrcASel_EX;
                ALUSrcBSel_EX   <= ALUSrcBSel_EX;
                ALUCtrl_EX      <= ALUCtrl_EX;
                MemRW_EX        <= MemRW_EX;
                MemRdCtrl_EX    <= MemRdCtrl_EX;
                MemWrCtrl_EX    <= MemWrCtrl_EX;
                RegWrite_EX     <= RegWrite_EX;
                waddr_EX        <= waddr_ID;
                Mem2Reg_EX      <= Mem2Reg_EX;
            end
        end
    end
endmodule