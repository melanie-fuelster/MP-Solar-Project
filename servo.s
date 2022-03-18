#include <xc.inc>

global  Servo_Setup, Create_Pulse, Create_small_Pulse, move_servo
    
extrn	delay_100us, delay_ms, delay_12us, sign	    ; external utilities subroutines
    
psect udata_acs
pulse_width:    ds 1 

psect	servo_code, class=CODE
    
Servo_Setup:
;   defining Port J as output (ie, pulse for Servo will arrive here)
    	movlw	0x0
	movwf	TRISJ, A
	return

move_servo:
	btfsc	sign, 0, A
	call	move_right
	call	move_left
	return
	
;centre pulse width is 1.46 ms --> the closer to centre, the slower the servo
move_right:
	movlw	0x28		;4 ms pulse
	call	Create_Pulse
	return
move_left:
	movlw	0x0e		;1.4 ms pulse
	call	Create_Pulse
	return
	
Create_Pulse:
	movwf   pulse_width, A
	movlw   0x01	
	movwf   PORTJ, A	    ;start of pulse
	movf	pulse_width, W, A
	call    delay_100us	    ;define pulse length
	movlw   0x00
	movwf   PORTJ, A	    ;end of pulse
return

	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			    ;;;; TEST SUBROUTINES ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
Create_small_Pulse:
	movwf   pulse_width, A
	movlw   0x01	
	movwf   PORTJ, A    ;start of pulse
	movf   pulse_width, W, A
	call    delay_12us ;define pulse length
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