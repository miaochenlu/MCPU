`timescale 1ns / 1ps

module MEM_WB(
    input clk,
    input rst,
    input EN,
    input [31:0] PC_MEM,
    input [31:0] inst_MEM,
    input [31:0] ALURes_MEM,
    input [31:0] MemRdData_MEM,
    input RegWrite_MEM,
    input [4:0] waddr_MEM,
    input [1:0] Mem2Reg_MEM,
    
    output reg [31:0] PC_WB,
    output reg [31:0] inst_WB,
    output reg [31:0] ALURes_WB,
    output reg [31:0] MemRdData_WB,
    output reg RegWrite_WB,
    output reg [4:0] waddr_WB,
    output reg Mem2Reg_WB
);
    always @(posedge clk) begin
        if(rst) begin
            PC_WB           <= 0;
            inst_WB         <= 0;
            ALURes_WB       <= 0;
            MemRdData_WB    <= 0;
            RegWrite_WB     <= 0;
            waddr_WB        <= 0;
            Mem2Reg_WB      <= 0;
        end
        else begin
            if(EN) begin
                PC_WB           <= PC_MEM;
                inst_WB         <= inst_MEM;
                ALURes_WB       <= ALURes_MEM;
                MemRdData_WB    <= MemRdData_MEM;
                RegWrite_WB     <= RegWrite_MEM;
                waddr_WB        <= waddr_MEM;
                Mem2Reg_WB      <= Mem2Reg_MEM;
            end
            else begin
                PC_WB           <= PC_WB;
                inst_WB         <= inst_WB;
                ALURes_WB       <= ALURes_WB;
                MemRdData_WB    <= MemRdData_WB;
                RegWrite_WB     <= RegWrite_WB;
                waddr_WB        <= waddr_WB;
                Mem2Reg_WB      <= Mem2Reg_WB;
            end
        end
    end
endmodule
