library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity top_level is
    Port ( clk                           : in  STD_LOGIC;
           reset_n, button               : in  STD_LOGIC;
			  SW                            : in  STD_LOGIC_VECTOR (9 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
			  
			 );
           
end top_level;

architecture Behavioral of top_level is

Signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in, Blank:  STD_LOGIC_VECTOR (5 downto 0);
Signal switch_inputs: STD_LOGIC_VECTOR (12 downto 0);
Signal bcd:           STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal bcd2:           STD_LOGIC_VECTOR(15 DOWNTO 0);
signal s8,s9,hold       : std_logic ;
signal in1,in2,in3,in4,mux_in,switch_inputs2 : std_logic_vector(15 downto 0); --delete muxdp vars
signal D: STD_LOGIC_VECTOR (9 downto 0);
signal G: STD_LOGIC_VECTOR (9 downto 0);
signal Q: STD_LOGIC_VECTOR (27 downto 0);
signal LD,in5,mux_out: STD_LOGIC_VECTOR (27 downto 0);
signal result: STD_LOGIC;
signal saved_value: STD_LOGIC;
signal ADC_out: STD_LOGIC_VECTOR(11 downto 0);
signal ADC_raw: STD_LOGIC_VECTOR(11 downto 0);
signal voltage: STD_LOGIC_VECTOR(12 downto 0);
signal distance: STD_LOGIC_VECTOR(12 downto 0);
signal mux_out_blank: std_logic_vector(11 downto 0);
signal second_val: STD_LOGIC_VECTOR (15 downto 0);

constant time_delay       : time := 20 ns;

Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in,Blank                                           : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset_n : IN  STD_LOGIC;                      --active low asynchronus reset_n
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component MUX5TO1 is
   PORT ( in1     : IN  std_logic_vector(15 downto 0);
          in2     : IN  std_logic_vector(15 downto 0);
			 in3     : IN  std_logic_vector(15 downto 0);
          in4     : IN  std_logic_vector(15 downto 0);
			 in5     : IN  std_logic_vector(27 downto 0);
          s8      : IN  std_logic;
			 s9      : IN  std_logic;
			 hold    : IN  std_logic;
          mux_out : OUT std_logic_vector(27 downto 0) 
         );
END COMPONENT; 

Component MUXDP is
	PORT ( s8      : in  std_logic; --switch 8
          s9      : in  std_logic; -- switch 9
          mux_out : out std_logic_vector(11 downto 0); -- notice no semi-colon 
			 mux_in  : in  std_logic_vector(15 downto 0)
        );
END COMPONENT;

Component synchronizer is
   PORT ( clk     : IN  STD_LOGIC;
          D       : IN STD_LOGIC_VECTOR (9 downto 0);
          G       : OUT  STD_LOGIC_VECTOR (9 downto 0);
			 reset_n : IN STD_LOGIC
         );
END COMPONENT;
			
Component debounce is
   GENERIC(
      clk_freq    : INTEGER;  --system clock frequency in Hz
      stable_time : INTEGER);         --time button must remain stable in ms
	PORT(
		clk		: IN STD_LOGIC; --input clock
		reset_n	: IN STD_LOGIC; --asynchronous active low rest
		button	: IN STD_LOGIC; --input signal to be decounced
		result	: OUT STD_LOGIC --debounced signal
		);
END COMPONENT;

Component Reg8 IS
   PORT(
      clk     		 : IN  STD_LOGIC;                      --system clock
      reset_n 		 : IN  STD_LOGIC;                      --active low asynchronus reset_n
      saved_value  : IN  STD_LOGIC;  
      LD    		 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);  
		Q     		 : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  
		);   		
END Component;

component ADC_Data
        port (clk              : in std_logic;
              reset_n          : in std_logic;
              voltage          : out std_logic_vector (12 downto 0);
              distance         : out std_logic_vector (12 downto 0);
              ADC_raw          : out std_logic_vector (11 downto 0);
              ADC_out          : out std_logic_vector (11 downto 0)
				  );
end component;

begin
   Num_Hex0 <= mux_out(3  downto  0); 
   Num_Hex1 <= mux_out(7  downto  4);
   Num_Hex2 <= mux_out(11 downto  8);
   Num_Hex3 <= mux_out(15 downto 12);
   Num_Hex4 <= "0000";
   Num_Hex5 <= "0000";   
   --DP_in    <= "000000"; -- position of the decimal point in the display (1=LED on,0=LED off)
   --Blank    <= "110000"; -- blank the 2 MSB 7-segment displays (1=7-seg display off, 0=7-seg display on)
             
                
SevenSegment_ins: SevenSegment  

                  PORT MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in    => mux_out(21 downto 16),
									 Blank    => mux_out(27 downto 22)
                          );
                                     
 
LEDR(9 downto 0) <=SW(9 downto 0); -- gives visual display of the switch inputs to the LEDs on board
switch_inputs <= "00000" & G(7 downto 0);
switch_inputs2 <="00000000" & G(7 downto 0);
second_val <= "0000" & ADC_out;

binary_bcd_ins: binary_bcd                              
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => voltage,    
      bcd      => bcd         
      );

binary_bcd_2_ins: binary_bcd                              
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => distance,    
      bcd      => bcd2         
      );

MUX5TO1_ins: MUX5TO1 
	PORT MAP( 
		in1     => switch_inputs2,
      in2     => bcd2,
		in3	  => bcd,
		in4	  => second_val,
		in5     => Q, 
      s8      => G(8),
		s9      => G(9),
		hold    => result,
      mux_out => mux_out
      );

--MUXDP_ins: MUXDP
--	PORT MAP (
--		s8      => G(8),
--      s9      => G(9),
--      mux_out => mux_out_blank,
--		mux_in  => mux_out
--      );		

synchronizer_ins: synchronizer 
   PORT MAP( 
      clk     => clk,
      D       => SW(9 downto 0),
      G       => G,
		reset_n => reset_n
      );		
		
debouncer_ins: debounce
   GENERIC MAP(
      clk_freq => 50_000_000,
      stable_time => 10
   )
	PORT MAP(
		clk		=> clk,
		reset_n  => reset_n,
		button   => button,
		result   => result
		);	
		
reg8_ins: reg8
	PORT MAP(
		clk				=> clk,
		reset_n 			=> reset_n,
		saved_value    => result,
		Q					=> Q,
		LD					=> mux_out
		);	

ADC_Data_ins: ADC_Data
    port map (clk              => clk,
              reset_n          => reset_n,
              voltage          => voltage,
              distance         => distance,
              ADC_raw          => ADC_raw,
              ADC_out          => ADC_out
				  );		
		
end Behavioral;