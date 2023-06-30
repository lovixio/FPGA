library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.digit_counter_pkg.all;

entity stopwatch is
    port(
            clock_i : in std_logic;
            clear_i : in std_logic;
            enable_i : in std_logic;
            digits_o : out stdlv_array_type(2 downto 0);
        );
end entity;

architecture stopwatch_architecture of stopwatch is
    constant max_count <=  std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(5000000-1, 23));
    signal one_decasecond_passed : std_logic; 
    
    digits_o <= (others => 0);
    
    
    begin
        
        CLOCK_COUNTER:  entity work.mod_m_counter_prog
                        generic map (5000000 => M)
		                port map (  clk_i       => clock_i,
			                        reset_i     => clear_i,
			                        run_i       => enable_i,
			                        max_count_i => max_count,
			                        count_o     => one_decasecond_passed,
			                        max_o       => max_o
			                     );
    
    
        DIGIT_COUNTER: entity work.digit_counter
                       generic map (3 => N)
                       port map ( clk_i => one_decasecond_passed,
                                  reset_i => clear_i,
                                  run_i => enable_i,
                                  digits_o => digits_o                                  
                               );
    
end architecture;
