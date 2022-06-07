`timescale 1ns / 1ps

module ReorderBuffer #(
    parameter integer ROB_ROB_ENTRY_NUM = 256,
    parameter integer ROB_ENTRY_WIDTH = 8
)
(
    input clk,
    input rst,
    
    // decode read
    input read_en1,
    input [ROB_ENTRY_WIDTH - 1:0] ROB_raddr1,
    output reg [31:0] ROB_rdata1,
    output reg ready1,

    input read_en2,
    input [ROB_ENTRY_WIDTH - 1:0] ROB_raddr2,
    output reg [31:0] ROB_rdata2,
    output reg ready2,
    
    // decode write
    input write_en,
    input [4:0] waddr,
    input [31:0] wpc,
    input [31:0] winst,
    output queue_full,
    output reg [ROB_ENTRY_NUM - 1:0] ROB_waddr,
);
    reg Valid[ROB_ENTRY_NUM - 1:0];
    reg [31:0] Inst[ROB_ENTRY_NUM - 1:0];
    reg [31:0] PC_Inst[ROB_ENTRY_NUM - 1:0];
    reg Ready[ROB_ENTRY_NUM - 1:0];
    reg [ 4:0] DestRegID[ROB_ENTRY_NUM - 1:0];
    reg [31:0] DestRegVal[ROB_ENTRY_NUM - 1:0];

    reg [ROB_ENTRY_WIDTH - 1:0] head, tail;  // pointer to the head and tail of the fifo queue
    reg [ROB_ENTRY_WIDTH - 1:0] counter;     // count the number of elements in the ROB, to see if it's empty or full

    wire queue_full;
    assign queue_full = (counter >= ROB_ROB_ENTRY_NUM);

    integer i;
    initial begin
        for(i = 0; i < ROB_ENTRY_NUM; i = i + 1) begin
            Valid[i]      = 0;
            Inst[i]       = 0;
            PC_Inst[i]    = 0;
            Ready[i]      = 0;
            DestRegID[i]  = 0;
            DestRegVal[i] = 0;
        end
        head = 0;
        tail = 0;
        counter = 0;
    end

    // decode read
    always @(*) begin
        ready1 = 0;
        ready2 = 0;

        if(read_en1 && Valid[ROB_raddr1]) begin
            ready1 = Ready[ROB_raddr1];
            ROB_rdata1 = DestRegID[ROB_raddr1];
        end

        if(read_en2 && Valid[ROB_raddr2]) begin
            ready2 = Ready[ROB_raddr2];
            ROB_rdata2 = DestRegID[ROB_raddr2];
        end
    end

    // decode write
    always @(posedge clk) begin
        if(write_en && ~queue_full) begin
            ROB_waddr        <= tail;
            Valid[tail]      <= 1'd1;
            Inst[tail]       <= winst;
            PC_Inst[tail]    <= wpc;
            Ready[tail]      <= 1'd0;
            DestRegID[tail]  <= waddr;
            DestRegVal[tail] <= 32'd0;

            tail <= tail + 1;
            counter <= counter + 1;
        end
    end

endmodule
