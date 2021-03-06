library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM_flash is
   Generic ( width : integer := 9);
   Port    ( reset_n    : in  STD_LOGIC;
             clk        : in  STD_LOGIC;
             --duty_cycle : in  STD_LOGIC_VECTOR (width-1 downto 0);
             pwm_out    : out STD_LOGIC_VECTOR(27 downto 0);
             mux_input     : in std_logic_vector(27 downto 0);
             enable     : in STD_LOGIC
           );
end PWM_flash;

architecture Behavioral of PWM_flash is
   signal counter : unsigned (width-1 downto 0);
   signal duty_cycle : unsigned(width-1 downto 0);
       
begin
   count : process(clk,reset_n,enable)
   begin
       if( reset_n = '0') then
           counter <= (others => '0');
       elsif (rising_edge(clk) and enable = '1') then 
           counter <= counter + 1;
       end if;
   end process;
 
   compare : process(counter, duty_cycle,mux_input)
   begin    
   duty_cycle <= "100000000";
       if (counter < unsigned(duty_cycle)) then
           pwm_out <= mux_input;
       else 
           pwm_out <= "1111110000000000000000000000";
       end if;
   end process;
  
end Behavioral;