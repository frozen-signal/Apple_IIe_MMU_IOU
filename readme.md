# Apple IIe MMU and IOU custom ICs

## Project Overview

The Apple IIe’s IOU (Input/Output Unit) and MMU (Memory Management Unit) are two custom integrated circuits (ICs) that played a crucial role in the computer’s design. Developed by Apple in the early 1980s, these chips consolidated much of the system’s complex circuitry into single components. However, once Apple ceased production of the Apple IIe, the manufacture of these chips also stopped. For decades, the only way to replace a faulty IOU or MMU has been to scavenge them from other Apple IIe units — a diminishing resource.
<br/>
This project offers a modern solution: a VHDL-based reimplementation of the Apple IIe's IOU and MMU, faithfully based on original Apple schematics. The goal is to preserve the technology behind these essential ICs and provide the means to create replacement adapters, ensuring that damaged chips no longer spell the end for an Apple IIe.

## Project status
![Tests](https://img.shields.io/badge/Tests-Thoroughly_tested-green)<br/>


## Hardware adapters

This project is code portion of the IOU / MMU.<br/>
Although it does not target a specific FPGA or CPLD, some reference hardware PCB designs are available here:
### 3.3V Adapter reference designs
- [3.3V IOU adapter](https://github.com/frozen-signal/Apple_IIe_IOU_3V3)
- [3.3V MMU adapter](https://github.com/frozen-signal/Apple_IIe_MMU_3V3)
### 5V Adapter reference designs
- 5V IOU adapter (Coming soon)
- 5V MMU adapter (Coming soon)

## Obtaining an adapter

### Buying it
The two official stores where to buy the IOU and MMU adapters are _ReActiveMicro_ and _Ralle Palaveev's store_.<br/>
<br/>
<a href="https://apple2.co.uk/Products">Ralle Palaveev's store</a><br/>
<a href="https://www.reactivemicro.com/">ReActiveMicro</a> (Available soon)<br/>
<br/>

### Making it yourself
You can of course use the reference design projects above to order the adapters at your favorite fab house.<br/>
And the most dedicated users can design their own adapters from scratch. See [Building and adapter](Documentation/building-an-adapter.md).

## Acknowledgements

This project was made possible thanks to the support and contributions of a few key individuals.<br/>
Notable thanks go to:
 * **Henry S. Courbis of ReActiveMicro** not only was instrumental in the development of the VHDL code but also was the spark that initiated this project. His generous support and deep technical insight made this project possible.
 * **[Ralle Palaveev](https://github.com/rallepalaveev)** is more than a contributor — he is the co-creator of the 3.3V adapters. His impressive skills made what seemed impossible look easy: fitting everything into a 40-pin DIP-sized PCB.

And lastly, a special thanks to **Leeland Heins [@SoftwareJanitor](https://github.com/softwarejanitor)**, who thoroughly tested this project. His steady encouragement was a much-appreciated source of motivation during the tougher stretches of development.

## Tested Hardware

| Category         | Hardware Components |
|------------------|---------------------|
| **Motherboards** | <ul><li>Rev.B motherboard (NTSC)</li><li>ReActiveMicro IIe motherboard (NTSC)</li><li>Pravetz 8E</li><li>Pravetz 8A</li></ul> |
| **CPUs**         | <ul><li>Synertek 6502 (unenhanced ROMs)</li><li>Rockwell R6502AP (unenhanced ROMs)</li><li>UMC UM6502 (unenhanced ROMs)</li><li>GTE G65SC02P-2 (enhanced ROMs)</li><li>NCR 65C02 (enhanced ROMs)</li><li>Rockwell R65C02P4 (enhanced ROMs)</li><li>WDC 65C02S (with adapter)</li></ul> |
| **AUX Cards**    | <ul><li>RAMWorks III (512M)</li><li>80-Column Expansion Card (820-0067-B)</li><li>80-Column Expansion Card (820-0067-D)</li><li>AE Ramworks ][</li><li>Apple "Slinky" RAM card</li></ul> |
| **ROMs**         | <ul><li>Enhanced ROM set (ReActiveMicro)</li><li>Unenhanced ROMs:<ul><li>342-0132-B</li><li>342-0133-A</li><li>342-0134-A</li><li>342-0135-A</li></ul></li></ul> |
| **Disk Interfaces/Drive** | <ul><li>Apple 5.25" Drive Controller Card (655-0101-E)</li><li>Disk ][ Interface Card (650-X104)</li><li>Apple Disk II Drive</li><li>NVRam Drive</li><li>BOMW FloppyEMU</li><li>A2DISK</li><li>Franklin floppy controller</li></ul> |
| **Other**        | <ul><li>Mouse Interface Card (670-0030-C)</li><li>Thunderclock Plus</li><li>A2VGA mouse emulation</li><li>Booti</li><li>TJ Boldt's ROM-Drive v4.0</li><li>Grappler+</li><li>A2DVI</li><li>A2Pico</li><li>A2VGA</li><li>Romcard</li><li>Romcard2</li><li>Romcard3</li><li>A2RESET v1,v2</li><li>AE Transwarp</li><li>Titan Accellerator //e</li><li>Ian Kim A2 Turbo</li><li>MS Z80 Softcard clone</li></ul> |

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
