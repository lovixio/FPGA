entity signal_to_morse is
    generic();
    port(        
        reset_in  : in std_logic;
        read_enable_in : in std_logic;
        type_in  : in std_logic;
        duration_in  : in std_logic_vector(22 downto 0);
        read_enable_in : in std_logic;
        short_limit_in : in std_logic_vector();
        long_limit_in : in std_logic_vector();
        morse_out : out std_logic_vector(1 downto 0); 
    );
end entity;

architecture signal_to_morse_architecture of signal_to_morse is
    
    signal morse : std_logic_vector(1 downto 0);
    signal silence_short_limit : natural := natural(short_limit_in * 3);
    signal silence_long_limit : natural := natural(long_limit_in * 7);

begin 

    process(read_enable_in)
    begin 
        if(read_enable_in = '1') then
            if (type_in = '1') then
                if (duration_in > short_limit_in and duration_in < long_limit_in) then

                    morse <= '10';

                elsif (duration_in > long_limit_in)
                
                    morse <= '11';
                
                end if;
            else
                if (duration_in > silence_short_limit and duration_in < silence_long_limit) then

                    morse <= '00';

                elsif (duration_in > silence_long_limit) then

                    morse <= '01';

                end if;
            end if;
        end if;
    end process;

    morse_out <= morse;


end architecture;