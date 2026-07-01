`timescale 1ns / 1ps

module tb_riscv;
    
    reg clk;
    reg rst_n;
    
    riscv_top u_top (
        .clk(clk),
        .rst_n(rst_n)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_riscv);
    end
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        $display("========================================");
        $display("RV32I Processor Simulation Started");
        $display("========================================");
        
        #20;
        rst_n = 1;
        $display("Reset released");
        
        #200;
        
        $display("========================================");
        $display("Simulation Complete");
        $display("========================================");
        $finish;
    end
    
    always @(posedge clk) begin
        if (rst_n) begin
            $display("Time=%0t | PC=%h | Instr=%h | RS1=%h | RS2=%h | ALU=%h", 
                     $time, u_top.pc, u_top.instr, u_top.rs1_data, u_top.rs2_data, u_top.alu_result);
        end
    end
    
endmodule