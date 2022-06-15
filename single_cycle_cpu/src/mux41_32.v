`timescale 1ns / 1ps

module Mux41_32 (
    input  [31:0] in0,
    input  [31:0] in1,
    input  [31:0] in2,
    input  [31:0] in3,
    input  [ 1:0] sel,
    output [31:0] out
);

    assign out = ({32{sel == 2'd0}} & in0)
               | ({32{sel == 2'd1}} & in1)
               | ({32{sel == 2'd2}} & in2)
               | ({32{sel == 2'd3}} & in3);

endmodule
