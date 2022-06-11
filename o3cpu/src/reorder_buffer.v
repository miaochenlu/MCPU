`timescale 1ns / 1ps

// https://github.com/XOR-op/TransistorU

module ReorderBuffer (
    input clk,
    input rst,
    output full,
    output empty,
    // decode read
    input read_en1,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_rindex1,
    output reg [31:0] ROB_rdata1,
    output ready1,

    input read_en2,
    input [`ROB_ENTRY_WIDTH - 1:0] ROB_rindex2,
    output reg [31:0] ROB_rdata2,
    output reg ready2,
    
    // decode write
    input write_en,
    input [4:0] waddr,
    input [31:0] pc_in,
    input [31:0] inst_in,
    output [`ROB_ENTRY_NUM:0] ROB_windex,

    // commit to registers
    output reg ROB_we,
    output reg [ 4:0] addr_commit,
    output reg [31:0] data_commit,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit,

    // CDB result
    input [`ROB_ENTRY_WIDTH - 1:0] CDB_ALU_ROB_index,
    input [31:0] CDB_ALU_data
);
    reg        Valid[`ROB_ENTRY_NUM:0];
    reg        Ready[`ROB_ENTRY_NUM:0];
    reg [31:0] Inst[`ROB_ENTRY_NUM:0];
    reg [31:0] PC_Inst[`ROB_ENTRY_NUM:0];
    reg [ 4:0] DestRegID[`ROB_ENTRY_NUM:0];
    reg [31:0] DestAddr[`ROB_ENTRY_NUM:0]; // for store inst
    reg [31:0] DestRegVal[`ROB_ENTRY_NUM:0];

    // the fifo queue index starts with 1
    reg [`ROB_ENTRY_WIDTH - 1:0] head, tail;  // pointer to the head and tail of the fifo queue
    reg [`ROB_ENTRY_WIDTH - 1:0] counter;     // count the number of elements in the ROB, to see if it's empty or full

    assign empty = (counter == 0);
    assign full  = (counter >= ROB_`ROB_ENTRY_NUM);
    assign ROB_windex = tail;
    
    integer i;
    initial begin
        for(i = 0; i <= `ROB_ENTRY_NUM; i = i + 1) begin
            Valid[i]      = 0;
            Inst[i]       = 0;
            PC_Inst[i]    = 0;
            Ready[i]      = 0;
            DestRegID[i]  = 0;
            DestRegVal[i] = 0;
        end
        head = 1;
        tail = 1;
        counter = 0;

        ROB_we     <= 1'd0;
    end

    /*****************************decode read****************************/
    assign ready1     = (read_en1 && Valid[`ROB_ENTRY_NUM]) ? Ready[`ROB_ENTRY_NUM] : 1'd0;
    assign ready2     = (read_en2 && Valid[ROB_rindex2]) ? Ready[ROB_rindex2] : 1'd0;
    assign ROB_rdata1 = (read_en1 && Valid[`ROB_ENTRY_NUM]) ? DestRegVal[`ROB_ENTRY_NUM] : 32'd0;
    assign ROB_rdata2 = (read_en2 && Valid[ROB_rindex2]) ? DestRegVal[ROB_rindex2] : 32'd0;

    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i <= `ROB_ENTRY_NUM; i = i + 1) begin
                Valid[i]      <= 0;
                Inst[i]       <= 0;
                PC_Inst[i]    <= 0;
                Ready[i]      <= 0;
                DestRegID[i]  <= 0;
                DestRegVal[i] <= 0;
            end
            head <= 1;
            tail <= 1;
            counter <= 0;

            // output set to 0
            ROB_we     <= 1'd0;

        end
    /*****************************decode write****************************/
        if(write_en && ~full) begin
            Valid[tail]      <= 1'd1;
            Inst[tail]       <= inst_in;
            PC_Inst[tail]    <= pc_in;
            Ready[tail]      <= 1'd0;
            DestRegID[tail]  <= waddr;
            DestRegVal[tail] <= 32'd0;

            tail <= (tail == `ROB_ENTRY_NUM) ? 1 : tail + 1;
            counter <= counter + 1;
        end
    /*****************************CDB write****************************/

        if(CDB_ALU_ROB_index != 0) begin
            DestRegID[CDB_ALU_ROB_index] <= CDB_ALU_data;
            Ready[CDB_ALU_ROB_index]     <= 1'd1;
        end

    /*****************************commit****************************/
        if(~empty && (Ready[head])) begin
            ROB_we      <= 1'd1;
            addr_commit <= DestRegID[head];
            data_commit <= DestRegVal[head];
            ROB_index_commit <= head;

            head        <= (head == `ROB_ENTRY_NUM) ? 1 : head + 1;
            counter     <= counter - 1;
            Valid[head] <= 1'd0;
            Ready[head] <= 1'd0;
        end
        else begin
            ROB_we <= 1'd0;
        end
    end

endmodule
