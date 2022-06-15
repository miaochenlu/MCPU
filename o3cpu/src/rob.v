`timescale 1ns / 1ps

// https://github.com/XOR-op/TransistorU

module ROB (
    input  clk,
    input  rst,
    input  rollback,
    output full,
    output empty,
    // decode read
    input [`ROB_ENTRY_WIDTH - 1:0]      ROB_rindex1,
    output [31:0]                       ROB_rdata1,
    output                              ready1,

    input [`ROB_ENTRY_WIDTH - 1:0]      ROB_rindex2,
    output [31:0]                       ROB_rdata2,
    output                              ready2,
    
    // decode write
    input                               write_en,
    input [31:0]                        pc_in,
    input [6:0]                         OpCode_in,
    input [4:0]                         waddr_in,
    input                               branch_pred_taken,
    output [`ROB_ENTRY_NUM:0]           ROB_windex,

    // commit to registers
    output reg                          ROB_we,
    output reg [ 4:0]                   addr_commit,
    output reg [31:0]                   data_commit,
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit2reg,

    // commit to lsq
    output reg [`ROB_ENTRY_WIDTH - 1:0] ROB_index_commit2lsq,

    // commit branch
    output reg                          IsBranch_out,
    output reg [31:0]                   BranchInstPC_out,
    output reg                          BranchTaken_out,
    output reg                          MisPredict_out,
    output reg [31:0]                   JumpAddr_out,

    // CDB result
    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_ALU_ROB_index,
    input [31:0]                        CDB_ALU_data,

    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_LSQ_ROB_index,
    input [31:0]                        CDB_LSQ_data,

    input                               CDB_BRA_Jump_en,
    input [31:0]                        CDB_BRA_JumpAddr,
    input [`ROB_ENTRY_WIDTH - 1:0]      CDB_BRA_ROB_index,
    input [31:0]                        CDB_BRA_data
);

    reg                                 Valid[`ROB_ENTRY_NUM:0];
    reg                                 Ready[`ROB_ENTRY_NUM:0];
    reg [6:0]                           OpCode[`ROB_ENTRY_NUM:0];
    reg [31:0]                          PC[`ROB_ENTRY_NUM:0];
    reg [ 4:0]                          DestRegID[`ROB_ENTRY_NUM:0];
    reg [31:0]                          DestRegVal[`ROB_ENTRY_NUM:0];
    reg                                 PredTaken[`ROB_ENTRY_NUM:0];    // branch prediction
    reg                                 ActTaken[`ROB_ENTRY_NUM:0];
    reg [31:0]                          JumpAddr[`ROB_ENTRY_NUM:0];

    // the fifo queue index starts with 1
    reg [`ROB_ENTRY_WIDTH - 1:0]        head, tail;  // pointer to the head and tail of the fifo queue
    reg [`ROB_ENTRY_WIDTH - 1:0]        counter;     // count the number of elements in the ROB, to see if it's empty or full
    reg                                 counter_plus, counter_minus;
    
    integer i;
    assign empty = (counter == 0);
    assign full  = (counter >= `ROB_ENTRY_NUM);
    assign ROB_windex = tail;

    /*****************************decode read****************************/
    assign ready1     = (ROB_rindex1 != 0 && Valid[ROB_rindex1]) ? Ready[ROB_rindex1] : 1'd0;
    assign ready2     = (ROB_rindex2 != 0 && Valid[ROB_rindex2]) ? Ready[ROB_rindex2] : 1'd0;
    assign ROB_rdata1 = (ROB_rindex1 != 0 && Valid[ROB_rindex1]) ? DestRegVal[ROB_rindex1] : 32'd0;
    assign ROB_rdata2 = (ROB_rindex2 != 0 && Valid[ROB_rindex2]) ? DestRegVal[ROB_rindex2] : 32'd0;

    always @(posedge clk) begin
        // set output to default value
        ROB_we <= 1'd0;
        ROB_index_commit2reg <= 0;
        ROB_index_commit2lsq <= 0;
        IsBranch_out <= 0;
        MisPredict_out <= 0;

        if(rst || rollback) begin
            for(i = 0; i <= `ROB_ENTRY_NUM; i = i + 1) begin
                Valid[i]        <= 0;
                Ready[i]        <= 0;
                OpCode[i]       <= 0;
                PC[i]           <= 0;
                DestRegID[i]    <= 0;
                DestRegVal[i]   <= 0;
                PredTaken[i]    <= 0;
                ActTaken[i]     <= 0;
                JumpAddr[i]     <= 0;
            end
            head                <= 1;
            tail                <= 1;
            counter             <= 0;
            counter_minus       <= 0;
            counter_plus        <= 0;
        end
        else begin
            counter_plus  <= 0;
            counter_minus <= 0;

        /*****************************CDB write****************************/
            if(CDB_ALU_ROB_index != 0) begin
                DestRegVal[CDB_ALU_ROB_index] <= CDB_ALU_data;
                Ready[CDB_ALU_ROB_index]      <= 1'd1;
            end

            if(CDB_LSQ_ROB_index != 0) begin
                DestRegVal[CDB_LSQ_ROB_index] <= CDB_LSQ_data;
                Ready[CDB_LSQ_ROB_index]      <= 1'd1;
            end

            if(CDB_BRA_ROB_index != 0) begin
                ActTaken[CDB_BRA_ROB_index]   <= CDB_BRA_Jump_en;
                JumpAddr[CDB_BRA_ROB_index]   <= CDB_BRA_JumpAddr;
                DestRegVal[CDB_BRA_ROB_index] <= CDB_BRA_data;
                Ready[CDB_BRA_ROB_index]      <= 1'd1;
            end

        /*****************************decode write****************************/
            if(write_en && ~full && OpCode_in != 0) begin
                Valid[tail]         <= 1'd1;
                Ready[tail]         <= 1'd0;
                OpCode[tail]        <= OpCode_in;
                PC[tail]            <= pc_in;
                DestRegID[tail]     <= waddr_in;
                DestRegVal[tail]    <= 32'd0;
                PredTaken[i]        <= branch_pred_taken;
                ActTaken[i]         <= 0;
                JumpAddr[i]         <= 0;

                if(OpCode_in == `S_OP) begin
                    Ready[tail] <= 1'd1;
                end

                tail          <= (tail == `ROB_ENTRY_NUM) ? 1 : tail + 1;
                counter_plus  <= 1'd1;
            end

        /*****************************commit****************************/
            if(~empty && (Ready[head])) begin
                case(OpCode[head])
                    `R_OP, `I_LOGIC_OP, `I_MEM_OP, `U_LUI_OP, `U_AUIPC_OP: begin
                        ROB_we                  <= 1'd1;
                        addr_commit             <= DestRegID[head];
                        data_commit             <= DestRegVal[head];
                        ROB_index_commit2reg    <= head;

                        head                    <= (head == `ROB_ENTRY_NUM) ? 1 : head + 1;
                        Valid[head]             <= 1'd0;
                        Ready[head]             <= 1'd0;
                        counter_minus           <= 1'd1;
                    end
                    `S_OP: begin
                        ROB_index_commit2lsq    <= head;
                        head                    <= (head == `ROB_ENTRY_NUM) ? 1 : head + 1;
                        Valid[head]             <= 1'd0;
                        Ready[head]             <= 1'd0;
                        counter_minus           <= 1'd1;
                    end
                    `B_OP, `J_OP: begin
                        IsBranch_out            <= 1'd1;
                        BranchInstPC_out        <= PC[head];
                        BranchTaken_out         <= ActTaken[head];
                        MisPredict_out          <= (PredTaken[head] != ActTaken[head]);
                        JumpAddr_out            <= JumpAddr[head];
                        head                    <= (head == `ROB_ENTRY_NUM) ? 1 : head + 1;
                        Valid[head]             <= 1'd0;
                        Ready[head]             <= 1'd0;
                        counter_minus           <= 1'd1;
                    end
                    `I_JALR_OP: begin
                        ROB_we                  <= 1'd1;
                        addr_commit             <= DestRegID[head];
                        data_commit             <= DestRegVal[head];
                        ROB_index_commit2reg    <= head;

                        IsBranch_out            <= 1'd1;
                        BranchInstPC_out        <= PC[head];
                        BranchTaken_out         <= ActTaken[head];
                        MisPredict_out          <= (PredTaken[head] != ActTaken[head]);
                        JumpAddr_out            <= JumpAddr[head]; 
                        
                        head                    <= (head == `ROB_ENTRY_NUM) ? 1 : head + 1;
                        Valid[head]             <= 1'd0;
                        Ready[head]             <= 1'd0;
                        counter_minus           <= 1'd1;
                    end
                    default: begin
                        ROB_we        <= 1'd0;
                        counter_minus <= 1'd0;
                    end
                endcase
            end
            else begin
                ROB_we        <= 1'd0;
                counter_minus <= 1'd0;
            end
            
        end
    end

    always @(*) begin
        counter = ({`ROB_ENTRY_WIDTH{ counter_plus &&  counter_minus}} & counter)
                | ({`ROB_ENTRY_WIDTH{ counter_plus && ~counter_minus}} & (counter + 1))
                | ({`ROB_ENTRY_WIDTH{~counter_plus &&  counter_minus}} & (counter - 1))  
                | ({`ROB_ENTRY_WIDTH{~counter_plus && ~counter_minus}} & counter);
    end

endmodule
