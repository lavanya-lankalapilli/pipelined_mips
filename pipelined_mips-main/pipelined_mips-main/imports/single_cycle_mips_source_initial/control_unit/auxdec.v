module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [2:0] alu_ctrl,
        
        // New output wires
        // New outputs
        output wire rf_wd_hilo_sel,
        output wire mult_we,
        output wire mf_hilo_sel,
        output wire alu_src_sh_sel,
        output wire jr_sel
      
    );

    reg [7:0] ctrl;

    assign {alu_ctrl, mult_we, mf_hilo_sel, rf_wd_hilo_sel, alu_src_sh_sel, jr_sel} = ctrl;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00: ctrl = 8'b010_0_0_0_0_0;          // ADD
            2'b01: ctrl = 8'b110_0_0_0_0_0;          // SUB
            default: case (funct)
                6'b10_0100: ctrl = 8'b000_0_0_0_0_0; // AND
                6'b10_0101: ctrl = 8'b001_0_0_0_0_0; // OR
                6'b10_0000: ctrl = 8'b010_0_0_0_0_0; // ADD
                6'b10_0010: ctrl = 8'b110_0_0_0_0_0; // SUB
                6'b10_1010: ctrl = 8'b111_0_0_0_0_0; // SLT
                6'b01_1001: ctrl = 8'b000_1_0_0_0_0; // MULTU
                6'b01_0000: ctrl = 8'b000_0_0_1_0_0; // MFHI
                6'b01_0010: ctrl = 8'b000_0_1_1_0_0; // MFLO
                6'b00_0000: ctrl = 8'b100_0_0_0_1_0; // SLL
                6'b00_0010: ctrl = 8'b101_0_0_0_1_0; // SLR
                6'b00_1000: ctrl = 8'b000_0_0_0_0_1; // JR
                default:    ctrl = 8'bxxx_x_x_x_x_x;
            endcase
        endcase
    end

endmodule