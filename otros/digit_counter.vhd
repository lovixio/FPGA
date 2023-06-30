library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;



package digit_counter_pkg is
	constant B: natural :=10;
	constant B_bits : natural := natural(ceil(log2(real(B))));
	type stdlv_array_type is array (integer range <>) of
	std_logic_vector (B_bits-1 downto 0);
end package;


entity digit_counter is
	generic(N : natural := 4); -- Cantidad de digitos
	port(clk_i : in std_logic;
	reset_i : in std_logic;
	run_i : in std_logic;
	-- el rango puede no estar:
	digits_o : out stdlv_array_type(N-1 downto 0);
	max_o : out std_logic
	);
end entity;

architecture structural of digit_counter is
	constant max_count : std_logic_vector(B_bits-1 downto 0) := std_logic_vector(to_unsigned(B-1, B_bits));
	signal count_next : std_logic_vector(N downto 0);

begin

	count_next(0) <= run_i;
	DIGITS: for i in 0 to N-1 generate
		CONT: entity work.mod_m_counter_prog
			generic map(M => B) -- Modulo
			port map (  clk_i       => clk_i,
				        reset_i     => reset_i,
				        run_i       => count_next(i),
				        max_count_i => max_count,
				        count_o     => digits_o(i),
				        max_o       => count_next(i+1)
				     );
		end generate;
max_o <= count_next(N);

end architecture;
