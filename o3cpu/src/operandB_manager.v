`timescale 1ns / 1ps
`include "defines.vh"

module OperandBManager(
    input [ 1:0]                        OpBSel,
    // choose pc
    input [31:0]                        imm,
    // choose reg
    input                               RAT_valid,
    input [31:0]                        RAT_value,
    input                               ROB_ready,
    input [`ROB_ENTRY_WIDTH - 1:0]      ROB_index_in,
    input [31:0]                        ROB_value,

    // CDB write result
    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_ALU_ROB_index,
    input [31:0]                        CDB_ALU_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_LSQ_ROB_index,
    input [31:0]                        CDB_LSQ_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_BRA_ROB_index,
    input [31:0]                        CDB_BRA_data,

    output reg [31:0]                   OpBValue,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_out
);

    always @(*) begin
        if(OpBSel == 2'd0) begin
            OpBValue      = 0;
            ROB_index_out = 0;
        end
        else if(OpBSel == 2'd1) begin
            OpBValue      = imm;
            ROB_index_out = 0;
        end
        else begin
            if(RAT_valid) begin
                OpBValue      = RAT_value;
                ROB_index_out = 0;
            end
            else if(ROB_ready) begin
                OpBValue      = ROB_value;
                ROB_index_out = 0;
            end
            else begin
                if(RAT_valid) begin
                    OpBValue      = RAT_value;
                    ROB_index_out = 0;
                end
                else if(ROB_ready) begin
                    OpBValue      = ROB_value;
                    ROB_index_out = 0;
                end
                else begin
                    if(CDB_ALU_ROB_index != 0 && CDB_ALU_ROB_index == ROB_index_in) begin
                        OpBValue = CDB_ALU_data;
                        ROB_index_out = 0;
                    end
                    else if(CDB_LSQ_ROB_index != 0 && CDB_LSQ_ROB_index == ROB_index_in) begin
                        OpBValue = CDB_LSQ_data;
                        ROB_index_out = 0;
                    end
                    else if(CDB_BRA_ROB_index !=0 && CDB_BRA_ROB_index == ROB_index_in) begin
                        OpBValue = CDB_BRA_data;
                        ROB_index_out = 0;
                    end
                    else begin
                        OpBValue      = 32'd0;
                        ROB_index_out = ROB_index_in;
                    end
                end
            end
        end
    end

endmodule