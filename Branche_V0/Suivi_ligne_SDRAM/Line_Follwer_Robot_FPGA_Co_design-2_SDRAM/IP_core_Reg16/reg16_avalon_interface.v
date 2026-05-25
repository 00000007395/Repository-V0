// ─────────────────────────────────────────────
//  reg16_avalon_interface.v
//  Enveloppe Avalon Memory-Mapped pour reg16
//  Tutoriel : Making Qsys Components (Altera)
// ─────────────────────────────────────────────
//
//  Ports Avalon MM (slave) :
//    clock           – horloge système
//    resetn          – reset actif bas
//    writedata[15:0] – donnée envoyée par le maître
//    readdata[15:0]  – donnée renvoyée au maître
//    write           – 1 quand le maître écrit
//    read            – 1 quand le maître lit
//    chipselect      – 1 quand ce composant est sélectionné
//    byteenable[1:0] – octets concernés par l'écriture
//
//  Port conduit (export) :
//    Q_export[15:0]  – valeur du registre vers l'extérieur
//                      (branché aux afficheurs 7 segments)
// ─────────────────────────────────────────────

module reg16_avalon_interface (
    clock,
    resetn,
    writedata,
    readdata,
    write,
    read,
    byteenable,
    chipselect,
    Q_export
);

    // ── Signaux Avalon MM ──
    input         clock;
    input         resetn;
    input         read;
    input         write;
    input         chipselect;
    input  [1:0]  byteenable;
    input  [15:0] writedata;
    output [15:0] readdata;

    // ── Signal conduit ──
    output [15:0] Q_export;

    // ── Fils internes ──
    wire [1:0]  local_byteenable;
    wire [15:0] to_reg;
    wire [15:0] from_reg;

    // La donnée à écrire est simplement writedata
    assign to_reg = writedata;

    // On n'autorise l'écriture que si chipselect ET write
    // sont actifs simultanément
    assign local_byteenable = (chipselect & write) ? byteenable : 2'd0;

    // Instanciation du registre interne
    reg16 U1 (
        .clock      (clock),
        .resetn     (resetn),
        .D          (to_reg),
        .byteenable (local_byteenable),
        .Q          (from_reg)
    );

    // La sortie de lecture et le conduit
    // pointent tous les deux vers la sortie Q du registre
    assign readdata  = from_reg;
    assign Q_export  = from_reg;

endmodule
