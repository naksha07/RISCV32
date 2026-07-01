SIM = cpu_sim

RTL = rtl/*.v
TB = testbench/tb_riscv.v

sim:
	iverilog -g2012 -o $(SIM) $(RTL) $(TB)
	vvp $(SIM)

wave:
	gtkwave waveform.vcd

clean:
	rm -f $(SIM)
	rm -f *.vcd