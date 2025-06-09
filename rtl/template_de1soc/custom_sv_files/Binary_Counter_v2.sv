/**
 * VERSION 2 FOR LAB 2
 *
 * Binary counter that counts from [0, 2^N - 1] (inclusive), updated every clk cycle, with synchronous reset
 * Outputs a signal when the count reaches at least count_to
 *
 * @param N - Number of bits used for counting
 * @param clk - Input clock
 * @param rst - Synchronous reset
 * @param count_to - The specific count after which a logic high is outputted 
 * @param out - Output signal specifying when count_to is reached while counting
 */
module Binary_Counter (clk,rst,count_to,out);
    parameter N = 1; 

    input clk;
    input rst;
    input logic [N-1:0] count_to;
    output out;
    
    logic [N-1:0] current_count = 0; // Initial value

    // CL to indicate whenever count_to is reached
    assign out = (current_count >= count_to);

    // Counter FF
    always_ff @(posedge clk) 
    begin
        if (rst) begin
            current_count <= 0;
        end
        else begin 
            current_count <= current_count + 1;
        end
    end
endmodule