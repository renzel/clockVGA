----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2018 10:10:22
-- Design Name: 
-- Module Name: ClockNBtn - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockNBtn is
port(
        clk: in std_logic;
        btnC: in std_logic; -- reset
        btnR: in std_logic; --Increment/Decrement the minutes by a factor of 1 min
        btnU: in std_logic; -- Increment/Decrement the hour by a factor of 1hour
        btnD: in std_logic; --Increment/Decrement the minutes by a factor of 10 min
        o_sw: in std_logic_vector(0 downto 0); --increment sw='0' and decrement sw='1' values in 'set' function
        num: out  std_logic_vector (15 downto 0));
      
      
end ClockNBtn;

architecture Behavioral of ClockNBtn is

signal sec_clock : INTEGER range 0 to 100 := 0;
signal counter : INTEGER range 0 to 100000050 := 0; -- Basys3 has 100M cycles per second
signal counter_bin : unsigned (15 downto 0) := (others=> '0');

begin 

num <= std_logic_vector(counter_bin); 

counter_clock1: process(clk)
begin
    if rising_edge (clk) then
        counter <= counter + 1;            
        if btnC = '1' then --reset button, displays '0's
            counter <= 0;
            sec_clock <= 0;
            counter_bin <= (others=> '0');  
        elsif (counter >= 100000000) then -- counts every 1 second                        
            sec_clock <= sec_clock + 1;              
            if (sec_clock >= 59) then -- when the second counter reaches 59, it resets and sets minutes to +11
                 counter_bin <= counter_bin + "0000000000000001";
                 sec_clock <= 0;
            end if;
            if btnR = '1' then -- adds 1 min every second
                if (o_sw(0) = '0') then                   
                    counter_bin <= counter_bin + "1";                 
                else
                    if counter_bin(3 downto 0) = "0000" then -- if 0 - 1 = 9
                        counter_bin(3 downto 0) <= "1000";
                    else
                        counter_bin <= counter_bin - "1";
                    end if; 
                end if;
            end if;
            if btnD='1' then --adds 10 min every second
                if (o_sw(0) = '0') then
                    if counter_bin(7 downto 4) >= "0101" then -- if 0 - 1 = 9
                        counter_bin(11 downto 0) <= (counter_bin(11 downto 8) + "0001") & "00000000"; 
                    else
                        counter_bin(7 downto 4) <= counter_bin(7 downto 4) + "0001";
                    end if;
                else
                    if counter_bin(7 downto 4) = "0000" then -- if 0 - 1 = 9
                        counter_bin(7 downto 4) <= "0100";
                    else 
                        counter_bin(7 downto 4) <= counter_bin(7 downto 4) - "0001";
                    end if;                                       
                end if;
            end if; 
            if btnU='1' then --adds 1 hour every second
                if (o_sw(0) = '0') then  
                    counter_bin(11 downto 8) <= counter_bin(11 downto 8) + "0001";                
                else
                    if counter_bin(11 downto 8) = "0000" then -- if 0 - 1 = 8
                        counter_bin(11 downto 8) <= "1000";
                    else
                        counter_bin(11 downto 8) <= counter_bin(11 downto 8) - "0001";
                    end if;                    
                end if;
             end if;
             if (counter_bin(15 downto 0) >= "0010001100000000" )then -- checks if more than 24:00, resets
                  counter_bin <= "0000000000000000";       
             elsif (counter_bin(7 downto 0) >= "01100000") then -- checks if more than xx:59, resets
                  counter_bin(11 downto 0) <= (counter_bin(11 downto 8) + "0001") & "00000000";               
             elsif (counter_bin(3 downto 0) >= "1001") then -- checks if more than xx:x9, resets
                  counter_bin(7 downto 4) <= counter_bin(7 downto 4) + "0001";
                  counter_bin(3 downto 0) <= "0000";                     
             elsif (counter_bin(11 downto 8) >= "1001") then -- checks if more than x9:xx, resets
                  counter_bin(15 downto 12) <= counter_bin(15 downto 12) + "0001"; 
                  counter_bin(11 downto 8) <= "0000";           
             end if;                    
             counter <= 0;
        end if;          
    end if;
end process;    

end Behavioral;
