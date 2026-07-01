@echo off

echo ===================================
echo Compiling RISC-V Processor...
echo ===================================

iverilog -g2012 -I rtl -o processor_sim rtl\*.v testbench\tb_riscv.v

if %errorlevel% neq 0 (
    echo Compilation Failed.
    pause
    exit
)

echo.
echo ===================================
echo Running Simulation...
echo ===================================

vvp processor_sim

echo.
echo ===================================
echo Opening GTKWave...
echo ===================================

gtkwave waveform.vcd

pause