--4/16/18 taken from https://allaboutfpga.com/vhdl-code-flipflop-d-t-jk-sr/#D_FlipFlop and added enable

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity flipflop is
port ( d, clk, en : in std_logic;
	   q 		  : out std_logic
);
end flipflop;

architecture arch of flipflop is
begin
process(clk,en)
begin
if(rising_edge(clk) and clk = '1' and en = '1') then{
	q <= d;
	}
end if;
end process;
end arch;