library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.funciones.all;

entity top is
port(
    clk : in std_logic;
    btn : in std_logic_vector(7 downto 0);
    led : out std_logic_vector(5 downto 0)
    );
end top;

architecture structural of top is

    constant M : natural := 10;
    
    signal max_count : std_logic;
    signal rst_n : std_logic;

begin

rst_n <= not btn(0);

U0_COUNTER: entity work.mod_m_counter_prog
  generic map(
    M => M-- Modulo
    )
  port map(
    clk_i        => clk,
    reset_i      => rst_n,
    run_i        => btn(1),
    max_count_i  => (others => '1'),
    count_o      => open,
    max_o        => max_count
    );

U1_TOGGLE: entity work.ToggleMachine
  port map(
    clk    => clk,
    rst    => rst_n,
    en     => '1',
    sin    => max_count,
    toggle => led(0)
    );
    
end structural;
