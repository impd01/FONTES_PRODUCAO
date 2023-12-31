#Include "Rwmake.ch"

/*���������������������������������������������������������������������������
���Programa  �BRADAC    �Autor  �Eduardo Augusto     � Data �  12/03/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Preenchimento da posi��o 140 a 147 do CNAB Bradesco.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Igreja Mundial                                             ���
���������������������������������������������������������������������������*/

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
aAdd( aChr, { "�","A" } )
aAdd( aChr, { "�","E" } )
aAdd( aChr, { "�","I" } )
aAdd( aChr, { "�","O" } )
aAdd( aChr, { "�","U" } )
aAdd( aChr, { "�","C" } )
aAdd( aChr, { "�","A" } )
aAdd( aChr, { "�","A" } )
aAdd( aChr, { "�","E" } )
aAdd( aChr, { "�","I" } )
aAdd( aChr, { "�","O" } )
aAdd( aChr, { "�","U" } )
aAdd( aChr, { "'�","A" } )
aAdd( aChr, { "�","E" } )
aAdd( aChr, { "�","I" } )
aAdd( aChr, { "�","O" } )
aAdd( aChr, { "�","U" } )
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
aAdd( aChr, { "�","a" } )
aAdd( aChr, { "�","e" } )
aAdd( aChr, { "�","i" } )
aAdd( aChr, { "�","o" } )
aAdd( aChr, { "�","u" } )
aAdd( aChr, { "�","c" } )
aAdd( aChr, { "�","a" } )
aAdd( aChr, { "�","a" } )
aAdd( aChr, { "�","e" } )
aAdd( aChr, { "�","i" } )
aAdd( aChr, { "�","o" } )
aAdd( aChr, { "�","u" } )
aAdd( aChr, { "'�","a" } )
aAdd( aChr, { "�","e" } )
aAdd( aChr, { "�","i" } )
aAdd( aChr, { "�","o" } )
aAdd( aChr, { "�","u" } )
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