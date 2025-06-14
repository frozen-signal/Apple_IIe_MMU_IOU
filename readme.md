# Apple IIe MMU and IOU custom ICs

## Project Overview

The Apple IIe’s IOU (Input/Output Unit) and MMU (Memory Management Unit) are two custom integrated circuits (ICs) that played a crucial role in the computer’s design. Developed by Apple in the early 1980s, these chips consolidated much of the system’s complex circuitry into single components. However, once Apple ceased production of the Apple IIe, the manufacture of these chips also stopped. For decades, the only way to replace a faulty IOU or MMU has been to scavenge them from other Apple IIe units—a diminishing resource.
<br/>
This project offers a modern solution: a VHDL-based reimplementation of the Apple IIe's IOU and MMU, faithfully based on original Apple schematics. The goal is to preserve the technology behind these essential ICs and provide the means to create replacement adapters, ensuring that damaged chips no longer spell the end for an Apple IIe.

## Important Notice

This project is code-only and does not include any hardware designs such as Gerber files or a Bill of Materials (BOM) for building physical adapters.<br/>
The hardware projects are located here:
### 3.3V Adapter reference designs
- [3.3V IOU adapter](https://github.com/frozen-signal/Apple_IIe_IOU_3V3)
- [3.3V MMU adapter](https://github.com/frozen-signal/Apple_IIe_MMU_3V3)
### 5V Adapter reference designs
- 5V IOU adapter (To be done)
- 5V MMU adapter (To be done)

## Project status
The IOU and MMU has been thoroughly tested and is functionnal.
<br/>
![IOU](https://img.shields.io/github/issues-search?query=repo%3Afrozen-signal%2FApple_IIe_MMU_IOU%20is%3Aopen%20label%3Abug%20label%3AIOU&label=IOU%20Issues
)<br/>
![MMU](https://img.shields.io/github/issues-search?query=repo%3Afrozen-signal%2FApple_IIe_MMU_IOU%20is%3Aopen%20label%3Abug%20label%3AMMU&label=MMU%20Issues
)<br/>
![Tests](https://img.shields.io/badge/Tests-Thoroughly_tested-green)<br/>

## Tested Hardware

| Category         | Hardware Components |
|------------------|---------------------|
| **Motherboards** | <ul><li>Rev.B motherboard (NTSC)</li><li>ReActiveMicro IIe motherboard (NTSC)</li></ul> |
| **CPUs**         | <ul><li>Synertek 6502 (unenhanced ROMs)</li><li>Rockwell R6502AP (unenhanced ROMs)</li><li>UMC UM6502 (unenhanced ROMs)</li><li>GTE G65SC02P-2 (enhanced ROMs)</li><li>NCR 65C02 (enhanced ROMs)</li><li>Rockwell R65C02P4 (enhanced ROMs)</li></ul> |
| **AUX Cards**    | <ul><li>RAMWorks III</li><li>80-Column Expansion Card (820-0067-B)</li><li>80-Column Expansion Card (820-0067-D)</li></ul> |
| **ROMs**         | <ul><li>Enhanced ROM set (ReActiveMicro)</li><li>Unenhanced ROMs:<ul><li>342-0132-B</li><li>342-0133-A</li><li>342-0134-A</li><li>342-0135-A</li></ul></li></ul> |
| **Disk Interfaces** | <ul><li>Apple 5.25" Drive Controller Card (655-0101-E)</li><li>Disk ][ Interface Card (650-X104)</li></ul> |
| **Other**        | <ul><li>Mouse Interface Card (670-0030-C)</li></ul> |

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
