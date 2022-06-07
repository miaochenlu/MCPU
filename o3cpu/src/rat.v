`timescale 1ns / 1ps

module RAT #(
    parameter integer ROB_ENTRY_NUM = 256,
    parameter integer ROB_ENTRY_WIDTH = 8
)
(
    input clk,
    input rst,
    
    // read operands
    input  [4:0] raddr1,
    output reg valid1,  // is value 1 ready in regfile
    output reg [31:0] rdata1,
    output reg [ROB_ENTRY_WIDTH - 1:0] ROB_index1_out,
    
    input  [4:0] raddr2,
    output reg valid2,  // is value 2 ready in regfile
    output reg [31:0] rdata2,
    output reg [ROB_ENTRY_WIDTH - 1:0] ROB_index2_out,
    
    // set dst reg
    input  dec_we, // set rob entry
    input  [ 4:0] waddr;
    input  [ROB_ENTRY_WIDTH - 1:0] ROB_index_in;

    // ROB updates regfile
    input  ROB_we,
    input  [ 4:0] ROB_waddr,
    input  [31:0] ROB_wdata,
);
    // if the reg value is valid
    reg Valid[31:0];
    // reg value
    reg [31:0] Value[31:0];
    // if not valid, pointer to rob
    reg [ROB_ENTRY_WIDTH - 1:0] ROBAddr[31:0];
    
    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                Valid[i]   <= 1'd0;
                Value[i]   <= 32'd0;
                ROBAddr[i] <= {ROB_ENTRY_WIDTH{0}};
            end
        end
        else begin
            if(ROB_we && waddr != 5'd0) begin
                Value[ROB_waddr]   <= ROB_wdata;
                Valid[ROB_waddr]   <= 1'd1;
                ROBAddr[ROB_waddr] <= {ROB_ENTRY_WIDTH{0}};
            end
            
            if(dec_we && waddr != 5'd0) begin
                Valid[waddr]   <= 1'd0;
                ROBAddr[waddr] <= ROB_index_in;
            end
        end
    end

    always @(*) begin
        valid1 = Valid[raddr1];
        rdata1 = Value[raddr1];
        ROB_index1_out = ROBAddr[raddr1];

        valid2 = Valid[raddr2];
        rdata2 = Value[raddr2];
        ROB_index2_out = ROBAddr[raddr2];
    end

endmodule