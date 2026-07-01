# Design and Verification of a 32-bit RISC-V Processor using Verilog HDL

## Overview

This project implements a 32-bit single-cycle RISC-V (RV32I) processor in Verilog HDL.

The processor supports instruction fetch, decode, execute, memory access and write-back stages. It is completely modular and verified using a self-checking Verilog testbench.

The design is simulated using Icarus Verilog and GTKWave.

---

## Features

- 32-bit RV32I Processor
- Single Cycle Architecture
- Modular RTL Design
- ALU
- ALU Control Unit
- Main Control Unit
- Register File
- Program Counter
- Immediate Generator
- Instruction Memory
- Data Memory
- Branch Instructions
- Jump Instructions
- Performance Counters
- CPI and IPC Calculation
- Automated Verification Testbench

---

## Folder Structure

```
RISCV32
│
├── rtl
│   ├── alu.v
│   ├── alu_control.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── imm_generator.v
│   ├── instruction_counter.v
│   ├── instruction_memory.v
│   ├── pc.v
│   ├── performance_counter.v
│   ├── register_file.v
│   └── riscv_top.v
│
├── testbench
│   └── tb_riscv.v
│
├── programs
│   └── fibonacci.hex
│
├── docs
│
├── waveform.vcd
│
├── run.bat
│
└── README.md
```

---

## Processor Datapath

(Add datapath image here)

---

## Module Hierarchy

(Add hierarchy image here)

---

## Simulation

Compile

```
iverilog -g2012 -I rtl -o processor_sim rtl/*.v testbench/tb_riscv.v
```

Run

```
vvp processor_sim
```

Open Waveform

```
gtkwave waveform.vcd
```

---

## Verification Summary

| Test | Status |
|------|--------|
| Program Counter | PASS |
| Control Unit | PASS |
| ALU | PASS |
| Branch | PASS |
| Jump | PASS |
| Performance Counter | PASS |
| Instruction Counter | PASS |

---

## Performance

Example Simulation

```
Cycle Count : 30

Instruction Count : 29

CPI : 1.03

IPC : 0.97
```

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Git
- GitHub

---

## Author

Nakshathraa N B

Electronics and Communication Engineering
