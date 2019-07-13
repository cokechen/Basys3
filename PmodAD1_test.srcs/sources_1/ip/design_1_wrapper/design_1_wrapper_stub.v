// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1733598 Wed Dec 14 22:35:39 MST 2016
// Date        : Fri Jul 12 16:49:02 2019
// Host        : Daenerys-670 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Git_workspace/vivado_work/PmodAD1_test/PmodAD1_test.srcs/sources_1/ip/design_1_wrapper/design_1_wrapper_stub.v
// Design      : design_1_wrapper
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module design_1_wrapper(clk_out1, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_in1" */;
  output clk_out1;
  input clk_in1;
endmodule
