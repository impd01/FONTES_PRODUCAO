#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AUTOMATIC      ºAutor³Vinicius Henrique	ºData³  04/08/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Excluir baixas dos titulos e baixa novamente como DEBITO    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AUTOMATIC()
	
	Processa({||Atualiza()},"Aguarde, Atualizando Registros")
	
Return

Static Function Atualiza()
Local cAlias	:= GetNextAlias()
Local aCols		:= {}
Local cQuery	:= ""
Local dEmissao
Local cHist		:= ""
Local nx

Private lMsErroAuto := .F.

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SEF")+" SEF	"
		cQuery += " WHERE D_E_L_E_T_ = ' '	"
		cQuery += " AND EF_BANCO = '237'	"
		cQuery += " AND EF_NUM = ' '	"
		cQuery += " AND EF_DATA >=20170101	"
	
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->EF_TITULO,;			
			(cAlias)->EF_PARCELA,;
			(cAlias)->EF_BANCO,;
			(cAlias)->EF_AGENCIA,;
			(cAlias)->EF_CONTA,;
			(cAlias)->EF_DATA,;
			(cAlias)->EF_FORNECE,;
			(cAlias)->EF_LOJA,;
			(cAlias)->EF_PREFIXO})
			(cAlias)->(dbSkip())
						
		EndDo
		(cAlias)->(DbGoTop())
				
		ProcRegua(Reccount())

		For nx := 1 To Len(aCols)

		DbSelectArea("SE2")
		SE2->(dbSetOrder(24))
		SE2->(dbGoTop())
			
			If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][8]+aCols[nx][9]))
			
			IncProc("Atualizando Título: " + SE2->E2_NUM)
			
						If SE2->E2_SALDO == 0
						
							cHistBaixa := "Valor pago s/ Titulo"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Monta array com os dados da baixa a pagar do título³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
							aBaixa 	:= {}
							aBaixa2 := {}
							
							AADD(aBaixa, {"E2_FILIAL" 	, 	SE2->E2_FILIAL 	, 	Nil})
							AADD(aBaixa, {"E2_PREFIXO" 	, 	SE2->E2_PREFIXO , 	Nil})
							AADD(aBaixa, {"E2_NUM" 		, 	SE2->E2_NUM 	, 	Nil})
							AADD(aBaixa, {"E2_PARCELA" 	, 	SE2->E2_PARCELA ,	Nil})
							AADD(aBaixa, {"E2_TIPO" 	, 	SE2->E2_TIPO 	, 	Nil})
							AADD(aBaixa, {"E2_FORNECE" 	, 	SE2->E2_FORNECE , 	Nil})
							AADD(aBaixa, {"E2_LOJA" 	, 	SE2->E2_LOJA 	, 	Nil}) 
							AADD(aBaixa, {"AUTVLRPG" 	, 	SE2->E2_VALOR 	, 	Nil})
							
							MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 6)							
							
							AADD(aBaixa2, {"E2_FILIAL" 		, 	SE2->E2_FILIAL 	, 	Nil})
							AADD(aBaixa2, {"E2_PREFIXO" 	, 	SE2->E2_PREFIXO , 	Nil})
							AADD(aBaixa2, {"E2_NUM" 		, 	SE2->E2_NUM 	, 	Nil})
							AADD(aBaixa2, {"E2_PARCELA" 	, 	SE2->E2_PARCELA , 	Nil})
							AADD(aBaixa2, {"E2_TIPO" 		, 	SE2->E2_TIPO 	, 	Nil})
							AADD(aBaixa2, {"E2_FORNECE" 	, 	SE2->E2_FORNECE , 	Nil})
							AADD(aBaixa2, {"E2_LOJA" 		, 	SE2->E2_LOJA 	, 	Nil}) 
							AADD(aBaixa2, {"AUTMOTBX" 		, 	"DEBITO CC " 	, 	Nil})
							AADD(aBaixa2, {"AUTBANCO" 		, 	aCols[nx][4]	, 	Nil})
							AADD(aBaixa2, {"AUTAGENCIA" 	, 	aCols[nx][5]	, 	Nil})
							AADD(aBaixa2, {"AUTCONTA" 		, 	aCols[nx][6]	, 	Nil})
							AADD(aBaixa2, {"AUTDTBAIXA" 	, 	STOD(aCols[nx][7])	, 	Nil}) 
							AADD(aBaixa2, {"AUTHIST" 		, 	cHistBaixa 		, 	Nil})
							AADD(aBaixa2, {"AUTVLRPG" 		, 	SE2->E2_SALDO 	, 	Nil})							
							
							MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa2, 3)
							
							dEmissao 	:= SE2->E2_EMISSAO
							cHist		:= SE2->E2_HIST
														
		DbSelectArea("SE5")
		SE5->(dbSetOrder(23))
		SE5->(dbGoTop())
							
						If SE5->(dbSeek(aCols[nx][10]+aCols[nx][2]+aCols[nx][3]+aCols[nx][8]+aCols[nx][9]))
											
							RecLock("SE5",.F.)
												
							SE5->E5_DTDISPO := STOD(aCols[nx][7])
							SE5->E5_DTDIGIT := dEmissao
							SE5->E5_HISTOR	:= cHist						
							SE5->(MsUnlock())
												
						Endif
						
						Else
//							Alert("O título não possui saldo a pagar em aberto")
						EndIf 
			Else
//					Alert("O título a pagar não foi localizado")
			EndIf
		
		Next nx
		
return
