# Dependencies
Our toolchain is mostly based around `Make`, so you will want to have it
installed. For now, the only exception to this is if you wish to program it to the 
FPGA, in which case you should use the Gowin IDE directly on Windows or Linux

## Firmware
For compiling the firmware from c code you will need to have the risc-v toolchain
installed. For MacOS you cand find instructions 
[here](https://github.com/riscv-software-src/homebrew-riscv), though please note I couldn't install it on
MacOS Monterey and updated to MacOS Ventura, in which case it installs from
precompilled binaries.

If you wish to compile the firmaware from asm code, we use the python package
[bronzebeard](https://github.com/theandrew168/bronzebeard). We install it
as a step in our toolchain, so just make sure you have a venv compatible python
installation.

# Running

For running the project in the FPGA, just run it on the Gowin IDE. If you wish
to update the firmware code, run `make compile-firmware` to generate the hex
file. You can specify a file inside the `firmware` folder using the optional
parameter `TARGET_SOURCE` which defaults to `main.c`. For example:

`make compile-firmware TARGET_SOURCE=main.asm`

# Testing

We use `verilator` as our testbench tool and visualize the results using 
`GTKWave`. To run the simulation, simply execute `make test`. You can also
specify a verilog unit file to test with the optional parameter `T` which
defaults to `CPU.v`. Most of the cases you will want to use the default value.

After runnning the simulation, it will output the waveform to `output/VCPU.vcd`.
You can run `GTKWave` from the command line with `gtkwave output/VCPU.vcd` and 
simply refresh it after running the simulation.

So a normal development flow looks like this:

```
gtkwave output/VCPU.vcd # In another shell to keep the visualization open

make test
# ... Refresh the view on gtkwave
# change code
make test
# ... Refresh the view on gtkwave
```
