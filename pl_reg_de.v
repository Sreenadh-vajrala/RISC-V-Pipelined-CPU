// PL Reg DE: Pipeline Register between Decode and Execute stages
module pl_reg_de (
    input              clk, clr,
    input              JumpD, ALUSrcD, BranchD, MemWriteD, RegWriteD, InstrD_5, jarlD,
    input [1:0]        ResultSrcD,
    input [3:0]        ALUControlD,
    input [31:0]       SrcAD, WriteDataD, PCD, ImmExtD, PCPlus4D,
    input [2:0]        InstrD_14_12,
    input [4:0]        InstrD_11_7,
    input [19:0]       InstrD_31_12,
    input [4:0]        InstrD_19_15,
    input [4:0]        InstrD_24_20,
    output reg         JumpE, ALUSrcE, BranchE, MemWriteE, RegWriteE, InstrE_5, jarlE,
    output reg [1:0]   ResultSrcE,
    output reg [3:0]   ALUControlE,
    output reg [31:0]  SrcAE, WriteDataE, PCE, ImmExtE, PCPlus4E,
    output reg [2:0]   InstrE_14_12,
    output reg [4:0]   InstrE_11_7,
    output reg [19:0]  InstrE_31_12,
    output reg [4:0]   InstrE_19_15,
    output reg [4:0]   InstrE_24_20
);

always @(posedge clk) begin

    if(clr) begin
        JumpE        <= 0;
        ALUSrcE      <= 0;
        BranchE      <= 0;
        MemWriteE    <= 0;
        RegWriteE    <= 0;
        InstrE_5     <= 0;
        jarlE        <= 0;
        ResultSrcE   <= 0;
        ALUControlE  <= 0;
        SrcAE        <= 0;
        WriteDataE   <= 0;
        PCE          <= 0;
        ImmExtE      <= 0;
        PCPlus4E     <= 0;
        InstrE_14_12 <= 0;
        InstrE_11_7  <= 0;
        InstrE_31_12 <= 0;
        InstrE_19_15 <= 0;
        InstrE_24_20 <= 0;

    end
    else begin
        JumpE        <= JumpD;
        ALUSrcE      <= ALUSrcD;
        BranchE      <= BranchD;
        MemWriteE    <= MemWriteD;
        RegWriteE    <= RegWriteD;
        InstrE_5     <= InstrD_5;
        jarlE        <= jarlD;
        ResultSrcE   <= ResultSrcD;
        ALUControlE  <= ALUControlD;
        SrcAE        <= SrcAD;
        WriteDataE   <= WriteDataD;
        PCE          <= PCD;
        ImmExtE      <= ImmExtD;
        PCPlus4E     <= PCPlus4D;
        InstrE_14_12 <= InstrD_14_12;
        InstrE_11_7  <= InstrD_11_7;
        InstrE_31_12 <= InstrD_31_12;
        InstrE_19_15 <= InstrD_19_15;
        InstrE_24_20 <= InstrD_24_20;

    end
end

endmodule