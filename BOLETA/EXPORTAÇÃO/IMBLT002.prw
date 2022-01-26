#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

#Define ENTER Chr(13)+Chr(10)
/*
Funcao      : IMBLT002
Objetivos   : Função para exportar cadastro de Igrejas para TXT
Autor       : Vinicius Henrique
Data/Hora   : 20/09/2017
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
*/
User function IMBLT002()

	Local cQuery		:= ""
	Local cAlias		:= GetNextAlias()
	Local cPerg			:= "IMBLT002"
	Local cArq    		:= "Cad_Igrejas.txt"
	Local cRg			:= ""
	Local cCpf			:= ""

	Private cDir		:= "C:\Boleta\"
	Private aCols	:= {}

		cQuery := " SELECT * "						+ CRLF
		cQuery += " FROM SA1010 SA1"				+ CRLF
		cQuery += " WHERE D_E_L_E_T_ = ' ' 	"		+ CRLF
		cQuery += " AND A1_XSUP = '000570' OR A1_COD = '000570' OR A1_XSUP = '' "	+ CRLF
		cQuery += " ORDER BY A1_XSUP	 "			+ CRLF

		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->A1_FILIAL,;			
			(cAlias)->A1_COD,;
			(cAlias)->A1_NOME,;
			(cAlias)->A1_END,;
			(cAlias)->A1_XNUMERO,;
			(cAlias)->A1_BAIRRO,;
			(cAlias)->A1_COD_MUN,;
			(cAlias)->A1_MUN,; 
			(cAlias)->A1_EST,;
			(cAlias)->A1_CEP,; 
			(cAlias)->A1_XCC,;
			(cAlias)->A1_XSUP})

			(cAlias)->(dbSkip())

		EndDo

	Processa({||GeraArq(aCols,cDir,cArq)},"Gerando arquivo Texto! Aguarde...") //Chamada da função para geração do txt

Return .T. 

Static Function GeraArq(aCols,cDir,cArq)      

	Local nHandle := FCreate(cDir+cArq)
	Local nCount  := 0	
	Local cEst	  := ""

	If nHandle < 0
		MsgAlert("Erro durante criação do arquivo.")
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLinha := 1 to Len(aCols)
		
//		cEst := ALLTRIM(aCols[nLinha][7])
			
			FWrite(nHandle, "I" + aCols[nLinha][2] + aCols[nLinha][3] + aCols[nLinha][4] + aCols[nLinha][5] + aCols[nLinha][6] + aCols[nLinha][7] + aCols[nLinha][8] + ;
			aCols[nLinha][9] + aCols[nLinha][10] + aCols[nLinha][11] + aCols[nLinha][12] + aCols[nLinha][13] + CRLF)  
		Next nLinha
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FClose(nHandle)
	EndIf

Return()
