`timescale 1ns / 1ps

module tetris(input CLK48M, input [8:1] SW, input [2:1] PSW, output [10:1] LED,
	      output [3:0] R, G, B, output HS, VS // VGA signals
	      );	    
   // Do not modify following lines
   wire SPEAKER;
   reg CLK24M = 0;
   always @(posedge CLK48M) CLK24M <= ~CLK24M;
   assign LED[ 2] = SPEAKER;
   assign LED[ 5] = SPEAKER;
   assign LED[ 6] = 1;
   assign LED[ 8] = 1;
   assign LED[ 9] = ^SW;
   assign LED[10] = ^PSW;
   
   // generate VGA video timing
   wire vde;
   wire [10:0] hnt, vnt;
   VGAtiming VGAtiming(CLK24M,SW[2],vde,HS,VS,hnt,vnt);
   assign R = vde==0 ? 0:Red[7:4];
   assign G = vde==0 ? 0:Green[7:4];
   assign B = vde==0 ? 0:Blue[7:4];
   
   // specify color for each pixel
   wire [7:0]  Red,Green,Blue;
   color color(CLK24M,SW[3],hnt[9:0],vnt[8:0],Red,Green,Blue,PSW[1],PSW[2]);

   // sound
   sound sound(CLK24M, ~SW[1], PSW, SPEAKER);
endmodule
