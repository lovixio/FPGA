library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture testbench of tb_top is

    signal clk : std_logic := '0';     -- Señal de reloj
    signal btn : std_logic_vector(7 downto 0) := (others => '0');  -- Señal de botones
    signal led : std_logic_vector(5 downto 0);  -- Señal de LEDs

    component top is   -- Declara el DUT como un componente
        port(
            clk : in std_logic;
            btn : in std_logic_vector(7 downto 0);
            led : out std_logic_vector(5 downto 0)
        );
    end component;

begin
    UUT: top
        port map (
            clk => clk,
            btn => btn,
            led => led
            );  -- Conecta los puertos del DUT

    clk_process: process  -- Generador de reloj
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    reset_process: process  -- Proceso de reset
    begin
        btn(0) <= '1';
        wait for 20 ns + 1 ps;
        btn(0) <= '0';
        wait;
    end process;

    stimulus: process  -- Estímulo
    begin
        wait for 30 ns + 1ps;
        btn(1) <= '1';
        wait for 100 ns;
        btn(1) <= '0';
        wait for 10 ns;
        btn(1) <= '1';
        wait;
    end process;
end testbench;

