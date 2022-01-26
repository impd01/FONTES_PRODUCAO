#include 'protheus.ch'
#include 'parmtype.ch'

User function GERADIRF()

	Private cFile		:= ""
	Private lVal		:= .F.
	Private aCols		:= {}
	Private aGera		:= {}
	Private aErro		:= {}

		cFile := cGetFile( "(*.TXT) |*.TXT|","Selecione o arquivo a importar ",,"S:\Outros",.T.,48,.F.)

		If !File(cFile)
			MsgInfo( "Operação cancelada ou arquivo inválido. Verifique.")
			Return(.F.)
		else			
				Processa({||LeArqs()},"Lendo Arquivo " + cFile,"Aguarde")
		EndIf                                                                  

return

Static Function LeArqs()

	Local nCont 	:= 1
	Local cLinha 	:= ""
	Local nHdI		:= 0
	Local nTamArq	:= 0
	Local nTamLinha := 0
	Local cTab		:= "" //VARIAVEL DAS TABELAS
	Local cNome		:= ""
	Local cCpf		:= ""
	Local cMes		:= ""
	Local cValor	:= ""
	Local cIrrf		:= ""
	Local cJan		:= "000"
	Local cFev		:= "000"
	Local cMar		:= "000"
	Local cAbr		:= "000"
	Local cMai		:= "000"
	Local cJun		:= "000"
	Local cJul		:= "000"
	Local cAgo		:= "000"
	Local cSet		:= "000"
	Local cOut		:= "000"
	Local cNov		:= "000"
	Local cDez		:= "000"
	Local cJanIr	:= "000"
	Local cFevIr	:= "000"
	Local cMarIr	:= "000"
	Local cAbrIr	:= "000"
	Local cMaiIr	:= "000"
	Local cJunIr	:= "000"
	Local cJulIr	:= "000"
	Local cAgoIr	:= "000"
	Local cSetIr	:= "000"
	Local cOutIr	:= "000"
	Local cNovIr	:= "000"
	Local cDezIr	:= "000"
	Local cCpfAnt	:= ""
	
	Private cMes	:= ""

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
	
	cJan		:= "000"
	cFev		:= "000"
	cMar		:= "000"
	cAbr		:= "000"
	cMai		:= "000"
	cJun		:= "000"
	cJul		:= "000"
	cAgo		:= "000"
	cSet		:= "000"
	cOut		:= "000"
	cNov		:= "000"
	cDez		:= "000"
	cJanIr		:= "000"
	cFevIr		:= "000"
	cMarIr		:= "000"
	cAbrIr		:= "000"
	cMaiIr		:= "000"
	cJunIr		:= "000"
	cJulIr		:= "000"
	cAgoIr		:= "000"
	cSetIr		:= "000"
	cOutIr		:= "000"
	cNovIr		:= "000"
	cDezIr		:= "000"
	cIrrf		:= ""
	cValor		:= ""
	
		If nCont > nLinhas
			Exit
		EndIF

		cLinha := Alltrim(FT_FREADLN())
		nRecno := FT_FRECNO() // Retorna a linha corrente

		If !Empty(cLinha)

				cNome	 	:= UPPER(NoAcento(Alltrim(Substr(cLinha,1,80))))
				cCpf		:= Alltrim(Substr(cLinha,82,15))
				cMes		:= Alltrim(Substr(cLinha,98,15))
				cValor		:= Alltrim(Substr(cLinha,114,15))
				cIrrf		:= Alltrim(Substr(cLinha,130,15))

				IncProc("Gerando DIRF para o CPF: " + cCpf)

				cValor := Val(cValor)

				cIrrf := Val(cIrrf)

				cValor := STRTRAN(Alltrim(cValtoChar(TRANSFORM(cValor, "@E 9,999,999.99"))),",","")

				cIrrf := Alltrim(cValtoChar(TRANSFORM(cIrrf, "@E 9,999,999.99")))

				cNome		:= STRTRAN(cNome,"(","")
				cNome		:= STRTRAN(cNome,")","")
				cNome		:= STRTRAN(cNome,".","")
				cNome		:= STRTRAN(cNome,",","")

				cValor		:= STRTRAN(cValor,".","")
				cValor		:= STRTRAN(cValor,",","")

				cIrrf		:= STRTRAN(cIrrf,".","")
				cIrrf		:= STRTRAN(cIrrf,",","")

				cCpf := STRTRAN(cCpf,"-","")
				cCpf := STRTRAN(cCpf,".","")
				cCpf := STRTRAN(cCpf,"/","")
				cCpf := STRTRAN(cCpf,"*","")

				If !CGC(cCpf) .Or. Empty(cCpf)
				AADD(aErro,{cNome,cCpf,cMes,})
					FT_FSKIP()
				Endif

				If Empty(Alltrim(cCpfAnt))
					cCpfAnt := cCpf
				Endif

				If cIrrf == '0' .Or. Empty(Alltrim(cIrrf))
					cIrrf := '000'
				Endif

					If 	cMes = "JANEIRO"
						cJan := cValor
						cJanIr := cIrrf
					Elseif cMes = "FEVEREIRO"
						cFev := cValor
						cFevIr := cIrrf
					Elseif cMes = "MARÇO"
						cMar := cValor
						cMarIr := cIrrf
					Elseif cMes = "ABRIL"
						cAbr := cValor
						cAbrIr := cIrrf
					ElseIf cMes = "MAIO"
						cMai := cValor
						cMaiIr := cIrrf
					ElseIf cMes = "JUNHO"
						cJun := cValor
						cJunIr := cIrrf
					ElseIf cMes = "JULHO"
						cJul := cValor
						cJulIr := cIrrf
					ElseIf cMes = "AGOSTO"
						cAgo := cValor
						cAgoIr := cIrrf
					ElseIf cMes = "SETEMBRO"
						cSet := cValor
						cSetIr := cIrrf
					ElseIf cMes = "OUTUBRO"
						cOut := cValor
						cOutIr := cIrrf
					ElseIf cMes = "NOVEMBRO"
						cNov := cValor
						cNovIr := cIrrf
					ElseIf cMes = "DEZEMBRO"
						cDez := cValor
						cDezIr := cIrrf
					Endif

				AADD(aCols,{cNome,cCpf,cMes,cJan,cJanIr,cFev,cFevIr,cMar,cMarIr,cAbr,cAbrIr,cMai,cMaiIr,cJun,cJunIr,cJul,cJulIr,cAgo,cAgoIr,cSet,cSetIr,cOut,cOutIr,cNov,cNovIr,cDez,cDezIr})

        EndIf

		FT_FSKIP()
		nCont++

	EndDo
	
	FT_FUSE()
	fClose(nHdI)

	GERARQ()
	GERARQER()

	MsgAlert("Processamento efetuado com sucesso.","Sucesso")

Return()

Static Function GERARQ()

	Local cDir    := "C:\Contabilidade\"
	Local cArq    := cUserName + DTOS(Date())+"_" + StrTran(Time(),":","") + ".txt"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FCreate - É o comando responsavel pela criação do arquivo.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nHandle := FCreate(cDir+cArq)
	Local nCount  := 0
	Local cCpfAnt := ""
	Local cMesAnt := ""
	Local nCont	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nHandle - A função FCreate retorna o handle, que indica se foi possível ou não criar o arquivo. Se o valor for     ³
	//³menor que zero, não foi possível criar o arquivo.                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nHandle < 0
			MsgAlert("Erro durante criação do arquivo.")
		Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄzÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			FWrite(nHandle,"DIRF|2018|2017|N||Q84FV63|"+ CRLF)
			FWrite(nHandle,"RESPO|02253296899|JOSE MARIO DA SILVA|11|35773815|||CONTABILIDADE@IMPD.ORG.BR|"+ CRLF)
			FWrite(nHandle,"DECPJ|02415583000147|IGREJA MUNDIAL DO PODER DE DEUS|0|08874024614|N|N|N|N|S|N|N|N||"+ CRLF)
			FWrite(nHandle,"IDREC|0588|"+ CRLF)

		For nx := 1 to len(aCols)

			If aCols[nx][2] == cCpfAnt
				If aCols[nx][3] == 'JANEIRO'
					IF cMesAnt == aCols[nx][3]
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][3] := cValtoChar(Val(aGera[nCont][3]) + Val(aCols[nx][4]))
						aGera[nCont][4] := cValtoChar(Val(aGera[nCont][4]) + Val(aCols[nx][5]))
					Else
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][3] := aCols[nx][4]
						aGera[nCont][4] := aCols[nx][5]
					Endif
				Elseif aCols[nx][3] == 'FEVEREIRO'
					IF cMesAnt == aCols[nx][3]
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][5] := cValtoChar(Val(aGera[nCont][5]) + Val(aCols[nx][6]))
						aGera[nCont][6] := cValtoChar(Val(aGera[nCont][6]) + Val(aCols[nx][7]))
					Else
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][5] := aCols[nx][6]
						aGera[nCont][6] := aCols[nx][7]
					Endif
				Elseif aCols[nx][3] == 'MARÇO'
					IF cMesAnt == aCols[nx][3]
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][7] := cValtoChar(Val(aGera[nCont][7]) + Val(aCols[nx][8]))
						aGera[nCont][8] := cValtoChar(Val(aGera[nCont][8]) + Val(aCols[nx][9]))
					Else
						aGera[nCont][1] := aCols[nx][1]
						aGera[nCont][2] := aCols[nx][2]
						aGera[nCont][7] := aCols[nx][8]
						aGera[nCont][8] := aCols[nx][9]
					Endif
				Elseif aCols[nx][3] == 'ABRIL'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][9] := cValtoChar(Val(aGera[nCont][9]) + Val(aCols[nx][10]))
					aGera[nCont][10] := cValtoChar(Val(aGera[nCont][10]) + Val(aCols[nx][11]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][9] := aCols[nx][10]
					aGera[nCont][10] := aCols[nx][11]
					Endif
				Elseif aCols[nx][3] == 'MAIO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][11] := cValtoChar(Val(aGera[nCont][11]) + Val(aCols[nx][12]))
					aGera[nCont][12] := cValtoChar(Val(aGera[nCont][12]) + Val(aCols[nx][13]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][11] := aCols[nx][12]
					aGera[nCont][12] := aCols[nx][13]
					Endif
				Elseif aCols[nx][3] == 'JUNHO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][13] := cValtoChar(Val(aGera[nCont][13]) + Val(aCols[nx][14]))
					aGera[nCont][14] := cValtoChar(Val(aGera[nCont][14]) + Val(aCols[nx][15]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][13] := aCols[nx][14]
					aGera[nCont][14] := aCols[nx][15]
					Endif
				Elseif aCols[nx][3] == 'JULHO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][15] := cValtoChar(Val(aGera[nCont][15]) + Val(aCols[nx][16]))
					aGera[nCont][16] := cValtoChar(Val(aGera[nCont][16]) + Val(aCols[nx][17]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][15] := aCols[nx][16]
					aGera[nCont][16] := aCols[nx][17]
					Endif
				Elseif aCols[nx][3] == 'AGOSTO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][17] := cValtoChar(Val(aGera[nCont][17]) + Val(aCols[nx][18]))
					aGera[nCont][18] := cValtoChar(Val(aGera[nCont][19]) + Val(aCols[nx][19]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][17] := aCols[nx][18]
					aGera[nCont][18] := aCols[nx][19]
					Endif
				Elseif aCols[nx][3] == 'SETEMBRO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][19] := cValtoChar(Val(aGera[nCont][19]) + Val(aCols[nx][20]))
					aGera[nCont][20] := cValtoChar(Val(aGera[nCont][20]) + Val(aCols[nx][21]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][19] := aCols[nx][20]
					aGera[nCont][20] := aCols[nx][21]
					Endif
				Elseif aCols[nx][3] == 'OUTUBRO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][21] := cValtoChar(Val(aGera[nCont][21]) + Val(aCols[nx][22]))
					aGera[nCont][22] := cValtoChar(Val(aGera[nCont][22]) + Val(aCols[nx][23]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][21] := aCols[nx][22]
					aGera[nCont][22] := aCols[nx][23]
					Endif
				Elseif aCols[nx][3] == 'NOVEMBRO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][23] := cValtoChar(Val(aGera[nCont][23]) + Val(aCols[nx][24]))
					aGera[nCont][24] := cValtoChar(Val(aGera[nCont][24]) + Val(aCols[nx][25]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][23] := aCols[nx][24]
					aGera[nCont][24] := aCols[nx][25]
					Endif
				Elseif aCols[nx][3] == 'DEZEMBRO'
					IF cMesAnt == aCols[nx][3]
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][25] := cValtoChar(Val(aGera[nCont][25]) + Val(aCols[nx][26]))
					aGera[nCont][26] := cValtoChar(Val(aGera[nCont][26]) + Val(aCols[nx][27]))
					Else
					aGera[nCont][1] := aCols[nx][1]
					aGera[nCont][2] := aCols[nx][2]
					aGera[nCont][25] := aCols[nx][26]
					aGera[nCont][26] := aCols[nx][27]
					Endif
				Endif
			Else

			AADD(aGera,{aCols[nx][1],aCols[nx][2],aCols[nx][4],aCols[nx][5],aCols[nx][6],aCols[nx][7],aCols[nx][8],aCols[nx][9],aCols[nx][10],aCols[nx][11],aCols[nx][12],aCols[nx][13],aCols[nx][14],;
			aCols[nx][15],aCols[nx][16],aCols[nx][17],aCols[nx][18],aCols[nx][19],aCols[nx][20],aCols[nx][21],aCols[nx][22],aCols[nx][23],aCols[nx][24],aCols[nx][25],aCols[nx][26],aCols[nx][27]})			
			nCont++
			Endif

			cCpfAnt := aCols[nx][2]
			cMesAnt := aCols[nx][3]
			
		Next nx
			
			aSort(aGera,,,{|x,y| x[2] < y[2] })
			
			For nz := 1 To Len(aGera)		
				FWrite(nHandle, "BPFDEC|"+Alltrim(aGera[nz][2])+ "|" + aGera[nz][1] + "||S|S|"+ CRLF)
				FWrite(nHandle, "RTRT|"+aGera[nz][3]+"|"+aGera[nz][5]+"|"+aGera[nz][7]+"|"+aGera[nz][9]+"|"+aGera[nz][11]+"|"+aGera[nz][13]+"|"+aGera[nz][15]+;
				"|"+aGera[nz][17]+"|"+aGera[nz][19]+"|"+aGera[nz][21]+"|"+aGera[nz][23]+"|"+aGera[nz][25]+"||"+ CRLF)
				FWrite(nHandle, "RTIRF|"+aGera[nz][4]+"|"+aGera[nz][6]+"|"+aGera[nz][8]+"|"+aGera[nz][10]+"|"+aGera[nz][12]+"|"+aGera[nz][14]+"|"+aGera[nz][16]+;
				"|"+aGera[nz][18]+"|"+aGera[nz][20]+"|"+aGera[nz][22]+"|"+aGera[nz][24]+"|"+aGera[nz][26]+"||"+ CRLF)
			Next nz
				FWrite(nHandle, "FIMDIRF|"+ CRLF)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FClose(nHandle)
		EndIf

Return

Static Function GERARQER()

	Local cDir    := "C:\Contabilidade\"
	Local cArq    := "ERRO_"+cUserName + DTOS(Date())+"_" + StrTran(Time(),":","") + ".txt"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FCreate - É o comando responsavel pela criação do arquivo.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nHandle := FCreate(cDir+cArq)
	Local nCount  := 0
	Local cCpfAnt := ""
	Local nCont	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nHandle - A função FCreate retorna o handle, que indica se foi possível ou não criar o arquivo. Se o valor for     ³
	//³menor que zero, não foi possível criar o arquivo.                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nHandle < 0
			MsgAlert("Erro durante criação do arquivo.")
		Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄzÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AADD(aErro,{cNome,cCpf,cMes,})
		For nx := 1 to len(aErro)
			FWrite(nHandle,Alltrim(aErro[nx][1])+ " | " + Alltrim(aErro[nx][2])+ " | " + Alltrim(aErro[nx][3])+ " | " + "<------ CPF INVÁLIDO "+CRLF)
		Next nx
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FClose(nHandle)
		EndIf

Return
