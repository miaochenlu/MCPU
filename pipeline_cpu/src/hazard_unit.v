`timescale 1ns / 1ps

module HazardUnit(
    input [4:0] raddr1_ID,
    input [4:0] raddr2_ID,
    input RS1Use_ID,
    input RS2Use_ID,
    input MemWrite_ID,
    input [4:0] waddr_EX,
    input MemRead_EX,
    input JumpStall,
    output PC_EN_IF,
    output IF_ID_Flush,
    output ID_EX_Flush,
    output IF_ID_Stall
);
    wire DataStall;
    assign DataStall = MemRead_EX && ~MemWrite_ID && 
                    ((RS1Use_ID && raddr1_ID != 0 && (waddr_EX == raddr1_ID)) 
                  || (RS2Use_ID && raddr2_ID != 0 && (waddr_EX == raddr2_ID)));

    assign PC_EN_IF    = ~DataStall;
    assign IF_ID_Flush = JumpStall;
    assign IF_ID_Stall = DataStall;
    assign ID_EX_Flush = DataStall;
endmodule
