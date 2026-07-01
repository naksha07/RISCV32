module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    input  wire       zero,
    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        jump,
    output reg        alu_src,
    output reg        mem_to_reg,
    output reg        pc_src,
    output reg [3:0]  alu_op
);
    
    always @(*) begin
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_src     = 1'b0;
        mem_to_reg  = 1'b0;
        pc_src      = 1'b0;
        alu_op      = 4'b0000;
        
        case (opcode)
            7'b0110011: begin
                reg_write = 1'b1;
            end
            
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_op = 4'b0001;
            end
            
            7'b0000011: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
            end
            
            7'b0100011: begin
                mem_write  = 1'b1;
                alu_src    = 1'b1;
            end
            
            7'b1100011: begin
                branch = (funct3 == 3'b000) ? zero : ~zero;
                alu_op = 4'b0010;
            end
            
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
                pc_src    = 1'b1;
            end
            
            7'b1100111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
                pc_src    = 1'b1;
                alu_src   = 1'b1;
            end
        endcase
    end
    
endmodule