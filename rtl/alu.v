`timescale 1ns/1ps

`include "include/alu_ops.vh"

module alu #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [3:0] ALUControl,

    output reg  [WIDTH-1:0] Result,
    output wire Zero,
    output wire Negative,
    output reg  Carry,
    output reg  Overflow
);

reg [WIDTH:0] temp;

always @(*) begin

    Result   = 0;
    Carry    = 0;
    Overflow = 0;

    case(ALUControl)

        `ALU_ADD:
        begin
            temp     = {1'b0,A}+{1'b0,B};
            Result   = temp[WIDTH-1:0];
            Carry    = temp[WIDTH];

            Overflow = (~(A[31]^B[31])) &
                       (A[31]^Result[31]);
        end

        `ALU_SUB:
        begin
            temp     = {1'b0,A}-{1'b0,B};
            Result   = temp[WIDTH-1:0];
            Carry    = temp[WIDTH];

            Overflow = (A[31]^B[31]) &
                       (A[31]^Result[31]);
        end

        `ALU_AND:
            Result = A & B;

        `ALU_OR:
            Result = A | B;

        `ALU_XOR:
            Result = A ^ B;

        `ALU_SLL:
            Result = A << B[4:0];

        `ALU_SRL:
            Result = A >> B[4:0];

        `ALU_SRA:
            Result = $signed(A) >>> B[4:0];

        `ALU_SLT:
            Result = ($signed(A) < $signed(B));

        `ALU_SLTU:
            Result = (A < B);

        default:
            Result = 0;

    endcase

end

assign Zero     = (Result==0);
assign Negative = Result[31];

endmodule