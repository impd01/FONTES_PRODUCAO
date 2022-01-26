#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User function IM06SC02()

Local cQuery	:= ""
Local aCols		:= {}
Local cAlias	:= GetNextAlias()
Local cNaturez	:= ""

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SE2")+" SE2	"
		cQuery += " WHERE D_E_L_E_T_ = ' '	"
		cQuery += " AND SE2.E2_CODRET = '1708' OR "
		cQuery += " SE2.E2_CODRET = '3208' OR "
		cQuery += " SE2.E2_CODRET = '0561' OR "
		cQuery += " SE2.E2_CODRET = '0588' OR "
		cQuery += " SE2.E2_CODRET = '8045' "
		
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
		
		ProcRegua(Reccount())
		
		DbSelectArea("SE2")
		SE2->(dbSetOrder(1))
		SE2->(dbGoTop())

		For nx := 1 To Len(aCols)		
					
				If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][4]+aCols[nx][5]+aCols[nx][6]+aCols[nx][7]))
				
				IncProc("Atualizando Título: " + SE2->E2_NUM)
				
						If SE2->E2_CODRET = '1708'
							cNaturez := '5015004'
						Elseif SE2->E2_CODRET = '3208'
							cNaturez := '5015005'
						Elseif SE2->E2_CODRET = '0561'
							cNaturez := '5015006'
						Elseif SE2->E2_CODRET = '0588'
							cNaturez := '5015007'
						Elseif SE2->E2_CODRET = '8045'
							cNaturez := '5015008'
						Endif
				
						RecLock("SE2",.F.)
						SE2->E2_NATUREZ	:= cNaturez						
						SE2->(MsUnlock())

				Endif
		
		Next nx
	
Return