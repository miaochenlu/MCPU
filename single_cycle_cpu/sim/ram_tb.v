`timescale 1ns / 1ps

module ram_tb();
    reg clk;
    reg [31:0] rd_addr;
    reg [2:0] MemRdCtrl;
    reg [1:0] MemWrCtrl;
    wire [31:0] rd_data;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    integer i = 0;
    initial begin
        MemRdCtrl = 1;
        MemWrCtrl = 0;
        for(i = 0; i < 1024; i = i + 1) begin
            #1 rd_addr = i;
        end
    end
    
    RAM test_RAM(.clk(clk), .wr_en(wr_en), .rd_ctrl(MemRdCtrl), .wr_ctrl(MemWrCtrl), .wr_addr(wr_addr), .wr_data(wr_data), .rd_addr(rd_addr), .rd_data(rd_data));
endmodule
