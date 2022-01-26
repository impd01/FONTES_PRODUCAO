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
    Local cTitulo := "Hist�rico de Transfer�ncias"
     
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("GPESRE")
     
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o e ativando a navega��o
    oBrowse := FWMBrowse():New()
    oBrowse:AddButton ("Visualizar",,,2)
    
    oBrowse:SetAlias("SRE")
    oBrowse:SetDescription(cTitulo)

    oBrowse:Activate()
     
    //Voltando o nome da fun��o
    SetFunName(cFunBkp)
     
    RestArea(aArea)
Return Nil
