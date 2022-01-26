#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002
  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMBLTXX1   ºAutor  ³Vinicius Henrique       º Data ³25/01/2019    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMBLTXX1 - Exporta Arquivos de Pastores para TXT			        º±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function IMBLTXX1()

	 Local 		cPerg	:= "IMBLTXX1"
	 Private 	nTipo 	:= MV_PAR07
	 Private oProcess	:= Nil	//Utilizo private pq faco varias consistencias com VALTYPE
	
		If ! Pergunte(cPerg,.T.)
			Return
		Endif

	FWMsgRun(, {|oSay| U_GERATXT( 1,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06, MV_PAR07) }, "Integração Boleta Eletrônica", "Gerando Arquivo" )
	
return

User Function GERATXT(nOpc, cFilialD, cFilialA, cMatde, cMatAt, cCcDe, cCcAte, nTpArq, aCols)

	Local cFil		:= ""
	Local cCpf		:= ""
	Local cRg		:= ""
	Local cConta	:= ""
	Local cTipo 	:= ""
	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local cCusto	:= ""
	Local cArqIg   	:= "Cad_Pastores" + "_" +DTOS(Date()) + "_" + StrTran(Time(),":","")+".txt"
	
	Private cDirIg	:= "\Arquivos Boleta\Pastores\"
	Private nHandle
	Private	cCodIg	:= Space(6)
	Private cStsIgj	:= ""

	If nOpc == 1
 
		cQuery	:= "SELECT * FOM SRA020 SRA 															" + CRLF
		cQuery	+= "WHERE  SRA.D_E_L_E_T_ = ' '															" + CRLF
		cQuery	+= "AND SRA.RA_FILIAL BETWEEN '" + cFilialD + "' AND '" + cFilialA + "'					" + CRLF
		cQuery	+= "AND SRA.RA_MAT BETWEEN '" + cMatde + "' AND '" + cMatAt + "'						" + CRLF
		cQuery	+= "AND SRA.RA_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'							" + CRLF
		cQuery	+= "AND SRA.RA_DEMISSA = ' '															" + CRLF
	
		MEMOWRITE("IMBLTXX1.SQL",cQuery)
	
		TCQUERY cQuery NEW ALIAS (cAlias)

		aCols		:= {}

		Do While !(cAlias)->(Eof()) 
	
			aAdd(aCols,{.F.,;
			(cAlias)->RA_FILIAL,;	// Filial
			(cAlias)->RA_MAT,;		// Matricula
			(cAlias)->RA_NOME,;		// Nome Completo
			(cAlias)->RA_NASC,;		// Data de Nascimento
			(cAlias)->RA_SEXO,;		// Sexo
			(cAlias)->RA_CIC,;		// CPF
			(cAlias)->RA_RG,;		// RG
			(cAlias)->RA_ESTCIVI,;	// Estado Civil
			(cAlias)->RA_XCONJUG,;	// Nome Conjuge
			(cAlias)->RA_XIGJATU,;	// Igreja Superior
			(cAlias)->RA_SALARIO,;	// Salário
			(cAlias)->RA_XTIPO,;	// Função
			"",;
			"",;
			"",;
			(cAlias)->RA_ADMISSA,;	// Data de Admissão
			(cAlias)->RA_DEMISSA,;	// Data de Demissão
			(cAlias)->RA_XHRQ,;
			"",;
			(cAlias)->RA_CC})		// Hierarquia
	
			(cAlias)->(DbSkip())
	
		EndDo
	
	Else
		Sleep(2000)
	Endif

		If nTpArq == 1
			cTipo := 'I'
		Else
			cTipo := 'A'	
		Endif
		
			If Len(aCols) > 0
	
				nHandle 	:= FCreate(cDirIg+cArqIg)
		
				If nHandle < 0
					MsgAlert("Erro durante criação do arquivo.")
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
					For nLinha := 1 to Len(aCols)
		
						cCpf := STRTRAN(aCols[nLinha][7],"-","")
						cCpf := STRTRAN(cCpf,".","")
						cCpf := STRTRAN(cCpf,"/","")
				
						cRg := STRTRAN(aCols[nLinha][8],"-","")
						cRg := STRTRAN(cRg,".","")
						cRg := STRTRAN(cRg,"/","")
				
						cRg	:= PADR(cRg,15," ")
				
						cConta := STRTRAN(aCols[nLinha][16],"-","")
						cConta := STRTRAN(cConta,".","")
						cConta := STRTRAN(cConta,"/","")
				
						cConta := PADR(cConta,15," ")
						
						cFil   := SUBSTR(aCols[nLinha][2],1,6)
							
						cCusto := aCols[nLinha][21]
						
						DbSelectArea("SA1")
						DbSetOrder(1) 
						
							If nOpc == 3
								cCodIg := '999999'
							Else	
								
								CODIGRJ(cCusto)
							
								If cStsIgj == 'N' .Or. Empty(Alltrim(cCodIg))
									cCodIg := '999999'
								Else
									cCodIg := cCodIg
								Endif  
							
							Endif
								
						If nOpc == 1
						
							FWrite(nHandle, cTipo + cFil + aCols[nLinha][3] + PADR(aCols[nLinha][4],70," ") + aCols[nLinha][5] + aCols[nLinha][6] + cCpf + cRg + aCols[nLinha][9] +;
							aCols[nLinha][10] + cCodIg + STRZERO(aCols[nLinha][12],12) + aCols[nLinha][13] + Space(4) + Space(5) + Space(15) + aCols[nLinha][17] +;
							aCols[nLinha][18] + aCols[nLinha][19]  + CRLF)  	
	
						Else
	
							FWrite(nHandle, cTipo + cFil + aCols[nLinha][3] + PADR(aCols[nLinha][4],70," ") + aCols[nLinha][5] + aCols[nLinha][6] + cCpf + cRg + aCols[nLinha][9] +;
							aCols[nLinha][10] + cCodIg + STRZERO(aCols[nLinha][12],12) + aCols[nLinha][13] + Space(4) + Space(5) + Space(15) + aCols[nLinha][17] +;
							aCols[nLinha][18] + aCols[nLinha][19]  + CRLF)  	
	
						Endif
								
					Next nLinha
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					FClose(nHandle)
				EndIf
			Else
	
				MsgAlert("Não foram encontrados registros com os dados informados.","TOTVS")
				Return(.F.)
			Endif
				
				If U_IMPDFTP()
					U_ImpdCpyFTP(cArqIg, 'PASTORES')
				Endif
Return()



Static Function CODIGRJ(cCCusto) 

	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""
	Local aInfo		:= {}

	cQuery	:= "SELECT A1_COD, A1_XSTATUS			" 		+ CRLF
	cQuery	+= "FROM SA1010							"	 	+ CRLF
	cQuery	+= "WHERE A1_XCC = '" + cCCusto + "'	"	 	+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	If !(cAlias)->(Eof()) 
		cCodIg 	:= (cAlias)->A1_COD
		cStsIgj := (cAlias)->A1_XSTATUS
	Else
		cCodIg := ''
	Endif
	
Return()
