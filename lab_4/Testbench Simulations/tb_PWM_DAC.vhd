-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 26.11.2020 13:06:30 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_PWM_DAC is
end tb_PWM_DAC;

architecture tb of tb_PWM_DAC is

    component PWM_DAC
	 Generic ( width : integer);
        port (reset_n    : in std_logic;
              clk        : in std_logic;
              duty_cycle : in std_logic_vector (width-1 downto 0);
              pwm_out    : out STD_LOGIC_VECTOR (9 downto 0)
				  );
    end component;

    signal reset_n    : std_logic;
    signal clk        : std_logic;
    signal duty_cycle : std_logic_vector (8 downto 0); -- change width-1 to 8
    signal pwm_out    : STD_LOGIC_VECTOR (9 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PWM_DAC
	 generic map (width => 9) -- change this value if different from default
    port map (reset_n    => reset_n,
              clk        => clk,
              duty_cycle => duty_cycle,
              pwm_out    => pwm_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        duty_cycle <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for TbPeriod;
        reset_n <= '1';
        wait for TbPeriod;

        -- EDIT Add stimuli here
		  
        wait for TbPeriod;
		  duty_cycle <= "000000111"; wait for 10 * TbPeriod;
		  duty_cycle <= "000000001"; wait for 10 * TbPeriod;
		  reset_n <= '0'; wait for TbPeriod;
		  reset_n <= '1'; wait for TbPeriod;

--		  Uncomment stuff below if you want to test the part where there's overflow/carry-out
--	     duty_cycle <= "000000111"; wait for 10 * TbPeriod;
--		  wait for 515 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
		  
        TbSimEnded <= '1';
        wait;
    end process;

end tb;