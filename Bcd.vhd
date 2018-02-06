---- Description: 
-- The Bcd design is used to connect the digits of minutes and hour (from slices of the vector count)
-- to a specific anode in the 7-seg display decoder.
--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Bcd is
    Port (     
    bcd: in STD_LOGIC_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0) --signal goes to 
    );
end Bcd;

architecture Behavioral of Bcd is

begin
    seg <=  "1000000" when (bcd = "0000") else
            "1111001" when (bcd = "0001") else
            "0100100" when (bcd = "0010") else
            "0110000" when (bcd = "0011") else
            "0011001" when (bcd = "0100") else
            "0010010" when (bcd = "0101") else
            "0000010" when (bcd = "0110") else
            "1111000" when (bcd = "0111") else
            "0000000" when (bcd = "1000") else
            "0011000" when (bcd = "1001") else 
            "1100010";
    
end Behavioral;
