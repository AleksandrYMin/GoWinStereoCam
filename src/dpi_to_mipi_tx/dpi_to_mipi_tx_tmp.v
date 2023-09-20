//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri Sep 15 16:33:39 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	DPI_to_MIPI_TX_Top your_instance_name(
		.rst_n(rst_n_i), //input rst_n
		.byte_d1_out(byte_d1_out_o), //output [7:0] byte_d1_out
		.byte_d0_out(byte_d0_out_o), //output [7:0] byte_d0_out
		.hs_clk_en(hs_clk_en_o), //output hs_clk_en
		.hs_data_en(hs_data_en_o), //output hs_data_en
		.lp_clk(lp_clk_o), //output [1:0] lp_clk
		.lp_data(lp_data_o), //output [1:0] lp_data
		.byte_clk(byte_clk_i), //input byte_clk
		.pix_clk_dpi(pix_clk_dpi_i), //input pix_clk_dpi
		.pix_data_dpi(pix_data_dpi_i), //input [23:0] pix_data_dpi
		.de_dpi(de_dpi_i), //input de_dpi
		.vsync_dpi(vsync_dpi_i), //input vsync_dpi
		.hsync_dpi(hsync_dpi_i) //input hsync_dpi
	);

//--------Copy end-------------------
