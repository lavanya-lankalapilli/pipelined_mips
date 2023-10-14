module mips (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        output wire [31:0] wd_rf,
        output wire        we_dm_M,
        output wire [31:0] wd_dm_M,
        output wire [31:0] instr_E,
        output wire [31:0] instr_D,
        output  wire [31:0] instr_W,
        output wire [31:0] alu_out_M
    );
    
    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [2:0] alu_ctrl;
    // Newly added
    wire        rf_wd_hilo_sel;
    wire        mult_we;
    wire        mf_hilo_sel;
    wire        alu_src_sh_sel;
    wire        jr_sel;
    wire        jal_wd_sel;
    wire        jal_wa_sel;
    wire    [31:0] instr_M;
   // wire [31:0] instr_D;

    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3),
            .rf_wd_hilo_sel (rf_wd_hilo_sel),
            .mult_we        (mult_we),
            .mf_hilo_sel    (mf_hilo_sel),
            .alu_src_sh_sel (alu_src_sh_sel),
            .jr_sel         (jr_sel),
            .jal_wd_sel     (jal_wd_sel),
            .jal_wa_sel     (jal_wa_sel),
            .instr_D        (instr_D),
            .wd_rf          (wd_rf),
            .we_dm_M        (we_dm_M),
            .instr_E        (instr_E),
            .instr_M        (instr_M),
            .instr_W        (instr_W),
            .we_dm          (we_dm),
            .wd_dm_M        (wd_dm_M),
            .alu_out_M      (alu_out_M)
        );

    controlunit cu (
            .opcode         (instr_D[31:26]),
            .funct          (instr_D[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .rf_wd_hilo_sel (rf_wd_hilo_sel),
            .mult_we        (mult_we),
            .mf_hilo_sel    (mf_hilo_sel),
            .alu_src_sh_sel (alu_src_sh_sel),
            .jr_sel         (jr_sel),
            .jal_wd_sel     (jal_wd_sel),
            .jal_wa_sel     (jal_wa_sel)
        );

endmodule