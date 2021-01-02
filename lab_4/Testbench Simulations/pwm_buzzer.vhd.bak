library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pwm_buzzer is
   Generic ( width : integer := 9); 
   Port    ( reset_n    : in  STD_LOGIC;
             clk        : in  STD_LOGIC;
             --duty_cycle : in  STD_LOGIC_VECTOR (width-1 downto 0);
             enable     : in STD_LOGIC;
             pwm_out    : out STD_LOGIC
           );
end pwm_buzzer;

architecture Behavioral of pwm_buzzer is
   signal counter : unsigned (width-1 downto 0);
   signal duty_cycle : STD_LOGIC_VECTOR (width-1 downto 0);
begin
   count : process(clk,reset_n,enable)
   begin
       if( reset_n = '0') then
           counter <= (others => '0');
       elsif (rising_edge(clk) and enable='1') then 
           counter <= counter + 1;
       end if;
   end process;
 
   compare : process(counter, duty_cycle)
   begin  
       duty_cycle <= "100000000";
       if (counter < unsigned(duty_cycle)) then
           pwm_out <= '1';
       else 
           pwm_out <= '0';
       end if;
   end process;
  
end Behavioral;