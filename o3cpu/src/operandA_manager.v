`timescale 1ns / 1ps
`include "defines.vh"

module OperandAManager(
    input SrcASel,
    // choose pc
    input [31:0] PC,
    // choose reg
    input RAT_valid,
    input [31:0] RAT_value,
    input ROB_ready,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_index_in,
    input [31:0] ROB_value,

    output reg [31:0] OpAValue,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_out

);

    always @(*) begin
        if(SrcASel == 1'd0) begin
            OpAValue = PC;
            ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
        end
        else begin
            if(RAT_valid) begin
                OpAValue = RAT_value;
                ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
            end
            else if(ROB_ready) begin
                OpAValue = ROB_value;
                ROB_index_out = {`ROB_ENTRY_WIDTH{0}};
            end
            else begin
                OpAValue = 32'd0;
                ROB_index_out = ROB_index_in;
            end
        end
    end

endmodule