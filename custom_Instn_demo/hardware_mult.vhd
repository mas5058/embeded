--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2012, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Prof Christman
--
--       LAB NAME:  Custom Instruction / Hardware Acceleration demo
--
--      FILE NAME:  custom_instruction_demo.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    This is a module that performs a multiply of two 8 bit numbers
--    using the shift-and-add method.  The result is 16 bits.
--
--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mult IS
  PORT (
    Nios_custom_instruction_slave_Clk    : IN  std_logic;
    Nios_custom_instruction_slave_clk_en : IN  std_logic;  --must be 1 for the state machine to advance
    Nios_custom_instruction_slave_Reset  : IN  std_logic;
    Nios_custom_instruction_slave_DATAA  : IN  std_logic_vector(31 DOWNTO 0);  --32 bits for avalon interface
    Nios_custom_instruction_slave_DATAB  : IN  std_logic_vector(31 DOWNTO 0);
    Nios_custom_instruction_slave_start  : IN  std_logic;             -- when 1, start the multiply
    Nios_custom_instruction_slave_done   : OUT std_logic;  --hold to 1 for 1 clock cycle to indicate mult. is done
    Nios_custom_instruction_slave_RESULT : OUT std_logic_vector(31 DOWNTO 0)  -- 32 bits for avalon interface
    );
END ENTITY mult;

ARCHITECTURE BEHAVIORAL OF mult IS

  --Internal wires
  SIGNAL  Clk    : std_logic;
  SIGNAL  clk_en : std_logic;  
  SIGNAL  Reset  : std_logic;
  
  --sum1- sum8 are the intermediate sums
  SIGNAL sum1        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum2        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum3        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum4        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum5        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum6        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum7        : std_logic_vector(15 DOWNTO 0);
  SIGNAL sum8        : std_logic_vector(15 DOWNTO 0);
  SIGNAL product_reg : std_logic_vector(15 DOWNTO 0);  --sum of all intermediate sums
  SIGNAL A, B        : std_logic_vector(7 DOWNTO 0);


  -- Type state_t
  TYPE state_t IS (IDLE, STEP1, STEP2);
  --step1 is the state where I calculate all the intermediate sum
  --step2 is the state where I calculate the product doing the sum of all
  --  the intermediate sum.

  SIGNAL current_state : state_t;
  SIGNAL next_state    : state_t;

BEGIN
  clk <=Nios_custom_instruction_slave_clk;
  clk_en <= Nios_custom_instruction_slave_clk_en;
  reset <= Nios_custom_instruction_slave_reset;  --note the reset is active high
  
  A <= Nios_custom_instruction_slave_dataa(7 DOWNTO 0);  --only want the lower byte of the input data
  B <= Nios_custom_instruction_slave_datab(7 DOWNTO 0);

  --Process to go to the next state
  sync : PROCESS(Clk, reset, clk_en)
  BEGIN
    IF reset = '1' THEN
      current_state <= IDLE;
    ELSIF(Clk'event AND Clk = '1') THEN
      IF(clk_en = '1') THEN
        current_state <= next_state;
      END IF;
    END IF;
  END PROCESS sync;

  --Process to determine next state
  determine_next_state : PROCESS(current_state, nios_custom_instruction_slave_start)
  BEGIN
    CASE(current_state) IS
      WHEN IDLE =>
        IF (Nios_custom_instruction_slave_start = '1') THEN
          next_state <= STEP1;
        ELSE
          next_state <= IDLE;
        END IF;

      WHEN STEP1 =>
        next_state <= STEP2;

      WHEN STEP2 =>
        next_state <= IDLE;
      WHEN OTHERS =>
        next_state <= IDLE;
    END CASE;
  END PROCESS determine_next_state;

  --Process to update the output product
  output_product : PROCESS(current_state, A, B, sum1, sum2, sum3, sum4,
                           sum5, sum6, sum7, sum8)
  BEGIN
    CASE(current_state) IS
      WHEN STEP2 =>
        product_reg <= (sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7 + sum8);
      WHEN OTHERS =>
        product_reg <= (OTHERS => '1');
      END CASE;
  END PROCESS output_product;

  --Process to control the done signal
  output_done : PROCESS(current_state)
  BEGIN
    CASE(current_state) IS
      WHEN STEP2 =>
        Nios_custom_instruction_slave_done <= '1';
      WHEN OTHERS =>
        Nios_custom_instruction_slave_done <= '0';
    END CASE;
  END PROCESS output_done;

  --Process to update the intermediate sum
  output_sum : PROCESS(current_state, A, B)
  BEGIN
    CASE(current_state) IS
      WHEN STEP1 | STEP2 =>
        --sum1
        IF (B(0) = '0') THEN
          sum1 <= (OTHERS => '0');
        ELSE                                --(B(1) = '1') then
          sum1 <= "00000000" & A;
        END IF;
        --sum2
        IF (B(1) = '0') THEN
          sum2 <= (OTHERS => '0');
        ELSE                                --(B(1) = '1') then
          sum2 <= "0000000" & A& '0';
        END IF;
        --sum3
        IF (B(2) = '0') THEN
          sum3 <= (OTHERS => '0');
        ELSE                                --(B(2) = '1') then
          sum3 <= "000000" & A& "00";
        END IF;
        --sum4
        IF (B(3) = '0') THEN
          sum4 <= (OTHERS => '0');
        ELSE                                --(B(3) = '1') then
          sum4 <= "00000" & A & "000";
        END IF;
        --sum5
        IF (B(4) = '0') THEN
          sum5 <= (OTHERS => '0');
        ELSE                                --(B(4) = '1') then
          sum5 <= "0000" & A & "0000";
        END IF;
        --sum6
        IF (B(5) = '0') THEN
          sum6 <= (OTHERS => '0');
        ELSE                                --(B(5) = '1') then
          sum6 <= "000" & A& "00000";
        END IF;
        --sum7
        IF (B(6) = '0') THEN
          sum7 <= (OTHERS => '0');
        ELSE                                --(B(6) = '1') then
          sum7 <= "00" & A& "000000";
        END IF;
        --sum8
        IF (B(7) = '0') THEN
          sum8 <= (OTHERS => '0');
        ELSE                                --(B(7) = '1') then
          sum8 <= '0' & A& "0000000";
        END IF;

      WHEN OTHERS =>
        sum1 <= (OTHERS => '0');
        sum2 <= (OTHERS => '0');
        sum3 <= (OTHERS => '0');
        sum4 <= (OTHERS => '0');
        sum5 <= (OTHERS => '0');
        sum6 <= (OTHERS => '0');
        sum7 <= (OTHERS => '0');
        sum8 <= (OTHERS => '0');
    END CASE;
  END PROCESS output_sum;

  Nios_custom_instruction_slave_result <= "0000000000000000" & product_reg;  --result needs to be 32 bits also

  END ARCHITECTURE behavioral;
