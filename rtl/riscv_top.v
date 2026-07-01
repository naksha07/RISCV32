`timescale 1ns/1ps

module riscv_top (
    input wire clk,
    input wire rst_n
);

    //------------------------------------------------------
    // Program Counter
    //------------------------------------------------------
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] pc_plus4;

    //------------------------------------------------------
    // Instruction
    //------------------------------------------------------
    wire [31:0] instr;

    //------------------------------------------------------
    // Register File
    //------------------------------------------------------
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_back_data;

    //------------------------------------------------------
    // Immediate
    //------------------------------------------------------
    wire [31:0] imm;

    //------------------------------------------------------
    // ALU
    //------------------------------------------------------
    wire [31:0] alu_in2;
    wire [31:0] alu_result;

    wire zero;
    wire negative;
    wire carry;
    wire overflow;

    //------------------------------------------------------
    // Data Memory
    //------------------------------------------------------
    wire [31:0] mem_read_data;

    //------------------------------------------------------
    // Control Signals
    //------------------------------------------------------
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire Jump;
    wire ALUSrc;
    wire MemToReg;

    //------------------------------------------------------
    // ALU Control
    //------------------------------------------------------
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    //------------------------------------------------------
    // Branch / Jump
    //------------------------------------------------------
    wire branch_taken;

    wire jump_taken;
    wire [31:0] jump_target;

    //------------------------------------------------------
    // Performance Counters
    //------------------------------------------------------
    wire [31:0] cycle_count;
    wire [31:0] instruction_count;

    //------------------------------------------------------
    // PC Logic
    //------------------------------------------------------
    assign pc_plus4 = pc + 32'd4;

    assign next_pc =
        (jump_taken)   ? jump_target :
        (branch_taken) ? (pc + imm) :
                         pc_plus4;

    //------------------------------------------------------
    // Program Counter
    //------------------------------------------------------
    pc u_pc(
        .clk(clk),
        .rst_n(rst_n),
        .pc_write(1'b1),
        .next_pc(next_pc),
        .pc_out(pc)
    );

    //------------------------------------------------------
    // Instruction Memory
    //------------------------------------------------------
    instruction_memory u_imem(
        .clk(clk),
        .addr(pc),
        .instr(instr)
    );

    //------------------------------------------------------
    // Register File
    //------------------------------------------------------
    register_file u_rf(
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .rd_data(write_back_data),
        .reg_write(RegWrite),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    //------------------------------------------------------
    // Immediate Generator
    //------------------------------------------------------
    imm_generator u_imm(
        .instr(instr),
        .imm(imm)
    );

    //------------------------------------------------------
    // ALU Operand Selection
    //------------------------------------------------------
    assign alu_in2 = (ALUSrc) ? imm : rs2_data;

    //------------------------------------------------------
    // Main Control Unit
    //------------------------------------------------------
    control_unit u_ctrl(
        .opcode(instr[6:0]),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp)
    );

    //------------------------------------------------------
    // ALU Control
    //------------------------------------------------------
    alu_control u_alu_ctrl(
        .ALUOp(ALUOp),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .ALUControl(ALUControl)
    );

    //------------------------------------------------------
    // ALU
    //------------------------------------------------------
    alu u_alu(
        .A(rs1_data),
        .B(alu_in2),
        .ALUControl(ALUControl),
        .Result(alu_result),
        .Zero(zero),
        .Negative(negative),
        .Carry(carry),
        .Overflow(overflow)
    );

    //------------------------------------------------------
    // Branch Unit
    //------------------------------------------------------
    branch_unit u_branch(
        .Branch(Branch),
        .funct3(instr[14:12]),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .branch_taken(branch_taken)
    );

    //------------------------------------------------------
    // Jump Unit
    //------------------------------------------------------
    jump_unit u_jump(
        .Jump(Jump),
        .opcode(instr[6:0]),
        .pc(pc),
        .rs1(rs1_data),
        .imm(imm),
        .jump_target(jump_target),
        .jump_taken(jump_taken)
    );

    //------------------------------------------------------
    // Data Memory
    //------------------------------------------------------
    data_memory u_dmem(
        .clk(clk),
        .addr(alu_result),
        .write_data(rs2_data),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .read_data(mem_read_data)
    );

    //------------------------------------------------------
    // Performance Counter
    //------------------------------------------------------
    performance_counter u_cycle_counter(
        .clk(clk),
        .rst_n(rst_n),
        .cycle_count(cycle_count)
    );

    //------------------------------------------------------
    // Instruction Counter
    //------------------------------------------------------
    instruction_counter u_instr_counter(
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(RegWrite),
        .instruction_count(instruction_count)
    );

    //------------------------------------------------------
    // Write Back
    //------------------------------------------------------
    assign write_back_data =
        (MemToReg) ? mem_read_data :
                     alu_result;

endmodule