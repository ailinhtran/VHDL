library ieee;
use ieee.std_logic_1164.all;

entity reg_down is
	port (LD: in natural;
			Q: out natural;
			CLK, saved_value, reset_n: in std_logic
			);
end reg_down;

architecture BEHAV of reg_down is
	begin 
		process(CLK, reset_n)
		 begin
			if reset_n='0' then 
				Q <= 1; -- makes period go to 1 so clk operates at natural 50MHz
			elsif rising_edge(CLK) then
				if saved_value='1' then
					Q <= LD; --always takes in output of comparators
				end if;
			end if;
		end process;
end BEHAV;