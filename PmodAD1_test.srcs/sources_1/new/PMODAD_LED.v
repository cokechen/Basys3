     
module PMODAD_LED(
        input clk,sw0,
      //  output  reg  [3:0] LED  ,
        input  ADC_sdata0, ADC_sdata1,
        output  ADC_sclk,ADC_csn,
        output [3:0] an,
        output dp,
         output [6:0] seg
            
    );
    
  wire  [11:0]  adc_res0, adc_res1;
   reg [15:0]data;
     wire     adc_valid;
     wire clk35M ;
     
     
   always@(posedge clk35M) begin
     if (adc_valid) begin
            data<=(sw0==1) ? {adc_res0[11:0],4'b0000} :{adc_res1[11:0],4'b0000};
      end
   end
 
    
 
 
    design_1_wrapper uu(
                         .clk_in1( clk ) ,                  .clk_out1( clk35M )
                     );
                        
                         reg [32:0] count;
                         localparam S_IDLE = 0;
                         localparam S_FRAME_WAIT = 1;
                         localparam S_CONVERSION = 2;
                         reg [1:0] state = S_IDLE;
                         reg [15:0] sseg_data;
                         
                         //binary to decimal converter signals
                         reg b2d_start;
                         reg [15:0] b2d_din;
                         wire [15:0] b2d_dout;
                         wire b2d_done;
          //binary to decimal conversion
                            always @ (posedge(clk35M)) begin
                                case (state)
                                S_IDLE: begin
                                    state <= S_FRAME_WAIT;
                                    count <= 'b0;
                                end
                                S_FRAME_WAIT: begin
                                    if (count >= 10000000) begin
                                        if (data > 16'hFFD0) begin
                                            sseg_data <= 16'h1000;
                                            state <= S_IDLE;
                                        end else begin
                                            b2d_start <= 1'b1;
                                            b2d_din <= data;     //sampling result
                                            state <= S_CONVERSION;
                                        end
                                    end else
                                        count <= count + 1'b1;
                                end
                                S_CONVERSION: begin
                                    b2d_start <= 1'b0;
                                    if (b2d_done == 1'b1) begin
                                        sseg_data <= b2d_dout;   //convert result (4*segment BCD)
                                        state <= S_IDLE;
                                    end
                                end
                                endcase
                            end
                            
                            bin2dec m_b2d (
                                .clk(clk35M),
                                .start(b2d_start),
                                .din(b2d_din),
                                .done(b2d_done),
                                .dout(b2d_dout)
                            );
    
  
//    always @ (posedge clk35M)if (adc_valid) LED <= ( sw0 == 1 )  ?  adc_res0[11:8]   :  adc_res1[11:8]  ;
    
    ad7476_sample  u1(
                       .clk( clk35M )  ,
                       .rst( 1'b0 )  ,
                       .ADC_sdata0(ADC_sdata0  )  ,
                       .ADC_sdata1(ADC_sdata1  )  ,
                       .ADC_sclk(ADC_sclk  )  ,
                       .ADC_csn(ADC_csn  )  ,
                       .adc_res0(adc_res0  )  ,
                       .adc_res1(adc_res1  )  ,
                       .adc_valid(adc_valid  )
                   );
                   
          DigitToSeg segment1(    //used to display
                         .in1(sseg_data[3:0]),
                         .in2(sseg_data[7:4]),
                         .in3(sseg_data[11:8]),
                         .in4(sseg_data[15:12]),
                         .in5(),
                         .in6(),
                         .in7(),
                         .in8(),
                         .mclk(clk35M),
                         .an(an),
                         .dp(dp),
                         .seg(seg)
                     );           
                   
                   
 
endmodule
 