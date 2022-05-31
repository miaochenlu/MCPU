`timescale 1ns / 1ps

`define TAG_MSB 31
`define TAG_LSB 9
`define INDEX_MSB 8
`define INDEX_LSB 4

module CacheContoller # (
    parameter integer ADDR_WIDTH = 5,
    parameter integer WHOLE_DATA_WIDTH = 128,
    parameter integer BANK_DATA_WIDTH = 32,
    parameter integer DATA_BYTE_NUM = 4,
    parameter integer DATA_WORD_NUM = 4,
    parameter integer TAG_BITS = 23,
    parameter integer CACHE_WAY_BIT = 1,
    parameter integer CACHE_WAY_NUM = 2
)
(
    input clk,
    input rst,
    
    input read_req,
    input write_req,
    input [31:0] addr,
    input [31:0] write_data,
    input [ 2:0] rd_ctrl,
    input [ 1:0] wr_ctrl,
    output reg [31:0] read_data,
    output reg read_data_ready,
    
    // memside
    output mem_read;
    output mem_write;
    output [31:0] mem_addr,
    input  [WHOLE_DATA_WIDTH - 1:0] mem_read_data,
    input  mem_read_data_ready,
    output [WHOLE_DATA_WIDTH - 1:0] mem_write_data
    
);
    
    // remain doubted
    wire [DATA_WORD_NUM - 1:0] wr_word_en = addr_buf[3:2];
    wire [DATA_BYTE_NUM - 1:0] wr_byte_en = addr_buf[1:0];
    
    localparam integer
        STATE_IDLE      = 3'd0,
        STATE_LOOKUP    = 3'd1,
        STATE_HITWRITE  = 3'd2,
        STATE_WB1       = 3'd3,
        STATE_WB2       = 3'd4,
        STATE_REFILL1   = 3'd5,
        STATE_REFILL2   = 3'd6,
        STATE_REFILL3   = 3'd7;
    
    reg ready;
    reg [2:0] state;
    reg [2:0] next_state;
    
    // info read from cache
    reg  [TAG_BITS + ADDR_WIDTH - 1:0] wb_addr_way0;
    reg  [TAG_BITS + ADDR_WIDTH - 1:0] wb_addr_way1;
    reg  [TAG_BITS - 1:0] tag_data_way0;
    reg  [TAG_BITS - 1:0] tag_data_way1;
    reg  [WHOLE_DATA_WIDTH - 1:0] rd_data;
    reg  [WHOLE_DATA_WIDTH - 1:0] rd_data_way0;
    reg  [WHOLE_DATA_WIDTH - 1:0] rd_data_way1;
    wire [CACHE_WAY_NUM - 1:0] valid_arr;
    wire [CACHE_WAY_NUM - 1:0] hit_arr;
    wire [CACHE_WAY_NUM - 1:0] modify_arr;
    
    // buffered request
    reg  [WHOLE_DATA_WIDTH - 1:0] write_data_buf;
    reg  [ADDR_WIDTH - 1:0] addr_buf;
    reg  [DATA_WORD_NUM - 1:0] wr_word_en_buf;
    reg  [DATA_BYTE_NUM - 1:0] wr_byte_en_buf;
    reg  write_req_buf;
    reg  read_req_buf;


    reg  [CACHE_WAY_NUM - 1:0] way_select;
    reg  [CACHE_WAY_NUM - 1:0] fetch_write;
    reg  wr_en;

    
    // LRU info
    reg  [1:0] LRU;
    
    always @(posedge clk) begin
        if(rst) begin
            LRU <= 0;
            state <= STATE_IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            STATE_IDLE: begin
                read_data_ready = 0;
                if(read_req || write_req) begin
                    ready <= 1'b0;
                    next_state <= STATE_LOOKUP;
                end
                else begin
                    ready <= 1'b1;
                    next_state <= STATE_IDLE;
                end
            end
            STATE_LOOKUP: begin
                if((|hit_arr) && write_req_buf)     // hit and write req
                    next_state <= STATE_HITWRITE;
                else if((|hit_arr) && read_req_buf) // hit and write req
                    next_state <= STATE_IDLE;
                else if(~(&valid_arr) || (~modify_arr[LRU[0]]))  // miss and replace data clean
                    next_state <= STATE_REFILL1; 
                else                                // miss but replace data dirty
                    next_state <= STATE_WB1;
            end
            STATE_HITWRITE: begin
                next_state <= STATE_IDLE;
            end
            STATE_WB1: begin
                next_state <= STATE_WB2;
            end
            STATE_WB2: begin
                next_state <= STATE_REFILL1;
            end
            STATE_REFILL1: begin
                if(!mem_wait)
                    next_state <= STATE_REFILL2;
                else 
                    next_state <= STATE_REFILL1;
            end
            STATE_REFILL2: begin
                next_state <= STATE_REFILL3;
            end
            STATE_REFILL3: begin
                next_state <= STATE_IDLE;
            end
        endcase
    end
    
    
    
    always @(*) begin
        case(state)
            STATE_IDLE: begin
                write_data_buf = {write_data, write_data, write_data, write_data};
                addr_buf = addr;
                wr_word_en_buf = wr_word_en;
                wr_byte_en_buf = wr_byte_en;
                write_req_buf = write_req;
                read_req_buf = read_req;
                way_select = 0; // which way to write
                fetch_write = 0;
                wr_en = 0;
            end
            STATE_LOOKUP: begin
                if(|hit_arr) begin
                    if(hit_arr[0]) LRU = 2'b01;
                    else if(hit_arr[1]) LRU = 2'b10;
                    else LRU <= 2'b00;
                    
                    if(write_req) begin
                        way_select = hit_arr;
                        wr_en = 1;
                    end
                    else if(read_req) begin
                        read_data_ready = 1;
                        if(hit_arr[0]) rd_data = rd_data_way0;
                        else if(hit_arr[1]) rd_data = rd_data_way1;
                        else rd_data = 0;
                        /********* append lb, lh, lhu...***********************/
                    end
                end
                else if(~(&valid_arr) || (~modify_arr[LRU[0]])) begin
                    if(~valid_arr[0]) begin // replace way0
                        fetch_write = 2'b01;
                        LRU = 2'b01;
                    end
                    else if(~valid_arr[1]) begin
                        fetch_write = 2'b10;
                        LRU = 2'b10;
                    end
                    else if(~modify_arr[LRU[0]]) begin
                        if(LRU[0]) begin
                            fetch_write = 2'b01;
                            LRU = 2'b01;
                        end
                        else begin
                            fetch_write = 2'b10;
                            LRU = 2'b10;
                        end
                    end
                    /****************************set mem info*************/
                end
                else begin
                    if(LRU[0]) begin
                        fetch_write = 2'b01;
                        LRU = 2'b01;
                    end
                    else begin
                        fetch_write = 2'b10;
                        LRU = 2'b10;
                    end
                end
            end
            STATE_HITWRITE: begin
                way_select = 0;
                wr_en = 0;
            end
            STATE_WB1: begin
                mem_write = 1;
                /******************error addr******************/
                if(fetch_write[0]) begin    // write way0 data back to mem
                    mem_addr = {wb_addr_way0, 3'b000};
                    mem_write_data = rd_data_way0;
                end
                else begin                  // write way1 data back to mem
                    mem_addr = {wb_addr_way1, 3'b000};
                    mem_write_data = rd_data_way1;
                end
            end
            STATE_WB2: begin
                mem_write = 0;
                mem_read = 1;
                /******************error addr******************/
                mem_addr = addr_buf;
            end
            STATE_REFILL1: begin
                if(mem_wait) begin
                    mem_read = 0;   
                end
            end
            STATE_REFILL2: begin
                if(mem_read_data_ready) begin
                    fetch_write = 0;
                    if(write_req_buf) begin
                        way_select = fetch_write;
                    end
                    else if(read_req_buf) begin
                        read_data_ready = 1;
                        if(hit_arr[0]) rd_data = rd_data_way0;
                        else if(hit_arr[1]) rd_data = rd_data_way1;
                        else rd_data = 0;
                    end
                end
            end
            STATE_REFILL3: begin
                way_select = 0;
            end

        endcase
    end
    
     
    Cache2Way (
        .clk(clk),
        .wr_en(wr_en),
        .addr(addr),
        .in_tag(in_tag),
        .way_select(way_select),
        .wr_data(write_data),
        .wr_tag(wr_tag),
        .wr_word_en(wr_word_en),
        .wr_byte_en(wr_byte_en),
        .read_miss(read_miss),
        .valid(valid_arr),
        .hit(hit_arr),
        .modify(modify_arr),
        .wb_addr_way0(wb_addr_way0),
        .wb_addr1_way1(wb_addr_way1),
        .tag_data_way0(tag_data_way0),
        .tag_data_way1(tag_data_way1),
        .rd_data_way0(rd_data_way0),
        .rd_data_way1(rd_data_way1)
    );
endmodule
