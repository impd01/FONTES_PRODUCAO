#Include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³BRADAC    ºAutor  ³Eduardo Augusto     º Data ³  12/03/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenchimento da posição 140 a 147 do CNAB Bradesco.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Igreja Mundial                                             º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function BradAC()
Local cRet	:= ""
Local cAgenc:= "3395"
Local cBanco:= "237"
Local cDigito:= "2"
//cBanco := SA6->A6_NUMBCO
//cAgenc := Strzero(Val(TiraAcento(SA6->A6_AGENCIA)),4)
//cDigito:= Strzero(Val(SA6->A6_DVAGE),1) 
cRet	:= IIF(SE1->E1_OCORREN$Alltrim("  ,01"),Alltrim(cBanco)+Alltrim(cAgenc)+Alltrim(cDigito),Strzero(0,8))
Return(cRet)

Static Function TiraAcento( cTexto )
Local cRet1 := ""
Local aChr  := {}
Local i     := 0
Local cChar := ""
Local nElem := 0
// Maiusculo
aAdd( aChr, { "Á","A" } )
aAdd( aChr, { "É","E" } )
aAdd( aChr, { "Í","I" } )
aAdd( aChr, { "Ó","O" } )
aAdd( aChr, { "Ú","U" } )
aAdd( aChr, { "Ç","C" } )
aAdd( aChr, { "Ã","A" } )
aAdd( aChr, { "Â","A" } )
aAdd( aChr, { "Ê","E" } )
aAdd( aChr, { "Î","I" } )
aAdd( aChr, { "Ô","O" } )
aAdd( aChr, { "Û","U" } )
aAdd( aChr, { "'À","A" } )
aAdd( aChr, { "È","E" } )
aAdd( aChr, { "Ì","I" } )
aAdd( aChr, { "Ò","O" } )
aAdd( aChr, { "Ù","U" } )
aAdd( aChr, { "'","" } )
aAdd( aChr, { "-","" } )
aAdd( aChr, { ".","" } )
aAdd( aChr, { "**","" } )
aAdd( aChr, { "/","" } )
aAdd( aChr, { "*","" } )
aAdd( aChr, { "=","" } )
aAdd( aChr, { "..","" } )
aAdd( aChr, { "#","" } )
aAdd( aChr, { "(","" } )
aAdd( aChr, { ")","" }  )
aAdd( aChr, { "{","" }  )
aAdd( aChr, { "}","" } )
aAdd( aChr, { "\","" } )
aAdd( aChr, { "@","" } )
aAdd( aChr, { "+","" } )
aAdd( aChr, { "<","" } )
aAdd( aChr, { ">","" } )
aAdd( aChr, { ":","" } )
aAdd( aChr, { ";","" } )
// Minusculo
aAdd( aChr, { "á","a" } )
aAdd( aChr, { "é","e" } )
aAdd( aChr, { "í","i" } )
aAdd( aChr, { "ó","o" } )
aAdd( aChr, { "ú","u" } )
aAdd( aChr, { "ç","c" } )
aAdd( aChr, { "ã","a" } )
aAdd( aChr, { "â","a" } )
aAdd( aChr, { "ê","e" } )
aAdd( aChr, { "î","i" } )
aAdd( aChr, { "ô","o" } )
aAdd( aChr, { "û","u" } )
aAdd( aChr, { "'à","a" } )
aAdd( aChr, { "è","e" } )
aAdd( aChr, { "ì","i" } )
aAdd( aChr, { "ò","o" } )
aAdd( aChr, { "ù","u" } )
aAdd( aChr, { "-","" } )
For i := 1 to len( cTexto )
	cChar := Subst( cTexto, i, 1 )
	nElem := aScan( aChr,{ |x| Upper(x[1]) == Upper(cChar)} )
	If nElem > 0
		cChar := aChr[ nElem, 2]
	EndIf
	cRet1 += cChar
Next
Return( cRet1 )                                                               