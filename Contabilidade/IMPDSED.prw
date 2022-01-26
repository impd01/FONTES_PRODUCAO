#include "totvs.ch"

User Function IMPDSED()

	Local cArq		:= "c:\totvs\natureza.csv"
	Local cLinha	:= ""
	Local aCampos	:= {}
	Local aDados	:= {}
	 
	Private aErro := {}
	 
	If !File(cArq)
		MsgStop("O arquivo " + cArq + " n�o foi encontrado. A importa��o ser� abortada!","[AEST901] - ATENCAO")
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
	 
	ApMsgInfo("Atualiza��o das Naturezas conclu�da com sucesso!","[IMPDSED] - SUCESSO")
 
Return