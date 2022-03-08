#include <xc.inc>

global  ADC_Setup
    
psect udata_acs
RES0:	ds  1

psect	servo_code, class=CODE
    
Servo_Setup:
	return

Create_Pulse:
    
end