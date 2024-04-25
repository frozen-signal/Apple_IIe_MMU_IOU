This directory contains few implementations of DRAM_HOLD_TIME.

#### NOP
This implementation do not add the required delay.
To be used when the delays are added externally and with the testbenches.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### Specifications

The DRAM used in the Apple IIe require the MMU / IOU to hold the ORA signal values a certain delay past the Row and Column Address Strobe.
| Signal | Min | Typ | Max | Unit |
| - | - | - | - | - |
| /PRAS | 32 | 60 | 80 | ns |
| Q3 |  | 48 |  | ns |


