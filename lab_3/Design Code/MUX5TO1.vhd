library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5TO1 is
port ( in1     : in  std_logic_vector(15 downto 0); --
       in2     : in  std_logic_vector(15 downto 0); -- 
       in3     : in  std_logic_vector(15 downto 0); --
       in4     : in  std_logic_vector(15 downto 0); -- 
       in5     : in  std_logic_vector(27 downto 0); --output of register
	 s8      : in  std_logic; --switch 8
       s9      : in  std_logic; -- switch 9
	 hold    : in  std_logic; 
       mux_out : out std_logic_vector(27 downto 0) -- notice no semi-colon  
      );
end MUX5TO1; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of MUX5TO1 is
      begin
            process(s8,s9,hold,in1,in2,in3,in4,in5) --sensitivity list
                  begin
			      if (hold='0')  then
					mux_out <= in5;
                        elsif (s8='0') and (s9='0')	then
                              mux_out <= "110000000000" & in1;
                        elsif (s8='0') and (s9='1')	then
                              if in2(15 downto 12) = "0000" then
						mux_out <= "111000000100" & in2;
					else 	
						mux_out <= "110000000100" & in2;
					end if;	
                        elsif (s8='1') and (s9='0')	then 
                              mux_out <= "110000001000" & in3;
                        else
                              if (in4(15 downto 12) = "0000") and (in4(11 downto 8) = "0000") and (in4(7 downto 4) = "0000") then
                                    mux_out <= "111110000000" & in4; --blanking fourth digit
                                    
                              elsif (in4(15 downto 12) = "0000") and (in4(11 downto 8) = "0000") then
                                    mux_out <= "111100000000" & in4; --blanking fourth and third digit
                                    
                              elsif in4(15 downto 12) = "0000" then
                                    mux_out <= "111000000000" & in4; --blanking fourth, third and second digit

                              else
                                    mux_out <= "110000000000" & in4; -- acd hex (shows all 4 digits)
                                    
                              end if;
                            
                        end if;
            end process; 
      end BEHAVIOR; -- can also be written as "end;"