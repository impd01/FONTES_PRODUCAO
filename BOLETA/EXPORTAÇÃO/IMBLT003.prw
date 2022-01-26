#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

#Define ENTER Chr(13)+Chr(10)
/*
Funcao      : IMBLT003
Objetivos   : Função para exportar cadastro de Centro de Custo para TXT
Autor       : Vinicius Henrique
Data/Hora   : 20/09/2017
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
*/
User function IMBLT003()

	Local cQuery		:= ""
	Local cAlias		:= GetNextAlias()
	Local cPerg			:= "IMBLT003"
	Local cArq    		:= "Cad_CentroDeCusto.txt"
	Local cRg			:= ""
	Local cCpf			:= ""
	
	Private cDir		:= "\Testes TXT\"
	Private aCols		:= {}
	
//	sValidPerg(cPerg)

//	If !Pergunte(cPerg,.T.)
//		Return
//	Endif

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("CTT")+" CTT	"
		cQuery += " WHERE CTT.D_E_L_E_T_ = ' '	"
	
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->CTT_FILIAL,;			
			(cAlias)->CTT_CUSTO,;
			(cAlias)->CTT_DESC01})
			
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
	
			FWrite(nHandle, "I" + aCols[nLinha][2] + aCols[nLinha][3] + aCols[nLinha][4] + CRLF)  
			
		Next nLinha
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FClose(nHandle)
	EndIf

Return()

