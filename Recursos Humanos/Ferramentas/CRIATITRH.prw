#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User Function CRUATITRH()

	Private cFile	:= ""
	Private lVal	:= .F.

		cFile := cGetFile( "(*.TXT) |*.TXT|","Selecione o arquivo a importar ",,"S:\Outros",.T.,48,.F.)

		If !File(cFile)
			MsgInfo( "OperaГЦo cancelada ou arquivo invАlido. Verifique.")
			Return(.F.)
		else			
				Processa({||LeArqs()},"Lendo Arquivo" + cFile,"Aguarde")
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
	Local cDirf		:= ""
	Local cRetenc	:= ""
	Local cBanco	:= ""
	Local cAgencia	:= ""
	Local cConta	:= ""
	Local dDtBx		:= ""
	Local cMotBx	:= ""
	Local nMulta	:= 0
	Local nJuros	:= 0
	Local aGerar 	:= {}
	Local aBaixa	:= {}
	Local nTotAbat	:= 0
	
	Private aLogOk		:= {}
	Private aLogErr		:= {}
	Private aTitulos	:= {}
	Private cTitulo		:= ""
	Private lOk			:= .T.
	Private cBanco		:= "237"
	Private cAgencia	:= "0098 "
	Private cConta		:= "0098002   "

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
					cTitulo := "AUT000001"
				Endif

				ccFilial 	:= xFilial("SE2")
				cPrefixo	:= " "
				cParcela	:= "   "
				cTipo		:= "FOL"
				cFornec		:= "003728"
				cLoja		:= "01"
				dEmissa		:= Substr(cLinha,98,10)
				dVencto		:= Substr(cLinha,98,10)
				nValor		:= Val(Substr(cLinha,82,15))
				cHist		:= Substr(cLinha,1,50)
				cNatur		:= "1060003   "
				cCcusto		:= "10301010010001"
				cBanco		:= "237"
				cAgencia	:= "0098 "
				cConta		:= "	   "
				dDtBx		:= Substr(cLinha,98,10)
				cMotBx		:= "DEB"
				
				nMulta		:= 0
				nJuros		:= 0
 
				IncProc("IncluМndo TМtulo: "+Alltrim(cTitulo))

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
					SE2->E2_NOMFOR		:= "ADIANTAMENTO SALARIO"
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
					SE2->E2_PROJMPS		:= 'S'
					SE2->E2_MODSPB		:= '1'
					SE2->E2_FILORIG		:= ccFilial
					SE2->E2_PRETPIS		:= '1'
					SE2->E2_PRETCOF		:= '1'
					SE2->E2_PRETCLS		:= '1'
					SE2->E2_BASECOF		:= nValor
					SE2->E2_BASEPIS		:= nValor
					SE2->E2_BASECLS		:= nValor
					SE2->E2_MDRTISS		:= '1'
					SE2->E2_FRETISS		:= '1'
					SE2->E2_APLVMN		:= '1'
					SE2->E2_PRETIRF		:= '1'
					SE2->E2_BASEISS		:= nValor
					SE2->E2_BASEIRF		:= nValor
					SE2->E2_DATAAGE		:= CTOD(dVencto)
					SE2->E2_TEMDOCS		:= '2'
					SE2->E2_STATLIB		:= '01'
					SE2->E2_BASEINS		:= nValor
					SE2->E2_RATFIN		:= '2'
					SE2->E2_XNUM		:= cTitulo
					SE2->E2_XUSERLI		:= cUserName
					SE2->E2_XHIST		:= cHist
					SE2->E2_XAUTOMA 	:= 'S'
					SE2->(MsUnlock())

				FT_FSKIP()
				nCont++
/*				
				IF SE2->(DbSeek(cTitulo+cParcela+cFornec+cLoja)) .And. !EMPTY(Alltrim(cMotBx))

					IncProc("Baixando TМtulo: "+Alltrim(SE2->E2_NUM))  
		
					aBaixa := {}

					lMsErroAuto := .F.

					AADD(aBaixa, {"E2_FILIAL" 		, 	ccFilial		  	, 	Nil})
					AADD(aBaixa, {"E2_PREFIXO" 		, 	SE2->E2_PREFIXO	 	, 	Nil})
					AADD(aBaixa, {"E2_NUM" 			, 	SE2->E2_NUM 		, 	Nil})
					AADD(aBaixa, {"E2_PARCELA" 		, 	SE2->E2_PARCELA 	, 	Nil})
					AADD(aBaixa, {"E2_TIPO" 		, 	SE2->E2_TIPO 		, 	Nil})
					AADD(aBaixa, {"E2_FORNECE" 		, 	SE2->E2_FORNECE 	, 	Nil})
					AADD(aBaixa, {"E2_LOJA" 		, 	SE2->E2_LOJA 		, 	Nil})
					AADD(aBaixa, {"AUTMOTBX" 		, 	"DEB" 				, 	Nil})
					AADD(aBaixa, {"AUTBANCO" 		, 	cBanco				, 	Nil})
					AADD(aBaixa, {"AUTAGENCIA" 		, 	cAgencia			, 	Nil})
					AADD(aBaixa, {"AUTCONTA" 		, 	cConta				, 	Nil})
					AADD(aBaixa, {"AUTMULTA" 		, 	nMulta				, 	Nil})
					AADD(aBaixa, {"AUTJUROS" 		, 	nJuros				, 	Nil})	
					AADD(aBaixa, {"AUTDTBAIXA" 		, 	CTOD(dDtBx)			, 	Nil})
					AADD(aBaixa, {"AUTDTCREDITO"	, 	CTOD(dDtBx)			, 	Nil}) 
					AADD(aBaixa, {"AUTHIST" 		, 	cHist 				, 	Nil})					

					MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)

					If lMsErroAuto
						MOSTRAERRO()
						FT_FSKIP() 
					Endif

				Endif

			FT_FSKIP() 
*/
		Endif

	EndDo

			MsgAlert("Processamento efetuado com sucesso. Titulos lanГados: " + cValtoChar(nContS) + " | Titulos com erro: " + cValtochar(nContE) + ".","Sucesso")

			FT_FUSE()
			fClose(nHdI)

Return

Static Function LOGERRO()

		Local cDir    := "C:\ImportaГЦo de Arquivos\Erro\"
		Local cArq    := cUserName + DTOS(Date())+"_" + StrTran(Time(),":","") + ".txt"
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁFCreate - и o comando responsavel pela criaГЦo do arquivo.                                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Local nHandle := FCreate(cDir+cArq)
		Local nCount  := 0

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁnHandle - A funГЦo FCreate retorna o handle, que indica se foi possМvel ou nЦo criar o arquivo. Se o valor for     Ё
		//Ёmenor que zero, nЦo foi possМvel criar o arquivo.                                                                  Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If nHandle < 0
			MsgAlert("Erro durante criaГЦo do arquivo.")
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁFWrite - Comando reponsavel pela gravaГЦo do texto.                                                                Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			For nz := 1 to len(aLogErr)
				FWrite(nHandle, aLogErr[nz][1] + " " + aLogErr[nz][2] + " " + aLogErr[nz][3] + " " + aLogErr[nz][4] + " " + aLogErr[nz][5] + " " + ;
				aLogErr[nz][6] + " " + aLogErr[nz][7] + " " + aLogErr[nz][8] + " " + aLogErr[nz][9] + " " + aLogErr[nz][10] + " " +  PADL(cValtochar(aLogErr[nz][11]),10," ") + " " + ;
				aLogErr[nz][12] + " " + CRLF)
			Next nz
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁFClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			FClose(nHandle)
		EndIf

Return

Static Function NextNum() //Gera novo titulo de acordo com os parБmetros

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

			cTitulo :=  "AUT" + STRZERO(cTitulo, 6, 0)

		Endif

Return(cTitulo)
