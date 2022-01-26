#INCLUDE "RWMAKE.CH"        

/*���������������������������������������������������������������������������
���Programa  �PAGVENC   �Autor  �Eduardo Augusto     � Data �  26/02/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Declaracao de variaveis utilizadas no programa atraves da   ���
���			 �funcao SetPrvt, que criara somente as variaveis definidas   ���
���			 �pelo usuario, identificando as variaveis publicas do sistema���
���			 �utilizadas no codigo. 									  ���
��� 		 �Incluido pelo assistente de conversao do AP5 IDE 			  ���
��� 		 �															  ���
��� 		 �"VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS."			  ���
���          �CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (139-150)         ���
�������������������������������������������������������������������������͹��
���Uso       � Shoeller								                      ���
���������������������������������������������������������������������������*/

User Function PAGVENC()
SetPrvt("_VENCVAL")
// VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS 
_VENCVAL  :=  ""
IF !Empty(SE2->E2_CODBAR)
   _VENCVAL := PADL(SUBSTR(SE2->E2_CODBAR,6,14),14,"0")
EndIf
IF Empty(_VENCVAL)                                
	If !EMPTY(SE2->E2_ACRESC) .OR. !EMPTY(SE2->E2_DECRESC)
  	 	_VENCVAL := STRZERO(SE2->(E2_SALDO + E2_ACRESC - E2_DECRESC)*100,14)        
 	ElseIf EMPTY(SE2->E2_ACRESC) .OR. EMPTY(SE2->E2_DECRESC)
  		_VENCVAL  :=  "00000000000000"
    EndIf
EndIf
Return(_VENCVAL)