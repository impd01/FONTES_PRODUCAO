//Bibliotecas
#Include "Protheus.ch"
 
User Function zTstWeb(cCod)

    Local aArea       := GetArea()
    Local cNomeImg    := cCod
    Local cNomeFim    := ""
    Local aRet        := {}
    Local oRepository
    Local oDlg
    Local lPut
    Local nTamanImg   := TamSX3('ZA1_BITMAP')[01]
    Local nAtual      := 0
    Local oObjeto
    Local oPai        := GetWndDefault()

    //Chama a rotina para gerar a imagem da WebCam
    aRet := u_zPegaWeb(cNomeImg)
     
    //Se a rotina foi confirmada
    If aRet[1]
        DEFINE MSDIALOG oDlg TITLE "Atualizando imagem do cliente" FROM 000, 000  TO 080, 100 PIXEL
            //Criando o repositório de imagens
            @ 000,000 REPOSITORY oRepository SIZE 0,0 OF oDlg
             
            //Pegando a imagem
            cNomeFim := Upper(AllTrim(aRet[2]))
            cNomeFim := SubStr(cNomeFim, RAt("\", cNomeFim)+1, Len(cNomeFim))
            cNomeFim := StrTran(cNomeFim, ".BMP", "")
            cNomeFim := SubStr(cNomeFim, 1, nTamanImg)
             
            //Se existir a imagem no repositório, exclui
            If oRepository:ExistBmp(cNomeFim)
                oRepository:DeleteBmp(cNomeFim)
            EndIf
             
            //Insere a imagem no repositório
            lPut := .T.
            oRepository:InsertBmp(aRet[2], cNomeFim, @lPut)
             
            //Se deu certo a inserção
            If lPut
                M->ZA1_BITMAP := "000010"

                //Percorre todos os campos da Enchoice
                For nAtual := 1 to Len( oPai:aControls )
                    //Se não for do tipo objeto, pula
                    If ValType(oPai:aControls[nAtual]) != 'O'
                        Loop
                    Endif
                     
                    //Pega o objeto
                    oObjeto := oPai:aControls[nAtual]
                     
                    //Se for do tipo Imagem, atualiza a imagem
                    If oObjeto:ClassName() == 'FWIMAGEFIELD'
                        //Primeiro, é setado qualquer imagem, apenas para forçar o refresh, pois a imagem da webcam terá o mesmo nome
                        oObjeto:oImagem:cBMPFile := "ok.png"
                        oObjeto:Refresh()
                         
                        //Agora é setado a imagem
                        oObjeto:oImagem:cBMPFile := aRet[2]
                        oObjeto:Refresh()
                    Endif
                Next
                 
                //Atualiza a Enchoice
                GetDRefresh()
            EndIf
             
        ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oDlg:End())
    EndIf
     
    RestArea(aArea)
Return

Static Function INCLUI()

Private cCadastro 	:= "Inclusão de Visitante"

	Axinclui("ZA1",Recno(),3)

Return