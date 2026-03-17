// ALU Module
module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,        // operands
    input       [3:0] alu_ctrl,          // ALU control
    input [2:0] funct3,                  // funct3 field from instruction
    output reg  [WIDTH-1:0] alu_out,     // ALU output
    output reg    branch_cond            // branch condition flag
);

always @(*) begin
    case (alu_ctrl)
        4'b0000: alu_out = a+b;            // ADD
        4'b0001: alu_out = a+~b+1;         // SUB
        4'b0010: alu_out = a & b;          // AND
        4'b0011: alu_out = a | b;          // OR
        4'b0100: alu_out = a << b[4:0];    // SLL (Shift Left Logical)
        4'b0101: alu_out = ($signed(a) < $signed(b)) ? 1 : 0; // SLT (Signed comparison)
        4'b0110: alu_out = (a < b) ? 1 : 0;// SLTU (Unsigned comparison)
        4'b0111: alu_out = a ^ b;          // XOR
        4'b1000: alu_out = $signed(a) >>> b[4:0]; // SRA (Arithmetic Right Shift)
        4'b1001: alu_out = a >> b[4:0];    // SRL (Logical Right Shift)
        default: alu_out = 0;              // Default case
    endcase
end

always @(*) begin
    case(funct3)
        3'b000: branch_cond = (a == b);        // BEQ
        3'b001: branch_cond = (a != b);        // BNE
        3'b100: branch_cond = ($signed(a) < $signed(b)); // BLT
        3'b101: branch_cond = ($signed(a) >= $signed(b)); // BGE
        3'b110: branch_cond = (a < b);         // BLTU
        3'b111: branch_cond = (a >= b);        // BGEU
        default: branch_cond = 0;               // Default case
    endcase
end

endmodule