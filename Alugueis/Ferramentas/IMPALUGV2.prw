#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPALUGV2	   ºAutor  ³Rafael Silvestrim    º Data ³15/05/2019     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMPALUGV2	 - Rotina de inclusão de titulos automáticos - Alugueis º±±
º±±																				º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPALUG()

	Private cFile	:= ""
	Private lVal	:= .F.

		cFile := cGetFile( "(*.TXT) |*.TXT|","Selecione o arquivo a importar ",," S:\Outros",.T.,48,.F.)

		If !File(cFile)
			MsgInfo("Operação cancelada ou arquivo inválido. Verifique.")
			Return(.F.)
		else			
				Processa({||LeArqs()},"Lendo Arquivo " + cFile,"Aguarde")
		EndIf                                                                  

Return

Static Function LeArqs()
	
	Local nCont 	:= 1
	Local nContS	:= 0
	Local nContE	:= 0
	Local cLinha 	:= ""
	Local nHdI		:= 0
	Local nTamArq	:= 0
	Local nTamLinha := 0
	Local cTab		:= "" //VARIAVEL DAS TABELAS
	Local ccFilial	:= ""
	Local cPrefixo	:= ""
	Local cParcela	:= ""
	Local cTipo 	:= ""
	Local cFornec	:= ""
	Local cLoja		:= ""
	Local dEmissa
	Local dVencto
	Local nValor	:= ""
	Local cHist		:= ""
	Local cNatur	:= ""
	Local cCcusto	:= "" 
 	Local cTplanc 	:= ""
 	Local dVencReal 
 	Local cNumi 	:= ""
 	Local cRef  
 	Local cRelat	:= ""
	Local cPagto	:= "" 
	Local aGerar 	:= {}
	Local aBaixa	:= {}
	Local nTotAbat	:= 0
	
	Private aLogOk	:= {}
	Private aLogErr	:= {}
	Private cTitulo	:= ""
	Private lOk		:= .T.

	lMsErroAuto := .F.
	
	nHdI := FOpen(cFile,0)

	FSEEK(nHdI,0,0)
	nTamArq := FSEEK(nHdI,0,2)
	FSEEK(nHdI,0,0)
	FCLOSE(nHdI)

	FT_FUSE(cFile)	//Abre o Arquivo
	FT_FGOTOP() 	//Posiciona na primeira linha do arquivo
	nTamLinha := Len(FT_FREADLN()) //verifica tamanho linha
	FT_FGOTOP()
	nLinhas := FT_FLASTREC() //Quantidade de linhas no arquivo

	cLinha := Alltrim(FT_FREADLN())

	ProcRegua(nLinhas)

	While !FT_FEOF()
	
	If nCont > nLinhas
		Exit
	EndIF

	cLinha := Alltrim(FT_FREADLN())
	nRecno := FT_FRECNO() // Retorna a linha corrente

	If !Empty(cLinha)

		NextNum()

		If Empty(Alltrim(cTitulo))
			cTitulo := "CON000001"
		Endif

		ccFilial 	:= Substr(cLinha,1,6)  
		cPrefixo	:= Substr(cLinha,8,3) 
		cTplanc 	:= Substr(cLinha,12,1)  //combobox
		cParcela	:= "   "  
		cTipo		:= Substr(cLinha,14,3) 
		cFornec		:= Substr(cLinha,18,6)
		cLoja		:= Substr(cLinha,25,2) 
		dEmissa		:= Substr(cLinha,28,10)
		dVencto		:= Substr(cLinha,39,10)
		dVencReal 	:= Substr(cLinha,50,10)  
		nValor		:= Val(Substr(cLinha,61,15))
		cHist		:= Substr(cLinha,77,40)
		cNatur		:= Substr(cLinha,118,7)
		cCcusto		:= Substr(cLinha,126,16)
		cNumi 		:= Substr(cLinha,143,40)  //texto
		cRef 		:= Substr(cLinha,184,6) // Mes/ano 
		cRelat 		:= Substr(cLinha,191,30) // Cons. padrão 
		cPagto		:= Substr(cLinha,222,16) 

		cFornec := StrZero(Val(Alltrim(cFornec)),6)

		IncProc("Incluíndo Título: "+Alltrim(cTitulo))

		DbSelectArea("SA2")
		DbSetOrder(1)

		lOk := .T.

		IF SA2->(DbSeek(xFilial("SA2")+cFornec+cLoja))
			cNomeFor := SA2->A2_NOME
		Else
			MsgAlert("Fornecedor "+ cFornec +" não encontrado.","Atenção")
			AADD(aLogErr,{ccFilial,cPrefixo,cTipo,cFornec,cLoja,dEmissa,dVencto,cValtoChar(nValor),cHist,cNatur})
			nContE++
			lOk := .F.
		Endif

		dbCloseArea()

		If lOk 

			DbSelectArea("SE2")
			DbSetOrder(24)

			RecLock("SE2",.T.)
			SE2->E2_FILIAL		:= ccFilial
			SE2->E2_PREFIXO		:= cPrefixo
			SE2->E2_TIPO	 	:= cTipo
			SE2->E2_NUM			:= cTitulo
			SE2->E2_PARCELA		:= cParcela
			SE2->E2_FORNECE		:= cFornec
			SE2->E2_LOJA		:= cLoja
			SE2->E2_NOMFOR		:= cNomeFor
			SE2->E2_NATUREZ		:= cNatur
			SE2->E2_EMISSAO		:= CTOD(dEmissa)
			SE2->E2_EMIS1		:= CTOD(dEmissa)
			SE2->E2_VENCTO		:= CTOD(dVencto)
			SE2->E2_VENCREA		:= CTOD(dVencto)
			SE2->E2_VENCORI		:= CTOD(dVencto)
			SE2->E2_VALOR		:= nValor
			SE2->E2_SALDO		:= nValor
			SE2->E2_VLCRUZ		:= nValor
			SE2->E2_MOEDA		:= 1
			SE2->E2_ORIGEM		:= 'FINA050'
			SE2->E2_CCD			:= cCcusto
			SE2->E2_HIST		:= cHist
			SE2->E2_RATEIO		:= 'N'
			SE2->E2_OCORREN		:= '01'
			SE2->E2_FLUXO		:= 'S'
			SE2->E2_MULTNAT		:= '2'
//			SE2->E2_PROJMPS		:= 'S'
			SE2->E2_MODSPB		:= '1'
			SE2->E2_FILORIG		:= ccFilial
			SE2->E2_PRETPIS		:= '1'
			SE2->E2_PRETCOF		:= '1'
//			SE2->E2_PRETCLS		:= '1'
//			SE2->E2_BASECOF		:= nValor
//			SE2->E2_BASEPIS		:= nValor
//			SE2->E2_BASECLS		:= nValor
			SE2->E2_MDRTISS		:= '1'
			SE2->E2_FRETISS		:= '1'
//			SE2->E2_APLVMN		:= '1'
			SE2->E2_PRETIRF		:= '1'
//			SE2->E2_BASEISS		:= nValor
//			SE2->E2_BASEIRF		:= nValor
			SE2->E2_DATAAGE		:= CTOD(dVencto)
			SE2->E2_TEMDOCS		:= '2'
			SE2->E2_STATLIB		:= '01'
//			SE2->E2_BASEINS		:= nValor
			SE2->E2_RATFIN		:= '2'
			SE2->E2_XNUM		:= cTitulo
			SE2->E2_XUSERLI		:= cUserName
			SE2->E2_XHIST		:= cHist
			SE2->E2_XAUTOMA 	:= 'S'
			SE2->E2_VENCREA     := CTOD(dVencReal)
			SE2->E2_XTIPO		:= cTplanc
			SE2->E2_NUMI		:= cNumi 
			SE2->E2_XDTR		:= cRef
			SE2->E2_XREL		:= cRelat
			SE2->E2_XPAG		:= cPagto
			SE2->(MsUnlock())
nContS++
			dbCloseArea()

		EndIf
		
	Endif
		
	FT_FSKIP()
	nCont++

	EndDo

	If Len(aLogErr) > 0
		LOGERRO()
	Endif
			
	MsgAlert("Processamento efetuado com sucesso. Titulos lançados: " + cValtoChar(nContS) + " | Titulos com erro: " + cValtochar(nContE) + ".","Sucesso")
		
	FT_FUSE()
	fClose(nHdI)

Return

Static Function NextNum() //Gera novo titulo de acordo com os parâmetros

	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""

		cQuery	:= "SELECT MAX(E2_NUM) AS MAXCODIGO		" 		+ CRLF
		cQuery	+= "FROM " + RetSQLName("SE2") + " SE2	"	 	+ CRLF
		cQuery	+= "WHERE SE2.E2_XAUTOMA = 'S'	"		 		+ CRLF

		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(dbGoTop())

		cTitulo := SUBSTR((cAlias)->MAXCODIGO,4,9)

		If !Empty(Alltrim(cTitulo))

			cTitulo := Val(cTitulo)	+ 1

			cTitulo :=  "CON" + STRZERO(cTitulo, 6, 0)

		Endif

Return(cTitulo)
