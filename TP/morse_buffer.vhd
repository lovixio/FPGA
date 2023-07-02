library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity morse_buffer is
    generic();
    port(     
        clock_in : in std_logic;   
        reset_in  : in std_logic;
        read_enable_in : in std_logic;
        morse_in : out std_logic_vector(1 downto 0); 
        buffer_out : out std_logic_vector(10 downto 0);
        char_ready_out : out std_logic;
        end_of_word_out : out std_logic;
    );
end entity;

architecture morse_buffer_architecture of morse_buffer is 

signal current_buffer, next_buffer : std_logic_vector(10 downto 0);
signal morse_counter, next_morse_counter : std_logic_vector(4 downto 0);

begin

    process(clock_in, reset_in)
    begin 
        if (reset_in = '1') then 
            current_buffer <= (others => '0');
            next_buffer <= (others => '0');
            char_ready_out <= 0;
            end_of_word_out <= 0;
        elsif rising_edge(clock_in) then
            if(char_ready_out = '1') then 
                char_ready_out <= '0'; 
                current_buffer <= (others => '0');
            end if;
            if(end_of_word_out = '1') then 
                end_of_word_out <= '0';
            end if;
            if(read_enable_in = '1') then
                if(morse_in = '10' or morse_in = '11') then
                    current_buffer <= next_buffer;
                    morse_counter <= next_morse_counter;                        
                    if(unsigned(morse_counter) = 5) then
                        char_ready_out <= '1';
                        morse_counter = '0';
                    end if;
                else                    
                    char_ready_out <= '1';
                    morse_counter = '0';
                    if(morse_in = '01') then
                        end_of_word_out <= '1';
                    end if;
                end if;
            end if;
        end if;       
    end process;

next_buffer <= std_logic_vector(shift_left(unsigned(current_buffer), 2) + unsigned(morse_in));
next_morse_counter <= morse_counter + 1;

buffer_out <= current_buffer;

end architecture;