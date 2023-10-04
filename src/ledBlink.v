//`define TEST_SRC
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
    input [1:0]gpio_in,
    output gpio_out,
    output [2:0] led,

    output cam_clk_1,
	input  [7:0] cam_1_db,     //cmos data
	input  cam_1_vsync,        //cmos vsync
	input  cam_1_href,         //cmos hsync refrence,data valid
	input  cam_1_pclk,         //cmos pxiel clock
	inout  cmos_1_scl,         //cmos i2c clock
	inout  cmos_1_sda,         //cmos i2c data

    output cam_clk_2,
    input  [7:0] cam_2_db,     //cmos data
	input  cam_2_vsync,        //cmos vsync
	input  cam_2_href,         //cmos hsync refrence,data valid
	input  cam_2_pclk,         //cmos pxiel clock
	inout  cmos_2_scl,         //cmos i2c clock
	inout  cmos_2_sda,         //cmos i2c data

	output [14-1:0]             ddr_addr,       //ROW_WIDTH=14
	output [3-1:0]              ddr_bank,       //BANK_WIDTH=3
	output                      ddr_cs,
	output                      ddr_ras,
	output                      ddr_cas,
	output                      ddr_we,
	output                      ddr_ck,
	output                      ddr_ck_n,
	output                      ddr_cke,
	output                      ddr_odt,
	output                      ddr_reset_n,
	output [2-1:0]              ddr_dm,         //DM_WIDTH=2
	inout [16-1:0]              ddr_dq,         //DQ_WIDTH=16
	inout [2-1:0]               ddr_dqs,        //DQS_WIDTH=2
	inout [2-1:0]               ddr_dqs_n      //DQS_WIDTH=2
);

wire reset_n;
assign reset_n = (camera_en);

wire DDR_pll_lock;
wire [7:0] data_in1;  
wire [7:0] data_in0;
wire [1:0] lp_clk;
wire [1:0] lp_data1;
wire [1:0] lp_data0;
wire hs_clk_en;
wire hs_data_en;

//wire [2:0] led;
assign led[0] = cam_clk_1;
assign led[1] = cam_2_href;
assign led[2] = cam_2_vsync;
assign gpio_out = byte_clk;

wire        tp0_vs_in  ;
wire        tp0_hs_in  ;
wire        tp0_de_in ;

wire [23:0] pix_data;

assign cam_clk_1 = clk24;
assign cam_clk_2 = clk24;

wire pix_clk;
wire byte_clk;
wire hs_clk;
wire hs_clk_p;

assign pix_clk = clk54;
assign byte_clk = clk81;
assign hs_clk = clk324;
assign hs_clk_p = clk324_p;
//==============================================================================

//=================================CLOCKS=======================================
wire clk324;
wire clk324_p;
wire clk81;
wire clk54;
wire clk24;

Gowin_rPLL_324 faster_clock(
    .lock_o(DDR_pll_lock),
    .clkout(clk324), //output clkout
    .clkoutp(clk324_p), //output clkoutp
    .clkoutd(clk81), //output clkoutd
    .clkin(clk) //input clkin
);

Gowin_rPLL_54 pix_clock_gen(
    .clkout(clk54), //output clkout
    .clkin(clk) //input clkin
);

Gowin_rPLL_24 cam_pll(
    .clkout(clk24), //output clkout
    .clkin(clk) //input clkin
);

//==============================================================================

//=============================TEST PATTERN=====================================
`ifdef TEST_SRC

wire [ 7:0] tp0_data_r/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_g/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_b/*synthesis syn_keep=1*/;

assign pix_data = {tp0_data_b,tp0_data_g,tp0_data_r};

wire [2:0]mode;
assign mode = {1'b0,gpio_in[1],gpio_in[0]};

testpattern testpattern_inst
(
    .I_pxl_clk   (pix_clk            ),//pixel clock
    .I_rst_n     (reset_n            ),//low active 
    .I_mode      (mode               ),//data select
    .I_single_r  (8'h00              ),
    .I_single_g  (8'h00              ),                                          //required 1280x720
    .I_single_b  (8'hFF              ),                  //800x600    //1024x768   //1280x720    
    .I_h_total   (12'd1650           ),//hor total time  // 12'd1056  // 12'd1344  // 12'd1650  
    .I_h_sync    (12'd40             ),//hor sync time   // 12'd128   // 12'd136   // 12'd40    
    .I_h_bporch  (12'd220            ),//hor back porch  // 12'd88    // 12'd160   // 12'd220   
    .I_h_res     (12'd1280           ),//hor resolution  // 12'd800   // 12'd1024  // 12'd1280  
    .I_v_total   (12'd750            ),//ver total time  // 12'd628   // 12'd806   // 12'd750   
    .I_v_sync    (12'd5              ),//ver sync time   // 12'd4     // 12'd6     // 12'd5     
    .I_v_bporch  (12'd20             ),//ver back porch  // 12'd23    // 12'd29    // 12'd20    
    .I_v_res     (12'd720            ),//ver resolution  // 12'd600   // 12'd768   // 12'd720    
    .I_hs_pol    (1'b1               ),//HS polarity , 0:negetive ploarity，1：positive polarity
    .I_vs_pol    (1'b1               ),//VS polarity , 0:negetive ploarity，1：positive polarity
    .O_de        (tp0_de_in          ),   
    .O_hs        (tp0_hs_in          ),
    .O_vs        (tp0_vs_in          ),
    .O_data_r    (tp0_data_r         ),   
    .O_data_g    (tp0_data_g         ),
    .O_data_b    (tp0_data_b         )
);
//==============================================================================

`else

//==============================CAMERAS PROCESSING==============================
//memory interface
wire                   memory_clk         ;
wire                   dma_clk         	  ;
wire                   cmd_ready          ;
wire[2:0]              cmd                ;
wire                   cmd_en             ;
wire[5:0]              app_burst_number   ;
wire[ADDR_WIDTH-1:0]   addr               ;
wire                   wr_data_rdy        ;
wire                   wr_data_en         ;//
wire                   wr_data_end        ;//
wire[DATA_WIDTH-1:0]   wr_data            ;   
wire[DATA_WIDTH/8-1:0] wr_data_mask       ;   
wire                   rd_data_valid      ;  
wire                   rd_data_end        ;//unused 
wire[DATA_WIDTH-1:0]   rd_data            ;   
wire                   init_calib_complete;

`define	USE_THREE_FRAME_BUFFER
`define	DEF_ADDR_WIDTH 28 
`define	DEF_SRAM_DATA_WIDTH 128
//SRAM parameters
parameter ADDR_WIDTH          = `DEF_ADDR_WIDTH;    //存储单元是byte，总容量=2^27*16bit = 2Gbit,增加1位rank地址，{rank[0],bank[2:0],row[13:0],cloumn[9:0]}
parameter DATA_WIDTH          = `DEF_SRAM_DATA_WIDTH;   //与生成DDR3IP有关，此ddr3 2Gbit, x16， 时钟比例1:4 ，则固定128bit

wire off0_syn_de;

assign pix_data = off0_syn_de ? {off0_syn_data[4:0],3'b000,off0_syn_data[10:5],2'b00,off0_syn_data[15:11],3'b000}: 16'h0F550F;
wire video_clk;
assign video_clk = pix_clk;

wire[15:0] write_data;
//assign write_data = {cmos_2_16bit_data[4:0]>>1+cmos_1_16bit_data[4:0]>>1,cmos_2_16bit_data[10:5]>>1+cmos_1_16bit_data[10:5]>>1,cmos_2_16bit_data[15:11]>>1+cmos_1_16bit_data[15:11]>>1};
assign write_data = {cmos_16bit_data[4:0],cmos_16bit_data[10:5],cmos_16bit_data[15:11]};
//assign write_data = {cmos_1_16bit_data[4:0],cmos_1_16bit_data[10:5],cmos_1_16bit_data[15:11]};

wire[15:0] off0_syn_data;

wire[15:0]                      cmos_16bit_data;
assign cmos_16bit_data = gpio_in[0] ? cmos_2_16bit_data: cmos_1_16bit_data;

wire                            cmos_16bit_clk;
assign cmos_16bit_clk = gpio_in[0] ? cmos_2_16bit_clk: cmos_1_16bit_clk;

wire cam_vsync;
assign cam_vsync = gpio_in[0] ? cam_2_vsync: cam_1_vsync;

wire cmos_16bit_wr;
assign cmos_16bit_wr = gpio_in[0] ? cmos_2_16bit_wr: cmos_1_16bit_wr;

wire[15:0]                      cmos_1_16bit_data;
wire                            cmos_1_16bit_clk;

wire[15:0]                      cmos_2_16bit_data;
wire                            cmos_2_16bit_clk;
wire                            out_de;

cmos_8_16bit cmos_8_16bit_m0(
	.rst                        (~reset_n                 ),
	.pclk                       (cam_1_pclk               ),
	.pdata_i                    (cam_1_db                 ),
	.de_i                       (cam_1_href               ),
	.pdata_o                    (cmos_1_16bit_data        ),
	.hblank                     (cmos_1_16bit_wr          ),
	.de_o                       (cmos_1_16bit_clk         )
);

cmos_8_16bit cmos_8_16bit_m1(
	.rst                        (~reset_n                 ),
	.pclk                       (cam_2_pclk               ),
	.pdata_i                    (cam_2_db                 ),
	.de_i                       (cam_2_href               ),
	.pdata_o                    (cmos_2_16bit_data        ),
	.hblank                     (cmos_2_16bit_wr          ),
	.de_o                       (cmos_2_16bit_clk         )
);
wire                      syn_off0_vs;
wire                      syn_off0_hs;

assign tp0_vs_in = Pout_vs_dn[4];//syn_off0_vs;
assign tp0_hs_in = Pout_hs_dn[4];//syn_off0_hs;
assign tp0_de_in = Pout_de_dn[4];//off0_syn_de;

assign memory_clk = clk324;

vga_timing vga_timing_m0(
    .clk (pix_clk),
    .rst (~reset_n),
    // .active_x(lcd_x),
    // .active_y(lcd_y),
    .hs(syn_off0_hs),
    .vs(syn_off0_vs),
    .de(out_de)
);

Video_Frame_Buffer_Top Video_Frame_Buffer_Top_inst
( 
    .I_rst_n              (init_calib_complete ),//rst_n            ),
    .I_dma_clk            (dma_clk          ),   //sram_clk         ),
`ifdef USE_THREE_FRAME_BUFFER 
    .I_wr_halt            (1'd0             ), //1:halt,  0:no halt
    .I_rd_halt            (1'd0             ), //1:halt,  0:no halt
`endif
    // video data input             
    .I_vin0_clk           (cmos_16bit_clk  ),
    .I_vin0_vs_n          (~cam_vsync      ),//只接收负极性
    .I_vin0_de            (cmos_16bit_wr   ),
    .I_vin0_data          (write_data        ),
    .O_vin0_fifo_full     (                  ),

    // //测试图
    // .I_vin0_clk           (video_clk   ),
    // .I_vin0_vs_n          (~tp0_vs_in      ),//只接收负极性
    // .I_vin0_de            (tp0_de_in    ),
    // .I_vin0_data          ({tp0_data_r[7:3],tp0_data_g[7:2],tp0_data_b[7:3]} ),
    // .O_vin0_fifo_full     (                 ),

    // video data output            
    .I_vout0_clk          (video_clk        ),
    .I_vout0_vs_n         (~syn_off0_vs     ),//只接收负极性
    .I_vout0_de           (out_de           ),
    .O_vout0_den          (off0_syn_de      ),
    .O_vout0_data         (off0_syn_data    ),
    .O_vout0_fifo_empty   (                 ),
    // ddr write request
    .I_cmd_ready          (cmd_ready          ),
    .O_cmd                (cmd                ),//0:write;  1:read
    .O_cmd_en             (cmd_en             ),
    .O_app_burst_number   (app_burst_number   ),
    .O_addr               (addr               ),//[ADDR_WIDTH-1:0]
    .I_wr_data_rdy        (wr_data_rdy        ),
    .O_wr_data_en         (wr_data_en         ),//
    .O_wr_data_end        (wr_data_end        ),//
    .O_wr_data            (wr_data            ),//[DATA_WIDTH-1:0]
    .O_wr_data_mask       (wr_data_mask       ),
    .I_rd_data_valid      (rd_data_valid      ),
    .I_rd_data_end        (rd_data_end        ),//unused 
    .I_rd_data            (rd_data            ),//[DATA_WIDTH-1:0]
    .I_init_calib_complete(init_calib_complete)
); 


localparam N = 7; //delay N clocks
                          
reg  [N-1:0]  Pout_hs_dn   ;
reg  [N-1:0]  Pout_vs_dn   ;
reg  [N-1:0]  Pout_de_dn   ;

always@(posedge video_clk or negedge reset_n)
begin
    if(!reset_n)
        begin                          
            Pout_hs_dn  <= {N{1'b1}};
            Pout_vs_dn  <= {N{1'b1}}; 
            Pout_de_dn  <= {N{1'b0}}; 
        end
    else 
        begin                          
            Pout_hs_dn  <= {Pout_hs_dn[N-2:0],syn_off0_hs};
            Pout_vs_dn  <= {Pout_vs_dn[N-2:0],syn_off0_vs}; 
            Pout_de_dn  <= {Pout_de_dn[N-2:0],out_de}; 
        end
end

//===================================DDR3=======================================
DDR3MI DDR3_Memory_Interface_Top_inst 
(
    .clk                (video_clk          ),
    .memory_clk         (memory_clk         ),
    .pll_lock           (DDR_pll_lock       ),
    .rst_n              (reset_n            ), //rst_n
    .app_burst_number   (app_burst_number   ),
    .cmd_ready          (cmd_ready          ),
    .cmd                (cmd                ),
    .cmd_en             (cmd_en             ),
    .addr               (addr               ),
    .wr_data_rdy        (wr_data_rdy        ),
    .wr_data            (wr_data            ),
    .wr_data_en         (wr_data_en         ),
    .wr_data_end        (wr_data_end        ),
    .wr_data_mask       (wr_data_mask       ),
    .rd_data            (rd_data            ),
    .rd_data_valid      (rd_data_valid      ),
    .rd_data_end        (rd_data_end        ),
    .sr_req             (1'b0               ),
    .ref_req            (1'b0               ),
    .sr_ack             (                   ),
    .ref_ack            (                   ),
    .init_calib_complete(init_calib_complete),
    .clk_out            (dma_clk            ),
    .burst              (1'b1               ),
     
    .ddr_rst            (                 ),
    .O_ddr_addr         (ddr_addr         ),
    .O_ddr_ba           (ddr_bank         ),
    .O_ddr_cs_n         (ddr_cs         ),
    .O_ddr_ras_n        (ddr_ras        ),
    .O_ddr_cas_n        (ddr_cas        ),
    .O_ddr_we_n         (ddr_we         ),
    .O_ddr_clk          (ddr_ck          ),
    .O_ddr_clk_n        (ddr_ck_n        ),
    .O_ddr_cke          (ddr_cke          ),
    .O_ddr_odt          (ddr_odt          ),
    .O_ddr_reset_n      (ddr_reset_n      ),
    .O_ddr_dqm          (ddr_dm           ),
    .IO_ddr_dq          (ddr_dq           ),
    .IO_ddr_dqs         (ddr_dqs          ),
    .IO_ddr_dqs_n       (ddr_dqs_n        )
);
//==============================================================================
`endif


wire[9:0]                       lut_index;
wire[31:0]                      lut_data;
//configure look-up table
lut_ov5640_rgb565_1280_720 lut_ov5640_rgb565_1280_720_m0(
	.lut_index                  (lut_index                ),
	.lut_data                   (lut_data                 )
);
//I2C master controller
i2c_config i2c_config_m0(
	.rst                        (~reset_n                  ),
	.clk                        (clk                      ),
	.clk_div_cnt                (16'd500                  ),
	.i2c_addr_2byte             (1'b1                     ),
	.lut_index                  (lut_index                ),
	.lut_dev_addr               (lut_data[31:24]          ),
	.lut_reg_addr               (lut_data[23:8]           ),
	.lut_reg_data               (lut_data[7:0]            ),
	.error                      (                         ),
	.done                       (                         ),
	.i2c_scl                    (cmos_2_scl               ),
	.i2c_sda                    (cmos_2_sda               )
);

wire[9:0]                       lut_index_2;
wire[31:0]                      lut_data_2;
//configure look-up table
lut_ov5640_rgb565_1280_720 lut_ov5640_rgb565_1280_720_m1(
	.lut_index                  (lut_index_2                ),
	.lut_data                   (lut_data_2                 )
);
//I2C master controller
i2c_config i2c_config_m1(
	.rst                        (~reset_n                  ),
	.clk                        (clk                      ),
	.clk_div_cnt                (16'd500                  ),
	.i2c_addr_2byte             (1'b1                     ),
	.lut_index                  (lut_index_2                ),
	.lut_dev_addr               (lut_data_2[31:24]          ),
	.lut_reg_addr               (lut_data_2[23:8]           ),
	.lut_reg_data               (lut_data_2[7:0]            ),
	.error                      (                         ),
	.done                       (                         ),
	.i2c_scl                    (cmos_1_scl               ),
	.i2c_sda                    (cmos_1_sda               )
);
//===============================MIPI CSI-2=====================================
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
    .I_WC(16'd3840), //input [15:0] I_WC //d2400
    .I_VC(2'd0), //input [1:0] I_VC
    .I_DT(6'h24), //input [5:0] I_DT
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

MIPI_TX_Advance_Top mipi_tx_inst(
    .reset_n(reset_n),          //input reset_n                        

    .HS_CLK_P(HS_CLK_TX_p),     //output HS_CLK_P
    .HS_CLK_N(HS_CLK_TX_n),     //output HS_CLK_N
    .clk_data(8'b01010101),     //input [7:0] clk_data

    .clk_bit(hs_clk_p),           //input clk_bit
    .clk_bit_90(hs_clk),      //input clk_bit_90
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
//==============================================================================

endmodule
