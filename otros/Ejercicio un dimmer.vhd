library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEE.math_real.all;

entity panic_level is
generic (N:natural := 3); --->Generic!
port (
	clock_i		: 	in std_logic;
	reset_i		: 	in std_logic;
	duty_cycle_i:	in std_logic_vector(N-1 downto 0);
	led_o		:	out std_logic;
     );
end entity;
     
architecture panic_level_architecture of panic_level is

constant TOTAL_CYCLES : natural := natural((2**N) - 1);
signal current_cycle : unsigned(N-1 downto 0);
signal next_cycle : unsigned(N-1 downto 0);

begin

    
    UPDATE_STATE_PROCESS: process(clock_i)
    begin
        if rising_edge(clock_i) then
        
            if (reset_i = '1') then
                current_cycle <= (others => '0');
            end if
            
            if (current_cycle < unsigned(duty_cycles_i)) then
                led_o <= '1';
            else
                led_o <= '0';
            end if
            
            current_cycle <= next_cycle;
            
        end if;
    end process;
    
next_cycle <= (others => '0') when current_cycle = unsigned(TOTAL_CYCLES) else current_cycle + 1;

end architecture;

