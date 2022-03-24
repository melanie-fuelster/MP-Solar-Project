#include <xc.inc>

; ******* import external routines ****************************************
extrn	LCD_Setup			    ; external LCD subroutines
extrn	ADC_diff_setup, ADC_LDR_setup	    ; external ADC subroutines
extrn	volt_display, delay_250ns, ARG1L    ; external utilities subroutines
extrn   Servo_Setup, move_servo, move_servo2			    ; external servo subroutines
extrn   timer_Setup, timer_Int_Hi 

    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

  
int_hi:	org 0x0008
	goto	timer_Int_Hi
	; ******* Setup Code ***********************
setup:
	call	LCD_Setup	; setup LCD
	call	Servo_Setup	; setup servo motors
	call	timer_Setup
	goto	start
	
	; ******* Main programme ****************************************
start:	
	call	ADC_diff_setup	; setup ADC for differential input
	call    volt_display	; measures voltage difference and displays it on LCD
	movlw	0x04		; (0.004V threshold)
	cpfslt	ARG1L, A	; check if solar array is facing light source
	call    move_servo
;	
	call	ADC_LDR_setup	; setup ADC for differential input
	call    volt_display	; measures voltage difference and displays it on LCD
	movlw	0xd0		; (0.208V threshold)
	cpfslt	ARG1L, A	; check if solar array is facing light source
	call    move_servo2
	goto    start
	


	end	rst