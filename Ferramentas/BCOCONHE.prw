#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BCOCONHE    ºAutor  ³Vinicius Henrique       º Data ³27/07/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³BCOCONHE - Ajusta Sequencia do Banco de Conhecimento		        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Grupo Dovac	                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±admin
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BCOCONHE()
 
Private oProcess	:= Nil

	oProcess := MsNewProcess():New( { || PROCESSA() }, 'Aguarde', 'Atualizando Registros ...', .T. )
	oProcess:Activate()
	
Return()

Static Function PROCESSA()

Local nRegs		:= 0000020719
Local nNumAnte	:= 0
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local aCols		:= {}
Local nx
	
		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("ACB")+" ACB	"
		cQuery += " INNER JOIN "+RetSQLName("AC9")+" AC9	"
		cQuery += " ON ACB.ACB_FILIAL = AC9.AC9_FILIAL	"
		cQuery += " AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ	"
		cQuery += " ORDER BY ACB.R_E_C_N_O_	"
	
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->ACB_FILIAL,;			
			(cAlias)->ACB_CODOBJ,;
			(cAlias)->AC9_FILIAL,;			
			(cAlias)->AC9_CODOBJ})
			(cAlias)->(dbSkip())			
		EndDo

		DbSelectArea("ACB")
		ACB->(DbSetOrder(1))
		ACB->(dbGoTop())

		DbSelectArea("AC9")
		AC9->(DbSetOrder(1))
		AC9->(dbGoTop())
		
		For nx := 1 To Len(aCols)
			
				If ACB->(dbSeek(aCols[nx][2]+aCols[nx][3])) 
					RecLock("ACB",.F.)
					ACB->ACB_CODOBJ := STRZERO(nRegs,10)
					ACB->(MsUnlock())
					
					If	AC9->(dbSeek(aCols[nx][4]+aCols[nx][5]))
						RecLock("AC9",.F.)
						AC9->AC9_CODOBJ := STRZERO(nRegs,10)
						AC9->(MsUnlock())
						
					Endif
				nRegs++	
				Endif
			
		Next nx
		
		Alert("Registros atualizados")

Return()
