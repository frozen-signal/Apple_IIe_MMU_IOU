# Description
The sources in this repository can be used to understand and interact with the different parts of the IOU and the MMU.

# About the sources
Throughout the code, there are comments that refers to the emulator schematics. The format is `[Schematics] @[Coords]:[Component]-[OutPin]`
For example this:
```
    -- MMU_1 @B-1:L2-8
    CASEN_N <= OCASEN_N and PHI_0;
```
refers to the schematic named `MMU_1.jpg`, at a location near `B-1` and is the output pin `8` of the component `L2`.

# Prerequisites
A VHDL compiler such as GHDL is required. Optionnally, you also need the `make` command to automate the build. And also optionnaly, a wave analyser such as GTKWave can be used to view the tests outputs.

# Compiling all
With the GNU command `make`, the process of analyzing and elaborating the entities can be automated.

### Cleaning the work library
```bash
make clean
```

### Importing units
The units must be imported when they have never been imported, after the library has been cleaned, and after any modification in the VHDL files.<br/>
```bash
make import VENDOR={ ALTERA }
```
VENDOR is optional; if omited, simulation units will be imported. Passing a VENDOR value is only used to generate the list of files required to build the IOU or the MMU<br/>
Note that only the vendor 'ALTERA' is currently supported.

### Building units
Once imported, the units must be built.<br/>
```bash
make build
```

### Running the tests
And then the tests can be run.
```bash
make test
```

### Obtaining the list of files
To obtain the list of files required to build the IOU or the MMU.<br/>
First, clean the work library:
```bash
make clean
```

Then import for the target device vendor:
```bash
make import VENDOR=ALTERA
```

And finally, generate the list of files for the desired ASIC:
```bash
make files ASIC={ MMU | IOU }
```
Where ASIC should be passed `MMU` or `IOU`.

# Compiling Manually
## Analysing the entity
VHDL files must first be analysed. For example for a file `my_vhdl_component.vhdl` run the command:
```bash
ghdl -a --workdir=work my_vhdl_component.vhdl
```

## Elaboration
Then, the component must be elaborated. For example, if the file above contains a component named `MY_VHDL_COMPONENT`, this would elaborate the component:
```bash
ghdl -e --workdir=work MY_VHDL_COMPONENT
```
Note that the components must be elaborated in their dependency order.

## Runing a testbench and generating a debug trace
Finally, to run a testbench once it has been analysed and elaborated, run this command
```bash
ghdl -r --workdir=work MY_COMPONENT_TB  --vcd=debug.vcd
```
This will run the testbench `MY_COMPONENT_TB` and dump the generated signals in the file `debug.vcd`. To view the dump, run:
```bash
gtkwave debug.vcd
```
