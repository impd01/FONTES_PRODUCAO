#INCLUDE "RWMAKE.CH"

/*���������������������������������������������������������������������������
���Programa  �CNPJCPF   �Autor  �Eduardo Augusto     � Data �  26/02/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fonte desenvolvido para tratamento do CNPJ e CPF do       ���
���          �  Banco Bradesco                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Shoeller						                              ���
���������������������������������������������������������������������������*/

User Function CNPJCPF()

Local _cCNPJCPF := Padl(AllTrim(SA2->A2_CGC),15,"0")
If Len(AllTrim(SA2->A2_CGC)) == 11
	_cCNPJCPF := Left(SA2->A2_CGC,9)
	_cCNPJCPF += "0000"
	_cCNPJCPF += SubStr(SA2->A2_CGC,10,2)
EndIf
Return(_cCNPJCPF)