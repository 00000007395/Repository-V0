# Repository-V0

Nios II (programme C ou Monitor Program)
   │
   │  writedata(15..0)   ← donnée à stocker
   │  address(31..0)     ← adresse 0x00000000
   │  write / read       ← commande lecture/écriture
   │  chipselect         ← sélection du composant
   ▼
┌─────────────────────────────────────────┐
│         Avalon Interconnect             │
│   (bus généré automatiquement par Qsys) │
└──────────────┬──────────────────────────┘
               │
               │  writedata(15..0)
               │  write / read / chipselect
               │  byteenable(1..0)
               ▼
┌─────────────────────────────────────────┐
│        reg16_avalon_interface           │
│                                         │
│  CS=1 & WR=1                           │
│  byteenable(0)=1 → Q(7..0)  ← D(7..0) │
│  byteenable(1)=1 → Q(15..8) ← D(15..8)│
│                                         │
│  RD=1 → readdata(15..0) = Q(15..0)    │
│                                         │
└──────────────┬──────────────────────────┘
               │
               │  D(15..0)
               │  byteenable(1..0)
               │  clock / resetn
               ▼
┌─────────────────────────────────────────┐
│              reg16                      │
│                                         │
│  Q(7..0)  ← D(7..0)  si byteenable(0) │
│  Q(15..8) ← D(15..8) si byteenable(1) │
│  Q = 0    si resetn=0                  │
│                                         │
└──────────────┬──────────────────────────┘
               │
               │  Q(15..0)
               ▼
┌─────────────────────────────────────────┐
│         Conduit Q_export(15..0)         │
│   (sort du système Qsys vers FPGA)      │
└──────────────┬──────────────────────────┘
               │
               │  to_HEX(15..0)
               ▼
┌──────────────────────────────────────────────────────┐
│                    hex7seg × 4                        │
│                                                       │
│  h0 : to_HEX(3..0)   → HEX0(0..6)  ← chiffre unité  │
│  h1 : to_HEX(7..4)   → HEX1(0..6)  ← chiffre dizaine│
│  h2 : to_HEX(11..8)  → HEX2(0..6)  ← chiffre cent.  │
│  h3 : to_HEX(15..12) → HEX3(0..6)  ← chiffre mille. │
│                                                       │
└──────────────────────────────────────────────────────┘
               │
               ▼
     Afficheurs 7 segments physiques
     HEX0  HEX1  HEX2  HEX3
     sur la carte DE-series




Le tutoriel montre comment rendre un circuit matériel accessible depuis un processeur via le bus Avalon. Le point de départ est un simple registre 16 bits écrit en VHDL — reg16 — qui ne sait rien du bus et ne fait que stocker une valeur. Pour le rendre accessible au Nios II, on crée une enveloppe appelée reg16_avalon_interface qui traduit les signaux du bus Avalon — writedata, write, read, chipselect, byteenable — en commandes simples pour le registre interne.
     
Le signal byteenable joue un rôle clé : il permet au processeur 32 bits d'écrire les deux octets du registre 16 bits indépendamment, ce qui est nécessaire pour la compatibilité avec l'architecture mémoire du Nios II. L'interface gère aussi la lecture — quand read est actif, elle renvoie la valeur courante du registre sur readdata vers le bus.

La valeur stockée dans le registre doit également sortir physiquement du système Qsys pour être visible sur la carte. C'est le rôle du signal conduit Q_export — il transporte les 16 bits du registre en permanence vers l'extérieur du système, sans passer par le bus. Ce signal est ensuite découpé en 4 groupes de 4 bits, chacun passant dans une instance de hex7seg qui convertit la valeur hexadécimale en 7 signaux de segments pour piloter les afficheurs physiques HEX0 à HEX3 de la carte.



                     
