module alu (
        input  wire [2:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output wire        zero,
        output reg  [31:0] y
    );

    assign zero = (y == 0);

    always @ (op, a, b) begin
        $display("ALU ---- op = %h", op);
        case (op)
            3'b000: y = a & b;
            3'b001: y = a | b;
            3'b010: y = a + b;
            3'b110: y = a - b;
            3'b111: y = (a < b) ? 1 : 0;
            3'b100: y = a << b; // ALU ctrl signal for logical left shift SLL a - value and b shift amount
            3'b101: y = a >> b; // ALU ctrl signal for logical right shift SLR
        endcase
        $display("ALU y = %h b = %h y = %h", a, b, y);
    end

endmodule