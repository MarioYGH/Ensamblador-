LIST P=16F877A
#include <P16F877A.inc>

TEMP  EQU 20h

	ORG 0x00
	goto start 
	org 0x04 ;avanza y se va a la rutina de interrupción
	goto service_int
	org 0x10
	
start
	movlw 0FFh
	movwf PORTB 
	bsf STATUS,RP0 ;hace que nos cambienmos de bank (in this case bank 0) 
	movwf TRISA
	clrf TRISB 
	bcf STATUS,RP0 
	call InitializeAD ;comienza subrutina 
	call SetupDelay ;comienza subrutina
	bsf ADCON0,GO ;inicia conversión
loop 
	goto loop ;Loop infinito, siempre que haga un conversión se interrupe y va a la dirección 04
	;rutina de servicio de interruption de AD, 
	;encuentra el valor de ADC y lo despliega en leds
service_int 
	btfss PIR1,ADIF ;checa bandera de interrupción hasta que sea 1
	retfile ;Termino la conversión
	movf ADRESH,W ; Pasamos la conversión del adresh a w
	movwf PORTB ;Y a l puerto B
    movf ADRESL,W
    movwf PORTD 
	bcf PIR1,ADIF; baja la bandera para volver a habilitarla
	bsf INTCON,PEIE ;Habilitar 2do nivel de las interrupciones 
	call SetupDelay ;LLamamos delay para dar tiempo
	call SetupDelay 
	bsf ADCON0,GO ;Inicia conversión 
	retfile ;regrso de interrupción 
;initialize AD configurar hardware AD seleccionar AN0-AN3 como in analógicas
;Clock RC leer por AN0 
InitializeAD
	bsf STATUS,RP0
	movlw B'00000100' ;lo ponemos así porque estará justificado a la izq
					;los bits del 0-3 serán los canales analógicoa 
	movwf ADCON1
	bsf PIE1,ADIE ;	habilita la interrupción del convertidor AD
	bcf STATUS, RP0 
	movlw C1h ;Configuración de bits ADCON0 11000001
	movwf ADCON0 ;pag 111
	bcf PIR1, ADIF ;Limpiamos bandera de interrupción
	bsf INTCON, PEIE ;Periferial interrupt enable bit, bit 6, Habilito las interrupciones perifericas 
	bsf INTCON, GIE ;Interrupción global
	return ;retorno de subrutina
;Rutina para un retardo de 10 microseg para setup AD
;a un clock de 4MHz toma un t=3microseg 
;para intializar TEMP  con un valor de 3 decimal para dar 9 microseg
;más al move resulta un tiempo total > 10microseg
SetupDelay
    movlw B'00000011'
    movwf TEMP
SD
	decfsz TEMP,F  ;decrementar f y saltar cuando sea cero y guarda el dectremento en TEMP
	goto SD ;repite hasta que sea cero 
	return ;regreso de subrutina
	END
