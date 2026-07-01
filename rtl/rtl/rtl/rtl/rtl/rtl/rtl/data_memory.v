module data_memory (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire        mem_read,
    input  wire        mem_write,
    output reg  [31:0] read_data
);
    
    reg [31:0] mem [0:1023];
    
    wire [31:0] word_addr = addr >> 2;
    
    always @(*) begin
        if (mem_read)
            read_data = mem[word_addr[9:0]];
        else
            read_data = 32'h0;
    end
    
    always @(posedge clk) begin
        if (mem_write)
            mem[word_addr[9:0]] <= write_data;
    end
    
endmodule