This directory contains few implementations of MMU_HOLD_TIME, a component that adds the delays specific to the MMU.

#### NOP
This implementation do not add the required delay.
To be used when the delays are added externally and with the testbenches.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### Specifications
The signals /EN80 is required to hold it's value a certain delay past the PHI_0 change. The signals /ROMEN1 and /ROMEN2 also show a hold delay, but don't seem to be necessary. It is added nonetheless for the sake of being closer to the ASIC MMU's timings.
To add the delay, we add a delay to PHI_0 and use this delayed signal in the computation of /EN80, /ROMEN1, and /ROMEN2.

| Signal | Min | Typ | Max | Unit |
| - | - | - | - | - |
| PHI_0 |  | 45 |  | ns |

