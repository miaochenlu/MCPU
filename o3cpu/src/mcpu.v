`timescale 1ns / 1ps
`include "defines.vh"

module MCPU (
    input clk,
    input rst
);
    // Fetch
    wire [31:0]                     PC_IF;
    wire [31:0]                     inst_IF;
    wire [31:0]                     NextPC; 
    wire [31:0]                     PC_p4;

    wire                            PC_EN_IF;
    wire                            IF_ID_EN;
    wire                            IF_ID_Stall;
    wire                            IF_ID_Flush;

    // Decode
    wire [31:0]                     PC_ID;
    wire [31:0]                     inst_ID;
    wire [ 6:0]                     OpCode_ID;
    wire [`FU_WIDTH - 1:0]          FUType_ID;
    wire                            RegWrite_ID;
    wire                            ROBWrite_en_ID;
    wire [ 3:0]                     ImmSel_ID;
    wire [ 1:0]                     OpASel_ID;
    wire [ 1:0]                     OpBSel_ID;
    wire [`ALU_OP_WIDTH - 1:0]      ALUCtrl_ID;
    wire [`LSQ_OP_WIDTH - 1:0]      MemCtrl_ID;
    wire [`BRA_OP_WIDTH - 1:0]      BRACtrl_ID;

    wire                            ID_RN_EN;
    wire                            ID_RN_Flush;
    wire                            ID_RN_Stall;

    // Renaming
    wire [31:0]                     PC_RN;
    wire [31:0]                     inst_RN;
    wire [ 6:0]                     OpCode_RN;
    wire [`FU_WIDTH - 1:0]          FUType_RN;
    wire                            RegWrite_RN;
    wire                            ROBWrite_en_RN;
    wire [ 3:0]                     ImmSel_RN;
    wire [ 1:0]                     OpASel_RN;
    wire [ 1:0]                     OpBSel_RN;
    wire [`ALU_OP_WIDTH - 1:0]      ALUCtrl_RN;
    wire [`LSQ_OP_WIDTH - 1:0]      MemCtrl_RN;
    wire [`BRA_OP_WIDTH - 1:0]      BRACtrl_RN;

    wire                            RAT_rollback;
    wire                            RAT_valid1_RN;
    wire                            RAT_valid2_RN;
    wire [31:0]                     RAT_rdata1_RN;
    wire [31:0]                     RAT_rdata2_RN;

    wire                            ROB_full;
    wire                            ROB_empty;
    wire                            ROB_rollback;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_rindex1_RN;
    wire [31:0]                     ROB_rdata1_RN;
    wire                            ROB_ready1_RN;
    
    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_rindex2_RN;
    wire [31:0]                     ROB_rdata2_RN;
    wire                            ROB_ready2_RN;

    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_windex;
    wire                            ROB_we;
    wire [ 4:0]                     ROB_addr_commit;
    wire [31:0]                     ROB_data_commit;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_index_commit2reg;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_index_commit2lsq;

    wire                            ROB_IsBranch;
    wire [31:0]                     ROB_BranchInstPC;
    wire                            ROB_BranchTaken;
    wire                            ROB_MisPredict;
    wire [31:0]                     ROB_JumpAddr;

    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_dest_RN;

    wire [31:0]                     Imm_RN;

    wire [31:0]                     OpAValue_RN;
    wire [`ROB_ENTRY_WIDTH - 1:0]   OpA_ROB_index_RN;
    wire [31:0]                     OpBValue_RN;
    wire [`ROB_ENTRY_WIDTH - 1:0]   OpB_ROB_index_RN;

    wire                            RN_DP_EN;
    wire                            RN_DP_Flush;
    wire                            RN_DP_Stall;

    // Dispatch

    wire [31:0]                     PC_DP;
    wire [31:0]                     inst_DP;
    wire [ 6:0]                     OpCode_DP;
    wire [`FU_WIDTH - 1:0]          FUType_DP;
    wire [ 1:0]                     OpASel_DP;
    wire [ 1:0]                     OpBSel_DP;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ROB_dest_DP;
    wire [`ALU_OP_WIDTH - 1:0]      ALUCtrl_DP;
    wire [`LSQ_OP_WIDTH - 1:0]      MemCtrl_DP;
    wire [`BRA_OP_WIDTH - 1:0]      BRACtrl_DP;
    wire [31:0]                     Imm_DP;
    wire [31:0]                     OpAValue_DP;
    wire [`ROB_ENTRY_WIDTH - 1:0]   OpA_ROB_index_DP;
    wire [31:0]                     OpBValue_DP;
    wire [`ROB_ENTRY_WIDTH - 1:0]   OpB_ROB_index_DP;

    wire                            RSALU_we;
    wire                            RSBRA_we;
    wire                            RSLSQ_we;

    wire                            RSALU_full;
    wire                            RSLSQ_full;
    wire                            RSBRA_full;
    wire                            RSALU_rollback;
    wire                            RSLSQ_rollback;
    wire                            RSBRA_rollback;

    wire [`ALU_OP_WIDTH - 1:0]      ALUOp;
    wire [31:0]                     ALUSrcA;
    wire [31:0]                     ALUSrcB;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ALUDest_in;

    wire [`LSQ_OP_WIDTH - 1:0]      LSQOp;
    wire [31:0]                     LSQAddr;

    wire [31:0]                     LSQ_rd_data;
    wire [`ROB_ENTRY_WIDTH - 1:0]   LSQDest_out;

    wire [`BRA_OP_WIDTH - 1:0]      BRAOp;
    wire [31:0]                     BRASrcA;
    wire [31:0]                     BRASrcB;
    wire [31:0]                     BRAPC;
    wire [31:0]                     BRAOffset;
    wire [`ROB_ENTRY_WIDTH - 1:0]   BRADest_in;
    // for alu
    wire                            ALUBusy;
    wire                            ALURes_ready;
    wire [31:0]                     ALURes;
    wire [`ROB_ENTRY_WIDTH - 1:0]   ALUDest_out;
    // for ram
    wire                            mem_rd_ready;
    wire [31:0]                     mem_rd_data;
    wire                            mem_wr_ready;
    wire [31:0]                     mem_wr_data;
    // for bra
    wire                            BRA_busy;
    wire                            BRARes_ready;
    wire                            BRAJump_en;
    wire [31:0]                     BRAJumpAddr;
    wire [31:0]                     BRA_Dest_val;
    wire [`ROB_ENTRY_WIDTH - 1:0]   BRADest_out;

    // CDB
    wire [31:0]                     CDB_ALU_data;
    wire [`ROB_ENTRY_WIDTH - 1:0]   CDB_ALU_ROB_index;
    wire [31:0]                     CDB_LSQ_data;
    wire [`ROB_ENTRY_WIDTH - 1:0]   CDB_LSQ_ROB_index;
    wire                            CDB_BRA_Jump_en;
    wire [31:0]                     CDB_BRA_JumpAddr;
    wire [31:0]                     CDB_BRA_data;
    wire [`ROB_ENTRY_WIDTH - 1:0]   CDB_BRA_ROB_index;
    
    assign IF_ID_EN = 1;
    assign ID_RN_EN = 1;
    assign RN_DP_EN = 1;

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
        .in1(ROB_JumpAddr),
        .sel(ROB_BranchTaken && ROB_IsBranch),
        .out(NextPC)
    );
    
    IF_ID M_IF_ID (
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

    Decoder M_Decoder (
        .inst(inst_ID),
        .FUType(FUType_ID),
        .OpCode(OpCode_ID),
        .RegWrite(RegWrite_ID),
        .ROBWrite_en(ROBWrite_en_ID),
        .ImmSel(ImmSel_ID),
        .OpASel(OpASel_ID),
        .OpBSel(OpBSel_ID),
        .ALUCtrl(ALUCtrl_ID),
        .MemCtrl(MemCtrl_ID),
        .BRACtrl(BRACtrl_ID)
    );

    HazardUnit M_HazardUnit (
        .FUType(FUType_DP),
        .ROB_full(ROB_full),
        .RSALU_full(RSALU_full),
        .RSLSQ_full(RSLSQ_full),
        .RSBRA_full(RSBRA_full),
        .MisPredict(ROB_MisPredict),
        .PC_EN_IF(PC_EN_IF),
        .IF_ID_Stall(IF_ID_Stall),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_RN_Stall(ID_RN_Stall),
        .ID_RN_Flush(ID_RN_Flush),
        .RN_DP_Stall(RN_DP_Stall),
        .RN_DP_Flush(RN_DP_Flush),
        .ROB_rollback(ROB_rollback),
        .RAT_rollback(RAT_rollback),
        .RSLSQ_rollback(RSLSQ_rollback),
        .RSALU_rollback(RSALU_rollback),
        .RSBRA_rollback(RSBRA_rollback)
    );

    ID_RN M_ID_RN (
        .clk(clk),
        .rst(rst),
        .EN(ID_RN_EN),
        .flush(ID_RN_Flush),
        .stall(ID_RN_Stall),

        .PC_ID(PC_ID),
        .inst_ID(inst_ID),
        .OpCode_ID(OpCode_ID),
        .FUType_ID(FUType_ID),
        .RegWrite_ID(RegWrite_ID),
        .ROBWrite_en_ID(ROBWrite_en_ID),
        .ImmSel_ID(ImmSel_ID),
        .OpASel_ID(OpASel_ID),
        .OpBSel_ID(OpBSel_ID),
        .ALUCtrl_ID(ALUCtrl_ID),
        .MemCtrl_ID(MemCtrl_ID),
        .BRACtrl_ID(BRACtrl_ID),

        .PC_RN(PC_RN),
        .inst_RN(inst_RN),
        .OpCode_RN(OpCode_RN),
        .FUType_RN(FUType_RN),
        .RegWrite_RN(RegWrite_RN),
        .ROBWrite_en_RN(ROBWrite_en_RN),
        .ImmSel_RN(ImmSel_RN),
        .OpASel_RN(OpASel_RN),
        .OpBSel_RN(OpBSel_RN),
        .ALUCtrl_RN(ALUCtrl_RN),
        .MemCtrl_RN(MemCtrl_RN),
        .BRACtrl_RN(BRACtrl_RN)
    );

    /**********************RENAMING*********************/
    RAT M_RAT (
        .clk(clk),
        .rst(rst),
        .rollback(RAT_rollback),
        // read operands
        .raddr1(inst_RN[19:15]),
        .valid1(RAT_valid1_RN),
        .rdata1(RAT_rdata1_RN),
        .ROB_index1_out(ROB_rindex1_RN),
        .raddr2(inst_RN[24:20]),
        .valid2(RAT_valid2_RN),
        .rdata2(RAT_rdata2_RN),
        .ROB_index2_out(ROB_rindex2_RN),
        // register renaming  decode set dest reg
        .dec_we(RegWrite_RN & (~ID_RN_Stall) & ~(ID_RN_Flush)),
        .waddr(inst_RN[11:7]),
        .ROB_index_in(ROB_windex),
        // ROB commit
        .ROB_we(ROB_we),
        .ROB_addr_commit(ROB_addr_commit),
        .ROB_data_commit(ROB_data_commit),
        .ROB_index_commit(ROB_index_commit2reg)
    );

    ROB M_ROB (
        .clk(clk),
        .rst(rst),
        .rollback(ROB_rollback),
        .full(ROB_full),
        .empty(ROB_empty),
        .ROB_rindex1(ROB_rindex1_RN),
        .ROB_rdata1(ROB_rdata1_RN),
        .ready1(ROB_ready1_RN),

        .ROB_rindex2(ROB_rindex2_RN),
        .ROB_rdata2(ROB_rdata2_RN),
        .ready2(ROB_ready2_RN),
        
        // register renaming
        .write_en(ROBWrite_en_RN & (~ID_RN_Stall) & (~ID_RN_Flush)), // every inst should have an ROB entry
        .pc_in(PC_RN),
        .OpCode_in(OpCode_RN),
        .waddr_in(inst_RN[11:7] & {5{RegWrite_RN}}),
        .branch_pred_taken(1'd0), //predict not taken
        .ROB_windex(ROB_windex),

        .ROB_we(ROB_we),
        .addr_commit(ROB_addr_commit),
        .data_commit(ROB_data_commit),
        .ROB_index_commit2reg(ROB_index_commit2reg),

        .ROB_index_commit2lsq(ROB_index_commit2lsq),

        .IsBranch_out(ROB_IsBranch),
        .BranchInstPC_out(ROB_BranchInstPC),
        .BranchTaken_out(ROB_BranchTaken),
        .MisPredict_out(ROB_MisPredict),
        .JumpAddr_out(ROB_JumpAddr),
        
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_Jump_en(CDB_BRA_Jump_en),
        .CDB_BRA_JumpAddr(CDB_BRA_JumpAddr),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data)
    );

    assign ROB_dest_RN = ROB_windex;

    ImmGen M_ImmGen (
        .inst(inst_RN),
        .ImmSel(ImmSel_RN),
        .imm(Imm_RN)
    );

    // read operands from Regfile & ROB
    OperandAManager M_OperandAManager (
        .OpASel(OpASel_RN),
        .PC(PC_RN),
        .RAT_valid(RAT_valid1_RN),
        .RAT_value(RAT_rdata1_RN),
        .ROB_ready(ROB_ready1_RN),
        .ROB_index_in(ROB_rindex1_RN),
        .ROB_value(ROB_rdata1_RN),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data),
        .OpAValue(OpAValue_RN),
        .ROB_index_out(OpA_ROB_index_RN)
    );

    OperandBManager M_OperandBManager (
        .OpBSel(OpBSel_RN),
        .imm(Imm_RN),
        .RAT_valid(RAT_valid2_RN),
        .RAT_value(RAT_rdata2_RN),
        .ROB_ready(ROB_ready2_RN),
        .ROB_index_in(ROB_rindex2_RN),
        .ROB_value(ROB_rdata2_RN),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data),
        .OpBValue(OpBValue_RN),
        .ROB_index_out(OpB_ROB_index_RN)
    );

    RN_DP M_RN_DP (
        .clk(clk),
        .rst(rst),
        .EN(RN_DP_EN),
        .flush(RN_DP_Flush),
        .stall(RN_DP_Stall),

        .PC_RN(PC_RN),
        .inst_RN(inst_RN),
        .OpCode_RN(OpCode_RN),
        .FUType_RN(FUType_RN),
        .OpASel_RN(OpASel_RN),
        .OpBSel_RN(OpBSel_RN),
        .ROB_dest_RN(ROB_dest_RN),
        .ALUCtrl_RN(ALUCtrl_RN),
        .MemCtrl_RN(MemCtrl_RN),
        .BRACtrl_RN(BRACtrl_RN),
        .Imm_RN(Imm_RN),
        .OpAValue_RN(OpAValue_RN),
        .OpA_ROB_index_RN(OpA_ROB_index_RN),
        .OpBValue_RN(OpBValue_RN),
        .OpB_ROB_index_RN(OpB_ROB_index_RN),

        .PC_DP(PC_DP),
        .inst_DP(inst_DP),
        .OpCode_DP(OpCode_DP),
        .FUType_DP(FUType_DP),
        .OpASel_DP(OpASel_DP),
        .OpBSel_DP(OpBSel_DP),
        .ROB_dest_DP(ROB_dest_DP),
        .ALUCtrl_DP(ALUCtrl_DP),
        .MemCtrl_DP(MemCtrl_DP),
        .BRACtrl_DP(BRACtrl_DP),
        .Imm_DP(Imm_DP),
        .OpAValue_DP(OpAValue_DP),
        .OpA_ROB_index_DP(OpA_ROB_index_DP),
        .OpBValue_DP(OpBValue_DP),
        .OpB_ROB_index_DP(OpB_ROB_index_DP)
    );
    /**********************DISPATCH*******************/
    
    // choose the function unit
    RSManager M_RSManager (
        .FUType(FUType_DP),
        .RSALU_we(RSALU_we),
        .RSBRA_we(RSBRA_we),
        .RSLSQ_we(RSLSQ_we)
    );


    // write to RS
    RSALU M_RSALU (
        .clk(clk),
        .rst(rst),
        .rollback(RSALU_rollback),
        .full(RSALU_full),
        .issue_we(RSALU_we && (~RN_DP_Stall) && (~RN_DP_Flush)),
        .Op_in(ALUCtrl_DP),
        .Vj_in(OpAValue_DP),
        .Vk_in(OpBValue_DP),
        .Qj_in(OpA_ROB_index_DP),
        .Qk_in(OpB_ROB_index_DP),
        .Dest_in(ROB_dest_DP),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data),
        .Op_out(ALUOp),
        .Vj_out(ALUSrcA),
        .Vk_out(ALUSrcB),
        .Dest_out(ALUDest_in)
    );

    RSLSQ M_RSLSQ (
        .clk(clk),
        .rst(rst),
        .rollback(RSLSQ_rollback),
        .full(RSLSQ_full),
        .empty(),
        .issue_we(RSLSQ_we && (~RN_DP_Stall) && (~RN_DP_Flush)),
        .Op_in(MemCtrl_DP),
        .Vj_in(OpAValue_DP),
        .Vk_in(OpBValue_DP),
        .Qj_in(OpA_ROB_index_DP),
        .Qk_in(OpB_ROB_index_DP),
        .Offset_in(Imm_DP),
        .Dest_in(ROB_dest_DP),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data),
        .Op_out(LSQOp),
        .Addr_out(LSQAddr),
        .mem_rd_ready(mem_rd_ready),
        .mem_rd_data(mem_rd_data),
        .mem_wr_ready(mem_wr_ready),
        .mem_wr_data(mem_wr_data),
        .ROB_index_commit(ROB_index_commit2lsq),
        .rd_data(LSQ_rd_data),
        .Dest_out(LSQDest_out)
    );

    RSBRA M_RSBRA (
        .clk(clk),
        .rst(rst),
        .rollback(RSBRA_rollback),
        .full(RSBRA_full),
        .issue_we(RSBRA_we && (~RN_DP_Stall) && (~RN_DP_Flush)),
        .Op_in(BRACtrl_DP),
        .Vj_in(OpAValue_DP),
        .Vk_in(OpBValue_DP),
        .Qj_in(OpA_ROB_index_DP),
        .Qk_in(OpB_ROB_index_DP),
        .PC_in(PC_DP),
        .Offset_in(Imm_DP),
        .Dest_in(ROB_dest_DP),
        .CDB_ALU_ROB_index(CDB_ALU_ROB_index),
        .CDB_ALU_data(CDB_ALU_data),
        .CDB_LSQ_ROB_index(CDB_LSQ_ROB_index),
        .CDB_LSQ_data(CDB_LSQ_data),
        .CDB_BRA_ROB_index(CDB_BRA_ROB_index),
        .CDB_BRA_data(CDB_BRA_data),
        .func_busy(BRA_busy),
        .Op_out(BRAOp),
        .Vj_out(BRASrcA),
        .Vk_out(BRASrcB),
        .PC_out(BRAPC),
        .Offset_out(BRAOffset),
        .Dest_out(BRADest_in)
    );

/**********************Execute*******************/

    ALU M_ALU (
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .Dest_in(ALUDest_in),
        .busy(ALUBusy),
        .res_ready(ALURes_ready),
        .res(ALURes),
        .Dest_out(ALUDest_out),
        .zero(),
        .overflow()
    );


    RAM M_RAM (
        .clk(~clk),
        .mem_ctrl(LSQOp),
        .wr_addr(LSQAddr),
        .wr_data(mem_wr_data),
        .rd_addr(LSQAddr),
        .rd_ready(mem_rd_ready),
        .wr_ready(mem_wr_ready),
        .rd_data(mem_rd_data)
    );

    BRA M_BRA (
        .BRAOp(BRAOp),
        .BRASrcA(BRASrcA),
        .BRASrcB(BRASrcB),
        .PC(BRAPC),
        .Offset(BRAOffset),
        .Dest_in(BRADest_in),
        .busy(BRA_busy),
        .res_ready(BRARes_ready),
        .Jump_en(BRAJump_en),
        .JumpAddr(BRAJumpAddr),
        .Dest_val(BRA_Dest_val),
        .Dest_out(BRADest_out)
    );

    CDB M_CDB (
        .CDB_ALUData_in(ALURes),
        .CDB_ALUDest_in(ALUDest_out),
        .CDB_ALUData_out(CDB_ALU_data),
        .CDB_ALUDest_out(CDB_ALU_ROB_index),

        .CDB_LSQData_in(LSQ_rd_data),
        .CDB_LSQDest_in(LSQDest_out),
        .CDB_LSQData_out(CDB_LSQ_data),
        .CDB_LSQDest_out(CDB_LSQ_ROB_index),

        .CDB_BRAJump_en_in(BRAJump_en),
        .CDB_BRAJumpAddr_in(BRAJumpAddr),
        .CDB_BRAData_in(BRA_Dest_val),
        .CDB_BRADest_in(BRADest_out),
        .CDB_BRAJump_en_out(CDB_BRA_Jump_en),
        .CDB_BRAJumpAddr_out(CDB_BRA_JumpAddr),
        .CDB_BRAData_out(CDB_BRA_data),
        .CDB_BRADest_out(CDB_BRA_ROB_index)
    );

endmodule