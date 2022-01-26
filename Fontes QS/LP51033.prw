#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP51033   �Autor  �Mario K.            � Data �  06/05/2019���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// IIF(!SUBSTR(SE2->E2_NUM,1,3)$ "AUT" .AND. ALLTRIM(SE2->E2_NATUREZ) $ "5004008/1060002/5004007/5004008/5005001/5005007/5005034/5005040/5006013/5006024/5007001/5008001/5009002/5010001" .AND. !SA2->A2_CALCIRF$"1/2",SE2->E2_VALOR, 0)
//IIF(!SUBSTR(SE2->E2_NUM,1,3)$ "AUT" .AND. ALLTRIM(SE2->E2_NATUREZ) $ "5004008/1060002/5004007/5004008/5005001/5005007/5005034/5005040/5006013/5006024/5007001/5008001/5009002/5010001" .AND. !SA2->A2_CALCIRF$"1/2",SE2->E2_VALOR, 0)                         
*/

User function LP51033()

local nValor := 0

IF !SUBSTR(SE2->E2_NUM,1,3)$ "AUT" .AND. ALLTRIM(SE2->E2_NATUREZ) $ "5004008/1060002/5004007/5004008/5005001/5005007/5005034/5005040/5006013/5006024/5007001/5008001/5009002/5010001" .AND. !SA2->A2_CALCIRF$"1/2" .AND. ALLTRIM(SE2->E2_ORIGEM)<>"MATA100"
	
	nValor := SE2->E2_VALOR
	
ELSE
	
	nValor := 0
	
EndIF

Return(nValor)