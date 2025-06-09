/**
 * VERSION 2 FOR LAB 2
 * MUST USE WITH Binary_Counter_v2
 * 
 * Takes in a clock frequency of inclk and outputs a new clock frequency
 * of inclk/(2*N) at outclk, where N = num_clk_divisions
 *
 * 2*N - Number of clock frequency divisions
 * @param inclk - Input clock frequency
 * @param reset - Synchronous reset for circuit
 * @param num_clk_divisions - Number of times clock frequency is divided in half; 
 *          0 < nunm_clk_divisions < (2^32 - 1)/2
 * @param outclk - Output clock frequency; outclk = inclk/(2*N)
 */
module Clk_Freq_Divider (inclk,reset,num_clk_divisions,outclk);
 
    input inclk, reset;
    input [31:0] num_clk_divisions;
    output outclk;

    logic next_clk;
    logic count_compare;
    logic [31:0] count_to; // 32 bit counter signal

    assign count_to = num_clk_divisions - 32'd1;
    assign next_clk = outclk; 
    
    // Once counter counts to N - 1 (which is N counts since it is a binary counter), on the next
    // rising edge of inclk, it resets itself
    Binary_Counter #(.N(32)) clk_period_counter (
        .clk(inclk), 
        .rst(count_compare), 
        .count_to(count_to), 
        .out(count_compare)
    );

    // At the same time the counter resets itself, this FF outputs the inverted value of the frequency
    // divided clock for use in the next clock cycle
    vTFFER #(.n(1)) next_clk_TFF  (
        .clk(inclk),
        .en(count_compare),
        .rst(reset),
        .toggle(1'b1),
        .in(next_clk),
        .out(outclk)
    );
    
endmodule