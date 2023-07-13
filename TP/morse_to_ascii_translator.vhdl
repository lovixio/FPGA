library IEEE;


entity morse_to_ascii_translator is
    generic();
    port(
        clock_in : in std_logic;
        reset_in : in std_logic;
        word_ready_in : in std_logic;
        morse_word_in : in std_logic_vector( 10 downto 0);
        ascii_char_out : out integer;
        ascii_word_buffer: out std_logic_vector( 1024 downto 0); -- guardo hasa 128 letras si son cosas de 8 bits?
    );
end entity;

architecture morse_to_ascii_translator_architecture of morse_to_ascii_translator is
    signal morse_word_section_pointer : std_logic_vector(4 downto 0);
    process(clock_in, reset_in) begin
        if(reset_in = '1') then
            ascii_char_out <= '0';
            ascii_word_buffer <= (others => '0');
            morse_word_section_pointer <= (others => '0');
        else if rising_edge(clock_in) then
            if (word_in_ready = '1') then
                --algo
                --reseteo el pointer
                morse_word_section_pointer <= (others => '0');
            else    
                --traduzco una letra
            end if;
        end if;
    end process;
        
    next_pointer <= std_logic_vector(shift_left(unsigned(current_buffer), 2) + unsigned(morse_in));
    next_morse_counter <= morse_counter + 1;
    

end architecture;    