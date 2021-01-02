library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity top_level is
    Port ( clk                           : in  STD_LOGIC;
           reset_n, button               : in  STD_LOGIC;
			  SW                            : in  STD_LOGIC_VECTOR (9 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  buzzer                        : out std_logic
			 );
           
end top_level;

architecture Behavioral of top_level is

Signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
--Signal , Blank:  STD_LOGIC_VECTOR (5 downto 0);
Signal bcd:           STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal bcd2:           STD_LOGIC_VECTOR(15 DOWNTO 0);
signal s8,s9,hold    : std_logic;
signal switch_inputs2 : std_logic_vector(15 downto 0); --deleted in1,in2,in3,in4
signal D: STD_LOGIC_VECTOR (9 downto 0);
signal G: STD_LOGIC_VECTOR (9 downto 0);
signal Q: STD_LOGIC_VECTOR (27 downto 0);
signal LD,in5,mux_out: STD_LOGIC_VECTOR (27 downto 0);
--signal result: STD_LOGIC; --debounce not used in Simulation
signal saved_value: STD_LOGIC;
signal ADC_out: STD_LOGIC_VECTOR(11 downto 0);
signal ADC_raw: STD_LOGIC_VECTOR(11 downto 0);
signal voltage: STD_LOGIC_VECTOR(12 downto 0);
signal distance: STD_LOGIC_VECTOR(12 downto 0);
signal mux_out_blank: std_logic_vector(11 downto 0);
signal second_val: STD_LOGIC_VECTOR (15 downto 0);
signal duty_cycle : STD_LOGIC_VECTOR (8 downto 0); --change width-1
signal pwm_out    : STD_LOGIC_VECTOR (9 downto 0);
signal d_value  : std_logic_vector(12 downto 0);
signal duty_out : std_logic_vector(8 downto 0); --change width-1
-- downcounter
signal zero : std_logic;
-- buzzer_change
signal period_buzzer : natural;
-- pwm_buzzer
signal pwm_out_buzzer : std_logic; 
--downcounter for flashing
signal zero_flashing : std_logic;
--PWM_flash
signal pwm_out_flash : std_logic_vector(27 downto 0);
--flashing_change
signal period_flash : natural;
-- reg_ledr
signal hold_ledr : std_logic_vector(8 downto 0);
-- reg_down
signal hold_flash: natural;
signal hold_freq: natural;

constant time_delay       : time := 20 ns;

component reg_ledr is
	port (LD: in std_logic_vector(8 downto 0);
			Q: out std_logic_vector(8 downto 0);
			CLK, saved_value, reset_n: in std_logic
			);
end component;

component reg_down is
	port (LD: in natural;
			Q: out natural;
			CLK, saved_value, reset_n: in std_logic
			);
end component;

component flashing_change is
   port ( d_value: in  std_logic_vector(12 downto 0); 
          hold : in std_logic;
          hold_value : in natural;
          period : out natural
         );
   end component; 

component PWM_flash is
   Generic ( width : integer);
   Port    ( reset_n    : in  STD_LOGIC;
             clk        : in  STD_LOGIC;
             pwm_out    : out STD_LOGIC_VECTOR(27 downto 0);
             mux_input  : in std_logic_vector(27 downto 0);
             enable     : in STD_LOGIC
           );
end component;

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

Component synchronizer is
   PORT ( clk     : IN  STD_LOGIC;
          D       : IN STD_LOGIC_VECTOR (9 downto 0);
          G       : OUT  STD_LOGIC_VECTOR (9 downto 0);
			 reset_n : IN STD_LOGIC
         );
END COMPONENT;

--remove debounce component for faster simulation
--Component debounce is
--   GENERIC(
--      clk_freq    : INTEGER;  --system clock frequency in Hz
--      stable_time : INTEGER); --time button must remain stable in ms
--	PORT(
--		clk		: IN STD_LOGIC; --input clock
--		reset_n	: IN STD_LOGIC; --asynchronous active low rest
--		button	: IN STD_LOGIC; --input signal to be decounced
--		result	: OUT STD_LOGIC --debounced signal
--		);
--END COMPONENT;

Component Reg8 IS
   PORT(
      clk     		 : IN  STD_LOGIC; --system clock
      reset_n 		 : IN  STD_LOGIC; --active low asynchronus reset_n
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

component PWM_DAC is
   Generic ( width : integer); 
   Port    ( reset_n    : in  STD_LOGIC;
             clk        : in  STD_LOGIC;
             duty_cycle : in  STD_LOGIC_VECTOR (width-1 downto 0);
             pwm_out    : out STD_LOGIC_VECTOR (9 downto 0)
           );
end component;

component duty_ledr is
   Generic ( width : integer); 
   port ( d_value: in  std_logic_vector(12 downto 0); 
          hold : in std_logic;
          hold_value : in std_logic_vector(8 downto 0);
          duty_out : out std_logic_vector(width-1 downto 0)  
         );
   end component; 

component downcounter is
      PORT    ( clk     : in  STD_LOGIC; 
                reset_n : in  STD_LOGIC; 
					 period  : in natural;
                enable  : in  STD_LOGIC; 
                zero    : out STD_LOGIC  
           );
  end component;

  component buzzer_change is
   port ( d_value: in  std_logic_vector(12 downto 0);
          hold : in std_logic;
          hold_value : in natural;
          period : out natural 
         );
   end component;

   component pwm_buzzer is
      Generic ( width : integer := 3); --changed to 3 for simulation (In RTL: 9)
      Port    ( reset_n    : in  STD_LOGIC;
                clk        : in  STD_LOGIC;
                enable     : in STD_LOGIC;
                pwm_out    : out STD_LOGIC
              );
   end component;

begin
   
   Num_Hex0 <= pwm_out_flash(3  downto  0); 
   Num_Hex1 <= pwm_out_flash(7  downto  4);
   Num_Hex2 <= pwm_out_flash(11 downto  8);
   Num_Hex3 <= pwm_out_flash(15 downto 12);
   Num_Hex4 <= "0000";
   Num_Hex5 <= "0000";   
             
                
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
                            DP_in    => pwm_out_flash(21 downto 16),
									 Blank    => pwm_out_flash(27 downto 22)
                          );
                                     
LEDR <= pwm_out;
buzzer <= pwm_out_buzzer;
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
		hold    => button, --result, (CHANGE DEPENDING IF SIMULATION OR RTL)
      mux_out => mux_out
      );	

synchronizer_ins: synchronizer 
   PORT MAP( 
      clk     => clk,
      D       => SW(9 downto 0),
      G       => G,
		reset_n => reset_n
      );		
		
--debouncer_ins: debounce
--   GENERIC MAP(
--      clk_freq => 50_000_000,
--      stable_time => 10
--   )
--	PORT MAP(
--		clk		=> clk,
--		reset_n  => reset_n,
--		button   => button,
--		result   => result
--		);	
		
reg8_ins: reg8
	PORT MAP(
		clk				=> clk,
		reset_n 			=> reset_n,
		saved_value    => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
		Q					=> Q,
		LD					=> mux_out
      );	
      
regduty_ins: reg_ledr
   PORT MAP(
      clk				=> clk,
      reset_n 			=> reset_n,
      saved_value    => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
      Q					=> hold_ledr,
      LD					=> duty_out
      );	

regflash_ins: reg_down
   PORT MAP(
      clk				=> clk,
      reset_n 			=> reset_n,
      saved_value    => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
      Q					=> hold_flash,
      LD					=> period_flash
      );	

regfreq_ins: reg_down
   PORT MAP(
      clk				=> clk,
      reset_n 			=> reset_n,
      saved_value    => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
      Q					=> hold_freq,
      LD					=> period_buzzer
      );	

PWM_DAC_ins: PWM_DAC
   GENERIC MAP ( width => 9)
   PORT MAP( reset_n  => reset_n,
             clk      => clk,
             duty_cycle =>  duty_out,
             pwm_out    => pwm_out
            );

duty_ledr_ins: duty_ledr
   GENERIC MAP ( width => 9) 
   PORT MAP ( d_value => distance,
            hold => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
            hold_value => hold_ledr,
          duty_out => duty_out 
         );

ADC_Data_ins: ADC_Data
    port map (clk              => clk,
              reset_n          => reset_n,
              voltage          => voltage,
              distance         => distance,
              ADC_raw          => ADC_raw,
              ADC_out          => ADC_out
				  );		
 
downcounter_ins: downcounter
   PORT MAP    ( clk   => clk, 
               reset_n => reset_n,
               enable  => '1', 
					period  => period_buzzer,
               zero    => zero  
               );

buzzer_change_ins: buzzer_change
   port map( d_value => distance,
            hold => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
            hold_value => hold_freq,
         period => period_buzzer 
         );

pwm_buzzer_ins: pwm_buzzer
      Generic map ( width => 3) --9 for RTL
      Port map ( reset_n => reset_n,
                clk     => clk,
                enable => zero,
                pwm_out => pwm_out_buzzer
              );

flashing_change_ins: flashing_change
   PORT MAP ( d_value => distance,
              hold => button, --result for RTL, (CHANGE DEPENDING IF SIMULATION OR RTL)
              hold_value => hold_flash,
              period => period_flash
         );

PWM_flash_ins: PWM_flash
   Generic map ( width => 3) --9 for RTL
   Port map (reset_n  => reset_n,
            clk      => clk,
            enable   => zero_flashing,
            pwm_out  => pwm_out_flash,
            mux_input => mux_out
            );

downcounter_ins_2: downcounter
   PORT MAP ( clk   => clk, 
            reset_n => reset_n, 
            enable  => '1', 
            period  => period_flash,
            zero    => zero_flashing  
            );

end Behavioral;