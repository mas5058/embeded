
module demo (
	clock_buffer_sdram_clk,
	ledr_export,
	dram_addr,
	dram_ba,
	dram_cas_n,
	dram_cke,
	dram_cs_n,
	dram_dq,
	dram_dqm,
	dram_ras_n,
	dram_we_n,
	switches_export,
	clk_clk,
	reset_reset);	

	output		clock_buffer_sdram_clk;
	output	[9:0]	ledr_export;
	output	[12:0]	dram_addr;
	output	[1:0]	dram_ba;
	output		dram_cas_n;
	output		dram_cke;
	output		dram_cs_n;
	inout	[15:0]	dram_dq;
	output	[1:0]	dram_dqm;
	output		dram_ras_n;
	output		dram_we_n;
	input	[9:0]	switches_export;
	input		clk_clk;
	input		reset_reset;
endmodule
