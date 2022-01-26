#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User Function IMBLT007()

	Local 	cQuery		:= ""
	Local 	cAlias		:= GetNextAlias()
	Local 	cArqIg   	:= "Cad_Pastores"+ "_" +DTOS(Date())+"_" + StrTran(Time(),":","")+".txt"

	Private aPastores	:= {}
	Private cDirIg		:= "\Arquivos Boleta\Pastores\"
	Private nHandle 	//:= FCreate(cDirIg+cArqIg)
	Private cCpf		:= ""
	Private cRg			:= ""
	Private cConta		:= ""
	
 	PREPARE ENVIRONMENT EMPRESA '02' FILIAL '010010001' MODULO 'GPE'
		
		cQuery := " SELECT Z7_FILIAL, Z7_MAT, Z7_NOME, Z7_NASC, Z7_SEXO, Z7_CIC, Z7_RG, Z7_ESTCIVI, Z7_XCONJU, 					" + CRLF
		cQuery += " Z7_XIGREJA, Z7_SALARIO, Z7_XTIPO, Z7_BCDEPSA, Z7_TPCSAL, Z7_CTDEPSA, Z7_ADMISSA,								" + CRLF
		cQuery += " Z7_DEMISSA, Z7_XHRQ, Z7_TIPO, Z7_SITU, Z7_XDATA, Z7_XHORA, Z7_CC, Z7_DDDFONE, Z7_TELEFON, Z7_DDDCELU, SZ7.R_E_C_N_O_		" + CRLF
		cQuery += " FROM SZ7010 SZ7																								" + CRLF
		cQuery += " INNER JOIN SRA020 SRA ON																					" + CRLF
		cQuery += " SZ7.Z7_CIC = SRA.RA_CIC																						" + CRLF
		cQuery += " WHERE SZ7.D_E_L_E_T_ = ' '																					" + CRLF
		cQuery += " AND SRA.D_E_L_E_T_ = ' '																					" + CRLF
		cQuery += " AND SZ7.Z7_SITU = 'P'																						" + CRLF
		cQuery += " AND SRA.RA_XBOLETA = 'A'																					" + CRLF
		cQuery += " AND SZ7.Z7_XIGREJA IS NOT NULL																				" + CRLF
		cQuery += " GROUP BY Z7_FILIAL, Z7_MAT, Z7_NOME, Z7_NASC, Z7_SEXO, Z7_CIC, Z7_RG, Z7_ESTCIVI, Z7_XCONJU,				" + CRLF 
		cQuery += " Z7_XIGREJA, Z7_SALARIO, Z7_XTIPO, Z7_BCDEPSA, Z7_TPCSAL, Z7_CTDEPSA, Z7_ADMISSA,								" + CRLF
		cQuery += " Z7_DEMISSA, Z7_XHRQ, Z7_TIPO, Z7_SITU, Z7_XDATA, Z7_XHORA, Z7_CC, Z7_DDDFONE, Z7_TELEFON, Z7_DDDCELU, SZ7.R_E_C_N_O_" + CRLF

		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(DbGoTop())

			Do While !(cAlias)->(Eof())
		
					aAdd(aPastores,{.F.,;
					(cAlias)->Z7_FILIAL,;	// Filial
					(cAlias)->Z7_MAT,;		// Matricula
					(cAlias)->Z7_NOME,;		// Nome Completo
					(cAlias)->Z7_NASC,;		// Data de Nascimento
					(cAlias)->Z7_SEXO,;		// Sexo
					(cAlias)->Z7_CIC,;		// CPF
					(cAlias)->Z7_RG,;		// RG
					(cAlias)->Z7_ESTCIVI,;	// Estado Civil
					(cAlias)->Z7_XCONJU,;	// Nome Conjuge
					(cAlias)->Z7_XIGREJA,;	// Igreja Superior
					(cAlias)->Z7_SALARIO,;	// Salário
					(cAlias)->Z7_XTIPO,;	// Função
					(cAlias)->Z7_BCDEPSA,;	// Banco Para Deposito de Salário
					(cAlias)->Z7_TPCSAL,;	// Tipo de Conta
					(cAlias)->Z7_CTDEPSA,;	// Numero da Conta
					(cAlias)->Z7_ADMISSA,;	// Data de Admissão
					(cAlias)->Z7_DEMISSA,;	// Data de Demissão
					(cAlias)->Z7_XHRQ,;
					(cAlias)->Z7_TIPO,;
					(cAlias)->R_E_C_N_O_})		// Hierarquia
 
			(cAlias)->(dbSkip())

			EndDo

		If Len(aPastores) > 0

		nHandle 	:= FCreate(cDirIg+cArqIg)

			If nHandle < 0
				MsgAlert("Erro durante criação do arquivo.")
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nLinha := 1 to Len(aPastores)

					cCpf := STRTRAN(aPastores[nLinha][7],"-","")
					cCpf := STRTRAN(cCpf,".","")
					cCpf := STRTRAN(cCpf,"/","")
		
					cRg := STRTRAN(aPastores[nLinha][8],"-","")
					cRg := STRTRAN(cRg,".","")
					cRg := STRTRAN(cRg,"/","")
		
					cRg	:= PADR(cRg,15," ")
		
					cConta := STRTRAN(aPastores[nLinha][16],"-","")
					cConta := STRTRAN(cConta,".","")
					cConta := STRTRAN(cConta,"/","")
		
					cConta	:= PADR(cRg,15," ")

					FWrite(nHandle, aPastores[nLinha][20] + "010001" + aPastores[nLinha][3] + PADR(aPastores[nLinha][4],70," ") + aPastores[nLinha][5] + aPastores[nLinha][6] + cCpf + cRg + aPastores[nLinha][9] +;
					aPastores[nLinha][10] + aPastores[nLinha][11] + STRZERO(aPastores[nLinha][12],12) + aPastores[nLinha][13] + Space(4) + Space(5) + Space(15) + aPastores[nLinha][17] +;
					aPastores[nLinha][18] + aPastores[nLinha][19]  + CRLF)  

					cQuery := " UPDATE SZ7010
					cQuery += " SET Z7_SITU = 'G' "
					cQuery += " WHERE D_E_L_E_T_ = ' ' "
					cQuery += " AND R_E_C_N_O_ = "+cValtoChar(aPastores[nLinha][21])+" "

					If TcSqlExec(cQuery) < 0
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
	
	RESET ENVIRONMENT

return