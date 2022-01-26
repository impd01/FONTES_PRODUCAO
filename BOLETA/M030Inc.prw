#INCLUDE "PROTHEUS.CH"

/* 
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �M030Inc   �Autor  �Vinicius Henrique     � Data �05/02/2019 	    ���
�������������������������������������������������������������������������������͹��
���Descricao �M030Inc - Ponto de Entrada para Exportar 	    	    			���
���							Arquivos de Igrejas para TXT						���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�������������������������������������������������������������������������������͹��
���Retorno   �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       �Igreja Mundial do Poder de Deus                                   ���
�������������������������������������������������������������������������������͹��
���Revisao   �           �Autor  �                      � Data �                ���
�������������������������������������������������������������������������������͹��
���Descricao �                                                                  ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/

User Function M030Inc()

Local aCols := {}

If INCLUI .And. !EMPTY(Alltrim(M->A1_NOME))

	aAdd(aCols,{'I',;
	"      ",;
	M->A1_COD,;
	M->A1_NOME,;
	M->A1_END,;
	M->A1_XNUMERO,;
	M->A1_BAIRRO,;
	M->A1_COD_MUN,;
	M->A1_MUN,;
	M->A1_EST,;
	M->A1_CEP,;
	M->A1_XCC,;
	M->A1_XSUP,;
	M->A1_XSTATUS})
	
	FWMsgRun(, {|oSay| U_GERATXTI(,,,,,"M030INC", aCols) }, "Integra��o Boleta Eletr�nica", "Gerando Arquivo" )

Endif
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