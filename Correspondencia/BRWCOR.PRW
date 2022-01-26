#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"

#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include 'TopConn.ch'
 
 // Rotina para gestão de Destinatários da correspondencia 

Static cTitulo := "Cadastro Destinatários de correspondências"
//Static aArray  := {}

User Function BRWCOR()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
    Local aArray  := {}
     
    SetFunName("BRWCOR")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZS9")
    oBrowse:setArray(aArray)
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

      //Legendas
    /*oBrowse:AddLegend( "ZS9->ZS9_STSENV = '1'", "YELLOW", "Espera de emissão de etiqueta" )
    oBrowse:AddLegend( "ZS9->ZS9_STSENV = '2'", "BLUE", "Etiqueta emitida" )*/

    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Edit:  Felipe Barros                                                |
 | Data:                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}

    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar'                  ACTION 'VIEWDEF.BRWCOR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'                     ACTION 'u_zMod1Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'                     ACTION 'VIEWDEF.BRWCOR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'                     ACTION 'VIEWDEF.BRWCOR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'                     ACTION 'VIEWDEF.BRWCOR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    //ADD OPTION aRot TITLE 'Impressão Etiq.(PIMACO)'     ACTION 'u_IMPCOR'       OPERATION 6 ACCESS 0 //OPERATION 5

Return aRot
 /*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Edit:  Felipe Barros                                                |
 | Data:                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStZZ1 := FWFormStruct(1, "ZS9")
      
    
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("BRWCORM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZ1",/*cOwner*/,oStZZ1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZS9_FILIAL','ZS9_COD'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription(cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZZ1"):SetDescription(cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Edit:  Felipe Barros                                                |
 | Data:                                                     |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Local aStruZZ1    := ZZ1->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("BRWCOR")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZ1 := FWFormStruct(2, "ZS9")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZZ1", oStZZ1, "FORMZZ1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_ZZ1', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_ZZ1","TELA")
     
Return oView
