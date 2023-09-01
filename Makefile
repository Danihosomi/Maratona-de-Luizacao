all: compile-firmware build run

build: *.v
	verilator --binary Tester.v --clk clk
	
run:
	./obj_dir/VTester

.PHONY: test
test: ./output/V$(T).vcd

./output/V%.vcd: ./obj_dir/V%
	test -d output || mkdir output;
	cd output; ../$<

./obj_dir/V%: %.v tests/%_TestBench.cpp *.v
	verilator --trace --build -cc $< --exe $(word 2, $^)

./obj_dir/V%: %.v
	verilator --trace -cc $<

TARGET_ASSEMBLY_FILE?="main.asm"
compile-firmware: install
	( \
       . scripts/venv/bin/activate; \
	   test -d temp || mkdir temp; \
	   bronzebeard --include assembly/ --output temp/firmware.data assembly/$(TARGET_ASSEMBLY_FILE); \
       python3 scripts/compile_firmware.py --src temp/firmware.data --dest ROMMemory.v \
    )


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

.PHONY: install clean compile-firmware
