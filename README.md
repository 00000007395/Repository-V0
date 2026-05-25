# Repository-V0


Nios II
   │
   │  writedata(15..0)
   │  address(0)
   │  chipselect + write
   ▼
┌─────────────────────────────┐
│   PWM_avalon_interface      │
│                             │
│  CS=1 & WR=1               │
│  addr=0 → reg_droit[13:0]  │──────┐
│  addr=1 → reg_gauche[13:0] │───┐  │
│                             │   │  │
└─────────────────────────────┘   │  │
                                   ▼  ▼
                            ┌──────────────┐
                            │ PWM_generation│
                            └──────┬───────┘
                                   │
                     dc_motor_p/n_R/L → Moteurs




Le système repose sur une architecture maître-esclave via le bus Avalon Memory-Mapped. Le processeur Nios II joue le rôle de maître : il envoie des données sur le bus en précisant une adresse mémoire, une donnée (writedata sur 16 bits), et des signaux de contrôle (chipselect et write).

Le composant PWM_avalon_interface est l'IP Core que nous avons créé. C'est lui qui fait le lien entre le bus Avalon et les moteurs. Il joue le rôle d'esclave Avalon : il reçoit les signaux du Nios II et les stocke dans deux registres internes de 14 bits chacun — reg_moteur_droit et reg_moteur_gauche. Lorsque chipselect = 1 et write = 1, il regarde le signal address pour savoir quel registre mettre à jour : address = 0 pour le moteur droit, address = 1 pour le moteur gauche. Ces registres mémorisent la commande jusqu'à la prochaine écriture. Le format des 14 bits est le suivant : le bit 13 est le bit GO, le bit 12 est le bit DIR, et les bits 11 à 0 représentent la vitesse.

Une fois les registres mis à jour, PWM_avalon_interface transmet en permanence leur contenu au composant PWM_generation. Ce dernier génère les signaux PWM à 16 kHz à partir de l'horloge FPGA de 50 MHz, avec un rapport cyclique proportionnel à la valeur de vitesse. Ces signaux sont ensuite envoyés sur les pins physiques du FPGA pour piloter les deux moteurs DC du robot CuteCar.
