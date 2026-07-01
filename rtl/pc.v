module pc (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        pc_write,
    input  wire [31:0] next_pc,
    output reg  [31:0] pc_out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_out <= 32'h00000000;
        else if (pc_write)
            pc_out <= next_pc;
    end
    
endmodule