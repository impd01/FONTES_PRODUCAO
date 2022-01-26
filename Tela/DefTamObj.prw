#include 'protheus.ch'
#include 'parmtype.ch'

User Function DefTamObj(aTamObj,nTOP,nLEFT,nWIDTH,nBOTTOM,lAcVlZr,oObjAlvo)

	Local lRefPerc			:= .F.
	Local nDimen			:= 0

	PARAMTYPE 0	VAR aTamObj		AS Array		OPTIONAL	DEFAULT Array(4)
	PARAMTYPE 1	VAR nTOP		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 2	VAR nLEFT		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 3	VAR nWIDTH		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 4	VAR nBOTTOM		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 5	VAR	lAcVlZr		AS Logical		OPTIONAL	DEFAULT .F.
	PARAMTYPE 6	VAR	oObjAlvo	AS Object		OPTIONAL	DEFAULT Nil

	If ValType(oObjAlvo) == "O"
		lRefPerc := !lRefPerc
	Endif
	If Len(aTamObj) # 4
		aTamObj := Array(4)
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nTOP))
		If lRefPerc
			If nTOP < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamObj[1] := (Abs(nTOP) / 100) * (nDimen / 2)
			Else
				aTamObj[1] := Abs(nTOP)
			Endif
		Else
			aTamObj[1] := Abs(nTOP)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nLEFT))
		If lRefPerc
			If nLEFT < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamObj[2] := (Abs(nLEFT) / 100) * (nDimen / 2)
			Else
				aTamObj[2] := Abs(nLEFT)
			Endif
		Else
			aTamObj[2] := Abs(nLEFT)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nWIDTH))
		If lRefPerc
			If nWIDTH < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamObj[3] := (Abs(nWIDTH) / 100) * (nDimen / 2)
			Else
				aTamObj[3] := Abs(nWIDTH)
			Endif
		Else
			aTamObj[3] := Abs(nWIDTH)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nBOTTOM))
		If lRefPerc
			If nBOTTOM < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamObj[4] := (Abs(nBOTTOM) / 100) * (nDimen / 2)
			Else
				aTamObj[4] := Abs(nBOTTOM)
			Endif
		Else
			aTamObj[4] := Abs(nBOTTOM)
		Endif
	Endif

Return Nil
