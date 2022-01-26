#include 'protheus.ch'
#include 'parmtype.ch'

User function PL627NAT()

Local cTipo     := paramixb[1]
Local cNatNivel := paramixb[2]
Local cKeyCli   := paramixb[3]
Local cKeyPro   := paramixb[4]

Alert("TESTE PONTO DE ENTRADA, VALOR " + SE2->E2_VALOR)
	
return cNat