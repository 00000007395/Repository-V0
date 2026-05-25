library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity robot_cutecar_de0nano is
port(
    clock_50     : in    std_logic;
    key          : in    std_logic_vector(1 downto 0);
    sw           : in    std_logic_vector(3 downto 0);
    led          : out   std_logic_vector(7 downto 0);
    dram_clk     : out   std_logic;
    dram_cke     : out   std_logic;
    dram_addr    : out   std_logic_vector(12 downto 0);
    dram_ba      : out   std_logic_vector(1 downto 0);
    dram_cs_n    : out   std_logic;
    dram_cas_n   : out   std_logic;
    dram_ras_n   : out   std_logic;
    dram_we_n    : out   std_logic;
    dram_dq      : inout std_logic_vector(15 downto 0);
    dram_dqm     : out   std_logic_vector(1 downto 0);
    -- Sorties PWM vers les moteurs DC
    -- RENOMMÉS pour correspondre au .qsf !
    MTRR_P       : out   std_logic;   -- dc_motor_p_r
    MTRR_N       : out   std_logic;   -- dc_motor_n_r
    MTRL_P       : out   std_logic;   -- dc_motor_p_l
    MTRL_N       : out   std_logic    -- dc_motor_n_l
);
end robot_cutecar_de0nano;

architecture robot_rtl of robot_cutecar_de0nano is
    component niosII_v1 is
    port (
        clk_clk             : in    std_logic                     := 'X';
        switches_export     : in    std_logic_vector(3 downto 0)  := (others => 'X');
        leds_export         : out   std_logic_vector(7 downto 0);
        reset_reset_n       : in    std_logic                     := 'X';
        sdram_clock_clk     : out   std_logic;
        sdram_wire_addr     : out   std_logic_vector(12 downto 0);
        sdram_wire_ba       : out   std_logic_vector(1 downto 0);
        sdram_wire_cas_n    : out   std_logic;
        sdram_wire_cke      : out   std_logic;
        sdram_wire_cs_n     : out   std_logic;
        sdram_wire_dq       : inout std_logic_vector(15 downto 0) := (others => 'X');
        sdram_wire_dqm      : out   std_logic_vector(1 downto 0);
        sdram_wire_ras_n    : out   std_logic;
        sdram_wire_we_n     : out   std_logic;
        dc_motor_p_r_export : out   std_logic;
        dc_motor_n_r_export : out   std_logic;
        dc_motor_p_l_export : out   std_logic;
        dc_motor_n_l_export : out   std_logic
    );
    end component niosII_v1;

begin
    niosII : component niosII_v1
    port map (
        clk_clk             => clock_50,
        switches_export     => sw,
        leds_export         => led,
        reset_reset_n       => key(0),
        sdram_clock_clk     => dram_clk,
        sdram_wire_addr     => dram_addr,
        sdram_wire_ba       => dram_ba,
        sdram_wire_cas_n    => dram_cas_n,
        sdram_wire_cke      => dram_cke,
        sdram_wire_cs_n     => dram_cs_n,
        sdram_wire_dq       => dram_dq,
        sdram_wire_dqm      => dram_dqm,
        sdram_wire_ras_n    => dram_ras_n,
        sdram_wire_we_n     => dram_we_n,
        dc_motor_p_r_export => MTRR_P,   -- renommé
        dc_motor_n_r_export => MTRR_N,   -- renommé
        dc_motor_p_l_export => MTRL_P,   -- renommé
        dc_motor_n_l_export => MTRL_N    -- renommé
    );
end robot_rtl;