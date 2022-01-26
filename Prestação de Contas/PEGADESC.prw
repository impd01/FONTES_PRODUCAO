#Include 'Protheus.ch'
#include 'Tbiconn.ch'
User Function PEGADESC(xPar)
Local cCampo	:= 'RA_XTIPO'
Local aCombo
local nX
local xCombo
//local xPar := "2"
local cArea := GetArea()
local cRet
dbSelectArea('SX3')
SX3->( dbSetOrder(2) )
SX3->( dbSeek( cCampo ) )
                
cValor	:= X3CBox()	
xCombo 	:= StrTokArr2( cValor, ";" )
//aCombo := Separa(cValor,"=")

	for nX := 1 to len(xCombo)
		If Substr(xCombo[nX] ,1,1) == xPar
			cRet := substr(xCombo[nX],3)
		Endif
	Next nX
RestArea(cArea)
Return cRet

