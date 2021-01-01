library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4TO1 is
port ( in1     : in  std_logic_vector(15 downto 0); --bcd
       in2     : in  std_logic_vector(15 downto 0); -- hex
       in3     : in  std_logic_vector(15 downto 0); --output of register
       in4     : in  std_logic_vector(15 downto 0); --5A5A 
       s8      : in  std_logic; --switch 8
       s9      : in  std_logic; -- switch 9
       mux_out : out std_logic_vector(15 downto 0) -- notice no semi-colon 
      );
end MUX4TO1; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of MUX4TO1 is
      begin
            process(s8,s9,in1,in2,in3,in4) --sensitivity list
                  begin
                        if (s8='0') and (s9='0') then
                              mux_out <= in1;
                        elsif (s8='0') and (s9='1') then
                              mux_out <= in2;
                        elsif (s8='1') and (s9='0') then
                              mux_out <= in3;
                        else
                              mux_out <= in4;
                        end if;
            end process; 
      end BEHAVIOR; -- can also be written as "end;"