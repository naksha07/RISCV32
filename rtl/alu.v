module alu
#(
    parameter WIDTH = 32
)
(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,

    input  wire [3:0] ALUControl,

    output reg  [WIDTH-1:0] Result,

    output wire Zero,
    output wire Negative,
    output reg  Carry,
    output reg  Overflow
);
    
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    
    always @(*) begin
        case (alu_op)
            ALU_ADD:  alu_result = operand_a + operand_b;
            ALU_SUB:  alu_result = operand_a - operand_b;
            ALU_AND:  alu_result = operand_a & operand_b;
            ALU_OR:   alu_result = operand_a | operand_b;
            ALU_XOR:  alu_result = operand_a ^ operand_b;
            ALU_SLL:  alu_result = operand_a << operand_b[4:0];
            ALU_SRL:  alu_result = operand_a >> operand_b[4:0];
            ALU_SRA:  alu_result = $signed(operand_a) >>> operand_b[4:0];
            ALU_SLT:  alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'h1 : 32'h0;
            ALU_SLTU: alu_result = (operand_a < operand_b) ? 32'h1 : 32'h0;
            default:  alu_result = 32'h0;
        endcase
    end
    
    assign zero = (alu_result == 32'h0);
    
endmodule

