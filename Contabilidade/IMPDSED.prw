#include "totvs.ch"

User Function IMPDSED()

	Local cArq		:= "c:\totvs\natureza.csv"
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
	 
			dbSelectArea("SED")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SED")+aDados[i,1])
				Reclock("SED",.F.)
				
					SED->ED_CONTA := aDados[i,3]
	
				SED->(MsUnlock())
			EndIf
		Next i
	End Transaction
	 
	FT_FUSE()
	 
	ApMsgInfo("Atualização das Naturezas concluída com sucesso!","[IMPDSED] - SUCESSO")
 
Return