#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMBLT006    ºAutor  ³Vinicius Henrique       º Data ³24/04/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMBLT006 - Gera Arquivo Texto de Igrejas					        º±±
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

User Function IMBLT006()

	Local 	cQuery		:= ""
	Local 	cAlias		:= GetNextAlias()
	Local 	cAliasZ6	:= GetNextAlias()
	Local 	cArqIg   	:= "Cad_Igrejas"+ "_" +DTOS(Date())+"_" + StrTran(Time(),":","")+".txt"
	
	Private _cQuery		:= ""
	Private aIgrejas	:= {}
	Private cDirIg 		:= "\Arquivos Boleta\Igrejas\"
	Private nHandle

		cQuery := " SELECT * "
		cQuery += " FROM SZ6010 SZ6	"
		cQuery += " WHERE SZ6.D_E_L_E_T_ = ' '	"
		cQuery += " AND SZ6.Z6_SITU = 'P'	"
//		cQuery += " AND SZ6.Z6_NOME LIKE '%SEDE%' "

		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aIgrejas,{(cAlias)->Z6_TIPO,;
			(cAlias)->Z6_FILIAL,;			
			(cAlias)->Z6_COD,;
			(cAlias)->Z6_NOME,;
			(cAlias)->Z6_END,;
			(cAlias)->Z6_XNUM,;
			(cAlias)->Z6_BAIRRO,;
			(cAlias)->Z6_COD_MUN,;
			(cAlias)->Z6_MUN,; 
			(cAlias)->Z6_EST,;
			(cAlias)->Z6_CEP,; 
			(cAlias)->Z6_XCC,;
			(cAlias)->Z6_XSUP,;
			(cAlias)->Z6_XSTATUS,;
			(cAlias)->R_E_C_N_O_})			
			
			(cAlias)->(dbSkip())

		EndDo
		
	If Len(aIgrejas) > 0
	
		nHandle 	:= FCreate(cDirIg+cArqIg)
		
		If nHandle < 0
			MsgAlert("Erro durante criação do arquivo.")
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLinha := 1 to Len(aIgrejas)
			
				cNome 	:= FORMAT(aIgrejas[nLinha][4])
				cEnd 	:= FORMAT(aIgrejas[nLinha][5])
				cNum 	:= FORMAT(aIgrejas[nLinha][6])
				cBairro := FORMAT(aIgrejas[nLinha][7])
				cMun 	:= FORMAT(aIgrejas[nLinha][9])
/*				cNome 	:= aIgrejas[nLinha][4]
				cEnd 	:= aIgrejas[nLinha][5]
				cNum 	:= aIgrejas[nLinha][6]
				cBairro := aIgrejas[nLinha][7]
				cMun 	:= aIgrejas[nLinha][9]*/

				FWrite(nHandle, aIgrejas[nLinha][1] + aIgrejas[nLinha][2] + aIgrejas[nLinha][3] + cNome + cEnd + cNum + cBairro + aIgrejas[nLinha][8] + ;
				cMun + aIgrejas[nLinha][10] + aIgrejas[nLinha][11] + aIgrejas[nLinha][12] + aIgrejas[nLinha][13] + aIgrejas[nLinha][14] + CRLF)  

				_cQuery := " UPDATE "+RetSqlName("SZ6")
				_cQuery += " SET Z6_SITU = 'G' "
				_cQuery += " WHERE D_E_L_E_T_ = ' ' "
				_cQuery += " AND R_E_C_N_O_ = "+cValtoChar(aIgrejas[nLinha][15])+" "
	
				If TcSqlExec(_cQuery) < 0
					alert(TcSqlError())
				Else
					TcSqlExec( "COMMIT" )				
				Endif
	
			Next nLinha
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FClose(nHandle)
		EndIf
	
	Endif

Return()

Static Function FORMAT(cTexto)
/*
	cTexto := NoAcento(cTexto)
	cTexto := STRTRAN(cTexto,"-"," ")				
	cTexto := STRTRAN(cTexto,"."," ")				
	cTexto := STRTRAN(cTexto,"/"," ")		
	cTexto := STRTRAN(cTexto,"("," ")				
	cTexto := STRTRAN(cTexto,")"," ")
	cTexto := STRTRAN(cTexto,","," ")
	cTexto := STRTRAN(cTexto,":"," ")
	cTexto := STRTRAN(cTexto,"´"," ")
	cTexto := STRTRAN(cTexto,"'"," ")
	cTexto := STRTRAN(cTexto,"Ç","C")
*/
	cTexto := EncodeUTF8(cTexto, "cp1252")
//	cTexto := DecodeUTF8(cTexto, "cp1252")

//	cTexto := UPPER(cTexto)

Return cTexto