# TL;DR
Use a 5v CPLD. In doubt, use the Altera EPM7128STC. The MMU don't need anything special, besides decoupling capacitors and JTAG programming pins. The IOU need the same things, plus a 10K pull-up resistor on /RESET.

# CPLD / FPGA Selection
## Device voltage
The Apple IIe being a 5v computer, using a 5v CPLD/FPGA will obviously be easiest. Unfortunately, almost all 5v CPLDs/FPGAs have gone out of production. Modern CPLDs/FPGAs are all 3.3v and will need the Apple's 5v to be level-shifted down to 3.3v. This is of course more complex, and some details about this can be found [below](# Using 3.3v)

# Number of GPIOs
The device needs to have a minimum number of GPIOs depending on the ASIC:
| ASIC | Num<br/>GPIOs |
| - | -: |
| IOU | 37 |
| MMU | 38  |

# Hold Times
Some signals need to hold their value for a certain amount of time. For example, see [DRAM hold times](/CUSTOM/DRAM_HOLD_TIME/readme.md). This implementation currently only offers the delays through Altera's LCELL buffers.<br/>
Essentially, you have these choices
- Select a CPLD/FPGA that has the LCELL primitive.
- Implement an alternate solution, through an oscillator primitive, a ring oscillator, using the Apple's 14M signal, or another way using the selected device. You will need to write a [DRAM_HOLD_TIME](/CUSTOM/DRAM_HOLD_TIME/readme.md) entity. And if you build a MMU adapter, you will also need to write a [MMU_HOLD_TIME](/CUSTOM/MMU_HOLD_TIME/readme.md) entity.
- Add the hold times externally, for example through RC delay or through a serie of logic gates.

# Power-on initialization
The IOU need to detect the Power-On event. The current entity assumes that all flip-flops and other memory elements are initialized to '0' at power-on. If it's not the case for your device, you will need to write an alternate implementation of [POWER_ON_DETECTION](/CUSTOM/POWER_ON_DETECTION.vhdl)

# Bonding options
The schematics contains "hard-coded" values and bonding options. These are the values used:
| Bonding<br/>Option | Value | Notes |
| --- | --- | --- |
| 64K | HIGH | |
| VLC | LOW | Refers to "Very Low Cost"; the codename of the Apple IIc |
| INVIO' | LOW | |
| DIANA | HIGH | "Diana" was the codename for the Apple IIe |

Note that all parts of the schematics associated with unselected values of these bonding options has been left out of of this implementation.

# ASIC specifics

## IOU

### Signal names and Pins

| Signal | Pin | Notes |
| - | - | - |
| LGR_TXT_N | 2 | OUT |
| SEGA | 3 | OUT |
| SEGB | 4 | OUT |
| SEGC | 5 | OUT |
| S_80COL_N | 6 | OUT |
| CASSO | 7 | OUT |
| SPKR | 8 | OUT |
| MD7 | 9 | OUT, Tri-state |
| AN0 | 10 | OUT |
| AN1 | 11 | OUT |
| AN2 | 12 | OUT |
| AN3 | 13 | OUT |
| R_W_N | 14 | IN |
| RESET_N | 15 | BIDIR, Tri-state |
| ORA0 | 17 | BIDIR, Tri-state |
| ORA1 | 18 | BIDIR, Tri-state |
| ORA2 | 19 | BIDIR, Tri-state |
| ORA3 | 20 | BIDIR, Tri-state |
| ORA4 | 21 | BIDIR, Tri-state |
| ORA5 | 22 | BIDIR, Tri-state |
| ORA6 | 23 | BIDIR, Tri-state |
| ORA7 | 24 | OUT, Tri-state |
| PRAS_N | 25 | IN |
| PHI_0 | 26 | IN |
| Q3 | 27 | IN |
| A6 | 29 | IN |
| C0XX_N | 30 | IN |
| IAKD | 31 | IN |
| IKSTRB | 32 | IN |
| VID7 | 33 | IN |
| VID6 | 34 | IN |
| RA9_N | 35 | OUT |
| RA10_N | 36 | OUT |
| CLRGAT_N | 37 | OUT |
| WNDW_N | 38 | OUT |
| SYNC_N | 39 | OUT |
| H0 | 40 | OUT |

### Files needed
These are the VHDL files needed to build the IOU:
- All the files in COMMON
- /COMMON/POWER_ON_DETECTION.vhdl
- DRAM_HOLD_TIME
  - The hold time will be done externally: use the NOP version
  - The device supports LCELLs: use the VENDOR/ALTERA version
  - Otherwise, a user-defined implementation.
- All the files in IOU
- All the files in TTL

### Other

#### Generate the PAL version of the IOU

To generate the PAL version, the parameter `NTSC_CONSTANT` must be changed to '0' in the [IOU top-level entity](/IOU/IOU.vhdl)

#### /RESET Pull-up
The /RESET (pin 15) on the IOU need to be pulled-up. The schematics calls for a 3.3K resistor, and a 10K also works fine.

## MMU

### Signal names and Pins

| Signal | Pin | Notes |
| - | - | - |
| A0 | 2 | IN |
| PHI_0 | 3 | IN |
| Q3 | 4 | IN |
| PRAS_N | 5 | IN |
| ORA0 | 6 | OUT, Tri-State |
| ORA1 | 7 | OUT, Tri-State |
| ORA2 | 8 | OUT, Tri-State |
| ORA3 | 9 | OUT, Tri-State |
| ORA4 | 10 | OUT, Tri-State |
| ORA5 | 11 | OUT, Tri-State |
| ORA6 | 12 | OUT, Tri-State |
| ORA7 | 13 | OUT, Tri-State |
| R_W_N | 14 | IN |
| INH_N | 15 | IN |
| DMA_N | 16 | IN |
| EN80_N | 17 | OUT |
| KBD_N | 18 | OUT |
| ROMEN2_N | 19 | OUT |
| ROMEN1_N | 20 | OUT |
| MD7 | 21 | OUT, Tri-State |
| R_W_N_245 | 22 | OUT |
| CASEN_N | 23 | OUT |
| CXXXOUT | 24 | OUT |
| A15 | 26 | IN |
| A14 | 27 | IN |
| A13 | 28 | IN |
| A12 | 29 | IN |
| A11 | 30 | IN |
| A10 | 31 | IN |
| A9 | 32 | IN |
| A8 | 33 | IN |
| A7 | 34 | IN |
| A6 | 35 | IN |
| A5 | 36 | IN |
| A4 | 37 | IN |
| A3 | 38 | IN |
| A2 | 39 | IN |
| A1 | 40 | IN |

### Files needed
These are the VHDL files needed to build the MMU:
- All the files in COMMON
- DRAM_HOLD_TIME
  - The hold time will be done externally: use the NOP version
  - The device supports LCELLs: use the VENDOR/ALTERA version
  - Otherwise, a user-defined implementation.
- MMU_HOLD_TIME
  - The hold time will be done externally: use the NOP version
  - The device supports LCELLs: use the VENDOR/ALTERA version
  - Otherwise, a user-defined implementation.
- All the files in MMU
- The file LATCH_9334 in TTL


### Other

There is nothing special that needs to be done for the MMU.

# 5v Recommendation

The Altera EPM7128STC have been used in the development of this repository.
<br/>
<br/>
<br/>
# Using 3.3v

Using a 3.3v FPGA needs a much more complex design. These are some of the aspects you will have to find a solution. Only the MMU has been tested with a 3.3v FPGA (a Lattice MachXO3D development board).

## Level shifting 5v to 3.3v

Unless you are using a 5v tolerant device, the Apple IIe's 5v power needs to be level-shifted to 3.3v (and 1.2v if your device two different power voltages).

## FPGA configuration memory

If your device don't have non-volatile configuration memory, you will need a SPI Flash Memory.

## Pin voltage level shift

### Input and Output only pins

Fortunately, 3.3v can drive 5v TTL logic, so output-only pins can be connected directly. All input-only pins must be level-shifted with components such as 74LVC245.

### Bidirectional pins

In the case of bi-directional signals, they also need to be level-shifted. But a component such as a 74LVC245 will need the corresponding direction signal and it is not exposed. This means that the sources of the [IOU top-level entity](/IOU/IOU.vhdl) will need to be modified to expose these direction signals:

| Signal | Direction Signal | Notes |
| - | - | - |
| RESET_N | FORCE_RESET_N_LOW | When FORCE_RESET_N_LOW is LOW, RESET_N should be an input; when HIGH it should be an output. Also remember to place the pull-up on the Apple's side of RESET_N |
| ORA6-0 | RA_ENABLE_N | When RA_ENABLE_N is HIGH, ORA6-0 should be inputs; when LOW they should be outputs. |
