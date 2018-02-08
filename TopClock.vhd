----------------------------------------------------------------------------------
-- Company: HSN Høgskolen i Sørøst Norge
-- Engineers: Flavia Souza Santos
--            Thomas Årstadvold 
--            Trond Østby Rensel
--            Zain Imtiaz Qureshi

-- Create Date: 01/30/2018 10:48:01 AM
-- Design Name: Digital Clock 
-- Module Name: TopClock - Behavioral
-- Project Name: Assignemnt 2
-- Target Devices: Basys3
-- Tool Versions: 
-- Description: The project was developed in VHDL using the FPGA Basys 3 architecture. 
--              The time is displayed in the 4 7-segment displays with a 24h format.
--              BTNC : to reset
--              
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
--          0.02 - Added Test benches
--          0.03 - Added Debouncing Circuit
--               - Separated 'ClockNBtn' from TopClock

-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopClock is
 Port ( 
         clk: in std_logic;
          btnC: in std_logic; -- reset
          btnR: in std_logic; --Increment/Decrement the minutes by a factor of 1 min
          btnU: in std_logic; -- Increment/Decrement the hour by a factor of 1hour
          btnD: in std_logic; --Increment/Decrement the minutes by a factor of 10 min
          btnL: in std_logic; -- Increment/Decrement the hour by a factor of 6hours
          sw: in std_logic_vector(0 downto 0); --increment sw='0' and decrement sw='1' values in 'set' function
          an : out std_logic_vector(3 downto 0); -- four-digit common anode( _ _:_ _)
          seg : out std_logic_vector(6 downto 0) -- Each of the four digits is composed of seven segments arranged
                                                 -- in a "figure 8" pattern, with an LED embedded in each segment.
  );
end TopClock;

architecture Behavioral of TopClock is

signal num: std_logic_vector (15 downto 0):=(others=> '0');-- store temporally values of minutes and hours
signal seg0, seg1, seg2, seg3 : std_logic_vector (6 downto 0):=(others=> '0');
signal reset : STD_LOGIC;
signal o_btnC, o_btnR, o_btnU, o_btnL, o_btnD: std_logic := '0'; --outputs for the debouncing circuits
signal o_sw: std_logic_vector (0 downto 0):= (others => '0'); -- output for the debouncing circuit

component Bcd
port (   
        bcd : in STD_LOGIC_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
);
end component;

component Display7seg 
    Port ( clk : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg_tall0 : in std_logic_vector (6 downto 0);
           seg_tall1 : in std_logic_vector (6 downto 0);
           seg_tall2 : in std_logic_vector (6 downto 0);
           seg_tall3 : in std_logic_vector (6 downto 0)
           );
end component;

component ClockNBtn
port(
       clk: in std_logic;      
       btnC: in std_logic; -- reset
       btnR: in std_logic; 
       btnU: in std_logic; 
       btnD: in std_logic; 
       o_sw: in std_logic_vector(0 downto 0); 
       num: out  std_logic_vector (15 downto 0)            
     );
end component;

COMPONENT debounce
PORT(
    clk    : IN  STD_LOGIC;  --input clock
    input  : IN  STD_LOGIC;  --input signal to be debounced
    output  : OUT STD_LOGIC --debounced signal       
);
END COMPONENT;

begin


--Converts the bcd number to fit the 7segment display, the signal is inverted, ex 0110 (6) => 0000010 in the display
Bcd_to_7seg0 : Bcd port map(
    bcd => num(3 downto 0),
    seg => seg0
);

Bcd_to_7seg1 : Bcd port map(
    bcd => num(7 downto 4),
    seg => seg1
);

Bcd_to_7seg2 : Bcd port map(
    bcd => num(11 downto 8),
    seg => seg2
);

Bcd_to_7seg3 : Bcd port map(
    bcd => num(15 downto 12),
    seg => seg3
);

-- Gets a number for each of the displays and puts in on the 7segment display, each segment is lit 1/4 of the time
-- The segments changes every 0.001 of a second, which makes it seem on all the time
display_babys : Display7seg port map(
    clk => clk, 
    an => an,
    seg => seg,  
    seg_tall0 => seg0,           
    seg_tall1 => seg1,
    seg_tall2 => seg2,
    seg_tall3 => seg3
);
clkclock: ClockNBtn port map(
    clk => clk,
    btnC => o_btnC, --reset
    btnU => o_btnU,
    btnR => o_btnR,
    btnD => o_btnD,
    o_sw(0) => o_sw(0),
    num => num   
);
--Debouncing slide switch and push-buttons:
--connect outputs
        
db_btnC: debounce PORT MAP( 
    clk => clk,     --input clock
    input => btnC,   --input signal to be debounced
    output => o_btnC --debounced signal
);

db_btnR: debounce PORT MAP(
    clk => clk,     
    input => btnR,   
    output => o_btnR  
);
db_btnU: debounce PORT MAP(
    clk => clk,     
    input => btnU,   
    output => o_btnU  
);
db_btnD: debounce PORT MAP(
    clk => clk,     
    input => btnD,
    output => o_btnD  
);
db_btnL: debounce PORT MAP(
    clk => clk,     
    input => btnL,   
    output => o_btnL  
);
db_sw: debounce PORT MAP(
    clk => clk,     
    input => sw(0),   
    output =>  o_sw(0)
);

end Behavioral;