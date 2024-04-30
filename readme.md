# Apple IIe MMU and IOU custom ICs

This is a VHDL implementation of the Apple IIe's MMU and IOU custom ICs, based on the actual schematics that were used during the development of the Apple IIe.

## Project status
The prototype of the IOU has been tested and is functionnal. There currently no known issue with the MMU or the IOU. More testing is needed, as well as code cleaning and more commenting. Also maybe an effort to bring the signals timings closer to the ASICs<br/>
<br/>
![IOU](https://img.shields.io/badge/IOU-Fully_Functionnal-green)<br/>
![MMU](https://img.shields.io/badge/MMU-Fully_Functionnal-green)<br/>
![Tested](https://img.shields.io/badge/Tested-Tested_but_not_thoroughly-yellow)<br/>
![Documentation](https://img.shields.io/badge/Documentation-Mininal-red)<br/>

## Tested Hardware
The implementation has been tested with these hardware components:

- Motherboards:
  - Rev.B motherboard.
- CPU:
  - Synertek 6502 (unenhanced ROMs)
  - Rockwell 6502 (unenhanced ROMs)
  - 65C02 (enhanced ROMs)
  - A recent WDC65C02 (with pins mod) with enhanced ROMS
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

# Directory Structure
* **COMMON**: Components common to the MMU and the IOU.
* **CUSTOM**: Components that may need to be changed depending on the hardware used.
* **TTL**: Implementation of a few TTL components used in the schematics.
* **MMU**: Components that makes the MMU.
* **IOU**: Components that makes the IOU.
* **Documentation**: Help on understanding the IOU and MMU, and help on implementing hardware replacement adapters.
* **test**: Testing components, testbenches and test-cases; has the same structure as the base directory.

## License

This repository is licensed under the Creative Commons Zero License. You are free to use, modify, distribute, and build upon the code in any way you see fit. The Creative Commons License grants you the freedom to adapt the code for personal, academic, commercial, or any other purposes without seeking explicit permission.
