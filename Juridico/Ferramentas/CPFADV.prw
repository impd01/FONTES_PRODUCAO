#include 'protheus.ch'
#include 'parmtype.ch'

user function CPFADV(cCgc)
	
	cCgc := Alltrim(cCgc)
	
DbSelectArea("ZZ0")
DbSetOrder(2)
	
	If !CGC(cCgc)
		MsgInfo("CPF inv�lido","TOTVS")
		Return .F.
	Endif
		
	IF ZZ0->(DbSeek(xFilial("ZZ0")+cCgc))
		
		MsgInfo("Este CPF j� est� cadastrado","TOTVS")			
		
		M->ZZ0_CGC := ""
			
		Return .F.
			
	Endif
		
DbCloseArea()

Return(.T.)
