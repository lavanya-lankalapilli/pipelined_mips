`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lavanya 
// 
// Create Date: 05/09/2023 02:38:02 PM
// Design Name: 
// Module Name: EXE_MEM_REG
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


module EXE_MEM_REG(
    input wire clk,
    // control signals
    input wire jump_E,
    input wire we_reg_E,
    input wire we_dm_E,
    input wire dm2reg_E,
    //input wire jr_sel_E,
    input wire jal_wd_sel_E,
    input wire rf_wd_hilo_sel_E,
    input wire mult_we_E,
    input wire mf_hilo_sel_E,
    
    // data wires
    input wire [31:0] pc_plus4_E,
    input wire [31:0] alu_out_E,
    input wire [31:0] wd_dm_E,
    input wire [63:0] prod_E,
    input wire [4:0]  rf_jal_wa_out_E,
    input wire [31:0] instr_E,
    //input wire [31:0] alu_pa_E,
    
    // output
    output reg jump_M,
    output reg we_reg_M,
    output reg we_dm_M,
    output reg dm2reg_M,
    //output reg jr_sel_M,
    output reg jal_wd_sel_M,
    output reg rf_wd_hilo_sel_M,
    output reg mult_we_M,
    output reg mf_hilo_sel_M,
    output reg [31:0] pc_plus4_M,
    output reg [31:0] alu_out_M,
    output reg [31:0] wd_dm_M,
    output reg [63:0] prod_M,
    output reg [4:0]  rf_jal_wa_out_M,
    output reg [31:0] instr_M
    //output reg [31:0] alu_pa_M
);

initial begin
    pc_plus4_M = 32'h0;
    alu_out_M = 32'h0;
    wd_dm_M = 32'h0;
    prod_M = 64'h0;
    rf_jal_wa_out_M = 5'h0;
    instr_M = 32'h0;
    //alu_pa_M= 32'h0;
    
    jump_M = 1'h0;
    we_reg_M = 1'h0;
    we_dm_M = 1'h0;
    dm2reg_M = 1'h0;
    jal_wd_sel_M = 1'h0;
    rf_wd_hilo_sel_M = 1'h0;
    mult_we_M = 1'h0;
    mf_hilo_sel_M = 1'h0;
end

always @(posedge clk) begin
    pc_plus4_M = pc_plus4_E;
    alu_out_M = alu_out_E;
    wd_dm_M = wd_dm_E;
    prod_M = prod_E;
    rf_jal_wa_out_M = rf_jal_wa_out_E;
    instr_M = instr_E;
    //alu_pa_M= 32'h0;
    
    jump_M = jump_E;
    we_reg_M = we_reg_E;
    we_dm_M = we_dm_E;
    dm2reg_M = dm2reg_E;
    jal_wd_sel_M = jal_wd_sel_E;
    rf_wd_hilo_sel_M = rf_wd_hilo_sel_E;
    mult_we_M = mult_we_E;
    mf_hilo_sel_M = mf_hilo_sel_E;
end
endmodule
