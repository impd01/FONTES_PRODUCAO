#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � lp51008   �Autor  �Mario K.            � Data �  06/05/2019���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// IIF(SA2->A2_XLP510=="1" .OR. SA2->A2_XCONT=="1" .OR. SE2->E2_NATUREZ $ "5004005   /1070001   /1060005   " .OR. SE2->E2_TIPO $ "PR /NDF/AB-" .OR. SE2->E2_PREFIXO=="AGL",0,IIF(SA2->A2_CALCIRF=="2",SE2->(E2_VALOR+E2_ISS+E2_INSS),0))

*/

User function LP51008()    

local nValor := 0

IF SA2->A2_XLP510=="1" .OR. SA2->A2_XCONT=="1" .OR. SE2->E2_NATUREZ $ "5004005   /1070001   /1060005   " .OR. SE2->E2_TIPO $ "PR /NDF/AB-" .OR. SE2->E2_PREFIXO=="AGL"
       
     nValor := 0

ELSEIF SA2->A2_CALCIRF=="2" .AND. ALLTRIM(SE2->E2_ORIGEM)<>"MATA100"
    
    nValor := (SE2->E2_VALOR+SE2->E2_ISS+SE2->E2_INSS)
      
ENDIF
   
Return(nValor)