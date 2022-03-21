#include <xc.inc>

; ******* import external routines ****************************************
extrn	LCD_Setup			    ; external LCD subroutines
extrn	ADC_Setup, ADC_diff_setup, ADC_LDR_setup	    ; external ADC subroutines
extrn	volt_display, delay_250ns, ARG1L    ; external utilities subroutines
extrn   Servo_Setup, move_servo		    ; external servo subroutines

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Setup Code ***********************
setup:
	call	LCD_Setup	; setup LCD
	;call	ADC_Setup	; setup ADC
;	call	ADC_diff_setup	; setup ADC for differential input
	call	ADC_LDR_setup	; setup ADC for differential input from LDRs (eventually)
	call	Servo_Setup	; setup servo motors
	goto	start

	
	; ******* Main programme ****************************************
start:	
	call    volt_display	; measures voltage difference and displays it on LCD
	movlw	0x04		; (0.004V threshold)
	cpfslt	ARG1L, A	; check if solar array is facing light source
	call    move_servo
	call	delay_250ns
	call	delay_250ns
	goto    start

	end	rst