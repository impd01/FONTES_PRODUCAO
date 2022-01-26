#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

/* 
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �GP180TRA   �Autor  �Vinicius Henrique     � Data �05/02/2019 	    ���
�������������������������������������������������������������������������������͹��
���Descricao �GP180TRA - Ponto de Entrada para Exportar 	   	    			���
���							Arquivos de Pastores para TXT (Transferencia)		���
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

User Function GP180TRA()

Local aCols := {}
Local nOpc	:= 0

			aAdd(aCols,{.F.	  ,;
			M->RA_FILIAL	  ,;	// Filial
			M->RA_MAT		  ,;	// Matricula
			M->RA_NOME		  ,;	// Nome Completo
			DTOS(M->RA_NASC)  ,;	// Data de Nascimento
			M->RA_SEXO		  ,;	// Sexo
			M->RA_CIC		  ,;	// CPF
			M->RA_RG		  ,;	// RG
			M->RA_ESTCIVI	  ,;	// Estado Civil
			M->RA_XCONJUG	  ,;	// Nome Conjuge
			"      "		  ,;	// Igreja Superior
			M->RA_SALARIO	  ,;	// Sal�rio
			M->RA_XTIPO		  ,;	// Fun��o
			"",;					// Banco Para Deposito de Sal�rio
			"",;					// Tipo de Conta
			"",;					// Numero da Conta
			DTOS(M->RA_ADMISSA),;	// Data de Admiss�o
			DTOS(M->RA_DEMISSA),;	// Data de Demiss�o
			M->RA_XHRQ		   ,;
			""				   ,;
			M->RA_CC})				// Hierarquia	
			
			nOpc := 2

			FWMsgRun(, {|oSay| U_GERATXT(2, M->RA_FILIAL, M->RA_FILIAL, M->RA_MAT, M->RA_MAT, M->RA_CC, M->RA_CC, nOpc, aCols) }, "Integra��o Boleta Eletr�nica", "Gerando Arquivo" )

			RecLock("SRA",.F.)
				SRA->RA_XCC := M->RA_CC
			SRA->(MsUnlock())
			
	Return(.T.)

Return


/*Static Function CODIGRJ(cCCusto)

Local cAlias	:= GetNextAlias() 
Local cQuery	:= ""

	cQuery	:= "SELECT A1_XSTATUS					" 		+ CRLF
	cQuery	+= "FROM SA1010							"	 	+ CRLF
	cQuery	+= "WHERE A1_XCC = '" + cCCusto + "'	"	 	+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(dbGoTop())
	
	If (cAlias)->A1_XSTATUS == 'S'
		nOpc := 1
	Else
		nOpc := 2
	Endif
	
Return(nOpc)
*/