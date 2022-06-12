`timescale 1ns / 1ps
`include "defines.vh"

module rs_bra_tb();
    reg clk, rst;
    reg                             RSBRA_we;
    reg [`ALU_OP_WIDTH - 1:0]       Op_in;
    reg [31:0]                      Vj_in;
    reg [31:0]                      Vk_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Qj_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Qk_in;
    reg [31:0]                      PC_in;
    reg [31:0]                      Offset_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    Dest_in;
    reg [`ROB_ENTRY_WIDTH - 1:0]    CDB_ALU_ROB_index;
    reg [31:0]                      CDB_ALU_data;
    
    wire full;
    wire [`ALU_OP_WIDTH - 1:0]      Op_out;
    wire [31:0]                     Vj_out;
    wire [31:0]                     Vk_out;
    wire [31:0]                     PC_out;
    wire [31:0]                     Offset_out;
    wire [`ROB_ENTRY_WIDTH - 1:0]   RSBRA_Dest_out;
    
    wire                            func_busy;
    wire                            Jump_en;
    wire [31:0]                     JumpAddr;
    wire [31:0]                     BRA_Dest_val;
    wire [`ROB_ENTRY_WIDTH - 1:0]   BRA_Dest_out;
    
    
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
        RSBRA_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        PC_in = 0;
        Offset_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;

        #1;
        @(posedge clk) RSBRA_we = 1; Op_in = `BEQ; Vj_in = 32'd1; Vk_in = 32'd1; PC_in = 4; Offset_in = 8;
        #1        
        RSBRA_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        PC_in = 0;
        Offset_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;

    end
    
    RSBRA test_RSBRA (
        .clk(clk),
        .rst(rst),
        .full(full),
        .issue_we(RSBRA_we),
        .Op_in(Op_in),
        .Vj_in(Vj_in),
        .Vk_in(Vk_in),
        .Qj_in(Qj_in),
        .Qk_in(Qk_in),
        .PC_in(PC_in),
        .Offset_in(Offset_in),
        .Dest_in(Dest_in),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .func_busy(func_busy),
        .Op_out(Op_out),
        .Vj_out(Vj_out),
        .Vk_out(Vk_out),
        .PC_out(PC_out),
        .Offset_out(Offset_out),
        .Dest_out(RSBRA_Dest_out)
    );
   
    BRA test_BRA (
        .BRAOp(Op_out),
        .BRASrcA(Vj_out),
        .BRASrcB(Vk_out),
        .PC(PC_out),
        .Offset(Offset_out),
        .Dest_in(RSBRA_Dest_out),
        .busy(func_busy),
        .Jump_en(Jump_en),
        .JumpAddr(JumpAddr),
        .Dest_val(BRA_Dest_val),
        .Dest_out(BRA_Dest_val)
    );
endmodule
