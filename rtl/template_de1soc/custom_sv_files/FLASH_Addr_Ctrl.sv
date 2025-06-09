/**
 * Up/down counter for indexing flash memory address
 *
 * @param sampling_clk - sampling rate of flash memory
 * @param rst - synchronous reset
 * @param count_up - boolean variable; if 1, then incrementing; if 0, then decerementing
 * @param read_en - enables controller to find next memory address
 * @param flash_mem_address - flash memory address
 */
module FLASH_Addr_Ctrl (
    sampling_clk,
    rst,
    count_up,
    read_en,
    flash_mem_address
);  

    input sampling_clk;
    input rst;
    input count_up;
    input read_en;
    output [22:0] flash_mem_address;

    logic [22:0] current_address = 23'h0;

    always_ff @(posedge sampling_clk) 
    begin
        begin 
            if (read_en)
            begin
                if (count_up)
                begin
                    if (rst)
                        current_address <= 23'h0;
                    else if (current_address < 23'h7FFFF)
                        current_address <= current_address + 1;
                    else 
                        current_address <= 23'h0;
                end
                else
                begin
                    if (rst)
                        current_address <= 23'h7FFFF;
                    else if (current_address > 23'h0)
                        current_address <= current_address - 1;
                    else 
                        current_address <= 23'h7FFFF;
                end
            end
        end
    end

    assign flash_mem_address = current_address;

endmodule