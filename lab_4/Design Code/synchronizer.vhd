-- --- synchronizer 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
    Port ( 
           D        : in STD_LOGIC_VECTOR (9 downto 0);
           G    : out  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC; 
			  reset_n : in STD_LOGIC 
          );
end synchronizer;

architecture Behavioral of synchronizer is
signal E: STD_LOGIC_VECTOR (9 downto 0);

begin
   Process (clk, reset_n)
		begin  
		  if reset_n='0' then 
				G <= (others=>'0');
        elsif rising_edge(clk) then 
            E <= D;
            G <= E;
        end if;
	 end Process;
end Behavioral;