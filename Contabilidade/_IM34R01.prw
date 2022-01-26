#Include "RwMake.Ch"
#include 'Protheus.ch'
#Include "RPTDEF.CH"
#Include "TBICONN.CH"

#DEFINE CLRT CHR(13)+CHR(10)
#DEFINE DMPAPER_A4 9
#DEFINE DMPAPER_A4SMALL 10

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM34R01    บAutor  ณVinciius Henrique      บ Data ณ06/11/2017     บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM34R01 - Relat๓rio Razใo											บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIMPD			                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออนฑฑ
ฑฑบRevisao   ณ           บAutor  ณ                      บ Data ณ                บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function IM34R01()

	Local oPrinter
	Local cQuery	:= ""
	Local aCols		:= {}
	Local cAlias	:= GetNextAlias()

		cQuery := " SELECT * 						" + CRLF 
		cQuery += " FROM "+ RetSQLName(SEF) +" SEF" + CRLF
		cQuery += " WHERE D_E_L_E_T_ = ' '	        " + CRLF
		cQuery += " AND EF_BANCO = '237'			" + CRLF
		cQuery += " AND EF_NUM = ' '				" + CRLF
		cQuery += " AND EF_DATA >=20170101			" + CRLF
	
		TCQUERY cQuery NEW ALIAS (cAlias)

		
		(cAlias)->(DbGoTop())	

		Do While !(cAlias)->(Eof())

			aAdd(aCols,{.F.,;
			(cAlias)->EF_TITULO,;			
			(cAlias)->EF_PARCELA,;
			(cAlias)->EF_BANCO,;
			(cAlias)->EF_AGENCIA,;
			(cAlias)->EF_CONTA,;
			(cAlias)->EF_DATA,;
			(cAlias)->EF_FORNECE,;
			(cAlias)->EF_LOJA,;
			(cAlias)->EF_PREFIXO})
			(cAlias)->(dbSkip())
						
		EndDo
		(cAlias)->(DbGoTop())

	oPrinter := TMSPrinter():New('DV06R06')
	Processa( {|| U_IM34R01A(oPrinter,aCols) }, "Aguarde...", "Imprimindo...",.F.)
	oPrinter:EndPage()
	oPrinter:Preview()
	FreeObj(oPrinter)

	
Return (Nil)

/*
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo para gerar o relat๓rio a ser impresso							  		 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
*/

User Function IM34R01A(oPrinter,aColsTotal)

	Local cCli			:= ""
	Local cLoja			:= ""

	Local aDad			:= {}
	Local aDad2			:= {}
	Local aAux			:= {'',0,0}

	Local nX
	Local nTotL			:= 0
	Local nTotB			:= 0
	Local nCnt			:= 0
	Local nGeral        := 0 

	Private cPag		:= '001'
	Private cBitMap		:= "LGRL"+substr(cNumEmp,1,2)+'.BMP'

	Private oFont08		:= TFont():New('Courier new',,8,.F.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
	Private oFont08n	:= TFont():New('Courier new',,8,.T.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
	Private oFont09		:= TFont():New('Courier new',,09,.F.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10

	Private tHora		:= Time()


	//	aSort(aColsTotal[nX][01])
	ASORT(aColsTotal, , , { | x,y | x[1] + x[3] < y[1] + y[3] } )

	AAdd(aColsTotal,{"","","","","","","","","","","","",.F.})


	nTotCli	:= 0
	nGerNac := 0
	nGerReg := 0
	nSuperv := 0
	nVended := 0

	ProcRegua(Len(aColsTotal)-1)

	oPrinter:StartPage()
	oPrinter:setLandscape()
	oPrinter:setPaperSize(DMPAPER_A4)

	fCab1(oPrinter)

	nHeight := oPrinter:GetTextHeight( "Teste"			,oFont08 )

	I := 300
	For nX := 1 to Len(aColsTotal)-1

		If Alltrim(aColsTotal[nX][01]) == "Debito"

			oPrinter:Say( I,0060,aColsTotal[nX][01]				,oFont08,1400 )
			oPrinter:Say( I,0340,aColsTotal[nX][02]				,oFont08,1400 )
			oPrinter:Say( I,0600,aColsTotal[nX][03]				,oFont08,1400 )
			oPrinter:Say( I,0850,aColsTotal[nX][04]				,oFont08,1400 )
			oPrinter:Say( I,1100,aColsTotal[nX][05]				,oFont08,1400 )
			oPrinter:Say( I,1290,aColsTotal[nX][06]				,oFont08,1400 )
			oPrinter:Say( I,1488,aColsTotal[nX][07]				,oFont08,1400 )
			oPrinter:Say( I,1670,aColsTotal[nX][08]				,oFont08,1400 )
			oPrinter:Say( I,1830,aColsTotal[nX][09]				,oFont08,1400 )
			oPrinter:Say( I,1980,aColsTotal[nX][10]				,oFont08,1400 )
			oPrinter:Say( I,2070,SUBSTR(aColsTotal[nX][11],1,40),oFont08,1400 )
			oPrinter:Say( I,3055,Transform(noround(aColsTotal[nX][12]),"@e< 9,999,999,999.99"),oFont08,,,,1)
			oPrinter:Say( I,3320,Transform(noround(aColsTotal[nX][13]),"@e< 9,999,999,999.99"),oFont08,,,,1)

			nTotL  +=  aColsTotal[nX][12]
			nTotB  +=  aColsTotal[nX][13]

			nCnt++

		ElseIf Alltrim(aColsTotal[nX][01]) == "Cheque"

			oPrinter:Say( I,0060,aColsTotal[nX][01]				,oFont08,1400 )
			oPrinter:Say( I,0340,aColsTotal[nX][02]				,oFont08,1400 )
			oPrinter:Say( I,0600,aColsTotal[nX][03]				,oFont08,1400 )
			oPrinter:Say( I,0850,aColsTotal[nX][04]				,oFont08,1400 )
			oPrinter:Say( I,1100,aColsTotal[nX][05]				,oFont08,1400 )
			oPrinter:Say( I,1290,aColsTotal[nX][06]				,oFont08,1400 )
			oPrinter:Say( I,1488,aColsTotal[nX][07]				,oFont08,1400 )
			oPrinter:Say( I,1680,aColsTotal[nX][08]				,oFont08,1400 )
			oPrinter:Say( I,1830,aColsTotal[nX][09]				,oFont08,1400 )
			oPrinter:Say( I,1970,aColsTotal[nX][10]				,oFont08,1400 )
			oPrinter:Say( I,2070,SUBSTR(aColsTotal[nX][11],1,40),oFont08,1400 )
			oPrinter:Say( I,3055,Transform(noround(aColsTotal[nX][12]),"@e< 9,999,999,999.99"),oFont08,,,,1)
			oPrinter:Say( I,3320,Transform(noround(aColsTotal[nX][13]),"@e< 9,999,999,999.99"),oFont08,,,,1)

			nTotL := aColsTotal[nX][12] + nTotL
			nTotB += aColsTotal[nX][13]

			nCnt++


		ElseIf Alltrim(aColsTotal[nX][01]) == "Cnab"

			oPrinter:Say( I,0060,aColsTotal[nX][01]				,oFont08,1400 )
			oPrinter:Say( I,0340,aColsTotal[nX][02]				,oFont08,1400 )
			oPrinter:Say( I,0600,aColsTotal[nX][03]				,oFont08,1400 )
			oPrinter:Say( I,0850,aColsTotal[nX][04]				,oFont08,1400 )
			oPrinter:Say( I,1100,aColsTotal[nX][05]				,oFont08,1400 )
			oPrinter:Say( I,1290,aColsTotal[nX][06]				,oFont08,1400 )
			oPrinter:Say( I,1488,aColsTotal[nX][07]				,oFont08,1400 )
			oPrinter:Say( I,1670,aColsTotal[nX][08]				,oFont08,1400 )
			oPrinter:Say( I,1830,aColsTotal[nX][09]				,oFont08,1400 )
			oPrinter:Say( I,1980,aColsTotal[nX][10]				,oFont08,1400 )
			oPrinter:Say( I,2070,SUBSTR(aColsTotal[nX][11],1,40),oFont08,1400 )
			oPrinter:Say( I,3055,Transform(noround(aColsTotal[nX][12]),"@e< 9,999,999,999.99"),oFont08,,,,1)
			oPrinter:Say( I,3320,Transform(noround(aColsTotal[nX][13]),"@e< 9,999,999,999.99"),oFont08,,,,1)

			nTotL  := aColsTotal[nX][12] + nTotL
			nTotB  += aColsTotal[nX][13]

			nCnt++


		Endif

		nGeral += aColsTotal[nX][13]

		I += nHeight

		If I > 2300
			oPrinter:EndPage()
			oPrinter:StartPage()
			fCab1(oPrinter)
			I := 300
		Endif	

		If nX < Len(aColsTotal) 

			If Alltrim(aColsTotal[nX][01]) <> Alltrim(aColsTotal[nX+1][01])///IIF(nX == Len(aColsTotal), Alltrim(aColsTotal[nX][01]) ,Alltrim(aColsTotal[nX+1][01]))

				oPrinter:Line(I,50,I,3450)
				I += nHeight
				oPrinter:Say( I,0060,"Total de Registro:" 							 ,oFont08,1400 )
				oPrinter:Say( I,0450,Transform(noround(nCnt),"@E 9,999,999,999")	 ,oFont08,,,,1 )
				oPrinter:Say( I,2450,"Valor Total: "								 ,oFont08,1400 )
				//oPrinter:Say( I,2829,Transform(noround(nTotL),"@e< 9,999,999,999.99"),oFont08,1400 )
				//oPrinter:Say( I,3090,Transform(noround(nTotB),"@e< 9,999,999,999.99"),oFont08,1400 )
				oPrinter:Say( I,3055,Transform(noround(nTotL),"@e< 9,999,999,999.99"),oFont08,,,,1 )
				oPrinter:Say( I,3320,Transform(noround(nTotB),"@e< 9,999,999,999.99"),oFont08,,,,1 )
				I += nHeight + 28
				oPrinter:Line(I,50,I,3450)

				nTotL  := 0
				nTotB  := 0
				nCnt   := 0

			EndIf

		EndIf

	Next nX

	I += nHeight + 28
	oPrinter:Say( I,2450,"Valor Total Geral: "								 ,oFont08,1400 )
	oPrinter:Line(I,50,I,3450)
	oPrinter:Say( I,3320,Transform(noround(nGeral),"@e< 9,999,999,999.99"),oFont08,,,,1 )

Return

/*
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo para gerar o cabe็alho relat๓rio a ser impresso				  		 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
*/

Static Function fCab1(oPrinter)

	Local _clin := 0

	PRIVATE oFont18 := TFont():New("Arial",,18,.T.)
	PRIVATE oFont10 := TFont():New("Arial",,10,.T.)
	PRIVATE oFont12 := TFont():New("Arial",,08,.T.)
	PRIVATE oFont06 := TFont():New("Courier new",,07,.F.)

	oPrinter:SayBitmap( 20,20,cBitMap,180,180 )

	oPrinter:Line(020,50,20,3450)
	oPrinter:Say( 040,3160,"Data: " + DTOC(Date()),oFont06,1400)
	oPrinter:Say( 060,3160,"Horas: " + tHora      ,oFont06,1400)
	oPrinter:Say( 080,3160,"DV06R06.prw"          ,oFont06,1400)
	oPrinter:Say( 100,3160,"Pแgina: "+ cPag       ,oFont06,1400)
	cPag := soma1(cPag)

	oPrinter:Say( 080,1045,"PLD184 - Relat๓rio de Formas de Pagamento"  ,oFont18,1400)
	_clin := 80
	_clin += 30
	//oPrinter:Say( 140,1700,"Data de 17/05/2016 at้ 17/05/2016" ,oFont12,1400)
	oPrinter:Say( 145,1420,"Data de " + DToC(MV_PAR01)+" at้ " + DToC(MV_PAR02)    ,oFont12,1400)

	oPrinter:Line(200,50,200,3450)
	/*	oPrinter:Say( 200,0060,"C๓digo Zona"				,oFont12,1400)
	oPrinter:Say( 200,0340,"Nome Zona"	 				,oFont12,1400)
	*/							 			
	oPrinter:Say( (200+40),0060,"Forma Pgto"			,oFont12,1400)
	oPrinter:Say( (200+40),0340,"No. Cheque"	 		,oFont12,1400)
	oPrinter:Say( (200+40),0600,"Dt. Baixa"  			,oFont12,1400)
	oPrinter:Say( (200+40),0850,"Dt. Vencto"  			,oFont12,1400)
	oPrinter:Say( (200+40),1100,"Portador"  			,oFont12,1400)
	oPrinter:Say( (200+40),1290,"No. Tํtulo"		   	,oFont12,1400)
	oPrinter:Say( (200+40),1488,"Parcela"				,oFont12,1400)
	oPrinter:Say( (200+40),1650,"Mot. Baixa"			,oFont12,1400)
	oPrinter:Say( (200+40),1830,"C๓digo"				,oFont12,1400)
	oPrinter:Say( (200+40),1980,"Loja"					,oFont12,1400)
	oPrinter:Say( (200+40),2070,"Razใo Social" 			,oFont12,1400)
	oPrinter:Say( (200+40),2920,"Vl. Previsto"			,oFont12,1400)
	oPrinter:Say( (200+40),3230,"Vl. Pago"				,oFont12,1400)

	oPrinter:Line(280,50,280,3450)

Return
