library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity audiofilter_tb is
end entity audiofilter_tb;

ARCHITECTURE test OF audiofilter_tb IS

component audiofilter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		audioSample : in signed(35 downto 0);
		dataReq : in std_logic;
		audioSampleFiltered : out signed(35 downto 0)
	);
end component;

	signal clk_tb 				  : std_logic;
	signal reset_tb 			  : std_logic;
	signal dataReq_tb			  : std_logic;
	signal audioSample_tb 		  : signed(35 downto 0);
	signal audioSampleFiltered_tb : signed(35 downto 0);
	
	
	
	