`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:00 05/05/2025 
// Design Name: 
// Module Name:    cache_control_with_MESI_support 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cache_control_with_MESI_support(
    input IN_INIT_dlx,
    input as_N,
    input wr_N,
    input main_ack,
    input hit,
    input is_shared_in,
    input Reset,
    input CLK,
    input [1:0] mesi_state, // MESI state from the cache itself
    input informed_recived, // Informed received in the bus and other cache
    input flush_block, // Inner signal to start flush of a block
    output IN_INIT_out,
    output ack_N,
    output M_as_N,
    output M_wr_N,
    output wr_en,
    output set_dirty,
    output [3:0] state_o,
    output [4:0] block_counter_o,
    output mod_en,
    output tag_en,
    output [2:0] bus_cmd_req,
    output MESI_to_Modified
    );


parameter BLOCK_SIZE = 16;

reg [3:0] state;
reg [3:0] next_state;
reg [4:0] block_counter;
reg block_counter_en;
reg [3:0] interupted_state;

// control states parameters
parameter init_wait = 4'h0;
parameter check_addr  = 4'h2;
parameter read = 4'h3; // 0011
parameter write = 4'h4; // 0100
parameter miss = 4'h5;
parameter clear_dirty = 4'h6;
parameter get_block = 4'h7; // 0111
parameter save_block = 4'h8; // 1000
parameter save_dirty = 4'h9;
parameter reset_counter = 4'hA;
parameter Inform = 4'hB; // Inform other caches about MESI status change
parameter flush_word = 4'hC; // Flush word from the cache
parameter flush_next = 4'hD; // Prepare to flush the next word from the cache
parameter finish = 4'hF;


// mesi states parameters
parameter MESI_I = 2'b00; // Invalid
parameter MESI_S = 2'b01; // Shared
parameter MESI_E = 2'b10; // Exclusive
parameter MESI_M = 2'b11; // Modified

// bus_cmd_req parameters
parameter BusRd = 3'b001; // Bus Read
parameter BusRdX = 3'b010; // Bus Read Exclusive
parameter flush = 3'b011; // Flush
parameter BusInform = 3'b100; // Bus command - Inform other caches about MESI status cahnge
parameter dirtyflush = 3'b101; // Flush dirty block 

always@(*) begin
    next_state = state;
    block_counter_en = 0;
    case(state)
        init_wait:
            if(flush_block) begin
                next_state = flush_word;
            end
            else if(as_N)
                next_state = init_wait;
            else
                next_state = check_addr;

        check_addr: // check tag, dirty, and MESI state for the recieived address
            if(flush_block) 
                next_state = flush_word;
            
            else if(~hit) begin
                if(mesi_state == MESI_M)
                    next_state = clear_dirty;
                else
                    next_state = get_block;
            end
            else if(mesi_state == MESI_I) 
                next_state = get_block;
            else if(mesi_state == MESI_S && wr_N == 0) 
                next_state = Inform;
            else if(wr_N)
                next_state = read;
            else
                next_state = write;
        
        clear_dirty:
            if(flush_block) 
                next_state = flush_word;

            else if(~main_ack) begin
                next_state = save_dirty;
                block_counter_en = 1;
            end
            else
                next_state = clear_dirty;
        
        save_dirty:
            if(block_counter < BLOCK_SIZE)
                next_state = clear_dirty;
            else
                next_state = reset_counter;

        reset_counter: begin
            next_state = get_block;
        end

        get_block:
            if(flush_block) 
                next_state = flush_word;

            else if(~main_ack) begin
                next_state = save_block;
                block_counter_en = 1;
            end
            else
                next_state = get_block;
        
        save_block:
            if(block_counter < BLOCK_SIZE) 
                next_state = get_block;
            else
                if(wr_N)
                    next_state = read;
                else 
                    next_state = write;

        Inform:
            if(informed_recived)begin
                if(wr_N)
                    next_state = read;
                else
                    next_state = write;
            end
            else
                next_state = Inform;

        read, write: begin
            next_state = finish;
        end
        
        flush_word:
            if(~main_ack) begin
                next_state = flush_next;
                block_counter_en = 1;
            end
            else
                next_state = flush_word;

        flush_next:
            if(block_counter < BLOCK_SIZE)
                next_state = flush_word;
            else
                next_state = interupted_state;

        finish:
            next_state = init_wait;

        default: begin
            next_state = init_wait;
        end
    endcase
end

always@(posedge CLK) begin
    if(Reset) begin
        state <= init_wait;
        block_counter <= 0;
    end else begin
        state <= next_state;
        if (block_counter_en || next_state == save_block)
            block_counter <= block_counter + 1;
        else if (state == check_addr || state == reset_counter || state == read || state == write || state == init_wait)
            block_counter <= 0;
        if (next_state == flush_word && (state == init_wait || state == check_addr || state == get_block || state == clear_dirty)) 
            interupted_state <= state;
    end
end

assign IN_INIT_out = (state == init_wait || state == check_addr || state == read || state == write || 
                        state == flush_word || state == flush_next || state == finish) ? 1 : 0;
assign ack_N = (state == finish) ? 0 : 1;
assign M_as_N = (state == clear_dirty || state == get_block || state == flush_word) ? 0 : 1;
assign M_wr_N = (state == clear_dirty || state == flush_word || state == flush_next) ? 0 : 1;
assign wr_en = (state == write || (state == get_block && ~main_ack)) ? 1 : 0;
assign state_o = state;
assign block_counter_o = block_counter;
assign tag_en = (state == clear_dirty || state == flush_word) ? 1 : 0;
assign mod_en = (state == clear_dirty || state == get_block || state == flush_word || state == flush_next) ? 1 : 0;
assign bus_cmd_req = ((state == get_block || state == save_block) && wr_N) ? BusRd : 
                     ((state == get_block || state == save_block) && ~wr_N) ? BusRdX :
                     (state == Inform) ? BusInform :
                     (state == flush_word || state == flush_next) ? flush : 
                     (state == clear_dirty || state == save_dirty) ? dirtyflush :
                     3'b000;
assign MESI_to_Modified = (state == write) ? 1 : 0;

endmodule
