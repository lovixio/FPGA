library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_reader_tb is
end button_reader_tb;

architecture testbench of button_reader_tb is
    signal clock                :  std_logic := '0';
    signal reset                :  std_logic := '0';
    signal enable               :  std_logic := '1';
    signal button               :  std_logic := '0';
    signal short_limit          :  std_logic_vector(5 downto 0) := (others => '0');
    signal signal_duration      :  std_logic_vector(22 downto 0) := (others => '0');
    signal signal_type          :  std_logic := '0';
    signal read_enable          :  std_logic := '0';
    signal count_o              :  std_logic_vector(3 downto 0) := (others => '0');


    constant standard_short_limit : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(3, 6));

    component button_reader is
        port(
            clock_in        : in std_logic;
            reset_in        : in std_logic;
            enable_in       : in std_logic;
            button_in       : in std_logic;
            short_limit_in  : in std_logic_vector(5 downto 0);
            duration_out    : out std_logic_vector(22 downto 0);
            type_out        : out std_logic;
            read_enable_out : out std_logic;
            count_o         : out std_logic_vector(3 downto 0)
        );
    end component;


begin
    BR : button_reader
    port map(
        clock_in        => clock,
        reset_in        => reset,
        enable_in       => enable,
        button_in       => button,
        short_limit_in  => short_limit,
        duration_out    => signal_duration,
        type_out        => signal_type,
        read_enable_out => read_enable,
        count_o         => count_o
    );

    clock_process: process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;
    
    --acordarse de cambiar cuanto cuenta el mod_m_counter en button_reader para poder capturar todo esto
    short_long_process: process
    begin
        enable <= '1';
        button <= '1';
        short_limit <= standard_short_limit;

        wait for 3*50 ns + 5 ns;

        button <= '0';
        wait for 3*50 ns + 5 ns;
        assert (signal_type = '0' and unsigned(signal_duration) = 3) report "no se está contando bien el silencio";
        assert (read_enable = '0') report "read_enable está levantado cuando no debería (contando silencio)";
        button <= '1';
        wait for 2*50 ns + 5 ns;
        button <= '0';
        wait for 6 ns;
        assert (signal_type = '0' and unsigned(signal_duration) = 5) report "no se está contando el silencio despues de descartar posible";
        assert (read_enable = '0') report "read_enable está levantado cuando no debería (luego de descartar posible short/long)";
        

        wait for 1*50 ns + 5 ns;
        button <= '1';
        wait for 3*50 ns + 2 ns;
        assert (signal_type = '0' and unsigned(signal_duration) = 6) report "no se está contando el silencio despues de confirmar short/long";
        assert (read_enable = '1') report "read_enable no está levantado cuando se reporta silencio";
        wait for 4 ns;
        assert (read_enable = '0') report "read_enable está levantado cuando no debería (despues de reportar silencio)";
        button <= '0';
        wait for 3 ns;
        assert (signal_type = '1') report "debería mandar signal_type = 1 al cambiar a silencio";
        assert (unsigned(signal_duration) = 3) report "no está reportando bien la cantidad de decasenudos del short/long";
        assert (read_enable = '1') report "no está levantado el read al reportar un sort/long";
        wait for 3 ns;
        assert (read_enable = '0') report "está levantado el read al reportar un sort/long y que haya pasado tiempo como para que baje";
        assert (signal_type = '0') report "no cambió el signal_type out luego de reportar el short/long";
        assert (unsigned(signal_duration) = 0) report "no se reseteó el signal_duration luego de reportar short/long";

        wait for 4*50 ns + 5 ns;
        button <= '1';
        wait for 3*50 ns;
        assert (unsigned(signal_duration) = 4) report "no está contando bien el silencio luego de confirmar short/long";
        wait for 6 ns;
        assert (unsigned(signal_duration) = 3) report "no está haciendo bien la transición de duración de silencio a short/long";
        assert (signal_type = '1') report "no está haciendo bien la transición de signal_type de silencio a short/long";
        button <= '0';
        wait for 3 ns;
        assert (unsigned(signal_duration) = 3) report "no conserva bien la duración al reportar short/long";
        assert (signal_type = '1') report "no conserva bien el tipo al reportar short/long";
        assert (read_enable = '1') report "no está habilitando leer luego de cambiar de short/long a silencio";
        wait for 1*50 ns + 5 ns;
        assert (unsigned(signal_duration) = 1) report "no reseteó o contó bien el silencio luego de reportar short/long";
        assert (signal_type = '0') report "no cambió bien el tipo a silencio luego de reportar short/long";
        assert (read_enable = '0') report "no desabilitó el read al vovler a silencio luego de short/long";
        
        wait for 1*50 ns + 5 ns;
        reset <= '1';
        wait for 5 ns;
        assert (read_enable = '0') report "no reseteó bien el read_enable luego de silencio";
        assert (signal_type = '0') report "no reseteó bien el tipo luego de silencio";
        assert (unsigned(signal_duration) = 0) report "no reseteó bien la duración luego de silencio";
        reset <= '0';
        wait for 3*50 ns;
        button <= '1';
        wait for 3*50 ns + 5 ns;
        reset <= '1';
        wait for 5 ns;
        assert (read_enable = '0') report "no reseteó bien el read_enable luego de short/long";
        assert (signal_type = '0') report "no reseteó bien el tipo luego de short/long";
        assert (unsigned(signal_duration) = 0) report "no reseteó bien la duración luego de short/long";

        reset <= '0';

        button <= '0';
        short_limit <= std_logic_vector(to_unsigned(5, 6));
        wait for 1*50 ns + 5 ns;
        button <= '1';
        wait for 3*50 ns + 5 ns;
        button <= '0';
        wait for 6 ns;
        assert (signal_type = '0' and unsigned(signal_duration) = 4) report "no se descartó bien el short/long que no llegó a short o  no se contó bien en el medio de especularlo";
        wait for 1*50 ns;
        button <= '1';
        wait for 5*50 ns + 6 ns;
        assert (signal_type = '1' and unsigned(signal_duration) = 5) report "no está contando bien el short/long cuando le ponemos otro limite";

    end process;

end testbench;