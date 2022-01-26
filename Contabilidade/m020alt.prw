#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �m020alt   �Autor�Adilson Gomes         � Data � 31/03/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a grava��o do Item Cont�bil (CTD) autom�ticamente   ���
���          � Conforme defini��o do projeto, o item cont�bil registrar�  ���
���          � a contabiliza��o de Cliente e Fornecedores, permitindo     ���
���          � que a contabilidade tenha um plano de contas.              ���
���          �                                                            ���
���          � O cadastro dos itens cont�beis ser� composto de:           ���
���          � Fornecedores: "F" + SA2->A2_COD + SA2->A2_LOJA             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico da BMA/SIGAFIN                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M020ALT()
//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������
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