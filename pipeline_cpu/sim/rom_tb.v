`timescale 1ns / 1ps

module rom_tb();
    reg [6:0] addr;
    wire [31:0] rd_data;
    
    integer i = 0;
    initial begin
        for(i = 0; i < 128; i = i + 1) begin
            #10 addr = i;
        end
    end
    
    ROM test_ROM(.addr(addr), .rd_data(rd_data));
endmodule
