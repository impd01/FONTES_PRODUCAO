#INCLUDE "PROTHEUS.CH"


/*���������������������������������������������������������������������������
���Programa  �M030INC   �Autor  �Eduardo Augusto     � Data �  11/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. na rotina MATA030 (Cadastro de Cliente).               ���
�������������������������������������������������������������������������͹��
���Uso       � AULA ADVPL Jonathan Schmidt                                ���
���������������������������������������������������������������������������*/

User Function M030Inc()
DbSelectarea("CTD")
CTD->(DbSetOrder(1)) // CTD_FILIAL + CTD_ITEM
If CTD->(!DbSeek(xFilial("CTD") + "C" + SA1->A1_COD + SA1->A1_LOJA))
	RecLock("CTD",.T.)
	CTD->CTD_FILIAL := xFilial("CTD")
	CTD->CTD_ITEM := "C" + SA1->A1_COD + SA1->A1_LOJA
	CTD->CTD_CLASSE := "2"
	CTD->CTD_DESC01 := SA1->A1_NOME
	CTD->CTD_RES	:= Alltrim(SA1->A1_NREDUZ)	
	CTD->CTD_CLASSE	:= "2"
	CTD->CTD_NORMAL	:= "0"
	CTD->CTD_BLOQ	:= "2"
	CTD->CTD_DTEXIS	:= StoD("19800101")
	CTD->(MsUnlock())
EndIf
Return