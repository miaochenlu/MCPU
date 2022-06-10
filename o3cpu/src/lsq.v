`timescale 1ns / 1ps

module LSQ (
    input clk,
    input rst,
    input rollback,

    input [ 3:0] LSQOp,
    input [31:0] MemAddr,
);


    RAM M_RAM (
        .clk(~clk),
        .wr_en(MemRW_MEM),
        .rd_ctrl(MemRdCtrl_MEM),
        .wr_ctrl(MemWrCtrl_MEM),
        .wr_addr(ALURes_MEM),
        .wr_data(MemWriteData_MEM),
        .rd_addr(ALURes_MEM),
        .rd_data(MemRdData_MEM)
    );
endmodule