#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User function CADICTB()

Local cQuery	:= ""
Local aCols		:= {}
Local cAlias	:= GetNextAlias()
Local cCTDCod	  := "F00000"
Local cItemContab := ""

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SA2")+" SA2	"
		cQuery += " WHERE SA2.D_E_L_E_T_ = ' '	"

		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->A2_COD,;			
			(cAlias)->A2_LOJA})
			
			(cAlias)->(dbSkip())
						
		EndDo
		(cAlias)->(DbGoTop())
				
		DbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		
		For nx := 1 To Len(aCols)

			If SA2->(dbSeek(xFilial("SA2")+aCols[nx][2]+aCols[nx][3]))
			
				cItemContab := "F" + aCols[nx][2]+aCols[nx][3]
				
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				CTD->(dbGoTop())
										
				If !CTD->(dbSeek(xFilial("CTD")+cItemContab))
					Reclock("CTD",.T.)
					CTD->CTD_FILIAL	:= xFilial("CTD")
					CTD->CTD_ITEM	:= Alltrim(cItemContab)
					CTD->CTD_CLASSE	:= "2"
					CTD->CTD_NORMAL	:= "0"
					CTD->CTD_DESC01	:= Alltrim(SA2->A2_NOME)    
					CTD->CTD_RES	:= Alltrim(SA2->A2_NREDUZ)	
					CTD->CTD_BLOQ	:= "2"
					CTD->CTD_DTEXIS	:= StoD("19800101")
					CTD->CTD_ITLP	:= Alltrim(cItemContab)
					CTD->CTD_ITSUP	:= cCTDCod
					CTD->CTD_ACCLVL	:= "1"
					CTD->CTD_CLOBRG	:= "2"
					MsUnlock()	
				Endif
				
			Endif
		
		Next nx

Return