module riscv_top (
    input  wire        clk,
    input  wire        rst_n
);
    
    wire [31:0] pc, next_pc, pc_plus4;
    wire [31:0] instr;
    wire [31:0] imm;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] alu_result, alu_in2;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;
    wire [3:0]  alu_ctrl;
    wire        zero;
    
    wire        reg_write, mem_read, mem_write;
    wire        branch, jump, alu_src, mem_to_reg, pc_src;
    wire [3:0]  alu_op;
    
    assign pc_plus4 = pc + 32'h4;
    assign next_pc = (pc_src) ? pc + imm : pc_plus4;
    
    pc u_pc (
        .clk(clk),
        .rst_n(rst_n),
        .pc_write(1'b1),
        .next_pc(next_pc),
        .pc_out(pc)
    );
    
    instruction_memory u_imem (
        .clk(clk),
        .addr(pc),
        .instr(instr)
    );
    
    register_file u_rf (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .rd_data(write_back_data),
        .reg_write(reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    imm_generator u_imm (
        .instr(instr),
        .imm(imm)
    );
    
    assign alu_in2 = (alu_src) ? imm : rs2_data;
    
    alu u_alu (
        .operand_a(rs1_data),
        .operand_b(alu_in2),
        .alu_op(alu_ctrl),
        .alu_result(alu_result),
        .zero(zero)
    );
    
    control_unit u_ctrl (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .zero(zero),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .pc_src(pc_src),
        .alu_op(alu_op)
    );
    
    alu_control u_alu_ctrl (
        .alu_op(alu_op),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .alu_ctrl(alu_ctrl)
    );
    
    data_memory u_dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(rs2_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );
    
    assign write_back_data = (mem_to_reg) ? mem_read_data : alu_result;
    
endmodule