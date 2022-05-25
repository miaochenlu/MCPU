`timescale 1ns / 1ps
`include "defines.v"

module ForwardUnit (
    input [4:0] raddr1_EX,
    input [4:0] raddr2_EX,
    input RS1Use_EX,
    input RS2Use_EX,
    input [4:0] waddr_MEM,
    input [4:0] waddr_WB,
    input RegWrite_MEM,
    input RegWrite_WB,
    input MemWrite_EX,
    input MemRead_MEM,
    input MemRead_WB,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg [1:0] ForwardWriteMem
);
    always @(*) begin
        if(RegWrite_MEM && waddr_MEM != 0 && RS1Use_EX && waddr_MEM == raddr1_EX && ~MemRead_MEM) 
            ForwardA = `FORWARD_A_ALU_MEM;
        else if(RegWrite_WB && waddr_WB != 0 && RS1Use_EX && waddr_WB == raddr1_EX && ~MemRead_WB) 
            ForwardA = `FORWARD_A_ALU_WB;
        else if(RegWrite_WB && waddr_WB != 0 && RS1Use_EX && waddr_WB == raddr1_EX && MemRead_WB) 
            ForwardA = `FORWARD_A_LOAD_WB;
        else
            ForwardA = `NOFORWARD;    
        
        if(RegWrite_MEM && waddr_MEM != 0 && RS2Use_EX && waddr_MEM == raddr2_EX && ~MemRead_MEM) 
            ForwardB = `FORWARD_B_ALU_MEM;
        else if(RegWrite_WB && waddr_WB != 0 && RS2Use_EX && waddr_WB == raddr2_EX && ~MemRead_WB) 
            ForwardB = `FORWARD_B_ALU_WB; 
        else if(RegWrite_WB && waddr_WB != 0 && RS2Use_EX && waddr_WB == raddr2_EX && MemRead_WB) 
            ForwardB = `FORWARD_B_LOAD_WB; 
        else
            ForwardB = `NOFORWARD;
        
        if(RegWrite_MEM && waddr_MEM != 0 && RS2Use_EX && waddr_MEM == raddr2_EX && MemWrite_EX) begin
            if(MemRead_MEM) ForwardWriteMem = `FORWARD_WRITEMEM_MEM;
            else ForwardWriteMem = `FORWARD_WRITEMEM_ALU;
        end
        else ForwardWriteMem = `NOFORWARD;
    end
endmodule
