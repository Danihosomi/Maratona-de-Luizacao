#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "../obj_dir/VRegisterFile.h"

#define str(x) #x".vcd"

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

void testWriteRegister() {
    VRegisterFile *dut = new VRegisterFile;
    // Skipping first cycle as there is no edge
    dut->clk ^= 1; dut->eval();
    dut->clk ^= 1; dut->eval(); 

    std::cout << std::endl << "##### If we store something in a register #####" << std::endl;
    dut->writeRegisterIndex = 12;
    dut->writeRegisterData = 908321;
    dut->shouldWrite = true;

    dut->clk ^= 1; dut->eval();
    dut->clk ^= 1; dut->eval();

    dut->clk ^= 1;
    dut->source1RegisterIndex = 12;
    dut->shouldWrite = true;
    dut->eval();

    std::cout << "  We can read it later: ";
    assert(dut->source1RegisterData == 908321); std::cout << "OK!" << std::endl;

    delete dut;
}

void testReadAfterWrite() {
    VRegisterFile *dut = new VRegisterFile;
    // Skipping first cycle as there is no edge
    dut->clk ^= 1; dut->eval();

    std::cout << std::endl << "##### If we wanted to write something in the previous cycle #####" << std::endl;
    dut->writeRegisterIndex = 3;
    dut->writeRegisterData = 312;
    dut->shouldWrite = true;
    dut->clk ^= 1; dut->eval();

    std::cout << "  It is propagated in the rising clock: ";
    dut->source2RegisterIndex = 3;
    dut->clk ^= 1; dut->eval();
    assert(dut->source2RegisterData == 312); 
    std::cout << "OK!" << std::endl;

    std::cout << "  But not anywhere else: ";
    dut->writeRegisterData = 901;
    dut->clk ^= 1; dut->eval();
    assert(dut->source2RegisterData == 312); 
    std::cout << "OK!" << std::endl;

    delete dut;
}

void testZeroRegister() {
    VRegisterFile *dut = new VRegisterFile;
    dut->clk ^= 1; dut->eval();
    dut->clk ^= 1; dut->eval();

    std::cout << std::endl << "##### If we try to store anything in the zero register #####" << std::endl;
    dut->source1RegisterIndex = 0;
    dut->writeRegisterIndex = 0;
    dut->writeRegisterData = 21334;
    dut->shouldWrite = true;

    std::cout << "  It doesn't write anything: ";
    dut->clk ^= 1; dut->eval();
    dut->clk ^= 1; dut->eval();
    assert(dut->source1RegisterData == 0); 
    std::cout << "OK!" << std::endl;

    delete dut;
}

void runSimulation() {
    VRegisterFile *dut = new VRegisterFile;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(str(VRegisterFile));

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;
        dut->source1RegisterIndex = 1;
        dut->source2RegisterIndex = 2;
        dut->writeRegisterIndex = 1;
        dut->writeRegisterData = 10;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
}

int main(int argc, char** argv, char** env) {
    testZeroRegister();
    testWriteRegister();
    testReadAfterWrite();

    runSimulation();

    exit(EXIT_SUCCESS);
}