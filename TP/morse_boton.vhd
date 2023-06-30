library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.digit_counter_pkg.all;

entity morse_boton is
    generic();
    port(
        clock    : in std_logic;
        reset    : in std_logic;
        enable   : in std_logic;
        boton_in : in std_logic;
        len_señal_out : in std_logic_vector(5 downto 0);
        tipo_señal_out : in std_logic;
    );
end entity;

architecture morse_boton_architecture of morse_boton is
    constant max_count <=  std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(5000000-1, 23));
    signal one_decasecond_passed : std_logic; 
    
    digits_o <= (others => 0);
    
    
    begin
        
        CLOCK_COUNTER:  entity work.mod_m_counter_prog
                        generic map (5000000 => M)
		                port map (  clk_i       => clock,
			                        reset_i     => reset,
			                        run_i       => enable,
			                        max_count_i => max_count,
			                        count_o     => one_decasecond_passed,
			                        max_o       => max_o
			                     );
    
    
        DIGIT_COUNTER: entity work.digit_counter
                       generic map (3 => N)
                       port map ( clk_i => one_decasecond_passed,
                                  reset_i => reset,
                                  run_i => enable,
                                  digits_o => --cambiar para que saque aca el numero de decasegundos a algo que espere a que cambie la señal                                  
                               );
    
end architecture;
--falta ver como hariamos para que espere a que cambie la señal y ver como determinar que está es short/long o fin letra/palabra