`timescale 1ns / 1ps
`include "defines.vh"

module RN_DP(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,

    input [31:0]        PC_RN,
    input [31:0]        inst_RN,
    input [ 6:0]        OpCode_RN,
    input [ 2:0]        FUType_RN,
    input [ 1:0]        OpASel_RN,
    input [ 1:0]        OpBSel_RN,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_RN,
    input [ 3:0]        ALUCtrl_RN,
    input [ 3:0]        MemCtrl_RN,
    input [ 3:0]        BRACtrl_RN,
    input [31:0]        Imm_RN,
    input [31:0]        OpAValue_RN,
    input [`ROB_ENTRY_WIDTH - 1:0] OpA_ROB_index_RN,
    input [31:0]        OpBValue_RN,
    input [`ROB_ENTRY_WIDTH - 1:0] OpB_ROB_index_RN,
    
    output reg [31:0]   PC_DP,
    output reg [31:0]   inst_DP,
    output reg [ 6:0]   OpCode_DP,   
    output reg [ 2:0]   FUType_DP,
    output reg [ 1:0]   OpASel_DP,
    output reg [ 1:0]   OpBSel_DP,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_DP,
    output reg [ 3:0]   ALUCtrl_DP,
    output reg [ 3:0]   MemCtrl_DP,
    output reg [ 3:0]   BRACtrl_DP,
    output reg [31:0]   Imm_DP,
    output reg [31:0]   OpAValue_DP,
    output reg [`ROB_ENTRY_WIDTH - 1:0] OpA_ROB_index_DP,
    output reg [31:0]   OpBValue_DP,
    output reg [`ROB_ENTRY_WIDTH - 1:0] OpB_ROB_index_DP
);

    always @(posedge clk) begin
        if(rst) begin
            PC_DP   <= 0;
            inst_DP <= 0;
            OpCode_DP <= 0;
            FUType_DP <= 0;
            OpASel_DP <= 0;
            OpBSel_DP <= 0;
            ROB_dest_DP <= 0;
            ALUCtrl_DP <= 0;
            MemCtrl_DP <= 0;
            BRACtrl_DP <= 0;
            Imm_DP <= 0;
            OpAValue_DP <= 0;
            OpA_ROB_index_DP <= 0;
            OpBValue_DP <= 0;
            OpB_ROB_index_DP <= 0;
        end
        else if(EN) begin
            if(stall) begin
                PC_DP   <= PC_DP;
                inst_DP <= inst_DP;
                OpCode_DP <= OpCode_DP;
                FUType_DP <= FUType_DP;
                OpASel_DP <= OpASel_DP;
                OpBSel_DP <= OpBSel_DP;
                ROB_dest_DP <= ROB_dest_DP;
                ALUCtrl_DP <= ALUCtrl_DP;
                MemCtrl_DP <= MemCtrl_DP;
                BRACtrl_DP <= BRACtrl_DP;
                Imm_DP <= Imm_DP;
                OpAValue_DP <= OpAValue_DP;
                OpA_ROB_index_DP <= OpA_ROB_index_DP;
                OpBValue_DP <= OpBValue_DP;
                OpB_ROB_index_DP <= OpB_ROB_index_DP;
            end
            else if(flush) begin
                PC_DP   <= PC_RN;
                inst_DP <= 32'h00000000;
                OpCode_DP <= 0;
                FUType_DP <= 0;
                OpASel_DP <= 0;
                OpBSel_DP <= 0;
                ROB_dest_DP <= 0;
                ALUCtrl_DP <= 0;
                MemCtrl_DP <= 0;
                BRACtrl_DP <= 0;
                Imm_DP <= 0;
                OpAValue_DP <= 0;
                OpA_ROB_index_DP <= 0;
                OpBValue_DP <= 0;
                OpB_ROB_index_DP <= 0;
            end
            else begin
                PC_DP   <= PC_RN;
                inst_DP <= inst_RN;
                OpCode_DP <= OpCode_RN;
                FUType_DP <= FUType_RN;
                OpASel_DP <= OpASel_RN;
                OpBSel_DP <= OpBSel_RN;
                ROB_dest_DP <= ROB_dest_RN;
                ALUCtrl_DP <= ALUCtrl_RN;
                MemCtrl_DP <= MemCtrl_RN;
                BRACtrl_DP <= BRACtrl_RN;
                Imm_DP <= Imm_RN;
                OpAValue_DP <= OpAValue_RN;
                OpA_ROB_index_DP <= OpA_ROB_index_RN;
                OpBValue_DP <= OpBValue_RN;
                OpB_ROB_index_DP <= OpB_ROB_index_RN;
            end
        end
        else begin
            PC_DP   <= PC_DP;
            inst_DP <= inst_DP;
            FUType_DP <= FUType_DP;
            OpCode_DP <= OpCode_DP;
            OpASel_DP <= OpASel_DP;
            OpBSel_DP <= OpBSel_DP;
            ROB_dest_DP <= ROB_dest_DP;
            ALUCtrl_DP <= ALUCtrl_DP;
            MemCtrl_DP <= MemCtrl_DP;
            BRACtrl_DP <= BRACtrl_DP;
            Imm_DP <= Imm_DP;
            OpAValue_DP <= OpAValue_DP;
            OpA_ROB_index_DP <= OpA_ROB_index_DP;
            OpBValue_DP <= OpBValue_DP;
            OpB_ROB_index_DP <= OpB_ROB_index_DP;
            
        end
    end
endmodule