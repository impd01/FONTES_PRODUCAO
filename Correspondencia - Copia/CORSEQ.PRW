#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include 'TopConn.ch'

User Function CORSEQ()

    Begin Transaction
        //Pegando o último código do cliente conforme a SXE / SXF
        cCodigo := GetSXENum('ZS6', 'ZS6_CODPED')
        
        //Perguntando se deseja confirmar esse código, para confirmar e atualizar as tabelas SXE / SXF
        If reclock('ZS6',.T.)
            ConfirmSX8()
        
        //Senão, volta a numeração onde estava    
        Else
            RollBackSX8()
        EndIf
    End Transaction

Return cCodigo
