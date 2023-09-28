#Include 'Protheus.ch'
#INCLUDE "RPTDEF.CH"

User Function gatcusto()

Local aArea     := GetArea()
Local cConta    := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
Local cCusto    := ' '

dbSelectArea("CT1")
CT1->(dbSetOrder(1))

If CT1->(MsSeek(XFILIAL("CT1")+cConta))
    cCusto := CT1->CT1_CONTA
Endif

RestArea(aArea)

Return (cCusto)
