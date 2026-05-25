// ─────────────────────────────────────────────
//  reg16.v  —  Registre 16 bits synchrone
//  Tutoriel : Making Qsys Components (Altera)
// ─────────────────────────────────────────────
//
//  Ports :
//    clock       – horloge système (front montant)
//    resetn      – reset actif bas (0 = reset)
//    D[15:0]     – donnée à écrire
//    byteenable[1:0] – contrôle octet par octet
//                      bit0=1 → écrire D[7:0]
//                      bit1=1 → écrire D[15:8]
//    Q[15:0]     – sortie du registre
// ─────────────────────────────────────────────

module reg16 (clock, resetn, D, byteenable, Q);

    input  clock;
    input  resetn;
    input  [1:0]  byteenable;
    input  [15:0] D;
    output reg [15:0] Q;

    always @(posedge clock)
    begin
        if (!resetn)
            // Reset actif bas : on remet tout à zéro
            Q <= 16'b0;
        else
        begin
            // Écriture indépendante de chaque octet
            if (byteenable[0]) Q[7:0]  <= D[7:0];
            if (byteenable[1]) Q[15:8] <= D[15:8];
        end
    end

endmodule
