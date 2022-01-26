#include 'protheus.ch'
#include 'parmtype.ch'

user function IMPFOR()
	
	Private cFile		:= ""

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
	Local cTipo		:= ""
	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""
	
	
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

				cEnd		:= Alltrim(Substr(cLinha,1,40))
				cMun		:= Alltrim(Substr(cLinha,42,60))
				cNome		:= Alltrim(Substr(cLinha,103,40))
				cCgc		:= Alltrim(Substr(cLinha,144,18))
				cFone		:= Alltrim(Substr(cLinha,162,50))
				cEmail		:= Alltrim(Substr(cLinha,213,30))

				cCgc := STRTRAN(cCgc,"-","")
				cCgc := STRTRAN(cCgc,".","")
				cCgc := STRTRAN(cCgc,"/","")
				cCgc := STRTRAN(cCgc,"*","")

				DbSelectArea("SA2")
				DbSetOrder(3)

				If !Empty(Alltrim(cCgc)) .And. SA2->(!DbSeek(xFilial("SA2")+cCgc)) .And. CGC(cCgc)

					cCodigo		:= GETSXENUM("SA2","A2_COD")

					IncProc("Incluindo Favorecido - Código: " + cCodigo)
	
					If Len(cCgc) == 11
						cTipo := 'F'
					Elseif Len(cCgc) == 14
						cTipo := 'J'
					Else
						cTipo := ''
					Endif

					RecLock("SA2",.T.)
					SA2->A2_COD 	:= cCodigo
					SA2->A2_LOJA	:= '01'
					SA2->A2_NOME	:= cNome
					SA2->A2_TEL		:= cFone
					SA2->A2_EMAIL	:= cEmail
					SA2->A2_NREDUZ	:= cNome
					SA2->A2_END		:= cEnd
					SA2->A2_NR_END	:= ""
					SA2->A2_BAIRRO	:= "IMPORT"
					SA2->A2_EST		:= 'SP'
					SA2->A2_COD_MUN	:= ""
					SA2->A2_MUN		:= cMun
					SA2->A2_CEP		:= ""
					SA2->A2_TIPO	:= cTipo
					SA2->A2_CGC		:= cCgc
					SA2->A2_PAIS	:= '105'
					SA2->A2_MSBLQL	:= '2'
					SA2->A2_NATUREZ	:= '5005034'
					MsUnLock()

					nCont++

				EndIf

			Endif
			
	DbCloseArea()

	FT_FSKIP()

	EndDo

	FT_FUSE()
	fClose(nHdI)

	MsgAlert("Processamento efetuado com sucesso.","Sucesso")

Return()
