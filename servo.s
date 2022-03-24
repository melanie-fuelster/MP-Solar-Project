#include <xc.inc>

global  Servo_Setup, Create_Pulse, Create_small_Pulse, move_servo, move_servo2
    
extrn	delay_100us, delay_ms, delay_12us, sign	    ; external utilities subroutines
    
psect udata_acs
pulse_width:    ds 1 

psect	servo_code, class=CODE
    
Servo_Setup:
;   defining Port H as output (ie, pulse for Servo will arrive here)
    	movlw	0x0
	movwf	TRISH, A
	return

move_servo:
	btfsc	sign, 0, A	;testing arbitrary (0th) bit
	call	move_right
	call	move_left
	movlw	0x01
	call	delay_ms
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
	movlw   0x01		    ;send pulse to pin RH0
	movwf   PORTH, A	    ;start of pulse
	movf	pulse_width, W, A
	call    delay_100us	    ;define pulse length
	movlw   0x00
	movwf   PORTH, A	    ;end of pulse
	return
	

	
move_servo2:
	btfsc	sign, 0, A	;testing arbitrary (0th) bit
	call	move_right2
	call	move_left2
	movlw	0x04
	call	delay_ms
	return
	
move_right2:			;solar servo needs to fight the wires in this direction so we need it to move faster
	movlw	0x20		;3.2 ms pulse
	call	Create_Pulse2
	return	
move_left2:
	movlw	0x0e		;1.4 ms pulse
	call	Create_Pulse2
	return	
Create_Pulse2:			    ;for servo attached to panels
	movwf   pulse_width, A
	movlw   0x02		    ;send pulse to pin RJ1
	movwf   PORTH, A	    ;start of pulse
	movf	pulse_width, W, A
	call    delay_100us	    ;define pulse length
	movlw   0x00
	movwf   PORTH, A	    ;end of pulse
	return

	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			    ;;;; TEST SUBROUTINES ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
Create_small_Pulse:
	movwf   pulse_width, A
	movlw   0x01	
	movwf   PORTJ, A    ;start of pulse
	movf	pulse_width, W, A
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