library ieee;
use ieee.std_logic_1164.all;

entity reg_ledr is
	port (LD: in std_logic_vector(8 downto 0);
			Q: out std_logic_vector(8 downto 0);
			CLK, saved_value, reset_n: in std_logic
			);
end reg_ledr;

architecture BEHAV of reg_ledr is
	begin 
		process(CLK, reset_n)
		 begin
			if reset_n='0' then 
				Q <= (others=>'0'); -- makes it 0 
			elsif rising_edge(CLK) then
				if saved_value='1' then
					Q <= LD; --always takes in output of duty_ledr
				end if;
			end if;
		end process;
end BEHAV;