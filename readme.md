Note: This project is currently under development.

# Apple IIe MMU and IOU custom ICs

This is a VHDL implementation of the Apple IIe's MMU and IOU custom ICs, based on the actual schematics that were used during the development of the Apple IIe.

# Compiling and testing
## Prerequisites
A VHDL compiler such as GHDL is required, and optionnaly a wave analyser such as GTKWave can be used to view the tests outputs.
## Compiling
VHDL files must first be analysed. For example for a file `my_vhdl_component.vhdl` run the command:
```bash
ghdl -a --std=08 --workdir=work my_vhdl_component.vhdl
```
Then, the component must be elaborated. For example, if the file above contains a component named `MY_VHDL_COMPONENT`, this would elaborate the component:
```bash
ghdl -e --std=08 --workdir=work MY_VHDL_COMPONENT
```
Finally, to run a testbench once it has been analysed and elaborated, run this command
```bash
ghdl -r --std=08 --workdir=work MY_COMPONENT_TB  --vcd=debug.vcd
```
This will run the testbench `MY_COMPONENT_TB` and dump the generated signals in the file `debug.vcd`. To view the dump, run:
```bash
gtkwave debug.vcd
```
## Compiling all
Alternatively, all the sources can be analysed and elaborated with this command:
```bash
./make.sh
```
And all testbenches can be simulated with this command:
```bash
./testall.sh
```

# Directory Structure
* **COMMON**: Components common to the MMU and the IOU.
* **TTL**: Implementation of a few TTL components used in the schematics.
* **MMU**: Components that makes the MMU.
* **test**: Testing components, testbenches and test-cases; has the same structure as the base directory.

# Notation in the code that references the schematics.
Throughout the code, there are comments that refers to the logic schematics. The format is `[Schematics] @[Coords]:[Component]-[OutPin]`
For example this:
```
    -- MMU_1 @B-1:L2-8
    CASEN_N <= OCASEN_N and PHI_0;
```
refers to the schematic named `MMU_1.jpg`, at a location near `B-1` and is the output pin `8` of the component `L2`.

# Notes:
## In development
This project is in development; the IOU has not been completed yet and the MMU likely still contains problems.
To facilitate debugging, the logic is exactly (except when noted otherwise in the sources) as seen in the schematics; simplification of the logic will be done later.

## Bonding options
The schematics contains "hard-coded" values and bonding options. These are the values used:
```
64K: HIGH
VLC: LOW
INVIO': LOW
DIANA: HIGH
```
