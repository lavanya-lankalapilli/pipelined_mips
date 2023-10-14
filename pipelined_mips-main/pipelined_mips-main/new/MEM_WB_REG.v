`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lavanya
// 
// Create Date: 05/09/2023 09:52:12 PM
// Design Name: 
// Module Name: MEM_WB_REG
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


module MEM_WB_REG(
    input wire clk,
    input wire we_reg_M,
    input wire dm2reg_M,
    input wire jal_wd_sel_M,
    input wire rf_wd_hilo_sel_M,
    input wire mf_hilo_sel_M,
    input wire [31:0] pc_plus4_M,
    input wire [31:0] rd_dm_M,
    input wire [31:0] alu_out_M,
    input wire [31:0] mult_hi_M,
    input wire [31:0] mult_lo_M,
    input wire [4:0]  rf_jal_wa_out_M,
    input wire [31:0] instr_M,
    
    output reg we_reg_W,
    output reg dm2reg_W,
    output reg jal_wd_sel_W,
    output reg rf_wd_hilo_sel_W,
    output reg mf_hilo_sel_W,
    output reg [31:0] pc_plus4_W,
    output reg [31:0] rd_dm_W,
    output reg [31:0] alu_out_W,
    output reg [31:0] mult_hi_W,
    output reg [31:0] mult_lo_W,
    output reg [4:0]  rf_jal_wa_out_W,
    output reg [31:0] instr_W
    );


initial begin
    we_reg_W = 1'h0;
    dm2reg_W = 1'h0;
    jal_wd_sel_W = 1'h0;
    rf_wd_hilo_sel_W = 1'h0;
    mf_hilo_sel_W = 1'h0;
    pc_plus4_W = 32'h0;
    rd_dm_W = 32'h0;
    alu_out_W = 32'h0;
    mult_hi_W = 32'h0;
    mult_lo_W = 32'h0;
    rf_jal_wa_out_W = 5'h0;
    instr_W = 32'h0;
end

always @(posedge clk) begin
    we_reg_W = we_reg_M;
    dm2reg_W = dm2reg_M;
    jal_wd_sel_W = jal_wd_sel_M;
    rf_wd_hilo_sel_W = rf_wd_hilo_sel_M;
    mf_hilo_sel_W = mf_hilo_sel_M;
    pc_plus4_W = pc_plus4_M;
    rd_dm_W = rd_dm_M;
    alu_out_W = alu_out_M;
    mult_hi_W = mult_hi_M;
    mult_lo_W = mult_lo_M;
    rf_jal_wa_out_W = rf_jal_wa_out_M;
    instr_W = instr_M;
end
endmodule








