#INCLUDE "RWMAKE.CH"  

#DEFINE cEnter Chr(13) + Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VALTOT    ºAutor  ³Eduardo Augusto     º Data ³  26/02/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Declaracao de variaveis utilizadas no programa atraves da   º±±
±±º			 ³funcao SetPrvt, que criara somente as variaveis definidas   º±±
±±º			 ³pelo usuario, identificando as variaveis publicas do sistemaº±±
±±º			 ³utilizadas no codigo. 									  º±±
±±º 		 ³Incluido pelo assistente de conversao do AP5 IDE 			  º±±
±±º 		 ³															  º±±
±±º 		 ³"RETORNA A SOMA TOTAL E OS DESCONTOS SE INFORMADO."	 	  º±±
±±º          ³CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (139-150)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shoeller								                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VALTOT() 

Local cQuery 	:= ""
Local nSaldo	:= 0

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
cQuery := " SELECT SUM((E2_SALDO + E2_ACRESC - E2_DECRESC) - (E2_INSS + E2_PIS + E2_COFINS + E2_CSLL)) SALDO FROM "	+ cEnter
cQuery += RetSqlName("SE2") 																			+ cEnter																
cQuery += " WHERE D_E_L_E_T_ = ' ' "																	+ cEnter
cQuery += " AND E2_NUMBOR >= '" + Mv_Par01 + "' AND E2_NUMBOR <= '" + Mv_Par02 + "' "					+ cEnter
cQuery += " AND SUBSTRING(E2_VENCREA,1,6) = '" + Substr(DtoS(dDataBase),1,6) + "' "						+ cEnter
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)							
TcSetField("TMP","E2_SALDO" ,"N",12,2) 
DbSelectArea("TMP")
DbGoTop()

nSaldo := PadL(StrTran( Alltrim(StrTran(Transform(SALDO,"@E 999,999,999,999.99"),",","")),".",""), 17, "0" )

Return(nSaldo) 
 