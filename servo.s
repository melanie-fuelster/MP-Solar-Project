#include <xc.inc>

global  Servo_Setup, Create_Pulse
    
extrn   delay_x4us, delay_100us, delay_ms
    
psect udata_acs
pulse_width:    ds 1 

psect	servo_code, class=CODE
    
Servo_Setup:
;   defining Port J as output (ie, pulse for Servo will arrive here)
    	movlw	0x0
	movwf	TRISJ, A
	return

Create_Pulse:
    movwf   pulse_width, A
    movlw   0x01	
    movwf   PORTJ, A    ;start of pulse
    movff   pulse_width, WREG, A
    call    delay_100us ;define pulse length
    movlw   0x00
    movwf   PORTJ, A    ;end of pulse
return
	
	
Test_Pulse:
	movlw	0x01	
	movwf	PORTJ, A    ;start of pulse
	movlw	25
	call	delay_100us ;define pulse length
	movlw	0x00
	movwf	PORTJ, A    ;end of pulse
	movlw	255
	call	delay_ms    ;wait between pulses (for testing purposes)
	movlw	0x01
	movwf	PORTJ, A    ;start of pulse
	movlw	10
	call	delay_100us;define pulse length
	movlw	0x00
	movwf	PORTJ, A    ;end of pulse
	movlw	255
	call	delay_ms    ;wait between pulses (for testing purposes)
	return
    
end