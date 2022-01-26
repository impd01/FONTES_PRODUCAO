#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK   ºAutor  ³Vinicius Henrique     º Data ³05/02/2019      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³MA030TOK - Ponto de Entrada para Exportar 	        			º±±
º±±							Arquivos de Igrejas para TXT						º±±
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

User Function MA030TOK()

Local aCols 	:= {}
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local lRet 		:= .F.
Local cIgreja	:= Space(6)
Local cArqPst  	:= "Cad_Pastores"+ "_" +DTOS(Date())+"_" + StrTran(Time(),":","")+".txt"

Private cDirPst	:= "\Arquivos Boleta\Pastores\"
Private nHandle

IF ALTERA

	If (SA1->A1_COD <> M->A1_COD .Or. ;
		SA1->A1_NOME <> M->A1_NOME .Or. ;
		SA1->A1_END <> M->A1_END .Or. ;
		SA1->A1_XNUMERO <> M->A1_XNUMERO .Or. ;
		SA1->A1_BAIRRO <> M->A1_BAIRRO .Or. ;
		SA1->A1_COD_MUN <> M->A1_COD_MUN .Or. ;
		SA1->A1_MUN <> M->A1_MUN .Or. ;
		SA1->A1_EST <> M->A1_EST .Or. ;
		SA1->A1_CEP <> M->A1_CEP .Or. ;
		SA1->A1_XCC <> M->A1_XCC .Or. ;
		SA1->A1_XSUP <> M->A1_XSUP .Or. ;
		SA1->A1_XSTATUS <> M->A1_XSTATUS)

		If M->A1_XSTATUS == 'N'
	
			M->A1_MSBLQL := '1'
						
		Endif

		aAdd(aCols,{'A',;
		"      ",;
		M->A1_COD,;
		M->A1_NOME,;
		M->A1_END,;
		M->A1_XNUMERO,;
		M->A1_BAIRRO,;
		M->A1_COD_MUN,;
		M->A1_MUN,;
		M->A1_EST,;
		M->A1_CEP,;
		M->A1_XCC,;
		M->A1_XSUP,;
		M->A1_XSTATUS})

		FWMsgRun(, {|oSay| U_GERATXTI(,,,,,"M030ALT", aCols) }, "Integração Boleta Eletrônica", "Gerando Arquivo" )
		
		If SA1->A1_XSTATUS == 'S' .AND. M->A1_XSTATUS == 'N'
			nOpc := 3
			lRet := .T.
		Elseif SA1->A1_XSTATUS == 'N' .AND. M->A1_XSTATUS == 'S'
			nOpc := 4 
			lRet := .T.
		Endif
		
		nHandle 	:= FCreate(cDirPst+cArqPst)

		cQuery	:= "SELECT *														" + CRLF
		cQuery	+= "FROM SRA020 SRA					 								" + CRLF
		cQuery	+= "WHERE  SRA.D_E_L_E_T_ = ' '										" + CRLF
		cQuery	+= "AND SRA.RA_CC = '" + M->A1_XCC + "'								" + CRLF
		cQuery	+= "AND SRA.RA_DEMISSA = ' '										" + CRLF

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
			
			cConta	:= PADR(cConta,15," ")
				
			cCusto := aCols[nLinha][21]
			
			If nOpc == 3
				cIgreja := '999999'
			Elseif nOpc == 4
				cIgreja := CODIGRJ(cCusto)
			Endif

			FWrite(nHandle, 'A' + "010001" + aCols[nLinha][3] + PADR(aCols[nLinha][4],70," ") + aCols[nLinha][5] + aCols[nLinha][6] + cCpf + cRg + aCols[nLinha][9] +;
			aCols[nLinha][10] + cIgreja + STRZERO(aCols[nLinha][12],12) + aCols[nLinha][13] + Space(4) + Space(5) + Space(15) + aCols[nLinha][17] +;
			aCols[nLinha][18] + aCols[nLinha][19]  + CRLF)  	

			Next nLinha
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			FClose(nHandle)
			
		If U_IMPDFTP()
			U_ImpdCpyFTP(cArqPst, 'PASTORES')
		Endif

	Endif
	
Endif

Return(.T.)

return

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
		cCodIg := '999999'
	Endif

Return(cCodIg)
