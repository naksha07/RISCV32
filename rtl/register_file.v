module register_file (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data,
    input  wire        reg_write,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    
    reg [31:0] regs [31:0];
    integer i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'h0;
        end else if (reg_write && (rd_addr != 5'h0)) begin
            regs[rd_addr] <= rd_data;
        end
    end
    
    assign rs1_data = (rs1_addr == 5'h0) ? 32'h0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'h0) ? 32'h0 : regs[rs2_addr];
    
endmodule