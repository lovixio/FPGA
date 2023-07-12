library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package funciones is

-- Declaraciones
  
  function ceil2power (N               :    natural) return natural;
  function getStdLogicVectorZeroes(int : in integer) return std_logic_vector;
  function to_slv(sl                   : in std_logic) return std_logic_vector;
  function to_sl(slv                   : in std_logic_vector) return std_logic;
  function increment(value             : in std_logic_vector) return std_logic_vector;
  function increment(value             : in natural) return std_logic_vector;
  function decrement(value             : in std_logic_vector) return std_logic_vector;
  function decrement(value             : in natural) return std_logic_vector;
  
end funciones;


package body funciones is

------------------------------------------------------------------------------

  function ceil2power(N : natural) return natural is

    variable m, p : natural;
  begin
    m := 0;
    p := 1;

    while p <= N loop
      m := m + 1;
      p := p * 2;
    end loop;

    return m;
    
  end ceil2power;

--------------------------------------------------------------------------------

  function getStdLogicVectorZeroes(int : in integer) return std_logic_vector is
    variable result : std_logic_vector(int -1 downto 0);
  begin
    for index in result'range loop
      result(index) := '0';
    end loop;
    return result;
  end getStdLogicVectorZeroes;

---------------------------------------------------------------------------------  

  function to_slv(sl : in std_logic) return std_logic_vector is
    
    variable result : std_logic_vector(0 downto 0);
  begin
    result(0) := sl;
    return result;
  end to_slv;

---------------------------------------------------------------------------------

  function to_sl(slv : in std_logic_vector) return std_logic is
    
    variable result : std_logic;
  begin
    result := slv(0);
    return result;
  end to_sl;

---------------------------------------------------------------------------------

  function increment(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) + to_unsigned(1, value'length));
    return result;
  end increment;

---------------------------------------------------------------------------------

  function decrement(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) - to_unsigned(1, value'length));
    return result;
  end decrement;

---------------------------------------------------------------------------------       


  function increment(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value + 1, result'length));
    return result;
  end increment;

  ---------------------------------------------------------------------------------

  function decrement(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value - 1, result'length));
    return result;
  end decrement;

---------------------------------------------------------------------------------       
end funciones;
