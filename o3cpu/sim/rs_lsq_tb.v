`timescale 1ns / 1ps
`include "defines.vh"

module rs_lsq_tb();
    reg clk, rst, rollback;
    reg RSLSQ_we;
    reg [`LSQ_OP_WIDTH - 1:0] Op_in;
    reg [31:0] Vj_in;
    reg [31:0] Vk_in;
    reg [`ROB_ENTRY_WIDTH - 1:0] Qj_in;
    reg [`ROB_ENTRY_WIDTH - 1:0] Qk_in;
    reg [`ROB_ENTRY_WIDTH - 1:0] Offset_in;
    reg [`ROB_ENTRY_WIDTH - 1:0] Dest_in;
    reg [`ROB_ENTRY_WIDTH - 1:0] CDB_ALU_ROB_index;
    reg [31:0] CDB_ALU_data;
    reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit;
    
    wire full, empty;
    wire mem_rd_ready, mem_wr_ready;
    wire [`LSQ_OP_WIDTH - 1:0] Op_out;
    wire [31:0] Addr_out;
    wire [31:0] mem_rd_data;
    wire [31:0] mem_wr_data;
    
    wire [31:0] rd_data;
    wire [`ROB_ENTRY_WIDTH - 1:0] Dest_out;
    
    
    initial begin
        clk = 1;
        forever begin
            #1 clk = ~clk;
        end
    end
    
    initial begin
        rst = 1; rollback = 0;
        #2 rst = 0;
    end
    
    initial begin
        RSLSQ_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Offset_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
        ROB_index_commit = 0;
        #1;
        @(posedge clk) RSLSQ_we = 1; Op_in = `LW; Vj_in = 0; Offset_in = 4; Dest_in = 1;
        #1 
        RSLSQ_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Offset_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
        ROB_index_commit = 0;
        #1;
        @(posedge clk) RSLSQ_we = 1; Op_in = `SW; Vj_in = 0; Vk_in = 32'd12; Offset_in = 4; Dest_in = 2;
        #1 
        RSLSQ_we = 0;
        Op_in = 0;
        Vj_in = 0;
        Vk_in = 0;
        Qj_in = 0;
        Qk_in = 0;
        Offset_in = 0;
        Dest_in = 0;
        CDB_ALU_ROB_index = 0;
        CDB_ALU_data = 0;
        ROB_index_commit = 0;
         #1;
        @(posedge clk) ROB_index_commit = 2;
        #2 ROB_index_commit = 0;
    
    end
    
    RSLSQ test_RSLSQ (
        .clk(clk),
        .rst(rst),
        .rollback(rollback),
        .full(full),
        .empty(empty),
        .issue_we(RSLSQ_we),
        .Op_in(Op_in),
        .Vj_in(Vj_in),
        .Vk_in(Vk_in),
        .Qj_in(Qj_in),
        .Qk_in(Qk_in),
        .Offset_in(Offset_in),
        .Dest_in(Dest_in),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .Op_out(Op_out),
        .Addr_out(Addr_out),
        .mem_rd_ready(mem_rd_ready),
        .mem_rd_data(mem_rd_data),
        .mem_wr_ready(mem_wr_ready),
        .mem_wr_data(mem_wr_data),
        .ROB_index_commit(ROB_index_commit),
        .rd_data(rd_data),
        .Dest_out(Dest_out)
    );
   
    
    
    RAM M_RAM (
        .clk(~clk),
        .mem_ctrl(Op_out),
        .wr_addr(Addr_out),
        .wr_data(mem_wr_data),
        .rd_addr(Addr_out),
        .rd_ready(mem_rd_ready),
        .wr_ready(mem_wr_ready),
        .rd_data(mem_rd_data)
    );
endmodule
