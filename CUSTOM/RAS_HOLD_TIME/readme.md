This directory contains few implementations of RAS_HOLD_TIME.

####RAS_HOLD_TIME_TEST
This is only used with the testbenches. This implementation do not add the required delay.

####RAS_HOLD_TIME_ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

####Specifications
An implementation need to delay the PRAS_N signal by at least 25ns and return the delayed signal with RAS_N.

