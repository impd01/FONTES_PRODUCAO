#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

#Define ENTER Chr(13)+Chr(10)
/*
Funcao      : IMBLT001
Objetivos   : Função para exportar cadastro de pastores para TXT
Autor       : Vinicius Henrique LUIZ
Data/Hora   : 20/09/2017
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
*/
User function IMBLT001()

	Local cQuery		:= ""
	Local cAlias		:= GetNextAlias()
	Local cPerg			:= "IMBLT001"
	Local cArq    		:= "Cad_Pastores.txt"
	Local cRg			:= ""
	Local cCpf			:= ""
	Local cConta		:= ""

	Private cDir		:= "C:\Boleta\"
	Private aCols		:= {}

//	sValidPerg(cPerg)

//	If !Pergunte(cPerg,.T.)
//		Return
//	Endif

		cQuery := " SELECT *							" + CRLF
		cQuery += " FROM SRA020 SRA				 		" + CRLF
		cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' 			" + CRLF
//		cQuery += " AND SRA.RA_XIGREJA <> ' ' 			" + CRLF
		cQuery += " AND SRA.RA_CC BETWEEN '10301010470001' AND '10301010470032' " + CRLF
		cQuery += " ORDER BY SRA.RA_XDESCC " + CRLF
		
		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			"010001",;				// Filial			
			(cAlias)->RA_MAT,;		// Matricula
			(cAlias)->RA_NOME,;		// Nome Completo
			(cAlias)->RA_NASC,;		// Data de Nascimento
			(cAlias)->RA_SEXO,;		// Sexo
			(cAlias)->RA_CIC,;		// CPF
			(cAlias)->RA_RG,;		// RG
			(cAlias)->RA_ESTCIVI,;	// Estado Civil
			(cAlias)->RA_XCONJUG,;	// Nome Conjuge
			"XXXXXX",;				// Igreja Superior
			(cAlias)->RA_SALARIO,;	// Salário
			(cAlias)->RA_XTIPO,;	// Função
			(cAlias)->RA_BCDEPSA,;	// Banco Para Deposito de Salário
			(cAlias)->RA_TPCTSAL,;	// Tipo de Conta
			(cAlias)->RA_CTDEPSAL,;	// Numero da Conta
			(cAlias)->RA_ADMISSA,;	// Data de Admissão
			(cAlias)->RA_DEMISSA,;	// Data de Demissão
			(cAlias)->RA_XHRQ})		// Hierarquia

			(cAlias)->(dbSkip())

		EndDo

	Processa({||GeraArq(aCols,cDir,cArq)},"Gerando arquivo Texto! Aguarde...") //Chamada da função para geração do txt

Return .T. 
	
Static Function GeraArq(aCols,cDir,cArq)

	Local nHandle := FCreate(cDir+cArq)
	Local nCount  := 0	

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
			cConta := STRTRAN(cRg,".","")
			cConta := STRTRAN(cRg,"/","")

			cConta	:= PADR(cRg,15," ")


			FWrite(nHandle, "I" + aCols[nLinha][2] + aCols[nLinha][3] + aCols[nLinha][4] + aCols[nLinha][5] + aCols[nLinha][6] + cCpf + cRg + aCols[nLinha][9] +;
			aCols[nLinha][10] + aCols[nLinha][11] + STRZERO(aCols[nLinha][12],12) + aCols[nLinha][13] + aCols[nLinha][14] + aCols[nLinha][15] + cConta + aCols[nLinha][17] + aCols[nLinha][18] +;
			aCols[nLinha][19] + CRLF)  
		Next nLinha
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FClose(nHandle)
	EndIf

Return()
