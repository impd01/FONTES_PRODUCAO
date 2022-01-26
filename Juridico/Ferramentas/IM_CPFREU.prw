#include 'protheus.ch'
#include 'parmtype.ch'

user function IM_CPFREU(cCgc)
	
	cCgc := Alltrim(cCgc)
	
DbSelectArea("ZZ6")
DbSetOrder(2)
	
	If !CGC(cCgc)
		MsgInfo("CPF ou CNPJ inv�lido","TOTVS")
		Return .F.
	Endif
		
	IF ZZ6->(DbSeek(xFilial("ZZ6")+cCgc))
		
		MsgInfo("Este CPF j� est� cadastrado","TOTVS")			
		
		M->ZZ6_CGC := ""
			
		Return .F.
			
	Endif
		
DbCloseArea()

Return(.T.)