`timescale 1ns / 1ps

module EX_MEM(
    input clk,
    input rst,
    input EN,
    
    input [31:0]        PC_EX,
    input [31:0]        inst_EX,
    input [31:0]        ALURes_EX,
    input [31:0]        MemWriteData_EX,
    input               MemRW_EX,
    input [2:0]         MemRdCtrl_EX,
    input [1:0]         MemWrCtrl_EX,
    input               RegWrite_EX,
    input [4:0]         waddr_EX,
    input               Mem2Reg_EX,
   
    output reg [31:0]   PC_MEM,
    output reg [31:0]   inst_MEM,
    output reg [31:0]   ALURes_MEM,
    output reg [31:0]   MemWriteData_MEM,
    output reg          MemRW_MEM,
    output reg [2:0]    MemRdCtrl_MEM,
    output reg [1:0]    MemWrCtrl_MEM,
    output reg          RegWrite_MEM,
    output reg [4:0]    waddr_MEM,
    output reg          Mem2Reg_MEM
);
    
    always @(posedge clk) begin
        if(rst) begin
            PC_MEM           <= 0;
            inst_MEM         <= 0;
            ALURes_MEM       <= 0;
            MemWriteData_MEM <= 0;
            MemRW_MEM        <= 0;
            MemRdCtrl_MEM    <= 0;
            MemWrCtrl_MEM    <= 0;
            RegWrite_MEM     <= 0;
            waddr_MEM        <= 0;
            Mem2Reg_MEM      <= 0;
        end
        else begin
            if(EN) begin
                PC_MEM           <= PC_EX;
                inst_MEM         <= inst_EX;
                ALURes_MEM       <= ALURes_EX;
                MemWriteData_MEM <= MemWriteData_EX;
                MemRW_MEM        <= MemRW_EX;
                MemRdCtrl_MEM    <= MemRdCtrl_EX;
                MemWrCtrl_MEM    <= MemWrCtrl_EX;
                RegWrite_MEM     <= RegWrite_EX;
                waddr_MEM        <= waddr_EX;
                Mem2Reg_MEM      <= Mem2Reg_EX;
            end
            else begin
                PC_MEM           <= PC_MEM;
                inst_MEM         <= inst_MEM;
                ALURes_MEM       <= ALURes_MEM;
                MemWriteData_MEM <= MemWriteData_MEM;
                MemRW_MEM        <= MemRW_MEM;
                MemRdCtrl_MEM    <= MemRdCtrl_MEM;
                MemWrCtrl_MEM    <= MemWrCtrl_MEM;
                RegWrite_MEM     <= RegWrite_MEM;
                waddr_MEM        <= waddr_MEM;
                Mem2Reg_MEM      <= Mem2Reg_MEM;
            end
        end
    end
endmodule
