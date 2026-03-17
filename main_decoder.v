// Main decoder module for RISC-V single-cycle CPU
// Generates control signals based on opcode
module main_decoder (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump, jarl,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

reg [11:0] controls;

always @(*) begin
    case (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_jarl
        7'b0000011: controls = 12'b1_00_1_0_01_0_00_0_0; // load
        7'b0100011: controls = 12'b0_01_1_1_00_0_00_0_0; // store
        7'b0110011: controls = 12'b1_xx_0_0_00_0_10_0_0; // R–type
        7'b1100011: controls = 12'b0_10_0_0_00_1_01_0_0; // branch
        7'b0010011: controls = 12'b1_00_1_0_00_0_10_0_0; // I–type ALU
        7'b1101111: controls = 12'b1_11_0_0_10_0_00_1_0; // jal
        7'b1100111: controls = 12'b1_00_0_0_10_0_00_1_1; // jalr
        7'b0010111: controls = 12'b1_00_0_0_11_0_00_0_0; // auipc
        7'b0110111: controls = 12'b1_00_0_0_11_0_00_0_0; // lui
        default:    controls = 12'b0_00_0_0_00_0_00_0_0; // default (illegal instr)
    endcase
end

assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, jarl} = controls;

endmodule