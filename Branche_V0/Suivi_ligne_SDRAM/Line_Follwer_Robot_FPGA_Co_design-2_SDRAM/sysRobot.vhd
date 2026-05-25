LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sysRobot IS
PORT (
    SW        : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    KEY       : IN    STD_LOGIC_VECTOR(0 DOWNTO 0);
    CLOCK_50  : IN    STD_LOGIC;
    LED       : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    HEX0      : OUT   STD_LOGIC_VECTOR(0 TO 6);
    HEX1      : OUT   STD_LOGIC_VECTOR(0 TO 6);
    HEX2      : OUT   STD_LOGIC_VECTOR(0 TO 6);
    HEX3      : OUT   STD_LOGIC_VECTOR(0 TO 6);
    DRAM_CLK  : OUT   STD_LOGIC;
    DRAM_CKE  : OUT   STD_LOGIC;
    DRAM_ADDR : OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
    DRAM_BA   : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    DRAM_CS_N : OUT   STD_LOGIC;
    DRAM_CAS_N: OUT   STD_LOGIC;
    DRAM_RAS_N: OUT   STD_LOGIC;
    DRAM_WE_N : OUT   STD_LOGIC;
    DRAM_DQ   : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DRAM_DQM  : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END sysRobot;

ARCHITECTURE Structure OF sysRobot IS

    COMPONENT embedded_system IS
    PORT (
        clk_clk          : IN    STD_LOGIC;
        reset_reset_n    : IN    STD_LOGIC;
        switches_export  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
        leds_export      : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        sdram_wire_addr  : OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
        sdram_wire_ba    : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        sdram_wire_cas_n : OUT   STD_LOGIC;
        sdram_wire_cke   : OUT   STD_LOGIC;
        sdram_wire_cs_n  : OUT   STD_LOGIC;
        sdram_wire_dq    : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        sdram_wire_dqm   : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        sdram_wire_ras_n : OUT   STD_LOGIC;
        sdram_wire_we_n  : OUT   STD_LOGIC;
        to_hex_export    : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT embedded_system;

    COMPONENT hex7seg IS
    PORT (
        hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        display : OUT STD_LOGIC_VECTOR(0 TO 6)
    );
    END COMPONENT hex7seg;

    SIGNAL to_HEX : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    NiosII: embedded_system
    PORT MAP (
        clk_clk          => CLOCK_50,
        reset_reset_n    => KEY(0),
        switches_export  => SW,
        leds_export      => LED,
        sdram_wire_addr  => DRAM_ADDR,
        sdram_wire_ba    => DRAM_BA,
        sdram_wire_cas_n => DRAM_CAS_N,
        sdram_wire_cke   => DRAM_CKE,
        sdram_wire_cs_n  => DRAM_CS_N,
        sdram_wire_dq    => DRAM_DQ,
        sdram_wire_dqm   => DRAM_DQM,
        sdram_wire_ras_n => DRAM_RAS_N,
        sdram_wire_we_n  => DRAM_WE_N,
        to_hex_export    => to_HEX
    );

    DRAM_CLK <= CLOCK_50;

    h0: hex7seg PORT MAP (to_HEX(3  DOWNTO 0),  HEX0);
    h1: hex7seg PORT MAP (to_HEX(7  DOWNTO 4),  HEX1);
    h2: hex7seg PORT MAP (to_HEX(11 DOWNTO 8),  HEX2);
    h3: hex7seg PORT MAP (to_HEX(15 DOWNTO 12), HEX3);

END Structure;