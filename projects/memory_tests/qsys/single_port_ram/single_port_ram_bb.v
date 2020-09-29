
module single_port_ram (
	clk_clk,
	reset_reset_n,
	onchip_memory2_0_s1_address,
	onchip_memory2_0_s1_clken,
	onchip_memory2_0_s1_chipselect,
	onchip_memory2_0_s1_write,
	onchip_memory2_0_s1_readdata,
	onchip_memory2_0_s1_writedata,
	onchip_memory2_0_s1_byteenable,
	onchip_memory2_0_s2_address,
	onchip_memory2_0_s2_chipselect,
	onchip_memory2_0_s2_clken,
	onchip_memory2_0_s2_write,
	onchip_memory2_0_s2_readdata,
	onchip_memory2_0_s2_writedata,
	onchip_memory2_0_s2_byteenable);	

	input		clk_clk;
	input		reset_reset_n;
	input	[5:0]	onchip_memory2_0_s1_address;
	input		onchip_memory2_0_s1_clken;
	input		onchip_memory2_0_s1_chipselect;
	input		onchip_memory2_0_s1_write;
	output	[511:0]	onchip_memory2_0_s1_readdata;
	input	[511:0]	onchip_memory2_0_s1_writedata;
	input	[63:0]	onchip_memory2_0_s1_byteenable;
	input	[5:0]	onchip_memory2_0_s2_address;
	input		onchip_memory2_0_s2_chipselect;
	input		onchip_memory2_0_s2_clken;
	input		onchip_memory2_0_s2_write;
	output	[511:0]	onchip_memory2_0_s2_readdata;
	input	[511:0]	onchip_memory2_0_s2_writedata;
	input	[63:0]	onchip_memory2_0_s2_byteenable;
endmodule
