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

    constant standard_short_limit : std_logic_vector(32 downto 0) := std_logic_vector(to_unsigned(3, 32));

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
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    short_long_process: process
    begin
        enable_in <= '1';
        button_in <= '1';
        short_limit_in <= standard_short_limit;

        wait for 300 ms + 5 ns;

        button_in <= '0';
        wait for 300 ms + 5 ns;
        assert (type_out = '0' and duration_out = std_logic_vector(to_unsigned(3, 22))) report "no se está contando bien el silencio"
        assert (read_enable_out = '0') report "read_enable_out está levantado cuando no debería (contando silencio)"
        button_in <= '1';
        wait for 200 ms + 5 ns;
        button_in <= '0';
        wait for 6 ns;
        assert (type_out = '0' and duration_out = std_logic_vector(to_unsigned(5, 22))) report "no se está contando el silencio despues de descartar posible"
        assert (read_enable_out = '0') report "read_enable_out está levantado cuando no debería (luego de descartar posible short/long)"
        

        wait for 100 ms + 5 ns;
        button_in <= '1';
        wait for 300 ms + 2 ns;
        assert (type_out = '0' and duration_out = std_logic_vector(to_unsigned(6, 22))) report "no se está contando el silencio despues de confirmar short/long"
        assert (read_enable_out = '1') report "read_enable_out no está levantado cuando se reporta silencio"
        wait for 4 ns;
        assert (read_enable_out = '0') report "read_enable_out está levantado cuando no debería (despues de reportar silencio)"
        button_in <= '0';
        wait for 3 ns;
        assert (type_out = '1') report "debería mandar type = 1 al cambiar a silencio"
        assert (duration_out = std_logic_vector(to_unsigned(3, 22))) report "no está reportando bien la cantidad de decasenudos del short/long"
        assert (read_enable_out = '1') report "no está levantado el read al reportar un sort/long"
        wait for 3 ns;
        assert (read_enable_out = '0') report "está levantado el read al reportar un sort/long y que haya pasado tiempo como para que baje"
        assert (type_out = '0') report "noc cambió el type out luego de reportar el short/long"
        assert (duration_out = (others => '0')) report "no se reseteó el duration luego de reportar short/long"

        wait for 400 ms + 5 ns;
        button_in <= '1';
        wait for 300 ms;
        assert (duration_out = std_logic_vector(to_unsigned(4,22))) report "no está contando bien el silencio luego de confirmar short/long"
        wait for 6 ns;
        assert (duration_out = std_logic_vector(to_unsigned(3,22))) report "no está haciendo bien la transición de duración de silencio a short/long"
        assert (type_out = '1') report "no está haciendo bien la transición de type de silencio a short/long"
        button_in <= '0';
        wait for 3 ns;
        assert (duration_out = std_logic_vector(to_unsigned(3,22))) report "no conserva bien la duración al reportar short/long"
        assert (type_out = '1') report "no conserva bien el tipo al reportar short/long"
        assert (read_enable_out = '1') report "no está habilitando leer luego de cambiar de short/long a silencio"
        wait for 100 ms + 5 ns;
        assert (duration_out = std_logic_vector(to_unsigned(1,22))) report "no reseteó o contó bien el silencio luego de reportar short/long"
        assert (type_out = '0') report "no cambió bien el tipo a silencio luego de reportar short/long"
        assert (read_enable_out = '0') report "no desabilitó el read al vovler a silencio luego de short/long"
        
        wait for 100 ms + 5 ns;
        reset_in <= '1';
        wait for 5 ns;
        assert (read_enable_out = '0') report "no reseteó bien el read_enable luego de silencio"
        assert (type_out = '0') report "no reseteó bien el tipo luego de silencio"
        assert (duration_out = (others => '0')) report "no reseteó bien la duración luego de silencio"
        reset_in <= '0';
        wait for 300 ms;
        button_in <= '1';
        wait for 300 ms + 5 ns;
        reset_in <= '1';
        wait for 5 ns;
        assert (read_enable_out = '0') report "no reseteó bien el read_enable luego de short/long"
        assert (type_out = '0') report "no reseteó bien el tipo luego de short/long"
        assert (duration_out = (others => '0')) report "no reseteó bien la duración luego de short/long"

        reset_in <= '0';

        button_in <= '0';
        short_limit_in <= std_logic_vector(to_unsigned(5, 32));
        wait for 100 ms + 5 ns;
        button_in <= '1';
        wait for 300 ms + 5 ns;
        button_in <= '0';
        wait for 6 ns;
        assert (type_out = '0' and duration_out = std_logic_vector(to_unsigned(4, 22))) report "no se descartó bien el short/long que no llegó a short o  no se contó bien en el medio de especularlo"
        wait for 100 ms;
        button_in <= '1';
        wait for 500 ms + 6 ns;
        assert (type_out = '1' and duration_out = std_logic_vector(to_unsigned(5, 22))) report "no está contando bien el short/long cuando le ponemos otro limite"

    end process;

end testbench;