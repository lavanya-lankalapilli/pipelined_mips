module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire [2:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        output  wire [31:0] instr_D,
        output  wire [31:0] instr_E,
        output  wire [31:0] instr_M,
        output  wire [31:0] instr_W,
        
        
        // --- Newly added wires --- //
        // New input wires
        input   wire    mult_we,        // wire to load the hi and lo registers
        input   wire    mf_hilo_sel,   // wire to sel hi or lo registers => 0: hi & 1: lo
        input   wire    rf_wd_hilo_sel,     // wire to sel between output of rd_wd_mux and hi/lo mux
        input   wire    alu_src_sh_sel,     // wire to sel between alu_pb and shift amount as second amount to ALU
        input   wire    jr_sel,         // wire to select mux that outputs alu_pa ie. rd1 as pc_next 
        input   wire    jal_wd_sel,
        input   wire    jal_wa_sel,
        
        output wire [31:0] wd_rf,
        input wire        we_dm,
        output wire we_dm_M,
        output wire [31:0] wd_dm_M,
        output wire [31:0] alu_out_M
    );

    wire [4:0]  rf_wa;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    //wire [31:0] wd_rf;
    wire        zero;
    //wire we_dm_D = we_dm;
    
     // --- Newly added wires --- //
    wire [63:0] product;  // wire carrying the product
    wire [31:0] mult_hi;  // wire carrying the higher 32 bits of the product
    wire [31:0] mult_lo;  // wire carrying the lower 32 bits of the product
    wire [31:0] mul_mf_res;  // wire carrying the hi/lo contents
    wire [31:0] rf_wd_mux_out;  // wire carrying the output of the rf_wd_mux
    wire [31:0] alu_b;  // wire carrying the output of the rf_wd_mux
    wire [31:0] alu_a;  // wire carrying the input a for alu and output of alu_pa_wd_dm_mux
    wire [31:0] pc_jmp_out;       // wire carrying pc_pre or jta
    wire [31:0] hi_lo_alu_dm_out; // wire carrying hi or lo or alu_out or rd_dm output
    wire [4:0]  rf_jal_wa_out;    // wire carrying instr[20:16], instr[15:11] or register number 31
    
    
    //exe wires
    wire rf_wd_hilo_sel_E;
    wire alu_src_E;
    wire branch_E;
    wire jump_E;
    wire dm2reg_E;
    wire jr_sel_E;
    wire jal_wd_Sel_E;
    wire alu_src_sh_sel_E;
    wire mult_we_E;
    wire mf_hilo_sel_E;
    wire we_reg_E;
    wire [31:0] pc_plus4_E;
    wire [31:0] alu_pa_E;
    wire [31:0] senext_imm_E;
    wire [4:0]  rf_jal_wa_out_E;
    wire [2:0] alu_ctrl_E;
    wire [31:0] wd_dm_E;
    wire we_dm_E;
    
    //mem wires
    wire jump_M;
    wire we_reg_M;
    //wire we_dm_M;
    wire dm2reg_M;
    wire jal_wd_sel_M;
    wire rf_wd_hilo_sel_M;
    wire mult_we_M;
    wire mf_hilo_sel_M;
    wire [31:0] pc_plus4_M;
    //wire [31:0] alu_out_M;
    //wire [31:0] wd_dm_M;
    wire [63:0] prod_M;
    wire [4:0]  rf_jal_wa_out_M;
    
    // write back signals
    wire we_reg_W;
    wire dm2reg_W;
    wire jal_wd_sel_W;
    wire rf_wd_hilo_sel_W;
    wire mf_hilo_sel_W;
    wire [31:0] pc_plus4_W;
    wire [31:0] rd_dm_W;
    wire [31:0] alu_out_W;
    wire [31:0] mult_hi_W;
    wire [31:0] mult_lo_W;
    wire [4:0] rf_jal_wa_out_W;
    
    // Hazard Unit wires
    wire ForwardAD;
    wire ForwardBD; 
    wire branchStall;
    wire stallF;
    wire stallD;
    wire flushE;   
    wire [31:0] branch_op1;
    wire [31:0] branch_op2;
    wire [31:0] pc_plus4_F;
    
    // Data forwarding wires
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire [31:0] mux_AE_op;
    wire [31:0] mux_BE_op;
    
    assign jta = {pc_plus4[31:28], instr_E[25:0], 2'b00};
    wire [31:0] sh_amt = {27'b0, instr_E[10:6]}; // wire carrying the shift amount
    
    // wires for if_id
    wire [31:0] pc_plus4_D;
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current),
            .stall          (stallF)
        );
        
        // mux to select (pc_pre or jta) or alu_pa (ie. rd1) as data on wire pc_next    
    mux2 #(32) pc_jr_mux (
            .sel            (jr_sel_E), //jr_sel
            .a              (pc_jmp_out),
            .b              (alu_pa_E),
            .y              (pc_next)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4_D),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        );

    mux2 #(32) pc_jmp_mux (
            .sel            (jump_E), //jump
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_jmp_out)
        );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr_D[20:16]),
            .b              (instr_D[15:11]),
            .y              (rf_wa)
        );
        
        IF_ID_Reg if_id_reg(
            .clk(clk),
            .instr_F(instr),
            .pc_plus4_F(pc_plus4),
            .instr_D(instr_D),
            .pc_plus4_D(pc_plus4_D),
            .stall(stallD)
        );
         
        
         
       ID_EXE_REG id_exe_reg(
            .clk(clk),
            .pc_plus4_D(pc_plus4_D),
            .alu_pa_D(alu_pa),
            .wd_dm_D(wd_dm),
            .senext_imm_D(sext_imm),
            .instr_D(instr_D),
            .rf_jal_wa_out_D(rf_jal_wa_out),
            .alu_ctrl_D(alu_ctrl),
            .rf_wd_hilo_sel_D(rf_wd_hilo_sel),
            .alu_src_D(alu_src),
            .branch_D(branch),
            .jump_D(jump),
            .we_dm_D(we_dm),
            .dm2reg_D(dm2reg),
            .jr_sel_D(jr_sel),
            .jal_wd_Sel_D(jal_wd_sel),
            .alu_src_sh_sel_D(alu_src_sh_sel),
            .mult_we_D(mult_we),
            .mf_hilo_sel_D(mf_hilo_sel),
            .we_reg_D(we_reg),
            .pc_plus4_E(pc_plus4_E),
            .alu_pa_E(alu_pa_E),
            .wd_dm_E(wd_dm_E),
            .senext_imm_E(senext_imm_E),
            .instr_E(instr_E),
            .rf_jal_wa_out_E(rf_jal_wa_out_E),
            .alu_ctrl_E(alu_ctrl_E),
            .rf_wd_hilo_sel_E(rf_wd_hilo_sel_E),
            .alu_src_E(alu_src_E),
            .branch_E(branch_E),
            .jump_E(jump_E),
            .we_dm_E(we_dm_E),
            .dm2reg_E(dm2reg_E),
            .jr_sel_E(jr_sel_E),
            .jal_wd_Sel_E(jal_wd_Sel_E),
            .alu_src_sh_sel_E(alu_src_sh_sel_E),
            .mult_we_E(mult_we_E),
            .mf_hilo_sel_E(mf_hilo_sel_E),
            .we_reg_E(we_reg_E),
            .flush(flushE)
        );
        
        EXE_MEM_REG exe_mem_reg(
            .clk(clk),
            .jump_E(jump_E),
            .we_reg_E(we_reg_E),
            .we_dm_E(we_dm_E),
            .dm2reg_E(dm2reg_E),
            .jal_wd_sel_E(jal_wd_Sel_E),
            .rf_wd_hilo_sel_E(rf_wd_hilo_sel_E),
            .mult_we_E(mult_we_E),
            .mf_hilo_sel_E(mf_hilo_sel_E),
            .pc_plus4_E(pc_plus4_E),
            .alu_out_E(alu_out),
            .wd_dm_E(wd_dm_E),
            .prod_E(product),
            .rf_jal_wa_out_E(rf_jal_wa_out_E),
            .instr_E(instr_E),
            .jump_M(jump_M),
            .we_reg_M(we_reg_M),
            .we_dm_M(we_dm_M),
            .dm2reg_M(dm2reg_M),
            .jal_wd_sel_M(jal_wd_sel_M),
            .rf_wd_hilo_sel_M(rf_wd_hilo_sel_M),
            .mult_we_M(mult_we_M),
            .mf_hilo_sel_M(mf_hilo_sel_M),
            .pc_plus4_M(pc_plus4_M),
            .alu_out_M(alu_out_M),
            .wd_dm_M(wd_dm_M),
            .prod_M(prod_M),
            .rf_jal_wa_out_M(rf_jal_wa_out_M),
            .instr_M(instr_M)
        );
        
        MEM_WB_REG mem_wb_reg(
            .clk(clk),
            .we_reg_M(we_reg_M),
            .dm2reg_M(dm2reg_M),
            .jal_wd_sel_M(jal_wd_sel_M),
            .rf_wd_hilo_sel_M(rf_wd_hilo_sel_M),
            .mf_hilo_sel_M(mf_hilo_sel_M),
            .pc_plus4_M(pc_plus4_M),
            .rd_dm_M(rd_dm),
            .alu_out_M(alu_out_M),
            .mult_hi_M(mult_hi),
            .mult_lo_M(mult_lo),
            .rf_jal_wa_out_M(rf_jal_wa_out_M),
            .instr_M(instr_M),
            .we_reg_W(we_reg_W),
            .dm2reg_W(dm2reg_W),
            .jal_wd_sel_W(jal_wd_sel_W),
            .rf_wd_hilo_sel_W(rf_wd_hilo_sel_W),
            .mf_hilo_sel_W(mf_hilo_sel_W),
            .pc_plus4_W(pc_plus4_W),
            .rd_dm_W(rd_dm_W),
            .alu_out_W(alu_out_W),
            .mult_hi_W(mult_hi_W),
            .mult_lo_W(mult_lo_W),
            .rf_jal_wa_out_W(rf_jal_wa_out_W),
            .instr_W(instr_W)
        );

    regfile rf (
            .clk            (clk),
            .we             (we_reg_W),
            .ra1            (instr_D[25:21]),
            .ra2            (instr_D[20:16]),
            .ra3            (ra3),
            .wa             (rf_jal_wa_out_W),
            .wd             (wd_rf),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3),
            .rst            (rst)
        );

    signext se (
            .a              (instr_D[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src_E),//alu_src
            .a              (mux_BE_op),
            .b              (senext_imm_E),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl_E),
            .a              (alu_a),
            .b              (alu_b),
            .zero           (zero),
            .y              (alu_out)
        );
    wire op_eq;  
    assign pc_src = branch & op_eq;
    assign ba = {sext_imm[29:0], 2'b00};

    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux (
            .sel            (dm2reg_W), // dm2reg
            .a              (alu_out_W),
            .b              (rd_dm_W),
            .y              (rf_wd_mux_out)
        );     
     
    // --- MULTU Logic --- //
    multu multu(
            .a          (mux_AE_op),
            .b          (mux_BE_op),
            .y          (product)
    );
    
    // ---- storing the hi register ------//
    we_dreg hi(
        .clk        (clk),
        .we         (mult_we_M), // mult_we
        .d          (prod_M[63:32]),
        .q          (mult_hi)
    );
    
    // ---- storing the lo register ------//
    we_dreg lo(
        .clk        (clk),
        .we         (mult_we_M), // mult_we
        .d          (prod_M[31:0]),
        .q          (mult_lo)
    );
    
    // --- mflo/mfhi Logic --- //
    mux2 #(32) mf_hi_lo_mux (
            .sel            (mf_hilo_sel_W), //mf_hilo_sel
            .a              (mult_hi_W),
            .b              (mult_lo_W),
            .y              (mul_mf_res)
        );

    // --- input to wd mux Logic --- //
    mux2 #(32) rf_wd_hilo_mux (
            .sel            (rf_wd_hilo_sel_W), //rf_wd_hilo_sel
            .a              (rf_wd_mux_out),
            .b              (mul_mf_res),
            .y              (hi_lo_alu_dm_out)
        );
        
        
     // -- Mux to choose between alu_pb and shift amount for shift instructions -- //
     mux2 #(32) mux_alu_pb_sh_amt (
            .sel            (alu_src_sh_sel_E),
            .a              (alu_pb),
            .b              (sh_amt),
            .y              (alu_b)
        );
     
    mux2 #(32) alu_pa_wd_dm_mux (
            .sel            (alu_src_sh_sel_E), //alu_src_sh_sel
            .a              (mux_AE_op),
            .b              (mux_BE_op),
            .y              (alu_a)
        );
        
        
    // mux to select pc_plus4 address or hi or lo or alu_out or dm_out as data on wire wd_rf      
    mux2 #(32) jal_wd_mux (
            .sel            (jal_wd_sel_W), //jal_wd_sel
            .a              (hi_lo_alu_dm_out),
            .b              (pc_plus4_W),
            .y              (wd_rf)
        );
        
    // mux to select destination register $31 to write pc_plus4 before performing jump    
    mux2 #(5) jal_wa_mux (
            .sel            (jal_wa_sel),
            .a              (rf_wa),
            .b              (5'd31),
            .y              (rf_jal_wa_out)
        );
    
    // Control Hazard Logic
    HazardUnit hazardUnit(
        .clk(clk),
        .branchD(branch),
        .we_regM(we_reg_M),
        .rsD(instr_D[25:21]),
        .rtD(instr_D[20:16]),
        .rsE(instr_E[25:21]),
        .rtE(instr_E[20:16]),
        .rf_waW(rf_jal_wa_out_W),
        .we_regW(we_reg_W),
        .rf_waM(rf_jal_wa_out_M),
        .we_regE(we_reg_E),
        .dm2regM(dm2reg_M),
        .rf_waE(rf_jal_wa_out_E),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .branchstall(branchStall),
        .stallF(stallF),
        .stallD(stallD),
        .flushE(flushE)
    );
    
    mux2 #(32) mux_AD (
        .sel   (ForwardAD),
        .a     (alu_pa),
        .b     (alu_out_M),
        .y     (branch_op1)
    );

    mux2 #(32) mux_BD (
        .sel   (ForwardBD),
        .a     (wd_dm),
        .b     (alu_out_M),
        .y     (branch_op2)
    );
    
    Comparator comparator (
        .a      (branch_op1),
        .b      (branch_op2),
        .eq     (op_eq)
    );

    // Data Forwarding Logic
    mux3 #(32) mux_AE (
        .sel    (ForwardAE),
        .a      (alu_pa_E),
        .b      (wd_rf),
        .c      (alu_out_M),
        .y      (mux_AE_op)
    );
    
    mux3 #(32) mux_BE (
        .sel    (ForwardBE),
        .a      (wd_dm_E),
        .b      (wd_rf),
        .c      (alu_out_M),
        .y      (mux_BE_op)
    );

endmodule











































