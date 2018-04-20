--4/16/18 taken from https://allaboutfpga.com/vhdl-code-flipflop-d-t-jk-sr/#D_FlipFlop and added enable

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity flipflop is
port ( d      			: in signed (35 downto 0);
      clk,en, reset : in std_logic;
  	q 	  	      : out signed(35 downto 0)
);
end flipflop;

architecture arch of flipflop is
begin
	process(clk,en,reset)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				q <= (others => '0');
			elsif (en = '1') then
				q <= d;
			end if;
		end if;
	end process;
end arch;