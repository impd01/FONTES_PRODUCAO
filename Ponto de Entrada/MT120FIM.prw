#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT120FIM

@author carlos.xavier
@since 17/02/2017
@version 0.0.1
@type function
/*/

user function MT120FIM()

local cFunname:="CNTA120|CNTA260|CNTA150"
local cFuncName:=rTrim(Funname())

	BEGIN SEQUENCE
	
		IF (.not.(cFuncName $ cFunname))
		   BREAK
		Endif
				
		recLock("SC7",.F.)
			
			SC7->C7_XTPCTO:=CN9->CN9_TPCTO
			SC7->C7_XCONTRA:=CN9->CN9_NUMERO
			SC7->C7_CC:=CN9->CN9_XREG
			SC7->C7_XEND:=CN9->CN9_XEND
			SC7->C7_XBAIRRO:=CN9->CN9_XBAIRR
			SC7->C7_XMUN:=CN9->CN9_XMUN
		
		SC7->(msUnlock())
	     
	
	
	END SEQUENCE
	


return 