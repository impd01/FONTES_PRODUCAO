#include "totvs.ch"

User Function IMPDSB1()

	Local cArq		:= "c:\totvs\produtos.csv"
	Local cLinha	:= ""
	Local aCampos	:= {}
	Local aDados	:= {}
	 
	Private aErro := {}
	 
	If !File(cArq)
		MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf
	
	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
	 
		IncProc("Lendo arquivo texto...")
	 
		cLinha := FT_FREADLN()

		AADD(aDados,Separa(cLinha,";",.T.))
	 
		FT_FSKIP()
		
	EndDo
	 
	Begin Transaction
		ProcRegua(Len(aDados))
		For i:=1 to Len(aDados)
	 
			IncProc("Atualizando Naturezas...")
	 
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SB1")+aDados[i,1])
				Reclock("SB1",.F.)
				
					SB1->B1_CONTA := aDados[i,2]
	
				SB1->(MsUnlock())
			EndIf
		Next i
	End Transaction
	 
	FT_FUSE()
	 
	ApMsgInfo("Atualização dos Produtos concluída com sucesso!","[IMPDSB1] - SUCESSO")
 
Return