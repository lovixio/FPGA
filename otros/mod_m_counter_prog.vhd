library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity mod_m_counter_prog is
	generic(M : natural); -- Modulo
	port	(clk_i : in std_logic;
		reset_i : in std_logic;
		run_i : in std_logic;
		max_count_i : in std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
		count_o : out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
		max_o : out std_logic
		);
end entity;

architecture mod_m_counter_prog_arch of mod_m_counter_prog is
	constant NUM_BITS : natural := natural(ceil(log2(real(M))));
	signal r_reg : unsigned(NUM_BITS-1 downto 0);
	signal r_next : unsigned(NUM_BITS-1 downto 0);
begin
NXT_STATE_PROC: process(clk_i, reset_i)
                begin
                    if rising_edge(clk_i) then
                        if (reset_i = '1') then
                        r_reg <= (others => '0');
                        elsif run_i = '1' then
                        r_reg <= r_next;
                        end if;
                    end if;
                end process;
r_next <= (others => '0') when r_reg = unsigned(max_count_i) else
r_reg + 1;

end architecture;
