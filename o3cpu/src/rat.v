`timescale 1ns / 1ps
`include "defines.vh"

module RAT (
    input clk,
    input rst,
    input rollback,
    // read operands
    input  [4:0]                    raddr1,
    output reg                         valid1,          // is value 1 ready in regfile
    output reg [31:0]                   rdata1,   // if valid, the data
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index1_out, // if not valid, the pointer to rob
    
    input  [4:0]                    raddr2,
    output reg                         valid2,
    output reg [31:0]                   rdata2,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index2_out,
    
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
                Valid[i]   <= 1'd1;
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

    always @(*) begin
        if(ROB_we && waddr != 0 && raddr1 == ROB_addr_commit) begin
            valid1 = 1;
            rdata1 = ROB_data_commit;
            ROB_index1_out = 0;
        end
        else begin
            valid1         = Valid[raddr1];
            rdata1         = Value[raddr1];
            ROB_index1_out = ROBAddr[raddr1];
        end

        if(ROB_we && waddr != 0 && raddr2 == ROB_addr_commit) begin
            valid2 = 1;
            rdata2 = ROB_data_commit;
            ROB_index2_out = 0;
        end
        else begin
            valid2         = Valid[raddr2];
            rdata2         = Value[raddr2];
            ROB_index2_out = ROBAddr[raddr2];
        end
    end

endmodule