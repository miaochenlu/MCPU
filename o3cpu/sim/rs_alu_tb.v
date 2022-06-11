`timescale 1ns / 1ps
`include "defines.vh"

module rs_alu_tb();
    reg clk, rst;
    reg                             RSALU_we;
    reg [`ALU_OP_WIDTH - 1:0]       Op_in;
    reg [31:0]                      Vj_in;
    reg [31:0]                      Vk_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Qj_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Qk_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Dest_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    CDB_ALU_ROB_index;
    reg [31:0]                      CDB_ALU_data;
    
    wire full;
    wire [`ALU_OP_WIDTH - 1:0]      Op_out;
    wire [31:0]                     Vj_out;
    wire [31:0]                     Vk_out;
    wire [`ROB_ENTRY_WIDTH - 1:0]   RSALU_Dest_out;
    
    wire                            busy;
    wire [31:0]                     ALURes;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ALU_Dest_out;
    
    
    initial begin
        clk = 1;
        forever begin
            #1 clk = ~clk;
        end
    end
    
    initial begin
        rst = 1;
        #2 rst = 0;
    end
    
    initial begin
        RSALU_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;

        #1;
        @(posedge clk) RSALU_we = 1; Op_in = `SUB; Vj_in = 32'd0; Qj_in = 7; Vk_in = 32'd1; Dest_in = 1;
        #1 
        RSALU_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
        #1;
        @(posedge clk) RSALU_we = 1; Op_in = `ADD; Vj_in = 32'd2; Vk_in = 32'd1; Dest_in = 1;
        #1 
        RSALU_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
        #1;
        @(posedge clk) CDB_ALU_ROB_index = 7; CDB_ALU_data = 101;
        #2 
        RSALU_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
    end
    
    RSALU test_RSALU (
        .clk(clk),
        .rst(rst),
        .full(full),
        .issue_we(RSALU_we),
        .Op_in(Op_in),
        .Vj_in(Vj_in),
        .Vk_in(Vk_in),
        .Qj_in(Qj_in),
        .Qk_in(Qk_in),
        .Dest_in(Dest_in),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .Op_out(Op_out),
        .Vj_out(Vj_out),
        .Vk_out(Vk_out),
        .Dest_out(RSALU_Dest_out)
    );
   
    ALU test_ALU (
        .ALUOp(Op_out),
        .ALUSrcA(Vj_out),
        .ALUSrcB(Vk_out),
        .Dest_in(RSALU_Dest_out),
        .busy(busy),
        .res(ALURes),
        .Dest_out(ALU_Dest_out),
        .zero(),
        .overflow()
    );

endmodule
