// Reset Flip-Flop Module
module reset_ff #(parameter WIDTH = 8) (
    input       clk, rst, clr,
    input       [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

initial begin
    q = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else if (!clr) q <= d;
end

endmodule