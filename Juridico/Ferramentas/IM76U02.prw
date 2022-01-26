#include 'protheus.ch'
#include 'parmtype.ch'

user function IM76U02(cCgc)

cCgc := Alltrim(cCgc)

DbSelectArea("ZZ3")
DbSetOrder(2)

		If !CGC(cCgc)
//			MsgInfo("CPF ou CNPJ inv�lido","TOTVS")
			Return .F.
		Endif

		IF ZZ3->(DbSeek(xFilial("ZZ3")+cCgc))

			MsgInfo("Este CPF j� est� cadastrado","TOTVS")

			M->ZZ3_CGC := ""
			
			Return .F.

		Endif

DbCloseArea()

Return(.T.)