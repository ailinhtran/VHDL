library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.LUT_ledr.all; --uses LUT package

entity duty_ledr is
Generic ( width : integer := 9);
port ( d_value     : in  std_logic_vector(12 downto 0);
       hold : in std_logic;
       hold_value : in std_logic_vector(8 downto 0); -- added in hold_value for reg
       duty_out : out std_logic_vector(width-1 downto 0) -- notice no semi-colon  
      );
end duty_ledr; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of duty_ledr is
      --signal temp1: integer;
      --signal temp2: integer;
      begin
           process(d_value, hold, hold_value) --sensitivity list
                  begin
                        if (hold = '0') then
                              duty_out <= hold_value; --hold duty cycle (keeps brightness the same)
--				elsif (d_value >= "0111111111111")  then --add number here
--                              duty_out <= "000000000"; --9 digits here
--                        elsif (d_value <= "0000110001010") then
--                              duty_out <= "111111111"; --9 digits here
                        else
                        --use formula to calculate duty value
                        --temp1 <= to_integer(unsigned(d_value)); --converts distance value to int
                        --temp2 <= ((-511*temp1)/3701)+((4095*511)/3701); --finds value of duty_out with simple linear equation
                        --duty_out <= std_logic_vector(to_unsigned(((-511*to_integer(unsigned(d_value)))/3701)+((4095*511)/3701), duty_out'length));
                        duty_out <= std_logic_vector(to_unsigned(ledr_LUT(to_integer(unsigned(d_value))),duty_out'length));
								
            end if;
            end process; 
      end BEHAVIOR; -- can also be written as "end;"