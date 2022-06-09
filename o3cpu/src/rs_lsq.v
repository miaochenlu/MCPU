`timescale 1ns / 1ps
`include "defines.vh"

module RSLSQ (
    input clk,
    input rst,
    output full,

    // issue in
    input issue_we,
    input [5:0] Op_in,
    input [31:0] Vj_in,
    input [31:0] Vk_in,
    input [`ROB_ENTRY_WIDTH - 1:0] Qj_in,
    input [`ROB_ENTRY_WIDTH - 1:0] Dest_in,

    // CDB write result
    input [`ROB_ENTRY_WIDTH - 1:0] CDB_ALU_ROB_index,
    input [31:0] CDB_ALU_data,

    // to function unit
    output [5:0] Op_out,
    output [31:0] Vj_out,
    output [31:0] Vk_out,
    output [`ROB_ENTRY_WIDTH - 1:0] Dest_out
);
    reg Busy[`RSALU_ENTRY_NUM - 1: 0];
    // the operation
    reg [5:0] Op[`RSALU_ENTRY_NUM - 1: 0];
    // the value of the source operands
    reg [31:0] Vj[`RSALU_ENTRY_NUM - 1: 0];
    reg [31:0] Vk[`RSALU_ENTRY_NUM - 1: 0];
    // the reorder buffer index that produce the value 
    reg [`ROB_ENTRY_WIDTH - 1:0] Qj[`RSALU_ENTRY_NUM - 1: 0];
    reg [`ROB_ENTRY_WIDTH - 1:0] Qk[`RSALU_ENTRY_NUM - 1: 0];
    reg [`ROB_ENTRY_WIDTH - 1:0] Dest[`RSALU_ENTRY_NUM - 1: 0];
    // memory address
    reg [31:0] A[`RSALU_ENTRY_NUM - 1: 0]; 

    integer i;

    reg AllocRS_index[`RSALU_ENTRY_WIDTH - 1:0];
    reg ExeRS_index[`RSALU_ENTRY_WIDTH - 1:0];

    // check free RS entry
    always @(*) begin
        AllocRS_index = {`RSALU_ENTRY_WIDTH{0}};
        for(i = 1; i < `RSALU_ENTRY_NUM; i = i + 1) begin
            if(Valid[i] == 1'd0) 
                AllocRS_index = i; 
        end
    end

    // check ready RS entry
    always @(*) begin
        ExeRS_index = 0;
        for(i = 1; i < `RSALU_ENTRY_NUM; i = i + 1) begin
            if(Valid[i] == 1'd1 && Qj[i] == 0 && Qk[i] == 0) 
                ExeRS_index = i; 
        end
    end


    always @(posedge clk) begin
        if(rst) begin
            for(i = 1; i < `RSALU_ENTRY_NUM; i = i + 1) begin
                Busy[i] <= 1'd0;
                Op[i]   <= 6'd0;
                Dest[i] <= {`ROB_ENTRY_WIDTH{0}};
            end
        end
        else begin
            
            if(CDB_ALU_ROB_index != 0) begin
                for(i = 1; i < `RSALU_ENTRY_NUM; i = i + 1) begin
                    if(CDB_ALU_ROB_index == Qj[i]) begin
                        Vj[i] <= CDB_ALU_data;
                        Qj[i] <= {`ROB_ENTRY_WIDTH{0}};
                    end
                    if(CDB_ALU_ROB_index == Qk[i]) begin
                        Vk[i] <= CDB_ALU_data;
                        Qk[i] <= {`ROB_ENTRY_WIDTH{0}};
                    end
                end
            end


            if(ExeRS_index != 0) begin
                Op_out <= Op[ExeRS_index];
                Vj_out <= Vj[ExeRS_index];
                Vk_out <= Vk[ExeRS_index];
                Dest_out <= Dest[ExeRS_index];
                
                Busy[ExeRS_index] <= 1'd0;
            end

            if(issue_we) begin
                Op[AllocRS_index] <= Op_in;
                Vj[AllocRS_index] <= Vj_in;
                Vk[AllocRS_index] <= Vk_in;
                Qj[AllocRS_index] <= Qj_in;
                Qk[AllocRS_index] <= Qk_in;
                Dest[AllocRS_index] <= Dest_in;
                Busy[AllocRS_index] <= 1'd1;

            end
        end
    end

endmodule