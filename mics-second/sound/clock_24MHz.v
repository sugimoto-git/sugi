module clock_24MHz(output reg clk_24MHz);
   initial clk_24MHz = 0;
   always  #21 clk_24MHz = ~clk_24MHz; // 1/(24x10^6) ~= 42nsec 
endmodule