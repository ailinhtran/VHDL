library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.LUT_buzzer.all; --uses LUT package

entity buzzer_change is
--Generic (width : integer := 9);
port ( d_value: in  std_logic_vector(12 downto 0); --
       hold : in std_logic;
       hold_value : in natural; -- added in hold_value for reg
       period : out natural -- notice no semi-colon  --not sure if this will give us error
      );
end buzzer_change; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of buzzer_change is
      --signal temp1: integer;
      --signal temp2: integer;
      begin
            process(d_value,hold,hold_value) --sensitivity list
                  begin
                        if (hold = '0') then
                              period <= hold_value; --hold period (keeps frequency the same)
--								elsif (d_value >= "0111111111111")  then --add number here
--                              period <= 1000; --9 digits here
--                        elsif (d_value <= "0000110001010") then
--                              period <= 50; --9 digits here
                        else
                        --use formula to calculate duty value
                        --temp1 <= to_integer(unsigned(d_value)); --converts distance value to int
                        --period <= ((950*to_integer(unsigned(d_value)))/3701)+50-((950*394)/3701);
                        --period <= ((156666*temp1)/3701)+10000-((156666*394)/3701); --finds value of period with simple linear equation
                        period <= buzzer_lut(to_integer(unsigned(d_value)));

           end if;
           end process; 
      end BEHAVIOR; -- can also be written as "end;"