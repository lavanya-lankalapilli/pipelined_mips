module mips_top (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] instr,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd_dm,
        output wire [31:0] rd3,
        output wire [31:0] wd_rf,
        output  wire [31:0] instr_E
    );

    wire [31:0] DONT_USE;
    wire we_dm_M;
    wire [31:0] wd_dm_M;
    wire [31:0] alu_out_M;

    mips mips (
            .clk            (clk),
            .rst            (rst),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3),
             .wd_rf         (wd_rf),
             .we_dm_M       (we_dm_M),
             .wd_dm_M       (wd_dm_M),
             .instr_E       (instr_E),
             .alu_out_M     (alu_out_M)
        );

    imem imem (
            .a              (pc_current[7:2]),
            .y              (instr)
        );

    dmem dmem (
            .clk            (clk),
            .we             (we_dm_M),
            .a              (alu_out_M[7:2]),
            .d              (wd_dm_M),
            .q              (rd_dm),
            .rst            (rst)
        );

endmodule