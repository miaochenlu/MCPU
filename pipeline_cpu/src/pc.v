`timescale 1ns / 1ps

module PC (
    input  clk,
    input  rst,
    input  CE,
    input  [31:0] pc_in,
    output [31:0] pc_out    
);
    reg [31:0] pc;
    always @(posedge clk) begin
        if(rst) pc <= 0;
        else if(CE) pc <= pc_in;
        else pc <= pc;
    end
    
    assign pc_out = pc;
endmodule
