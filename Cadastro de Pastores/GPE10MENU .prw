#Include 'Protheus.ch'

User Function GPE10MENU()

	IF ALLTRIM(FUNNAME())=="GPEA265"
		AAdd( aRotina ,{"Bco de Conhecimento" ,'MsDocument'	,0,4})
		aAdd(aRotina, { "Entrevista", "u_MDGPE02()", 0, 7, 0, Nil })
		aAdd(aRotina, { "Cadastro de Bens", "u_MDGPE01()", 0, 7, 0, Nil })
		aAdd(aRotina, { "Historico Transferncia", "u_MDGPE03()", 0, 7, 0, Nil })
	ENDIF
Return(Nil)


