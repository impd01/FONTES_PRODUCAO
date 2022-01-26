#include 'protheus.ch'

/*/{Protheus.doc} FA050INC

@author jorge.heitor
@since 12/06/2017
@version 1.0
@type function
@description Ponto de Entrada para validar a Inclusão de Titulos a Pagar (usado para validar o preenchimento de codigo de retenção)

/*/
User Function FA050INC()

	Local lRet		:= .T.
	Local lTemIRR	:= .F.
	
	//Verificar impostos
	If Posicione("SED",1,FWxFilial("SED") + M->E2_NATUREZ,"ED_CALCIRF") == "S"
	
		lTemIRR := .T.
		
	EndIf

	//Se tiver IRR, valida o preenchimento do campo de DIRF e do Código de Retenção
	If lTemIRR	
		
		If M->E2_DIRF <> "1" .Or. Empty(M->E2_CODRET)
		
			MsgStop("Verificar o campo DIRF e/ou Código de Retenção!", "Atenção - FA050INC")
			lRet := .F.
			
		EndIf	
		
	EndIf
	
	If M->E2_TIPO <> 'TX' .and. Empty(M->E2_CCD)
		Alert("Informe o C. Custo Deb","Aten��o")
		Return(.F.)
	Endif
	
	If M->E2_XTIPO = '4' .and. M->E2_NATUREZ = '5005034' .and. M->E2_DIRF <> '2'
		Alert ("Este tipo de lan�amento n�o Gera Dirf, Alterar o campo Gera Dirf para - 2=N�o")
		Return(.F.)
	Endif
	

Return lRet