`timescale 1ns / 1ps
`include "defines.vh"

module RAT (
    input clk,
    input rst,
    input rollback,
    // read operands
    input  [4:0]                    raddr1,
    output                          valid1,          // is value 1 ready in regfile
    output [31:0]                   rdata1,   // if valid, the data
    output [`ROB_ENTRY_WIDTH - 1:0] ROB_index1_out, // if not valid, the pointer to rob
    
    input  [4:0]                    raddr2,
    output                          valid2,
    output [31:0]                   rdata2,
    output [`ROB_ENTRY_WIDTH - 1:0] ROB_index2_out,
    
    // set dst reg
    input                           dec_we, // set rob entry
    input  [4:0]                    waddr,
    input  [`ROB_ENTRY_WIDTH - 1:0] ROB_index_in,

    // ROB commits to regfile
    input                           ROB_we,
    input  [ 4:0]                   ROB_addr_commit,
    input  [31:0]                   ROB_data_commit,
    input  [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit    // to see if it's the latest
);
    // if the reg value is valid
    reg                             Valid[31:0];
    // reg value
    reg [31:0]                      Value[31:0];
    // if not valid, pointer to rob
    reg [`ROB_ENTRY_WIDTH - 1:0]    ROBAddr[31:0];
    
    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                Valid[i]   <= 1'd0;
                Value[i]   <= 32'd0;
                ROBAddr[i] <= {`ROB_ENTRY_WIDTH{0}};
            end
        end
        else if(rollback) begin
            for(i = 0; i < 32; i = i + 1) begin
                Valid[i]   <= 1'd1;
                ROBAddr[i] <= {`ROB_ENTRY_WIDTH{0}};
            end
        end
        else begin
            if(ROB_we && waddr != 5'd0) begin
                Value[ROB_addr_commit]       <= ROB_data_commit;
                if(ROB_index_commit == ROBAddr[ROB_addr_commit]) begin
                    Valid[ROB_addr_commit]   <= 1'd1;
                    ROBAddr[ROB_addr_commit] <= {`ROB_ENTRY_WIDTH{0}};
                end
            end
            
            if(dec_we && waddr != 5'd0) begin
                Valid[waddr]   <= 1'd0;
                ROBAddr[waddr] <= ROB_index_in;
            end
        end
    end

    // read operand 1
    assign valid1         = Valid[raddr1];
    assign rdata1         = Value[raddr1];
    assign ROB_index1_out = ROBAddr[raddr1];
    
    // read operand 2
    assign valid2         = Valid[raddr2];
    assign rdata2         = Value[raddr2];
    assign ROB_index2_out = ROBAddr[raddr2];

endmodule