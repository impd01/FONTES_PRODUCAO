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
ฑฑบPrograma  ณIM43R01    บAutor  ณVinicius Henrique      บ Data ณ08/02/2018     บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM43R01 - Relat๓rio de Agendamentos								บฑฑ
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

User Function IM43R01(aCols,MV_PAR05,MV_PAR06)

	Local oPrinter

	oPrinter := TMSPrinter():New('IM43R01')
	Processa( {|| U_IM43R01A(oPrinter,aCols) }, "Aguarde...", "Imprimindo...",.F.)
	oPrinter:EndPage()
	oPrinter:Preview()
	FreeObj(oPrinter)

Return (Nil)

/*
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo para gerar o relat๓rio a ser impresso							  		 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
*/

User Function IM43R01A(oPrinter,aCols)

	Local aDad			:= {}
	Local aDad2			:= {}
	Local aAux			:= {'',0,0}

	Local nX
	Local nTotL			:= 0
	Local nTotB			:= 0
	Local nCnt			:= 0
	Local nGeral        := 0 

	Private cPag		:= '001'
	Private cBitMap		:= "logorel01.BMP'

	Private oFont08		:= TFont():New('Courier new',,8,.F.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
	Private oFont08n	:= TFont():New('Courier new',,8,.T.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
	Private oFont09		:= TFont():New('Courier new',,09,.F.)//TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10

	Private tHora		:= Time()


	//	aSort(aCols[nX][01])
	ASORT(aCols, , , { | x,y | x[1] + x[3] < y[1] + y[3] } )

//	AAdd(aCols,{"","","","","","","","","","","",.F.})

	ProcRegua(Len(aCols))

	oPrinter:StartPage()
	oPrinter:setLandscape()
	oPrinter:setPaperSize(DMPAPER_A4)

	fCab1(oPrinter)

//	nHeight := oPrinter:GetTextHeight( "Teste"			,oFont08 )

	I := 300

	aSort(aCols,,,{|x,y| x[5] < y[5] })

	For nX := 1 to Len(aCols)

			oPrinter:Say( I,0060,aCols[nX][05]								,oFont08,1400 )
			oPrinter:Say( I,0300,aCols[nX][07]								,oFont08,1400 )
			oPrinter:Say( I,0540,aCols[nX][08]								,oFont08,1400 )
			oPrinter:Say( I,0780,SUBSTR(Alltrim(aCols[nX][10]),1,28)		,oFont08,1400 )
			oPrinter:Say( I,1280,Transform(aCols[nX][11],"@R 9-9999-9999")	,oFont08,1400 )
			oPrinter:Say( I,1520,SUBSTR(Alltrim(aCols[nX][16]),1,20)		,oFont08,1400 )
			oPrinter:Say( I,1920,SUBSTR(Alltrim(aCols[nX][18]),1,16)		,oFont08,1400 )
			oPrinter:Say( I,2220,SUBSTR(Alltrim(aCols[nX][14]),1,16)		,oFont08,1400 )
			oPrinter:Say( I,2520,SUBSTR(Alltrim(aCols[nX][15]),1,16)		,oFont08,1400 )
			oPrinter:Say( I,2820,SUBSTR(Alltrim(aCols[nX][19]),1,35)		,oFont08,1400 )

			nCnt++

		I += 35

		If I > 2300
			oPrinter:EndPage()
			oPrinter:StartPage()
			fCab1(oPrinter)
			I := 300
		Endif	

	Next nX

Return

/*
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo para gerar o cabe็alho relat๓rio a ser impresso				  		 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
*/

Static Function fCab1(oPrinter)

	Local _clin := 0

	PRIVATE oFont20 := TFont():New("Arial",,18,.T.)
	PRIVATE oFont10 := TFont():New("Arial",,10,.T.)
	PRIVATE oFont12 := TFont():New("Arial",,08,.T.)
	PRIVATE oFont14 := TFont():New("Arial",,12,.T.)
	PRIVATE oFont06 := TFont():New("Courier new",,07,.F.)

	oPrinter:SayBitmap( 20,20,cBitMap,180,180 )

	oPrinter:Line(020,50,20,3450)
	oPrinter:Say( 040,3160,"Data: " + DTOC(Date()),oFont06,1400)
	oPrinter:Say( 060,3160,"Horas: " + tHora      ,oFont06,1400)
	oPrinter:Say( 080,3160,"IM43R01.prw"          ,oFont06,1400)
	oPrinter:Say( 100,3160,"Pแgina: "+ cPag       ,oFont06,1400)
	cPag := soma1(cPag)

	oPrinter:Say( 050,1300,"Relat๓rio de Agendamentos"  ,oFont20,1400)
	_clin := 80
	_clin += 30
	//oPrinter:Say( 140,1700,"Data de 17/05/2016 at้ 17/05/2016" ,oFont12,1400)
	oPrinter:Say( 145,1370,"Data de " + DToC(MV_PAR05)+" at้ " + DToC(MV_PAR06)    ,oFont14,1400)

	oPrinter:Line(200,50,200,3450)
	oPrinter:Say( (200+40),0060,"Hora"				,oFont12,1400)
	oPrinter:Say( (200+40),0300,"Placa"	 			,oFont12,1400)
	oPrinter:Say( (200+40),0540,"Veiculo" 			,oFont12,1400)
	oPrinter:Say( (200+40),0780,"Motorista"  		,oFont12,1400)
	oPrinter:Say( (200+40),1280,"Telefone"  		,oFont12,1400)
	oPrinter:Say( (200+40),1520,"Solicitante"  		,oFont12,1400)
	oPrinter:Say( (200+40),1920,"Setor"		   		,oFont12,1400)
	oPrinter:Say( (200+40),2220,"Origem"			,oFont12,1400)
	oPrinter:Say( (200+40),2520,"Destino"			,oFont12,1400)
	oPrinter:Say( (200+40),2820,"Observa็ใo"		,oFont12,1400)

/*	oPrinter:Line(200,50,200,3450)
	oPrinter:Say( (200+40),0060,"C๓digo"			,oFont12,1400)
	oPrinter:Say( (200+40),0300,"Data"	 			,oFont12,1400)
	oPrinter:Say( (200+40),0540,"Hora"  			,oFont12,1400)
	oPrinter:Say( (200+40),0780,"Cod. Veiculo"  	,oFont12,1400)
	oPrinter:Say( (200+40),1020,"Placa"  			,oFont12,1400)
	oPrinter:Say( (200+40),1260,"Veiculo"		   	,oFont12,1400)
	oPrinter:Say( (200+40),1500,"Motorista"			,oFont12,1400)
	oPrinter:Say( (200+40),2000,"Origem"			,oFont12,1400)
	oPrinter:Say( (200+40),2500,"Destino"			,oFont12,1400)
	oPrinter:Say( (200+40),3000,"Solicitante" 		,oFont12,1400)
*/
	oPrinter:Line(280,50,280,3450)

Return
