`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2023 05:43:11 PM
// Design Name: 
// Module Name: we_dreg
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


module we_dreg # (parameter WIDTH = 32) (
        input  wire             clk,
        input  wire             we,
        input  wire [WIDTH-1:0] d,
        output reg  [WIDTH-1:0] q
    );
    always @ (posedge clk, posedge we) begin
        if (we) q <= d;
        else     q <= q;
    end
endmodule