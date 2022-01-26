#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT103IPC

@author carlos.xavier
@since 17/02/2017
@version 0.0.1
@type function

/*/
user function MT103IPC ()

local nD:=PARAMIXB[1]
local nPTP:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XTPCTO"} )
local nCTR:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XCONTRA"} )
local nEND:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XEND"} )
local nMUN:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XMUN"} )
local nBAR:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XBAIRRO"} )
	
		aCols[nD][nPTP]:=SC7->C7_XTPCTO
		aCols[nD][nCTR]:=SC7->C7_XCONTRA
		aCols[nD][nEND]:=SC7->C7_XEND
		aCols[nD][nMUN]:=SC7->C7_XMUN
		aCols[nD][nBAR]:=SC7->C7_XBAIRRO
		
return (.T.)