/**
 * Edge trap synchronizer circuit; takes in an asychronous input and
 * outputs it on the same clock domain as clk after 2 synchronized
 * clock cycles
 *
 * @param asynch_input - asynchronous input
 * @param clk - synchronized clock domain
 * @param synch_output - synchronus output
 */

module Edge_Trap (async_in,clk,sync_sig);
    input async_in;
    input clk;
    output sync_sig;

    reg ff1, ff2, ff3;
    wire auto_reset;
    
    always_ff @(posedge async_in or posedge auto_reset) 
    begin
        if (auto_reset) 
        begin
            ff1 <= 1'b0;
        end 
        else 
        begin
            ff1 <= 1'b1;
        end
    end

    always_ff @(posedge clk)
    begin
        ff2 <= ff1;
    end

    always_ff @(posedge clk)
    begin
        ff3 <= ff2;
    end

    
    assign auto_reset = ff3 && (!async_in);
    assign sync_sig = ff3;

endmodule