`timescale 1ns / 1ps
`include "defines.vh"

module RSBRA (
    input  clk,
    input  rst,
    input  rollback,
    output full,

    // issue in
    input                               issue_we,
    input [`BRA_OP_WIDTH - 1:0]         Op_in,
    input [31:0]                        Vj_in,
    input [31:0]                        Vk_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Qj_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Qk_in,
    input [31:0]                        PC_in,
    input [31:0]                        Offset_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Dest_in,

    // CDB write result
    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_ALU_ROB_index,
    input [31:0]                        CDB_ALU_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_LSQ_ROB_index,
    input [31:0]                        CDB_LSQ_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_BRA_ROB_index,
    input [31:0]                        CDB_BRA_data,

    // from func unit: is it busy
    input                               func_busy,
    // to func unit
    output reg [`BRA_OP_WIDTH - 1:0]    Op_out,
    output reg [31:0]                   Vj_out,
    output reg [31:0]                   Vk_out,
    output reg [31:0]                   PC_out,
    output reg [31:0]                   Offset_out,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out
);


    reg                                 Busy[`RSBRA_ENTRY_NUM:0];
    // the operation
    reg [`BRA_OP_WIDTH - 1:0]           Op[`RSBRA_ENTRY_NUM:0];
    // the value of the source operands
    reg [31:0]                          Vj[`RSBRA_ENTRY_NUM:0];
    reg [31:0]                          Vk[`RSBRA_ENTRY_NUM:0];

    reg [`ROB_ENTRY_WIDTH - 1:0]        Qj[`RSBRA_ENTRY_NUM:0];
    reg [`ROB_ENTRY_WIDTH - 1:0]        Qk[`RSBRA_ENTRY_NUM:0];
    reg [31:0]                          PC[`RSBRA_ENTRY_NUM:0];
    reg [31:0]                          Offset[`RSBRA_ENTRY_NUM:0];
    reg [`ROB_ENTRY_WIDTH - 1:0]        Dest[`RSBRA_ENTRY_NUM:0];

    integer i;

    reg [`RSALU_ENTRY_WIDTH - 1:0]      AllocRS_index;
    reg [`RSALU_ENTRY_WIDTH - 1:0]      ExeRS_index;

    // check free RS entry
    always @(*) begin
        AllocRS_index = 0;
        for(i = 1; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
            if(Busy[i] == 1'd0) 
                AllocRS_index = i; 
        end
    end
    
    assign full = (AllocRS_index == 0);

    // check ready RS entry
    always @(*) begin
        ExeRS_index = 0;
        for(i = 1; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
            if(Busy[i] == 1'd1 && Qj[i] == 0 && Qk[i] == 0) 
                ExeRS_index = i; 
        end
    end


    always @(posedge clk) begin
        Op_out     <= 0;
        Vj_out     <= 0;
        Vk_out     <= 0;
        PC_out     <= 0;
        Offset_out <= 0;
        Dest_out   <= 0;
        
        if(rst || rollback) begin
            for(i = 0; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
                Busy[i]     <= 0;
                Op[i]       <= 0;
                Vj[i]       <= 0;
                Vk[i]       <= 0;
                Qj[i]       <= 0;
                Qk[i]       <= 0;
                PC[i]       <= 0;
                Offset[i]   <= 0;
                Dest[i]     <= 0;
            end
        end
        else begin
  
            if(CDB_ALU_ROB_index != 0) begin
                for(i = 1; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
                    if(CDB_ALU_ROB_index == Qj[i]) begin
                        Vj[i] <= CDB_ALU_data;
                        Qj[i] <= 0;
                    end
                    if(CDB_ALU_ROB_index == Qk[i]) begin
                        Vk[i] <= CDB_ALU_data;
                        Qk[i] <= 0;
                    end
                end
            end
            
            if(CDB_LSQ_ROB_index != 0) begin
                for(i = 1; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
                    if(CDB_LSQ_ROB_index == Qj[i]) begin
                        Vj[i] <= CDB_LSQ_data;
                        Qj[i] <= 0;
                    end
                    if(CDB_LSQ_ROB_index == Qk[i]) begin
                        Vk[i] <= CDB_LSQ_data;
                        Qk[i] <= 0;
                    end
                end
            end

            if(CDB_BRA_ROB_index != 0) begin
                for(i = 1; i <= `RSBRA_ENTRY_NUM; i = i + 1) begin
                    if(CDB_BRA_ROB_index == Qj[i]) begin
                        Vj[i] <= CDB_BRA_data;
                        Qj[i] <= 0;
                    end
                    if(CDB_BRA_ROB_index == Qk[i]) begin
                        Vk[i] <= CDB_BRA_data;
                        Qk[i] <= 0;
                    end
                end
            end

            if(ExeRS_index != 0 && ~func_busy) begin
                Op_out              <= Op[ExeRS_index];
                Vj_out              <= Vj[ExeRS_index];
                Vk_out              <= Vk[ExeRS_index];
                PC_out              <= PC[ExeRS_index];
                Offset_out          <= Offset[ExeRS_index];
                Dest_out            <= Dest[ExeRS_index];
                
                Busy[ExeRS_index]   <= 1'd0;
            end

            if(issue_we && ~full && Op_in != 0) begin
                Op[AllocRS_index]       <= Op_in;
                Vj[AllocRS_index]       <= Vj_in;
                Vk[AllocRS_index]       <= Vk_in;
                Qj[AllocRS_index]       <= Qj_in;
                Qk[AllocRS_index]       <= Qk_in;
                PC[AllocRS_index]       <= PC_in;
                Offset[AllocRS_index]   <= Offset_in;
                Dest[AllocRS_index]     <= Dest_in;
                Busy[AllocRS_index]     <= 1'd1;

                if(CDB_ALU_ROB_index == Qj_in && CDB_ALU_ROB_index != 0) begin
                    Vj[AllocRS_index] <= CDB_ALU_data;
                    Qj[AllocRS_index] <= 0;
                end
                else if(CDB_LSQ_ROB_index == Qj_in && CDB_LSQ_ROB_index != 0) begin
                    Vj[AllocRS_index] <= CDB_LSQ_data;
                    Qj[AllocRS_index] <= 0;
                end
                else if(CDB_BRA_ROB_index == Qj_in && CDB_BRA_ROB_index != 0) begin
                    Vj[AllocRS_index] <= CDB_BRA_data;
                    Qj[AllocRS_index] <= 0;
                end
                else begin
                    Vj[AllocRS_index] <= Vj_in;
                    Qj[AllocRS_index] <= Qj_in;
                end

                if(CDB_ALU_ROB_index == Qk_in && CDB_ALU_ROB_index != 0) begin
                    Vk[AllocRS_index] <= CDB_ALU_data;
                    Qk[AllocRS_index] <= 0;
                end
                else if(CDB_LSQ_ROB_index == Qk_in && CDB_LSQ_ROB_index != 0) begin
                    Vk[AllocRS_index] <= CDB_LSQ_data;
                    Qk[AllocRS_index] <= 0;
                end
                else if(CDB_BRA_ROB_index == Qk_in && CDB_BRA_ROB_index != 0) begin
                    Vk[AllocRS_index] <= CDB_BRA_data;
                    Qk[AllocRS_index] <= 0;
                end
                else begin
                    Vk[AllocRS_index] <= Vk_in;
                    Qk[AllocRS_index] <= Qk_in;
                end
            end
        end
    end

endmodule