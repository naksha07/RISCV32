`timescale 1ns/1ps

module tb_riscv;

reg clk;
reg rst_n;

integer total_tests;
integer passed_tests;
integer failed_tests;

real CPI;
real IPC;

riscv_top u_top(
    .clk(clk),
    .rst_n(rst_n)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb_riscv);
end

//------------------------------------------------------------
// PASS TASK
//------------------------------------------------------------
task pass;
input [255:0] msg;
begin
    total_tests = total_tests + 1;
    passed_tests = passed_tests + 1;
    $display("[PASS] %0s",msg);
end
endtask

//------------------------------------------------------------
// FAIL TASK
//------------------------------------------------------------
task fail;
input [255:0] msg;
begin
    total_tests = total_tests + 1;
    failed_tests = failed_tests + 1;
    $display("[FAIL] %0s",msg);
end
endtask

//------------------------------------------------------------
// SIMULATION
//------------------------------------------------------------
initial begin

    clk = 0;
    rst_n = 0;

    total_tests = 0;
    passed_tests = 0;
    failed_tests = 0;

    $display("");
    $display("===============================================");
    $display("        RV32I PROCESSOR VERIFICATION");
    $display("===============================================");

    #20;

    rst_n = 1;

    $display("Reset Released");

    #300;

    //--------------------------------------------------------
    // CHECKS
    //--------------------------------------------------------

    if(u_top.pc>0)
        pass("PC Running");
    else
        fail("PC Running");

    if(u_top.RegWrite===1'b0 || u_top.RegWrite===1'b1)
        pass("Control Unit");
    else
        fail("Control Unit");

    if(u_top.branch_taken===1'b0 || u_top.branch_taken===1'b1)
        pass("Branch Unit");
    else
        fail("Branch Unit");

    if(u_top.jump_taken===1'b0 || u_top.jump_taken===1'b1)
        pass("Jump Unit");
    else
        fail("Jump Unit");

    if(u_top.alu_result!==32'hxxxxxxxx)
        pass("ALU");
    else
        fail("ALU");

    if(u_top.cycle_count>0)
        pass("Cycle Counter");
    else
        fail("Cycle Counter");

    if(u_top.instruction_count>0)
        pass("Instruction Counter");
    else
        fail("Instruction Counter");

    //--------------------------------------------------------
    // PERFORMANCE
    //--------------------------------------------------------

    CPI = u_top.cycle_count;
    CPI = CPI / u_top.instruction_count;

    IPC = u_top.instruction_count;
    IPC = IPC / u_top.cycle_count;

    //--------------------------------------------------------
    // REPORT
    //--------------------------------------------------------

    $display("");

    $display("===============================================");
    $display("SIMULATION REPORT");
    $display("===============================================");

    $display("Cycle Count       : %0d",u_top.cycle_count);
    $display("Instruction Count : %0d",u_top.instruction_count);
    $display("CPI               : %0f",CPI);
    $display("IPC               : %0f",IPC);

    $display("");

    $display("Total Tests : %0d",total_tests);
    $display("Passed      : %0d",passed_tests);
    $display("Failed      : %0d",failed_tests);

    if(failed_tests==0)
        $display("STATUS : ALL TESTS PASSED");
    else
        $display("STATUS : TEST FAILED");

    $display("===============================================");

    #20;

    $finish;

end

//------------------------------------------------------------
// LIVE MONITOR
//------------------------------------------------------------
always @(posedge clk)
begin

    if(rst_n)
    begin

        $display("-------------------------------------------");
        $display("Time          : %0t",$time);
        $display("PC            : %h",u_top.pc);
        $display("Instruction   : %h",u_top.instr);
        $display("ALU Result    : %h",u_top.alu_result);
        $display("Branch Taken  : %b",u_top.branch_taken);
        $display("Jump Taken    : %b",u_top.jump_taken);
        $display("Cycles        : %0d",u_top.cycle_count);
        $display("Instructions  : %0d",u_top.instruction_count);
        $display("-------------------------------------------");

    end

end

endmodule