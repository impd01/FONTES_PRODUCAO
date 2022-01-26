#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User Function BAIXAAUT()

Local cAlias	:= GetNextAlias()
Local aCols		:= {}
Local cQuery	:= ""
Local nOpcAuto	:= 0
Local nx

Private lMsErroAuto := .F.

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SEF")+" SEF	"
		cQuery += " WHERE EF_BANCO <> 'CX'	"
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
			(cAlias)->EF_DATA})
			(cAlias)->(dbSkip())
						
		EndDo

	
		For nx := 1 To Len(aCols)

			dbSelectArea("SE2")
			SE2->(dbSetOrder(21))
			SE2->(dbGoTop())
			
			If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]))
			
						If SE2->E2_SALDO > 0
						
							cHistBaixa := "Valor pago s/ Titulo"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Monta array com os dados da baixa a pagar do título³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
							aBaixa := {}
							
							AADD(aBaixa, {"E2_FILIAL" 	, 	SE2->E2_FILIAL 	, 	Nil})
							AADD(aBaixa, {"E2_PREFIXO" 	, 	SE2->E2_PREFIXO , 	Nil})
							AADD(aBaixa, {"E2_NUM" 		, 	SE2->E2_NUM 	, 	Nil})
							AADD(aBaixa, {"E2_PARCELA" 	, 	SE2->E2_PARCELA , 	Nil})
							AADD(aBaixa, {"E2_TIPO" 	, 	SE2->E2_TIPO 	, 	Nil})
							AADD(aBaixa, {"E2_FORNECE" 	, 	SE2->E2_FORNECE , 	Nil})
							AADD(aBaixa, {"E2_LOJA" 	, 	SE2->E2_LOJA 	, 	Nil}) 
							AADD(aBaixa, {"AUTMOTBX" 	, 	"DEBITO CC " 	, 	Nil})
							AADD(aBaixa, {"AUTBANCO" 	, 	aCols[nx][4]	, 	Nil})
							AADD(aBaixa, {"AUTAGENCIA" 	, 	aCols[nx][5]	, 	Nil})
							AADD(aBaixa, {"AUTCONTA" 	, 	aCols[nx][6]	, 	Nil})
							AADD(aBaixa, {"AUTDTBAIXA" 	, 	aCols[nx][7]	, 	Nil}) 
							AADD(aBaixa, {"AUTDTCREDITO", 	aCols[nx][7]	, 	Nil})
							AADD(aBaixa, {"AUTHIST" 	, 	cHistBaixa 		, 	Nil})
							AADD(aBaixa, {"AUTVLRPG" 	, 	SE2->E2_SALDO 	, 	Nil})
							
							ACESSAPERG("FIN080", .F.)
							
							MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)
						
							If lMsErroAuto
							MOSTRAERRO() 
							Return .F.
							EndIf 
						Else
							Alert("O título não possui saldo a pagar em aberto")
						EndIf 
			Else
					Alert("O título a pagar não foi localizado")
			EndIf
		
		Next nx
Return
