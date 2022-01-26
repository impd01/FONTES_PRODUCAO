#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ºm020alt   ºAutorºAdilson Gomes         º Data º 31/03/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     º Efetua a gravação do Item Contábil (CTD) automáticamente   º±±
±±º          º Conforme definição do projeto, o item contábil registrará  º±±
±±º          º a contabilização de Cliente e Fornecedores, permitindo     º±±
±±º          º que a contabilidade tenha um plano de contas.              º±±
±±º          º                                                            º±±
±±º          º O cadastro dos itens contábeis será composto de:           º±±
±±º          º Fornecedores: "F" + SA2->A2_COD + SA2->A2_LOJA             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       º Especifico da BMA/SIGAFIN                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M020ALT()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aGetArea    := GetArea()

Local cItemContab := "F" + SA2->(A2_COD+A2_LOJA)
Local cCTDCod	  := "F00000"

CTD->(dbSetOrder(1))
//CTD->(dbGotop())
if !CTD->(dbSeek(xFilial("CTD")+cItemContab))
	CTD->(Reclock("CTD",.T.))
	CTD->CTD_FILIAL	:= xFilial("CTD")
	CTD->CTD_ITEM	:= Alltrim(cItemContab)
ELSE	
	CTD->(Reclock("CTD",.F.))
ENDIF	
	
	CTD->CTD_CLASSE	:= "2"
	CTD->CTD_NORMAL	:= "0"
	CTD->CTD_DESC01	:= Alltrim(SA2->A2_NOME)
	CTD->CTD_BLOQ	:= "2"
	CTD->CTD_DTEXIS	:= StoD("19800101")
	CTD->CTD_ITLP	:= Alltrim(cItemContab)
	CTD->CTD_ITSUP	:= cCTDCod
	CTD->CTD_ACCLVL	:= "1"
	CTD->CTD_CLOBRG	:= "2"
	CTD->(MsUnlock())	
               

//if empty(SA2->A2_ITCTB)
//	RecLock("SA2",.F.)
//	SA2->A2_ITCTB := cItemContab
//	MsUnlock()
//Endif

RestArea(aGetArea)

Return .T.