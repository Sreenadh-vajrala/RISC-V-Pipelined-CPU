// Instruction Memory Module
module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 512 32-bit instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

initial begin
    //$readmemh("rv32i_book.hex", instr_ram);
     $readmemh("rv32i_test.hex", instr_ram); // use this for testing
end

// word-aligned memory access
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];  // If PC increased by 4, index increases by 1.

endmodule