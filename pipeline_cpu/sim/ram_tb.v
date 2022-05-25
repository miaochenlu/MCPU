`timescale 1ns / 1ps

module ram_tb();
    reg clk;
    reg wr_en;
    reg [31:0] rd_addr;
    reg [31:0] wr_addr;
    reg [31:0] wr_data;
    reg [2:0] MemRdCtrl;
    reg [1:0] MemWrCtrl;
    wire [31:0] rd_data;
    
    
    integer i = 0;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
        
    initial begin
        #2;
        @(posedge clk)
        wr_en = 1;
        MemRdCtrl = 0;
        MemWrCtrl = 2'b11;
        wr_addr = 32'd28;
        wr_data = 32'hff000f0f;
        #2 wr_en = 0; 
    end
    
    RAM test_RAM(.clk(clk), .wr_en(wr_en), .rd_ctrl(MemRdCtrl), .wr_ctrl(MemWrCtrl), .wr_addr(wr_addr), .wr_data(wr_data), .rd_addr(rd_addr), .rd_data(rd_data));
endmodule
