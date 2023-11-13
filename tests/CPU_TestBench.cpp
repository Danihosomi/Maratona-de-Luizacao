#include <stdlib.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "../obj_dir/VCPU.h"

#define str(x) #x".vcd"

#define MAX_SIM_TIME 1000
vluint64_t sim_time = 0;

void runSimulation() {
    VCPU *dut = new VCPU;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(str(VCPU));

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;
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
