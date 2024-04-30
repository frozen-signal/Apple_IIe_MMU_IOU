# CPLD / FPGA Selection
## Device voltage
The Apple IIe being a 5v computer, using a 5v CPLD/FPGA will obviously be easier. Unfortunately, almost all all 5v CPLDs/FPGAs are now obsolete and are not produced anymore. They still can be found on such places as Aliexpress or ebay, but with high risk or being fake or non-functionnal.

On the other hand, new 3.3v CPLDs/FPGAs are easy to find. But having to level-shift to 5v makes it much more convoluted. More details about this [here](#place-2)

# Number of GPIOs
The device needs to have a minimum number of GPIOs depending on the ASIC:
| ASIC | Num<br/>GPIOs |
| - | - |
| IOU | 37 |
| MMU | 38  |

# Hold Times
Some signal need to hold their value for a certain delay. For example, see [DRAM hold times](/CUSTOM/DRAM_HOLD_TIME/readme.md). This implementation currently only offers the delays through Altera's LCELL buffers.<br/>
Essentially, you have these choices
- Select a CPLD/FPGA that has the LCELL primitive.
- Implement an alternate solution, through an oscillator primitive, a ring oscillator, or another helpful primitive supported by the device. You will need to write a [DRAM_HOLD_TIME](/CUSTOM/DRAM_HOLD_TIME/readme.md) entity. And if you build a MMU adapter, you will also need to write a [MMU_HOLD_TIME](/CUSTOM/MMU_HOLD_TIME/readme.md) entity.
- Add the hold times externally, for example through RC delay or a serie of NOT gates.

# Power-on initialization
The IOU need to detect the Power-On event. The current entity assumes that all flip-flops and other memory elements are initialized to '0' at power-on. If it's not the case for your device, you will need to write an alternate implementation of [POWER_ON_DETECTION](/CUSTOM/POWER_ON_DETECTION.vhdl)

# Bonding options
The schematics contains "hard-coded" values and bonding options. These are the values used:
```
64K: HIGH
VLC: LOW (refers to "Very Low Cost"; the codename of the Apple IIc)
INVIO': LOW
DIANA: HIGH ("Diana" was the codename for the Apple IIe)
```
Note that all parts of the schematics associated with unselected values of these bonding options has been left out of of this implementation.

# ASIC specifics

## IOU

### Signal names and Pins

| Signal | Pin | Notes |
| - | - | - |
LGR_TXT_N | 2 | OUT |
SEGA | 3 | OUT |
SEGB | 4 | OUT |
SEGC | 5 | OUT |
S_80COL_N | 6 | OUT |
CASSO | 7 | OUT |
SPKR | 8 | OUT |
MD7 | 9 | OUT, Tri-state |
AN0 | 10 | OUT |
AN1 | 11 | OUT |
AN2 | 12 | OUT |
AN3 | 13 | OUT |
R_W_N | 14 | IN |
RESET_N | 15 | BIDIR, Tri-state |
ORA0 | 17 | BIDIR, Tri-state |
ORA1 | 18 | BIDIR, Tri-state |
ORA2 | 19 | BIDIR, Tri-state |
ORA3 | 20 | BIDIR, Tri-state |
ORA4 | 21 | BIDIR, Tri-state |
ORA5 | 22 | BIDIR, Tri-state |
ORA6 | 23 | BIDIR, Tri-state |
ORA7 | 24 | OUT, Tri-state |
PRAS_N | 25 | IN |
PHI_0 | 26 | IN |
Q3 | 27 | IN |
A6 | 29 | IN |
C0XX_N | 30 | IN |
IAKD | 31 | IN |
IKSTRB | 32 | IN |
VID7 | 33 | IN |
VID6 | 34 | IN |
RA9_N | 35 | OUT |
RA10_N | 36 | OUT |
CLRGAT_N | 37 | OUT |
WNDW_N | 38 | OUT |
SYNC_N | 39 | OUT |
H0 | 40 | OUT |

### Other

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

### Other

There is nothing special that needs to be done.

# 5v Recommendation

The Altera EPM7128STC have been used in the development of this repository.

# Using 3.3v

Using a 3.3v FPGA needs a much more complex design. These are some of the aspects you will have to find a solution. Only the MMU has been tested with a 3.3v FPGA (a Lattice MachXO3D devlopment board)

## Level shifting 5v to 3.3v

The Apple IIe's 5v power needs to be level-shifted to 3.3v (and 1.2v if your device two different power voltages)

## FPGA configuration memory

If your device don't have non-volatile configuration memory, you will need a SPI Flash Memory

## Pin voltage level shift

Fortunately, 3.3v can drive 5v TTL logic, so output-only pins can be connected directly. All input-only pins must be level-shifted with components such as 74LVC245. In the case of bi-directional signals, the entities IOU and MMU will need to be modified in order to export the direction signal. Tri-state signals are similar; the enabling signal also need to be exported.
