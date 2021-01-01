# VHDL

VHDL Projects (ENEL 453)

These are the projects I did in ENEL 453 using VHDL and a Intel DE10-Lite Board, but can be used with any other FPGA board. 

1. First lab is just basic VHDL project which changes switch display from BCD to Hex representation of numbers up to 0-255

2. Second lab utilizes a debouncer to use a pushbutton to save the switch value and can be displayed at any time. It can switch display from BCD, Hex, the saved value (either BCD or hex) or a hard-coded value of 5A5A (mainly for debugging purposes).

3. Third lab uses ADC to use a sensor to determine the voltage and distance from the sensor on the FPGA board. It also uses a push button to hold the value as the value fluctuates a lot on the actual board. 

4. Last lab uses a buzzer that makes a noise and increases in frequency the closer the object is to the distance sensor on the board. In addition, using PWM, the lights on the FPGA board get brighter the closer the object is to the distance sensor on the board. Finally, the light flash when the object is 20cm away from the board and increases flashing frequency when the object gets closer to the distance sensor. 

EDITOR NOTES:

*Note that all projects also have testbenches in order to simulate the design on modelsim as well. 

*Changed to 'git config core.safecrlf false' in order to add files on github
