#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Cadastro de Residencias"
 
/*/{Protheus.doc} zModel1
Exemplo de Modelo 1 para cadastro de Artistas
@author Atilio
@since 31/07/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_zModel1()
/*/
 
User Function xBrowseCad()

    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("xBrowseCad")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZB1")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "ZB1->ZB1_ENTRE = '1'", "GREEN",   "Entregue" )
    oBrowse:AddLegend( "ZB1->ZB1_ENTRE = '2'", "BLUE",    "Em processo de entrega" )
    oBrowse:AddLegend( "ZB1->ZB1_STS   = '9'", "RED",     "Desativado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZ1->ZZ1_COD >= '000000' .And. ZZ1->ZZ1_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    //RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.xBrowseCad' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1ZB'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.xBrowseCad' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.xBrowseCad' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.xBrowseCad' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStZZ1 := FWFormStruct(1, "ZB1")
    
    /*//Editando características do dicionário
    oStZZ1:SetProperty('ZZ1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStZZ1:SetProperty('ZZ1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ1", "ZZ1_COD")'))         //Ini Padrão
    oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Validação de Campo
    oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório*/
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zModel1M",/*bPre*/, {||valid(oModel)},/*bCommit*/,/*bCancel*/) 
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZ1",/*cOwner*/,oStZZ1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZB1_FILIAL','ZB1_COD'})
     
    /*//Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)*/
     
    /*//Setando a descrição do formulário
    oModel:GetModel("FORMZZ1"):SetDescription("Formulário do Cadastro "+cTitulo)*/
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZZ1    := ZB1->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("xBrowseCad")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZ1 := FWFormStruct(2, "ZB1")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
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
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZZ1)
        cCampoAux := Alltrim(aStruZZ1[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStZZ1:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView

Static Function valid(oModel)
    Local lRet      := .T.
    Local nOperation:= oModel:GetOperation()    //Função para identificar operação feita no MVC 
    Local aDet      := {}
    Local cTipo 
        if nOperation == 3
            cTipo := 'I'
        elseIf nOperation == 4
            cTipo := 'A'
        elseIf nOperation == 5
            cTipo := 'E'
        endIf
            aAdd(aDet,{cTipo,;
                FWFldGet("ZB1_COD"),;							
				FWFldGet("ZB1_NOME"),;	    // Nome Residencia
				FWFldGet("ZB1_ENTRE"),;	    // Imovel em fase de entrega?
				FWFldGet("ZB1_JURI"),;	    // Imovel me juridico?
				FWFldGet("ZB1_IGJ"),;	    // Cod Igreja
				FWFldGet("ZB1_DESCIG"),;	// Descricao Igreja
				FWFldGet("ZB1_CC"),;		// Centro de custo
				FWFldGet("ZB1_END"),;	    // Endereço da residencia
				FWFldGet("ZB1_NUM"),;	    // Número da residencia 
				FWFldGet("ZB1_CEP"),;	    // CEP da residencia
				FWFldGet("ZB1_COD_MU"),;	// Cod do municipio
				FWFldGet("ZB1_DESC_M"),;	// Descricao do municipio 
				FWFldGet("ZB1_COD_ES"),;	// Estado 
				FWFldGet("ZB1_ALUG"),;
                FWFldGet("ZB1_STS")})       // Desativado ?
        U_IMBLT010(aDet)
Return lRet
 
 
User Function zMod1ZB()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",   "Entregue"  })
    AADD(aLegenda,{"BR_AZUL",    "Em processo de entrega"})
    AADD(aLegenda,{"BR_VERMELHO","Desativado"})
    BrwLegenda(cTitulo, "Status", aLegenda)
Return
