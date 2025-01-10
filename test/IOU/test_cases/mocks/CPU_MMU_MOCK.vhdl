library IEEE;
use IEEE.std_logic_1164.all;

entity CPU_MMU_MOCK is
    port (
        PRAS_N    : in std_logic;
        Q3        : in std_logic;
        PHI_0     : in std_logic;
        TEST_ORA0 : in std_logic;
        TEST_ORA1 : in std_logic;
        TEST_ORA2 : in std_logic;
        TEST_ORA3 : in std_logic;
        TEST_ORA4 : in std_logic;
        TEST_ORA5 : in std_logic;
        TEST_ORA6 : in std_logic;
        TEST_ORA7 : in std_logic;

        IOU_INPUT_ORA0 : out std_logic;
        IOU_INPUT_ORA1 : out std_logic;
        IOU_INPUT_ORA2 : out std_logic;
        IOU_INPUT_ORA3 : out std_logic;
        IOU_INPUT_ORA4 : out std_logic;
        IOU_INPUT_ORA5 : out std_logic;
        IOU_INPUT_ORA6 : out std_logic;
        IOU_INPUT_ORA7 : out std_logic
    );
end CPU_MMU_MOCK;

architecture MOCK of CPU_MMU_MOCK is
    component MMU_RA is
        port (
            DELAY_CLK : in std_logic;
            A      : in std_logic_vector(15 downto 0);
            PHI_0  : in std_logic;
            Q3     : in std_logic;
            PRAS_N  : in std_logic;
            DXXX_N : in std_logic;
            BANK1  : in std_logic;

            RA          : out std_logic_vector(7 downto 0);
            RA_ENABLE_N : out std_logic
        );
    end component;

    component COMMON_INTERNALS is
        port (
            R_W_N  : in std_logic;
            C01X_N : in std_logic;
            PRAS_N : in std_logic;
            Q3     : in std_logic;
            PHI_0  : in std_logic;

            RC01X_N   : out std_logic;
            P_PHI_0   : out std_logic;
            P_PHI_1   : out std_logic;
            Q3_PRAS_N : out std_logic
        );
    end component;
    signal RA_ENABLE_N, P_PHI_0, Q3_PRAS_N : std_logic;
begin
    U_COMMON_INTERNALS : COMMON_INTERNALS port map(
        R_W_N  => '0',
        C01X_N => '0',
        PRAS_N => PRAS_N,
        Q3     => Q3,
        PHI_0  => PHI_0,

        RC01X_N   => open,
        P_PHI_0   => P_PHI_0,
        P_PHI_1   => open,
        Q3_PRAS_N => Q3_PRAS_N
    );

    U_MMU_RA : MMU_RA port map(
        DELAY_CLK => '0',
        A           => "0000000000000000",
        PRAS_N      => PRAS_N,
        PHI_0       => PHI_0,
        Q3          => Q3,
        DXXX_N      => '0',
        BANK1       => '0',
        RA_ENABLE_N => RA_ENABLE_N
    );

    IOU_INPUT_ORA0 <= TEST_ORA0 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA1 <= TEST_ORA1 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA2 <= TEST_ORA2 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA3 <= TEST_ORA3 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA4 <= TEST_ORA4 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA5 <= TEST_ORA5 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA6 <= TEST_ORA6 when RA_ENABLE_N = '0' else 'Z';
    IOU_INPUT_ORA7 <= TEST_ORA7 when RA_ENABLE_N = '0' else 'Z';

end MOCK;
