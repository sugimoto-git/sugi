module soundle(input CLK24M, input RESET, input [2:1] PSW, output SPEAKER);
   reg [15:0] count = 0;
   reg 	      s;
   always @(posedge CLK24M) begin
      if(RESET==1) begin
			count <= 0;
			s <= 0;
      end else if(count==40863) begin
			count <= 0;
			s <= ~s;
      end else begin
			count <= count + 1;
      end
   end
   assign SPEAKER = s;
endmodule



