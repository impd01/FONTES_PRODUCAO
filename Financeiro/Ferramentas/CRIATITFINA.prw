#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

user function CRIATITFIN()

	Private cFile	:= ""
	Private lVal	:= .F.

		cFile := cGetFile( "(*.TXT) |*.TXT|","Selecione o arquivo a importar ",,"S:\Outros",.T.,48,.F.)

		If !File(cFile)
			MsgInfo( "OperaГЦo cancelada ou arquivo invАlido. Verifique.")
			Return(.F.)
		else			
				Processa({||LeArqs()},"Lendo Arquivo" + cFile,"Aguarde")
		EndIf                                                                  

return

Static Function LeArqs() 

	Local nCont 	:= 1
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
	Local dVenctoR
	Local cRelat	:= ""
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
	Local cNomeFor	:= ""
	
	Private aLogOk	:= {}
	Private aLogErr	:= {}
	Private aLogInS	:= {}
	Private aLogIne	:= {}
	Private cTitulo	:= ""

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

				ccFilial 	:= Substr(cLinha,1,6)
				cPrefixo	:= ""
				cTitulo		:= Substr(cLinha,15,9)
				cParcela	:= "   "
				cTipo		:= Substr(cLinha,25,3)
				cFornec		:= Substr(cLinha,29,6)
				cLoja		:= Substr(cLinha,36,2)
				cNomeFor	:= Substr(cLinha,40,30)
				cNatur		:= Substr(cLinha,71,7)
				dEmissa		:= Substr(cLinha,79,10)
				dVencto		:= Substr(cLinha,90,10)
				dVenctoR	:= Substr(cLinha,101,10)
				nValor		:= Val(Substr(cLinha,112,15))
				cHist		:= Substr(cLinha,128,80) 
				cCcusto		:= Substr(cLinha,209,16)
				cRelat		:= Substr(cLinha,226,25)
				cBanco		:= Substr(cLinha,278,4)
				cAgencia	:= Substr(cLinha,282,6)
				cConta		:= Substr(cLinha,288,11)
				dDtBx		:= Substr(cLinha,299,11)
				cMotBx		:= Substr(cLinha,310,4)

				IF Empty(Alltrim(cTitulo))
					cTitulo := GETSXENUM("SE2","E2_NUM")
				Else
					cTitulo := StrZero(Val(Alltrim(cTitulo)),9)
				Endif

				cFornec := StrZero(Val(Alltrim(cFornec)),6)

				IncProc("IncluМndo TМtulo: "+Alltrim(cTitulo))
				
				AaDd(aGerar,{"E2_FILIAL" 		,ccFilial				,Nil})
				AaDd(aGerar,{"E2_PREFIXO"		,cPrefixo   			,Nil})
				AaDd(aGerar,{"E2_NUM"      		,cTitulo		    	,Nil})
				AaDd(aGerar,{"E2_PARCELA"		,cParcela		    	,Nil})
				AaDd(aGerar,{"E2_TIPO"   		,cTipo  				,Nil})
				AaDd(aGerar,{"E2_FORNECE"		,cFornec		 		,Nil})
				AaDd(aGerar,{"E2_LOJA   "		,cLoja			    	,Nil})
				AaDd(aGerar,{"E2_EMISSAO"		,CTOD(dEmissa)			,Nil})
				AaDd(aGerar,{"E2_VENCTO" 		,CTOD(dVencto)			,Nil})
				AaDd(aGerar,{"E2_VENCREA" 		,CTOD(dVencto)			,Nil})
				AaDd(aGerar,{"E2_VALOR" 		,nValor					,Nil})
				AaDd(aGerar,{"E2_HIST"   		,cHist	 				,Nil})
				AaDd(aGerar,{"E2_NATUREZ"		,cNatur 				,Nil})
		
				lMsErroAuto := .F.
		
				MSExecAuto({|x,y| Fina050(x,y)},aGerar,3) //3-Inclusao //5-Exclusao				
/*
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
					SE2->E2_VENCREA		:= CTOD(dVenctoR)
					SE2->E2_VENCORI		:= CTOD(dVencto)
					SE2->E2_VALOR		:= nValor
					SE2->E2_SALDO		:= nValor
					SE2->E2_VLCRUZ		:= nValor
					SE2->E2_MOEDA		:= 1
					SE2->E2_ORIGEM		:= 'EXECAUTO'
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
				SE2->(MsUnlock())
*/						
						If !EMPTY(Alltrim(cMotBx))
															
							IncProc("Baixando TМtulo: "+Alltrim(cTitulo))  

							aBaixa := {}

							lMsErroAuto := .F.

							AADD(aBaixa, {"E2_FILIAL" 		, 	ccFilial		  	, 	Nil})
							AADD(aBaixa, {"E2_PREFIXO" 		, 	cPrefixo		 	, 	Nil})
							AADD(aBaixa, {"E2_NUM" 			, 	cTitulo		 		, 	Nil})
							AADD(aBaixa, {"E2_PARCELA" 		, 	cParcela		 	, 	Nil})
							AADD(aBaixa, {"E2_TIPO" 		, 	cTipo		 		, 	Nil})
							AADD(aBaixa, {"E2_FORNECE" 		, 	cFornec			 	, 	Nil})
							AADD(aBaixa, {"E2_LOJA" 		, 	cLoja		 		, 	Nil})
							AADD(aBaixa, {"AUTMOTBX" 		, 	cMotBx 				, 	Nil})
							AADD(aBaixa, {"AUTBANCO" 		, 	cBanco				, 	Nil})
							AADD(aBaixa, {"AUTAGENCIA" 		, 	cAgencia			, 	Nil})
							AADD(aBaixa, {"AUTCONTA" 		, 	cConta				, 	Nil})
							AADD(aBaixa, {"AUTDTBAIXA" 		, 	CTOD(dDtBx)			, 	Nil}) 
							AADD(aBaixa, {"AUTHIST" 		, 	cHist 				, 	Nil})					

							MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)																
/*																
							If lMsErroAuto
								AADD(aLogInE,{ccFilial,cPrefixo,cTitulo,cParcela,cTipo,cFornec,cLoja,dEmissa,dVencto,cValtoChar(nValor),cHist,cNatur})
								MOSTRAERRO() 
							Else
								AADD(aLogInS,{ccFilial,cPrefixo,cTitulo,cParcela,cTipo,cFornec,cLoja,dEmissa,dVencto,cValtoChar(nValor),cHist,cNatur})
							Endif
*/												            
						Endif  
	 				         	
	        
	    aGerar := {}

        EndIf

		FT_FSKIP()
		nCont++

	EndDo
/*	If Len(aLogOk) > 0	
		LOGSUCESSO()
	Endif
	
	If Len(aLogErr) > 0
		LOGERRO()
	Endif
	
	If Len(aLogInE) > 0
		LOGBAIXAER()
	Endif
	
	If Len(aLogInS) > 0
		LOGBAIXAOK()
	Endif
*/	
	MsgAlert("Processamento efetuado com sucesso.","Sucesso")

	FT_FUSE()
	fClose(nHdI)

Return

Static Function LOGSUCESSO()

			Local cDir    := "C:\ImportaГЦo de Arquivos\InclusЦo\Sucesso\"
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
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддzддддддддддддддды
				For nx := 1 to len(aLogOk)
					FWrite(nHandle, aLogOk[nx][1] + " " + aLogOk[nx][2] + " " + aLogOk[nx][3] + " " + aLogOk[nx][4] + " " + aLogOk[nx][5] + " " + ;
					aLogOk[nx][6] + " " + aLogOk[nx][7] + " " + aLogOk[nx][8] + " " + aLogOk[nx][9] + " " + aLogOk[nx][10] + " " + cValtochar(aLogOk[nx][11]) + " " + ;
					aLogOk[nx][12] + " " + CRLF)
				Next nx
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁFClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				FClose(nHandle)
			EndIf

Return

Static Function LOGERRO()

		Local cDir    := "C:\ImportaГЦo de Arquivos\InclusЦo\Erro\"
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
			For nx := 1 to len(aLogErr)
				FWrite(nHandle, aLogErr[nx][1] + " " + aLogErr[nx][2] + " " + aLogErr[nx][3] + " " + aLogErr[nx][4] + " " + aLogErr[nx][5] + " " + ;
				aLogErr[nx][6] + " " + aLogErr[nx][7] + " " + aLogErr[nx][8] + " " + aLogErr[nx][9] + " " + aLogErr[nx][10] + " " +  PADL(cValtochar(aLogErr[nx][11]),10," ") + " " + ;
				aLogErr[nx][12] + " " + CRLF)
			Next nx
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁFClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			FClose(nHandle)
		EndIf
	
Return

Static Function LOGBAIXAOK()

		Local cDir    := "C:\ImportaГЦo de Arquivos\Baixa\Sucesso\"
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
			For nx := 1 to len(aLogInS)
				FWrite(nHandle, aLogInS[nx][1] + " " + aLogInS[nx][2] + " " + aLogInS[nx][3] + " " + aLogInS[nx][4] + " " + aLogInS[nx][5] + " " + ;
				aLogInS[nx][6] + " " + aLogInS[nx][7] + " " + aLogInS[nx][8] + " " + aLogInS[nx][9] + " " + aLogInS[nx][10] + " " +  PADL(cValtochar(aLogInS[nx][11]),10," ") + " " + ;
				aLogInS[nx][12] + " " + CRLF)
			Next nx
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁFClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			FClose(nHandle)
		EndIf
	
Return

Static Function LOGBAIXAER()

		Local cDir    := "C:\ImportaГЦo de Arquivos\Baixa\Erro\"
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
			For nx := 1 to len(aLogInE)
				FWrite(nHandle, aLogInE[nx][1] + " " + aLogInE[nx][2] + " " + aLogInE[nx][3] + " " + aLogInE[nx][4] + " " + aLogInE[nx][5] + " " + ;
				aLogInE[nx][6] + " " + aLogInE[nx][7] + " " + aLogInE[nx][8] + " " + aLogInE[nx][9] + " " + aLogInE[nx][10] + " " +  PADL(cValtochar(aLogInE[nx][11]),10," ") + " " + ;
				aLogInE[nx][12] + " " + CRLF)
			Next nx
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
