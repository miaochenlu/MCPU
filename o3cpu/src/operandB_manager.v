`timescale 1ns / 1ps
`include "defines.vh"

module OperandBManager(
    input SrcBSel,
    // choose pc
    input [31:0] imm,
    // choose reg
    input RAT_valid,
    input [31:0] RAT_value,
    input ROB_ready,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_index_in,
    input [31:0] ROB_value,

    output reg [31:0] OpBValue,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_out

);

    always @(*) begin
        if(SrcBSel == 1'd0) begin
            OpBValue = imm;
            ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
        end
        else begin
            if(RAT_valid) begin
                OpBValue = RAT_value;
                ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
            end
            else if(ROB_ready) begin
                OpBValue = ROB_value;
                ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
            end
            else begin
                OpBValue = 32'd0;
                ROB_index_out = ROB_index_in;
            end
        end
    end

endmodule