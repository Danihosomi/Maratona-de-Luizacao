all: build run

build: *.v
	verilator --binary Tester.v --clk clk
	
run:
	./obj_dir/VTester