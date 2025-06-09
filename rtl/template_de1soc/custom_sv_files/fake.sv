/**
 * Controller for the audio data
 */
module FLASH_Rd_Ctrl (
    sampling_clk,
    flash_mem_address,
    count_up,

    flash_mem_waitrequest,
    flash_mem_readdata,
    flash_mem_readdatavalid,

    audio_data,
    get_new_address
);

    input sampling_clk;
    input [22:0] flash_mem_address;
    input count_up;

    input flash_mem_waitrequest;
    input [31:0] flash_mem_readdata;
    input flash_mem_readdatavalid;

    output logic [7:0] audio_data;
    output logic get_new_address = 0;

    // Boolean variable, used for reading upper/lower byte of FLASH audio data during the next clock cycle
    logic read_lower_audio_byte_next = 1;

    // FF for reading audio data from the flash memory
    // Sends lower and upper byte of the 16 bit flash data to the audio data every two cycles
    // Requests new audio data from the flash memory after those two cycles
    always_ff @(posedge sampling_clk)
    begin   
        if (flash_mem_readdatavalid)
        begin
            // For the first half of the memory addresses, read audio data from the
            // lower 16 bits of the flash_mem_readdata
            if (flash_mem_address < 23'h40000)
            begin
                // Reading lower byte of the lower 16 bits of the read data
                if (read_lower_audio_byte_next)
                    audio_data <= flash_mem_readdata[7:0];
                // Reading upper byte of the lower 16 bits of the read data
                else
                    audio_data <= flash_mem_readdata[15:8];
            end
            // For the second half of the memory addresses, read audio data from the
            // upper 16 bits of the flash_mem_readdata
            else 
            begin
                // Reading lower byte of the upper 16 bits of read data
                if (read_lower_audio_byte_next)
                    audio_data <= flash_mem_readdata[23:16];
                // Reading upper byte of the upper 16 bits of read data
                else
                    audio_data <= flash_mem_readdata[31:24];
            end
    
            // Logic for inverting read_lower_audio_byte_next and get_new_address
            if (count_up)
            begin
                // If currently reading upper byte and able to get a new memory address
                // then flip to reading lower byte next cycle
                // This ensures that the bytes being read do not flip back and forth unnecessarily
                // if a new memory address cannot be received
                if (read_lower_audio_byte_next && (get_new_address))
                begin
                    read_lower_audio_byte_next <= 0;
                    get_new_address <= 0;
                end
                // Flip to reading upper byte 
                else if (!read_lower_audio_byte_next)
                begin
                    read_lower_audio_byte_next <= 1;
                end
                else
                begin
                    // Enables new address to be received by the flash address controller FSM
                    // if there is no wait request from flash memory
                    if (!flash_mem_waitrequest)
                    begin
                        read_lower_audio_byte_next <= 0;
                        get_new_address <= 1;
                    end
                end
            end
            // Same as above but for decrementing the flash memory address
            else
            begin
                if (!read_lower_audio_byte_next && (get_new_address))
                begin
                    read_lower_audio_byte_next <= 1;
                    get_new_address <= 0;
                end
                else if (read_lower_audio_byte_next)
                begin
                    read_lower_audio_byte_next <= 0;
                end
                else
                begin
                    if (!flash_mem_waitrequest)
                    begin
                        read_lower_audio_byte_next <= 1;
                        get_new_address <= 1;
                    end
                end
            end 
        end
    end

endmodule