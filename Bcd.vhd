---- Description: 
-- This design is used to 
--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Bcd is
    Port (     
    bcd0: in STD_LOGIC_vector(3 downto 0);
    seg0 : out std_logic_vector(6 downto 0)
    );
end Bcd;

architecture Behavioral of Bcd is

begin
    seg0 <= "1000000" when (bcd0 = "0000") else
            "1111001" when (bcd0 = "0001") else
            "0100100" when (bcd0 = "0010") else
            "0110000" when (bcd0 = "0011") else
            "0011001" when (bcd0 = "0100") else
            "0010010" when (bcd0 = "0101") else
            "0000010" when (bcd0 = "0110") else
            "1111000" when (bcd0 = "0111") else
            "0000000" when (bcd0 = "1000") else
            "0011000" when (bcd0 = "1001") else 
            "1100010";
    
end Behavioral;
