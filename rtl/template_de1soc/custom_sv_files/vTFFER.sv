/* 
 * Edge Sensitive T Flip-Flop with Synchronous Enable and Synchronous Reset
 * Outputs inverted input on rising edge of clock
 *
 * Note: If want to use FF without synchronous enable, set: en = 1
 */
module vTFFER(clk, en, rst, toggle, in, out);
    parameter n = 1; // width
    input clk, en, rst, toggle;
    input [n-1:0] in;
    output [n-1:0] out;
    reg [n-1:0] out;

    always_ff @(posedge clk) 
    begin
        if (rst) 
        begin
            out <= 0;
        end 
        else if (en) 
        begin
            if (toggle) 
            begin
                out <= ~in;
            end
            else 
            begin
                out <= in;
            end
        end
    end
endmodule