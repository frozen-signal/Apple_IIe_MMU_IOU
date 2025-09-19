# DISCLAIMER
This repository is provided "as is". If you choose to fabricate and/or assemble this project yourself, you do so entirely at your own risk. The authors/maintainers provide no warranties (express or implied) and accept no responsibility for any damage, injury, or loss resulting from use or misuse. This design is not certified for safety, EMC, or regulatory compliance; you are solely responsible for verifying suitability, component orientation/polarity, firmware configuration, or any other aspect. By using any files in this repo, you agree to assume all risks.

# Reference designs
Hardware reference designs can be found here:
## 3.3V Adapter reference designs
- [3.3V IOU adapter](https://github.com/frozen-signal/Apple_IIe_IOU_3V3)
- [3.3V MMU adapter](https://github.com/frozen-signal/Apple_IIe_MMU_3V3)
## 5V Adapter reference designs
- 5V IOU adapter (To be done)
- 5V MMU adapter (To be done)

# Designing an adapter from scratch

## Notes

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
| SPKR | 8 | OUT, possibly open-drain |
| MD7 | 9 | OUT, Tri-state |
| AN0 | 10 | OUT |
| AN1 | 11 | OUT |
| AN2 | 12 | OUT |
| AN3 | 13 | OUT |
| R_W_N | 14 | IN |
| RESET_N | 15 | BIDIR, open-drain |
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

### FPGA / CPLD Selection

The Apple IIe is a 5V computer, so using a 5V FPGA or CPLD would be easiest. On the other hand, 3.3V devices are easier to source.
> [!NOTE]
> In the case of 3.3V devices, you'll need additional circuits for voltage level translation; feeding 5V signals to a 3.3V, non 5V-resistant device will damage it.
> More on this below.

### FPGA/CPLD configuration time

The configuration time of the device must be considered. In the case of the MMU, the device **must** configure itself and become operational within 35 ms. In the case of the IOU, since it has control over the /RESET signal, the configuration time is less critical.

### Number of GPIOs

The device needs to have a minimum number of GPIOs depending on the ASIC:
| ASIC | Number of GPIOs |
| - | -: |
| IOU | 37 |
| MMU | 38  |

### Voltage level translation

In the case of 3.3V FPGAs, you will need to translate some 5V signals down to 3.3V.
> [!NOTE]
> See the [_Voltage Level Translation Guide_](https://www.ti.com/lit/ml/scyb018h/scyb018h.pdf) for more information.

#### MMU signals requiring voltage level translation

| Signals | Notes |
| --- | --- |
| A0-A15 |  |
| MD7 | Tri-State<sup>1</sup> |
| ORA0-7 | Tri-State<sup>1</sup> |
| /PRAS |  |
| Q3 |  |
| PHI_0 |  |
| /DMA |  |
| /INH |  |
| R/W* |  |

<sup>1</sup> You may need to add OutputEnable* signals for tri-state signals. Remember to check if your FPGA has enough GPIOs for these additional signals. See the [top entity of the reference MMU implementation](https://github.com/frozen-signal/Apple_IIe_MMU_3V3/blob/master/firmware/CUSTOM/MMU.vhdl) for an example.

See the [schematics](https://github.com/frozen-signal/Apple_IIe_MMU_3V3/blob/master/Schematics.pdf) of the MMU reference 3.3V implementation for an example and more details.


#### IOU signals requiring voltage level translation

| Signals | Notes |
| --- | --- |
| MD7 | Tri-State<sup>1</sup> |
| VID6-7 |  |
| KSTRB |  |
| AKD |  |
| C0XX |  |
| A6 |  |
| /PRAS |  |
| Q3 |  |
| PHI_0 |  |
| ORA0-7 | Bidirectional<sup>1</sup> |
| SPKR | Pulled-up<sup>2</sup> |
| R/W* |  |

<sup>1</sup> You may need to add OutputEnable* and/or Direction signals for tri-state and bidirectional signals. Remember to check if your FPGA has enough GPIOs for these additional signals. See the [top entity of the reference IOU implementation](https://github.com/frozen-signal/Apple_IIe_IOU_3V3/blob/master/firmware/CUSTOM/IOU.vhdl) for an example.

<sup>2</sup> This pin is possibly open-drain on an official IOU; the signal is pulled-up to 5V on the motherboard. Therefore the corresponding 3.3V pin on the FPGA needs to be protected.

See the [schematics](https://github.com/frozen-signal/Apple_IIe_IOU_3V3/blob/master/Schematics.pdf) of the IOU reference 3.3V implementation for an example and more details.

### Hold Time Delay

> [!IMPORTANT]
> Do not skip this section; otherwise your adapter won't work.

Some signals in the IOU and MMU require hold times. Your design needs to have the means to add the required delays. This can be achieved through various methods, for example:

- Using specific IP on the device (such as ALTERA's LCELL)
- Using an oscillator
- Chaining out-in pins
- Using an RC circuit
- Using logic gates

If you decide to use an ALTERA MAX7000S EPM7128STC100-10N or a MACHXO2, this project should work as-is. In any other case however, you'll need to implement or modify some source files (more details in Step 2).

### The /RESET signal on the IOU

The /RESET signal on the IOU is a bidirectional open-drain interrupt line. It needs to be pulled-up by the IOU. Caution must be taken so that this signal do not inadvertently goes HIGH during power-on; if your FPGA tri-states the /RESET GPIO during configuration, the /RESET signal will be pulled HIGH. Make sure you prevent this by using for example a circuit such as the one used in the reference [3.3V implementation](https://github.com/frozen-signal/Apple_IIe_IOU_3V3/blob/master/Schematics.pdf) (See "POWER-ON CIRCUIT" at the bottom left).

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
1. **Exactly an ALTERA MAX7000S EPM7128STC100:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl`
1. **An ALTERA device that supports LCELL:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl` and adjust NUM_LCELLS_RAS and NUM_LCELLS_Q3<br/>**See note**
1. **A MACHXO2**:<br/>Add the following files: `CUSTOM/DELAY_OSCILLATOR/VENDOR/LATTICE/MACHXO2/DELAY_OSCILLATOR.vhdl`, `CUSTOM/DRAM_HOLD_TIME/DELAY_CLK/DRAM_HOLD_TIME.vhdl`
1. **An internal oscillator:**<br/>Implement your oscillator using `CUSTOM/DELAY_OSCILLATOR/NOP/DELAY_OSCILLATOR.vhdl` as a starting point, then add `CUSTOM/DRAM_HOLD_TIME/DELAY_CLK/DRAM_HOLD_TIME.vhdl`
1. **An external delay circuit (e.g., an RC circuit):**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/NOP/DRAM_HOLD_TIME.vhdl`<br/> **See note**
1. **Any other method (e.g., using an internal oscillator)**<br/>Implement a DRAM_HOLD_TIME entity that will add the necessary hold times.<br/>**See note**

> [!NOTE]
> Ensure your solution meets the timing specifications detailed [here](/CUSTOM/DRAM_HOLD_TIME/readme.md)

#### NTSC vs PAL Version

By default, this project will produce an NTSC version of the IOU. If you need the PAL version, change the value of `NTSC_CONSTANT` to '0' in the file `/IOU/IOU.vhdl`

### Project for the MMU

#### Required Files

- All files in the COMMON directory
- All files in the MMU directory
- The file LATCH_9334 in the TTL directory

#### Required CUSTOM files

Depending on the device you're using, you'll need to customize the hold time in two entities. Here are the options:

1. **Exactly an ALTERA MAX7000S EPM7128STC100:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl` and `CUSTOM/MMU_HOLD_TIME/VENDOR/ALTERA/MMU_HOLD_TIME.vhdl`
1. **An ALTERA device that supports LCELL:**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/VENDOR/ALTERA/DRAM_HOLD_TIME.vhdl` and adjust NUM_LCELLS_RAS and NUM_LCELLS_Q3. Then add `CUSTOM/MMU_HOLD_TIME/VENDOR/ALTERA/MMU_HOLD_TIME.vhdl` and adjust NUM_LCELLS<br/>**See note**
1. **A MACHXO2**:<br/>Add the following files: `CUSTOM/DELAY_OSCILLATOR/VENDOR/LATTICE/MACHXO2/DELAY_OSCILLATOR.vhdl`, `CUSTOM/DRAM_HOLD_TIME/DELAY_CLK/DRAM_HOLD_TIME.vhdl`, and `CUSTOM/MMU_HOLD_TIME/DELAY_CLK/MMU_HOLD_TIME.vhdl`
1. **An internal oscillator:**<br/>Implement your oscillator using `CUSTOM/DELAY_OSCILLATOR/NOP/DELAY_OSCILLATOR.vhdl` as a starting point, then add `CUSTOM/DRAM_HOLD_TIME/DELAY_CLK/DRAM_HOLD_TIME.vhdl` and `CUSTOM/MMU_HOLD_TIME/DELAY_CLK/MMU_HOLD_TIME.vhdl`
1. **An external delay circuit (e.g., an RC circuit):**<br/>Add the file `CUSTOM/DRAM_HOLD_TIME/NOP/DRAM_HOLD_TIME.vhdl` and `CUSTOM/MMU_HOLD_TIME/NOP/MMU_HOLD_TIME.vhdl`<br/> **See note**
1. **Any other method (e.g., using an internal oscillator)**<br/>Implement a DRAM_HOLD_TIME and MMU_HOLD_TIME entities that will add the necessary hold times.<br/>**See note**

**NOTE:** Ensure your solution meets the timing specifications detailed [here](/CUSTOM/DRAM_HOLD_TIME/readme.md) and [here](/CUSTOM/MMU_HOLD_TIME/readme.md)

### Project settings

- Ensure your project settings do not interfere with your hold time solution. (For example, when using Quartus II, make sure 'Ignore LCELL Buffers' is OFF.)
- Optimizing for speed is unnecessary for the Apple IIe, so you can optimize for area instead.
- Ensure the settings will initialize flip-flops and other memory elements to '0'. (For example, in Quartus II, 'Power-Up Don't Care' should not be checked.)
- You can improve signal integrity by setting a slow slew rate.
