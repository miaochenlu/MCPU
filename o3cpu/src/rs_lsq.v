`timescale 1ns / 1ps
`include "defines.vh"

module RSLSQ (
    input  clk,
    input  rst,
    input  rollback,
    output full,
    output empty,

    // issue in
    input                               issue_we,
    input [`LSQ_OP_WIDTH - 1:0]         Op_in,
    input [31:0]                        Vj_in,
    input [31:0]                        Vk_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Qj_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Qk_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Offset_in,
    input [`ROB_ENTRY_WIDTH - 1:0]      Dest_in,

    // CDB write result
    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_ALU_ROB_index,
    input [31:0]                        CDB_ALU_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_LSQ_ROB_index,
    input [31:0]                        CDB_LSQ_data,

    // to function unit
    output reg [`LSQ_OP_WIDTH - 1:0]    Op_out,
    output reg [31:0]                   Addr_out,
        // load from memory
    input                               mem_rd_ready,
    input [31:0]                        mem_rd_data,
        // write to memory
    input                               mem_wr_ready,
    output reg [31:0]                   mem_wr_data,

    // ROB commit
    input [`ROB_ENTRY_WIDTH - 1:0]      ROB_index_commit,
    // to ROB
    output reg [31:0]                   rd_data,
    output reg [`ROB_ENTRY_WIDTH - 1:0] Dest_out
);

    reg                          Busy[`RSLSQ_ENTRY_NUM: 0];
    reg                          Commit[`RSLSQ_ENTRY_NUM: 0];
    // the operation
    reg [`LSQ_OP_WIDTH - 1:0]    Op[`RSLSQ_ENTRY_NUM: 0];
    // the value of the source operands
    reg [31:0]                   Vj[`RSLSQ_ENTRY_NUM: 0];
    reg [31:0]                   Vk[`RSLSQ_ENTRY_NUM: 0]; // if store, store value
    // the reorder buffer index that produce the value 
    reg [`ROB_ENTRY_WIDTH - 1:0] Qj[`RSLSQ_ENTRY_NUM: 0];
    reg [`ROB_ENTRY_WIDTH - 1:0] Qk[`RSLSQ_ENTRY_NUM: 0];
    // memory address
    reg [31:0]                   Offset[`RSLSQ_ENTRY_NUM: 0];  // addr offset
    reg [31:0]                   Addr[`RSLSQ_ENTRY_NUM: 0]; 
    reg [`ROB_ENTRY_WIDTH - 1:0] Dest[`RSLSQ_ENTRY_NUM: 0];
    reg                          Status[`RSLSQ_ENTRY_NUM: 0]; 


    // the fifo queue index starts with 1
    reg [`RSLSQ_ENTRY_WIDTH - 1:0] head, tail;  // pointer to the head and tail of the fifo queue
    reg [`RSLSQ_ENTRY_WIDTH - 1:0] commit_pointer;
    reg [`RSLSQ_ENTRY_WIDTH - 1:0] counter;     // count the number of elements in the ROB, to see if it's empty or full
    reg counter_plus, counter_minus;
    
    assign empty = (counter == 0);
    assign full  = (counter >= `RSLSQ_ENTRY_NUM);
    assign RS_windex = tail;
    
    integer i;

    always @(posedge clk) begin
        // set default output
        Op_out      <= 0;
        Addr_out    <= 32'd0;
        mem_wr_data <= 32'd0;

        if(rst) begin
            for(i = 0; i <= `RSLSQ_ENTRY_NUM; i = i + 1) begin
                Busy[i]     <= 0;
                Commit[i]   <= 0;
                Op[i]       <= 0;
                Vj[i]       <= 0;
                Vk[i]       <= 0;
                Qj[i]       <= 0;
                Qk[i]       <= 0;
                Offset[i]   <= 0;
                Addr[i]     <= 0;
                Dest[i]     <= 0;
                Status[i]   <= 0;
            end
            head            <= 1'd1;
            tail            <= 1'd1;
            counter         <= 1'd0;
            commit_pointer  <= 0;
            counter_plus    <= 1'd0;
            counter_minus   <= 1'd0;
        end
        else if(rollback) begin
            if(commit_pointer == 0) begin
                head           <= 1'd1;
                tail           <= 1'd1;
                counter        <= 1'd0;
                commit_pointer <= 0;
            end
            else begin
                tail    <= (commit_pointer == `RSLSQ_ENTRY_NUM) ? 1 : commit_pointer + 1;
                counter <= (commit_pointer >= head) ? (commit_pointer - head + 1) : 
                                                      (commit_pointer + `RSLSQ_ENTRY_NUM - head + 1);
            end

            for(i = 0; i <= `RSLSQ_ENTRY_NUM; i = i + 1) begin
                if(~(Busy[i] && Commit[i])) begin
                    Busy[i]     <= 0;
                    Commit[i]   <= 0;
                    Op[i]       <= 0;
                    Vj[i]       <= 0;
                    Vk[i]       <= 0;
                    Qj[i]       <= 0;
                    Qk[i]       <= 0;
                    Offset[i]   <= 0;
                    Addr[i]     <= 0;
                    Dest[i]     <= 0;
                    Status[i]   <= 0;
                end
            end
            
        end
        else begin
            counter_plus  <= 0;
            counter_minus <= 0;
            
            if(CDB_ALU_ROB_index != 0) begin
                for(i = 1; i < `RSLSQ_ENTRY_NUM; i = i + 1) begin
                    if(CDB_ALU_ROB_index == Qj[i]) begin
                        Vj[i]   <= CDB_ALU_data;
                        Qj[i]   <= 0;
                        Addr[i] <= CDB_ALU_data + Offset[i];
                    end
                    if(CDB_ALU_ROB_index == Qk[i]) begin
                        Vk[i]   <= CDB_ALU_data;
                        Qk[i]   <= 0;
                    end
                end
            end

            if(CDB_LSQ_ROB_index != 0) begin
                for(i = 1; i <= `RSLSQ_ENTRY_NUM; i = i + 1) begin
                    if(CDB_LSQ_ROB_index == Qj[i]) begin
                        Vj[i]   <= CDB_LSQ_data;
                        Qj[i]   <= 0;
                        Addr[i] <= CDB_LSQ_data + Offset[i];
                    end
                    if(CDB_LSQ_ROB_index == Qk[i]) begin
                        Vk[i]   <= CDB_LSQ_data;
                        Qk[i]   <= 0;
                    end
                end
            end

            // ROB store commit
            if(ROB_index_commit != 0) begin
                for(i = 1; i <= `RSLSQ_ENTRY_NUM; i = i + 1) begin
                    if(ROB_index_commit != 0 && ROB_index_commit == Dest[i] && ~Commit[i]) begin
                        Commit[i]      <= 1'd1;
                        commit_pointer <= i;
                    end
                end
            end
                    

            /*****************allocate entry in lsq*********************/
            if(issue_we) begin
                Op[tail]     <= Op_in;
                Vj[tail]     <= Vj_in;
                Vk[tail]     <= Vk_in;
                Qj[tail]     <= Qj_in;
                Qk[tail]     <= Qk_in;
                Offset[tail] <= Offset_in;
                Dest[tail]   <= Dest_in;
                Commit[i]    <= 1'd0;
                Busy[tail]   <= 1'd1;
                Addr[tail]   <= (Qj_in == 0) ? (Vj_in + Offset_in) : 32'd0;
                Status[tail] <= 1'd0;

                tail         <= (tail == `RSLSQ_ENTRY_NUM) ? 1 : tail + 1;
                counter_plus <= 1'd1;
            end

            // if load inst is ready
            if((Busy[head] == 1'd1) && ((Op[head] & 4'b1000) == 4'd0) && (Qj[head] == {`ROB_ENTRY_WIDTH{0}})) begin
                /****************start to load*******************/
                if(Status[head] == 1'd0) begin
                    Op_out          <= Op[head];
                    Addr_out        <= Addr[head];
                    Status[head]    <= 1'd1; // start to execute
                end
                /****************load finish*******************/
                else if(Status[head] == 1'd1 && mem_rd_ready) begin
                    rd_data         <= mem_rd_data; 
                    Dest_out        <= Dest[head];
                    Busy[head]      <= 1'd0;
                    Op[head]        <= 1'd0;
                    Status[head]    <= 1'd0;

                    head            <= (head == `RSLSQ_ENTRY_NUM) ? 1 : head + 1;
                    counter_minus   <= 1'd1;
                end

            end

            // if store inst is ready to commit
            if(Busy[head] && (Op[head] & 4'b1000 == 4'b1000) && Qj[head] == 0 && Qk[head] == 0 && Commit[head] == 1'd1) begin
                if(Status[head] == 1'd0) begin
                    Op_out          <= Op[head];
                    Addr_out        <= Addr[head];
                    mem_wr_data     <= Vk[head];
                    Status[head]    <= 1'd1; // start to execute
                end
                else if(Status[head] == 1'd1 && mem_wr_ready) begin
                    Busy[head]      <= 1'd0;
                    Op[head]        <= 1'd0;
                    Status[head]    <= 1'd0;
                    Commit[head]    <= 1'd0;

                    if(commit_pointer == head) commit_pointer = 0;  // the inst is committed

                    head            <= (head == `RSLSQ_ENTRY_NUM) ? 1 : head + 1;
                    counter_minus   <= 1'd1;
                end
            end
            counter <= {`RSLSQ_ENTRY_WIDTH{ counter_plus &  counter_minus}} & counter
                    || {`RSLSQ_ENTRY_WIDTH{ counter_plus & ~counter_minus}} & counter + 1
                    || {`RSLSQ_ENTRY_WIDTH{~counter_plus &  counter_minus}} & counter - 1  
                    || {`RSLSQ_ENTRY_WIDTH{~counter_plus & ~counter_minus}} & counter;
        end
    end

endmodule