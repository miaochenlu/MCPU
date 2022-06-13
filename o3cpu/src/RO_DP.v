`timescale 1ns / 1ps
`include "defines.vh"

module RO_DP(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,

    input [31:0]        PC_RO,
    input [31:0]        inst_RO,
    input [ 6:0]        OpCode_RO,
    input [ 2:0]        FUType_RO,
    input [ 1:0]        OpASel_RO,
    input [ 1:0]        OpBSel_RO,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_RO,
    input [ 3:0]        ALUCtrl_RO,
    input [ 3:0]        MemCtrl_RO,
    input [ 3:0]        BraCtrl_RO,
    input [31:0]        Imm_RO,
    input [31:0]        OpAValue_RO,
    input [`ROB_ENTRY_WIDTH - 1:0] OpA_ROB_index_RO,
    input [31:0]        OpBValue_RO,
    input [`ROB_ENTRY_WIDTH - 1:0] OpB_ROB_index_RO,
    
    output reg [31:0]   PC_DP,
    output reg [31:0]   inst_DP,
    output reg [ 6:0]   OpCode_DP,   
    output reg [ 2:0]   FUType_DP,
    output reg [ 1:0]   OpASel_DP,
    output reg [ 1:0]   OpBSel_DP,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_DP,
    output reg [ 3:0]   ALUCtrl_DP,
    output reg [ 3:0]   MemCtrl_DP,
    output reg [ 3:0]   BraCtrl_DP,
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
            BraCtrl_DP <= 0;
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
                BraCtrl_DP <= BraCtrl_DP;
                Imm_DP <= Imm_DP;
                OpAValue_DP <= OpAValue_DP;
                OpA_ROB_index_DP <= OpA_ROB_index_DP;
                OpBValue_DP <= OpBValue_DP;
                OpB_ROB_index_DP <= OpB_ROB_index_DP;
            end
            else if(flush) begin
                PC_DP   <= PC_DP;
                inst_DP <= 32'h00000000;
                OpCode_DP <= 0;
                FUType_DP <= 0;
                OpASel_DP <= 0;
                OpBSel_DP <= 0;
                ROB_dest_DP <= 0;
                ALUCtrl_DP <= 0;
                MemCtrl_DP <= 0;
                BraCtrl_DP <= 0;
                Imm_DP <= 0;
                OpAValue_DP <= 0;
                OpA_ROB_index_DP <= 0;
                OpBValue_DP <= 0;
                OpB_ROB_index_DP <= 0;
            end
            else begin
                PC_DP   <= PC_RO;
                inst_DP <= inst_RO;
                OpCode_DP <= OpCode_RO;
                FUType_DP <= FUType_RO;
                OpASel_DP <= OpASel_RO;
                OpBSel_DP <= OpBSel_RO;
                ROB_dest_DP <= ROB_dest_RO;
                ALUCtrl_DP <= ALUCtrl_RO;
                MemCtrl_DP <= MemCtrl_RO;
                BraCtrl_DP <= BraCtrl_RO;
                Imm_DP <= Imm_RO;
                OpAValue_DP <= OpAValue_RO;
                OpA_ROB_index_DP <= OpA_ROB_index_RO;
                OpBValue_DP <= OpBValue_RO;
                OpB_ROB_index_DP <= OpB_ROB_index_RO;
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
            BraCtrl_DP <= BraCtrl_DP;
            Imm_DP <= Imm_DP;
            OpAValue_DP <= OpAValue_DP;
            OpA_ROB_index_DP <= OpA_ROB_index_DP;
            OpBValue_DP <= OpBValue_DP;
            OpB_ROB_index_DP <= OpB_ROB_index_DP;
            
        end
    end
endmodule