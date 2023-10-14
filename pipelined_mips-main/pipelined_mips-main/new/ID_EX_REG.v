`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lavanya 
// 
// Create Date: 05/02/2023 10:49:37 AM
// Design Name: 
// Module Name: ID_EX_REG
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


module ID_EXE_REG(
    input wire clk,
    input wire [31:0] pc_plus4_D,
    input wire [31:0] senext_imm_D,
    input wire [31:0] alu_pa_D,
    input wire [31:0] wd_dm_D,
    input wire [31:0] instr_D,  
    input wire [2:0]  alu_ctrl_D,
    input wire rf_wd_hilo_sel_D,
    input wire alu_src_D,
    input wire branch_D,
    input wire jump_D,
    input wire we_dm_D,
    input wire dm2reg_D,
    input wire jr_sel_D,
    input wire jal_wd_Sel_D,
    input wire alu_src_sh_sel_D,
    input wire mult_we_D,
    input wire mf_hilo_sel_D,
    input wire we_reg_D,
    input wire [4:0]  rf_jal_wa_out_D,
    input wire flush,
    
    output reg [31:0] pc_plus4_E,
    output reg [31:0] alu_pa_E,
    output reg [31:0] wd_dm_E,
    output reg [31:0] senext_imm_E,
    output reg [31:0] instr_E, 
    output reg [4:0]  rf_jal_wa_out_E,
    output reg [2:0]  alu_ctrl_E,
    output reg rf_wd_hilo_sel_E,
    output reg alu_src_E,
    output reg branch_E,
    output reg jump_E,
    output reg we_dm_E,
    output reg dm2reg_E,
    output reg jr_sel_E,
    output reg jal_wd_Sel_E,
    output reg alu_src_sh_sel_E,
    output reg mult_we_E,
    output reg mf_hilo_sel_E,
    output reg we_reg_E
);
integer i;

initial begin
    pc_plus4_E = 32'h0;
    alu_pa_E = 32'h0;
    wd_dm_E = 32'h0;
    senext_imm_E = 32'h0;
    instr_E = 32'h0; 
    rf_jal_wa_out_E = 5'h0;
    alu_ctrl_E= 3'h0;
    rf_wd_hilo_sel_E = 1'h0;
    alu_src_E = 1'h0;
    branch_E = 1'h0;
    jump_E = 1'h0;
    we_dm_E = 1'h0;
    dm2reg_E = 1'h0;
    jr_sel_E = 1'h0;
    jal_wd_Sel_E = 1'h0;
    alu_src_sh_sel_E = 1'h0;
    mult_we_E = 1'h0;
    mf_hilo_sel_E = 1'h0;
    we_reg_E = 1'h0;
end

always @(posedge clk) begin
    if (flush) begin
        pc_plus4_E <= 32'h0;       // Reset to initial values during flush
        alu_pa_E <= 32'h0;
        wd_dm_E <= 32'h0;
        senext_imm_E <= 32'h0;
        instr_E <= 32'h0; 
        rf_jal_wa_out_E <= 5'h0;
        alu_ctrl_E <= 3'h0;
        rf_wd_hilo_sel_E <= 1'h0;
        alu_src_E <= 1'h0;
        branch_E <= 1'h0;
        jump_E <= 1'h0;
        we_dm_E <= 1'h0;
        dm2reg_E <= 1'h0;
        jr_sel_E <= 1'h0;
        jal_wd_Sel_E <= 1'h0;
        alu_src_sh_sel_E <= 1'h0;
        mult_we_E <= 1'h0;
        mf_hilo_sel_E <= 1'h0;
        we_reg_E <= 1'h0;
    end 
    else begin
        alu_pa_E = alu_pa_D;
        wd_dm_E = wd_dm_D;
        senext_imm_E = senext_imm_D;
        instr_E = instr_D;
        pc_plus4_E = pc_plus4_D;
        rf_jal_wa_out_E = rf_jal_wa_out_D;
        alu_ctrl_E = alu_ctrl_D;
        rf_wd_hilo_sel_E = rf_wd_hilo_sel_D;
        alu_src_E = alu_src_D;
        branch_E = branch_D;
        jump_E = jump_D;
        we_dm_E = we_dm_D;
        dm2reg_E = dm2reg_D;
        jr_sel_E = jr_sel_D;
        jal_wd_Sel_E = jal_wd_Sel_D;
        alu_src_sh_sel_E = alu_src_sh_sel_D;
        mult_we_E = mult_we_D;
        mf_hilo_sel_E = mf_hilo_sel_D;
        we_reg_E = we_reg_D;
    end
end

endmodule
