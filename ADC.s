#include <xc.inc>

global  ADC_Read, ADC_diff_setup, ADC_LDR_setup
   
psect	adc_code, class=CODE
    
;ADC_Setup:
;	bsf	TRISA, PORTA_RA0_POSN, A  ; pin RA0==AN0 input
;	movlb	0x0f
;	bsf	ANSEL0	    ; set AN0 to analog
;	movlb	0x00
;	movlw   0x01	    ; select AN0 for measurement
;	movwf   ADCON0, A   ; and turn ADC on
;	movlw   0x30	    ; Select 4.096V positive reference
;	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
;	movlw   0xF6	    ; Right justified output
;	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
;	return

ADC_diff_setup:
    	bsf	TRISA, PORTA_RA0_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL0	    ; set AN0 to analog
	
	bsf	TRISA, PORTA_RA1_POSN, A  ; pin RA1==AN1 input
	movlb	0x0f
	bsf	ANSEL1	    ; set AN1 to analog
	
	movlb	0x00
	movlw   0x01	    ; select AN0 for measurement
	movwf   ADCON0, A   ; and turn ADC on
;	movlw   0x30	    ; Select 4.096V positive reference
	movlw	0x32	    ; 00110010
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return
    
	
ADC_LDR_setup:
    	bsf	TRISA, PORTA_RA2_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL2	    ; set AN2 to analog
	
	bsf	TRISA, PORTA_RA3_POSN, A  ; pin RA1==AN1 input
	movlb	0x0f
	bsf	ANSEL3	    ; set AN3 to analog
	
	movlb	0x00
	movlw   00001001B	    ; select AN2 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	
	movlw	00110100B   ; selects  AN3 as negatove input
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return
	
	
ADC_Read:
	bsf	GO	    ; Start conversion by setting GO bit in ADCON0
adc_loop:
	btfsc   GO	    ; check to see if finished
	bra	adc_loop
	
	return
	
end