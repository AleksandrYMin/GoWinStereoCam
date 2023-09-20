// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2020 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] TOP.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DPHY RefDesign design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Mar 27 15:30:00 2018
//     \  /    \  /      [version     ] 1.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | XX     |23/03/20  |Initial version
// ===========Oooo==========================================Oooo========

`timescale 1ns / 1ps

//====================================================//
// 1. Choose to use 1:8 mode or 1:16 mode
//****************************************************//
//
//               Used for 1:8 Mode
//
`define GEN_MIPI_TX_8
`define GEN_MIPI_RX_8
//
///////////////////////////////////////////////////
//
//               Used for 1:16 Mode
//
//
//****************************************************//
//====================================================//

//====================================================//
// 2. Choose the IO_TPYE: MIPI_IO or ELVDS/TLVDS
// 3. Choose the HS/LP LANE Number
//****************************************************//
//
//     Uesd for MIPI_IO IOTYPE & MIPI LANE Num.
//
/*
  `define DPHY_MIPI_IO
  `define MIPI_LANE3                                  //Defines HS (High Speed) Data Lanes 3 Enable;
  `define MIPI_LANE2                                  //Defines HS (High Speed) Data Lanes 2 Enable;
  `define MIPI_LANE1                                  //Defines HS (High Speed) Data Lanes 1 Enable;
  `define MIPI_LANE0                                  //Defines HS (High Speed) Data Lanes 0 Enable;
*/
//
///////////////////////////////////////////////////
//
// Uesd for ELVDS/TLVDS IOTYPE & HS/LP LANE Num.
//
////////////////// HS DATA LANE ///////////////////
  `define HS_DATA1                                  //Defines HS (High Speed) Data Lanes 1 Enable;
  `define HS_DATA0                                  //Defines HS (High Speed) Data Lanes 0 Enable;

//
////////////////// LP CLK/DATA LANE ///////////////////

  `define LP_CLK                                                                                                        
  `define LP_DATA0                                                                                                      
  `define LP_DATA1                                  

//
//****************************************************//
//====================================================//


//====================================================//
//
// 4. TX use INTERNAL PLL or Not
//
//****************************************************//
//
//   `define INTERNAL_PLL
//
//****************************************************//
//====================================================//




///////////////////////////////////////////////////
// Uesd ELVDS/TLVDS IOTYPE & 4 HS LANE & INTERNAL_PLL
///////////////////////////////////////////////////
       
module DPHY_TOP(
          output        HS_CLK_TX_P         ,      //HS (High Speed) Clock
          output        HS_CLK_TX_N         ,      //HS (High Speed) Clock
          output        HS_DATA1_TX_P       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA1_TX_N       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA0_TX_P       ,      //HS (High Speed) Data Lane 0
          output        HS_DATA0_TX_N       ,      //HS (High Speed) Data Lane 0
          inout   [1:0] LP_CLK_TX           ,        //LP (Low Power) External Interface Signals for Clock Lane
          inout   [1:0] LP_CLK_RX           ,        //LP (Low Power) External Interface Signals for Clock Lane
          inout   [1:0] LP_DATA1_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 1
          inout   [1:0] LP_DATA1_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 1
          inout   [1:0] LP_DATA0_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 0
          inout   [1:0] LP_DATA0_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 0
          input         rstn             ,
          input         clkx2x4          ,
          output  reg   hactive_flag     ,
          output  [1:0] probe            ,
          output        ready            
        );




  wire          lp_clk_dir, lp_data3_dir,lp_data2_dir,lp_data1_dir,lp_data0_dir; 
  wire  [1:0]   lp_clk_in , lp_data3_in, lp_data2_in, lp_data1_in, lp_data0_in;
  assign   lp_clk_dir   = 1'b0;
  assign   lp_data3_dir = 1'b0;
  assign   lp_data2_dir = 1'b0;
  assign   lp_data1_dir = 1'b0;
  assign   lp_data0_dir = 1'b0;
  assign   lp_clk_in    = 2'b00;
  assign   lp_data3_in  = 2'b00;
  assign   lp_data2_in  = 2'b00;
  assign   lp_data1_in  = 2'b00;
  assign   lp_data0_in  = 2'b00;

   reg   [1:0]  hs_en;
   wire  [16:0] dout_rom;

/////////////////////////////////////////////////////
// u_plld4 : Used to change the input clock frequency of MIPI DPHY TX

`ifdef GEN_MIPI_TX_8
      rPLL pll_mipi_tx
      (
           .CLKOUT   (CLKOUT                                     )
          ,.LOCK     (LOCK                                       )
          ,.CLKOUTP  (CLKOUTP                                    )
          ,.CLKOUTD  (clkoutd_o                                  )
          ,.CLKOUTD3 (clkoutd3_o                                 )
          ,.RESET    (1'b0                                       )
          ,.RESET_P  (1'b0                                       )
          ,.CLKIN    (clkx2x4                                    )
          ,.CLKFB    (1'b0                                       )
          ,.FBDSEL   (6'd0                                       )
          ,.IDSEL    (6'd0                                       )
          ,.ODSEL    (6'd0                                       )
          ,.PSDA     (4'd0                                       )
          ,.DUTYDA   (4'd0                                       )
          ,.FDLY     (4'hF                                       )
      );
      defparam pll_mipi_tx.FCLKIN="50"; 
      defparam pll_mipi_tx.DYN_IDIV_SEL= "false";
      defparam pll_mipi_tx.IDIV_SEL = 1; 
      defparam pll_mipi_tx.DYN_FBDIV_SEL= "false";
      defparam pll_mipi_tx.FBDIV_SEL = 7; 
      defparam pll_mipi_tx.DYN_ODIV_SEL= "false";
      defparam pll_mipi_tx.ODIV_SEL = 4;
      defparam pll_mipi_tx.PSDA_SEL= "0100";
      defparam pll_mipi_tx.DYN_DA_EN = "false";
      defparam pll_mipi_tx.DUTYDA_SEL= "1000";
      defparam pll_mipi_tx.CLKOUT_FT_DIR = 1'b1;  
      defparam pll_mipi_tx.CLKOUTP_FT_DIR = 1'b1; 
      defparam pll_mipi_tx.CLKFB_SEL = "internal";
      defparam pll_mipi_tx.CLKOUT_BYPASS = "false";  
      defparam pll_mipi_tx.CLKOUTP_BYPASS = "false";   
      defparam pll_mipi_tx.CLKOUTD_BYPASS = "false";  
      defparam pll_mipi_tx.DYN_SDIV_SEL = 2; 
      defparam pll_mipi_tx.CLKOUTD_SRC =  "CLKOUT";  
      defparam pll_mipi_tx.CLKOUTD3_SRC = "CLKOUT"; 
      defparam pll_mipi_tx.DEVICE = "GW1N-9";
      defparam U3_CLKDIV.DIV_MODE = "4" ;
      CLKDIV U3_CLKDIV (.RESETN(rstn), .HCLKIN(CLKOUT), .CALIB(1'b0), .CLKOUT(sclk_tx));
`endif

/////////////////////////////////////////////////////
// Generate HS Data & HS_EN
/////////////////////////////////////////////////////

    ROM549x17 u_ROM549x17(
     .clk   (sclk_tx),
     .rstn  (rstn),
     .dout  (dout_rom)
     );


`ifdef GEN_MIPI_TX_8 
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         {hactive_flag,dout1} <= 0;
       else
         {hactive_flag,dout1} <= {dout_rom[16],dout_rom[7:0]};
  end
  wire [7:0] clk_data;
  assign clk_data = 8'b0101_0101;
`endif


    MIPI_TX_Advance_Top u_MIPI_TX_Advance_Top(
          .reset_n      (rstn)              ,
          .HS_CLK_P     (HS_CLK_TX_P)       ,
          .HS_CLK_N     (HS_CLK_TX_N)       ,
          .clk_data     (clk_data   )       ,
     `ifdef INTERNAL_PLL
          .clk_byte     (clkx2x4    )       ,
          .sclk         (           )       ,
     `else
          .clk_bit      (CLKOUT     )       ,
          .clk_bit_90   (CLKOUTP    )       ,
          .sclk         (sclk_tx    )       ,
     `endif
     `ifdef HS_DATA3
          .HS_DATA3_P   (HS_DATA3_TX_P)     ,
          .HS_DATA3_N   (HS_DATA3_TX_N)     ,
          .data_in3     (dout1)             ,
     `endif
     `ifdef HS_DATA2
          .HS_DATA2_P   (HS_DATA2_TX_P)     ,
          .HS_DATA2_N   (HS_DATA2_TX_N)     ,
          .data_in2     (dout1)             ,
     `endif
     `ifdef HS_DATA1
          .HS_DATA1_P   (HS_DATA1_TX_P)     ,
          .HS_DATA1_N   (HS_DATA1_TX_N)     ,
          .data_in1     (dout1)             ,
     `endif
     `ifdef HS_DATA0
          .HS_DATA0_P   (HS_DATA0_TX_P)     ,
          .HS_DATA0_N   (HS_DATA0_TX_N)     ,
          .data_in0     (dout1)             ,
     `endif
     `ifdef LP_CLK
          .LP_CLK       (LP_CLK_TX)      ,
          .lp_clk_out   (2'b11    )      ,
          .lp_clk_in    (lp_clk_in)      ,
          .lp_clk_dir   (1'b1)           ,
     `endif
     `ifdef LP_DATA3
          .LP_DATA3     (LP_DATA3_TX)    ,
          .lp_data3_out (2'b11)          ,
          .lp_data3_in  (lp_data3_in  )  ,
          .lp_data3_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA2
          .LP_DATA2     (LP_DATA2_TX)    ,
          .lp_data2_out (2'b11)          ,
          .lp_data2_in  (lp_data2_in  )  ,
          .lp_data2_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA1
          .LP_DATA1     (LP_DATA1_TX)    ,
          .lp_data1_out (2'b11)          ,
          .lp_data1_in  (lp_data1_in  )  ,
          .lp_data1_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA0
          .LP_DATA0     (LP_DATA0_TX)    ,
          .lp_data0_out (2'b11)          ,
          .lp_data0_in  (lp_data0_in  )  ,
          .lp_data0_dir (1'b1)           ,
     `endif
          .hs_clk_en    (hactive_flag)   ,
          .hs_data_en   (hactive_flag)
      );


always @(posedge clk_byte_out or negedge rstn)
  begin
       if(~rstn)
         data_out_reg <= 0;
       else
         data_out_reg <= {data_out3,data_out2,data_out1,data_out0};
  end

assign probe[0] = ^data_out_reg;
assign probe[1] = 1'b0;

endmodule





