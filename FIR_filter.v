`timescale 1ns / 1ps
module FIR_filter #(
    parameter  N1   = 8,   // number of taps
    parameter  N2 = 16 ,
    parameter integer N3  = 32   // accumulator / output width (signed)
)(
    input  wire                      clk,
    input  wire                      rst,
    input  wire                      enable,
    input  wire signed [N2-1:0]    input_data,
    output  signed [N3-1:0]   sampleT,
   output   signed [N3-1:0] output_data
);
  reg signed [N3-1:0] output_data_reg;
  reg signed [N1-1:0] b [0:7] ;
  reg signed [N2-1:0] samples[0:6] ;
  integer i ;
  
  

        
   initial 
   begin   $readmemb("C:/ABHISHEK/python project folder/coeff.txt", b);

      end
   
    always @(posedge clk ) begin
        if (rst) begin
            for (i = 0; i < N1; i = i + 1) 
            samples[i]= 7'b0 ;
            output_data_reg<= 0 ;
            
        end
         else if (enable) begin
            output_data_reg<=b[0]*input_data 
                            +b[1]*samples[0]
                            +b[2]*samples[1]
                            +b[3]*samples[2]
                            +b[4]*samples[3]
                            +b[5]*samples[4]
                            +b[6]*samples[5]
                            +b[7]*samples[6] ;
               
              samples[0]<=input_data ;
              samples[1]<=samples[0] ;
              samples[2]<=samples[1] ;
              samples[3]<=samples[2] ;
              samples[4]<=samples[3] ;
              samples[5]<=samples[4] ;
              samples[6]<=samples[5] ;
              end
              end
              
         assign output_data=output_data_reg ;
         assign sampleT=samples[0];
              endmodule
              
              
                            
                