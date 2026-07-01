module instruction_memory (
    input  wire        clk,
    input  wire [31:0] addr,
    output reg  [31:0] instr
);
    
    reg [31:0] mem [0:1023];
    
    initial begin
        $readmemh("programs/fibonacci.hex", mem);
    end
    
    wire [31:0] word_addr = addr >> 2;
    
    always @(posedge clk) begin
        instr <= mem[word_addr[9:0]];
    end
    
endmodule
