`timescale 1ns / 1ps
`include "defines.vh"
// https://github.com/Ting0325/ICLAB_project/tree/master/src
// https://github.com/XOR-op/TransistorU
module MCPU (
    input clk,
    input rst
);

    // Fetch
    wire PC_EN_IF;
    wire IF_IS_EN; 
    wire IF_IS_Stall;
    wire IF_IS_Flush;
    wire [31:0] PC_IF;
    wire [31:0] inst_IF;
    wire [31:0] NextPC;
    wire [31:0] PC_p4;

    /**********************fetch*********************/
    PC M_PC(
        .clk(clk), 
        .rst(rst),
        .CE(PC_EN_IF),
        .pc_in(NextPC), 
        .pc_out(PC_IF)
    );

    ROM M_ROM (
        .addr(PC_IF[8:2]),
        .rd_data(inst_IF)
    );

    assign PC_p4 = PC_IF + 32'd4;

    Mux21_32 M_Mux21_32_PCSrc(
        .in0(PC_p4),
        .in1(JumpPC),
        .sel(DoJump),
        .out(NextPC)
    );

    IF_IS M_IF_ID (
        .clk(clk),
        .rst(rst),
        .EN(IF_ID_EN),
        .stall(IF_ID_Stall),
        .flush(IF_ID_Flush),
        .PC_IF(PC_IF),
        .inst_IF(inst_IF),
        .PC_ID(PC_ID),
        .inst_ID(inst_ID)
    );

    /**********************decode*********************/

    wire [3:0] FUType_ID;
    wire RS1Use_ID, RS2Use_ID;
    wire RegWrite_ID;
    wire [2:0] ImmSel_ID;
    wire ALUSrcASel_ID, ALUSrcBSel_ID;
    wire [3:0] ALUCtrl_ID;
    wire [2:0] MemRdCtrl_ID;
    wire [1:0] MemWrCtrl_ID;
    wire MemRW_ID;
    wire [2:0] BrType_ID;
    wire Jalr;
    wire Jal;

    wire [31:0] imm_ID;

    wire valid1;
    wire [31:0] RAT_rdata1;
    wire [`ROB_ENTRY_WIDTH - 1:0] ROB_index1_out;
    wire valid2;
    wire [31:0] RAT_rdata2;
    wire [`ROB_ENTRY_WIDTH - 1:0] ROB_index2_out;

    wire full, empty;
    wire [31:0] ROB_rdata1;
    wire ready1;
    wire [31:0] ROB_rdata2;
    wire ready2;
    wire [`ROB_ENTRY_NUM - 1:0] ROB_windex;
    wire ROB_we;
    wire [ 4:0] ROB_addr_commit;
    wire [31:0] ROB_data_commit;
    wire [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit;

    Decoder M_Decoder (
        .inst(inst_ID),
        .FUType(FUType_ID),
        .RS1Use(RS1Use_ID),
        .RS2Use(RS2Use_ID),
        .RegWrite(RegWrite_ID),
        .ImmSel(ImmSel_ID),
        .ALUSrcASel(ALUSrcASel_ID),
        .ALUSrcBSel(ALUSrcBSel_ID),
        .ALUCtrl(ALUCtrl_ID),
        .MemRdCtrl(MemRdCtrl_ID),
        .MemWrCtrl(MemWrCtrl_ID),
        .MemRW(MemRW_ID),
        .BrType(BrType_ID),
        .Jalr(Jalr),
        .Jal(Jal)
    );

    ID_DP M_ID_DP (

    );

    /**********************RENAMING*********************/
    RAT M_RAT (
        .clk(clk),
        .rst(rst),
        .rollback(rollback),
        // read operands
        .raddr1(inst_IS[19:15]),
        .valid1(valid1),
        .rdata1(RAT_rdata1),
        .ROB_index1_out(ROB_index1_out),
        .raddr2(inst_IS[24:20]),
        .valid2(valid2),
        .rdata2(RAT_rdata2),
        .ROB_index2_out(ROB_index2_out),
        // register renaming  decode set dest reg
        .dec_we(RegWrite_DP),
        .waddr(inst_DP[11:7]),
        .ROB_index_in(ROB_windex),
        // ROB commit
        .ROB_we(ROB_we),
        .ROB_addr_commit(ROB_addr_commit),
        .ROB_data_commit(ROB_data_commit),
        .ROB_index_commit(ROB_index_commit)
    );

    ReorderBuffer M_ROB (
        .clk(clk),
        .rst(rst),
        .full(full),
        .empty(empty),
        .read_en1(RS1Use_IS),
        .ROB_rindex1(ROB_rindex1),
        .ROB_rdata1(ROB_rdata1),
        .ready1(ready1),

        .read_en2(RS2Use_IS),
        .ROB_raddr2(ROB_rindex2),
        .ROB_rdata2(ROB_rdata2),
        .ready2(ready2),
        // register renaming
        .write_en(RegWrite_DP),
        .waddr(inst_DP[11:7]),
        .pc_in(PC_DP),
        .inst_in(inst_DP),
        .ROB_windex(ROB_windex),

        .ROB_we(ROB_we),
        .addr_commit(ROB_addr_commit),
        .data_commit(ROB_data_commit),
        .ROB_index_commit(ROB_index_commit)
    );


/**********************DISPATCH*******************/
    
    // choose the function unit
    RSManager M_RSManager (
        .FUType(FUType_IS),
        .RSALU_we(RSALU_we),
        .RSBRA_we(RSBRA_we),
        .RSLSQ_we(RSLSQ_we)
    );

    ImmGen M_ImmGen (
        .inst(inst_DP),
        .ImmSel(ImmSel_DP),
        .imm(imm_DP)
    );

    // read operands from Regfile & ROB
    OperandAManager M_OperandAManager (
        .SrcASel(SrcASel_DP),
        .PC(PC_DP),
        .RAT_valid(RAT_valid1),
        .RAT_value(RAT_rdata1),
        .ROB_ready(ROB_ready1),
        .ROB_index_in(ROB_rindex1),
        .ROB_value(ROB_rdata1),
        .OpAValue(OpAValue),
        .ROB_index_out(OpA_ROB_index)
    );

    OperandBManager M_OperandBManager (
        .SrcBSel(SrcBSel_DP),
        .imm(imm_DP),
        .RAT_valid(RAT_valid2),
        .RAT_value(RAT_rdata2),
        .ROB_ready(ROB_ready2),
        .ROB_index_in(ROB_rindex2),
        .ROB_value(ROB_rdata2),
        .OpBValue(OpBValue),
        .ROB_index_out(OpB_ROB_index)
    );


    // write to RS
    RSALU M_RSALU (
        .clk(clk),
        .rst(rst),
        .full(RSALU_full),

        .issue_we(RSALU_we),
        .Op_in(ALUCtrl_DP),
        .Vj_in(OpAValue),
        .Vk_in(OpBValue),
        .Qj_in(OpA_ROB_index),
        .Qk_in(OpB_ROB_index),
        .Dest_in(Dest_in),
        
        .Op_out(RS_ALUOp),
        .Vj_out(ALUSrcA),
        .Vk_out(ALUSrcB),
        .Dest_out(ALUDest)
    );

/**********************Execute*******************/

    ALU M_ALU (
        .ALUOp(RS_ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .Dest_in(ALUDest_in),
        .busy(ALU_busy),
        .res(ALU_res),
        .Dest_out(ALUDest_out),
        .zero(),
        .overflow()
    );

    CDB M_CDB (
        .ALURes_ready(ALURes_ready),
        .ALUData_in(ALU_res),
        .ALUDest_in(ALUDest_out),
        .ALURes_rec(),
        .ALUData_out(CDB_ALUData_out),
        .ALUDest_out(CDB_ALUDest_out)
    );
/*******************write result*****************/


/********************inst commit*****************/

endmodule