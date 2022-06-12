`timescale 1ns / 1ps

module IF_ID(
    input clk,
    input rst,
    input EN,
    input flush,
    input stall,

    input [31:0]        PC_IF,
    input [31:0]        inst_IF,
    
    output reg [31:0]   PC_ID,
    output reg [31:0]   inst_ID
);

    always @(posedge clk) begin
        if(rst) begin
            PC_ID   <= 0;
            inst_ID <= 0;
        end
        else if(EN) begin
            if(stall) begin
                PC_ID   <= PC_ID;
                inst_ID <= inst_ID;
            end
            else if(flush) begin
                PC_ID   <= PC_ID;
                inst_ID <= 32'h00002003; // nop lw zero, 0(zero)
            end
            else begin
                PC_ID   <= PC_IF;
                inst_ID <= inst_IF;
            end
        end
        else begin
            PC_ID   <= PC_ID;
            inst_ID <= inst_ID;
        end
    end
    
    
endmodule