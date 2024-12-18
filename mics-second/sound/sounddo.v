module sounddo(input CLK24M, input RESET, input [2:1] PSW, output SPEAKER);
   reg [15:0] count = 0;
   reg 	      s;
   always @(posedge CLK24M) begin
      if(RESET==1) begin
			count <= 0;
			s <= 0;
      end else if(count==45865) begin
			count <= 0;
			s <= ~s;
      end else begin
			count <= count + 1;
      end
   end
   assign SPEAKER = s;
endmodule

/*
module soundSim;
   wire CLK24M,speaker;
   reg [2:1] psw;
   reg       reset;
   clock_24MHz clock_24MHz(CLK24M);
   sound sound(CLK24M,reset,psw,speaker);
   initial begin
      $display("reset  speaker  time(ns)");
      $monitor(" %b        %b   ",reset,speaker,$stime);
      psw = 2'b00;
      @(posedge CLK24M) reset = 1;
      @(posedge CLK24M) reset = 0;
      #20000000;
      $finish;
   end
endmodule // soundSim
*/
