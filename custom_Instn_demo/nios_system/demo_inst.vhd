	component demo is
		port (
			clock_buffer_sdram_clk : out   std_logic;                                        -- clk
			ledr_export            : out   std_logic_vector(9 downto 0);                     -- export
			dram_addr              : out   std_logic_vector(12 downto 0);                    -- addr
			dram_ba                : out   std_logic_vector(1 downto 0);                     -- ba
			dram_cas_n             : out   std_logic;                                        -- cas_n
			dram_cke               : out   std_logic;                                        -- cke
			dram_cs_n              : out   std_logic;                                        -- cs_n
			dram_dq                : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			dram_dqm               : out   std_logic_vector(1 downto 0);                     -- dqm
			dram_ras_n             : out   std_logic;                                        -- ras_n
			dram_we_n              : out   std_logic;                                        -- we_n
			switches_export        : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			clk_clk                : in    std_logic                     := 'X';             -- clk
			reset_reset            : in    std_logic                     := 'X'              -- reset
		);
	end component demo;

	u0 : component demo
		port map (
			clock_buffer_sdram_clk => CONNECTED_TO_clock_buffer_sdram_clk, -- clock_buffer_sdram.clk
			ledr_export            => CONNECTED_TO_ledr_export,            --               ledr.export
			dram_addr              => CONNECTED_TO_dram_addr,              --               dram.addr
			dram_ba                => CONNECTED_TO_dram_ba,                --                   .ba
			dram_cas_n             => CONNECTED_TO_dram_cas_n,             --                   .cas_n
			dram_cke               => CONNECTED_TO_dram_cke,               --                   .cke
			dram_cs_n              => CONNECTED_TO_dram_cs_n,              --                   .cs_n
			dram_dq                => CONNECTED_TO_dram_dq,                --                   .dq
			dram_dqm               => CONNECTED_TO_dram_dqm,               --                   .dqm
			dram_ras_n             => CONNECTED_TO_dram_ras_n,             --                   .ras_n
			dram_we_n              => CONNECTED_TO_dram_we_n,              --                   .we_n
			switches_export        => CONNECTED_TO_switches_export,        --           switches.export
			clk_clk                => CONNECTED_TO_clk_clk,                --                clk.clk
			reset_reset            => CONNECTED_TO_reset_reset             --              reset.reset
		);

