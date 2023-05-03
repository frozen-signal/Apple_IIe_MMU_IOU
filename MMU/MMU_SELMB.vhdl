library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_SELMB is
	port (
		A15, A14,
		A13, A10    : in std_logic;
		HIRES       : in std_logic;
		PHI_0_7XX   : in std_logic;
		EN80VID     : in std_logic;
		PG2         : in std_logic;
		FLG1        : in std_logic;
		FLG2        : in std_logic;
		R_W_N       : in std_logic;
		ALTSTKZP    : in std_logic;
		D_FXXX      : in std_logic;
		PHI_0_1XX_N : in std_logic;

		SELMB_N : out std_logic
	);
end MMU_SELMB;

architecture RTL of MMU_SELMB is
	signal L2_11, K4_10, K7_6, K7_8, S3_3, S3_8, L3_4 : std_logic;
begin
	-- MMU_2 @B-1:L3_13
	L2_11 <= (((A15 nor A14) and A13 and HIRES)  -- L2_6
		or (A10 and PHI_0_7XX))                  -- B2_6
		and EN80VID;

	K7_8  <= (FLG1 and R_W_N) nor ((not R_W_N) and FLG2);
	K4_10 <= not K7_8;
	K7_6  <= (K4_10 and (not L2_11)) nor (L2_11 and PG2);
	S3_3  <= (not D_FXXX) and PHI_0_1XX_N;
	S3_8  <= S3_3 and K7_6;
	L3_4  <= (ALTSTKZP nor S3_3);

	SELMB_N <= L3_4 nor S3_8;
end RTL;
