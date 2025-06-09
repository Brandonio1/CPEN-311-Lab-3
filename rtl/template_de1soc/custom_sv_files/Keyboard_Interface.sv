//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

module KBD_Interface (clk,KBD_en,KBD_key,play_music,play_forwards,restart_music);

    input clk, KBD_en;
    input [7:0] KBD_key;

    output logic play_music = 0;
    output logic play_forwards = 1;
    output logic restart_music = 0;

    always_ff @(posedge clk)
    begin
        begin
            case (KBD_key)
                character_D : play_music <= 0;
                character_E : play_music <= 1;
                character_B : play_forwards <= 0;
                character_F : play_forwards <= 1;
                character_R : restart_music <= 1;
                default : restart_music <= 0;
            endcase
        end
    end
endmodule