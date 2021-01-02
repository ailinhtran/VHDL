library ieee;
use ieee.std_logic_1164.all;

entity Reg8 is
	port (LD: in std_logic_vector(27 downto 0);
			Q: out std_logic_vector(27 downto 0);
			CLK, saved_value, reset_n: in std_logic
			);
end Reg8;

architecture BEHAV of Reg8 is
	begin 
		process(CLK, reset_n)
		 begin
			if reset_n='0' then 
				Q <= "1100000000000000000000000000"; --
			elsif rising_edge(CLK) then
				if saved_value='1' then
					Q <= LD;
				end if;
			end if;
		end process;
end BEHAV;