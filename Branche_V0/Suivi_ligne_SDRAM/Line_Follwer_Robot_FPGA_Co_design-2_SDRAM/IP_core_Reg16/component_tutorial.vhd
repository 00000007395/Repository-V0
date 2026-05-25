// ─────────────────────────────────────────────
//  component_tutorial.v  —  Module top-level
//  Carte : Altera DE0 (Cyclone III EP3C16F484)
//  Tutoriel : Making Qsys Components
// ─────────────────────────────────────────────
//
//  Ce module :
//    1. Instancie le système embarqué Qsys
//    2. Connecte CLOCK_50 à l'horloge du système
//    3. Connecte KEY[0] au reset (actif bas)
//    4. Connecte Q_export (16 bits) aux 4
//       afficheurs 7 segments via hex7seg
// ─────────────────────────────────────────────

module component_tutorial (CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3);

    input         CLOCK_50;
    input  [0:0]  KEY;
    output [0:6]  HEX0, HEX1, HEX2, HEX3;

    wire [15:0] to_HEX;

    // Instanciation du système Qsys généré
    embedded_system U0 (
        .clk_clk          (CLOCK_50),
        .resetn_reset_n   (KEY[0]),
        .to_hex_export    (to_HEX)
    );

    // Conversion hex → 7 segments pour chaque nibble
    hex7seg h0 (to_HEX[3:0],   HEX0);   // bits  3..0
    hex7seg h1 (to_HEX[7:4],   HEX1);   // bits  7..4
    hex7seg h2 (to_HEX[11:8],  HEX2);   // bits 11..8
    hex7seg h3 (to_HEX[15:12], HEX3);   // bits 15..12

endmodule
