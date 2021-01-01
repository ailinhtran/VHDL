-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 22.10.2020 23:22:47 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_Reg8 is
end tb_Reg8;

architecture tb of tb_Reg8 is

    component Reg8
        port (LD          : in std_logic_vector (15 downto 0);
              Q           : out std_logic_vector (15 downto 0);
              CLK         : in std_logic;
              saved_value : in std_logic;
              reset_n     : in std_logic);
    end component;

    signal LD          : std_logic_vector (15 downto 0);
    signal Q           : std_logic_vector (15 downto 0);
    signal CLK         : std_logic;
    signal saved_value : std_logic;
    signal reset_n     : std_logic;

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here. CHANGED!
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Reg8
    port map (LD          => LD,
              Q           => Q,
              CLK         => CLK,
              saved_value => saved_value,
              reset_n     => reset_n);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        LD <= (others => '0');
        saved_value <= '1';

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
		  wait for 5 * TbPeriod;
		  LD <= "1111111111111111"; wait for 5 * TbPeriod; -- Q = all zeroes
		  saved_value <= '0'; wait for 5 * TbPeriod; -- Q = all ones
		  reset_n <= '0'; wait for 5 * TbPeriod; -- Q resets = all zeroes
		  reset_n <= '1'; wait for 5 * TbPeriod; -- 0 until rising edge -> previous LD
		  LD <= "1111111111111111"; wait for 5 * TbPeriod; -- previous LD since saved_value is still 0
		  saved_value <= '1'; wait for 5*TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Reg8 of tb_Reg8 is
    for tb
    end for;
end cfg_tb_Reg8;