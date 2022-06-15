`timescale 1ns / 1ps

module RegFile(
    input clk,
    input rst,
    input we, // write enable
    input  [ 4:0] raddr1,
    output [31:0] rdata1,
    input  [ 4:0] raddr2,
    output [31:0] rdata2,
    input  [ 4:0] waddr,
    input  [31:0] wdata
);

    reg [31:0] reg_array[31:0];
    
    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                reg_array[i] <= 32'd0;
            end
        end
        else begin
            if(we && waddr != 0) 
                reg_array[waddr] <= wdata;
        end
    end

    assign rdata1 = (raddr1 == 5'd0) ? 32'd0 : reg_array[raddr1];
    assign rdata2 = (raddr2 == 5'd0) ? 32'd0 : reg_array[raddr2];

endmodule
