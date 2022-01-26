#include 'protheus.ch'
#include 'parmtype.ch'

user function GPE11ROT()
local arot:={}
	IF ALLTRIM(FUNNAME())=="GPEA265"
		AAdd( arot ,{"Bco de Conhecimento" ,'MsDocument'	,0,4})
		aAdd(arot, { "Entrevista", "u_MDGPE02()", 0, 7, 0, Nil })
		aAdd(arot, { "Cadastro de Bens", "u_MDGPE01()", 0, 7, 0, Nil })
		aAdd(arot, { "Historico Transferncia", "u_MDGPE03()", 0, 7, 0, Nil })
		//E 11 OU NA 10
		
	ENDIF
	
      aAdd(arot, { "Ficha de Deslg", "U_uIMPDR01()", 0, 7, 0, Nil })
      aAdd(arot, { "Transf. Bip/Pr", "U_uIMPDF02()", 0, 7, 0, Nil })
      aAdd(arot, { "Controle de Deslg", "U_uIMPDF03()", 0, 7, 0, Nil })
      aAdd(arot, { "Autorização P/ Rtva Pr", "U_uIMPDF04()", 0, 7, 0, Nil })
      aAdd(arot, { "Rel. Hist. Tranf.", "U_uIMPDF05()", 0, 7, 0, Nil })
      aAdd(arot, { "Info Pr/Bisp", "U_uIMPDF06()", 0, 7, 0, Nil })
	
Return arot//DERRUBA