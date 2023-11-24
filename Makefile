all: compile-firmware build run

T?=CPU
test: ./output/V$(T).vcd

./output/V%.vcd: ./obj_dir/V% src/rom.hex
	test -d output || mkdir output;
	cp src/rom.hex output/rom.hex
	cd output; ../$<

./obj_dir/V%: src/%.v tests/%_TestBench.cpp src/*.v
	verilator -Isrc --trace --build -cc $< --exe $(word 2, $^)

./obj_dir/V%: src/%.v
	verilator -Isrc --trace -cc $<

TARGET_SOURCE?=main.c
src/rom.hex: install firmware/$(TARGET_SOURCE)
	test -d temp || mkdir temp;

	if [[ "$(suffix ${TARGET_SOURCE})" == ".c" ]]; then \
		sh scripts/firmware/compile_firmware_c.sh $(TARGET_SOURCE) src/rom.hex; \
	else \
		sh scripts/firmware/compile_firmware_asm.sh $(TARGET_SOURCE) src/rom.hex; \
	fi

compile-firmware: src/rom.hex

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

.PHONY: install clean test compile-firmware
