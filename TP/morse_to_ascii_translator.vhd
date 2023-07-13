library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity morse_to_ascii_translator is
    port(
        clock_in                : in std_logic;
        reset_in                : in std_logic;
        morse_ready_in          : in std_logic;
        end_of_word_in          : in std_logic;
        morse_letter_in         : in std_logic_vector(9 downto 0);
        ascii_char_ready_out    : out std_logic;
        ascii_char_out          : out std_logic_vector(7 downto 0)
    );
end entity;

architecture morse_to_ascii_translator_architecture of morse_to_ascii_translator is
    signal ascii_char       : unsigned(7 downto 0)  := (others => '0');
    signal write_end_of_word: std_logic             := '0';

    begin
        process(clock_in, reset_in) begin
            if(reset_in = '1') then
                ascii_char_out <= (others => '0');
                --ascii_word_buffer <= (others => '0');
            end if;

            if rising_edge(clock_in) then
                if (write_end_of_word = '0') then
                    ascii_char <= to_unsigned(32, 8);
                    write_end_of_word <= '0';
                elsif (morse_ready_in = '1') then
                    --leo que tiene el morse_letter_in
                    --lo traduzco
                    case morse_letter_in is
                        when "0000001011" =>
                            ascii_char <= to_unsigned(65, 8); --A
                        when "0011101010" =>
                            ascii_char <= to_unsigned(66, 8); --B
                        when "0011101110" =>
                            ascii_char <= to_unsigned(67, 8); --C
                        when "0000111010" =>
                            ascii_char <= to_unsigned(68, 8); --D
                        when "0000000010" =>
                            ascii_char <= to_unsigned(69, 8); --E
                        when "0010101110" =>
                            ascii_char <= to_unsigned(70, 8); --F
                        when "0000111010" =>
                            ascii_char <= to_unsigned(71, 8); --G
                        when "0010101010" =>
                            ascii_char <= to_unsigned(72, 8); --H
                        when "0000001010" =>
                            ascii_char <= to_unsigned(73, 8); --I
                        when "0010111111" =>
                            ascii_char <= to_unsigned(74, 8); --J
                        when "0000111011" =>
                            ascii_char <= to_unsigned(75, 8); --K
                        when "0010111010" =>
                            ascii_char <= to_unsigned(76, 8); --L
                        when "0000001111" =>
                            ascii_char <= to_unsigned(77, 8); --M
                        when "0000001110" =>
                            ascii_char <= to_unsigned(78, 8); --N
                        when "0000111111" =>
                            ascii_char <= to_unsigned(79, 8); --O
                        when "0010111110" =>
                            ascii_char <= to_unsigned(80, 8); --P
                        when "0011111011" =>
                            ascii_char <= to_unsigned(81, 8); --Q
                        when "0000101110" =>
                            ascii_char <= to_unsigned(82, 8); --R
                        when "0000101010" =>
                            ascii_char <= to_unsigned(83, 8); --S
                        when "0000000011" =>
                            ascii_char <= to_unsigned(84, 8); --T
                        when "0000101011" =>
                            ascii_char <= to_unsigned(85, 8); --U
                        when "0010101011" =>
                            ascii_char <= to_unsigned(86, 8); --V
                        when "0000101111" =>
                            ascii_char <= to_unsigned(87, 8); --W
                        when "0011101011" =>
                            ascii_char <= to_unsigned(88, 8); --X
                        when "0011101111" =>
                            ascii_char <= to_unsigned(89, 8); --Y
                        when "0011111010" =>
                            ascii_char <= to_unsigned(90, 8); --Z
                        when "1111111111" =>
                            ascii_char <= to_unsigned(48, 8); --0
                        when "1011111111" =>
                            ascii_char <= to_unsigned(49, 8); --1
                        when "1010111111" =>
                            ascii_char <= to_unsigned(50, 8); --2
                        when "1010101111" =>
                            ascii_char <= to_unsigned(51, 8); --3
                        when "1010101011" =>
                            ascii_char <= to_unsigned(52, 8); --4
                        when "1010101010" =>
                            ascii_char <= to_unsigned(53, 8); --5
                        when "1110101010" =>
                            ascii_char <= to_unsigned(54, 8); --6
                        when "1111101010" =>
                            ascii_char <= to_unsigned(55, 8); --7
                        when "1111111010" =>
                            ascii_char <= to_unsigned(56, 8); --8
                        when "1111111110" =>
                            ascii_char <= to_unsigned(57, 8); --9
                    end case;
                    --si es end_of_word, agrego el char y pongo como nuevo char el " "
                    if (end_of_word_in = '1') then
                        write_end_of_word <= '1';
                    end if;
                
                end if;
                --cambiamos bit de ready
                ascii_char_out <= std_logic_vector(ascii_char);
                ascii_char_ready_out <= morse_ready_in;
            end if;
        end process;

end architecture;    