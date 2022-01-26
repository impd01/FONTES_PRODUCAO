#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CNTPRSE2
@author carlos.xavier
@since 17/02/2017
@version 0.0.1
@obs PE responsavel por levar dados ao titulo do contrato
@type function
/*/
user function CNTPRSE2()
local cFuncName:=rTrim(Funname())

	BEGIN SEQUENCE
		
		//IF cFuncNAme == "CNTA100|CNTA150|CNTA120|CNTA260"
		
			Reclock("SE2",.F.)
				SE2->E2_XTPCTO:=CN9->CN9_TPCTO
				SE2->E2_XCONTRA:=CN9->CN9_NUMERO
				SE2->E2_XREG:=CN9->CN9_XREG
				SE2->E2_XRDESC:=CN9->CN9_XRDESC
				SE2->E2_XEND:=CN9->CN9_XEND
				SE2->E2_XBAIRRO:=CN9->CN9_XBAIRR 
				SE2->E2_XMUN:=CN9->CN9_XMUN
			SE2->(msUnlock())
				
		//EndIF
			
		
	END SEQUENCE 
	
return