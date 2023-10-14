module imem (
        input  wire [5:0]  a,
        output wire [31:0] y
    );

    reg [31:0] rom [0:63];

    initial begin
        $readmemh ("C:\\Users\\\Checkout\\Documents\\CMPE_200\\Lavanya\\Assignment-6\\single_cycle_mips_source_initial-20230408T171919Z-001\\single_cycle_mips_source_initial\\memory\\memory.dat", rom);
    end

    assign y = rom[a];
    
endmodule