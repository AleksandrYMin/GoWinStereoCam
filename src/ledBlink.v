module blinkTest (
    input clk,  //27 MHz

    output        HS_CLK_TX_p         ,      //HS (High Speed) Clock
    output        HS_CLK_TX_n         ,      //HS (High Speed) Clock

    output        HS_DATA1_TX_p       ,      //HS (High Speed) Data Lane 1
    output        HS_DATA1_TX_n       ,      //HS (High Speed) Data Lane 1

    output        HS_DATA0_TX_p       ,      //HS (High Speed) Data Lane 0
    output        HS_DATA0_TX_n       ,      //HS (High Speed) Data Lane 0

    inout   [1:0] LP_DATA1_TX         ,      //LP (Low Power) External Interface Signals for Data Lane 1
    inout   [1:0] LP_DATA0_TX         ,      //LP (Low Power) External Interface Signals for Data Lane 0
    inout   [1:0] LP_CLK_TX         ,      //LP (Low Power) External Interface Signals for Data Lane 0

    input  camera_en,
    input gpio_in,
    output [1:0] gpio_out,
    output [2:0] led
);
wire reset_n;
wire pll_lock;
assign reset_n = (camera_en | ~gpio_in) & pll_lock;

wire [7:0] data_in1;  
wire [7:0] data_in0;
wire [1:0] lp_clk;
wire [1:0] lp_data1;
wire [1:0] lp_data0;
wire hs_clk_en;
wire hs_data_en;

//wire [2:0] led;
assign led[0] = reset_n & tp0_hs_in;
assign led[1] = reset_n & tp0_hs_in;
assign led[2] = reset_n & tp0_hs_in;
assign gpio_out[0] = pix_clk;
assign gpio_out[1] = byte_clk;

wire        tp0_vs_in  ;
wire        tp0_hs_in  ;
wire        tp0_de_in ;
wire [ 7:0] tp0_data_r/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_g/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_b/*synthesis syn_keep=1*/;

wire [23:0] pix_data;
assign pix_data = {tp0_data_r,tp0_data_g,tp0_data_b};
wire pix_clk;
assign pix_clk = clk;
wire byte_clk;
assign byte_clk = clk40_5;

//testpattern
testpattern testpattern_inst
(
    .I_pxl_clk   (pix_clk            ),//pixel clock
    .I_rst_n     (reset_n            ),//low active 
    .I_mode      (3'b011             ),//data select
    .I_single_r  (8'h01              ),
    .I_single_g  (8'hAA              ),
    .I_single_b  (8'hB6              ),                  //800x600    //1024x768   //1280x720    
    .I_h_total   (12'd1056           ),//hor total time  // 12'd1056  // 12'd1344  // 12'd1650  
    .I_h_sync    (12'd128            ),//hor sync time   // 12'd128   // 12'd136   // 12'd40    
    .I_h_bporch  (12'd88             ),//hor back porch  // 12'd88    // 12'd160   // 12'd220   
    .I_h_res     (12'd800            ),//hor resolution  // 12'd800   // 12'd1024  // 12'd1280  
    .I_v_total   (12'd610            ),//ver total time  // 12'd628   // 12'd806   // 12'd750    
    .I_v_sync    (12'd4              ),//ver sync time   // 12'd4     // 12'd6     // 12'd5     
    .I_v_bporch  (12'd2              ),//ver back porch  // 12'd23    // 12'd29    // 12'd20    
    .I_v_res     (12'd600            ),//ver resolution  // 12'd600   // 12'd768   // 12'd720    
    .I_hs_pol    (1'b1               ),//HS polarity , 0:negetive ploarity，1：positive polarity
    .I_vs_pol    (1'b1               ),//VS polarity , 0:negetive ploarity，1：positive polarity
    .O_de        (tp0_de_in          ),   
    .O_hs        (tp0_hs_in          ),
    .O_vs        (tp0_vs_in          ),
    .O_data_r    (tp0_data_r         ),   
    .O_data_g    (tp0_data_g         ),
    .O_data_b    (tp0_data_b         )
);



wire clk162;
wire clk162_p;
wire clk40_5;

//wire clk81;

//CLKDIV u_clkdiv
//(.RESETN(reset_n)
//,.HCLKIN(clk162) //clk  x5
//,.CLKOUT(clk81)    //clk  x1
//,.CALIB (1'b1)
//);
//defparam u_clkdiv.DIV_MODE="2";
//defparam u_clkdiv.GSREN="false";


//DPI_to_MIPI_TX_Top DPI_to_MIPI_inst(
//    .rst_n(reset_n), //input rst_n

//    .byte_d1_out(data_in1), //output [7:0] byte_d1_out
//    .byte_d0_out(data_in0), //output [7:0] byte_d0_out
//    .hs_clk_en(hs_clk_en), //output hs_clk_en
//    .hs_data_en(hs_data_en), //output hs_data_en
//    .lp_clk(lp_clk), //output [1:0] lp_clk
//    .lp_data(lp_data0), //output [1:0] lp_data

//    .byte_clk(byte_clk), //input byte_clk
//    .pix_clk_dpi(pix_clk), //input pix_clk_dpi
//    .pix_data_dpi(pix_data), //input [23:0] pix_data_dpi
//    .de_dpi(tp0_de_in), //input de_dpi
//    .vsync_dpi(tp0_vs_in), //input vsync_dpi
//    .hsync_dpi(tp0_hs_in) //input hsync_dpi
//);


wire O_FV_START_o;
wire O_FV_END_o;
wire O_DATA_EN_o;
wire [15:0]O_DATA_o;
MIPI_Pixel_to_Byte_Converter_Top pixel_to_byte(
    .I_RSTN(reset_n), //input I_RSTN
    .I_PIXEL_CLK(pix_clk), //input I_PIXEL_CLK
    .I_BYTE_CLK(byte_clk), //input I_BYTE_CLK
    .I_FV(~tp0_vs_in), //input I_FV
    .I_LV(~tp0_hs_in & tp0_de_in), //input I_LV
    .I_PIXEL(pix_data), //input [23:0] I_PIXEL
    .O_FV_START(O_FV_START_o), //output O_FV_START
    .O_FV_END(O_FV_END_o), //output O_FV_END
    .O_DATA_EN(O_DATA_EN_o), //output O_DATA_EN
    .O_DATA(O_DATA_o) //output [15:0] O_DATA
);

MIPI_DSI_CSI2_TX_Top CSI2_TX(
    .I_RSTN(reset_n), //input I_RSTN
    .I_BYTE_CLK(byte_clk), //input I_BYTE_CLK
    .I_FV_START(O_FV_START_o), //input I_FV_START
    .I_FV_END(O_FV_END_o), //input I_FV_END
    .I_WC(16'd2400), //input [15:0] I_WC
    .I_VC(2'd0), //input [1:0] I_VC
    .I_DT(6'h21), //input [5:0] I_DT
    .I_DATA_EN(O_DATA_EN_o), //input I_DATA_EN
    .I_DATA(O_DATA_o), //input [15:0] I_DATA
    .O_LP_CLK(lp_clk), //output [1:0] O_LP_CLK
    .O_HS_CLK_EN(hs_clk_en), //output O_HS_CLK_EN
    .O_HS_CLK(), //output [7:0] O_HS_CLK
    .O_LP_DATA0(lp_data0), //output [1:0] O_LP_DATA0
    .O_HS_DATA_EN(hs_data_en), //output O_HS_DATA_EN
    .O_HS_DATA0(data_in0), //output [7:0] O_HS_DATA0
    .O_HS_DATA1(data_in1) //output [7:0] O_HS_DATA1
);

Gowin_rPLL_162 your_instance_name(
    .clkout(clk162), //output clkout
    .lock(pll_lock), //output lock
    .clkoutp(clk162_p), //output clkoutp
    .clkoutd(clk40_5), //output clkoutd
    .clkin(clk) //input clkin
);

MIPI_TX_Advance_Top mipi_tx_inst(
    .reset_n(reset_n),          //input reset_n                        

    .HS_CLK_P(HS_CLK_TX_p),     //output HS_CLK_P
    .HS_CLK_N(HS_CLK_TX_n),     //output HS_CLK_N
    .clk_data(~8'b01010101),     //input [7:0] clk_data

    .clk_bit(clk162),           //input clk_bit
    .clk_bit_90(clk162_p),      //input clk_bit_90
    .sclk(byte_clk),            //input sclk

    .HS_DATA1_P(HS_DATA1_TX_p), //output HS_DATA1_P
    .HS_DATA1_N(HS_DATA1_TX_n), //output HS_DATA1_N
    .data_in1(~data_in1),        //input [7:0] data_in1                

    .HS_DATA0_P(HS_DATA0_TX_p), //output HS_DATA0_P
    .HS_DATA0_N(HS_DATA0_TX_n), //output HS_DATA0_N
    .data_in0(data_in0),       //input [7:0] data_in0                

    .LP_CLK(LP_CLK_TX),         //inout [1:0] LP_CLK
    .lp_clk_out(lp_clk),        //input [1:0] lp_clk_out          
    .lp_clk_in(),               //output [1:0] lp_clk_in
    .lp_clk_dir(1'b1),    //input lp_clk_dir                

    .LP_DATA1(LP_DATA1_TX),     //inout [1:0] LP_DATA1
    .lp_data1_out(lp_data0),    //input [1:0] lp_data1_out    
    .lp_data1_in(),             //output [1:0] lp_data1_in
    .lp_data1_dir(1'b1), //input lp_data1_dir

    .LP_DATA0(LP_DATA0_TX),     //inout [1:0] LP_DATA0
    .lp_data0_out(lp_data0),    //input [1:0] lp_data0_out    
    .lp_data0_in(),             //output [1:0] lp_data0_in
    .lp_data0_dir(1'b1), //input lp_data0_dir

    .hs_clk_en(hs_clk_en),      //input hs_clk_en                   
    .hs_data_en(hs_data_en)     //input hs_data_en                 
);


endmodule
