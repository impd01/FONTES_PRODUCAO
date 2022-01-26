#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AUTOMATIC      �Autor�Vinicius Henrique	�Data�  04/08/2017���
�������������������������������������������������������������������������͹��
���              Desc.     �Excluir baixas dos titulos                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MXUPIS()
	
	Processa({||Atualiza()},"Aguarde, Atualizando Registros")
	
Return

Static Function Atualiza()
Local cAlias	:= GetNextAlias()
Local aCols		:= {}
Local cQuery	:= ""
Local dEmissao
Local cHist		:= ""
Local nx

Private lMsErroAuto := .F.

		cQuery := " SELECT * "
		cQuery += " FROM "+RetSQLName("SE2")+" SE2	"
		cQuery += " WHERE D_E_L_E_T_ = ' '	"
		cQuery += " AND E2_XIDAGL > ' '	"
		cQuery += " AND E2_BAIXA >= '20180101' "
		cQuery += " AND E2_NUM = '000003385'"
	
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{(cAlias)->E2_NUM,;			
			(cAlias)->E2_PARCELA,;
			(cAlias)->E2_FORNECE,;
			(cAlias)->E2_LOJA})
			
			(cAlias)->(dbSkip())
						
		EndDo
		
		(cAlias)->(DbGoTop())
				
		ProcRegua(Reccount())

		For nx := 1 To Len(aCols)

		DbSelectArea("SE2")
		SE2->(dbSetOrder(24))
		SE2->(dbGoTop())
			
			If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][8]+aCols[nx][9]))
			
			IncProc("Atualizando T�tulo: " + SE2->E2_NUM)
			
						If SE2->E2_SALDO == 0
						
							cHistBaixa := "Valor pago s/ Titulo"
							//�������������������������������������������������������������������������
							//�Monta array com os dados para o cancelamento da baixa a pagar do t�tulo�
							//������������������������������������������������������������������������� 
							aBaixa 	:= {}
							
							AADD(aBaixa, {"E2_FILIAL" 	, 	SE2->E2_FILIAL 	, 	Nil})
							AADD(aBaixa, {"E2_PREFIXO" 	, 	SE2->E2_PREFIXO , 	Nil})
							AADD(aBaixa, {"E2_NUM" 		, 	SE2->E2_NUM 	, 	Nil})
							AADD(aBaixa, {"E2_PARCELA" 	, 	SE2->E2_PARCELA ,	Nil})
							AADD(aBaixa, {"E2_TIPO" 	, 	SE2->E2_TIPO 	, 	Nil})
							AADD(aBaixa, {"E2_FORNECE" 	, 	SE2->E2_FORNECE , 	Nil})
							AADD(aBaixa, {"E2_LOJA" 	, 	SE2->E2_LOJA 	, 	Nil}) 
							AADD(aBaixa, {"AUTVLRPG" 	, 	SE2->E2_VALOR 	, 	Nil})
							
							MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 6)							
							
												
						Endif
						
			Else
//					Alert("O t�tulo a pagar n�o foi localizado")
			EndIf
		
		Next nx
		
return
