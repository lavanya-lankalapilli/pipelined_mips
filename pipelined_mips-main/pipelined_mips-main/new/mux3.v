`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lavanya
// 
// Create Date: 05/25/2023 11:37:02 PM
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 8) (
  input  wire  [1:0]           sel,
  input  wire [WIDTH-1:0] a,
  input  wire [WIDTH-1:0] b,
  input  wire [WIDTH-1:0] c,
  output wire [WIDTH-1:0] y
);

  assign y = (sel == 2'b00) ? a : (sel == 2'b01) ? b : c;

endmodule