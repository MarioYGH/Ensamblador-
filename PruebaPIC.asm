LIST P=16F877A
#INCLUDE <P16F877A.INC>

;Prueba las salidas de puertos B y C con corrimiento 
;de un BIT cada 0.5 segundos en cada puerto secuencialmente

; DEFINICION DE ETIQUETAS -------------------------------------------------

TMR0		EQU	01h	; Temporizador 0
OPTION_REG      EQU     81h
STATUS		EQU	03h	; Registro de estado
PORTB		EQU	06h	; Puerto B
TRISB		EQU     86h     ; Entrada/salida puertoB
PORTC		EQU	07h	; Puerto C
TRISC		EQU     87h     ; Entrada/salida puertoC
INTCON		EQU	0Bh	; Registro de control de interrupciones
CUENTA		EQU	20h	; Registro de conteo para el retardo de 0.5 seg.

; VECTOR DE INICIO

	ORG 0		        ; Vector de reset
	goto	INICIO	        ; Salto al inicio del programa


; PROGRAMA PRINCIPAL *********************************************************

	ORG 5		        ; Vector de inicio

; CONFIGURACION DE REGISTROS--------------------------------------------------

INICIO	bsf	STATUS,5	; Cambio al banco 1 RAM

; Configuracion de puertos
	clrf	TRISB		; Configura todo el puerto B como salida
	clrf	TRISC		; Configura todo el puerto C como salida

; Configuracion del temporizador
	movlw	b'11010111'	; Carga el registro de trabajo con 11010111
	movwf	OPTION_REG	; Configura el registro OPTION_REG 1101 0___ Prescalador 1:256
				; 1101_ Divisor o prescalador asignado a TMR0
				; 110_ Incremento por flanco descendente
				; 11_ Pulsos del reloj interno
				; 1_Interrupción externa RB0 por flanco ascendente
				; _Resistencias pull-up puerto B desactivadas
	bcf	STATUS,5        ; Regresa al banco 0 RAM

; TAREA PRINCIPAL------------------------------------------------------------------

; Inicializacion de variables
CICLO	clrf	PORTB		; Limpia el puerto B
	clrf	PORTC		; Limpia el puerto C

; Prueba del puerto B
	bsf	PORTB,0		; Pone un 1 en el bit 0 del puerto B
CICLOB	call    RETARDO	        ; Llamada a subrutina de retardo
	rlf	PORTB,1		; Rota a la izquierda el bit en el puerto B
	btfss   STATUS,0	; Prueba si ha ocurrido el acarreo (vuelta completa)
	goto    CICLOB	        ; Salta para repetir el ciclo

; Prueba del puerto C
	bsf	PORTC,0		; Pone un 1 en el bit 0 del puerto C
CICLOC	call    RETARDO	        ; Llamada a subrutina de retardo
	rlf	PORTC,1		; Rota a la izquierda el bit en el puerto C
	btfss   STATUS,0	; Prueba si ha ocurrido el acarreo (vuelta completa)
	goto    CICLOC		; Salta para repetir el ciclo

	goto    CICLO		; Repite la tarea principal

; RUTINA DE RETARDO----------------------------------------------------------------

RETARDO	clrf    CUENTA		; Limpia la cuenta del retardo
CICLOR	movlw   01h		; Carga el registro de trabajo W con 1 hexadecimal
	addwf   CUENTA,1        ; Suma un 1 a CUENTA y guarda el resultado en CUENTA
	clrf    TMR0		; Inicializa en CERO el TIMER0
TIEMPO	btfss   INTCON,2	; Verifica bandera de desbordamiento del TIMER0
	goto    TIEMPO		; Salto a verificacion
	bcf     INTCON,2	; Limpia la bandera del desbordamiento del TIMER0
	btfss   CUENTA,3	; Verifica fin de la CUENTA=00001000=8 decimal
	goto    CICLOR		; Retorna a incrementar la cuenta
	return			; Retorno de subrutina
	END			; Fin del programa
