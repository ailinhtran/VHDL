-- --- synchronizer 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
    Port ( 
           D        : in STD_LOGIC_VECTOR (9 downto 0);
           G    : out  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC 
          );
end synchronizer;

architecture Behavioral of synchronizer is
signal E: STD_LOGIC_VECTOR (9 downto 0);

begin
   Process (clk)
		begin  
        if rising_edge(clk) then 
            E <= D;
            G <= E;
        end if;
	 end Process;
end Behavioral;