library ieee;
use ieee.std_logic_1164.all;

entity button_reader_tests is
end button_reader_tests;

architecture testbench of button_reader_tests is
    signal clock_in        : in std_logic := '0';
    signal reset_in        : in std_logic := '0';
    signal enable_in       : in std_logic := '1';
    signal button_in       : in std_logic := '0';
    signal short_limit_in  : in std_logic_vector(32 downto 0) := (others => '0');
    signal duration_out    : out std_logic_vector(22 downto 0);
    signal type_out        : out std_logic;
    signal read_enable_out : out std_logic;

    component button_reader is
        port(
            clock_in        : in std_logic;
            reset_in        : in std_logic;
            enable_in       : in std_logic;
            button_in       : in std_logic;
            short_limit_in  : in std_logic_vector(32 downto 0);
            duration_out    : out std_logic_vector(22 downto 0);
            type_out        : out std_logic;
            read_enable_out : out std_logic;
        );
    end component;
end architecture;

begin
    BR : button_reader
        port map(
            clock_in        => clock_in;
            reset_in        => reset_in;
            enable_in       => enable_in;
            button_in       => button_in;
            short_limit_in  => short_limit_in;
            duration_out    => duration_out;
            type_out        => type_out;
            read_enable_out => read_enable_out;
        );

    clock_process: process
        begin
    end process;

end testbench;