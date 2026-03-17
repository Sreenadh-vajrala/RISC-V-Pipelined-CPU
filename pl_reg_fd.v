// PL Reg FD: Pipeline Register between Fetch and Decode stages
module pl_reg_fd (
    input             clk, en, clr,
    input      [31:0] InstrF, PCF, PCPlus4F,
    output reg [31:0] InstrD, PCD, PCPlus4D
);

initial begin
    InstrD    = 32'b0;
    PCD       = 32'b0;
    PCPlus4D  = 32'b0;
end


always @(posedge clk) begin
    if (clr) begin
        InstrD   <= 32'b0; 
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;
    end
    else if (!en) begin
        InstrD   <= InstrF; 
        PCD      <= PCF;
        PCPlus4D <= PCPlus4F;
    end
end

endmodule