User Function MT100GE2()

    Local aArea    := GetArea()
    Local aAreaSD1 := SD1->(GetArea())
     
    DbSelectArea('SE2')
    DbSelectArea('SD1')
    SD1->(DbSetOrder(1))
    SD1->(DbGoTop())
     
    //Posiciona no primeiro item do documento de entrada
    If SD1->(MsSeek(FWxFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) )
        RecLock("SE2", .F.)
            SE2->E2_CCD     := SD1->D1_CC
            SE2->E2_XHIST	:= SF1->F1_MENNOTA
            SE2->E2_HIST	:= SF1->F1_MENNOTA
        SE2->(MsUnLock())
    EndIf
 
    RestArea(aAreaSD1)
    RestArea(aArea)
    
Return
