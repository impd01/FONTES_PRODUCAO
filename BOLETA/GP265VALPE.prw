#include 'protheus.ch'
#include 'parmtype.ch'

/* 
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �GP265VALPE   �Autor  �Vinicius Henrique     � Data �27/01/2019    ���
�������������������������������������������������������������������������������͹��
���Descricao �GP265VALPE - Ponto de Entrada para Exportar 	        			���
���							Arquivos de Pastores para TXT						���
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

User Function GP265VALPE()

Local nTpArq
Local aCols := {}

		If Empty(M->RA_XHRQ)
			MsgAlert("Informar a hierarquia do Pastor/Bispo", "Aten��o")
			Return(.F.)
		Endif

		If 	(SRA->RA_FILIAL <> M->RA_FILIAL .Or. ;
			SRA->RA_MAT <> M->RA_MAT .Or. ;
			SRA->RA_NOME <> M->RA_NOME .Or. ;
			SRA->RA_NASC <> M->RA_NASC .Or. ;
			SRA->RA_SEXO <> M->RA_SEXO .Or. ;
			SRA->RA_CIC <> M->RA_CIC .Or. ;
			SRA->RA_RG <> M->RA_RG .Or. ;
			SRA->RA_ESTCIVI <> M->RA_ESTCIVI .Or. ;
			SRA->RA_XCONJUG <> M->RA_XCONJUG .Or. ;
			SRA->RA_XIGJATU <> M->RA_XIGJATU .Or. ;
			SRA->RA_SALARIO <> M->RA_SALARIO .Or. ;
			SRA->RA_XTIPO <> M->RA_XTIPO .Or. ;
			SRA->RA_BCDEPSA <> M->RA_BCDEPSA .Or. ;
			SRA->RA_CTDEPSA <> M->RA_CTDEPSA .Or. ;
			SRA->RA_ADMISSA <> M->RA_ADMISSA .Or. ;
			SRA->RA_DEMISSA <> M->RA_DEMISSA .Or. ;
			SRA->RA_XHRQ <> M->RA_XHRQ .Or. ;
			SRA->RA_CC <> M->RA_CC)
			
			aAdd(aCols,{.F.,;
			M->RA_FILIAL,;	// Filial
			M->RA_MAT,;		// Matricula
			M->RA_NOME,;		// Nome Completo
			DTOS(M->RA_NASC),;		// Data de Nascimento
			M->RA_SEXO,;		// Sexo
			M->RA_CIC,;		// CPF
			M->RA_RG,;		// RG
			M->RA_ESTCIVI,;	// Estado Civil
			M->RA_XCONJUG,;	// Nome Conjuge
			M->RA_XIGJATU,;	// Igreja Superior
			M->RA_SALARIO,;	// Sal�rio
			M->RA_XTIPO,;	// Fun��o
			"",;	// Banco Para Deposito de Sal�rio
			"",;	// Tipo de Conta
			"",;	// Numero da Conta
			DTOS(M->RA_ADMISSA),;	// Data de Admiss�o
			DTOS(M->RA_DEMISSA),;	// Data de Demiss�o
			M->RA_XHRQ,;
			"",;
			M->RA_CC})		// Hierarquia	
						
			If INCLUI
				nTpArq := 1
			Else
				nTpArq := 2
			Endif
			
			FWMsgRun(, {|oSay| U_GERATXT( 2, M->RA_FILIAL, M->RA_FILIAL, M->RA_MAT, M->RA_MAT, M->RA_CC, M->RA_CC, nTpArq, aCols, oSay ) }, "Integra��o Boleta Eletr�nica", "Gerando Arquivo" )
//			MsgRun("Gerando Arquivo","Aguarde...",{|| U_GERATXT(2, M->RA_FILIAL, M->RA_FILIAL, M->RA_MAT, M->RA_MAT, M->RA_CC, M->RA_CC, nTpArq, aCols) })
				
			Return(.T.)
 
		Endif
		
	Return(.T.)
		
Return
