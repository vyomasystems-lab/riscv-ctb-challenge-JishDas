
all: gen compile disass spike sim

gen: clean
	@echo '[UpTickPro] Test Generation ------'
	pip install aapg
	aapg setup
	aapg gen --config_file $(PWD)/rv32i.yaml --asm_name test --output_dir $(PWD) --arch rv32

compile:
	@echo '[UpTickPro] Test Compilation ------'
	riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -I$(PWD)/work/common -T$(PWD)/test.ld test.S $(PWD)/work/common/crt.S -o test.elf

disass: compile
	@echo '[UpTickPro] Test Disassembly ------'
	riscv32-unknown-elf-objdump -D test.elf > test.disass

spike: compile
	@echo '[UpTickPro] Spike Run ------'
	spike --isa=rv32i test.elf 
	spike -c --isa=rv32i +signature=test_spike_signature.log test.elf

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
	rm -rf *.elf *.disass *.log *.dump app_log code.mem signature boot.* riscv_buggy  work *.S *.ld *.ini
