#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

	
User Function IM76U01(cProcesso) 

DbSelectArea("SZ9")
DbSetOrder(1)
		
		IF SZ9->(DbSeek(xFilial("SZ9")+cProcesso))
		
			MsgInfo("Este n�mero de processo j� esta cadastrado","TOTVS")

			Return .F.
		
		Endif

DbCloseArea()

Return