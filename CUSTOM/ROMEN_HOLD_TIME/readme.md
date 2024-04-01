This directory contains few implementations of ROMEN_HOLD_TIME.

#### SIM
This is only used with the testbenches. This implementation do not add the required delay.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### Specifications
With the official MMU, ROMEN1_N and ROMEN2_N rises ~50-60 ns after the falling edge of PHI_0. Experimentally, this delay doesn't seem to be necessary, but it is added nonetheless if only for the sake of being closer to the ASIC MMU's timings.

