#include <xc.inc>

global  Servo_Setup, Create_Pulse
    
extrn   delay_x4us, delay_100us,delay_ms
    
psect udata_acs
RES0:	ds  1

psect	servo_code, class=CODE
    
Servo_Setup:
;   defining Port J as output (ie, pulse for Servo will arrive here)
    	movlw	0x0
	movwf	TRISJ, A
	return

Create_Pulse:
	movlw	0x01
	movwf	PORTJ, A
	movlw	25
	call	delay_100us
	movlw	0x00
	movwf	PORTJ, A
	movlw	255
	call	delay_ms
	movlw	0x01
	movwf	PORTJ, A
	movlw	10
	call	delay_100us
	movlw	0x00
	movwf	PORTJ, A
	movlw	255
	call	delay_ms
	return
    
end