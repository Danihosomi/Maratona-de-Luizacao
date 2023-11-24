all: compile-firmware build run

build: *.v
	verilator --binary Tester.v --clk clk
	
run:
	./obj_dir/VTester

test: ./output/V$(T).vcd

./output/V%.vcd: ./obj_dir/V% rom.hex
	test -d output || mkdir output;
	cp rom.hex output/rom.hex
	cd output; ../$<

./obj_dir/V%: %.v tests/%_TestBench.cpp *.v
	verilator --trace --build -cc $< --exe $(word 2, $^)

./obj_dir/V%: %.v
	verilator --trace -cc $<

TARGET_SOURCE?=main.c
rom.hex: install firmware/$(TARGET_SOURCE)
	test -d temp || mkdir temp;

	if [[ "$(suffix ${TARGET_SOURCE})" == ".c" ]]; then \
		sh scripts/firmware/compile_firmware_c.sh $(TARGET_SOURCE); \
	else \
		sh scripts/firmware/compile_firmware_asm.sh $(TARGET_SOURCE); \
	fi

python-dependencies-folder := scripts/venv/include
install: $(python-dependencies-folder)
$(python-dependencies-folder): scripts/requirements.txt scripts/venv
	. scripts/venv/bin/activate && pip install -r scripts/requirements.txt

scripts/venv: 
	test -d scripts/venv || python3 -m venv scripts/venv

clean:
	rm -rf scripts/venv
	rm -rf temp
	rm -rf obj_dir
	rm -rf output

.PHONY: install clean test
