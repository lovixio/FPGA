library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity button_reader is
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
end entity;

architecture button_reader_architecture of button_reader is
    
    -- N = 5 000 000 para real
    --constant N: natural := 5000000;
    --constant max_count : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(5000000-1, 23));
    constant max_duration : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(600, 23));


    -- N = 10 para test
    constant N: natural := 10;
    constant max_count : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(10-1, 4));
    --signal count_o : std_logic_vector(3 downto 0);


    signal one_decasecond_passed : std_logic := '0';
    signal current_type         : std_logic := '0'; 
    signal current_duration     : unsigned(22 downto 0) := (others => '0');
    signal next_duration        : unsigned(22 downto 0) := to_unsigned(1,23);
    signal possible_type        : std_logic := '0';
    signal possible_duration    : unsigned(22 downto 0) := (others => '0');
    signal read_enable          : std_logic := '0';
    
    
    begin
        CLOCK_COUNTER:  entity work.mod_m_counter_prog
        generic map (M => N)
        port map (  clk_i       => clock_in,
        reset_i     => reset_in,
        run_i       => enable_in,
        max_count_i => max_count,
        count_o     => count_o,
        max_o       => one_decasecond_passed
        );
        
        --proceso para ver que tipo de señal es y contarlo.

        --proceso que maneja los cambios de los registros luego de mandar a leer un codigo.
        -- si estamos escribiendo y acabamos de mandar a leer una señal:
        -- si la señal nueva es un silencio, reseteamos en 0 todo
        -- si las señal nueva es un short/long, ponemos lo especulado en current y reseteamos possibles.
        process(clock_in)
        begin
            if (rising_edge(clock_in)) then
                if(enable_in = '1' and read_enable = '1') then
                    if(possible_type = '0') then
                        current_duration <= (others => '0');
                        current_type <= '0';
                    else
                        current_duration <= possible_duration;
                        current_type <= '1';
                        possible_type <= '0';
                        possible_duration <= (others => '0');
                    end if; 
                    read_enable <= '0'; 
                end if;
            end if;
        end process;

        -- proceso para contar cada decasegundo de señales.
        -- si hay que resetear, reseteamos todo.
        -- si pasó un decasegundo y estamos escribiendo:
        --      si estamos especulando un posible short/long, añadimos al contador posible.
        --      si ese contador llegó al short, dejamos que se lea el silencio anterior y decrementamos el current con el short.
        --      movemos el contador current.
        process(one_decasecond_passed, reset_in)
        begin
            if(reset_in = '1') then
                current_duration <= (others => '0');                    
                current_type <= '0';
                read_enable <= '0';
                possible_type <= '0';
                possible_duration <= (others => '0');
            end if;

            if(one_decasecond_passed = '1' and enable_in = '1') then

                if(possible_type = '1') then

                    possible_duration <= possible_duration + 1;

                    if(possible_duration > unsigned(short_limit_in)) then
                        read_enable <= '1';
                        current_duration <= current_duration - possible_duration;          
                    end if;

                end if;       

                current_duration <= next_duration;

            end if;
        end process;
        
        --proceso para controlar la señal que nos llega del botón:
        --  si estamos escribiendo:
        --      si la señal nueva es un short/long:
        --          lo ponemos como posible y empezamos a contarlo.
        --      si no: ponemos posible en 0 y mandamos read_enable para leer el short/long que veniamos viendo si había.
        process(button_in)
        begin
            if(enable_in = '1') then
                if(button_in = '1') then
                    possible_type <= '1';
                else
                    possible_duration <= (others => '0');
                    possible_type <= '0';
                    if(current_type = '1') then
                        read_enable <= '1';
                    end if;
                end if;
            end if;
        end process;
                        
        -- si current está en su maximo, dejamos next estatico. si no, le sumamos 1.                            
        next_duration <= current_duration when current_duration = unsigned(max_duration) else (current_duration + 1);
        
        --ponemos el out los current y el read_enable.
        duration_out <= std_logic_vector(current_duration);
        type_out <= current_type;
        read_enable_out <= read_enable;
                
end architecture;