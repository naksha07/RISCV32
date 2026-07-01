`timescale 1ns/1ps

`include "include/alu_ops.vh"

module alu_control(

    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg  [3:0] ALUControl

);

always @(*) begin

    case(ALUOp)

        //==================================================
        // Load / Store Instructions
        //==================================================
        2'b00:
        begin
            ALUControl = `ALU_ADD;
        end

        //==================================================
        // Branch Instructions
        //==================================================
        2'b01:
        begin
            ALUControl = `ALU_SUB;
        end

        //==================================================
        // R-Type / I-Type Instructions
        //==================================================
        2'b10:
        begin

            case(funct3)

                //--------------------------------------------------
                // ADD / SUB / ADDI
                //--------------------------------------------------
                3'b000:
                begin

                    if(funct7 == 7'b0100000)
                        ALUControl = `ALU_SUB;
                    else
                        ALUControl = `ALU_ADD;

                end

                //--------------------------------------------------
                // SLL / SLLI
                //--------------------------------------------------
                3'b001:
                begin
                    ALUControl = `ALU_SLL;
                end

                //--------------------------------------------------
                // SLT / SLTI
                //--------------------------------------------------
                3'b010:
                begin
                    ALUControl = `ALU_SLT;
                end

                //--------------------------------------------------
                // SLTU / SLTIU
                //--------------------------------------------------
                3'b011:
                begin
                    ALUControl = `ALU_SLTU;
                end

                //--------------------------------------------------
                // XOR / XORI
                //--------------------------------------------------
                3'b100:
                begin
                    ALUControl = `ALU_XOR;
                end

                //--------------------------------------------------
                // SRL / SRA / SRLI / SRAI
                //--------------------------------------------------
                3'b101:
                begin

                    if(funct7 == 7'b0100000)
                        ALUControl = `ALU_SRA;
                    else
                        ALUControl = `ALU_SRL;

                end

                //--------------------------------------------------
                // OR / ORI
                //--------------------------------------------------
                3'b110:
                begin
                    ALUControl = `ALU_OR;
                end

                //--------------------------------------------------
                // AND / ANDI
                //--------------------------------------------------
                3'b111:
                begin
                    ALUControl = `ALU_AND;
                end

                //--------------------------------------------------
                // Default
                //--------------------------------------------------
                default:
                begin
                    ALUControl = `ALU_ADD;
                end

            endcase

        end

        //==================================================
        // Default
        //==================================================
        default:
        begin
            ALUControl = `ALU_ADD;
        end

    endcase

end

endmodule