`timescale 1ns / 1ps
`include "defines.vh"

module Decoder(
    input [31:0] inst,
    // which fuction unit
    output [2:0] FUType,
    output [6:0] OpCode,
    output       RegWrite,
    output       ROBWrite_en,
    output [3:0] ImmSel,
    output [1:0] OpASel,
    output [1:0] OpBSel,

    // ALU function unit
    output [`ALU_OP_WIDTH - 1:0] ALUCtrl,

    // load store function unit
    output [`LSQ_OP_WIDTH - 1:0] MemCtrl,

    // branch unit
    output [`BRA_OP_WIDTH - 1:0] BraCtrl
);
    
    wire            IsValidInst;
    wire    [2:0]   funct3;
    wire    [6:0]   funct7;
    
    assign  OpCode  = inst[6:0];
    assign  funct7  = inst[31:25];
    assign  funct3  = inst[14:12];
    
    // R type insts
    wire  is_add  = (OpCode == `R_OP) && (funct3 ==3'h0) && (funct7 == 7'h00);
    wire  is_sub  = (OpCode == `R_OP) && (funct3 ==3'h0) && (funct7 == 7'h20);
    wire  is_sll  = (OpCode == `R_OP) && (funct3 ==3'h1) && (funct7 == 7'h00);
    wire  is_slt  = (OpCode == `R_OP) && (funct3 ==3'h2) && (funct7 == 7'h00);
    wire  is_sltu = (OpCode == `R_OP) && (funct3 ==3'h3) && (funct7 == 7'h00);
    wire  is_xor  = (OpCode == `R_OP) && (funct3 ==3'h4) && (funct7 == 7'h00);
    wire  is_srl  = (OpCode == `R_OP) && (funct3 ==3'h5) && (funct7 == 7'h00);
    wire  is_sra  = (OpCode == `R_OP) && (funct3 ==3'h5) && (funct7 == 7'h20);
    wire  is_or   = (OpCode == `R_OP) && (funct3 ==3'h6) && (funct7 == 7'h00);
    wire  is_and  = (OpCode == `R_OP) && (funct3 ==3'h7) && (funct7 == 7'h00);
    
    // I MEM type insts
    wire  is_lb   = (OpCode == `I_MEM_OP) && (funct3 ==3'h0) ;
    wire  is_lh   = (OpCode == `I_MEM_OP) && (funct3 ==3'h1) ;
    wire  is_lw   = (OpCode == `I_MEM_OP) && (funct3 ==3'h2) ;
    wire  is_lbu  = (OpCode == `I_MEM_OP) && (funct3 ==3'h4) ;
    wire  is_lhu  = (OpCode == `I_MEM_OP) && (funct3 ==3'h5) ;
    
    // I Logic type insts    
    wire  is_addi = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h0) ;
    wire  is_slti = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h2) ;
    wire  is_sltiu= (OpCode == `I_LOGIC_OP) && (funct3 ==3'h3) ;
    wire  is_xori = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h4) ;
    wire  is_ori  = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h6) ;
    wire  is_andi = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h7) ;
    wire  is_slli = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h1) && (funct7 == 7'h00);
    wire  is_srli = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h5) && (funct7 == 7'h00);
    wire  is_srai = (OpCode == `I_LOGIC_OP) && (funct3 ==3'h5) && (funct7 == 7'h20);
    
    // I JALR inst
    wire  is_jalr = (OpCode == `I_JALR_OP) && (funct3 ==3'h0) ;
    
    // S type insts    
    wire  is_sb   = (OpCode == `S_OP) && (funct3 ==3'h0) ;
    wire  is_sh   = (OpCode == `S_OP) && (funct3 ==3'h1) ;
    wire  is_sw   = (OpCode == `S_OP) && (funct3 ==3'h2) ;
    
    // B type insts
    wire  is_beq  = (OpCode == `B_OP) && (funct3 ==3'h0) ;
    wire  is_bne  = (OpCode == `B_OP) && (funct3 ==3'h1) ;
    wire  is_blt  = (OpCode == `B_OP) && (funct3 ==3'h4) ;
    wire  is_bge  = (OpCode == `B_OP) && (funct3 ==3'h5) ;
    wire  is_bltu = (OpCode == `B_OP) && (funct3 ==3'h6) ;
    wire  is_bgeu = (OpCode == `B_OP) && (funct3 ==3'h7) ;

    // U type insts    
    wire  is_lui  = (OpCode == `U_LUI_OP) ;
    wire  is_auipc= (OpCode == `U_AUIPC_OP) ;
    
    // J type inst
    wire  is_jal  = (OpCode == `J_OP) ;
    
/*------------------------------------------------------------------------------------*/    
    wire is_R_type = is_add | is_sub | is_sll | is_slt | is_sltu | is_xor
                   | is_srl | is_sra | is_or | is_and ;
    wire is_I_type = is_lb | is_lh | is_lw | is_lbu | is_lhu
                      | is_addi | is_slti | is_sltiu | is_xori | is_ori | is_andi
                      | is_slli | is_srli | is_srai
                      | is_jalr ;
    wire is_I_MEM_type = is_lb | is_lh | is_lw | is_lbu | is_lhu;
    wire is_I_LOGIC_type = is_addi | is_slti | is_sltiu | is_xori | is_ori | is_andi
                           | is_slli | is_srli | is_srai;   
    wire is_S_type = is_sb | is_sh | is_sw;
    wire is_B_type = is_beq | is_bne | is_blt | is_bge | is_bltu | is_bgeu;
    wire is_J_type = is_jal;
    wire is_U_type = is_lui | is_auipc;
/*------------------------------------------------------------------------------------*/      
    // assign ctrl signals    
    
    // function unit
    assign FUType = ({3{is_R_type | is_I_LOGIC_type | is_U_type}}) & `FU_ALU
                  | ({3{is_I_MEM_type | is_S_type}} & `FU_LSQ)
                  | ({3{is_B_type | is_J_type | is_jalr}} & `FU_BRA);

    assign RegWrite = is_R_type | is_I_type | is_U_type | is_J_type;                                                                          
    
    assign ImmSel = {3{is_I_type}} & `I_TYPE_IMM
                  | {3{is_S_type}} & `S_TYPE_IMM
                  | {3{is_B_type}} & `B_TYPE_IMM
                  | {3{is_J_type}} & `J_TYPE_IMM
                  | {3{is_U_type}} & `U_TYPE_IMM;

    assign OpASel = ({2{is_auipc}} & 2'b01)
                  | ({2{is_R_type | is_I_MEM_type | is_I_LOGIC_type | is_S_type}} & 2'b10);
                         // 0 for pc; 1 for reg
    assign OpBSel = ({2{is_I_LOGIC_type}} & 2'b01)
                  | ({2{is_R_type}} & 2'b10); // 2 for reg; 1 for imm
    
    assign ALUCtrl = {4{is_add | is_addi | is_I_MEM_type | is_S_type | is_auipc}} & `ADD
                   | {4{is_sub}} & `SUB
                   | {4{is_and  | is_andi }} & `AND
                   | {4{is_or   | is_ori  }} & `OR
                   | {4{is_xor  | is_xori }} & `XOR
                   | {4{is_sll  | is_slli }} & `SLL
                   | {4{is_srl  | is_srli }} & `SRL
                   | {4{is_slt  | is_slti }} & `SLT
                   | {4{is_sltu | is_sltiu}} & `SLTU
                   | {4{is_sra  | is_srai }} & `SRA
                   | {4{is_lui}} & `OUTB;

    assign MemCtrl = ({4{is_lb}}  & `LB)
                   | ({4{is_lbu}} & `LBU)
                   | ({4{is_lh}}  & `LH)
                   | ({4{is_lhu}} & `LHU)
                   | ({4{is_lw}}  & `LW)
                   | ({4{is_sb}}  & `SB)
                   | ({4{is_sh}}  & `SH)
                   | ({4{is_sw}}  & `SW);                  
    
    
    assign BraCtrl = ({4{is_beq}}  & `BEQ)
                   | ({4{is_bne}}  & `BNE)
                   | ({4{is_blt}}  & `BLT)
                   | ({4{is_bge}}  & `BGE)
                   | ({4{is_bltu}} & `BLTU)
                   | ({4{is_bgeu}} & `BGEU)
                   | ({4{is_jal }} & `JAL)
                   | ({4{is_jalr}} & `JALR);
    
    assign IsValidInst = is_R_type | is_I_type | is_S_type | is_B_type | is_J_type | is_U_type;
    assign ROBWrite_en = IsValidInst;
    
endmodule