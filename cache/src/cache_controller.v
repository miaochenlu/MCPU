`timescale 1ns / 1ps
`include "defines.vh"

`define TAG_MSB 31
`define TAG_LSB 9
`define INDEX_MSB 8
`define INDEX_LSB 4

module CacheController # (
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
    // cpu side port
    input               read_req,
    input               write_req,
    input [31:0]        addr,
    input [ 1:0]        wr_ctrl,
    input [ 2:0]        rd_ctrl,
    input [31:0]        wr_data,
    output reg          rd_data_valid,
    output reg          wr_ready,
    output reg [ 31:0]  rd_data,

    // mem side port
    input  [127:0]      mem_rd_data,
    input               mem_rd_data_valid,
    input               mem_wr_data_ready,
    output reg [ 31:0]  mem_read_addr,
    output reg [ 31:0]  mem_write_addr,
    output reg          mem_read,
    output reg          mem_write,
    output reg [127:0]  mem_wr_data
);
    localparam integer
        ST_IDLE = 3'd0,
        ST_LKUP = 3'd1,
        ST_WBAC = 3'd2,
        ST_REFL = 3'd3;

    reg [1:0] state;
    reg [1:0] next_state;
    
    // store the request related info
    reg                         read_req_buf;
    reg                                 write_req_buf;
    reg [ 31:0]                     addr_buf;
    reg [WHOLE_DATA_WIDTH - 1:0]    wr_data_buf;
    reg [  2:0]                     rd_ctrl_buf;
    reg [  1:0]                     wr_ctrl_buf;
    
    wire [  1:0] word_offset = addr_buf[3:2];
    wire [  1:0] byte_offset = addr_buf[1:0];
    wire [  3:0] wr_byte_en;
    wire [  3:0] wr_word_en;
    wire [  3:0] wr_word_en_actual;
    wire [  3:0] wr_byte_en_actual;

    wire [4:0]            set_index  = addr_buf[`INDEX_MSB:`INDEX_LSB];
    wire [TAG_BITS - 1:0] addr_tag   = addr_buf[`TAG_MSB:`TAG_LSB];


    wire                        cache_write;
    reg                         refill;
    reg [CACHE_WAY_NUM - 1:0]   way_select;

    reg fetch_write;
    reg hit_write;

    wire [WHOLE_DATA_WIDTH - 1:0] wr_data_actual;

    wire [CACHE_WAY_NUM - 1:0]    valid_arr;
    wire [CACHE_WAY_NUM - 1:0]    hit_arr;
    wire [CACHE_WAY_NUM - 1:0]    modify_arr;
    wire [CACHE_WAY_NUM - 1:0]    refill_ready_arr;
    wire [CACHE_WAY_NUM - 1:0]    write_data_ready_arr;
    wire [TAG_BITS - 1:0]         out_tag_way0;
    wire [TAG_BITS - 1:0]         out_tag_way1;

    wire [WHOLE_DATA_WIDTH - 1:0] rd_data_way0;
    wire [WHOLE_DATA_WIDTH - 1:0] rd_data_way1;
    reg  [WHOLE_DATA_WIDTH - 1:0] raw_read_data_128;
    reg  [BANK_DATA_WIDTH - 1:0]  raw_read_data_32;
    
    reg mem_rd_data_valid_buf;

    wire hit   = (|hit_arr);
    wire valid = (|valid_arr);

    reg [CACHE_WAY_NUM - 1:0] LRU[(1 << ADDR_WIDTH) - 1:0];

    integer i;

    /************************************write byte control*************************************/
    
    assign wr_word_en = (~write_req_buf) ? 4'b0000 :
                        ({4{word_offset == 2'b00}} & 4'b0001)
                      | ({4{word_offset == 2'b01}} & 4'b0010)
                      | ({4{word_offset == 2'b10}} & 4'b0100)
                      | ({4{word_offset == 2'b11}} & 4'b1000);
    
    assign wr_byte_en = (~write_req_buf) ? 4'b0000 :
                        ({4{wr_ctrl_buf == `SB}} & ({32{byte_offset == 2'b00}} & 4'b0001)
                                            | ({32{byte_offset == 2'b01}} & 4'b0010)
                                            | ({32{byte_offset == 2'b10}} & 4'b0100)
                                            | ({32{byte_offset == 2'b11}} & 4'b1000))
                     | ({4{wr_ctrl_buf == `SH}} & ({32{byte_offset[1] == 1'b0}} & 4'b0011)
                                            | ({32{byte_offset[1] == 1'b1}} & 4'b1100))
                     | ({4{wr_ctrl_buf == `SW}} & 4'b1111);
 
    
    assign wr_data_actual    = fetch_write ? mem_rd_data : wr_data_buf;
    assign cache_write       = fetch_write ? mem_rd_data_valid : hit_write; 
    assign wr_word_en_actual = fetch_write ? 4'b1111 : wr_word_en;
    assign wr_byte_en_actual = fetch_write ? 4'b1111 : wr_byte_en;

    always @(posedge clk) begin
        if(rst) begin
            // initialize buffered info
            read_req_buf   <= 0;
            write_req_buf  <= 0;
            addr_buf       <= 0;
            wr_data_buf    <= 0;
            rd_ctrl_buf    <= 0;
            wr_ctrl_buf    <= 0;

            // initialize cache req
            hit_write   <= 0;
            fetch_write <= 0;
            refill      <= 0;
            way_select  <= 0;

            // initialize cpu output
            raw_read_data_128 <= 0;
            raw_read_data_32  <= 0;
            rd_data_valid     <= 0;
            wr_ready          <= 0;

            // initialize mem output
            mem_read                <= 0;
            mem_write               <= 0;
            mem_read_addr           <= 0;
            mem_write_addr          <= 0;
            mem_wr_data             <= 0;
            
            mem_rd_data_valid_buf   <= 0;
            // initialize state
            state                   <= ST_IDLE;
            next_state              <= ST_IDLE;

            // initialize LRU
            for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
                LRU[i] <= 0;
            end

        end
        else begin
            if(next_state == ST_IDLE) begin
                rd_data_valid           <= 0;
                wr_ready                <= 0;
                read_req_buf            <= read_req;
                write_req_buf           <= write_req;
                addr_buf                <= addr;
                rd_ctrl_buf             <= rd_ctrl;
                wr_ctrl_buf             <= wr_ctrl;
                wr_data_buf             <= {wr_data, wr_data, wr_data, wr_data};
                mem_rd_data_valid_buf   <= 0;
                refill                  <= 0;
                way_select              <= 0;
                fetch_write             <= 0;
                hit_write               <= 0;
            end
            state <= next_state;
        end
            
    end

    always @(*) begin
        case(state)
            ST_IDLE: begin  
                if(read_req || write_req) begin
                    next_state <= ST_LKUP;
                end
            end
            ST_LKUP: begin
                if(hit && read_req_buf) begin
                    rd_data_valid       = 1;
                    raw_read_data_128   = ({128{hit_arr[0]}} & rd_data_way0) | ({128{hit_arr[1]}} & rd_data_way1);
                    LRU[set_index]      = ({2{hit_arr[0]}} & 2'b01) | ({2{hit_arr[1]}} & 2'b10);
                    next_state          = ST_IDLE;
                    // at the same time, control read words and bytes
                end
                else if(hit && write_req_buf) begin
                    hit_write       = 1;
                    way_select      = hit_arr;
                    LRU[set_index]  = ({2{hit_arr[0]}} & 2'b01) | ({2{hit_arr[1]}} & 2'b10);

                    if(|write_data_ready_arr) begin
                        wr_ready    = 1;
                        next_state  = ST_IDLE;
                    end
                end
                else if(~(&valid_arr) || ~(modify_arr[LRU[0]])) begin
//                    fetch_write = 1;
//                    refill = 1;
                    if(~valid_arr[0]) begin
                        way_select = 2'b01;
                    end
                    else if(~valid_arr[1]) begin
                        way_select = 2'b10;
                    end
                    else if(~(modify_arr[LRU[set_index][0]])) begin
                        if(LRU[set_index][0] == 1'b1) begin // replace way1
                            way_select      = 2'b10;
                            LRU[set_index]  = 2'b01;
                       end
                       else begin               // replace way0
                            way_select      = 2'b01;
                            LRU[set_index]  = 2'b10;
                       end
                    end

                    mem_read_addr   = {addr_tag, set_index, 4'b0};
                    mem_read        = 1'b1;
                    next_state      = ST_REFL;
                end
                else begin
//                    fetch_write = 1;
//                    refill = 1;
                    if(LRU[set_index][0] == 1'b1) begin // replace way1
                        way_select      = 2'b10;
                        LRU[set_index]  = 2'b01;
                    end
                    else begin               // replace way0
                        way_select      = 2'b01;
                        LRU[set_index]  = 2'b10;
                    end

                    mem_read_addr   = {addr_tag, set_index, 4'b0};
                    mem_read        = 1'b1;
                    next_state      = ST_WBAC;
                end
            end
        ST_WBAC: begin
            mem_write = 1;
            if(way_select == 2'b01) begin
                mem_write_addr  = {out_tag_way0, set_index, 4'b0};
                mem_wr_data     = rd_data_way0;
            end
            else if(way_select == 2'b10) begin
                mem_write_addr  = {out_tag_way1, set_index, 4'b0};
                mem_wr_data     = rd_data_way1;
            end
            else begin
                mem_write_addr  = 0;
                mem_wr_data     = 0;
            end

            if(mem_wr_data_ready) begin
                mem_write       = 0;
                mem_write_addr  = 0;
                mem_wr_data     = 0;
                next_state      = ST_REFL;
            end
        end

        ST_REFL: begin
            if(mem_rd_data_valid) begin
                mem_rd_data_valid_buf = mem_rd_data_valid;
                mem_read        = 0;
                mem_read_addr   = 0;
                fetch_write     = 1;
                refill          = 1;
            end
            if(mem_rd_data_valid_buf & (|refill_ready_arr)) begin
                fetch_write = 0;
                refill      = 0;
                if(read_req_buf) begin
                    rd_data_valid       = 1;
                    raw_read_data_128   = mem_rd_data;
                    next_state          = ST_IDLE;
                end
                else if(write_req_buf) begin
                    next_state = ST_LKUP;
                end
            end
        end
        endcase
    end

    /************************************read byte control*************************************/
    always @(*) begin
        if(rd_data_valid) begin
            case(word_offset)
                2'b00: raw_read_data_32 = raw_read_data_128[31:0];
                2'b01: raw_read_data_32 = raw_read_data_128[63:32];
                2'b10: raw_read_data_32 = raw_read_data_128[95:64];
                2'b11: raw_read_data_32 = raw_read_data_128[127:96];
            endcase
            case(rd_ctrl_buf)
                `LB:  begin
                    rd_data = ({32{byte_offset == 2'b00}} & {{24{raw_read_data_32[ 7]}}, raw_read_data_32[ 7:0 ]})
                            | ({32{byte_offset == 2'b01}} & {{24{raw_read_data_32[15]}}, raw_read_data_32[15:8 ]})
                            | ({32{byte_offset == 2'b10}} & {{24{raw_read_data_32[23]}}, raw_read_data_32[23:16]})
                            | ({32{byte_offset == 2'b11}} & {{24{raw_read_data_32[31]}}, raw_read_data_32[31:24]});
                end
                `LBU: begin
                    rd_data = ({32{byte_offset == 2'b00}} & {24'b0, raw_read_data_32[ 7:0 ]})
                            | ({32{byte_offset == 2'b01}} & {24'b0, raw_read_data_32[15:8 ]})
                            | ({32{byte_offset == 2'b10}} & {24'b0, raw_read_data_32[23:16]})
                            | ({32{byte_offset == 2'b11}} & {24'b0, raw_read_data_32[31:24]});
                end
                `LH: begin
                    rd_data = ({32{byte_offset[1] == 1'b0}} & {{16{raw_read_data_32[15]}}, raw_read_data_32[15:0 ]})
                            | ({32{byte_offset[1] == 1'b1}} & {{16{raw_read_data_32[31]}}, raw_read_data_32[31:16]});
                end
                `LHU: begin
                    rd_data = ({32{byte_offset[1] == 1'b0}} & {16'b0, raw_read_data_32[15:0 ]})
                            | ({32{byte_offset[1] == 1'b1}} & {16'b0, raw_read_data_32[31:16]});
                end
                `LW : begin
                    rd_data = raw_read_data_32;
                end
                default: rd_data = 32'b0;
            endcase
        end
        else rd_data = 0;
    end

    Cache2Way M_Cache2Way (
        .clk(clk),
        .rst(rst),
        .wr_en(cache_write),
        .refill(refill),
        .addr(set_index),
        .in_tag(addr_tag),
        .way_select(way_select),
        .wr_data(wr_data_actual),
        .wr_word_en(wr_word_en_actual),
        .wr_byte_en(wr_byte_en_actual),
        .valid(valid_arr),
        .hit(hit_arr),
        .modify(modify_arr),
        .out_tag_way0(out_tag_way0),
        .out_tag_way1(out_tag_way1),
        .rd_data_way0(rd_data_way0),
        .rd_data_way1(rd_data_way1),
        .refill_ready(refill_ready_arr),
        .write_data_ready(write_data_ready_arr)
    );
endmodule