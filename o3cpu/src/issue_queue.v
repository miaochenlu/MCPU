// `timescale 1ns / 1ps

// module IssueQueue # (
//     parameter integer QUEUE_ENTRY_NUM = 16
//     parameter integer QUEUE_ENTRY_WIDTH = 4;
// )
// (
//     input clk,
//     input rst,

//     input push,
//     input [31:0] pc_in,
//     input [31:0] inst_in,
    
//     input pop,
//     output [31:0] pc_out,
//     output [31:0] inst_out,

//     output full,
//     output empty,

    
// );
//     // a bit indicating whether the current entry contains a valid instruction
//     reg Valid[QUEUE_ENTRY_NUM - 1:0];
//     // PC of the current instruction, required for exception handling
//     reg [31:0] InstPC[QUEUE_ENTRY_NUM - 1:0];
//     // the 32-bit instruction itself
//     reg [31:0] Inst[QUEUE_ENTRY_NUM - 1:0];
//     // predicted address of the next instruction of a branch from BTB
//     reg [31:0] PredTrgt[QUEUE_ENTRY_NUM - 1:0];
//     // when the current branch instruction was predicted to be a taken branch
//     reg PredTkn[QUEUE_ENTRY_NUM - 1:0];
//     // a bit indicating if an exception was raised during the current instruction fetch
//     reg ExcepRsd[QUEUE_ENTRY_NUM - 1:0];
//     //  a 4-bit code associated to the exception
//     reg [3:0] ExcepCode[QUEUE_ENTRY_NUM - 1:0];


//     reg [QUEUE_ENTRY_NUM - 1:0] head;
//     reg [QUEUE_ENTRY_NUM - 1:0] tail;
//     reg [QUEUE_ENTRY_NUM - 1:0] counter;

//     assign empty = (counter == 0) ? 1'b1 : 1'b0;
//     assign full  = (counter == QUEUE_ENTRY_NUM) ? 1'b1 : 1'b0;


//     always @(posedge clk) begin
//         if(rst) begin
//             head <= 0;
//             tail <= 0;
//             counter <= 0;
//         end
//         else begin
//             if(push && full == 1'b0) begin
//                 Valid[tail] <= 1;
//                 InstPC[tail] <= pc_in;
//                 Inst[tail] <= inst_in;
//                 tail <= tail + 1;
//                 counter <= counter + 1;
//             end

//             if(pop && empty == 1'b0) begin
//                 Valid[head] <= 1;
//                 pc_out <= InstPC[head];
//                 inst_out <= Inst[head];
//                 head <= head + 1;
//                 counter <= counter - 1;
//             end
//         end
//     end

// endmodule