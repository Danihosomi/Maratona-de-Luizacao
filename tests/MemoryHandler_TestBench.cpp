#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "../obj_dir/VMemoryHandler.h"

#define str(x) #x".vcd"

#define MAX_SIM_TIME 300
vluint64_t sim_time = 0;

void runSimulation() {
    VMemoryHandler *dut = new VMemoryHandler;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(str(VMemoryHandler));

    dut->dataMemoryWriteEnable = 1;
    dut->dataMemoryReadEnable = 0;
    dut->dataMemoryAddress = 0;
    dut->dataMemoryDataIn = 1;
    while (sim_time < MAX_SIM_TIME) {
        dut->dataMemoryWriteEnable ^= 1;
        dut->dataMemoryReadEnable ^= 1;
        dut->dataMemoryAddress += 4;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
}

int main(int argc, char** argv, char** env) {
    runSimulation();

    exit(EXIT_SUCCESS);
}