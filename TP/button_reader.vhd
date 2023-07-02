library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.digit_counter_pkg.all;

entity button_reader is
    generic();
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
end entity;

architecture button_reader_architecture of button_reader is
    constant max_count <=  std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(5000000-1, 23));
    signal one_decasecond_passed : std_logic;
    signal count_o : std_logic_vector(22 downto 0);

    signal current_type : std_logic; 
    signal current_duration : std_logic_vector(22 downto 0);
    signal next_duration : std_logic_vector(22 downto 0);
    signal possible_type :std_logic;
    signal possible_duration : std_logic_vector(22 downto 0);
    signal read_enable : std_logic;
    
    
    begin
        CLOCK_COUNTER:  entity work.mod_m_counter_prog
        generic map (5000000 => M)
        port map (  clk_i       => clock_in,
        reset_i     => reset_in,
        run_i       => enable_in,
        max_count_i => max_count,
        count_o     => count_o,
        max_o       => one_decasecond_passed
        );
        
        --proceso para ver que tipo de señal es y contarlo.
        process(one_decasecond_passed, reset_in)
        begin
            if(reset_in = '1') then
                current_duration <= (others => '0');                    
                current_type <= '0';
            end if;
            if(one_decasecond_passed = '1' and enable_in = '1') then

                if(read_enable = '1' and possible_type = '0') then
                    next_duration <= (others => '0') + 1;
                    current_type <= '0';
                    read_enalbe <= '0';
                end if;

                if(possible_type = '1') then
                    if(possible_duration < short_limit_in) then
                        possible_duration <= possible_duration +1;
                    elsif(read_enable = '0') then
                        possible_duration <= possible_duration +1;
                        read_enable <= '1';
                    else
                        next_duration <= possible_duration;
                        current_type <= '1';
                        possible_type <= '0';
                        read_enable <= '0';            
                    end if;
                end if;       
                current_duration <= next_duration;
            end if;
        end process;
        
        --TODO: solo confirmar el cambio del type cuando tenemos 1 short-limit de señal. 
        -- Necesitamos un contador paralelo para esto. No paramos el contador principal
        -- si llegamos al sortlimit, hacemos el cambio, restamos del principal un short-limit y enviamos el silencio.
        -- sino, reseteamos el contador paralelo y seguimos contando silencio.
        process(button_in)
        begin
            if(enable_in = '1') then
                if(button_in = '1') then
                    possible_type <= '1';
                    possible_duration <= (others => '0');
                else
                    if(read_enable = '1') then
                        current_duration <= possible_duration;
                        current_type <= possible_type
                    else
                        read_enable <= '1';
                    end if;
                    possible_type <= '0';
                end if;
            end if;
        end process;
                        
                                
    next_duration <= current_duration when current_duration = unsigned(max_count) else 
    current_duration + 1;
    
    duration_out <= current_duration;
    type_out <= current_type;
    read_enable_out <= read_enable;
                
end architecture;