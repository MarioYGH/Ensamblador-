LIST p=16F877A
#include <P16F877A.inc>

STATUS EQU 0x03
TRISB EQU 0X86
PORTB EQU 0X06
TRISD EQU 0X88
PORTD EQU 0X08

org 0x00
goto Start

org 0x05

Start
	bsf STATUS,RP0 ;Para ir al banco 1
	bcf STATUS,6 
    movlw B'11110000' ;Cargamos mitad entradas y mitad salisas
	movwf TRISB ;Lo movemos al puerto B
	clrf TRISD ;Declaramos como salida el puerto D
	bcf STATUS,RP0 ;Regresamos al banco 1
;El Loop principal cambia la compuerta de salida del puerto b
;Entre el 0,2 y 3. Cada mini Loop, revisa las entradas 5 y 4 
;para encender sus leds respectivos
Loop1  ; Loop Principal
    clrf PORTB ;Limpiamos puerto B
    bsf PORTB,0 ;Inicializamos b0 con un 1
    call Loop2 ;Y llamamos al segundo loop
	clrf PORTB ;Limpiamos puerto B y repetimos el Proceos
	bsf PORTB,2
	call Loop3
	clrf PORTB
	bsf PORTB,3
	call Loop4
	clrf PORTB
goto Loop1	;Nos mantenemos en el Loop
Loop2 ;Primer mini Loop
	call Leds1 ;Llamamos subrutina Leds1
	call Leds2 ;Las subrutinas Leds son iguales
return ;Regresamos al loop1
goto Loop1
Loop3
	call Leds3
	call Leds4 
return
goto Loop1
Loop4
	call Leds5
	call Leds6
    return
goto Loop1

Leds1
	btfss PORTB,4 ;Si se recibe un 1 en el puerto 4 salta a la siguiente instrucción
	return
	bsf PORTD,0 ;Enciende el led 1, que esta en d0
	call Debounce1 ;sutina de Rebote
	return ;regresamos al llamado de subrutina

Leds2
	btfss PORTB,5
	return
	bsf PORTD,1
	call Debounce2
	return

Leds3
	btfss PORTB,4
	return
	bsf PORTD,2
	call Debounce1
	return

Leds4
	btfss PORTB,5
	return
	bsf PORTD,3
	call Debounce2
	return

Leds5
	btfss PORTB,4
	return
	bsf PORTD,4
	call Debounce1
	return

Leds6
	btfss PORTB,5
	return
	bsf PORTD,5
	call Debounce2
	return

Debounce1 ;rutina de rebote, espera hasta que se baje el estado 
	btfsc PORTB,4 ;Si el bit es cero, se dejo de apretar el botón 
	goto Debounce1 ;salta esta instrucción que mantiene encendido el led
    clrf PORTD ;Limpia el puerto D
EndDebounce1 ;regresamos al llamado de subrutina Debounce1
    return

Debounce2 ;rutina de rebote, espera hasta que se bajo el estado 
	btfsc PORTB,5 ;
	goto Debounce2
    clrf PORTD
EndDebounce2 
    return

end
