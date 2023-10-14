module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        input  wire [31:0]  instr_D,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire [2:0]  alu_ctrl,
        output wire        rf_wd_hilo_sel,
        output wire        mult_we,
        output wire        mf_hilo_sel,
        output wire        alu_src_sh_sel,
        output wire        jr_sel,
        output wire        jal_wd_sel,
        output wire        jal_wa_sel
    );
    
    wire [1:0] alu_op;

    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op),
        .jal_wd_sel     (jal_wd_sel),
        .jal_wa_sel     (jal_wa_sel)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .rf_wd_hilo_sel (rf_wd_hilo_sel),
        .mult_we        (mult_we),
        .mf_hilo_sel    (mf_hilo_sel),
        .alu_src_sh_sel (alu_src_sh_sel),
        .jr_sel         (jr_sel)
    );

endmodule