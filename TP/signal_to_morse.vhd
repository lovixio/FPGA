library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity signal_to_morse is
    port(        
        clock_in : in std_logic;
        reset_in  : in std_logic;
        read_enable_in : in std_logic;
        type_in  : in std_logic;
        duration_in  : in std_logic_vector(22 downto 0);
        short_limit_in : in std_logic_vector(5 downto 0);
        long_limit_in : in std_logic_vector(5 downto 0);
        morse_out : out std_logic_vector(1 downto 0); 
        morse_ready_out : out std_logic 
    );
end entity;

architecture signal_to_morse_architecture of signal_to_morse is
    
    signal morse : std_logic_vector(1 downto 0) := (others => '0');
    signal silence_short_limit : unsigned(5 downto 0) := unsigned(short_limit_in)*3;
    signal silence_long_limit : unsigned(5 downto 0) := unsigned(short_limit_in)*7;
    signal morse_ready : std_logic := '0';

begin 

    process(clock_in)
    begin 
        if(rising_edge(clock_in)) then
            if (morse_ready = '1') then
                morse_ready <= '0';
            end if;
            if(read_enable_in = '1') then
                if (type_in = '1') then
                    if (unsigned(duration_in) > unsigned(short_limit_in) and unsigned(duration_in) < unsigned(long_limit_in)) then

                        morse <= std_logic_vector(to_unsigned(2, 2));
                        morse_ready <= '1';

                    elsif (unsigned(duration_in) > unsigned(long_limit_in)) then
                    
                        morse <= std_logic_vector(to_unsigned(3, 2));
                        morse_ready <= '1';
                    
                    end if;
                else
                    if (unsigned(duration_in) > unsigned(silence_short_limit) and unsigned(duration_in) < unsigned(silence_long_limit)) then

                        morse <= std_logic_vector(to_unsigned(0, 2));
                        morse_ready <= '1';

                    elsif (unsigned(duration_in) > unsigned(silence_long_limit)) then

                        morse <= std_logic_vector(to_unsigned(1, 2));
                        morse_ready <= '1';

                    end if;
                end if;
            end if;
        end if;
    end process;
                       
    morse_out <= morse;
    morse_ready_out <= morse_ready;

end architecture;