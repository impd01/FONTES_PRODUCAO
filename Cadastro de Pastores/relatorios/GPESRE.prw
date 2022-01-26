#include "TOTVS.ch"
#include 'FWPRINTSETUP.ch'
#include "RPTDEF.ch"
#include "TBICONN.ch"
#include "TOPCONN.ch"
#include "FILEIO.ch"
#include "COLORS.ch"
#INCLUDE "FWMVCDEF.CH"
#include 'tcbrowse.ch'

// Browse de historico de Transferencias de funcionarios

User Function GPESRE()
    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse   
    Local cTitulo := "Histórico de Transferências"
     
    //Setando o nome da função, para a função customizada
    SetFunName("GPESRE")
     
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse := FWMBrowse():New()
    oBrowse:AddButton ("Visualizar",,,2)
    
    oBrowse:SetAlias("SRE")
    oBrowse:SetDescription(cTitulo)

    oBrowse:Activate()
     
    //Voltando o nome da função
    SetFunName(cFunBkp)
     
    RestArea(aArea)
Return Nil
