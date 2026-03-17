// Hazard Detection and Forwarding Unit
module hazard_unit (
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input       ResultSrcER0, RegWriteM, RegWriteW, PCSrcE,
    output reg  StallF, StallD, FlushE, FlushD,
    output reg [1:0] ForwardAE, ForwardBE
);

reg lwStall;

always @(*) begin
    if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0) ) begin
        ForwardAE = 2'b10;
    end
    else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0) ) begin
        ForwardAE = 2'b01;
    end
    else begin
        ForwardAE = 2'b00;
    end   
end

always @ (*) begin
    if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0) ) begin
        ForwardBE = 2'b10;
    end
    else if ( ((Rs2E == RdW) && RegWriteW) && (Rs2E != 0) ) begin
        ForwardBE = 2'b01;
    end
    else begin
        ForwardBE = 2'b00;
    end 
end

always @ (*) begin
    lwStall = (ResultSrcER0 & ((Rs1D == RdE) | (Rs2D == RdE)));
    StallF  = lwStall;
    StallD  = lwStall;
    FlushD  = PCSrcE;
    FlushE  = lwStall | PCSrcE; 
end

endmodule
