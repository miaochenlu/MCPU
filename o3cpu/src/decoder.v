`timescale 1ns / 1ps
`include "defines.vh"

module Decoder(
    input [31:0] inst,
    // which fuction unit
    output [2:0] FUType,
    output RS1Use,
    output RS2Use,
    output RegWrite,
    output [3:0] ImmSel,
    output ALUSrcASel,
    output ALUSrcBSel,

    // ALU function unit
    output [3:0] ALUCtrl,

    // load store function unit
    output [2:0] MemRdCtrl,
    output [1:0] MemWrCtrl,
    output MemRW,

    // branch unit
    output [2:0] BrType,
    output Jalr,
    output Jal,
);
 
    wire    [6:0]   opcode;
    wire    [2:0]   funct3;
    wire    [6:0]   funct7;
    
    assign  opcode  = inst[6:0];
    assign  funct7  = inst[31:25];
    assign  funct3  = inst[14:12];
    
    // R type insts
    wire  is_add  = (opcode == `R_OP) && (funct3 ==3'h0) && (funct7 == 7'h00);
    wire  is_sub  = (opcode == `R_OP) && (funct3 ==3'h0) && (funct7 == 7'h20);
    wire  is_sll  = (opcode == `R_OP) && (funct3 ==3'h1) && (funct7 == 7'h00);
    wire  is_slt  = (opcode == `R_OP) && (funct3 ==3'h2) && (funct7 == 7'h00);
    wire  is_sltu = (opcode == `R_OP) && (funct3 ==3'h3) && (funct7 == 7'h00);
    wire  is_xor  = (opcode == `R_OP) && (funct3 ==3'h4) && (funct7 == 7'h00);
    wire  is_srl  = (opcode == `R_OP) && (funct3 ==3'h5) && (funct7 == 7'h00);
    wire  is_sra  = (opcode == `R_OP) && (funct3 ==3'h5) && (funct7 == 7'h20);
    wire  is_or   = (opcode == `R_OP) && (funct3 ==3'h6) && (funct7 == 7'h00);
    wire  is_and  = (opcode == `R_OP) && (funct3 ==3'h7) && (funct7 == 7'h00);
    
    // I MEM type insts
    wire  is_lb   = (opcode == `I_MEM_OP) && (funct3 ==3'h0) ;
    wire  is_lh   = (opcode == `I_MEM_OP) && (funct3 ==3'h1) ;
    wire  is_lw   = (opcode == `I_MEM_OP) && (funct3 ==3'h2) ;
    wire  is_lbu  = (opcode == `I_MEM_OP) && (funct3 ==3'h4) ;
    wire  is_lhu  = (opcode == `I_MEM_OP) && (funct3 ==3'h5) ;
    
    // I Logic type insts    
    wire  is_addi = (opcode == `I_LOGIC_OP) && (funct3 ==3'h0) ;
    wire  is_slti = (opcode == `I_LOGIC_OP) && (funct3 ==3'h2) ;
    wire  is_sltiu= (opcode == `I_LOGIC_OP) && (funct3 ==3'h3) ;
    wire  is_xori = (opcode == `I_LOGIC_OP) && (funct3 ==3'h4) ;
    wire  is_ori  = (opcode == `I_LOGIC_OP) && (funct3 ==3'h6) ;
    wire  is_andi = (opcode == `I_LOGIC_OP) && (funct3 ==3'h7) ;
    wire  is_slli = (opcode == `I_LOGIC_OP) && (funct3 ==3'h1) && (funct7 == 7'h00);
    wire  is_srli = (opcode == `I_LOGIC_OP) && (funct3 ==3'h5) && (funct7 == 7'h00);
    wire  is_srai = (opcode == `I_LOGIC_OP) && (funct3 ==3'h5) && (funct7 == 7'h20);
    
    // I JALR inst
    wire  is_jalr = (opcode == `I_JALR_OP) && (funct3 ==3'h0) ;
    
    // S type insts    
    wire  is_sb   = (opcode == `S_OP) && (funct3 ==3'h0) ;
    wire  is_sh   = (opcode == `S_OP) && (funct3 ==3'h1) ;
    wire  is_sw   = (opcode == `S_OP) && (funct3 ==3'h2) ;
    
    // B type insts
    wire  is_beq  = (opcode == `B_OP) && (funct3 ==3'h0) ;
    wire  is_bne  = (opcode == `B_OP) && (funct3 ==3'h1) ;
    wire  is_blt  = (opcode == `B_OP) && (funct3 ==3'h4) ;
    wire  is_bge  = (opcode == `B_OP) && (funct3 ==3'h5) ;
    wire  is_bltu = (opcode == `B_OP) && (funct3 ==3'h6) ;
    wire  is_bgeu = (opcode == `B_OP) && (funct3 ==3'h7) ;

    // U type insts    
    wire  is_lui  = (opcode == `U_LUI_OP) ;
    wire  is_auipc= (opcode == `U_AUIPC_OP) ;
    
    // J type inst
    wire  is_jal  = (opcode == `J_OP) ;
    
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

    assign RS1Use   = is_R_type | is_I_type | is_S_type | is_B_type | is_jalr;
    assign RS2Use   = is_R_type | is_S_type | is_B_type;
    assign RegWrite = is_R_type | is_I_type | is_U_type | is_J_type;                                                                          
    
    assign ImmSel = {3{is_I_type}} & `I_TYPE_IMM
                  | {3{is_S_type}} & `S_TYPE_IMM
                  | {3{is_B_type}} & `B_TYPE_IMM
                  | {3{is_J_type}} & `J_TYPE_IMM
                  | {3{is_U_type}} & `U_TYPE_IMM;

    assign ALUSrcASel = is_R_type | is_I_MEM_type | is_I_LOGIC_type | is_S_type; // 0 for pc; 1 for reg
    assign ALUSrcBSel = is_R_type; // 1 for reg; 0 for imm
    
    assign ALUCtrl = {4{is_add | is_addi | is_I_MEM_type | is_S_type | is_auipc}} & `ADD
                   | {4{is_sub}} & `SUB
                   | {4{is_and | is_andi}} & `AND
                   | {4{is_or  | is_ori}} & `OR
                   | {4{is_xor | is_xori}} & `XOR
                   | {4{is_sll | is_slli}} & `SLL
                   | {4{is_srl | is_srli}} & `SRL
                   | {4{is_slt | is_slti}} & `SLT
                   | {4{is_sltu | is_sltiu}} & `SLTU
                   | {4{is_sra | is_srai}} & `SRA
                   | {4{is_jal | is_jalr}} & `AP4
                   | {4{is_lui}} & `OUTB;

    assign MemRW = is_S_type;
    assign MemRdCtrl = ({3{is_lb}}  & `LB)
                     | ({3{is_lbu}} & `LBU)
                     | ({3{is_lh}}  & `LH)
                     | ({3{is_lhu}} & `LHU)
                     | ({3{is_lw}}  & `LW);
    assign MemWrCtrl = ({3{is_sb}} & `SB)
                     | ({3{is_sh}} & `SH)
                     | ({3{is_sw}} & `SW);                  
    
    
    assign BrType = ({3{is_beq}}  & `BEQ)
                  | ({3{is_bne}}  & `BNE)
                  | ({3{is_blt}}  & `BLT)
                  | ({3{is_bge}}  & `BGE)
                  | ({3{is_bltu}} & `BLTU)
                  | ({3{is_bgeu}} & `BGEU);
    assign Jal  = is_J_type;
    assign Jalr = is_jalr;
    
endmodule