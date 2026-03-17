// PL Reg MW: Pipeline Register between Memory and Writeback stages
module pl_reg_mw (
    input             clk,
    input [1:0]       ResultSrcM,
    input             RegWriteM,
    input [31:0]      ALUResultM, ReadDataM, LUIOrAUIPCResultM, PCPlus4M,
    input [4:0]       InstrM_11_7,
    input [31:0]      PCM,
    input [31:0]      WriteDataM,
    output reg [1:0]  ResultSrcW,
    output reg        RegWriteW,
    output reg [31:0] ALUResultW, ReadDataW, LUIOrAUIPCResultW, PCPlus4W,
    output reg [4:0]  InstrW_11_7,
    output reg [31:0] PCW,
    output reg [31:0] WriteDataW
);

always @(posedge clk) begin

    ResultSrcW        <= ResultSrcM;
    RegWriteW         <= RegWriteM;
    ALUResultW        <= ALUResultM;
    ReadDataW         <= ReadDataM;
    LUIOrAUIPCResultW <= LUIOrAUIPCResultM;
    PCPlus4W          <= PCPlus4M;
    InstrW_11_7       <= InstrM_11_7;
    PCW               <= PCM;
    WriteDataW        <= WriteDataM;

end
endmodule