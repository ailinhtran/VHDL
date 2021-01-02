-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 15.11.2020 04:36:21 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_MUX5TO1 is
end tb_MUX5TO1;

architecture tb of tb_MUX5TO1 is

    component MUX5TO1
        port (in1     : in std_logic_vector (15 downto 0);
              in2     : in std_logic_vector (15 downto 0);
              in3     : in std_logic_vector (15 downto 0);
              in4     : in std_logic_vector (15 downto 0);
              in5     : in std_logic_vector (27 downto 0);
              s8      : in std_logic;
              s9      : in std_logic;
              hold    : in std_logic;
              mux_out : out std_logic_vector (27 downto 0));
    end component;

    signal in1     : std_logic_vector (15 downto 0);
    signal in2     : std_logic_vector (15 downto 0);
    signal in3     : std_logic_vector (15 downto 0);
    signal in4     : std_logic_vector (15 downto 0);
    signal in5     : std_logic_vector (27 downto 0);
    signal s8      : std_logic;
    signal s9      : std_logic;
    signal hold    : std_logic;
    signal mux_out : std_logic_vector (27 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : MUX5TO1
    port map (in1     => in1,
              in2     => in2,
              in3     => in3,
              in4     => in4,
              in5     => in5,
              s8      => s8,
              s9      => s9,
              hold    => hold,
              mux_out => mux_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in1 <= (others => '0');
        in2 <= (others => '0');
        in3 <= (others => '0');
        in4 <= (others => '0');
        in5 <= (others => '0');
        s8 <= '0';
        s9 <= '0';
        hold <= '1';

        -- EDIT Add stimuli here
        wait for TbPeriod;
		  in1 <= "0000000000000000"; in2 <= "1111111111111111"; in3 <= "1000000000000000"; in4 <= "0111111111111111";
		  in5 <= "1010101010101010101010101010";
		  wait for TbPeriod; -- mux_out <= "110000000000" & in1; 2-out-of-6 7 segment displays blank, no decimal point, mode 1: hex
		  s8 <= '0'; s9 <= '1'; wait for TbPeriod; -- mux_out <= "110000000100" & in2; 2-out-of-6 7 segment displays blank, decimal point in 3rd display from the right, mode: distance
		  in2 <= "0000111111111111"; wait for TbPeriod; -- mux_out <= "111000000100" & in2; -- blank 3-out-of-6 7 segment displays blank, decimal point in 3rd display from the right, mode: distance
		  hold <= '0'; wait for TbPeriod; -- previous mux_out
		  s8 <= '1'; s9 <= '0'; wait for TbPeriod; --previous mux_out even if the switches changed
		  hold <= '1'; wait for TbPeriod; -- mux_out = "110000001000" & in3; 2-out-of-6 7 segment displays blank,decimal point in 4th display from the right, mode: voltage
		  s8 <= '1'; s9 <= '1'; wait for TbPeriod; --  mux_out <= "110000000000" & in4; -- acd hex (shows all 4 digits), no decimal point
		  in4 <= "0000111111111111"; wait for TbPeriod; --mux_out <= "111000000000" & in4; blank 3-out-of-6 7 segment displays, no decimal point, acd (hex)
		  in4 <= "0000000011111111"; wait for TbPeriod; --mux_out <= "111100000000" & in4;; blank 4-out-of-6 7 segment displays, no decimal point, acd (hex)
		  in4 <= "0000000000001111"; wait for TbPeriod; --mux_out <= "111110000000" & in4; blank 5-out-of-6 7 segment displays, no decimal point, acd (hex)
		  
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_MUX5TO1 of tb_MUX5TO1 is
    for tb
    end for;
end cfg_tb_MUX5TO1;
