

`define C_NUM_QUADS 1
`define C_REFCLKS_USED 1
module example_ibert_7series_gtp_0
(
  // GT top level ports
    output  wire [1:0] tx_en,
  output [(4*`C_NUM_QUADS)-1:0]		TXN_O,
  output [(4*`C_NUM_QUADS)-1:0]		TXP_O,
  input  [(4*`C_NUM_QUADS)-1:0]    	RXN_I,
  input  [(4*`C_NUM_QUADS)-1:0]   	RXP_I,
  input                           	SYSCLKP_I,
  input  [`C_REFCLKS_USED-1:0]        	GTREFCLK0P_I,
  input  [`C_REFCLKS_USED-1:0]        	GTREFCLK0N_I,
  input  [`C_REFCLKS_USED-1:0]        	GTREFCLK1P_I,
  input  [`C_REFCLKS_USED-1:0]        	GTREFCLK1N_I
);
assign tx_en=2'd0;
  //
  // Ibert refclk internal signals
  //
  wire   [`C_NUM_QUADS-1:0]        	gtrefclk0_i;
  wire   [`C_NUM_QUADS-1:0]        	gtrefclk1_i;
  wire   [`C_REFCLKS_USED-1:0]        	refclk0_i;
  wire   [`C_REFCLKS_USED-1:0]        	refclk1_i;
  wire                            	sysclk_i;

  //
  // Refclk IBUFDS instantiations
  //

    IBUFDS_GTE2 u_buf_q0_clk0
      (
        .O            (refclk0_i[0]),
        .ODIV2        (),
        .CEB          (1'b0),
        .I            (GTREFCLK0P_I[0]),
        .IB           (GTREFCLK0N_I[0])
      );

    IBUFDS_GTE2 u_buf_q0_clk1
      (
        .O            (refclk1_i[0]),
        .ODIV2        (),
        .CEB          (1'b0),
        .I            (GTREFCLK1P_I[0]),
        .IB           (GTREFCLK1N_I[0])
      );

  //
  // Refclk connection from each IBUFDS to respective quads depending on the source selected in gui
  //
  assign gtrefclk0_i[0] = refclk0_i[0];
  assign gtrefclk1_i[0] = refclk1_i[0];



  //
  // Sysclock connection
  //
  assign sysclk_i = SYSCLKP_I;


  //
  // IBERT core instantiation
  //
  ibert_7series_gtp_0 u_ibert_core
    (
      .TXN_O(TXN_O),
      .TXP_O(TXP_O),
      .RXN_I(RXN_I),
      .RXP_I(RXP_I),
      .SYSCLK_I(sysclk_i),
      .GTREFCLK0_I(gtrefclk0_i),
      .GTREFCLK1_I(gtrefclk1_i)
    );

endmodule
