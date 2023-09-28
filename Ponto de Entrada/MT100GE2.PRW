#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT100GE2()

Local nOpc := PARAMIXB[2]

    dbSelectArea("SED")
    SED->(dbSetOrder(1))

    If nOpc == 1 //.. inclusao

        If SED->(msSeek(xFilial("SED")+SE2->E2_NATUREZA))
            SE2->E2_XDNATUR:= SED->ED_DESCRIC
            SE2->E2_CCD    := SD1->D1_CC
        Endif

    Endif

Return
