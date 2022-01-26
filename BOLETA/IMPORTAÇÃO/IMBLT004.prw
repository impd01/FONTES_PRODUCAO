#include "totvs.ch"
#include "protheus.ch"

User Function IMBLT004()

	Local cLinha  := ""
	Local lPrim   := .T.
	Local aDados  := {}
	Local cDir	  := "C:\Boleta\"

	Private cArq    := "_Lancamentos_20180409.txt"
	Private aErro 	:= {}
/*	
	If !File(cDir+cArq)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf
*/

	FT_FUSE(cDir+"*.txt*")
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

			AADD(aDados,{cLinha})

		FT_FSKIP()

	EndDo

	For nx := 1 to Len(aDados)

		lMsErroAuto := .F.

		cCcusto		:= ""
		cNomeIg		:= ""
		cCodFil		:= Substr(aDados[nx][1],1,6)
		cTplanc		:= Substr(aDados[nx][1],7,2)
		cNaturez	:= Substr(aDados[nx][1],9,7)
		nValor		:= Val(Substr(aDados[nx][1],16,18))
		dData		:= STOD(Substr(aDados[nx][1],34,8))
		cIgreja		:= Substr(aDados[nx][1],42,6)
		cTpPag		:= Substr(aDados[nx][1],48,2)
		cBanco		:= StrZero(Val(Substr(aDados[nx][1],50,3)),3)
		cAgencia	:= StrZero(Val(Substr(aDados[nx][1],53,6)),4)
		cConta		:= StrZero(Val(Substr(aDados[nx][1],59,15)),7)
		cCpf		:= Substr(aDados[nx][1],74,11)
		cHoraRe		:= Substr(aDados[nx][1],85,4)
		cBoleta		:= Substr(aDados[nx][1],89,10)

		DbSelectArea("SA1")
		DbSetOrder(1)

		If SA1->(DbSeek(xFilial("SA1")+cIgreja+"01"))
			cCcusto	:= SA1->A1_XCC
			cNomeIg	:= SA1->A1_NOME
		Endif

		RecLock( "SZ5", .T. )
		SZ5->Z5_FILIAL	:= cCodFil
		SZ5->Z5_DATA 	:= dData
		SZ5->Z5_MOEDA	:= 'M1'
		SZ5->Z5_VALOR	:= nValor
		SZ5->Z5_NATUREZ	:= '10001
		SZ5->Z5_BANCO	:= cBanco
		SZ5->Z5_AGENCIA	:= cAgencia
		SZ5->Z5_CONTA	:= cConta
		SZ5->Z5_VENCTO	:= dData
		SZ5->Z5_DTDISPO	:= dData
		SZ5->Z5_DTDIGIT	:= dData
		SZ5->Z5_RECPAG	:= 'R'
		SZ5->Z5_RATEIO	:= 'N'
		SZ5->Z5_ORIGEM	:= 'FINA100'
		SZ5->Z5_HISTOR	:= 'BOLETA - MOVIMENTO DE DOAÇÃO - ' + Alltrim(cNomeIg)
		SZ5->Z5_CCUSTO	:= cCcusto
		SZ5->Z5_XTPLNC	:= cTplanc
		SZ5->Z5_XIGREJA	:= cIgreja
		SZ5->Z5_XTPPGTO	:= cTpPag
		SZ5->Z5_XHREUNI	:= cHoraRe
		SZ5->Z5_XARQUIV	:= cArq
		SZ5->Z5_XDTIMPO	:= Date()
		SZ5->Z5_XHRIMP	:= Time()
		SZ5->Z5_XMAT	:= cCodPast
		SZ5->Z5_CPF		:= cCpf
		SZ5->Z5_BOLETA	:= cBoleta
		SZ5->Z5_STATUS	:= 'I' // I=Importado | P=Processado
		MsUnLock()

	Next nx

	FT_FUSE()

	ApMsgInfo("Importação dos Registros concluída com sucesso!","Sucesso")

Return
