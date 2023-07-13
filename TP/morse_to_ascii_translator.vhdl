library IEEE;


entity morse_to_ascii_translator is
    generic();
    port(
        clock_in                : in std_logic;
        reset_in                : in std_logic;
        morse_ready_in          : in std_logic;
        end_of_word_in          : in std_logic;
        morse_letter_in         : in std_logic_vector( 10 downto 0);
        ascii_char_ready_out    : out std_logic;
        ascii_word_buffer_out   : out std_logic_vector( 1024 downto 0); -- guardo hasa 128 letras si son cosas de 8 bits?
    );
end entity;

architecture morse_to_ascii_translator_architecture of morse_to_ascii_translator is
    signal ascii_char       : unsigned(7 downto 0)  := (others => '0');

    begin
        process(clock_in, reset_in) begin
            if(reset_in = '1') then
                ascii_char_out <= '0';
                ascii_word_buffer <= (others => '0');
            end if;

            if rising_edge(clock_in) then
                if (morse_ready_in = '1') then
                    --leo que tiene el morse_letter_in
                    --lo traduzco
                    case morse_letter_in is
                        when '0000001011' =>
                            ascii_char <= 65; --A
                        when '0011101010' =>
                            ascii_char <= 66; --B
                        when '0011101110' =>
                            ascii_char <= 67; --C
                        when '0000111010' =>
                            ascii_char <= 68; --D
                        when '0000000010' =>
                            ascii_char <= 69; --E
                        when '0010101110' =>
                            ascii_char <= 70; --F
                        when '0000111010' =>
                            ascii_char <= 71; --G
                        when '0010101010' =>
                            ascii_char <= 72; --H
                        when '0000001010' =>
                            ascii_char <= 73; --I
                        when '0010111111' =>
                            ascii_char <= 74; --J
                        when '0000111011' =>
                            ascii_char <= 75; --K
                        when '0010111010' =>
                            ascii_char <= 76; --L
                        when '0000001111' =>
                            ascii_char <= 77; --M
                        when '0000001110' =>
                            ascii_char <= 78; --N
                        when '0000111111' =>
                            ascii_char <= 79; --O
                        when '0010111110' =>
                            ascii_char <= 80; --P
                        when '0011111011' =>
                            ascii_char <= 81; --Q
                        when '0000101110' =>
                            ascii_char <= 82; --R
                        when '0000101010' =>
                            ascii_char <= 83; --S
                        when '0000000011' =>
                            ascii_char <= 84; --T
                        when '0000101011' =>
                            ascii_char <= 85; --U
                        when '0010101011' =>
                            ascii_char <= 86; --V
                        when '0000101111' =>
                            ascii_char <= 87; --W
                        when '0011101011' =>
                            ascii_char <= 88; --X
                        when '0011101111' =>
                            ascii_char <= 89; --Y
                        when '0011111010' =>
                            ascii_char <= 90; --Z
                        when '1111111111' =>
                            ascii_char <= 48; --0
                        when '1011111111' =>
                            ascii_char <= 49; --1
                        when '1010111111' =>
                            ascii_char <= 50; --2
                        when '1010101111' =>
                            ascii_char <= 51; --3
                        when '1010101011' =>
                            ascii_char <= 52; --4
                        when '1010101010' =>
                            ascii_char <= 53; --5
                        when '1110101010' =>
                            ascii_char <= 54; --6
                        when '1111101010' =>
                            ascii_char <= 55; --7
                        when '1111111010' =>
                            ascii_char <= 56; --8
                        when '1111111110' =>
                            ascii_char <= 57; --9
                    end case;
                    --si es end_of_word, agrego el char y pongo como nuevo char el " "
                    if (end_of_word_in = '1') then
                        ascii_word_buffer_out <= shift_left(ascii_word_buffer_out, 8);
                        ascii_word_buffer_out(0) <= ascii_char(0);
                        ascii_word_buffer_out(1) <= ascii_char(1);
                        ascii_word_buffer_out(2) <= ascii_char(2);
                        ascii_word_buffer_out(3) <= ascii_char(3);
                        ascii_word_buffer_out(4) <= ascii_char(4);
                        ascii_word_buffer_out(5) <= ascii_char(5);
                        ascii_word_buffer_out(6) <= ascii_char(6);
                        ascii_word_buffer_out(7) <= ascii_char(7);
                        ascii_char <= 32;
                    end if;
                    --pongo el char en el buffer
                    ascii_word_buffer_out <= shift_left(ascii_word_buffer_out, 8);
                    ascii_word_buffer_out(0) <= ascii_char(0);
                    ascii_word_buffer_out(1) <= ascii_char(1);
                    ascii_word_buffer_out(2) <= ascii_char(2);
                    ascii_word_buffer_out(3) <= ascii_char(3);
                    ascii_word_buffer_out(4) <= ascii_char(4);
                    ascii_word_buffer_out(5) <= ascii_char(5);
                    ascii_word_buffer_out(6) <= ascii_char(6);
                    ascii_word_buffer_out(7) <= ascii_char(7);
                
                end if;
                --cambiamos bit de ready
                ascii_char_ready_out <= morse_ready_in;
            end if;
        end process;

end architecture;    