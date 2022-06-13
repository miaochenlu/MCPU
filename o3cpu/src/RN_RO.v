`timescale 1ns / 1ps
`include "defines.vh"

module RN_RO(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,

    input [31:0]        PC_RN,
    input [31:0]        inst_RN,
    input [6:0]         OpCode_RN,
    input [ 2:0]        FUType_RN,
    input [ 3:0]        ImmSel_RN,
    input [ 1:0]        OpASel_RN,
    input [ 1:0]        OpBSel_RN,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_RN,
    input [ 3:0]        ALUCtrl_RN,
    input [ 3:0]        MemCtrl_RN,
    input [ 3:0]        BraCtrl_RN,
    
    output reg [31:0]   PC_RO,
    output reg [31:0]   inst_RO,
    output reg [6:0]    OpCode_RO,
    output reg [ 2:0]   FUType_RO,
    output reg          RegWrite_RO,
    output reg [ 3:0]   ImmSel_RO,
    output reg [ 1:0]   OpASel_RO,
    output reg [ 1:0]   OpBSel_RO,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_dest_RO,
    output reg [ 3:0]   ALUCtrl_RO,
    output reg [ 3:0]   MemCtrl_RO,
    output reg [ 3:0]   BraCtrl_RO
);

    always @(posedge clk) begin
        if(rst) begin
            PC_RO   <= 0;
            inst_RO <= 0;
            OpCode_RO <= 0;
            FUType_RO <= 0;
            RegWrite_RO <= 0;
            ImmSel_RO <= 0;
            OpASel_RO <= 0;
            OpBSel_RO <= 0;
            ROB_dest_RO <= 0;
            ALUCtrl_RO <= 0;
            MemCtrl_RO <= 0;
            BraCtrl_RO <= 0;
        end
        else if(EN) begin
            if(stall) begin
                PC_RO   <= PC_RO;
                inst_RO <= inst_RO;
                OpCode_RO <= OpCode_RO;
                FUType_RO <= FUType_RO;
                RegWrite_RO <= RegWrite_RO;
                ImmSel_RO <= ImmSel_RO;
                OpASel_RO <= OpASel_RO;
                OpBSel_RO <= OpBSel_RO;
                ROB_dest_RO <= ROB_dest_RO;
                ALUCtrl_RO <= ALUCtrl_RO;
                MemCtrl_RO <= MemCtrl_RO;
                BraCtrl_RO <= BraCtrl_RO;
            end
            else if(flush) begin
                PC_RO   <= PC_RO;
                inst_RO <= 32'h00000000;
                OpCode_RO <= 0;
                FUType_RO <= 0;
                RegWrite_RO <= 0;
                ImmSel_RO <= 0;
                OpASel_RO <= 0;
                OpBSel_RO <= 0;
                ROB_dest_RO <= 0;
                ALUCtrl_RO <= 0;
                MemCtrl_RO <= 0;
                BraCtrl_RO <= 0;
            end
            else begin
                PC_RO   <= PC_RN;
                inst_RO <= inst_RN;
                OpCode_RO <= OpCode_RN;
                FUType_RO <= FUType_RN;
                ImmSel_RO <= ImmSel_RN;
                OpASel_RO <= OpASel_RN;
                OpBSel_RO <= OpBSel_RN;
                ROB_dest_RO <= ROB_dest_RN;
                ALUCtrl_RO <= ALUCtrl_RN;
                MemCtrl_RO <= MemCtrl_RN;
                BraCtrl_RO <= BraCtrl_RN;
            end
        end
        else begin
            PC_RO   <= PC_RO;
            inst_RO <= inst_RO;
            OpCode_RO <= OpCode_RO;
            FUType_RO <= FUType_RO;
            RegWrite_RO <= RegWrite_RO;
            ImmSel_RO <= ImmSel_RO;
            OpASel_RO <= OpASel_RO;
            OpBSel_RO <= OpBSel_RO;
            ROB_dest_RO <= ROB_dest_RO;
            ALUCtrl_RO <= ALUCtrl_RO;
            MemCtrl_RO <= MemCtrl_RO;
            BraCtrl_RO <= BraCtrl_RO;
        end
    end
endmodule