`timescale 1ns / 1ps

`define RESOLUTION 8   // 8-bit accuracy
`define SAMELEVEL  12  // 24M (clock frequency) / 8kHz (sampling rate of sound) / ( 2^8 ) = 12

module pwm(input CLK, input RESET, input [2:1] PSW, output SPEAKER); 
   wire play = PSW[2]; // play 0 - no sound, 1 - play sound
   reg [`RESOLUTION - 1:0] r = 0, rold = 0, dold = 0;
   wire [`RESOLUTION - 1:0] d;
   reg [3:0] 		    l = 0;
   reg [13:0] 		    i = 0;
   reg 			    p = 0, playold = 0;
   reg [1:0] 		    state = 0;
   // 0 - idle
   // 1 - reading first sound data
   // 2 - playing sound
   
   data data(CLK,i,d);
   always @(posedge CLK) begin
      playold <= play;
      dold    <= d;
      if(RESET == 1) begin
	 state <= 0;
      end else if(state == 0) begin // idle
         r <= 0;
         l <= 0;
         i <= 0;
         p <= 0;
         rold <= 0;
         if(playold == 0 && play == 1) begin
            state <= 1;
            i <= 0;
         end
      end else if(state == 1) begin
         state <= 2;
      end else if(state == 2) begin
         r <= r + 1;
         rold <= r;
         if(r == (1<<`RESOLUTION) - 1) begin
            if(l == `SAMELEVEL - 1) begin
               l <= 0;
               i <= i + 1;
            end else begin
               l <= l + 1;
            end
         end
         if(d > rold) begin
            p <= 1;
         end else begin
            p <= 0;
         end
         if(d == 0) begin
            state <= 0;
         end 
      end
   end
   assign SPEAKER = p;
endmodule

module data(input CLK, input [13:0] A, output [7:0] Dout);
   reg [7:0] rom [0:16383];
   reg [7:0] romo;
   initial begin
      $readmemh("countdown4_8k_4.hex",rom);
   end
   always @(posedge CLK) begin
      romo <= rom[A[13:0]];
   end
   assign Dout = romo;
endmodule 
