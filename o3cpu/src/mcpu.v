`timescale 1ns / 1ps

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

    IF_IS M_IF_IS (
        .clk(clk),
        .rst(rst),
        .EN(IF_IS_EN),
        .stall(IF_IS_Stall),
        .flush(IF_IS_Flush),
        .PC_IF(PC_IF),
        .inst_IF(inst_IF),
        .PC_IS(PC_IS),
        .inst_IS(inst_IS)
    );

    /**********************issue*********************/

    wire [3:0] FUType_IS;
    wire RS1Use_IS, RS2Use_IS;
    wire RegWrite_IS;
    wire [2:0] ImmSel_IS;
    wire ALUSrcASel_IS, ALUSrcBSel_IS;
    wire [3:0] ALUCtrl_IS;
    wire [2:0] MemRdCtrl_IS;
    wire [1:0] MemWrCtrl_IS;
    wire MemRW_IS;
    wire [2:0] BrType_IS;
    wire Jalr;
    wire Jal;

    wire [31:0] imm_IS;

    wire valid1;
    wire [31:0] RAT_rdata1;
    wire [ROB_ENTRY_WIDTH - 1:0] ROB_index1_out;
    wire valid2;
    wire [31:0] RAT_rdata2;
    wire [ROB_ENTRY_WIDTH - 1:0] ROB_index2_out;

    wire full, empty;
    wire [31:0] ROB_rdata1;
    wire ready1;
    wire [31:0] ROB_rdata2;
    wire ready2;
    wire [ROB_ENTRY_NUM - 1:0] ROB_windex;
    wire ROB_we;
    wire [ 4:0] ROB_addr_commit;
    wire [31:0] ROB_data_commit;
    wire [ROB_ENTRY_WIDTH - 1:0] ROB_index_commit;

    Decoder M_Decoder (
        .inst(inst_IS),
        .FUType(FUType_IS),
        .RS1Use(RS1Use_IS),
        .RS2Use(RS2Use_IS),
        .RegWrite(RegWrite_IS),
        .ImmSel(ImmSel_IS),
        .ALUSrcASel(ALUSrcASel_IS),
        .ALUSrcBSel(ALUSrcBSel_IS),
        .ALUCtrl(ALUCtrl_IS),
        .MemRdCtrl(MemRdCtrl_IS),
        .MemWrCtrl(MemWrCtrl_IS),
        .MemRW(MemRW_IS),
        .BrType(BrType_IS),
        .Jalr(Jalr),
        .Jal(Jal)
    );

    assign is_branch = (FUType_ID == FU_BRA);
    assign branch_valid = is_branch & ;

    ImmGen M_ImmGen (
        .inst(inst_IS),
        .ImmSel(ImmSel_IS),
        .imm(imm_IS)
    );

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
        // decode set dest reg
        .dec_we(RegWrite),
        .waddr(inst_IS[11:7]),
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
        .read_en1(RS1Use & ~valid1),
        .ROB_rindex1(ROB_rindex1),
        .ROB_rdata1(ROB_rdata1),
        .ready1(ready1),

        .read_en2(RS2Use & ~valid2),
        .ROB_raddr2(ROB_rindex2),
        .ROB_rdata2(ROB_rdata2),
        .ready2(ready2),

        .write_en(RegWrite_IS),
        .waddr(inst_IS[11:7]),
        .pc_in(PC_IS),
        .inst_in(inst_IS),
        .ROB_windex(ROB_windex),

        .ROB_we(ROB_we),
        .addr_commit(ROB_addr_commit),
        .data_commit(ROB_data_commit),
        .ROB_index_commit(ROB_index_commit)
    );

    wire [31:0] rdata1, rdata2;


/**********************execute*******************/

/*******************write result*****************/

/********************inst commit*****************/

endmodule