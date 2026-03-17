// Datapath module for a simple RISC-V processor
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrcD,
    input         ALUSrcD,
    input         RegWriteD,
    input [1:0]   ImmSrcD,
    input [3:0]   ALUControlD,
    input         jarlD,
    input         BranchD,
    input         JumpD,
    input         MemWriteD,
    output [31:0] PCF, // To instruction memory
    input  [31:0] Instr, // From instruction memory
    output [31:0] Mem_WrAddr, Mem_WrData, // Memory write address and data
    input  [31:0] ReadDataM, // Data read from Data memory
    output [31:0] ResultW,
    output        MemWriteM,
    output [2:0]  InstrM_14_12,
    output [31:0] PCW,
    output [31:0] ALUResultW,
    output [31:0] WriteDataW,
    output [31:0] InstrD
);

wire [31:0] PCNextF, PCPlus4F, PCTargetE;
wire [31:0] ImmExtD, SrcAD, SrcBE, WriteDataD, ALUResultE, outE;
wire [31:0] lui, auipc, LUIOrAUIPCResultE;
wire PCSrcE;

wire [31:0] PCD, PCPlus4D;
wire RegWriteW;
wire JumpE, ALUSrcE, BranchE, MemWriteE, InstrE_5, RegWriteE, jarlE;
wire [1:0]  ResultSrcE;
wire [3:0]  ALUControlE;
wire [31:0] SrcAE, WriteDataE, ImmExtE, PCPlus4E, PCE;
wire [2:0]  InstrE_14_12;
wire [4:0]  InstrE_11_7;
wire [19:0] InstrE_31_12;
wire [4:0]  InstrE_19_15, InstrE_24_20;

wire [1:0]  ResultSrcM;
wire        RegWriteM;
wire [31:0] ALUResultM, WriteDataM, PCPlus4M;
wire [4:0]  InstrM_11_7;
wire [31:0] LUIOrAUIPCResultM, PCM;

wire [1:0]  ResultSrcW;
wire [31:0] ReadDataW, LUIOrAUIPCResultW, PCPlus4W;
wire [4:0]  InstrW_11_7;
wire        ZeroE;

wire StallF, StallD, FlushE, FlushD;
wire [1:0] ForwardAE, ForwardBE; 
wire [31:0] ReadData1E, ReadData2E;

// IF stage
mux2 #(32)     pcmux(PCPlus4F, PCTargetE, PCSrcE, PCNextF);
reset_ff #(32) pcreg(clk, reset, StallF, PCNextF, PCF);
adder          pcadd4(PCF, 32'd4, PCPlus4F);

// Pipeline register between IF and DE stages
pl_reg_fd reg_fd (
    .clk(clk),
    .en(StallD),
    .clr(FlushD),
    .InstrF(Instr),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

// DE stage
reg_file       rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20], InstrW_11_7, ResultW, SrcAD, WriteDataD);
imm_extend     ext (InstrD[31:7], ImmSrcD, ImmExtD);

// Pipeline register between DE and EX stages
pl_reg_de reg_de(
    .clk(clk),
    .clr(FlushE),
    .JumpD(JumpD), 
    .ALUSrcD(ALUSrcD), 
    .BranchD(BranchD), 
    .MemWriteD(MemWriteD), 
    .RegWriteD(RegWriteD), 
    .InstrD_5(InstrD[5]), 
    .jarlD(jarlD),
    .ResultSrcD(ResultSrcD),
    .ALUControlD(ALUControlD),
    .SrcAD(SrcAD), 
    .WriteDataD(WriteDataD), 
    .PCD(PCD), 
    .ImmExtD(ImmExtD), 
    .PCPlus4D(PCPlus4D),
    .InstrD_14_12(InstrD[14:12]),
    .InstrD_11_7(InstrD[11:7]),
    .InstrD_31_12(InstrD[31:12]),
    .InstrD_19_15(InstrD[19:15]),
    .InstrD_24_20(InstrD[24:20]),
    .JumpE(JumpE), 
    .ALUSrcE(ALUSrcE), 
    .BranchE(BranchE), 
    .MemWriteE(MemWriteE), 
    .RegWriteE(RegWriteE), 
    .InstrE_5(InstrE_5), 
    .jarlE(jarlE),
    .ResultSrcE(ResultSrcE),
    .ALUControlE(ALUControlE),
    .SrcAE(ReadData1E), 
    .WriteDataE(ReadData2E), 
    .PCE(PCE), 
    .ImmExtE(ImmExtE), 
    .PCPlus4E(PCPlus4E),
    .InstrE_14_12(InstrE_14_12),
    .InstrE_11_7(InstrE_11_7),
    .InstrE_31_12(InstrE_31_12),
    .InstrE_19_15(InstrE_19_15),
    .InstrE_24_20(InstrE_24_20)
);

// forwarding muxes
mux3 #(32)     FAE(ReadData1E, ResultW, ALUResultM, ForwardAE, SrcAE);
mux3 #(32)     FBE(ReadData2E, ResultW, ALUResultM, ForwardBE, WriteDataE);

// EX stage
mux2 #(32)     srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
alu            alu (SrcAE, SrcBE, ALUControlE, InstrE_14_12, ALUResultE, ZeroE);
mux2 #(32)     jarlmux(PCE, SrcAE, jarlE, outE); // MUX to select between PC and SrcA for jalr instruction  
adder          pcaddbranch(outE, ImmExtE, PCTargetE);
assign lui = {InstrE_31_12, 12'b0};
adder auipc_adder(PCE, lui, auipc);
mux2 #(32)     lui_auipc_mux(auipc, lui, InstrE_5, LUIOrAUIPCResultE);
assign PCSrcE = (BranchE & ZeroE) | JumpE;

// Pipeline register between EX and MEM stages
pl_reg_em reg_em(
    .clk(clk),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE), 
    .RegWriteE(RegWriteE),
    .ALUResultE(ALUResultE), 
    .WriteDataE(WriteDataE), 
    .PCPlus4E(PCPlus4E),
    .InstrE_14_12(InstrE_14_12),
    .InstrE_11_7(InstrE_11_7),
    .LUIOrAUIPCResultE(LUIOrAUIPCResultE),
    .PCE(PCE),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM), 
    .RegWriteM(RegWriteM),
    .ALUResultM(ALUResultM), 
    .WriteDataM(WriteDataM), 
    .PCPlus4M(PCPlus4M),
    .InstrM_14_12(InstrM_14_12),
    .InstrM_11_7(InstrM_11_7),
    .LUIOrAUIPCResultM(LUIOrAUIPCResultM),
    .PCM(PCM)
);


// MEM stage
assign Mem_WrData = WriteDataM;
assign Mem_WrAddr = ALUResultM;

// Pipeline register between MEM and WB stages
pl_reg_mw reg_mw(
    .clk(clk),
    .ResultSrcM(ResultSrcM),
    .RegWriteM(RegWriteM),
    .ALUResultM(ALUResultM), 
    .ReadDataM(ReadDataM), 
    .LUIOrAUIPCResultM(LUIOrAUIPCResultM), 
    .PCPlus4M(PCPlus4M),
    .InstrM_11_7(InstrM_11_7),
    .PCM(PCM),
    .WriteDataM(WriteDataM),
    .ResultSrcW(ResultSrcW),
    .RegWriteW(RegWriteW),
    .ALUResultW(ALUResultW), 
    .ReadDataW(ReadDataW), 
    .LUIOrAUIPCResultW(LUIOrAUIPCResultW), 
    .PCPlus4W(PCPlus4W),
    .InstrW_11_7(InstrW_11_7),
    .PCW(PCW),
    .WriteDataW(WriteDataW)
);

// WB stage
mux4 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W, LUIOrAUIPCResultW, ResultSrcW, ResultW);


// hazard unit instantiation
hazard_unit hu(
    .Rs1D(InstrD[19:15]), 
    .Rs2D(InstrD[24:20]), 
    .Rs1E(InstrE_19_15), 
    .Rs2E(InstrE_24_20), 
    .RdE(InstrE_11_7), 
    .RdM(InstrM_11_7), 
    .RdW(InstrW_11_7),
    .ResultSrcER0(ResultSrcE[0]), 
    .RegWriteM(RegWriteM), 
    .RegWriteW(RegWriteW), 
    .PCSrcE(PCSrcE),
    .StallF(StallF), 
    .StallD(StallD), 
    .FlushE(FlushE), 
    .FlushD(FlushD),
    .ForwardAE(ForwardAE), 
    .ForwardBE(ForwardBE)
);

endmodule