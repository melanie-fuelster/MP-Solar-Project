#include <xc.inc>

global delay_x4us, delay_100us, delay_ms, delay_250ns, delay_12us
global  multiply, multiply_uneven,volt_display
global	ARG1H,ARG2H,ARG1L,ARG2L,L1,H1,M1,ARG2, RES0, RES1, RES2, RES3

extrn	LCD_Write_Hex, LCD_Send_Byte_D
extrn	LCD_clear, LCD_shift, LCD_delay, LCD_Write_Hex_Dig
extrn	ADC_Read
    
psect udata_acs
RES0:	ds  1
RES1:	ds  1
RES2:	ds  1
RES3:	ds  1
ARG1H:	ds  1
ARG2H:	ds  1
ARG1L:	ds  1
ARG2L:	ds  1
L1:	ds  1
H1:	ds  1
M1:	ds  1
ARG2:	ds 1
    
cnt_l:	ds 1	; reserve 1 byte for variable cnt_l
cnt_h:	ds 1	; reserve 1 byte for variable cnt_h
cnt_ms:	ds 1	; reserve 1 byte for ms counter
cnt_100us:ds 1	; reserve 1 byte for 100us counter
cnt_12us:ds 1	; reserve 1 byte for 100us counter
tmp:	ds 1	; reserve 1 byte for temporary use
counter:	ds 1	; reserve 1 byte for counting through nessage
sign:	ds 1	; sign bit from AD differential
diff_reading: ds 1
    
    
psect	utils_code, class=CODE
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			    ;;;; DELAY ROUTINES ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
delay_ms:		    ; delay given in ms in W
	movwf	cnt_ms, A
msloop:	movlw	250	    ; 1 ms delay
	call	delay_x4us	
	decfsz	cnt_ms, A
	bra	msloop
	return
	
delay_100us:		    ; delay given in ms in W
	movwf	cnt_100us, A			    ; USING SAME STORAGE VARIABLE AS IN FUNCTIONS ABOVE!! PLEASE CHANGE
usloop:	movlw	25	    ; 0.1 ms delay
	call	delay_x4us	
	decfsz	cnt_100us, A
	bra	usloop
	return 
	
delay_12us:		    ; delay given in ms in W
	movwf	cnt_12us, A			    ; USING SAME STORAGE VARIABLE AS IN FUNCTIONS ABOVE!! PLEASE CHANGE
usloop12:movlw	3	    ; 0.1 ms delay
	call	delay_x4us	
	decfsz	cnt_12us, A
	bra	usloop12
	return 	
delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	cnt_l, A	; now need to multiply by 16
	swapf   cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	cnt_l, W, A ; move low nibble to W
	movwf	cnt_h, A	; then to cnt_h
	movlw	0xf0	    
	andwf	cnt_l, F, A ; keep high nibble in cnt_l
	call	delay_250ns
	return
	
delay_250ns:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
nsloop:	decf 	cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	nsloop		; carry, then loop again
	return		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			    ;;;; ARITHMETIC ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
multiply:
	MOVF ARG1L, W, A
	MULWF ARG2L, A ; ARG1L * ARG2L-> 
		    ; PRODH:PRODL 
	MOVFF PRODH, RES1, A ; 
	MOVFF PRODL, RES0, A ; 
	; 
	MOVF ARG1H, W, A 
	MULWF ARG2H, A ; ARG1H * ARG2H-> 
		    ; PRODH:PRODL 
	MOVFF PRODH, RES3, A ; 
	MOVFF PRODL, RES2, A ; 
	; 
	MOVF ARG1L, W, A 
	MULWF ARG2H, A ; ARG1L * ARG2H-> 
		    ; PRODH:PRODL 
	MOVF PRODL, W, A ; 
	ADDWF RES1, F, A ; Add cross 
	MOVF PRODH, W, A ; products 
	ADDWFC RES2, F, A ; 
	CLRF WREG, A ; 
	ADDWFC RES3, F, A ; 
	; 
	MOVF ARG1H, W, A ; 
	MULWF ARG2L, A ; ARG1H * ARG2L-> 
		    ; PRODH:PRODL 
	MOVF PRODL, W, A ; 
	ADDWF RES1, F, A ; Add cross 
	MOVF PRODH, W, A ; products 
	ADDWFC RES2, F, A ; 
	CLRF WREG, A ; 
	ADDWFC RES3, F, A ; 
	return
	
multiply_uneven:
	MOVF L1, W, A
	MULWF ARG2, A ; ARG1L * ARG2L-> 
		    ; PRODH:PRODL 
	MOVFF PRODH, RES1, A ; 
	MOVFF PRODL, RES0, A ; 
	; 
	MOVF H1, W, A 
	MULWF ARG2, A ; ARG1H * ARG2H-> 
		    ; PRODH:PRODL 
	MOVFF PRODH, RES3, A ; 
	MOVFF PRODL, RES2, A ; 
	; 
	MOVF M1, W, A 
	MULWF ARG2, A ; ARG1L * ARG2H-> 
		    ; PRODH:PRODL 
	MOVF PRODL, W, A ; 
	ADDWF RES1, F, A ; Add cross 
	MOVF PRODH, W, A ; products 
	ADDWFC RES2, F, A ; 
	CLRF WREG, A ; 
	ADDWFC RES3, F, A ; 

	return
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			    ;;;; VOLT DIFF CONVERTER ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
volt_conv:
	movff	ADRESL, ARG1L, A    ; low byte of ADC result
	movff	ADRESH, diff_reading, A    ; high byte of ADC result
	movlw	00001111B
	andwf	diff_reading, W, A
	movwf	ARG1H, A		; store lower nibble of high byte in ARG1H
	
	movlw	11110000B
	andwf	diff_reading, W, A
	movwf	sign, A
	swapf	sign, f, A	    ; store higher nibble of high byte in sign
	
	btfsc	sign, 0, A
	call	subtraction
	
	movf	ARG1H, W, A
	call	LCD_Write_Hex
 	movf	ARG1L, W, A
 	call	LCD_Write_Hex
	call	LCD_shift
	
	movlw	0x41
	movwf	ARG2H, A	    ; high byte of conversion number
	movlw	0x8A
	movwf	ARG2L, A	    ; low byte of conversion number
	call	multiply	    ; result will be in RES0-3
	movf	RES3, W, A	    ;print highest non-zero nibble
	call	LCD_Write_Hex_Dig
	movlw	0x2E
	call	LCD_Send_Byte_D
	call	volt_decimals
	call	volt_decimals
	call	volt_decimals
	movlw	0x56
	call	LCD_Send_Byte_D
	return
volt_decimals:
	movff	RES2, H1, A
	movff	RES1, M1, A
	movff	RES0, L1, A
	movlw	0x0A
	movwf	ARG2, A
	call	multiply_uneven
	movf	RES3, W, A	    ;print highest non-zero nibble
	call	LCD_Write_Hex_Dig
	return

volt_display:
	call	ADC_Read
; 	movf	ADRESH, W, A
;	call	LCD_Write_Hex
; 	movf	ADRESL, W, A
; 	call	LCD_Write_Hex
;	call	LCD_shift
	call	volt_conv
	call	LCD_delay
	call	LCD_delay
	call	LCD_delay
	call	LCD_delay
	call	LCD_delay
	call	LCD_delay
	call	LCD_delay

	call	LCD_delay
	call	LCD_clear
	goto	volt_display		; NEED TO CHANGE! WILL GET STUCK IN LOOP! --> use timer interrupt ?
	
	
subtraction:
	movff	ARG1L, WREG, A
	sublw	0xff
	movwf	ARG1L, A
	movlw	0x00
	movwf	ARG1H, A
	return

	
end