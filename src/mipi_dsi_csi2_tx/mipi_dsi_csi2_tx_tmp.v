//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Fri Sep 15 16:28:24 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	MIPI_DSI_CSI2_TX_Top your_instance_name(
		.I_RSTN(I_RSTN_i), //input I_RSTN
		.I_BYTE_CLK(I_BYTE_CLK_i), //input I_BYTE_CLK
		.I_FV_START(I_FV_START_i), //input I_FV_START
		.I_FV_END(I_FV_END_i), //input I_FV_END
		.I_WC(I_WC_i), //input [15:0] I_WC
		.I_VC(I_VC_i), //input [1:0] I_VC
		.I_DT(I_DT_i), //input [5:0] I_DT
		.I_DATA_EN(I_DATA_EN_i), //input I_DATA_EN
		.I_DATA(I_DATA_i), //input [15:0] I_DATA
		.O_LP_CLK(O_LP_CLK_o), //output [1:0] O_LP_CLK
		.O_HS_CLK_EN(O_HS_CLK_EN_o), //output O_HS_CLK_EN
		.O_HS_CLK(O_HS_CLK_o), //output [7:0] O_HS_CLK
		.O_LP_DATA0(O_LP_DATA0_o), //output [1:0] O_LP_DATA0
		.O_HS_DATA_EN(O_HS_DATA_EN_o), //output O_HS_DATA_EN
		.O_HS_DATA0(O_HS_DATA0_o), //output [7:0] O_HS_DATA0
		.O_HS_DATA1(O_HS_DATA1_o) //output [7:0] O_HS_DATA1
	);

//--------Copy end-------------------
