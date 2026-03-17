// RISC-V CPU module integrating controller and datapath
module riscv_cpu (
    input         clk, reset,
    output [31:0] PC, // To instruction memory
    input  [31:0] Instr, // From instruction memory
    output        MemWriteM, // Memory write enable 
    output [31:0] Mem_WrAddr, Mem_WrData, // Memory write address and data
    input  [31:0] ReadData, // Data read from Data memory
    output [31:0] Result,
    output [2:0]  InstrM_14_12,
    output [31:0] PCW,
    output [31:0] ALUResultW,
    output [31:0] WriteDataW
);

wire        ALUSrc, RegWrite, jarl, Branch, Jump;
wire [1:0]  ResultSrc, ImmSrc;
wire [3:0]  ALUControl;
wire MemWrite;
wire [31:0] InstrD;

controller  c   (InstrD[6:0], InstrD[14:12], InstrD[30],
                ResultSrc, MemWrite, ALUSrc, RegWrite, jarl,
                ImmSrc, ALUControl, Branch, Jump);

datapath    dp  (clk, reset, ResultSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl, jarl, Branch, Jump, MemWrite,
                PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result, MemWriteM, InstrM_14_12, PCW, ALUResultW, WriteDataW, InstrD);

endmodule