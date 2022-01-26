#include 'protheus.ch'

/*/{Protheus.doc} IMPDGAT

@author jorge.heitor
@since 20/06/2017
@version 1.0
@type function
@description Função principal para comportar gatilhos que chamam funções

/*/
User Function IMPDGAT(nGatilho)
	
	Local xRet
	
	xRet := &("Gatilho" + AllTrim(Str(nGatilho)) + "()")

Return xRet

/*/{Protheus.doc} Gatilho1

@author jorge.heitor
@since 20/06/2017
@version 1.0
@type function
@description Gatilho do campo E2_NATUREZ para o campo E2_DIRF

/*/
Static Function Gatilho1()

	Local cRet :=  ""
	
	If Posicione("SED",1,FWxFilial("SED") + M->E2_NATUREZ,"ED_CALCIRF") == "S"
	
		cRet := "1"
		
	Else
	
		cRet := "2"
		
	EndIf
	
Return cRet

/*/{Protheus.doc} Gatilho2

@author jorge.heitor
@since 20/06/2017
@version 1.0
@type function
@description Gatilho do campo E2_NATUREZ para o campo E2_CODRET

/*/
Static Function Gatilho2()

	Local cRet :=  ""
	
	cRet := Posicione("SED",1,FWxFilial("SED") + M->E2_NATUREZ,"ED_CODRET")
	
Return cRet