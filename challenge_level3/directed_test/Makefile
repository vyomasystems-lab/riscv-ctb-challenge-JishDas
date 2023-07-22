
all: compile disass spike sim

compile: clean
	@echo '[UpTickPro] Compilation ------'
	riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles  -I$(PWD)/common -T$(PWD)/common/link.ld test.S -o test.elf

disass: compile
	riscv32-unknown-elf-objdump -D test.elf > test.disass

spike: compile
	@echo '[UpTickPro] Spike ------'
	/tools/mod_spike/bin/spike --isa=rv32i test.elf 
	/tools/mod_spike/bin/spike -c --isa=rv32i +signature=test_spike_signature.log test.elf

sim: spike
	@echo '[UpTickPro] Simulation ------'
	elf2hex  4  8388608 test.elf 2147483648 > code.mem
	@ln -sf $(PWD)/../riscv/* .
	./riscv_buggy
	head -n -4 rtl.dump > temp.dump
	cp temp.dump rtl.dump
	@echo '[UpTickPro] Comparison ------'
	diff rtl.dump spike.dump
	
clean:
	@echo '[UpTickPro] Clean ------'
	rm -rf *.elf *.disass *.log *.dump app_log code.mem signature boot.* riscv_buggy
