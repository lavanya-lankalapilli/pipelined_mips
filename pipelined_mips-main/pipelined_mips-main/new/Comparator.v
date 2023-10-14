`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lavanya
// 
// Create Date: 05/25/2023 04:51:30 PM
// Design Name: 
// Module Name: Comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Comparator(
  input wire [31:0] a,
  input wire [31:0] b,
  output reg eq  // equal
);

  always @* begin
    if (a == b)
      eq = 1'b1;
    else
      eq = 1'b0;
  end

endmodule


