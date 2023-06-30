library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity cordic_iter is
  generic(
    N     : natural := 8;  --Ancho de la palabra
    SHIFT : natural := 1); --Desplazamiento
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;
    xi    : in std_logic_vector (N-1 downto 0);
    yi    : in std_logic_vector (N-1 downto 0);
    zi    : in std_logic_vector (N-1 downto 0);
    ci    : in std_logic_vector (N-1 downto 0);
    dv_o  : out std_logic;
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
  );
end entity;

architecture strcutural of cordic_iter is
    signal error_iter : std_logic_vector(N-1 downto 0);
  begin
  	iter: process(clk, rst)
  	begin
  	    if rising_edge(clk) then
  	        if (en_i = '0') then
  	            xip1 <= std_logic_vector(unsigned(xi) - shift_left(unsigned(yi), SHIFT));
  	            yip1 <= std_logic_vector(unsigned(yi) + shift_left(unsigned(xi), SHIFT));
  	            error_iter <= std_logic_vector(signed(zi) - signed(ci));
  	        elsif (en_i = '1') then
  	            xip1 <= std_logic_vector(unsigned(xi) + shift_left(unsigned(yi), SHIFT));
  	            yip1 <= std_logic_vector(unsigned(yi) - shift_left(unsigned(xi), SHIFT));
  	            error_iter <= std_logic_vector(signed(zi) + signed(ci));
  	        end if;
  	    end if;
  	        zip1 <= error_iter;
  	        dv_o <= error_iter(N-1);
  	end process;
    --dv_o <= en_i;
    --xip1 <= xi;
    --yip1 <= yi;
    --zip1 <= zi;

end architecture;
