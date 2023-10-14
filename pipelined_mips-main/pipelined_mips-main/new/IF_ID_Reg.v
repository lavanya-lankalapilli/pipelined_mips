`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Lavanya
// 
// Create Date: 04/18/2023 03:33:40 PM
// Design Name: 
// Module Name: IF_ID_REG
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


module IF_ID_Reg(
    input wire clk,
    input wire [31:0] instr_F,
    input wire [31:0] pc_plus4_F,
    input wire stall,
    output reg [31:0] instr_D,
    output reg [31:0] pc_plus4_D
);
integer n;
initial begin
    pc_plus4_D = 32'h0;
    instr_D = 32'h0;
end
always @ (posedge clk) begin
    if (stall) begin
      pc_plus4_D <= pc_plus4_D;  // No change during stall
      instr_D <= instr_D;        // No change during stall
    end else begin
      pc_plus4_D = pc_plus4_F;
      instr_D = instr_F;
    end
end
endmodule