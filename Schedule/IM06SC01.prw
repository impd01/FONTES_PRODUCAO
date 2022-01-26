#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"


User Function IM06SCX01()

Private oProcess := Nil

	FWMsgRun(, {|oSay| U_IM06SC01()}, "Processando Registros", "Processando")

Return()

User Function IM06SC01()

Local cQuery	:= ""
Local aCols		:= {}
Local cAlias	:= GetNextAlias()
Local nCont		:= 0

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SE2")+" SE2	"
		cQuery += " WHERE D_E_L_E_T_ = ' '	"
		cQuery += " AND SE2.E2_BAIXA <>	' ' "
		cQuery += " AND SE2.E2_BAIXA <> SE2.E2_EMIS1	"

		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->E2_FILIAL,;			
			(cAlias)->E2_PREFIXO,;
			(cAlias)->E2_NUM,;
			(cAlias)->E2_PARCELA,;
			(cAlias)->E2_TIPO,;
			(cAlias)->E2_FORNECE,;
			(cAlias)->E2_LOJA})
			
			(cAlias)->(dbSkip())
						
		EndDo
		(cAlias)->(DbGoTop())
		
		DbSelectArea("SE2")
		SE2->(dbSetOrder(1))
		SE2->(dbGoTop())

		For nx := 1 To Len(aCols)		
					
				If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][4]+aCols[nx][5]+aCols[nx][6]+aCols[nx][7]))
				
						RecLock("SE2",.F.)
						SE2->E2_EMIS1	:= SE2->E2_BAIXA							
						SE2->(MsUnlock())
						
						nCont++
						
				Endif
		
		Next nx
	
		If nCont > 0
			MsgInfo(cValtoChar(nCont) + " registros processados.", "TOTVS")
		Else
			MsgInfo("Nenhum registro processado","TOTVS")
		Endif
	
Return