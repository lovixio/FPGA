library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity morse_buffer is
    port(     
        clock_in : in std_logic;   
        reset_in  : in std_logic;
        read_enable_in : in std_logic;
        morse_in : in std_logic_vector(1 downto 0); 
        buffer_out : out std_logic_vector(10 downto 0);
        char_ready_out : out std_logic;
        end_of_word_out : out std_logic
    );
end entity;

architecture morse_buffer_architecture of morse_buffer is 

signal current_buffer, next_buffer : std_logic_vector(10 downto 0);
signal morse_counter, next_morse_counter : std_logic_vector(4 downto 0);
signal char_ready : std_logic := '0';
signal end_of_word : std_logic := '0';

begin

    process(clock_in, reset_in)
    begin 
        if (reset_in = '1') then 
            current_buffer <= (others => '0');
            next_buffer <= (others => '0');
            char_ready <= '0';
            end_of_word <= '0';
        elsif rising_edge(clock_in) then
            if(char_ready = '1') then 
                char_ready <= '0'; 
                current_buffer <= (others => '0');
            end if;
            if(end_of_word = '1') then 
                end_of_word <= '0';
            end if;
            if(read_enable_in = '1') then
                if(unsigned(morse_in) = 2 or unsigned(morse_in) = 3) then
                    current_buffer <= next_buffer;
                    morse_counter <= next_morse_counter;                        
                    if(unsigned(morse_counter) = 5) then
                        char_ready <= '1';
                        morse_counter <= (others => '0');
                    end if;
                else                    
                    char_ready <= '1';
                    morse_counter <= (others => '0');
                    if(unsigned(morse_in) = 1) then
                        end_of_word <= '1';
                    end if;
                end if;
            end if;
        end if;       
    end process;

next_buffer <= std_logic_vector(shift_left(unsigned(current_buffer), 2) + unsigned(morse_in));
next_morse_counter <= std_logic_vector(unsigned(morse_counter) + 1);

char_ready_out <= char_ready;
end_of_word_out <= end_of_word;
buffer_out <= current_buffer;

end architecture;