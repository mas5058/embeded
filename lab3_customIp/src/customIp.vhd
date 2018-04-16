-------------------------------------------------------------------------
-- Author: Gregg Guarino Ph.D.
-- January, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY customIp is
  port (
    ----- Audio -----
    AUD_ADCDAT : in std_logic; 
    AUD_ADCLRCK : inout std_logic;
    AUD_BCLK : inout std_logic;
    AUD_DACDAT : out std_logic;
    AUD_DACLRCK : inout std_logic;
    AUD_XCK : out std_logic;

    ----- CLOCK -----
    CLOCK_50 : in std_logic;
    CLOCK2_50 : in std_logic;
    CLOCK3_50 : in std_logic;
    CLOCK4_50 : in std_logic;

    ----- SDRAM -----
    DRAM_ADDR : out std_logic_vector(12 downto 0);
    DRAM_BA : out std_logic_vector(1 downto 0);
    DRAM_CAS_N : out std_logic;
    DRAM_CKE : out std_logic;
    DRAM_CLK : out std_logic;
    DRAM_CS_N : out std_logic;
    DRAM_DQ : inout std_logic_vector(15 downto 0);
    DRAM_LDQM : out std_logic;
    DRAM_RAS_N : out std_logic;
    DRAM_UDQM : out std_logic;
    DRAM_WE_N : out std_logic;

    ----- I2C for Audio and Video-In -----
    FPGA_I2C_SCLK : out std_logic;
    FPGA_I2C_SDAT : inout std_logic;

    ----- SEG7 -----
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0);

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0);

    ----- LED -----
    LEDR : out  std_logic_vector(9 downto 0);

    ----- SW -----
    SW : in  std_logic_vector(9 downto 0);

    ----- GPIO_0, GPIO_0 connect to GPIO Default -----
    GPIO_0 : inout  std_logic_vector(35 downto 0);

    ----- GPIO_1, GPIO_1 connect to GPIO Default -----
    GPIO_1 : inout  std_logic_vector(35 downto 0)
  );
end entity customIp;

architecture ip_arch of customIp is
  -- signal declarations
  signal led0 : std_logic;
  signal key0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal ledNios : std_logic_vector(7 downto 0);
  signal reset_n : std_logic;
  signal accumPulse : std_logic;
  signal accum_sig : std_logic_vector(15 downto 0);
  signal SWsync : std_logic_vector(9 downto 0);
  signal KEYsync : std_logic_vector(3 downto 0);
  signal BEsig : std_logic_vector(3 downto 0) := (others => '0');
  signal addr: std_logic_vector(11 downto 0) := (others => '0');
  signal  din: std_logic_vector(31 downto 0) := (others => '0');
  signal dout: std_logic_vector(31 downto 0) := (others => '0');
  
  -- component declarations
  
  component raminfr_be IS
  PORT (
    clk : IN std_logic;
    reset_n : IN std_logic;
    we_n : IN std_logic;
    be_n : IN std_logic_vector(3 DOWNTO 0);
    addr : IN std_logic_vector(11 DOWNTO 0);
    din : IN std_logic_vector(31 DOWNTO 0);
    dout : OUT std_logic_vector(31 DOWNTO 0)
);
  END component;

  component synchronizer is
    port (
      i_SW : in std_logic_vector(9 downto 0);
      i_KEY : in std_logic_vector(3 downto 0);
      i_CLOCK2_50 : in std_logic;
      o_SWsync : out std_logic_vector(9 downto 0);
      o_KEYsync : out std_logic_vector(3 downto 0)
    );
  end component synchronizer;
  
  component debounce is
    port (
      i_pushButton : in std_logic;
      i_reset_n : in std_logic;
      i_clk : in std_logic;
      o_keyPulse : out std_logic;
	  o_bepulse : out std_logic_vector(3 downto 0)
    );
  end component debounce;
  
  -- component accum_mod is
    -- port (
      -- i_switch : in std_logic_vector(7 downto 0);
      -- i_trigger : in std_logic;
      -- i_reset_n : in std_logic;
      -- i_clk : in std_logic;
      -- o_accumulator : out std_logic_vector(15 downto 0)
    -- );
  -- end component accum_mod;
  
	component nios_system is
		port(
			clk_clk       : in std_logic; --   clk.clk
			key1_export   : in std_logic; --  key1.export
			leds_export   : out std_logic_vector(7 downto 0); --  leds.export
			reset_reset_n : in std_logic -- reset.reset_n
		);
		
	end component nios_system;

  component hexDisplayDriver is
    port (
      i_hex           : in std_logic_vector(3 downto 0);
	  clk             : in  std_logic; 
	  reset           : in  std_logic;
      o_sevenSeg      : out std_logic_vector(6 downto 0)
    );
  end component hexDisplayDriver;
  
begin

  ----- Control the 10 LEDs
  LEDR(7 downto 0) <= ledNios;
  -- LEDR(4 downto 0) <= "1111" & led0;
  -- led0 <= cntr(25);
  -- ledNios <= "10101";
  key0 <= KEYsync(1);
  
  ----- Syncronize the user inputs i.e. slide switches(SW) and pushbuttons(KEYS) 
  synchronizer_inst : synchronizer
    port map (
      i_SW        => SW,
      i_KEY       => KEY,
      i_CLOCK2_50 => CLOCK2_50,
      o_SWsync    => SWsync,
      o_KEYsync   => KEYsync
    );
    
  ----- Pushbutton KEY0 is the reset
  reset_n <= KEYsync(0);
  
  ----- Debounce the pushbutton which will add the switches input to the accumulator
  debounce_inst1 : debounce
    port map (
      i_pushButton => KEYsync(1),
      i_reset_n    => reset_n,
      i_clk        => CLOCK2_50,
      o_keyPulse   => accumPulse,
      o_bePulse   => BEsig
    );
	 
	 ramIp : raminfr_be
	  port map(
      clk         => CLOCK2_50,
      reset_n    => reset_n,
      we_n         => accumPulse,
      be_n         => BEsig,
      addr         => addr,
      din          => din,
      dout         => dout
      
      );
	  

  ----- The accumulator module
  -- accum_mod_inst : accum_mod
    -- port map (
      -- i_switch      => SWsync(7 downto 0),
      -- i_trigger     => accumPulse,
      -- i_reset_n     => reset_n,
      -- i_clk         => CLOCK2_50,
      -- o_accumulator => accum_sig
    -- );
    
	-- Instantiate the nios processor
 nios_system_inst : nios_system
		port map (
			clk_clk              => CLOCK2_50,
			reset_reset_n        => reset_n,
			key1_export          => key0,
			leds_export          => ledNios
			--o_accumulator_export => accum_sig
		);

  ----- Hex display drivers
  hexDisplayDriver_inst0 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(3 downto 0),
      clk     	 => CLOCK2_50,
      reset => reset_n,
      o_sevenSeg => HEX0
    );

  hexDisplayDriver_inst1 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(7 downto 4),
      clk     	 => CLOCK2_50,
      reset => reset_n,
      o_sevenSeg => HEX1
    );

  hexDisplayDriver_inst2 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(11 downto 8),
      clk        => CLOCK2_50,
      reset      => reset_n,
      o_sevenSeg => HEX2
    );

  hexDisplayDriver_inst3 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(15 downto 12),
      clk        => CLOCK2_50,
      reset      => reset_n,
      o_sevenSeg => HEX3
    );

  ----- Increment counter
  counter_proc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        cntr <= "00" & x"000000";
      else
        cntr <= cntr + ("00" & x"000001");
      end if;
    end if;
  end process counter_proc;
    
end architecture ip_arch;