#include <xc.inc>

global  timer_Setup
   
psect	adc_code, class=CODE
    
timer_Setup:
    movlw   10000111B	; Configure length of timer0 to 62.5kHz
    movwf   T0CON,A   
    bsf	    TMR0IE	; Enable timer0 interrupts
    
    bsf	    GIE	    ; Enable all interrupts
    return
    
    

    


	
end