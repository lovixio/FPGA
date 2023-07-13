library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signal_to_morse_tb is
end signal_to_morse_tb;

architecture testbench of signal_to_morse_tb is

    signal clk : std_logic := '0';     -- Señal de reloj
    signal reset  :  std_logic := '0';
    signal read_enable :  std_logic := '0';    
    signal signal_type  :  std_logic := '0';   -- 0 si es un silencio, 1 si es un bip
    signal signal_duration  :  std_logic_vector(22 downto 0) := (others => '0'); 
    signal short_limit : std_logic_vector(5 downto 0) := (others => '0');
    signal long_limit : std_logic_vector(5 downto 0) := (others => '0');
    signal morse_char : std_logic_vector(1 downto 0) := (others => '0'); -- el bit mas significativo indica el tipo, el otro indica si es corto o largo
    signal morse_ready : std_logic := '0';

    component signal_to_morse is
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
    end component;

begin
    UUT: signal_to_morse
        port map (
            clock_in => clk,
            reset_in  => reset,
            read_enable_in => read_enable,
            type_in => signal_type,
            duration_in => signal_duration,
            short_limit_in => short_limit,
            long_limit_in =>  long_limit,
            morse_out =>  morse_char,
            morse_ready_out => morse_ready
            );

    clk_process: process  -- Generador de reloj
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    reset_process: process  -- Proceso de reset
    begin
        reset <= '1';
        wait for 20 ns + 1 ps;
        reset <= '0';
        wait;
    end process;

    stimulus: process  -- Estímulo
    begin
        reset <= '0';
        signal_type <= '0';
        signal_duration <= std_logic_vector(to_unsigned(15, 22));
        short_limit <= std_logic_vector(to_unsigned(5, 5));
        long_limit <= std_logic_vector(to_unsigned(15, 5));
        read_enable <= '1';
        wait for 10 ns;
        
        reset <= '1';
        wait for 10 ns;

        reset <= '0';
        signal_type <= '0';
        signal_duration <= std_logic_vector(to_unsigned(35, 22));
        short_limit <= std_logic_vector(to_unsigned(5, 5));
        long_limit <= std_logic_vector(to_unsigned(15, 5));
        read_enable <= '1';
        wait for 10 ns;
        
        reset <= '1';
        wait for 10 ns;
        
        reset <= '0';
        signal_type <= '1';
        signal_duration <= std_logic_vector(to_unsigned(5, 22));
        short_limit <= std_logic_vector(to_unsigned(5, 5));
        long_limit <= std_logic_vector(to_unsigned(15, 5));
        read_enable <= '1';
        wait for 10 ns;
        
        reset <= '1';
        wait for 10 ns;
        
        reset <= '0';
        signal_type <= '1';
        signal_duration <= std_logic_vector(to_unsigned(15, 22));
        short_limit <= std_logic_vector(to_unsigned(5, 5));
        long_limit <= std_logic_vector(to_unsigned(15, 5));
        read_enable <= '1';
        wait for 10 ns;

        reset <= '1';
        wait;

    end process;
end testbench;
