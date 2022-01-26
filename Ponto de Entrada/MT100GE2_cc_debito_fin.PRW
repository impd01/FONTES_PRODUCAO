User Function MT100GE2()
Local aAreaSD1 := GetArea("SD1")
SD1->(DbSelectArea("SD1"))
SD1->(DbSetOrder(1))
SD1->(DbGotop())
SD1->(DbSeek(xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) )

SE2->(DbSelectArea("SE2"))
Se2->(RecLock("SE2"))
SE2->E2_CCD := SD1->D1_CC
SE2->E2_XHIST	:= SF1->F1_MENNOTA
SE2->E2_HIST	:= SF1->F1_MENNOTA
SE2->(MsUnLock())

RestArea(aAreaSD1)
Return()