
;Bloc 2 : Le calcul de la longueur de msg.
LDA enc,i
SUBA msg,i
STA msgSize, d

;Bloc 3: Le sous-programme verif.
; =========================================================================== 
; Sous - programe : verif 
; Doit vérifier si le message fourni en référence est bien composé de lettre majuscule seulement. 
; Entree : Adresse de msg ( dans la pile )  
; Sortie : Stopper le programme si mauvais message  
; ===========================================================================  
verif: RET0

;Bloc 4: Le sous-programme phiInvA.
; =========================================================================== 
; Sous - programme : phiInvA 
; Applique la fonction phi_Inv_A sur msg , et é cris dans vers msgPhi 
; Entree : Adresse du msg (SP +2) 
; Sortie : msgPhi est modifié 
; =========================================================================== 
phiInvA: RET0

;Bloc 5: Le sous-programme CESARENC. 
;=========================================================================== 
; Sous - programme : CESARENC 
; Effectue le chiffrement de Cesar ( msgPhi vers encPhi ) 
; Entree : Utilise msgPhi et CLE 
; Sortie : encPhi est updaté 
; =========================================================================== 
CESARENC: RET0

;Bloc 6: Le sous-programme STRO_CES. 
; =========================================================== 
; Sous - programme : STRO_CES 
; Affiche le message (en format Cesar de 0 à 25) et passe à la ligne 
; Entree : msg (SP +2) 
; Sortie : 
; =========================================================== 
STRO_CES: RET0

;Bloc 7: Le sous-programme CESARDEC.
; =========================================================== 
; Sous - programme : CESARDEC
; Effectue le chiffrement de Cesar ( encPhi vers decPhi )
; Entree : Utilise encPhi et CLE
; Sortie : decPhi est updaté
; =========================================================== 
CESARDEC: RET0

;Bloc 8: Le sous-programme FORCE.
; =========================================================== 
; Sous - programme : FORCE
; Effectue une attaque par force brute , essaie et affiche les 25 clés
; Entree : decPhi
; Sortie : Sortie dans le terminal
; =========================================================== 
FORCE: RET0

;Bloc 9: Le sous-programme distrib.
; =========================================================== 
; Sous - programme : distrib
; Affiche la distribution dans le terminal
; Entree : decPhi
; Sortie : Sortie dans le terminal
; =========================================================== 
distrib: RET0

;Bloc 10: Le sous-programme FREQUENC
; =========================================================== 
; Sous - programme : FREQUENC
; Attaque par analyse fré quenciel
; Entree : decPhi
; Sortie : Doit afficher les diff é rents dé codages , ainsi que la clé testée
; =========================================================== 
FREQUENC: RET0



; Les directives
msgLong: .ASCII "Le message est de longueur : \x00" 
welcome: .ASCII "Bienvenue dans le TP2\nLe message est : \x00"
msg: .ASCII "BienvenuedansledeuxiemeTPdececours\x00"
enc: .ASCII "BienvenuedansledeuxiemeTPdececours\x00"
msgSize: .WORD 0
msgPhi: .BLOCK 300
encPhi: .BLOCK 300
decPhi: .BLOCK 300

A: .WORD 'A'
a: .WORD 'a'
Z: .WORD 'Z'
z: .WORD 'z'
min2maj: .EQUATE 32

sizeA: .EQUATE 26
CLE: .EQUATE 10

msgFreq: .BLOCK 26
codeFreq: .BLOCK 26
