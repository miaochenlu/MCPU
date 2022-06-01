`timescale 1ns / 1ps
`include "defines.vh"
module mem_hier_tb();
    reg clk, rst;
    reg read_req, write_req;
    reg [31:0] addr;
    reg [1:0] wr_ctrl;
    reg [2:0] rd_ctrl;
    reg [31:0] wr_data;
    wire rd_data_valid;
    wire wr_ready;
    wire [31:0] rd_data;
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        read_req = 0; write_req = 0;
        #2 rst = 0;
    end
    
    integer i = 0;
    initial begin
        #2;
        @(posedge clk) read_req = 0; write_req = 1; addr = {23'b0, 5'b0, 4'b1}; wr_ctrl = `SW; rd_ctrl = 0; wr_data = 32'b1;
        @(posedge clk)
        while(~wr_ready) begin
            read_req = 0; write_req = 0; #1;
        end
        #2;
        @(posedge clk) read_req = 0; write_req = 1; addr = {23'b0, 5'b0, 4'b1}; wr_ctrl = `SW; rd_ctrl = 0; wr_data = 32'b1;
        @(posedge clk)
        while(~wr_ready) begin
            read_req = 0; write_req = 0; #1;
        end
        
        @(posedge clk) read_req = 1; write_req = 0; addr = {23'b0, 5'b0, 4'b1}; wr_ctrl = 0; rd_ctrl = `LW;
        @(posedge clk)
        while(~rd_data_valid) begin
            read_req = 0; write_req = 0; #1;
        end
        
        @(posedge clk) read_req = 0; write_req = 1; addr = {23'b1, 5'b0, 4'b1}; wr_ctrl = `SW; rd_ctrl = 0; wr_data = 32'b1;
        @(posedge clk)
        while(~wr_ready) begin
            read_req = 0; write_req = 0; #1;
        end
        
        @(posedge clk) read_req = 1; write_req = 0; addr = {23'b1, 5'b0, 4'b1}; wr_ctrl = 0; rd_ctrl = `LW;
        @(posedge clk)
        while(~rd_data_valid) begin
            read_req = 0; write_req = 0; #1;
        end
        
        @(posedge clk) read_req = 0; write_req = 1; addr = {23'b10, 5'b0, 4'b1}; wr_ctrl = `SW; rd_ctrl = 0; wr_data = 32'b1;
        @(posedge clk)
        while(~wr_ready) begin
            read_req = 0; write_req = 0; #1;
        end
        
        @(posedge clk) read_req = 1; write_req = 0; addr = {23'b10, 5'b0, 4'b1}; wr_ctrl = 0; rd_ctrl = `LW;
        @(posedge clk)
        while(~rd_data_valid) begin
            read_req = 0; write_req = 0; #1;
        end
        
        
    end
    
    MemHier test_MemHier (
        .clk(clk),
        .rst(rst),
        .read_req(read_req),
        .write_req(write_req),
        .addr(addr),
        .wr_ctrl(wr_ctrl),
        .rd_ctrl(rd_ctrl),
        .wr_data(wr_data),
        .rd_data_valid(rd_data_valid),
        .wr_ready(wr_ready),
        .rd_data(rd_data)
    );
    
endmodule
