;				PROYECTO RETROMAÑÍA 2016 (ERA OTRO P$#O PUZZLE Y SE TRANSFORMÓ EN ALGO)
;				MIGUEL A. GARCÍA PRADA - COMPILER SOFTWARE 2016
;				COMENZADO:	02/11/2016
;				FINALIZADO: 10/11/2016

				ORG 25000

start

ACORRER:	;ARRANCA EL JUEGO Y ES EL MENÚ DEL MISMO
			; Habilitamos las interrupciones para el contador de tiempo
			ld hl, TIMER
	        ld (65279),hl
	        ld a,254
	        ld i,a
	        im 2

MENU:		LD SP, 24999
			
			; NO NOS OLVIDEMOS DE INICIALIZAR VARIABLES EN CADA CICLO DE JUEGO.
			ld a, r 			; Semilla para RAND
			ld (SEED), a
			ld a, 7
			ld (Ccol),a
			ld a, 21
			ld (Caltura), a
			ld hl, 23239
			ld (CcolATTR), hl
			xor a
			ld (Cnumfichas), a
			ld (Ccolor), a
			ld hl, 0
			ld (Puntos), hl
			ld a, 6
			ld (DescLin), a
			ld a, 10
			ld (Cvelocidad), a

			ld a,1
			out (254),a
			ld hl, 16384
			ld de, 16385
			ld bc, 6911
			ld (hl),l
			ldir
			ld hl, 22528
			ld de, 22529
			ld bc, 767
			ld (hl),9
			ldir
			ld hl, TXTMEN01
			call IMPRIME_CADENA
			ld hl, 20537 ; ponemos la Ñ de retromañía
			ld (hl),120
			ld hl,	TXTTITULO
			ld de, 22623
			ld bc, 32*8
			ldir
			
MENUBUCLE:		ld d, 8
MENUBUCLE01:	ld a,#7F	; Si pulsamos espacio jugamos
				in a,(254)
				bit 0,a
				jr z, JUEGA

				ld a, d
				ld hl, 22953
				ld de, 22954
				ld bc, 13
				ld (hl), a
				ldir
				inc a
				ld d,a
				cp 15
				jr nz, MENUBUCLE01
			
				jr MENUBUCLE

JUEGA:		ld a,#7F	; Esperamos a soltar espacio
			in a,(254)
			bit 0,a
			jr z, JUEGA

			CALL CLSCYAN
			CALL SOMBREADO
			CALL CLSZJUEGO		
			call GENERADOR
			jp CURSOR	

TXTMEN01:	defb 16, 13,22,13,9
			defm "PULSA  ESPACIO"
			defb 22, 16, 4
			defm "PROGRAMA: MIGUEL G PRADA"
			DEFB 22,17,4
			DEFM "PARA CONCURSO RETROMANIA"
			DEFB 22,19,2
			DEFM "AGRADECIMIENTOS: FEDE, JAVI,"
			DEFB 22,20,7
			DEFM "PEDRETE Y SANTIAGO"
			DEFB 22,22,5
			DEFM "COMPILER SOFTWARE 2016" 
			defb 22,23,6
			defm "COMPILER.SPECCY.ORG"
			DEFB 255

TXTTITULO:	defb 9,9,9,9,9,73,73,73,73,73,9,9,73,73,73,73,73,9,9,73,73,73,73,73,9,9,73,9,9,9,9,9
			defb 9,9,9,9,9,73,9,9,9,73,0,9,73,9,9,9,73,0,9,73,9,9,9,73,0,9,73,0,9,9,9,9
			defb 9,9,9,9,9,73,9,9,9,73,0,9,73,9,9,9,73,0,9,73,9,9,9,73,0,9,73,0,9,9,9,9
			defb 9,9,9,9,9,73,9,9,9,73,0,9,73,73,73,73,73,0,9,73,73,73,73,73,0,9,73,0,9,9,9,9
			defb 9,9,9,9,9,73,9,9,9,73,0,9,73,0,0,0,0,0,9,73,0,0,0,0,0,9,73,0,9,9,9,9
			defb 9,9,9,9,9,73,9,9,9,73,0,9,73,0,9,9,9,9,9,73,0,9,9,9,9,9,9,0,9,9,9,9
			defb 9,9,9,9,9,73,73,73,73,73,0,9,73,0,9,9,9,9,9,73,0,9,9,9,9,9,73,9,9,9,9,9
			defb 9,9,9,9,9,9,0,0,0,0,0,9,9,0,9,9,9,9,9,9,0,9,9,9,9,9,9,0,9,9,9,9

;	################################################################################################
;	CONTADOR

SEGUNDOS:	defb 0
TIMERTEMP:	defb 0

TIMER:		di
			push af
			push hl
			push bc
			push de
			push ix

			; Incrementamos el tiempo
			ld a, (TIMERTEMP)
			inc a
			ld (TIMERTEMP), a
			cp 50
			jr nz, TIMER2
			xor a
			ld (TIMERTEMP),a
			ld a, (SEGUNDOS)
			inc a
			ld (SEGUNDOS),a

TIMER2:		pop ix
			pop de
			pop bc
			pop hl
			pop af
			ei
			RETI

;	################################################################################################


;	################################################################################################
;	MUERTE: 	Aquí se va todo al carajo

MUERTE: 	ld hl, 65535
MUERTE01:	out (254),a
			dec a
			dec hl
			ld a, h
			or l
			jr nz, MUERTE01
			jp ACORRER

;	################################################################################################


;	################################################################################################
;	CURSOR
;	Controla el cursor en pantalla y bucle general del juego.

Ccol:			defb 7		; columna de la paleta
Caltura:		defb 21		; Línea superior de la paleta, disminuye con la carga de fichas
Cnumfichas:		defb 0		; FIchas que tenemos sobre la paleta. Máximo 3
Ccolor:			defb 0		; Color de la ficha sobre la paleta
CcolATTR:		defw 23239	; Dirección del primer attr de la pala.
Puntos:			defw 0		; Fichas eliminadas
Cvelocidad:		defb 10		; Tiempo en segundos para bajar la línea

FichasTXT:		defb 16,14, 22,1,23
				defm "FICHAS"
				defb 255
PuntosTXT:		defb 16,14, 22,2,23," ", 255

CURSOR:			xor a
				ld (SEGUNDOS), a
				ld (TIMERTEMP), a
				ld hl, FichasTXT		; Imprimimos marcadores
				call IMPRIME_CADENA
				ld hl, PuntosTXT
				call IMPRIME_CADENA
				ld hl, (Puntos)
				call INT2ASCII
				ld hl, ASCII
				call IMPRIME_CADENA


				ld hl, (CcolATTR)  	;	Dibujamos la paleta.
				ld (hl), 112
				inc hl
				ld (hl), 112
				inc hl
				ld (hl), 48

Cbucle:			halt	; chapuza para ralentizar, cambiar por bucle correcto al afinar. O no.
				halt
				halt	

Creset:			;Si pulsamos R salimos al menú
				ld a,#FB
				in a,(254)
				bit 3,a
				jp z, MENU

				; Si es tiempo de bajar fila, lo hacemos
				ld a, (Cvelocidad)
				ld b,a
				ld a, (SEGUNDOS)
				cp b
				jr nz, Cderecha 	; No toca bajar
				xor a
				ld (SEGUNDOS), a
				ld (TIMERTEMP), a
				ld a, (Cvelocidad)
				cp 5
				jr z, Cdesciende01
				sbc a, 5
				ld (Cvelocidad),a
Cdesciende01:	call DESCIENDE
				call GENERALIN
				call FIJALIN
				; Chequeamos si estamos en la zona de muerte, y si es así, al carajo.
				ld a, (DescLin)
				cp 18
				jp z, MUERTE	


Cderecha:		ld a,#DF
				in a,(254)
				bit 0,a
				jr nz , Cizquierda
				ld a, (Ccol) 	; Si hemos llegado al límite derecho, no mueve.
				cp 16
				jr z, Cbucle
				ld hl, (CcolATTR) 	; Movemos la paleta a la derecha
				ld b,3
Cderecha01:		halt	; chapuceo para ralentizar en tiempo de desarrollo, quitar y cambiar por un timer (o no)
				halt
				halt
				ld (hl),0
				inc hl
				ld (hl),112
				inc hl
				ld (hl),112
				inc hl
				ld (hl), 48
				dec hl
				dec hl

				;Ahora comprobamos si también hay que mover las fichas
				ld a, (Cnumfichas)
				and a
				jr z, Cderecha02
				; Movemos las fichas
				push hl
				push bc
				ld b, a
				ld de, 32
				ld a, (Ccolor)
				dec hl
Cderecha03:		sbc hl, de
				push hl
				ld (hl), 0
				inc hl
				ld (hl), a
				inc hl
				ld (hl), a
				inc hl
				res 6,a
				ld (hl), a
				set 6,a
				pop hl
				djnz Cderecha03
				pop bc
				pop hl

Cderecha02:		djnz Cderecha01
				ld (CcolATTR), hl
				ld a,(Ccol)
				add a,3
				ld (Ccol), a
				ld a,r 			; Cambiamos el SEED de RAND
				ld (SEED),a
				jp Cbucle

Cizquierda:		bit 1,a
				jr nz , Cespacio
				ld a, (Ccol) 	; Si hemos llegado al límite izquierdo, no mueve.
				cp 1
				jp z, Cbucle
				ld hl, (CcolATTR) 	; Movemos la paleta a la derecha
				ld b,3
Cizquierda01:	halt	; chapuceo para ralentizar en tiempo de desarrollo, quitar
				halt
				halt
				inc hl
				inc hl
				ld (hl),0
				dec hl
				ld (hl), 48
				dec hl
				ld (hl), 112
				dec hl
				ld (hl), 112

				;Ahora comprobamos si también hay que mover las fichas
				ld a, (Cnumfichas)
				and a
				jr z, Cizquierda02
				; Movemos las fichas
				push hl
				push bc
				ld b, a
				ld de, 32
				ld a, (Ccolor)
Cizquierda03:	sbc hl, de
				push hl
				ld (hl), a
				inc hl
				ld (hl), a
				inc hl
				res 6,a
				ld (hl), a
				set 6,a
				inc hl
				ld (hl), 0
				pop hl
				djnz Cizquierda03
				pop bc
				pop hl


Cizquierda02:	djnz Cizquierda01
				ld (CcolATTR), hl
				ld a,(Ccol)
				sbc a,3
				ld (Ccol), a
				ld a,r 			; Cambiamos el SEED de RAND
				ld (SEED),a
				jp Cbucle				


Cespacio:		ld a,#7F			; Si pulsamos espacio
				in a,(254)
				bit 0,a
				jp nz, Cbucle


				ld a, (Cnumfichas) ; si el número de fichas es el máximo salta a disparo
				cp 3
				jr z, Cdispara

				; Calculamos línea y color de la ficha por encima de la paleta
				ld d,18 	; Dentro zona de la muerte para que al restar empiece búsqueda fuera de zona
				ld a,(Ccol)
				ld e,a
				call DIRATTR
				ld de, 32
				ld b, 17 	;Línea antes de la zona de la muerte
Cespacio01:		sbc hl, de
				ld a, (hl)
				and a
				jr nz, Cespacio02 ; Si hay ficha sale del bucle
				djnz Cespacio01
				jr Cdispara  ; Si llega al final del bucle y no encuentra ficha, salta a disparo
Cespacio02:		; Aquí tenemos en HL la dirección del atributo donde está la ficha a mover, en a el color y en b la línea
				ld d, a
				ld a, (Cnumfichas)
				and a
				jr nz, Cespacio03  ; Si hay fichas salta a comprobar colores. OJO Color está en D ahora.

BajaFicha:		ld a, (Caltura) ; Aquí bajamos la ficha
				sbc a, b
				ld b,a
				ld a, d ; tenemos en a el color
				ld (Ccolor), a ; almacenamos el color de la ficha que apilamos en su variable
BajaFicha01:	halt 	; Chapuceo ralentizar, cambiar por algo serio si apetece
				ld (hl),0  	; Borramos la ficha
				inc hl
				ld (hl),0
				inc hl
				ld (hl),0
				dec hl
				dec hl
				ld de, 32
				add hl, de
				ld (hl), a
				inc hl
				ld (hl), a
				inc hl
				res 6,a
				ld (hl),a
				set 6,a
				dec hl
				dec hl
				djnz BajaFicha01
				ld a, (Caltura) ; Actualizamos línea con ficha
				dec a
				ld (Caltura), a
				ld a, (Cnumfichas)
				inc a
				ld (Cnumfichas), a
				jp Cbucle

Cespacio03:		;Comprobamos si el color de la ficha en paleta es igual al que queremos coger. En caso contrario salta a disparar
				ld a, (Ccolor)
				cp d
				jr z, BajaFicha
				;jr Cdispara
				
Cdispara:		ld a, (Cnumfichas) ; si no hay fichas para qué vamos a disparar
				and a
				jp z, Cbucle

				;Aquí lanzamos las fichas a la parte superior

				;Lo primero es subir las fichas hasta que colisionen.
				;Buscamos la ficha tope
				ld hl, 23072
				ld d,0
				ld a,(Ccol)
				ld e,a
				add hl, de
				ld de, 32				
				ld b, 17
Cdispara01:		ld a, (hl)
				and a
				jr nz, Cdispara02   ; si hay ficha sale
				sbc hl, de
				djnz Cdispara01
Cdispara02:		inc b  ; en B tenemos la línea hasta la que subimos las fichas.

				ld a, 21
				sbc a, b ; ahora en A el número de iteraciones para subir el bloque
				ld b, a

				ld a, (Cnumfichas)  ; Y le restamos el num de fichas-1 para que no machaque fichas
				dec a
				ld h, a
				ld a, b
				sbc a, h
				ld b,a

				; Subimos el bloque
				ld hl, (CcolATTR)
				ld de, 32
				sbc hl, de

Cdispara03:		ld (hl),0  ; Borramos fila abajo ficha
				inc hl
				ld (hl),0
				inc hl
				ld (hl),0
				dec hl
				dec hl
				push hl

				push bc 	; Calculamos, según num de fichas, donde imprimimos la nueva
				ld a, (Cnumfichas)
				ld b,a
Cdispara04:		sbc hl, de
				djnz Cdispara04
				pop bc

				ld a, (Ccolor)
				ld (hl), a
				inc hl
				ld (hl), a
				inc hl
				res 6,a
				ld (hl), a
				dec hl
				dec hl

				pop hl
				sbc hl, de

				halt	; chapuceo...
				djnz Cdispara03

Celimina:		; eliminar bloque, restaurar variables y dar puntuación.
				
				;Tenemos en HL la dir del ATTR de la fila del impacto
				;ld a, (Cnumfichas)
				ld b, 0 ; ld b,a
				ld de, 32
Celimina02:		ld a, (Ccolor)
				cp (HL)
				jr nz, Celimina01 ; Si ya no es el color, eliminamos todas.
				inc b
				sbc hl, de
				jr Celimina02

Celimina01:		; actualizamos puntos, en b tenemos el número de fichas a destruir y lo sumamos
				
				; si solo tenemos una ficha en la paleta no destruimos la ficha ni puntuamos
				ld a, b
				cp 1
				jr z, Celimina04

				push hl  ; SUMAMOS LOS PUNTOS 1 por ficha destruida.
				push de
				push bc
				ld c,b
				ld b,0
				ld hl, (Puntos)
				add hl, bc
				ld (Puntos), hl
				ld hl, PuntosTXT
				call IMPRIME_CADENA
				ld hl, (Puntos)
				call INT2ASCII
				ld hl, ASCII
				call IMPRIME_CADENA
				pop bc
				pop de
				pop hl

				; borramos el bloque con efecto colorido
Celimina03:		push bc
				add hl, de
				ld b, 127
Celimina05:		ld a, b								
				ld (hl),a
				inc hl
				ld (hl),a
				inc hl
				ld (hl),a
				dec hl
				dec hl
				ld a, 150
Celimina06:		nop
				dec a
				jr nz, Celimina06
				ld (hl),0
				inc hl
				ld (hl),0
				inc hl
				ld (hl),0
				dec hl
				dec hl
				djnz Celimina05
				pop bc
				djnz Celimina03

				
Celimina04:		; Aquí restaura alguna variable y ejecuta el bucle de nuevo
				xor a
				ld (Cnumfichas), a
				ld (Ccolor), a
				ld a,21
				ld (Caltura), a
				jp Cbucle


;	################################################################################################


;	################################################################################################
;	FIJALIN:	Escanea cual es la línea más baja del bloque de fichas y actualiza su variable

FIJALIN:		ld a, (DescLin)
				ld d,a
				ld e,1
				call DIRATTR
				ld b, 6 	; Escaneamos la línea completa
FIJALIN01:		ld a, (hl)
				and a
				ret nz 		; Si encuentra ficha, sale
				inc hl
				inc hl
				inc hl
				djnz FIJALIN01
FINALIN02:		ld a, (DescLin) 
				dec a
				ld (DescLin), a
				and a
				jr nz, FIJALIN 	; Escanea línea anterior si no es la cero
				inc a
				ld (DescLin), a
				ret 	; Si la línea es cero, la fija en 1 y retorna

;	################################################################################################


;	################################################################################################
;	DESCIENDE: Baja el bloque de fichas una fila y añade una a la parte superior.

DescLin:		defb 6;		Línea inferior del bloque de fichas

DESCIENDE:		ld a,(DescLin)  ; Calculamos la dirección del attr
				ld d,a
				inc a
				ld (DescLin), a ; actualizamos la línea
				ld e,1
				call DIRATTR
				ld d,h 			; Calculamos la dirección de la siguiente línea para volcar
				ld e,l
				ld bc, 32
				add hl, bc
				ex de, hl
				ld a,(DescLin)
				dec a
				ld b,a
DESCIENDE01:	push bc
				ld bc, 18
				ldir
				ld bc, 50
				sbc hl, bc
				ex de, hl
				sbc hl, bc
				ex de, hl
				pop bc
				djnz DESCIENDE01
				jp GENERALIN

;	################################################################################################


;	################################################################################################
;	GENERADOR: Genera una pantalla aleatoria de inicio de juego

GENERADOR:		ld b,6		; Líneas a generar
				ld hl, 22561
GENERADOR01:	push bc
GENERADOR02:	ld b,6 		; Fichas por línea a generar
GENERADOR03:	push bc
GENERADOR04:	call RAND
				and 7
				and a 		; si color 0 genera otra
				jr z, GENERADOR04
				cp 5 		; si color >4 genera otra
				jr nc, GENERADOR04
				rla
				rla
				rla
				set 6,a
				ld (hl),a
				inc hl
				ld (hl),a
				inc hl
				res 6,a
				ld (hl),a
				inc hl
				pop bc
				djnz GENERADOR03
				ld bc, 14
				add hl, bc
				pop bc
				djnz GENERADOR01
				ret

;	################################################################################################


;	################################################################################################
; 	GENERALIN Genera la línea superior aleatoria cada vez que descienden las fichas

GENERALIN:		ld hl, 22561
				ld b, 6
GENERALIN01:	push bc
GENERALIN02:	call RAND
				and 7
				and a 		; si color 0 genera otra
				jr z, GENERALIN02
				cp 5 		; si color >4 genera otra
				jr nc, GENERALIN02
				rla
				rla
				rla
				set 6,a
				ld (hl),a
				inc hl
				ld (hl),a
				inc hl
				res 6,a
				ld (hl),a
				inc hl
				pop bc
				djnz GENERALIN01
				ret

;	################################################################################################


;	################################################################################################
;	RAND

SEED:			defb 0 			

RAND:			ld a,(SEED)
				ld b,a
				add a,a
				srla
				add a,a
				add a,b
				inc a
				ld (SEED),a
				rlca
				ret

;	################################################################################################


;	################################################################################################
;	IMPRIME_CADENA: Escribe en pantalla una cadena de caracteres mediante la rutina PRINT_CHAR.
;	Entrada:	HL Apuntando al inicio de la cadena de caracteres a imprimir.
;	Códigos:	16 seguido del atributo
;				22 seguido de línea y columna
;				255 cierra la cadena

PRINT_DIR:		defw 0	; Coordenadas de impresión para la rutina IMPRIME_CADENA y PRINT_CHAR
PRINT_ATTR:		defb 0	; Atributos de impresión para la rutina IMPRIME_CADENA y PRINT_CHAR

IMPRIME_CADENA:			ld de,0
IMPRIME_CADENA_01:		ld a,(hl)
						cp 255
						ret z
						cp 22
						jr nz, IMPRIME_CADENA_02
						inc hl
						ld d,(hl)
						inc hl
						ld e,(hl)
						inc hl
						ld (PRINT_DIR), de
						jr IMPRIME_CADENA_01
IMPRIME_CADENA_02:		cp 16
						jr nz, IMPRIME_CADENA_03
						inc hl
						ld a,(hl)
						ld (PRINT_ATTR),a
						inc hl
						jr IMPRIME_CADENA_01
IMPRIME_CADENA_03:		inc hl
						push hl
						ld h,0
						ld l,a
						call PRINT_CHAR
						pop HL
						jr IMPRIME_CADENA_01

;	IMPRIME_CADENA END
;	################################################################################################


;	################################################################################################
;	PRINT_CHAR: Escribe un caracter con sus atributos en pantalla.

PRINT_CHAR:				ld bc, 15360
						add hl, hl
						add hl, hl
						add hl, hl
						add hl, bc
						push hl
						ld de,(PRINT_DIR)
						call DIRATTR
						ld a,(PRINT_ATTR)
						ld (hl),a
						pop hl
						push de
						call DIRPANT
						ld b,8
PRINT_CHAR_01:			ld a,(hl)
						rla
						or (hl)
						ld (de),a
						inc d
						inc hl
						djnz PRINT_CHAR_01
						pop de
						ld a,e
						inc a
						and 31
						ld e,a
						ld (PRINT_DIR),de
						ret nz
						inc d
						ld a,d
						cp 24
						ret c
						ld d,0
						ld (PRINT_DIR),de
						ret 

;	PRINTCHAR END
;	################################################################################################


;	################################################################################################
;	DIRPANT:	Calcula la dirección en pantalla de unas coordenadas en baja resolución.
;	Entrada:
;				D: Línea
;				E: Columna.
;	Salida:
;				DE: Dirección de pantalla.

DIRPANT:		ld a,d
				and 24
				add a, 64
				ld b,a
				ld a,d
				rrca
				rrca
				rrca
				and 224
				add a,e
				ld e,a
				ld d,b
				ret

;	DIRPANT END
;	################################################################################################


;	################################################################################################
;	DIRATTR:	Calcula la dirección en pantalla de los atributos.
;	Entrada:
;				D: Línea.
;				E: Columna.
;	Salida:
;				HL: Dirección de memoria del atributo.

DIRATTR:		ld l,d
				ld h,0
				add hl, hl
				add hl, hl
				add hl, hl
				add hl, hl
				add hl, hl
				ld b,88
				ld c,e
				add hl, bc
				ret

;	DIRATTR END
;	################################################################################################


;	################################################################################################
;	CLSCYAN:		Borra toda la pantalla y pone los atributos en cyan con brillo.

CLSCYAN:		ld hl, 16384
				ld de, 16385
				ld bc, 6143
				ld (hl),l
				ldir
				ld hl, 22528
				ld de, 22529
				ld bc,767
				ld (hl),109
				ldir
				ret

;	CLSALL END
;	################################################################################################


;	################################################################################################
;	SOMBREADO: Sombrea la zona de juego y hace la línea de zona de la muerte

SOMBREADO:		ld hl, 23266
				ld de, 23267
				ld bc, 17
				ld (hl),45
				ldir
				ld hl, 22611
				ld b, 21
				ld de, 32
SOMBREADO01:	ld (hl), 45
				add hl, de
				djnz SOMBREADO01
				;línea zona muerte
				ld hl, 23104
				ld (hl),105
				ld hl, 23123
				ld (hl),41
				ld hl, 20544
				ld (hl),255
				ld hl, 20563
				ld (hl),255
				ret

;	################################################################################################


;	################################################################################################
;	CLSZJUEGO:	Pone a 0 la zona de juego

CLSZJUEGO:		ld b,22
				ld hl, 22561
CLSZJUEGO01:	push bc
				ld d,h
				ld e,l
				inc de
				ld bc, 17
				ld (hl),0
				ldir
				ld bc, 15
				add hl, bc
				pop bc
				djnz CLSZJUEGO01
				ret

;	################################################################################################


;	################################################################################################
;	SIGLINEA:	Calcula la dirección en pantalla de la siguiente línea a una dada.
;	Entrada:
;				DE: dirección de memoria en la pantalla actual.
;	Salida:
;				DE: dirección de la siguiente línea.

SIGLINEA:		inc d
				ld a,d
				and 7
				ret nz
				ld a,e
				add a,32
				ld e,a
				ret c
				ld a,d
				sub 8
				ld d,a
				ret

;	SIGLINEA END
;	################################################################################################


;	################################################################################################
;	INT2ASCII: Procesa un valor entero y devuelve una cadena ASCII
;	Entrada: HL valor.
;	Salida: ASCII cadena de 5 caracteres rellena con ceros a la izquierda

ASCII:			defb 48,48,48,48,48,255		; Aquí se almacena el número en ASCII con cierre de cadena.

INT2ASCII:		push hl
				ld hl, ASCII
				ld de, ASCII+1
				ld bc, 4
				ld a, 48
				ld (hl),a
				ldir
				pop hl
				ld b,5
				ld de, ASCII+4
INTA01:			push bc
				push de
				ld de, 10
				call DIVIDE
				ld a,e
				add a,48
				pop de
				ld (de),a
				dec de
				pop bc
				djnz INTA01
				ret

;	################################################################################################


;	################################################################################################
;	DIVIDE: Divide HL/DE
;	Entrada: 	HL Dividendo
;			 	DE Divisor
;	Salida:		HL Cociente
;				DE Resto

DIVIDE:			ld c,l
		        ld a,h
		        ld hl,0
		        ld b,16
		        or a
DIVI01:			rl c
		        rla
		        rl l
		        rl h
		        push hl
		        sbc hl, de
		        ccf
		        jr c, DIVI02
		        ex (sp), hl
DIVI02:			inc sp
		        inc sp
		        djnz  DIVI01
		        ex de, hl
		        rl c
		        ld l,c
		        rla
		        ld h,a
		        ret

;	################################################################################################

end start