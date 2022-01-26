#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"

#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include 'TopConn.ch'
 
 // Rotina para gestão de Pedidos da correspondencia 

Static cTitulo := "Cadastro de Pedidos correspond�ncias"
//Static aArray  := {}
    
User Function BRWCORP()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
    Local aArray  := {}
     
    SetFunName("BRWCORP")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZS6")
    oBrowse:setArray(aArray)
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

      //Legendas
    oBrowse:AddLegend( "ZS6->ZS6_STSENV = '1'", "YELLOW", "Espera de emiss�o de etiqueta" )
    oBrowse:AddLegend( "ZS6->ZS6_STSENV = '2'", "BLUE"  , "Etiqueta emitida" )
    oBrowse:AddLegend( "ZS6->ZS6_STSENV = '3'", "GRAY"  , "Fila de impress�o" )

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

    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar'                  ACTION 'VIEWDEF.BRWCORP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'                     ACTION 'u_zMod1Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'                     ACTION 'VIEWDEF.BRWCORP' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'                     ACTION 'VIEWDEF.BRWCORP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'                     ACTION 'VIEWDEF.BRWCORP' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Impress�o Etiq.(PIMACO)'     ACTION 'u_IMPCOR'       OPERATION 6 ACCESS 0 //OPERATION 5

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
    Local oStZZ1 := FWFormStruct(1, "ZS6")
      
    
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("BRWCORPM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZ1",/*cOwner*/,oStZZ1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZS6_FILIAL','ZS6_CODPED'})
     
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
    Local oModel := FWLoadModel("BRWCORP")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZ1 := FWFormStruct(2, "ZS6"/*, { |x| ALLTRIM(x) $ 'ZS6_CODPED, ZS6_CODD' }*/)  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
    //Local oStZZ2 := FWFormStruct(2, "ZS6", { |x| ALLTRIM(x) $ 'ZA1_MUSICA, ZA1_TITULO' })
     
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


User Function zMod1Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_AZUL",   "Etiqueta emitida"  })
    AADD(aLegenda,{"BR_AMARELO","Espera de emiss�o de etiqueta"})
    AADD(aLegenda,{"BR_CINZA"  ,"Fila de impress�o"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
Return

// Impressão das etiquetas no padrão das PIMACO
User Function IMPCOR()

    Local cStatus := '1'

    Local lAdjustToLegacy := .F.
    Local lDisableSetup   := .T.
    Local cLocal          := "\spool"
    Local oPrinter
    Local cData           := DTOS(Date()) + "_" + StrTran(Time(),":",)

    Local nLinha 
    Local nLinhaE
    Local nLinhaD
    Local nAux  := 0
    Local nAuxD := 0

    Local aCols 
    Local cQuery
    Local cAlias	      := GetNextAlias()

        cQuery	:= "SELECT *,ZS6_CODPED FROM ZS9010, ZS6010    " + CRLF
        cQuery	+= "WHERE ZS9010.D_E_L_E_T_ = ''               " + CRLF
        cQuery	+= "AND ZS6010.D_E_L_E_T_ = ''                 " + CRLF
        cQuery	+= "AND ZS6_STSENV = '"+cStatus+"'             " + CRLF
        cQuery	+= "AND ZS9_COD = ZS6_CODD                     " + CRLF
		

		MEMOWRITE("BRWCORP.SQL",cQuery)
	
		TCQUERY cQuery NEW ALIAS (cAlias)

		aCols		:= {}

		Do While !(cAlias)->(Eof()) 
	
			aAdd(aCols,{(cAlias)->ZS9_NOME  ,;
                        (cAlias)->ZS9_END   ,;	
                        (cAlias)->ZS9_NUM   ,;
                        (cAlias)->ZS9_BAIRRO,;	
                        (cAlias)->ZS9_DMUN  ,;	
                        (cAlias)->ZS9_CEP   ,;
                        (cAlias)->ZS9_EST   ,;
                        (cAlias)->ZS6_CODPED})	  
	
			            (cAlias)->(DbSkip())
		EndDo

    if Len(aCols) > 14
        MsgAlert("Existem mais de 14 cadastros esperando para serem impressos!", "Aten��o!")
        Return
    EndIf
    
    oPrinter := FWMSPrinter():New("rel_etiquetas_"+cData, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )

    oPrinter:Say( 40, 30, "Etiquetas geradas para folhas PIMACO 6282:")    
    
        For nLinha := 1 to Len(aCols)

            if nLinha <= 7 
                for nLinhaE := 90 to 700
                    nLinhaE += nAux 

                        if nAux <> 0
                            nLinhaE -= 90
                        EndIf
                    
                    if nLinhaE <= 700
                        //Direita da folha PIMACO
                        oPrinter:Say( nLinhaE, 50, allTrim(aCols[nLinha][1]))
                            nLinhaE += 15
                        oPrinter:Say( nLinhaE, 50, allTrim(aCols[nLinha][2]) +", "+alltrim(aCols[nLinha][3]))
                            nLinhaE += 10
                        oPrinter:Say( nLinhaE, 50, allTrim(aCols[nLinha][4]))
                            nLinhaE += 10
                        oPrinter:Say( nLinhaE, 50, allTrim(aCols[nLinha][5]))
                            nLinhaE += 10
                        oPrinter:Say( nLinhaE, 50, allTrim(TRANSFORM(aCols[nLinha][6], "@R 99999-999")))
                            //nLinhaE += 10
                        oPrinter:Say( nLinhaE, 150, allTrim(aCols[nLinha][7]))
                            nLinhaE += 10
                        oPrinter:Say( nLinhaE,150, "Ped.: " + allTrim(aCols[nLinha][8]))
                       // oPrinter:Say( nLinhaE,50, "Qtd.I: " + allTrim(aCols[nLinha][9]))
                            nLinhaE += 40

                            nAux := nLinhaE                            
                        exit
                    EndIf                
                next nLinhaE += 15

            else 
                                
                for nLinhaD := 90 to 700
                    nLinhaD += nAuxD

                        if nAuxD <> 0
                            nLinhaD -= 90
                        EndIf
                    
                    if nLinhaD <= 700
                        //Direita da folha PIMACO
                        oPrinter:Say( nLinhaD, 350, allTrim(aCols[nLinha][1]))
                            nLinhaD += 15
                        oPrinter:Say( nLinhaD, 350, allTrim(aCols[nLinha][2]) +", "+alltrim(aCols[nLinha][3]))
                            nLinhaD += 10
                        oPrinter:Say( nLinhaD, 350, allTrim(aCols[nLinha][4]))
                            nLinhaD += 10
                        oPrinter:Say( nLinhaD, 350, allTrim(aCols[nLinha][5]))
                            nLinhaD += 10
                        oPrinter:Say( nLinhaD, 350, allTrim(TRANSFORM(aCols[nLinha][6], "@R 99999-999")))
                            //nLinhaE += 10
                        oPrinter:Say( nLinhaD, 450, allTrim(aCols[nLinha][7]))
                            nLinhaD += 10
                        oPrinter:Say( nLinhaD,450, "Ped.: " + allTrim(aCols[nLinha][8]))
                        //oPrinter:Say( nLinhaD,350, "Qtd.I: " + allTrim(aCols[nLinha][9]))
                            nLinhaD += 40

                            nAuxD := nLinhaD                            
                        exit
                    EndIf                
                next nLinhaD += 15                               
            EndIf

        next nLinha 
        
    oPrinter:Setup()

    if oPrinter:nModalResult == PD_OK
        oPrinter:Preview()   
        
            // Update nos cadastros de destinatários do browse
            dbSelectArea("ZS6")
            dbSetOrder(1)
        
            While ZS6->(!Eof()) .And. ZS6->ZS6_FILIAL == xFilial("ZS6") 
                If ZS6->ZS6_STSENV <>'3'
                    If RecLock("ZS6",.f.)
                        ZS6->ZS6_STSENV := "2"
                        MsUnlock()
                    Endif
                ENDIF
                ZS6->(dbSkip(1))
            Enddo
            MsgAlert("Registros impressos atualizados!", "Aten��o")     
    ELSE 
        Return
    EndIf
Return
