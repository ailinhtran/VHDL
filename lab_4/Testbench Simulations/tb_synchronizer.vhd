-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 7.12.2020 03:57:52 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_synchronizer is
end tb_synchronizer;

architecture tb of tb_synchronizer is

    component synchronizer
        port (D       : in std_logic_vector (9 downto 0);
              G       : out std_logic_vector (9 downto 0);
              clk     : in std_logic;
              reset_n : in std_logic);
    end component;

    signal D       : std_logic_vector (9 downto 0);
    signal G       : std_logic_vector (9 downto 0);
    signal clk     : std_logic;
    signal reset_n : std_logic;

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : synchronizer
    port map (D       => D,
              G       => G,
              clk     => clk,
              reset_n => reset_n);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        D <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
		  D <= "0000011111"; wait for 100 * TbPeriod;
		  D <= "1000000000"; wait for 100 * TbPeriod;
		  D <= "0111111111"; wait for 100 * TbPeriod;
		  D <= "1110001110"; wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_synchronizer of tb_synchronizer is
    for tb
    end for;
end cfg_tb_synchronizer;