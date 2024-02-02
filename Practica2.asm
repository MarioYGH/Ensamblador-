LIST P=16F877A
#include <P16F877A.inc>

;entrada digital ocn push bottom por RA4 y cuenta binaria en 
;port B 
;para configurar nuestros registros (permiten entradas y salidad) TRIS A,
;TRIS B, PORT B

;especificamos nuestros registros y variables contenidos en la RAM 
TRISA EQU 85h ;in/out
PORTA EQU 05h ;lectura o ingreso de datos
TRISB EQU 86h
PORTB EQU 06h
COUNT EQU 20h

org 00h ;vector de reset, memoria del programa
goto Start

org 05h  ;vector de inicio 

Start 
	clrf PORTB ;limpia el puerto B, aquí se lleva la cuenta binaria
	bsf STATUS, RP0 ;nos dice que se enonctrará en el bank 0 
	movwf TRISB ;pouerto B como out, se mueve lo de w a f 
	bcf STATUS, RP0 ;para lograr llegar al bank 0, donde está la variable 
	clrf COUNT  ;limpia la variable COUNT 

Loop ;aquí se verifica nuestro pull up, "pulling", checa el bit continuamente
	btfss PORTA, 4 ; Bit Test f, Skip if Set
	goto IncCount
EndLoop
	goto Loop ;aquí se quedará hasta que el push bottom sea presionado 

IncCount 
	incf COUNT, F ;increment f, f=COUNT, lo guarda en F 
	movf COUNT, W
	movwf PORTB ;w es el registro de trabajo 

Debounce ;rutina de rebote, espera hasta que se suba el estado 
	btfss PORTA, 4 ;did you release the push buttom? 
	goto Debounce
EndDebounce 
	goto Loop 
	end
