library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_ADDR_DECODER_SPY is
    port (
        C0XX_N : in std_logic;
        LA7    : in std_logic;
        LA4    : in std_logic;
        LA5    : in std_logic;
        A6     : in std_logic;
        Q3     : in std_logic;

        C00X_N : out std_logic;
        C01X_N : out std_logic;
        C02X_N : out std_logic;
        C03X_N : out std_logic;
        C04X_N : out std_logic;
        C05X_N : out std_logic;
        C07X_N : out std_logic
    );
end IOU_ADDR_DECODER_SPY;

architecture SPY of IOU_ADDR_DECODER_SPY is
    component IOU_ADDR_DECODER is
        port (
            C0XX_N : in std_logic;
            LA7    : in std_logic;
            LA4    : in std_logic;
            LA5    : in std_logic;
            A6     : in std_logic;
            Q3     : in std_logic;

            C00X_N : out std_logic;
            C01X_N : out std_logic;
            C02X_N : out std_logic;
            C03X_N : out std_logic;
            C04X_N : out std_logic;
            C05X_N : out std_logic;
            C07X_N : out std_logic
        );
    end component;

    signal C00X_N_INT, C01X_N_INT, C02X_N_INT, C03X_N_INT, C04X_N_INT, C05X_N_INT, C07X_N_INT : std_logic;

begin
    U_IOU_ADDR_DECODER : IOU_ADDR_DECODER port map(
        C0XX_N => C0XX_N,
        LA7    => LA7,
        LA4    => LA4,
        LA5    => LA5,
        A6     => A6,
        Q3     => Q3,
        C00X_N => C00X_N_INT,
        C01X_N => C01X_N_INT,
        C02X_N => C02X_N_INT,
        C03X_N => C03X_N_INT,
        C04X_N => C04X_N_INT,
        C05X_N => C05X_N_INT,
        C07X_N => C07X_N_INT
    );

    TB_C00X_N <= C00X_N_INT;
    TB_C01X_N <= C01X_N_INT;
    TB_C02X_N <= C02X_N_INT;
    TB_C03X_N <= C03X_N_INT;
    TB_C04X_N <= C04X_N_INT;
    TB_C05X_N <= C05X_N_INT;
    TB_C07X_N <= C07X_N_INT;

    C00X_N <= C00X_N_INT;
    C01X_N <= C01X_N_INT;
    C02X_N <= C02X_N_INT;
    C03X_N <= C03X_N_INT;
    C04X_N <= C04X_N_INT;
    C05X_N <= C05X_N_INT;
    C07X_N <= C07X_N_INT;

end SPY;
