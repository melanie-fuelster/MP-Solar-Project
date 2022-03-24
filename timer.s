#include <xc.inc>

global timer_Setup, timer_Int_Hi 
extrn	volt_conv
   
psect	timer_code, class=CODE
    
timer_Int_Hi:
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
;	incf	LATD, F, A	; increment PORTD
	call	volt_conv
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	

 
timer_Setup:
	clrf    TRISD, A	; Set PORTD as all outputs
	clrf    LATD, A		; Clear PORTD outputs
	movlw   10000101B	; Configure length of timer0 to 62.5kHz
	movwf   T0CON,A   
	bsf	    TMR0IE	; Enable timer0 interrupts
	bsf	    GIE	    ; Enable all interrupts
	return    

	
end