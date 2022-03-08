#include <xc.inc>

global  multiply, multiply_uneven
global	RES0, RES1, RES2, RES3, ARG1H, ARG2H, ARG1L, ARG2L
global	L1, M1, H1, ARG2
    
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
tmp:	ds 1	; reserve 1 byte for temporary use
counter:	ds 1	; reserve 1 byte for counting through nessage
    
psect	utils_code, class=CODE
    
    ; ** a few delay routines below here as LCD timing can be quite critical ****
delay_ms:		    ; delay given in ms in W
	movwf	cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	delay_x4us	
	decfsz	cnt_ms, A
	bra	lcdlp2
	return
    
delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	cnt_l, A	; now need to multiply by 16
	swapf   cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	cnt_l, W, A ; move low nibble to W
	movwf	cnt_h, A	; then to cnt_h
	movlw	0xf0	    
	andwf	cnt_l, F, A ; keep high nibble in cnt_l
	call	delay
	return



	
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
end