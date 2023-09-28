#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOTVS.CH'
/*
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | F050IRF   | Autor | Gilberto Sales                         |*
*+------------+------------------------------------------------------------+*
*|Data        | 25-02-2022                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Alterara valor titulo IRPF para assumir valor Digitado     |*
*+------------+------------------------------------------------------------+*
*|Partida     | Protheus                                                   |*
*+-------------------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteracao                      |*
*+-------------------+----------+------------------------------------------+*
*| 					         | 	    		|                              |*
*+-------------------------------------------------------------------------+*
******************************************************************************/
USER FUNCTION F050IRF()

	Default nIrrf := 0

	If Alltrim(SE2->E2_CODRET) == '3208' .And. SE2->E2_VALOR != nIrrf
		If MsgYesNo('Confirma valor do IRPF: '+ cValtoChar(nIrrf) + ' ?')
			SE2->(RecLock( "SE2", .F. ))
			SE2->E2_VALOR  := nIrrf
			SE2->E2_SALDO  := nIrrf
			SE2->E2_VLCRUZ := nIrrf
			SE2->(dbCommit())
			SE2->(MsUnlock())
		EndIf
	EndIf

Return



