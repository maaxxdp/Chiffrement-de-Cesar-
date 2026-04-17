
;Bloc 2 : Le calcul de la longueur de msg.
main: LDA enc, i 
      SUBA msg, i
      SUBA 1, i ; Je pense qu'il a un charactere nul qui le rend a 35 et non 34.
      STA msgSize, d
; Loader le message dans l'accumulateur pour stoker l'adresse memoire
      LDA msg, i
; SUBSP donne l'espace memoire dans la pile
      SUBSP 2,i
      LDA msg, i
      STA 0,s ; Loader l'adresse dans la pile 
      CALL verif
      CALL phiInvA

      
      CALL CESARENC
     
      ; on veut  cree la variable globale encPhi pour l'utiliser dans les fonctions
      SUBSP 2,i ; incrementation de la pile de fonction globale
      LDA encPhi, i
      STA 0,s
      CALL STRO_CES
      ADDSP 2,i ; On decremente la pile de la fonction globale pour finir
      CALL CESARDEC
      CALL FORCE

      ; On cree une variable GLOBALE pour la fonction distrib
      SUBSP 4,i ; On fait des fonctions dans la pile donc on met cela
      CALL distrib
      ADDSP 4, i
      CALL FREQUENC
      STOP

;Bloc 3: Le sous-programme verif.
; =========================================================================== 
; Sous - programe : verif 
; Doit vérifier si le message fourni en référence est bien composé de lettre majuscule seulement. 
; Entree : Adresse de msg ( dans la pile )  
; Sortie : Stopper le programme si mauvais message  
; ===========================================================================  
verif:   LDX compteur, d
                             LDA 0,i 


       FOR1:    CPX msgSize, d   
                BRLT CORPS1
                RET0


       CORPS1:  LDBYTEA 2, sxf ; 
                CPA A, d
                BRLT msgINV
                CPA Z, d
                BRGT MAJ
                ADDX 1, i
                BR FOR1
              

        MAJ: CPA a, d ; on regarde si l'entre est dans l'intervale de a / z 
                 BRLT msgINV
                 CPA z, d
                 BRGT msgINV
                 SUBA min2maj, i ; on transforme si elle est dans l'intervalle de rentrer de la mettre en majuscule.
                 STBYTEA 2, sxf ; sfx = on ajoute dans la pile du tableau , une adresse 
                 ADDX 1,i
                 BR FOR1


msgINV: STRO msgInv, d
       BR FINAL


;Bloc 4: Le sous-programme phiInvA. 
; =========================================================================== 
; Sous - programme : phiInvA 
; Applique la fonction phi_Inv_A sur msg , et écris dans vers msgPhi 
; Entree : Adresse du msg (SP +2) 
; Sortie : msgPhi est modifié 
; =========================================================================== 
phiInvA: SUBSP 2,i
         LDX 0,i
         LDA 0,i
         STA 0,s
         BR BOUCLE

BOUCLE:  LDA 0,i
         LDBYTEA 4,sxf ; Tableau de msg
         CPX msgSize,d ; Condition de fin du parcours du tableau msg.
         BRGE fin
         
         SUBA A,d 
         STBYTEA msgPhi,x ; On enregistre dans le tableau msgPhi
         ADDX 1,i ; On  vas incrementer +1 dans x (index)

         BR BOUCLE

fin:    ADDSP 2,i
        RET0

;Bloc 5: Le sous-programme CESARENC. 
;=========================================================================== 
; Sous - programme : CESARENC 
; Effectue le chiffrement de Cesar ( msgPhi vers encPhi ) 
; Entree : Utilise msgPhi et CLE 
; Sortie : encPhi est updaté 
; =========================================================================== 
CESARENC: LDA 0,i
          LDX 0,i
          BR FOR2

; for(i=0; i<msgSize; i++)
FOR2:     CPX msgSize,d ; Condition de fin du parcours du tableau
          BRGE FIN1
          LDA 0,i
          LDBYTEA msgPhi,x ; Parcourir le tableau 
          ADDA CLE,i
          CPA sizeA,i
          BRLT OK
          SUBA sizeA,i ; On fait la soustraction afin d'avoir le chiffre en phi
          CPA 0,i ; Voir si condition est > 0 
          BRLT Zero
          BR OK

Zero:     ADDA sizeA,i; lorsque < 0 on veut le remonter a partir de Z
          BR OK   

OK:       STBYTEA encPhi,x
          ADDX 1,i ; Incrementation pour tableau
          BR FOR2

FIN1:      RET0

;Bloc 6: Le sous-programme STRO_CES. 
; =========================================================== 
; Sous - programme : STRO_CES 
; Affiche le message (en format Cesar de 0 �  25) et passe �  la ligne 
; Entree : msg (SP +2) 
; Sortie : 
; =========================================================== 
STRO_CES: LDA 0,i
          LDX 0,i 
          SUBSP 2,i

FOR4:     CPX msgSize,d ; condition de fin de tableau
          BRGE FIN2
          LDBYTEA 4,sxf ; on vas aller chercher encPhi en globale
          ADDA A,d ; On le transforme en ASCII
          STBYTEA 0,s
          CHARO 0,s
          ADDX 1,i ; on incremente +1 pour parcourir le tableau
          BR FOR4

FIN2:     LDA '\n',i
          RET2 ; On retourne de 2 octets dans la pile
;Bloc 7: Le sous-programme CESARDEC.
; =========================================================== 
; Sous - programme : CESARDEC
; Effectue le chiffrement de Cesar ( encPhi vers decPhi )
; Entree : Utilise encPhi et CLE
; Sortie : decPhi est updaté
; =========================================================== 
CESARDEC: LDA 0,i
          LDX 0,i
          BR FOR5

FOR5:    CPX msgSize,d ; Condition de fin du parcours du tableau
         BRGE FIN3
         LDA 0,i
         LDBYTEA encPhi,x  ; On vas mettre encPhi pour ajouter la CLE pour faire decPhi
         SUBA CLE, i
         CPA 0,i ; On le compare pour voir s'il tombe negatif
         BRLT Zero1
         BR OK1

Zero1:    ADDA sizeA,i; lorsque < 0 on veut le remonter a partir de Z
          BR OK1   

OK1:      STBYTEA decPhi,x
          ADDX 1,i ; Incrementation pour tableau
          BR FOR5


FIN3: RET0

;Bloc 8: Le sous-programme FORCE.
; =========================================================== 
; Sous - programme : FORCE
; Effectue une attaque par force brute , essaie et affiche les 25 clés
; Entree : encPhi
; Sortie : Sortie dans le terminal
; =========================================================== 
FORCE: LDA 0,i
       LDX 0,i
       SUBSP 4,i ; on as besoin de 2 iterateurs, donc on fait SUBSP 4, dans la pile
       LDA 1,i 
       STA 0,s
       BR B4_6

B4_6:  STRO msgClef,d
       DECO 0,s
       CHARO 10,i ; saut de ligne
       BR FOR6

FOR6: LDBYTEA encPhi,x 
      SUBA 0,s ; On incremente le tableau avec cle
      ADDA A,d ; On veut le transformer en ASCII
      CPA  A,d
      BRLT FixA
      BR CONTINUE

CONTINUE:        STBYTEA 2,s ; On enregistre la lettre qui a ete changer par la cle
                 CHARO 2,s ; On affiche la lettre
                 ADDX 1,i ;incrementation de x (pour parcourir le tableau de encPhi)
                 CPX msgSize,d ; Condition de fin du parcours du tableau (26)
                 BRGE CLEF
                 BR FOR6

FixA: ADDA sizeA,i ;Si trop petit , on ADDA sizeA pour fixer
      BR CONTINUE
    
      
     
CLEF: LDA 0,s ; On load la derniere clef utiliser
      CPA sizeA,i ; On regarde si toutes les clefs on ete passer.
      BRGE FIN4
      ADDA 1,i ; Incremente iterateur du tableau clef
      STA 0,s ; on enregistre la valeur
      LDX 0,i ; reset le compteur des lettres
      CHARO 10,i ; saut de ligne
      BR B4_6

FIN4: ADDSP 4,i ; on vas decrementer la pile pour retouner a CO qui est va retourner au main
      RET0

;Bloc 9: Le sous-programme distrib.
; =========================================================== 
; Sous - programme : distrib
; Affiche la distribution dans le terminal
; Entree : encPhi
; Sortie : Sortie dans le terminal
; =========================================================== 
distrib: LDA 0,i ;reset les compteurs
         LDX 0,i
         
         LDA A,d 
         STA 2,s ;Lettre temporaire a incrementer
         LDA 0,i
         STA 4,s ; # de fois lettre spawn
         BR FOR7

FOR7:    CPX msgSize,d ; Incrementations des lettres de encPhi
         BRGE FIN_L
         LDBYTEA encPhi,x
         ADDA A,d ; Transformer en ASCII
         CPA 2,s ; Comparer avec la lettre temp.
         BREQ Equal
         ADDX 1,i
         BR FOR7

Equal:   LDA 4,s ; Loader l'accumulateur avec le compteur le lettre
         ADDA 1,i ; Ajoute 1 a chaque fois que la lette apparait
         STA 4,s ; La sauvegade.
         ADDX 1,i
         BR FOR7

FIN_L:   LDA 2,s
         STBYTEA 2,s
         CHARO 10,i
         CHARO 2, s ; Afficher la lettre
         CHARO "-",i
         DECO 4,s ; Afficher le nombre de lettre
         LDA 0,i
         STA 4,s ; RAZ des compteurs de lettre
         LDBYTEA 2,s
         ADDA 1,i ; Passer a la lettre suivant
         STA 2,s
         LDX 0,i ; RAZ compteur message
         CPA Z,d
         BRLE FOR7
         BR FIN5

FIN5:    RET0
;Bloc 10: Le sous-programme FREQUENC
; =========================================================== 
; Sous - programme : FREQUENC
; Attaque par analyse fré quenciel
; Entree : decPhi
; Sortie : Doit afficher les diff é rents dé codages , ainsi que la clé testée
; =========================================================== 
FREQUENC: SUBSP 6,i
          CHARO '\n',i
          STRO msgFREQ,d
          DECI 0,s
          CHARO '\n',i
          LDX 0,i


FORFREQ: CPX msgSize,d
         BRGE CORPSFRE 
         LDA 0,i
         LDBYTEA encPhi,x
         SUBA 0,s
         CPA 0,i
         BRLT modFREQ
         STBYTEA msgFreq,x
         ADDX 1,i
         BR FORFREQ


modFREQ: ADDA sizeA,i
         STBYTEA msgFreq,x
         ADDX 1,i
         BR FORFREQ


CORPSFRE: STRO msgdeCod,d
          DECO 0,s
          CHARO ':',i
          LDX 0,i
WHILEFRE: CPX msgSize,d
          BRGE SAFETY
          LDA 0,i
          LDBYTEA msgFreq,x
          ADDA A,d
          STBYTEA 2,s
          CHARO 2,s
          ADDX 1,i
          BR WHILEFRE


SAFETY:CHARO '\n',i
       STRO msgCONT,d
       CHARI 4,s
       CHARI 6,s
       LDA 0,i
       LDBYTEA 4,s
       CPA 'O',i
       BREQ FREQUENC
       CPA 'N',i
       BREQ ENDFREQ
       STRO msgERR,d
       BR SAFETY
ENDFREQ: ADDSP 6,i
         RET0    

FINAL: stop

; Les directives
msgLong: .ASCII "Le message est de longueur : \x00" 
welcome: .ASCII "Bienvenue dans le TP2\nLe message est : \x00"
msg: .ASCII "BienvenuedansledeuxiemeTPdececours\x00"
enc: .ASCII "BienvenuedansledeuxiemeTPdececours\x00"
msgSize: .WORD 0
msgPhi: .BLOCK 300
encPhi: .BLOCK 300
decPhi: .BLOCK 300
compteur: .WORD 0
msgInv: .ASCII "Le message entr� est invalide\x00" 
msgClef: .ASCII"Voici la cl� tester \x00"

A: .WORD 'A'
a: .WORD 'a'
Z: .WORD 'Z'
z: .WORD 'z'
min2maj: .EQUATE 32

sizeA: .EQUATE 26
CLE: .EQUATE 10

msgFreq: .BLOCK 26
codeFreq: .BLOCK 26


msgFREQ: .ASCII "Choisiez la cle entre 1 et 25 : \x00"
msgdeCod: .ASCII "Ce message fut decode avec cette cle\x00"
msgCONT: .ASCII "Voulez-vous continuer ? (O/N) : \x00"
msgERR: .ASCII "Choisisez le bon caractere O ou N \x00"



.END
