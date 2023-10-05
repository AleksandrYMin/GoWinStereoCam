//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri Sep 15 15:17:31 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	MIPI_Pixel_to_Byte_Converter_Top your_instance_name(
		.I_RSTN(I_RSTN_i), //input I_RSTN
		.I_PIXEL_CLK(I_PIXEL_CLK_i), //input I_PIXEL_CLK
		.I_BYTE_CLK(I_BYTE_CLK_i), //input I_BYTE_CLK
		.I_FV(I_FV_i), //input I_FV
		.I_LV(I_LV_i), //input I_LV
		.I_PIXEL(I_PIXEL_i), //input [23:0] I_PIXEL
		.O_FV_START(O_FV_START_o), //output O_FV_START
		.O_FV_END(O_FV_END_o), //output O_FV_END
		.O_DATA_EN(O_DATA_EN_o), //output O_DATA_EN
		.O_DATA(O_DATA_o) //output [15:0] O_DATA
	);

//--------Copy end-------------------
