LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY PWM_avalon_interface IS
PORT (
    clk          : IN  STD_LOGIC;
    reset_n      : IN  STD_LOGIC;
    address      : IN  STD_LOGIC;
    writedata    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    write        : IN  STD_LOGIC;
    read         : IN  STD_LOGIC;                      -- AJOUTÉ
    readdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- AJOUTÉ
    chipselect   : IN  STD_LOGIC;
    dc_motor_p_R : OUT STD_LOGIC;
    dc_motor_n_R : OUT STD_LOGIC;
    dc_motor_p_L : OUT STD_LOGIC;
    dc_motor_n_L : OUT STD_LOGIC
);
END PWM_avalon_interface;

ARCHITECTURE Structure OF PWM_avalon_interface IS

    COMPONENT PWM_generation IS
    PORT (
        clk          : IN  STD_LOGIC;
        reset_n      : IN  STD_LOGIC;
        s_writedataR : IN  STD_LOGIC_VECTOR(13 DOWNTO 0);
        s_writedataL : IN  STD_LOGIC_VECTOR(13 DOWNTO 0);
        dc_motor_p_R : OUT STD_LOGIC;
        dc_motor_n_R : OUT STD_LOGIC;
        dc_motor_p_L : OUT STD_LOGIC;
        dc_motor_n_L : OUT STD_LOGIC
    );
    END COMPONENT PWM_generation;

    SIGNAL reg_moteur_droit  : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_moteur_gauche : STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');

BEGIN

    -- Process ÉCRITURE
    PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            reg_moteur_droit  <= (OTHERS => '0');
            reg_moteur_gauche <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF chipselect = '1' AND write = '1' THEN
                reg_moteur_droit  <= writedata(13 DOWNTO 0);
                reg_moteur_gauche <= writedata(29 DOWNTO 16);
            END IF;
        END IF;
    END PROCESS;

    -- Process LECTURE
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF chipselect = '1' AND read = '1' THEN
                readdata(13 DOWNTO 0)  <= reg_moteur_droit;   -- moteur droit
                readdata(15 DOWNTO 14) <= (OTHERS => '0');    -- bits inutilisés
                readdata(29 DOWNTO 16) <= reg_moteur_gauche;  -- moteur gauche
                readdata(31 DOWNTO 30) <= (OTHERS => '0');    -- bits inutilisés
            ELSE
                readdata <= (OTHERS => '0');  -- par défaut à 0
            END IF;
        END IF;
    END PROCESS;

    -- Instanciation PWM_generation
    PWM_inst : PWM_generation
    PORT MAP (
        clk          => clk,
        reset_n      => reset_n,
        s_writedataR => reg_moteur_droit,
        s_writedataL => reg_moteur_gauche,
        dc_motor_p_R => dc_motor_p_R,
        dc_motor_n_R => dc_motor_n_R,
        dc_motor_p_L => dc_motor_p_L,
        dc_motor_n_L => dc_motor_n_L
    );

END Structure;