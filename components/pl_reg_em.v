// PL Reg EM: Pipeline Register between Execute and Memory stages
module pl_reg_em (
    input             clk,
    input [1:0]       ResultSrcE,
    input             MemWriteE, RegWriteE,
    input [31:0]      ALUResultE, WriteDataE, PCPlus4E,
    input [2:0]       InstrE_14_12,
    input [4:0]       InstrE_11_7,
    input [31:0]      LUIOrAUIPCResultE,
    input [31:0]      PCE,
    output reg [1:0]  ResultSrcM,
    output reg        MemWriteM, RegWriteM,
    output reg [31:0] ALUResultM, WriteDataM, PCPlus4M,
    output reg [2:0]  InstrM_14_12,
    output reg [4:0]  InstrM_11_7,
    output reg [31:0] LUIOrAUIPCResultM,
    output reg [31:0] PCM
);

always @(posedge clk) begin

    ResultSrcM          <= ResultSrcE;
    MemWriteM           <= MemWriteE;
    RegWriteM           <= RegWriteE;
    ALUResultM          <= ALUResultE;
    WriteDataM          <= WriteDataE;
    PCPlus4M            <= PCPlus4E;
    InstrM_14_12        <= InstrE_14_12;
    InstrM_11_7         <= InstrE_11_7;
    LUIOrAUIPCResultM   <= LUIOrAUIPCResultE;
    PCM                 <= PCE;
end

endmodule