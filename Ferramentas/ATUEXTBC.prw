#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User Function ATUEXTBC()

	Processa({||Atualiza()},"Aguarde, Atualizando Registros")
	
Return

Static Function Atualiza()

Local cAlias	:= GetNextAlias()
Local aCols		:= {}
Local cQuery	:= ""
Local cHist		:= ""
Local nx

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SE5")+" SE5	" 		+ CRLF
		cQuery += " WHERE SE5.D_E_L_E_T_ = ' '	"		 	+ CRLF
	
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->E5_PREFIXO,;			
			(cAlias)->E5_NUMERO,;
			(cAlias)->E5_PARCELA,;
			(cAlias)->E5_CLIFOR,;
			(cAlias)->E5_LOJA})
			(cAlias)->(dbSkip())
						
		EndDo
		(cAlias)->(DbGoTop())
				
		ProcRegua(Reccount())

		For nx := 1 To Len(aCols)

			DbSelectArea("SE2")
			SE2->(dbSetOrder(24))
			SE2->(dbGoTop())
				
				If SE2->(dbSeek(aCols[nx][3]+aCols[nx][4]+aCols[nx][5]+aCols[nx][6]))
				
				cHist := SE2->E2_HIST
				
				IncProc("Atualizando Título: " + SE2->E2_NUM)			
	
							DbSelectArea("SE5")
							SE5->(dbSetOrder(23))
							SE5->(dbGoTop())
								
							If SE5->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][4]+aCols[nx][5]+aCols[nx][6]))
												
								RecLock("SE5",.F.)
													
								SE5->E5_HISTOR	:= cHist						

								SE5->(MsUnlock())
													
							Endif
	
				EndIf
				
				cHist := ""
		Next nx	
Return
