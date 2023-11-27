## A quick update on the project
We are currently experiencing small issues in the production of the release candidate units. Once produced, we will carefully re-test everything, and then the retail units will be available. It's hard to estimate a timeframe for when they will be available, but my guess is that they will be released in early 2024.
<br/><br/>But rest assured, this project is NOT abandonned.

# Apple IIe MMU and IOU custom ICs

This is a VHDL implementation of the Apple IIe's MMU and IOU custom ICs, based on the actual schematics that were used during the development of the Apple IIe.

## In development
Note: This project is currently under development and, although functionnal, is not ready to be used in a hardware implementation.<br/>
<br/>
![IOU](https://img.shields.io/badge/IOU-Fully_Functionnal-green)<br/>
![MMU](https://img.shields.io/badge/MMU-Fully_Functionnal-green)<br/>

## Tested Hardware
The implementation has been tested with these hardware components:

### IOU
- Motherboards:
  - Rev.B motherboard.
- CPU:
  - 6502 with unenhanced ROMs
  - 65C02 with enhanced ROMS
  - A recent WDC65C02 with enhanced ROMS
- AUX Cards:
  - RAMWORKS III aux card
  - 80-Col Expansion card (820-0067-B)
  - 80-Col Expansion card (820-0067-D)
- ROMs:
  - Enhanced ROMS from ReActiveMicro
  - Unhanced ROMS (342-0132-B, 342-0133-A, 342-0134-A, 342-0135-A)
- Disk Interfaces
  - Apple 5.25 Drive Controller Card (655-0101-E)
  - Disk ][ Interface Card (650-X104)
- Other
  - Mouse Interface 670-0030-C

### MMU
<b>Note</b>: The MMU still need more tests.
- Motherboards:
  - Rev.B motherboard.
- CPU:
  - 6502 with unenhanced ROMs
- AUX Cards:
  - 80-Col Expansion card (820-0067-B)
  - 80-Col Expansion card (820-0067-D)
- ROMs:
  - Unhanced ROMS (342-0132-B, 342-0133-A, 342-0134-A, 342-0135-A)
- Disk Interfaces
  - Apple 5.25 Drive Controller Card (655-0101-E)

### Note
To facilitate debugging, the code has been kept very close to the logic seen in the schematics, at the cost of efficiency and readibility. Simplifications and cleaning of the sources will be done later.

# Compiling and testing
## Prerequisites
A VHDL compiler such as GHDL is required, and optionnaly a wave analyser such as GTKWave can be used to view the tests outputs.
## Compiling
VHDL files must first be analysed. For example for a file `my_vhdl_component.vhdl` run the command:
```bash
ghdl -a --workdir=work my_vhdl_component.vhdl
```
Then, the component must be elaborated. For example, if the file above contains a component named `MY_VHDL_COMPONENT`, this would elaborate the component:
```bash
ghdl -e --workdir=work MY_VHDL_COMPONENT
```
Finally, to run a testbench once it has been analysed and elaborated, run this command
```bash
ghdl -r --workdir=work MY_COMPONENT_TB  --vcd=debug.vcd
```
This will run the testbench `MY_COMPONENT_TB` and dump the generated signals in the file `debug.vcd`. To view the dump, run:
```bash
gtkwave debug.vcd
```
## Compiling all
Alternatively, the 'make' utility can be used.
The units must be imported when they have never been imported, after the library has been cleaned, and after any modification in the VHDL files.<br/>
Once imported, the units must be built.<br/>
And then the tests can be run.

### Cleaning the work library
```bash
make clean
```

### Importing units
```bash
make import VENDOR={ ALTERA | iCE40 | MachX03D }
```
VENDOR is optional; if omited, simulation units will be imported.<br/>
When VENDOR is used, one of the supported devices must be passed:
- `ALTERA`
- `iCE40`
- `MachX03D`

### Building units
```bash
make build
```

### Running the tests
```bash
make test
```

### Obtaining the list of files
To obtain the list of files required to build the IOU or the MMU.<br/>
First, import the correct units with the `import` target.<br/>
Then use:
```bash
make files ASIC={ MMU | IOU }
```
Where ASIC should be passed `MMU` or `IOU`.

# Directory Structure
* **COMMON**: Components common to the MMU and the IOU.
* **CUSTOM**: Components that may need to be changed depending on the hardware used.
* **TTL**: Implementation of a few TTL components used in the schematics.
* **MMU**: Components that makes the MMU.
* **IOU**: Components that makes the IOU.
* **test**: Testing components, testbenches and test-cases; has the same structure as the base directory.

# Notation in the code that references the schematics.
Throughout the code, there are comments that refers to the emulator schematics. The format is `[Schematics] @[Coords]:[Component]-[OutPin]`
For example this:
```
    -- MMU_1 @B-1:L2-8
    CASEN_N <= OCASEN_N and PHI_0;
```
refers to the schematic named `MMU_1.jpg`, at a location near `B-1` and is the output pin `8` of the component `L2`.

# Notes:
## Bonding options
The schematics contains "hard-coded" values and bonding options. These are the values used:
```
64K: HIGH
VLC: LOW (refers to "Very Low Cost"; the codename of the Apple IIc)
INVIO': LOW
DIANA: HIGH ("Diana" was the codename for the Apple IIe)
```
Note that all parts of the schematics associated with unselected values of these bonding options has been left out of of this implementation.

## Hardware implementation
### IOU RESET_N pin
The RESET_N pin (pin 15) of the IOU need to be pulled-up. If the CPLD/FPGA do not support internal pull-up, a 10K ohms resistor should be used.

### Tri-State pins
A hardware solution should take care not to break the tri-state capability of some of the pins of the MMU and IOU, for example by using a bus tranceiver without exporting a corresponding 'enable' signal from the VHDL.
These are the tri-state pins and their corresponing enable signal:

**MMU**:
| Pin(s) | Enable signal |
| --- | --- |
| ORA0-7  | RA_ENABLE_N |
| MD7  | MD7_ENABLE_N |

**IOU**:
| Pin(s) | Enable signal | Notes |
| --- | --- | --- |
| PIN_RESET_N  | FORCE_RESET_N_LOW | The IOU will force RESET_N low for ~35ms after power-on, then will let external components drive this signal. |
| ORA0-7  | RA_ENABLE_N | Depending on the timings, ORA will be an input, an output pin or tri-state. |
| MD7  | MD7_ENABLE_N | |

## License

This repository is licensed under the Creative Commons Zero License. You are free to use, modify, distribute, and build upon the code in any way you see fit. The Creative Commons License grants you the freedom to adapt the code for personal, academic, commercial, or any other purposes without seeking explicit permission.
