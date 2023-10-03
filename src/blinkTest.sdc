//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-3
//Created Time: 2023-09-13 16:36:23
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}]
create_clock -name cam_2_pclk -period 10 [get_ports {cam_2_pclk}] -add
create_clock -name cam_2_vsync -period 1000 [get_ports {cam_2_vsync}] -add
