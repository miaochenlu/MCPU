`timescale 1ns / 1ps
`include "defines.vh"

module ID_RN(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,

    input [31:0]                    PC_ID,
    input [31:0]                    inst_ID,
    input [6:0]                     OpCode_ID,
    input [`FU_WIDTH - 1:0]         FUType_ID,
    input                           RegWrite_ID,
    input                           ROBWrite_en_ID,
    input [ 3:0]                    ImmSel_ID,
    input [ 1:0]                    OpASel_ID,
    input [ 1:0]                    OpBSel_ID,
    input [ 3:0]                    ALUCtrl_ID,
    input [ 3:0]                    MemCtrl_ID,
    input [ 3:0]                    BRACtrl_ID,
    
    output reg [31:0]               PC_RN,
    output reg [31:0]               inst_RN,
    output reg [6:0]                OpCode_RN,
    output reg [`FU_WIDTH - 1:0]    FUType_RN,
    output reg                      RegWrite_RN,
    output reg                      ROBWrite_en_RN,
    output reg [ 3:0]               ImmSel_RN,
    output reg [ 1:0]               OpASel_RN,
    output reg [ 1:0]               OpBSel_RN,
    output reg [ 3:0]               ALUCtrl_RN,
    output reg [ 3:0]               MemCtrl_RN,
    output reg [ 3:0]               BRACtrl_RN
);

    always @(posedge clk) begin
        if(rst) begin
            PC_RN               <= 0;
            inst_RN             <= 0;
            OpCode_RN           <= 0;
            FUType_RN           <= 0;
            RegWrite_RN         <= 0;
            ROBWrite_en_RN      <= 0;
            ImmSel_RN           <= 0;
            OpASel_RN           <= 0;
            OpBSel_RN           <= 0;
            ALUCtrl_RN          <= 0;
            MemCtrl_RN          <= 0;
            BRACtrl_RN          <= 0;
        end
        else if(EN) begin
            if(stall) begin
                PC_RN           <= PC_RN;
                inst_RN         <= inst_RN;
                OpCode_RN       <= OpCode_RN;
                FUType_RN       <= FUType_RN;
                RegWrite_RN     <= RegWrite_RN;
                ROBWrite_en_RN  <= ROBWrite_en_RN;
                ImmSel_RN       <= ImmSel_RN;
                OpASel_RN       <= OpASel_RN;
                OpBSel_RN       <= OpBSel_RN;
                ALUCtrl_RN      <= ALUCtrl_RN;
                MemCtrl_RN      <= MemCtrl_RN;
                BRACtrl_RN      <= BRACtrl_RN;
            end
            else if(flush) begin
                PC_RN           <= PC_ID;
                inst_RN         <= 32'h00000000;
                OpCode_RN       <= 0;
                FUType_RN       <= 0;
                RegWrite_RN     <= 0;
                ROBWrite_en_RN  <= 0;
                ImmSel_RN       <= 0;
                OpASel_RN       <= 0;
                OpBSel_RN       <= 0;
                ALUCtrl_RN      <= 0;
                MemCtrl_RN      <= 0;
                BRACtrl_RN      <= 0;
            end
            else begin
                PC_RN           <= PC_ID;
                inst_RN         <= inst_ID;
                OpCode_RN       <= OpCode_ID;
                FUType_RN       <= FUType_ID;
                RegWrite_RN     <= RegWrite_ID;
                ROBWrite_en_RN  <= ROBWrite_en_ID;
                ImmSel_RN       <= ImmSel_ID;
                OpASel_RN       <= OpASel_ID;
                OpBSel_RN       <= OpBSel_ID;
                ALUCtrl_RN      <= ALUCtrl_ID;
                MemCtrl_RN      <= MemCtrl_ID;
                BRACtrl_RN      <= BRACtrl_ID;
            end
        end
        else begin
            PC_RN               <= PC_RN;
            inst_RN             <= inst_RN;
            OpCode_RN           <= OpCode_RN;
            FUType_RN           <= FUType_RN;
            RegWrite_RN         <= RegWrite_RN;
            ROBWrite_en_RN      <= ROBWrite_en_RN;
            ImmSel_RN           <= ImmSel_RN;
            OpASel_RN           <= OpASel_RN;
            OpBSel_RN           <= OpBSel_RN;
            ALUCtrl_RN          <= ALUCtrl_RN;
            MemCtrl_RN          <= MemCtrl_RN;
            BRACtrl_RN          <= BRACtrl_RN;
        end
    end
endmodule