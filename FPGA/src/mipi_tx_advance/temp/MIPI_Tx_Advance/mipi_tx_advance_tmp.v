//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Wed Sep 20 12:00:01 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	MIPI_TX_Advance_Top your_instance_name(
		.reset_n(reset_n_i), //input reset_n
		.HS_CLK_P(HS_CLK_P_o), //output HS_CLK_P
		.HS_CLK_N(HS_CLK_N_o), //output HS_CLK_N
		.clk_data(clk_data_i), //input [7:0] clk_data
		.clk_bit(clk_bit_i), //input clk_bit
		.clk_bit_90(clk_bit_90_i), //input clk_bit_90
		.sclk(sclk_i), //input sclk
		.HS_DATA1_P(HS_DATA1_P_o), //output HS_DATA1_P
		.HS_DATA1_N(HS_DATA1_N_o), //output HS_DATA1_N
		.data_in1(data_in1_i), //input [7:0] data_in1
		.HS_DATA0_P(HS_DATA0_P_o), //output HS_DATA0_P
		.HS_DATA0_N(HS_DATA0_N_o), //output HS_DATA0_N
		.data_in0(data_in0_i), //input [7:0] data_in0
		.LP_CLK(LP_CLK_io), //inout [1:0] LP_CLK
		.lp_clk_out(lp_clk_out_i), //input [1:0] lp_clk_out
		.lp_clk_in(lp_clk_in_o), //output [1:0] lp_clk_in
		.lp_clk_dir(lp_clk_dir_i), //input lp_clk_dir
		.LP_DATA1(LP_DATA1_io), //inout [1:0] LP_DATA1
		.lp_data1_out(lp_data1_out_i), //input [1:0] lp_data1_out
		.lp_data1_in(lp_data1_in_o), //output [1:0] lp_data1_in
		.lp_data1_dir(lp_data1_dir_i), //input lp_data1_dir
		.LP_DATA0(LP_DATA0_io), //inout [1:0] LP_DATA0
		.lp_data0_out(lp_data0_out_i), //input [1:0] lp_data0_out
		.lp_data0_in(lp_data0_in_o), //output [1:0] lp_data0_in
		.lp_data0_dir(lp_data0_dir_i), //input lp_data0_dir
		.hs_clk_en(hs_clk_en_i), //input hs_clk_en
		.hs_data_en(hs_data_en_i) //input hs_data_en
	);

//--------Copy end-------------------
