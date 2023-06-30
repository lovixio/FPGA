library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEE.math_real.all;
use work.digit_counter_pkg.all;

entity tester is
    port();
end tester;

architecture tester_architecture of tester is

    
    --Inputs
    signal clk_i : std_logic := '1';
    signal reset_i: std_logic := '1';
    signal run_i : std_logic := '0';
    
    --Outputs
    signal count_o : stdlv_array_type(2 downto 0);
    --signal max_o : std_logic;
    
    -- Clock period definitions
    constant clk_period : time := 2/100 us;
    
    begin
    -- Clock process definitions
    clk_process : process
    begin
    clk_i <= '0';
    wait for clk_period/2;
    clk_i <= '1';
    wait for clk_period/2;
    end process;
    --reset_i <= '1', '0' after 5 us;
    run_i <= '1';--, '1' after 20 us, '0' after 30 us;
    
    -- Instantiate the Unit Under Test (UUT)
    uut : stopwatch
    port map (  clock_i => clk_i,
                clear_i => reset_i,
                enable_i => run_i,
                digits_o => count_o
                );


end architecture
