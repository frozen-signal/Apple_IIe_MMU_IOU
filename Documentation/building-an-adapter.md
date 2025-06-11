**Note: This documentation is incomplete / needs to be improved.**

Hardware reference designs can be found here:
### 3.3V Adapter reference designs
- [3.3V IOU adapter](https://github.com/frozen-signal/Apple_IIe_IOU_3V3)
- [3.3V MMU adapter](https://github.com/frozen-signal/Apple_IIe_MMU_3V3)
### 5V Adapter reference designs
- 5V IOU adapter (To be done)
- 5V MMU adapter (To be done)


# Building an IOU/MMU adapter

## Note

This project do not target a specific device, however the author of this project used an ALTERA MAX7000S EPM7128STC100-10N for a 5V design, and a MACHXO2 for a 3.3V one.

## Pinouts

### IOU

The pinout of the IOU:

| Signal | Pin | Notes |
| - | - | - |
| *GND* | 1 | Ground pin |
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
| RESET_N | 15 | BIDIR, Open-drain |
| NOT CONNECTED | 16 | Not connected |
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
| *Vcc* | 27 | +5V pin |
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

### MMU

The pinout of the MMU:

| Signal | Pin | Notes |
| - | - | - |
| *GND* | 1 | Ground pin |
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
| *Vcc* | 25 | +5V pin |
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

## Step 1 - Hardware design

### 5V or 3.3V device

The Apple IIe is a 5V computer, so using a 5V FPGA or CPLD would be easiest. However, if you choose to use a 3.3V device, you'll need additional circuits for voltage level translation. More information on 3.3V device design can be found in [Building a 3.3V adapter](/Documentation/building-an-adapter.md#building-a-33v-adapter).

### Number of GPIOs

The device needs to have a minimum number of GPIOs depending on the ASIC:
| ASIC | Number of GPIOs |
| - | -: |
| IOU | 37 |
| MMU | 38  |


### Hold Time Delay

**Important!**

Some signals in the IOU and MMU require hold times. Your design needs to have the means to add the required delays. This can be achieved through various methods, for example:

- Using specific IP on the device (such as ALTERA's LCELL)
- Using an oscillator
- Chaining out-in pins
- Using an RC circuit
- Using logic gates

If you decide to use an ALTERA MAX7000S EPM7128STC100-10N, this project should work as-is. In any other case however, you'll need to implement or modify some source files (more details in Step 2).

### Pull-up Resistor

On the IOU, a weak pull-up is needed on /RESET (Pin 15). The schematic calls for a 3.3K resistor, but the author used a 10K pull-up resistor.

## Step 2 - HDL Development Suite Project

In your device's toolchain, create a project and add and/or create the files as directed below:

### Project for the IOU

#### Required Files

- All files in the COMMON directory
- `/COMMON/POWER_ON_DETECTION.vhdl`
- All files in the IOU directory
- All files in the TTL directory


#### Required CUSTOM files

Depending on the device you're using, you'll need to customize the hold time. Here are the options:
1. **Exactly an ALTERA MAX7000S EPM7128STC100-10N:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl`
1. **An ALTERA device that supports LCELL:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl` and adjust NUM_LCELLS_RAS and NUM_LCELLS_Q3<br/>**See note**
1. **An external delay circuit (e.g., an RC circuit):**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/NOP/DRAM_HOLD_TIME.vhdl`<br/> **See note**
1. **Any other method (e.g., using an internal oscillator)**<br/>Implement a DRAM_HOLD_TIME entity that will add the necessary hold times.<br/>**See note**

**NOTE:** Ensure your solution meets the timing specifications detailed [here](/CUSTOM/DRAM_HOLD_TIME/readme.md)

#### NTSC vs PAL Version

By default, this project will produce an NTSC version of the IOU. If you need the PAL version, change the value of `NTSC_CONSTANT` to '0' in the file `/IOU/IOU.vhdl`

### Project for the MMU

#### Required Files

- All files in the COMMON directory
- All files in the MMU directory
- The file LATCH_9334 in the TTL directory

#### Required CUSTOM files

Depending on the device you're using, you'll need to customize the hold time in two entities. Here are the options:

1. DRAM_HOLD_TIME entity:
    1. **Exactly an ALTERA MAX7000S EPM7128STC100-10N:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl`
    1. **An ALTERA device that supports LCELL:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl` and adjust NUM_LCELLS_RAS and NUM_LCELLS_Q3<br/>**See note**
    1. **An external delay circuit (e.g., an RC circuit):**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/NOP/DRAM_HOLD_TIME.vhdl`<br/> **See note**
    1. **Any other method (e.g., using an internal oscillator)**<br/>Implement a DRAM_HOLD_TIME entity that will add the necessary hold times.<br/>**See note**

1. MMU_HOLD_TIME entity:
    1. **Exactly an ALTERA MAX7000S EPM7128STC100-10N:**<br/>Add the file `CUSTOM/MMU_HOLD_TIME/VENDOR/ALTERA/MMU_HOLD_TIME.vhdl`
    1. **An ALTERA device that supports LCELL:**<br/>Add the file `CUSTOM/MMU_HOLD_TIME/VENDOR/ALTERA/MMU_HOLD_TIME.vhdl` and adjust NUM_LCELLS **(See note)**
    1. **An external delay circuit (e.g., an RC circuit):**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/NOP/MMU_HOLD_TIME.vhdl` **(See note)**
    1. **Any other method (e.g., using an internal oscillator):**<br/>Implement an MMU_HOLD_TIME entity that will add the necessary hold times. **(See note)**

**NOTE:** Ensure your solution meets the timing specifications detailed [here](/CUSTOM/DRAM_HOLD_TIME/readme.md) and [here](/CUSTOM/MMU_HOLD_TIME/readme.md)

### Project settings

- Ensure your project settings do not interfere with your hold time solution. (For example, when using Quartus II, make sure 'Ignore LCELL Buffers' is OFF.)
- Optimizing for speed is unnecessary for the Apple IIe, so you can optimize for area instead.
- Ensure the settings will initialize flip-flops and other memory elements to '0'. (For example, in Quartus II, 'Power-Up Don't Care' should not be checked.)
- You can improve signal integrity by setting a slow slew rate.

## Building a 3.3V adapter

When using a 3.3V adapter, voltage level translation is necessary. Refer to the [_Voltage Level Translation Guide_](https://www.ti.com/lit/ml/scyb018h/scyb018h.pdf) for more information.


### Output Pins

Fortunately, 3.3V can drive 5V TTL logic, so output-only pins can be connected directly without the need for level shifting.

### Input Pins

All input-only pins must be level-shifted to protect the 3.3V device from damage.

### Bidirectional pins

Bidirectional pins must also be level-shifted to protect the 3.3V device from damage.

#### Direction Signal

If you choose a solution that requires a direction signal, you'll need to add these direction signals as outputs. This will involve modifying the file /IOU/IOU.vhdl:

| Signal | Direction Signal | Notes |
| - | - | - |
| RESET_N | FORCE_RESET_N_LOW | When FORCE_RESET_N_LOW is LOW, RESET_N acts as an input; when HIGH, it functions as an output. |
| ORA6-0 | RA_ENABLE_N | When RA_ENABLE_N is HIGH, ORA6-0 are inputs; when LOW, they act as outputs. |

#### RESET_N

RESET_N is both a bidirectional and open-drain pin. Ensure that your level-shifting circuit preserves these properties, and make sure to place the pull-up resistor on the 5V side of RESET_N.