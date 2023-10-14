`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Lavanya 
// 
// Create Date: 05/25/2023 03:22:29 PM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
    input  wire clk,
    input  wire branchD,
    input  wire we_regM,
    input  wire [4:0]   rsD,
    input  wire [4:0]   rtD,
    input  wire [4:0]   rsE,
    input  wire [4:0]   rtE,
    input  wire [4:0]   rf_waM,
    input  wire [4:0]   rf_waW,
    input  wire we_regE,
    input  wire we_regW,
    input  wire dm2regM,
    input  wire [4:0]   rf_waE,
    output reg ForwardAD,
    output reg ForwardBD,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg branchstall,
    output reg stallF,
    output reg stallD,
    output reg flushE
);

initial begin
    ForwardAD = 1'h0;
    ForwardBD = 1'h0;
    ForwardAE = 2'h00;
    ForwardBE = 2'h00;
    branchstall = 1'h0;
    stallF = 1'h0;
    stallD = 1'h0;
    flushE = 1'h0;
end
always @(*) begin
    ForwardAD = branchD & we_regM & (rsD != 0) & (rf_waM == rsD);
    ForwardBD = branchD & we_regM & (rtD != 0) & (rf_waM == rtD);
    if (we_regM && (rsE != 0) && (rf_waM == rsE))
        ForwardAE = 2'b10;
    else if (we_regW && (rsE != 0) && (rf_waW == rsE))
        ForwardAE = 2'b01;
    else
         ForwardAE = 2'h00;
    if (we_regM && (rtE != 0) && (rf_waM == rtE))
        ForwardBE = 2'b10;
    else if (we_regW && (rtE != 0) && (rf_waW == rtE))
        ForwardBE = 2'b01; 
    else
         ForwardBE = 2'h00;
    
    branchstall = (branchD & we_regE & ((rf_waE == rsD) || (rf_waE == rtD))) ||
                      (branchD & dm2regM & ((rf_waM == rsD) || (rf_waM == rtD)));
    // change these to lwstall || branchstall
    stallF = branchstall;
    stallD = branchstall;
    flushE = branchstall;
end

endmodule










