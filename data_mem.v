// Data Memory Module
module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
	input [2:0] funct3,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output reg  [DATA_WIDTH-1:0] rd_data_mem
);

reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64; // confined to MEM_SIZE and is word aligned

// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin
        if (funct3 == 3'b010) begin
            data_ram[word_addr] <= wr_data; // sw: Store word
        end
        case ({funct3, wr_addr[1:0]})
            5'b000_00: data_ram[word_addr][ 7: 0] <= wr_data[7:0];  // sb: Store byte
            5'b000_01: data_ram[word_addr][15: 8] <= wr_data[7:0];  // sb: Store byte
            5'b000_10: data_ram[word_addr][23:16] <= wr_data[7:0];  // sb: Store byte
            5'b000_11: data_ram[word_addr][31:24] <= wr_data[7:0];  // sb: Store byte

            5'b001_00: data_ram[word_addr][15: 0] <= wr_data[15:0]; // sh: Store half-word
            5'b001_10: data_ram[word_addr][31:16] <= wr_data[15:0]; // sh: Store half-word
        endcase
    end
end

// combinational read logic
always @(*) begin
    if (funct3 == 3'b010) begin
        rd_data_mem = data_ram[word_addr]; // lw: Load word
    end
    case ({funct3, wr_addr[1:0]})
        5'b000_00: rd_data_mem = {{24{data_ram[word_addr][ 7]}}, data_ram[word_addr][ 7:  0]}; // lb: Load signed byte
        5'b000_01: rd_data_mem = {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15:  8]}; // lb: Load signed byte
        5'b000_10: rd_data_mem = {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23: 16]}; // lb: Load signed byte
        5'b000_11: rd_data_mem = {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31: 24]}; // lb: Load signed byte

        5'b001_00: rd_data_mem = {{16{data_ram[word_addr][15]}}, data_ram[word_addr][15: 0]};  // lh: Load signed half-word
        5'b001_10: rd_data_mem = {{16{data_ram[word_addr][31]}}, data_ram[word_addr][31:16]};  // lh: Load signed half-word

        5'b100_00: rd_data_mem = {24'b0, data_ram[word_addr][ 7:  0]};                         // lbu: Load unsigned byte
        5'b100_01: rd_data_mem = {24'b0, data_ram[word_addr][15:  8]};                         // lbu: Load unsigned byte
        5'b100_10: rd_data_mem = {24'b0, data_ram[word_addr][23: 16]};                         // lbu: Load unsigned byte
        5'b100_11: rd_data_mem = {24'b0, data_ram[word_addr][31: 24]};                         // lbu: Load unsigned byte

        5'b101_00: rd_data_mem = {16'b0, data_ram[word_addr][15:0]};                           // lhu: Load unsigned half-word
        5'b101_10: rd_data_mem = {16'b0, data_ram[word_addr][31:16]};                          // lhu: Load unsigned half-word
    endcase
end 

endmodule