#include 'protheus.ch'
#include 'parmtype.ch'

user function FA100TRF()
	
Private CNATURORI
Private CTIPOTRAN	
	
	IF CNATURORI = "10004" .And. CTIPOTRAN <> "TB" 
		Alert("Para a natureza informada o Tipo Mov. deve ser igual a TB")
		Return (.F.)
	Else
		Return(.T.)
	Endif
	
return