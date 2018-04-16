
library ieee;
use ieee.std_logic_1164.all;

entity hexDisplayDriver is
  port (
    i_hex             : in  std_logic_vector(3 downto 0); 
    clk             : in  std_logic; 
    reset           : in  std_logic;
    o_sevenSeg            : out std_logic_vector(6 downto 0)
  );
end hexDisplayDriver;

architecture beh of hexDisplayDriver is
constant zero : 
            std_logic_vector(6 downto 0):= "1000000";
    constant one : 
            std_logic_vector(6 downto 0):= "1111001";
    constant two : 
            std_logic_vector(6 downto 0):= "0100100";
    constant three : 
            std_logic_vector(6 downto 0):= "0110000";
    constant four : 
            std_logic_vector(6 downto 0):= "0011001";
    constant five : 
            std_logic_vector(6 downto 0):= "0010010";
    constant six : 
            std_logic_vector(6 downto 0):= "0000010";
    constant seven : 
            std_logic_vector(6 downto 0):= "1111000";
    constant eight : 
            std_logic_vector(6 downto 0):= "0000000";
    constant nine : 
            std_logic_vector(6 downto 0):= "0011000";
    constant a : 
            std_logic_vector(6 downto 0):= "0001000";
    constant b : 
            std_logic_vector(6 downto 0):= "0000011";
    constant c : 
            std_logic_vector(6 downto 0):= "1000110";
    constant d : 
            std_logic_vector(6 downto 0):= "0100001";
    constant e : 
            std_logic_vector(6 downto 0):= "0000110";
    constant f : 
            std_logic_vector(6 downto 0):= "0001110";
    begin
proc:process(clk, reset, i_hex)
begin
    if (reset = '0') then
        o_sevenSeg <= zero;
    elsif (rising_edge(clk)) then
        case(i_hex(3 downto 0)) is
            when "0000" => o_sevenSeg <= zero;
            when "0001" => o_sevenSeg <= one;
            when "0010" => o_sevenSeg <= two;
            when "0011" => o_sevenSeg <= three;
            when "0100" => o_sevenSeg <= four;
            when "0101" => o_sevenSeg <= five;
            when "0110" => o_sevenSeg <= six;
            when "0111" => o_sevenSeg <= seven;
            when "1000" => o_sevenSeg <= eight;
            when "1001" => o_sevenSeg <= nine;
            when "1010" => o_sevenSeg <= a;
            when "1011" => o_sevenSeg <= b;
            when "1100" => o_sevenSeg <= c;
            when "1101" => o_sevenSeg <= d;
            when "1110" => o_sevenSeg <= e;
            when others => o_sevenSeg <= f;
        end case;
      end if;
      end process;
end beh;