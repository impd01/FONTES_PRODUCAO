#include 'protheus.ch'
#include 'parmtype.ch'

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP265VALPE   ºAutor  ³Vinicius Henrique     º Data ³27/01/2019    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³GP265VALPE - Ponto de Entrada para Exportar 	        			º±±
º±±							Arquivos de Pastores para TXT						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GP265VALPE()

Local nTpArq
Local aCols := {}

		If Empty(M->RA_XHRQ)
			MsgAlert("Informar a hierarquia do Pastor/Bispo", "Atenção")
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
			M->RA_SALARIO,;	// Salário
			M->RA_XTIPO,;	// Função
			"",;	// Banco Para Deposito de Salário
			"",;	// Tipo de Conta
			"",;	// Numero da Conta
			DTOS(M->RA_ADMISSA),;	// Data de Admissão
			DTOS(M->RA_DEMISSA),;	// Data de Demissão
			M->RA_XHRQ,;
			"",;
			M->RA_CC})		// Hierarquia	
						
			If INCLUI
				nTpArq := 1
			Else
				nTpArq := 2
			Endif
			
			FWMsgRun(, {|oSay| U_GERATXT( 2, M->RA_FILIAL, M->RA_FILIAL, M->RA_MAT, M->RA_MAT, M->RA_CC, M->RA_CC, nTpArq, aCols, oSay ) }, "Integração Boleta Eletrônica", "Gerando Arquivo" )
//			MsgRun("Gerando Arquivo","Aguarde...",{|| U_GERATXT(2, M->RA_FILIAL, M->RA_FILIAL, M->RA_MAT, M->RA_MAT, M->RA_CC, M->RA_CC, nTpArq, aCols) })
				
			Return(.T.)
 
		Endif
		
	Return(.T.)
		
Return
