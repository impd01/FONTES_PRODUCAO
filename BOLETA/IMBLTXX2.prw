#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMBLTXX2   ºAutor  ³Vinicius Henrique       º Data ³08/02/2019    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMBLTXX2 - Exporta Arquivos de Igrejas para TXT			        º±±
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

User Function IMBLTXX2()

Local cPerg		:= "IMBLTXX2"

Private nTipo 	:= MV_PAR05
	
	If ! Pergunte(cPerg,.T.)
		Return
	Endif
	
	MsgRun("Gerando Arquivo","Aguarde...",{|| U_GERATXTI(nTipo,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04, "IMBLTXX2", ) })
	FWMsgRun(, {|oSay| U_GERATXTI(nTipo,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04, "IMBLTXX2", ) }, "Integração Boleta Eletrônica", "Gerando Arquivo" )

Return

User Function GERATXTI(nOpc, MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04, cOrigem, aCols)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

Local cArqIg   	:= "Cad_Igrejas"+ "_" +DTOS(Date())+"_" + StrTran(Time(),":","")+".txt"

Private cDirIg	:= "\Arquivos Boleta\Igrejas\"
Private nHandle

	If cOrigem == 'IMBLTXX2'
	
			cQuery	:= "SELECT *																			" + CRLF
			cQuery	+= "FROM " + RetSQLName("SA1") + " SA1 													" + CRLF
			cQuery	+= "WHERE  SA1.D_E_L_E_T_ = ' '															" + CRLF
			cQuery	+= "AND SA1.A1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'					" + CRLF
			cQuery	+= "AND SA1.A1_XCC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'					" + CRLF

			MEMOWRITE("IMBLTXX2.SQL",cQuery)

			TCQUERY cQuery NEW ALIAS (cAlias)

			If nOpc == 1
				cTpArq :=  'I'
			Else
				cTpArq := 'A'
			Endif

			aCols		:= {}

			Do While !(cAlias)->(Eof()) 

				aAdd(aCols,{cTpArq,;
				"      ",;	// Filial
				(cAlias)->A1_COD,;		// Matricula
				(cAlias)->A1_NOME,;		// Nome Completo
				(cAlias)->A1_END,;		// Data de Nascimento
				(cAlias)->A1_XNUMERO,;		// Sexo
				(cAlias)->A1_BAIRRO,;		// CPF
				(cAlias)->A1_COD_MUN,;		// RG
				(cAlias)->A1_MUN,;	// Estado Civil
				(cAlias)->A1_EST,;	// Nome Conjuge
				(cAlias)->A1_CEP,;	// Igreja Superior
				(cAlias)->A1_XCC,;	// Salário
				(cAlias)->A1_XSUP,;	// Função
				(cAlias)->A1_XSTATUS})		// Hierarquia

				(cAlias)->(DbSkip())

			EndDo

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

						FWrite(nHandle, aCols[nLinha][1] + aCols[nLinha][2] + aCols[nLinha][3] + FwNoAccent(aCols[nLinha][4]) + FwNoAccent(aCols[nLinha][5]) + FwNoAccent(aCols[nLinha][6]) + aCols[nLinha][7] +;
						aCols[nLinha][8] + aCols[nLinha][9] + aCols[nLinha][10] + aCols[nLinha][11] + aCols[nLinha][12] + aCols[nLinha][13] + aCols[nLinha][14] + CRLF)  	

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
			U_ImpdCpyFTP(cArqIg, 'IGREJAS')
		Endif


Return