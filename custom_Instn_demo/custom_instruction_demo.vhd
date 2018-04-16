--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2018, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Jeanne Christman
--
--       LAB NAME:  Custom Instruction / Hardware Acceleration nios_system
--
--      FILE NAME:  custom_instruction_nios_system.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This VHDL is implements a Nios II system that can be used for the 
--    custom instruction nios_system in ESD I. The entity contains connections 
--    to DE1-SoC board to access the switches, pushbuttons, red LEDs and the 
--    SDRAM (which is used for program storage). The architecture is 
--    simply an instantiation of the nios_system hardware designed in
--    QSYS System Builder for this nios_systemstration.
--
--
--  REVISION HISTORY
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 10/31/12 | BAL  | 1.0 | Updated from Prof. Christman's nios_system
-- | 03/17/18 | JWC  | 2.0 | Updated from Bruce Link's nios_system 
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.NUMERIC_STD.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY custom_instruction_demo IS
  PORT(
    CLOCK_50   : IN    std_logic;
    KEY        : IN    std_logic_vector(3 DOWNTO 0);
    --
    -- Switch signals
    SW         : IN    std_logic_vector(9 DOWNTO 0);
    --
    -- Red LED signals
    LEDR       : OUT   std_logic_vector(9 DOWNTO 0);
    --
	 HEX0       : OUT   std_logic_vector(6 DOWNTO 0);
    -- DRAM Signals
    DRAM_DQ    : INOUT std_logic_vector(15 DOWNTO 0);
    DRAM_CLK   : OUT   std_logic;
    DRAM_CKE   : OUT   std_logic;
    DRAM_ADDR  : OUT   std_logic_vector(12 DOWNTO 0);
    DRAM_BA    : OUT   std_logic_vector(1 DOWNTO 0);
    DRAM_CS_N  : OUT   std_logic;
    DRAM_CAS_N : OUT   std_logic;
    DRAM_RAS_N : OUT   std_logic;
    DRAM_WE_N  : OUT   std_logic;
    DRAM_UDQM  : OUT   std_logic;
    DRAM_LDQM  : OUT   std_logic
    );
END ENTITY custom_instruction_demo;


ARCHITECTURE Structure OF custom_instruction_demo IS

  -----------------------------------------------------------------------------
  -- define components
  -----------------------------------------------------------------------------
  COMPONENT nios_system IS
    PORT (
      clk_clk                : IN    std_logic;
      reset_reset            : IN    std_logic;
      --
      clock_buffer_sdram_clk : OUT   std_logic;
      dram_addr             : OUT   std_logic_vector(12 DOWNTO 0);
      dram_ba               : OUT   std_logic_vector(1 DOWNTO 0);
      dram_cas_n            : OUT   std_logic;
      dram_cke              : OUT   std_logic;
      dram_cs_n             : OUT   std_logic;
      dram_dq               : INOUT std_logic_vector(15 DOWNTO 0);
      dram_dqm              : OUT   std_logic_vector(1 DOWNTO 0);
      dram_ras_n            : OUT   std_logic;
      dram_we_n             : OUT   std_logic;
      --
      switches_export        : IN    std_logic_vector(9 downto 0);
      ledr_export            : OUT   std_logic_vector(9 downto 0)
      );
  END COMPONENT nios_system;


  -----------------------------------------------------------------------------
  -- define custom data types, constants, etc
  -----------------------------------------------------------------------------
  CONSTANT HIGH : std_logic := '1';
  CONSTANT LOW  : std_logic := '0';

  
  -----------------------------------------------------------------------------
  -- define internal signals
  -----------------------------------------------------------------------------
  SIGNAL reset_n   : std_logic;
  --
  -- SDRAM signals
  --SIGNAL BA         : std_logic_vector(1 DOWNTO 0);
  SIGNAL DQM        : std_logic_vector(1 DOWNTO 0);


BEGIN

  -- identify system reset and connect to internal signal
  reset_n   <= NOT KEY(0);

  --DRAM_BA[1] <= BA(1);
  --DRAM_BA[0] <= BA(0);
  DRAM_UDQM <= DQM(1);
  DRAM_LDQM <= DQM(0);


  NiosII : nios_system PORT MAP(
    clk_clk                => CLOCK_50,
    reset_reset            => reset_n,
    --
    clock_buffer_sdram_clk => DRAM_CLK,
    dram_addr             => DRAM_ADDR,
    dram_ba               => DRAM_BA,
    dram_cas_n            => DRAM_CAS_N,
    dram_cke              => DRAM_CKE,
    dram_cs_n             => DRAM_CS_N,
    dram_dq               => DRAM_DQ,
    dram_dqm              => DQM,
    dram_ras_n            => DRAM_RAS_N,
    dram_we_n             => DRAM_WE_N,
    --
    switches_export        => sw,
    ledr_export            => LEDR
    --

    );

  HEX0 <= "0000000";
END ARCHITECTURE Structure;
