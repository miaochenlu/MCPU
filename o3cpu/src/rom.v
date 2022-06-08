`timescale 1ns / 1ps

module ROM (
    input [6:0] addr,
    output [31:0] rd_data
);
    reg [31:0] mem[127:0];
    
    initial begin
        $readmemh("rom.hex", mem);
    end
    
    assign rd_data = mem[addr];
endmodule