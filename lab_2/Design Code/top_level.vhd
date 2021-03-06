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
signal s8,s9          : std_logic ;
signal in1,in2,in3,in4,mux_out,switch_inputs2 : std_logic_vector(15 downto 0);
signal D: STD_LOGIC_VECTOR (9 downto 0);
signal G: STD_LOGIC_VECTOR (9 downto 0);
signal Q: STD_LOGIC_VECTOR (15 downto 0);
signal LD: STD_LOGIC_VECTOR (15 downto 0);
signal result: STD_LOGIC;
signal saved_value: STD_LOGIC;

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

Component MUX4TO1 is
   PORT ( in1     : IN  std_logic_vector(15 downto 0);
          in2     : IN  std_logic_vector(15 downto 0);
			 in3     : IN  std_logic_vector(15 downto 0);
          in4     : IN  std_logic_vector(15 downto 0);
          s8      : IN  std_logic;
			 s9      : IN  std_logic;
          mux_out : OUT std_logic_vector(15 downto 0) 
         );
END COMPONENT; 

Component synchronizer is
   PORT ( clk     : IN  STD_LOGIC;
          D       : IN STD_LOGIC_VECTOR (9 downto 0);
          G       : OUT  STD_LOGIC_VECTOR (9 downto 0)
         );
END COMPONENT;
			
Component debounce is
--GENERIC(
  --  clk_freq    : INTEGER := 50_000_000;  --system clock frequency in Hz
    --stable_time : INTEGER := 30);         --time button must remain stable in ms
	
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
      LD    		 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  
		Q     		 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  
		);           
END Component;

begin
   Num_Hex0 <= mux_out(3  downto  0); 
   Num_Hex1 <= mux_out(7  downto  4);
   Num_Hex2 <= mux_out(11 downto  8);
   Num_Hex3 <= mux_out(15 downto 12);
   Num_Hex4 <= "0000";
   Num_Hex5 <= "0000";   
   DP_in    <= "000000"; -- position of the decimal point in the display (1=LED on,0=LED off)
   Blank    <= "110000"; -- blank the 2 MSB 7-segment displays (1=7-seg display off, 0=7-seg display on)
             
                
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
                            DP_in    => DP_in,
									 Blank    => Blank
                          );
                                     
 
LEDR(9 downto 0) <=SW(9 downto 0); -- gives visual display of the switch inputs to the LEDs on board
switch_inputs <= "00000" & G(7 downto 0);
switch_inputs2 <="00000000" & G(7 downto 0);

binary_bcd_ins: binary_bcd                              
   PORT MAP(
      clk      => clk,                          
      reset_n  => reset_n,                                 
      binary   => switch_inputs,    
      bcd      => bcd         
      );

MUX4T01_ins: MUX4TO1 
	PORT MAP( 
		in1     => bcd(15 downto 0),
      in2     => switch_inputs2,
		in3	  => Q,
		in4	  => "0101101001011010",
      s8      => G(8),
		s9      => G(9),
      mux_out => mux_out
      );        		

synchronizer_ins: synchronizer 
   PORT MAP( 
      clk     => clk,
      D       => SW(9 downto 0),
      G       => G
      );		
		
debouncer_ins: debounce
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
		
end Behavioral;