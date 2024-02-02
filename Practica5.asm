LIST P=16F877A ; Indicamos el microcontrolador con el cual vamos a trabajar
#include <p16F877A.inc> ; directiva del micro
; programa on off

CORR EQU 20
CON1 EQU 21
CON1 EQU 21
TEMPO EQU 22
APU EQU 23
DATO EQU 24
BAN EQU 25 ; Establecer variables a direcciones RAM, banco 0


	ORG 00H ; Vamos al vector de inicio para iniciar el programa
	GOTO MAIN ; Ir a la directiva main
	ORG 04H ; Direccion 04 subrutina de interrupcion
	GOTO TIMER1 ; vamos a la rutina de interrupcion 
	ORG 06H ; direccion inicio del programa
	
	
	
MAIN BSF STATUS,5 ;Vamos al banco 1
	 CLRF TRISB ; Configura el puerto B
	 BCF STATUS, 5 ; Regresamos al banco 0
	 MOVLW 0x31 ; Movemos al registro de trabajo el numero 31/16
	 MOVWF T1CON ; COnfiguracion Timer1 enbale = bit 0 / Prescalador 1:8 = bit 4 y 5
	 MOVLW 0x0A ; COnfiguracion Timer
	 MOVWF CON1 ; COnfiguramos CON1
	 BCF PIR1,0 ; Iniciamos la bandera de la interrupcion
	 BSF STATUS,5 ; Nos movemos al banco 1
	 BSF PIE1,0 ; Habilitamos las interrupciones en el micro
	 BCF STATUS,5 ; Regresamos al banco 0
	 BSF INTCON,6
	 BSF INTCON,7 ; Habilitamos los registros de interrupciones (perifericas y globales)
	 MOVLW 0xFF ; Cargamos el numero FF a W
	 MOVWF CORR ; Cargamos FF en CORR
	 MOVWF PORTB ; Cargamos FF en Puerto B
	 BCF STATUS,0 ; Limpiamos el bit 0 del status
		 
OCIOSO NOP
	   GOTO OCIOSO ; Ciclo infinito hasta que el timer 1 interrumpa
	  
; Interrupcion  
TIMER1 DECFSZ CON1,1 ; Decrementa F, saltar si es 0
	   GOTO UNO 
	   MOVLW 0x0A ; Cargamos 0A /16 en W
	   COMF CORR ; Apagamos los LEDs del puerto B
	   MOVF CORR,0 ; Guarda lo que tengo en CORR en W
	   MOVWF PORTB ; Movemos W al puerto B
	   
UNO BCF PIR1,0 ; Limpia la bandera de interrupcion
	RETFIE ; Retorno de la interrupcion
	END
