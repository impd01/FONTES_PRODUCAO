#include 'protheus.ch'
#include 'parmtype.ch'

user function FA050ALT()
	
	If M->E2_XTIPO = '4' .and. M->E2_NATUREZ = '5005034' .and. M->E2_DIRF <> '2'
		Alert ("Este tipo de lançamento não Gera Dirf, Alterar o campo Gera Dirf para - 2=Não")
		Return(.F.)
	Else
		Return(.T.) 
	Endif
return