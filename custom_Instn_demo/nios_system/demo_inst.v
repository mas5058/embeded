	demo u0 (
		.clock_buffer_sdram_clk (<connected-to-clock_buffer_sdram_clk>), // clock_buffer_sdram.clk
		.ledr_export            (<connected-to-ledr_export>),            //               ledr.export
		.dram_addr              (<connected-to-dram_addr>),              //               dram.addr
		.dram_ba                (<connected-to-dram_ba>),                //                   .ba
		.dram_cas_n             (<connected-to-dram_cas_n>),             //                   .cas_n
		.dram_cke               (<connected-to-dram_cke>),               //                   .cke
		.dram_cs_n              (<connected-to-dram_cs_n>),              //                   .cs_n
		.dram_dq                (<connected-to-dram_dq>),                //                   .dq
		.dram_dqm               (<connected-to-dram_dqm>),               //                   .dqm
		.dram_ras_n             (<connected-to-dram_ras_n>),             //                   .ras_n
		.dram_we_n              (<connected-to-dram_we_n>),              //                   .we_n
		.switches_export        (<connected-to-switches_export>),        //           switches.export
		.clk_clk                (<connected-to-clk_clk>),                //                clk.clk
		.reset_reset            (<connected-to-reset_reset>)             //              reset.reset
	);

