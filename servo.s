#include <xc.inc>

global  ADC_Setup
    
psect udata_acs
RES0:	ds  1

psect	servo_code, class=CODE
    
Servo_Setup:
;   defining Port J as output (ie, pulse for Servo will arrive here)
    	movlw	0x0
	movwf	TRISJ, A
	return

Create_Pulse:
	
	return
    
end