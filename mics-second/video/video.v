`timescale 1ns / 1ps

module video(input CLK48M, input [8:1] SW, input [2:1] PSW, output [10:1] LED,
	     output [3:0] R, G, B, output HS, VS // VGA signals
	     );	    
   // Do not modify following lines
   reg CLK24M = 0;
   always @(posedge CLK48M) CLK24M <= ~CLK24M;
   assign LED[ 6] = 1;
   assign LED[ 8] = 1;
   assign LED[ 9] = ^SW;
   assign LED[10] = ^PSW;

   // LED
   assign LED[ 1] = VS;
   assign LED[ 2] = HS;

   // generate VGA video timing
   wire vde;
   wire [10:0] hcnt, vcnt;
   VGAtiming VGAtiming(CLK24M,SW[2],vde,HS,VS,hcnt,vcnt);
   assign R = vde==0 ? 0:Red[7:4];
   assign G = vde==0 ? 0:Green[7:4];
   assign B = vde==0 ? 0:Blue[7:4];
   
   // specify color for each pixel
   wire [7:0]  Red,Green,Blue;
   color color(CLK24M,SW[3],hcnt[9:0],vcnt[8:0],Red,Green,Blue,PSW[1],PSW[2]);
endmodule
