#include 'protheus.ch'

/*/{Protheus.doc} MTA103OK

@author jorge.heitor
@since 12/06/2017
@version 1.0
@type function
@description Ponto de Entrada para validar a Nota Fiscal de Entrada (usado para validar o preenchimento de codigo de retenção)

/*/
user function MTA103OK()

	Local lRet		:= .T.
	Local lTemIRR	:= .F.
	Local x
	
	//Verificar impostos
	For x:= 1 to Len(oFisRod:aArray)
	
		If AllTrim(oFisRod:aArray[x][1]) = "IRR"
		
			lTemIRR := .T.
			exit
			
		EndIf
		
	Next x

	//Se tiver IRR, valida o preenchimento do campo de DIRF e do Código de Retenção
	If lTemIRR
	
		If cDIRF <> "1" .Or. Empty(cCodRet)
		
			MsgStop("Verificar o campo DIRF e/ou Código de Retenção!", "Atenção - MTA103OK")
			lRet := .F.
			
		EndIf
		
	EndIf
	

Return lRet


