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
    
psect	utils_code, class=CODE
	
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