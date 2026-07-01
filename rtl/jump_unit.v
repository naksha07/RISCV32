`timescale 1ns/1ps

module jump_unit(

    input wire Jump,
    input wire [6:0] opcode,
    input wire [31:0] pc,
    input wire [31:0] rs1,
    input wire [31:0] imm,

    output reg [31:0] jump_target,
    output reg jump_taken

);

always @(*) begin

    jump_taken = 1'b0;
    jump_target = 32'b0;

    if(Jump) begin

        case(opcode)

            // JAL
            7'b1101111:
            begin
                jump_taken = 1'b1;
                jump_target = pc + imm;
            end

            // JALR
            7'b1100111:
            begin
                jump_taken = 1'b1;
                jump_target = (rs1 + imm) & 32'hFFFFFFFE;
            end

            default
            begin
                jump_taken = 1'b0;
                jump_target = 32'b0;
            end

        endcase

    end

end

endmodule