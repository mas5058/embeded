--
-- YOUR HEADER GOES HERE
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY raminfr_be IS
  PORT (
    clk : IN std_logic;
    reset_n : IN std_logic;
    we_n : IN std_logic;
    be_n : IN std_logic_vector(3 DOWNTO 0);
    addr : IN std_logic_vector(11 DOWNTO 0);
    din : IN std_logic_vector(31 DOWNTO 0);
    dout : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY raminfr_be;

ARCHITECTURE rtl OF raminfr_be IS
  TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL RAM : ram_type;
  SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
BEGIN
  RamBlock : PROCESS(clk) BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (reset_n = '0') THEN
        read_addr <= (OTHERS => '0');
      ELSIF ((we_n = '0') AND (be_n = "0000")) THEN
        RAM(conv_integer(addr)) <= din;
      END IF;
      read_addr <= addr;
    END IF;
  END PROCESS RamBlock;
  dout <= RAM(conv_integer(read_addr));
END ARCHITECTURE rtl;