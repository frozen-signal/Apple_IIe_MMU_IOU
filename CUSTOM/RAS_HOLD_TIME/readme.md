This directory contains few implementations of RAS_HOLD_TIME.

#### SIM
This is only used with the testbenches. This implementation do not add the required delay.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### VENDOR/LATTICE/iCE40
This can be used with Lattice FPGAs that support the SB_HFOSC primitive.

#### VENDOR/LATTICE/MachXO3D
This can be used with Lattice FPGAs that support the OSCJ primitive.

#### Specifications
An implementation need to delay the PRAS_N signal by at least 60ns (~80ns seems to be the max) and return the delayed signal with RAS_N.

