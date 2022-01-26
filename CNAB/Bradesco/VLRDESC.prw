#INCLUDE "PROTHEUS.CH"

#DEFINE cEnter Chr(13) + Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VLRDESC   ºAutor  ³Eduardo Augusto     º Data ³  08/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Fonte para calculo de Desconto de Impostos para o Banco   º±±
±±º          ³  Sispag ITAU 240 Posições. (Posição 120 a 134)             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Igreja Mundial                                             º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function VLRDESC()

Local nLiquid := 0
Local _cBanco := SE2->E2_PORTADO
Local cQuery  := ""

DbSelectArea("SA2")
DbSetOrder(1)                                                         
DbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA)

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
cQuery := " SELECT SUM(E2_SALDO) E2_SALDO FROM "									+ cEnter
cQuery += RetSqlName("SE2")															+ cEnter
cQuery += " WHERE D_E_L_E_T_ = ' ' "												+ cEnter
cQuery += " AND E2_FORNECE = '"+SE2->E2_FORNECE + "' "								+ cEnter
cQuery += " AND E2_LOJA = '"+SE2->E2_LOJA + "' "									+ cEnter
cQuery += " AND SUBSTRING(E2_VENCREA,1,6) = '" + Substr(DtoS(dDataBase),1,6) + "' "	+ cEnter
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","E2_SALDO" ,"N",12,2)

DbSelectArea("TMP")
DbGoTop()

If _cBanco == "341"
	nLiquid := PadL(StrTran( Alltrim(StrTran(Transform(TMP->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC - (SE2->E2_CSLL + SE2->E2_COFINS + SE2->E2_PIS + SE2->E2_INSS),"@E 999,999,999,999.99"),",","")),".",""), 15, "0" )
ElseIf _cBanco =="033"
	nLiquid := PadL(StrTran( Alltrim(StrTran(Transform(TMP->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC - (Iif(TMP->E2_SALDO < 5000,0,SE2->E2_CSLL) + Iif(TMP->E2_SALDO < 5000,0,SE2->E2_COFINS) + Iif(TMP->E2_SALDO < 5000,0,SE2->E2_PIS) + Iif(SA2->A2_RECISS == "S",SE2->E2_ISS,0) + SE2->E2_INSS),"@E 999,999,999,999.99"),",","")),".",""), 13, "0" )
Else                                                                                                                        
	nLiquid := PadL(StrTran( Alltrim(StrTran(Transform(TMP->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC -  (SE2->E2_CSLL + SE2->E2_COFINS + SE2->E2_PIS + SE2->E2_INSS),"@E 999,999,999,999.99"),",","")),".",""), 15, "0" )
EndIf

DbSelectArea("TMP")
DbCloseArea()

Return nLiquid
