library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.LUT_flash.all; --uses LUT package


entity flashing_change is
--Generic (width : integer := 9);
port ( d_value: in  std_logic_vector(12 downto 0); --
       hold : in std_logic;
       hold_value : in natural; -- added in hold_value for reg
       period : out natural -- notice no semi-colon  --not sure if this will give us error
      );
end flashing_change; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of flashing_change is
      --signal temp1: integer;
      --signal temp2: integer;
      begin
            process(d_value,hold,hold_value) --sensitivity list
                  begin
                        if (hold = '0') then
                              period <= hold_value; --hold duty cycle (keeps flashing the same)
--								elsif (d_value > "0011111010000")  then --add number here
--                              period <= 1; --makes downcounter always output 1 for pwm_flash
--                        elsif (d_value <= "0000110001010") then
--                              period <= 12500; 
                        else
                        --use formula to calculate duty value
                        --temp1 <= to_integer(unsigned(d_value)); --converts distance value to int
                        --period <= ((37500*to_integer(unsigned(d_value)))/1606)+12500-((37500*394)/1606); --finds value of period with simple linear equation
                        period <= flash_lut(to_integer(unsigned(d_value)));
            end if;
            end process; 
      end BEHAVIOR; -- can also be written as "end;"