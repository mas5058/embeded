--based off of https://en.wikibooks.org/wiki/VHDL_for_FPGA_Design/4-Bit_adder changed from 4 to 32 bit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity adder is
   port
   (
      nibble1, nibble2 : in signed(35 downto 0); 
      sum       : out signed(35 downto 0) 
      --carry_out : out std_logic
   );
end entity adder;
 
architecture Behavioral of adder is
   signal temp : signed(36 downto 0); 
begin 
   temp <= ("0" & nibble1) + ("0" & nibble2); 
   -- OR use the following syntax:
   -- temp <= ('0' & nibble1) + ('0' & nibble2);

   sum       <= temp(35 downto 0); 
   --carry_out <= temp(36);
end architecture Behavioral;