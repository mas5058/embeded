	component niosSystem is
		port (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
			leds_export     : out std_logic_vector(7 downto 0);                    -- export
			switches_export : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component niosSystem;

	u0 : component niosSystem
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --      clk.clk
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --    reset.reset_n
			leds_export     => CONNECTED_TO_leds_export,     --     leds.export
			switches_export => CONNECTED_TO_switches_export  -- switches.export
		);

