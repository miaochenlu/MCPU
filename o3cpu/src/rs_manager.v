`timescale 1ns / 1ps
`include "defines.vh"
module RSManager (
    input FUType,
    output RSALU_we,
    output RSBRA_we,
    output RSLSQ_we
);

    assign RSALU_we = (FUType == FU_ALU) ? 1'd1 : 1'd0;
    assign RSBRA_we = (FUType == FU_BRA) ? 1'd1 : 1'd0;
    assign RSLSQ_we = (FUType == FU_LSQ) ? 1'd1 : 1'd0;
endmodule