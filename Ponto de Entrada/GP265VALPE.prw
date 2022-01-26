#include 'protheus.ch'
#include 'parmtype.ch'

User Function GP265VALPE()

local cIgreja	:= M->RA_XIGREJA
local cCentroC	:= M->RA_CC

	If cCentroC >= '10301010010001' .and. cCentroC <= '10301019999999' .And. Empty(Alltrim(cIgreja)) 
		Alert("Favor informar o código da Igreja","TOTVS")
		Return(.F.)
	Else
		Return(.T.)
	Endif

Return