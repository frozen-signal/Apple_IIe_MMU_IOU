Under development

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
make import
```

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
