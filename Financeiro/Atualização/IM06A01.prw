#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"


Static nAltBot		:= 010
Static nDistPad		:= 002


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM06A01    บAutor  ณVinicius Henrique       บ Data ณ27/07/2017    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM06A01 - Renegocia็ใo dos Alugu้is						        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIgreja Mundial do Poder de Deus                                   บฑฑ
ฑฑฬออออออออออุอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออนฑฑ
ฑฑบRevisao   ณ           บAutor  ณ                      บ Data ณ                บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IM06A01()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IM06A01"

	Private oMV_PAR01
	Private oMV_PAR02
	Private oMV_PAR03
	Private oMV_PAR04
	Private oMV_PAR05
	Private oMV_PAR06
	Private oMV_PAR07
	Private oMV_PAR08

	Private oGetRank
	Private oVlLiq
	Private oVlBru
	Private oTottit //Total de Titulos Selecionados
	Private oVlTottit // Valor Total dos Titulos Selecionados

	Private nNivel			:= 1
	Private nTitulos		:= 0
	Private nVlTitu			:= 0
	Private nTitulosSel		:= 0
	Private nVlTituSel		:= 0

	Private aHeadRank		:= {}
	Private aCols			:= {}
	Private aCols1			:= {}
	Private aCposRank		:= {}
	Private aColsRank		:= {}
	Private aColsTotal		:= {}
	Private aColsBkp		:= {}
	Private aNewAcols		:= {}	
	Private aDados			:= {}
	Private aTamObj			:= Array(4)

	Private aCoord			:= FWGetDialogSize(oMainWnd)
	Private cVldDel			:= "AllwaysFalse()"
	Private cVldDelT		:= "AllwaysFalse()"
	Private cVldLOk			:= "AllwaysTrue()"
	Private cVldTOk			:= "AllwaysTrue()"
	Private cFieldOk		:= "AllwaysTrue()"
	Private nStyle			:= GD_UPDATE

	Private lDrill			:= .F.
	Private lRet			:= .F.
	Private oOk				:= LoadBitmap( GetResources(), "LBOK"  )
	Private oNo				:= LoadBitmap( GetResources(), "LBNO"  )
	Private nMark_Est 		:= 0, nMark_End := 0,  nMark_XXX := 0,  nMark_Del := 0
	Private oCheckBOX
	Private lCheckBOX 		:= .F.
	Private _cCondPgto   	:= space(3)
//	sValidPerg(cPerg)
	Private cTitSE2 := ""
	
	aAdd(aCols, {.F.,"","","","","","","","","",CToD("  /  /  "),CToD("  /  /  "),0,"","","",""})
	aAdd(aCols1,{.F.,"","","","","","","","","",CToD("  /  /  "),CToD("  /  /  "),0,"","","",""})

	If ! Pergunte(cPerg,.T.)
		Return
	Endif
/*	
	aAdd(aHeadRank,{" "					,"E2_PREFIXO"	,PesqPict("SE2","E2_PREFIXO")	,TamSX3("E2_PREFIXO")[1]	,TamSX3("E2_PREFIXO")[2]	,			,""			,TamSX3("E2_PREFIXO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Prefixo"			,"E2_PREFIXO"	,PesqPict("SE2","E2_PREFIXO")	,TamSX3("E2_PREFIXO")[1]	,TamSX3("E2_PREFIXO")[2]	,			,""			,TamSX3("E2_PREFIXO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"No. Tํtulo"		,"E2_NUM"		,PesqPict("SE2","E2_NUM")		,TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]		,			,""			,TamSX3("E2_NUM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Parcela"			,"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA")	,TamSX3("E2_PARCELA")[1]	,TamSX3("E2_PARCELA")[2]	,			,""			,TamSX3("E2_PARCELA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Tipo"				,"E2_TIPO"		,PesqPict("SE2","E2_TIPO")		,TamSX3("E2_TIPO")[1]		,TamSX3("E2_TIPO")[2]		,			,""			,TamSX3("E2_TIPO")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Natureza"			,"E2_NATUREZ"	,PesqPict("SE2","E2_NATUREZ")	,TamSX3("E2_NATUREZ")[1]	,TamSX3("E2_NATUREZ")[2]	,			,""			,TamSX3("E2_NATUREZ")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Fornecedor"		,"E2_FORNECE"	,PesqPict("SE2","E2_FORNECE")	,TamSX3("E2_FORNECE")[1]	,TamSX3("E2_FORNECE")[2]	,			,""			,TamSX3("E2_FORNECE")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Loja"				,"E2_LOJA"		,PesqPict("SE2","E2_LOJA")		,TamSX3("E2_LOJA")[1]		,TamSX3("E2_LOJA")[2]		,			,""			,TamSX3("E2_LOJA")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Nome"				,"E2_NOMFOR"	,PesqPict("SE2","E2_NOMFOR")	,TamSX3("E2_NOMFOR")[1]		,TamSX3("E2_NOMFOR")[2]		,			,""			,TamSX3("E2_NOMFOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Emissao"			,"E2_EMISSAO" 	,PesqPict("SE2","E2_EMISSAO")	,TamSX3("E2_EMISSAO")[1]	,TamSX3("E2_EMISSAO")[2]	,			,""			,TamSX3("E2_EMISSAO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Vencimento"		,"E2_VENCREA"	,PesqPict("SE2","E2_VENCREA")	,TamSX3("E2_VENCREA")[1]	,TamSX3("E2_VENCREA")[2]	,			,""			,TamSX3("E2_VENCREA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Valor"				,"E2_VALOR"		,PesqPict("SE2","E2_VALOR")		,TamSX3("E2_VALOR")[1]		,TamSX3("E2_VALOR")[2]	 	,			,""			,TamSX3("E2_VALOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Contrato"			,"E2_XCONTRA"	,PesqPict("SE2","E2_XCONTRA")	,TamSX3("E2_XCONTRA")[1]	,TamSX3("E2_XCONTRA")[2]	,			,""			,TamSX3("E2_XCONTRA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Endere็o"			,"CN9_END" 		,PesqPict("CN9","CN9_END")		,TamSX3("CN9_END")[1]		,TamSX3("CN9_END")[2]		,			,""			,TamSX3("CN9_END")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Municํpio"			,"CN9_MUN"		,PesqPict("CN9","CN9_MUN")		,TamSX3("CN9_MUN")[1]		,TamSX3("CN9_MUN")[2]		,			,""			,TamSX3("CN9_MUN")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Bairro"			,"CN9_BAIRRO"	,PesqPict("CN9","CN9_BAIRRO")	,TamSX3("CN9_BAIRRO")[1]	,TamSX3("CN9_BAIRRO")[2]	,			,""			,TamSX3("CN9_BAIRRO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Estado"			,"CN9_ESTADO"	,PesqPict("CN9","CN9_ESTADO")	,TamSX3("CN9_ESTADO")[1]	,TamSX3("CN9_ESTADO")[2]	,			,""			,TamSX3("CN9_ESTADO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
*/

	DEFINE FONT oFont10    NAME "Arial"	SIZE 0, -10 BOLD
	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD
	DEFINE FONT oFont13    NAME "Arial"	SIZE 0, -13 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Renegocia็ใo dos Alugu้is"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",35,.T.)
	oArea:AddLine("L02",65,.T.)

	oArea:AddCollumn("L01PARA"  , 65,.F.,"L01")
	oArea:AddCollumn("L01TOTA"  , 25,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 10,.F.,"L01")
	oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

	oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Parโmetros"							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01TOTA" ,"L01TOTA"  ,"Totais"								, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Fun็๕es" 							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Tํtulos"							, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)		

	oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
	oPainTota  := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA"  ,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
	oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,aCposRank,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,/*uChange*/)
	oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
//	oGetRank:oBrowse:bLDblClick := {|| LJMsgRun("Consultando Banco De Dados...","Aguarde...",{|| IIF(Len(aColsRank) > 0,IIF(nNivel <> 2, RankAnalit(aColsRank[oGetRank:nAt,1]), ), )}) }

	//	SetKey(VK_F1,{||U_Help("DV02C06")})

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Gera Dados",oPainBoto,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||GeraRank(.T.)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotPesq := tButton():New(aTamObj[1],aTamObj[2],"Pesquisa",oPainBoto,{|| MsgAlert("Fun็ใo Indisponํvel") },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotPesq:lActive := .T. })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotDrill := tButton():New(aTamObj[1],aTamObj[2],"Renegocia็ใo",oPainBoto,{|| TelaReneg(aCols) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotDrill:lActive := .T. })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotImpr := tButton():New(aTamObj[1],aTamObj[2],"Imprimir",oPainBoto,{|| MsgAlert("Fun็ใo Indisponํvel")},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotImpr:lActive := .T.})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fecha",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	aCoordTota		:= FWGetDialogSize(oPainTota)
	oScroll 		:= TScrollBox():New(oPainTota,aCoordTota[1], aCoordTota[2], aCoordTota[3], aCoordTota[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT

	@  07,   00 Say oSay1 Prompt 'Contrato De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,   00 Say oSay1 Prompt 'Contrato At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,   00 Say oSay1 Prompt 'Vencimento De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,   00 Say oSay1 Prompt 'Vencimento At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  07,  130 Say oSay1 Prompt 'Fornecedor De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,  130 Say oSay1 Prompt 'Loja De:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,  130 Say oSay1 Prompt 'Fornecedor At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,  130 Say oSay1 Prompt 'Loja At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	
	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CN9" Of oPainPara
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CN9" Of oPainPara
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  07,  185 MSGet oMV_PAR05	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  19,  185 MSGet oMV_PAR06	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  31,  185 MSGet oMV_PAR07	Var MV_PAR07 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  43,  185 MSGet oMV_PAR08	Var MV_PAR08 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	

	@  07,  05 Say  oSay Prompt 'Total Titulos:'		FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  19,  05 Say  oSay Prompt 'Val. Titulos R$:'		FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  31,  05 Say  oSay Prompt 'Titulos Selecionados:'FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  43,  05 Say  oSay Prompt 'Val. Tit. Selec. R$:'	FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll

	@  07,  70 MSGet oVlLiq		Var nTitulos	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  19,  70 MSGet oVlBru		Var nVlTitu		 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  31,  70 MSGet oTottit	Var nTitulosSel	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  43,  70 MSGet oVlTottit	Var nVlTituSEL		 	FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll

	@  08, 280 CHECKBOX oCheckBOX VAR lCheckBOX PROMPT "Marcar/Desmarcar Todos" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainPara    

	@ .3, .1 LISTBOX oEstoque		FIELDS HEADER "","ID","Prefixo","No. Tํtulo","Parcela","Tipo","Natureza","Fornecedor","Loja","Nome","Emissao","Vencimento","Valor","Contrato","Endere็o","Municํpio","Bairro","Estado" FIELDSIZES 15,10,30,35,30,30,30,35,30,120,35,35,35,50,140,60,60 SIZE oPainRank:nClientWidth/2, oPainRank:nClientHeight/2.2 OF oPainRank

	ShowEst()

	oEstoque:bLDblClick := {|| aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1], aCols:DrawSelect() }
	
	oCheckBOX:bchange   := {||Seltodos(aCols) }	
	
	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || GeraRank()})})

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณGeraRank   บAutor  ณEverton F. Diniz       บ Data ณ28/12/2015     บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ														            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGrupo Dovac	                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออนฑฑ
ฑฑบRevisao   ณ           บAutor  ณ                      บ Data ณ                บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraRank(lExec)

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local nCnt		:= 0
	Local nCont		:= 0
	Local cContra1	:= ""
	Local cContra2	:= ""
	
	aColsRank 		:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}
	
	nTitulos		:= 0
	nVlTitu			:= 0
	nTitulosSel		:= 0
	nVlTituSel		:= 0
	lCheckBOX 		:= .F.
	
	If lExec
		aCols	  := {}
		aCol1	  := {}
		aTransf	  := {}
		nMark_Est := 0
		nC1		  := 0
		nTotQtd   := 0
		nTotPal   := 0
		nTotEmp   := 0
		nTotSld   := 0
	Endif	
		
	_cQuery	:= "SELECT																				" + CRLF
	_cQuery	+= "E2_PREFIXO,																			" + CRLF
	_cQuery	+= "E2_NUM,																				" + CRLF
	_cQuery	+= "E2_PARCELA,																			" + CRLF
	_cQuery	+= "E2_TIPO,																			" + CRLF
	_cQuery	+= "E2_NATUREZ,																			" + CRLF
	_cQuery	+= "E2_FORNECE,																			" + CRLF
	_cQuery	+= "E2_LOJA,																			" + CRLF
	_cQuery	+= "E2_NOMFOR,																			" + CRLF
	_cQuery	+= "E2_EMISSAO,																			" + CRLF
	_cQuery	+= "E2_VENCREA,																			" + CRLF
	_cQuery	+= "E2_VALOR,																			" + CRLF
	_cQuery	+= "E2_XCC,																				" + CRLF
	_cQuery	+= "E2_XCCDESC,																			" + CRLF
	_cQuery	+= "E2_XCONTRA,																			" + CRLF
	_cQuery	+= "CN9_END,																			" + CRLF
	_cQuery	+= "CN9_MUN,																			" + CRLF
	_cQuery	+= "CN9_BAIRRO,																			" + CRLF
	_cQuery	+= "CN9_ESTADO																			" + CRLF
	_cQuery	+= "FROM " + RetSQLName("SE2") + " SE2													" + CRLF
	_cQuery	+= "INNER JOIN " + RetSQLName("CN9") + " CN9											" + CRLF
	_cQuery	+= "ON CN9.CN9_NUMERO = SE2.E2_XCONTRA													" + CRLF
	_cQuery	+= "AND CN9.D_E_L_E_T_ = ' '															" + CRLF
	_cQuery	+= "INNER JOIN " + RetSQLName("CNC") + " CNC											" + CRLF
	_cQuery	+= "ON CNC.CNC_CODIGO = SE2.E2_FORNECE													" + CRLF
	_cQuery	+= "AND CNC.D_E_L_E_T_ = ' '															" + CRLF
	_cQuery	+= "WHERE																				" + CRLF
	If !Empty(Alltrim(MV_PAR01)) .And. !("ZZ" $ MV_PAR02)
		cContra1 := STRZERO(Val(MV_PAR01), 15, 0)     
		cContra2 := STRZERO(Val(MV_PAR02), 15, 0)	
	_cQuery	+= "SE2.E2_XCONTRA BETWEEN '" + cContra1 + "'	AND '" + cContra2 + "'					" + CRLF
	Else
	_cQuery	+= "SE2.E2_XCONTRA BETWEEN '" + MV_PAR01 + "'	AND '" + MV_PAR02 + "'					" + CRLF
	Endif	
	_cQuery	+= "AND SE2.E2_VENCREA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'	" + CRLF
	_cQuery	+= "AND SE2.E2_FORNECE BETWEEN '" + MV_PAR05 + "'	AND '" + MV_PAR07 + "'				" + CRLF	
	_cQuery	+= "AND SE2.E2_LOJA BETWEEN    '" + MV_PAR06 + "'	AND '" + MV_PAR08 + "'				" + CRLF
	_cQuery	+= "AND SE2.E2_SALDO > 0																" + CRLF	
	_cQuery	+= "AND SE2.D_E_L_E_T_ = ' '															" + CRLF
	_cQuery	+= "GROUP BY E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,							" + CRLF						
	_cQuery	+= "E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,									" + CRLF										
	_cQuery	+= "E2_VALOR,E2_XCC,E2_XCCDESC,E2_XCONTRA,CN9_END,CN9_MUN,								" + CRLF															
	_cQuery	+= "CN9_BAIRRO,CN9_ESTADO																" + CRLF
	
//	MEMOWRITE("IM06A01.SQL",_cQuery)

	TCQUERY _cQuery NEW ALIAS (cAlias)
	
	(cAlias)->(DbGoTop())
	

	(cAlias)->(DbGoTop())
 	
		Do While !(cAlias)->(Eof())

			nCont++
			
			nVlTitu		+= (cAlias)->E2_VALOR
			
			aAdd(aCols,{.F.,; 
			"",;
			(cAlias)->E2_PREFIXO,;
			(cAlias)->E2_NUM,;
			(cAlias)->E2_PARCELA,;
			(cAlias)->E2_TIPO,;
			(cAlias)->E2_NATUREZ,;
			(cAlias)->E2_FORNECE,;
			(cAlias)->E2_LOJA,;
			(cAlias)->E2_NOMFOR,;
			DtoC(StoD((cAlias)->E2_EMISSAO)),;
			DtoC(StoD((cAlias)->E2_VENCREA)),;
			(cAlias)->E2_VALOR,;
			(cAlias)->E2_XCONTRA,;
			(cAlias)->CN9_END,;
			(cAlias)->CN9_MUN,;
			(cAlias)->CN9_BAIRRO,;
			(cAlias)->CN9_ESTADO,;
			.F.})
						
			(cAlias)->(DbSkip())

		EndDo

	(cAlias)->(DbCloseArea())
	
	nTitulos 	+= nCont

	ShowEst()
	oEstoque:Refresh()
	oEstoque:bLDblClick := {|| MarcaEst(1) }
	oEstoque:brClicked  := {|| OrdemEst(1) }
	oTottit:Refresh()
	oVlTottit:Refresh()

	aColsRank := aClone(aCols)
	oGetRank:SetArray(aColsRank)
	oGetRank:Refresh()
	oGetRank:oBrowse:SetFocus()
	oVlLiq:Refresh()
	oVlBru:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณsValidPerg บAutor  ณEverton F. Diniz       บ Data ณ18/12/2015     บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณsValidPerg - Cria parโmetros iniciais da tela de consulta         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGrupo Dovac	                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออนฑฑ
ฑฑบRevisao   ณ           บAutor  ณ                      บ Data ณ                บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function sValidPerg(cPerg1)
	Local j
	Local i

	cPerg1      := PADR(cPerg1,10)
	aRegs       := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	If !Dbseek(cperg1)

		AADD(aRegs,{cPerg1,"01","Data de         	            ?"		,""	,"", "mv_ch1" ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg1,"02","Data ate   	                ?"		,""	,"", "mv_ch2" ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg1,"03","Lista Quais   					?"		,""	,"", "mv_ch3" ,"C",01,0,0,"C","","mv_par03","Previsto","","","","","Realizado","","","","","","","","","","","","","","","","","","","",""})

	Endif

	For i:=1 to LEN(aRegs)
		If !dbSeek(cPerg1+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return

Static Function ShowEst()
//	oOper:Refresh()
	oEstoque:SetArray(aCols)
	oEstoque:bLine	:= {||{If(aCols[oEstoque:nAt,1],oOk,oNo),;
	aCols[oEstoque:nAt,2],;
	aCols[oEstoque:nAt,3],;
	aCols[oEstoque:nAt,4],;
	aCols[oEstoque:nAt,5],;
	aCols[oEstoque:nAt,6],;
	aCols[oEstoque:nAt,7],;
	aCols[oEstoque:nAt,8],;
	aCols[oEstoque:nAt,9],;
	aCols[oEstoque:nAt,10],;
	aCols[oEstoque:nAt,11],;
	aCols[oEstoque:nAt,12],;
	aCols[oEstoque:nAt,13],;
	aCols[oEstoque:nAt,14],;		
	aCols[oEstoque:nAt,15],;		
	aCols[oEstoque:nAt,16],;
	aCols[oEstoque:nAt,17] }}

	oVlLiq:Refresh()
	oVlBru:Refresh()
	oTottit:Refresh()
	oVlTottit:Refresh()
	
Return

Static Function ShowEnd()
	oOper:Refresh()
	oEndereco:SetArray(aCol1)
	oEndereco:bLine	:= {||{If(aCol1[oEndereco:nAt,1],oOk,oNo),;
	aCol1[oEndereco:nAt,2],;
	aCol1[oEndereco:nAt,3],;
	aCol1[oEndereco:nAt,4],;
	aCol1[oEndereco:nAt,5],;
	aCol1[oEndereco:nAt,6],;
	aCol1[oEndereco:nAt,7],;
	aCol1[oEndereco:nAt,8],;
	aCol1[oEndereco:nAt,9],;
	aCol1[oEndereco:nAt,10],;
	aCol1[oEndereco:nAt,11],;
	aCol1[oEndereco:nAt,12],;
	aCol1[oEndereco:nAt,13],;
	aCol1[oEndereco:nAt,14],;
	aCol1[oEndereco:nAt,15],;
	aCol1[oEndereco:nAt,16],;
	aCols[oEndereco:nAt,17] }}

	oVlLiq:Refresh()
	oVlBru:Refresh()
	oTottit:Refresh()
	oVlTottit:Refresh()
	
Return

//+--------------------------------------------------------------------+
//| Rotina | MarcaEst 	| Autor | Everton Diniz	 	 |Data| 09.07.2016 |
//+--------------------------------------------------------------------+
//| Descr. | Fun็ใo para carregar o aTransf.						   |
//+--------------------------------------------------------------------+
//| Uso    | SIGAEST - Local									 	   |
//+--------------------------------------------------------------------+
Static Function MarcaEst(nOpc)
	Local nPos	  := 0
	Local nP	  := 0
	Local lOk	  := .T.
	Local nLinha  := oEstoque:nAt
	Local ncoluna := oEstoque:ColPos
	Local sEnder   := 'XX'
	Local nsaldo   := 0
	Local nx

	///////////////////////////////////////////////////////////////////

		If nOpc == 1
			If aCols[oEstoque:nAt][1]          ///////////////////Desmarcando Array
				//nMark_Del := Val(aCols[nAt,2])
				nMark_Del := Val(aCols[oEstoque:nAt,2])
				aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1]
				oEstoque:DrawSelect()
				aCols[oEstoque:nAt][2]   := " "
				nTitulosSel--
				nVlTituSEL	-=	aCols[oEstoque:nAt][13]		
				oEstoque:Refresh()		
				oTottit:Refresh()
				oVlTottit:Refresh()	
				Return			
			Endif
			
			AchMarca()  
		
			nMark_End := 0
			nMark_XXX := 0
		
			aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1]
			oEstoque:DrawSelect()
		
			If aCols[oEstoque:nAt][1]
				nMark_Est++
				aCols[oEstoque:nAt][2]   := cValToChar(nMark_Est)
				nTitulosSel := nMark_Est
				nVlTituSEL	+=	aCols[oEstoque:nAt][13]
			Else
				aCols[oEstoque:nAt][2]   := " "
			EndIf

		Else
			For nx := 1 To Len(aCols)
						If aCols[nx][1]          ///////////////////Desmarcando Array
							//nMark_Del := Val(aCols[nAt,2])
							nMark_Del := Val(aCols[nx][2])
							aCols[nx][1] := !aCols[nx][1]
							oEstoque:DrawSelect()
							aCols[nx][2]   := " "
							nTitulosSel--
							nVlTituSEL	-=	aCols[nx][13]		
							oEstoque:Refresh()		
							oTottit:Refresh()
							oVlTottit:Refresh()	
						Else
						
							AchMarca()  
						
							nMark_End := 0
							nMark_XXX := 0
						
							aCols[nx][1] := !aCols[nx][1]
							oEstoque:DrawSelect()
					
							If aCols[nx][1]
								nMark_Est++
								aCols[nx][2]   := cValToChar(nMark_Est)
								nTitulosSel := nMark_Est
								nVlTituSEL	+=	aCols[nx][13]
							Else
								aCols[nx][2]   := " "
							EndIf
						Endif
			Next			
		
		Endif
	
	oEstoque:Refresh()
	oVlLiq:Refresh()
	oVlBru:Refresh()
	oTottit:Refresh()
	oVlTottit:Refresh()	
	nlinEst := nLinha 
	
Return

Static Function AchMarca()

	Local i

	nMark_Est := 0
	For i := 1 To Len(aCols)
		nMark_XXX := Val(aCols[i,2])		
		If nMark_XXX  > nMark_Est
			nMark_Est := Val(aCols[i,2])	
		Endif
	Next i
Return

Static Function OrdemEst(nOpc)
	Local nLin := oEstoque:nAt
	Local ncol := oEstoque:ColPos
	Local nxt

	if nCol > 1 .and. !Empty(aCols) .and. len(aCols) > 1
		if aCols[1,nCol] > aCols[Len(aCols)-1,nCol]
			aCols     := aSort(aCols,1,Len(aCols)-1,{|x,y| x[nCol] < y[nCol] })		
		else
			aCols     := aSort(aCols,1,Len(aCols)-1,{|x,y| x[nCol] > y[nCol] })
		endif
	endif
	ShowEst()
	oEstoque:Refresh()	
Return()

Static Function Seltodos(aCols)

		MarcaEst(2)
		oTottit:Refresh()	
		oVlTottit:Refresh()	
		oEstoque:Refresh()	
Return()

Static Function Reneg()

Alert(A360Cond(1))
 
Return()

Static Function TelaReneg(aCols3)

	Local aArea			:= GetArea()
	Local oArea			:= FWLayer():New()

	Local cTitulo 		:= "Renegicia็ใo dos Alugu้is"

	Local cDelOk		:= "AllwaysFalse()"
	Local cSuperDel		:= "AllwaysFalse()"
	Local cLinhaOk		:= "AllwaysTrue()"
	Local cTudoOk		:= "AllwaysTrue()"
	Local cFieldOk		:= "AllwaysTrue()"
	Local cNature		:= GetMV("IM_NATALU1")
	Local cPrefix		:= GetMV("IM_PRENEG")
	Local cTipo			:= GetMV("IM_TIPNEG")
	Local aAlter		:= {"E2_VENCREA","E2_VALOR"}

	
	Private cObserv 	:= Space(150)
	Private lVazio 		:= .F.
	Private cCond		:= Space(3)
	Private aHeadDados 	:= {}
	Private aColsDados 	:= aCols
	Private lParc		:= .F.	
	Private oTela
	Private aPacelas	:= {}
	Private oCond
	Private oParc
	Private oDescr		
	Private cDescr		:= Space(30)
	Private cCond		:= Space(3)
	Private cParce		:= Space(2)	
	Private oValTotS		
	Private NValTotS	:= 0
	Private oValTot		
	Private NValTot		:= 0
	Private oDifere		
	Private nDifere		:= 0
	
	
	DbSelectArea("SE4")
	DbSetOrder(1)   
	
	NValTotS := nVlTituSel
	
	nStyle := GD_INSERT + GD_UPDATE + GD_DELETE
	
	aAdd(aHeadDados,{"No. Tํtulo"		,"E2_NUM"		,PesqPict("SE2","E2_NUM")		,TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]		,			,""			,TamSX3("E2_NUM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadDados,{"Parcela"			,"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA")	,TamSX3("E2_PARCELA")[1]	,TamSX3("E2_PARCELA")[2]	,			,""			,TamSX3("E2_PARCELA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadDados,{"Fornecedor"		,"E2_FORNECE"	,PesqPict("SE2","E2_FORNECE")	,TamSX3("E2_FORNECE")[1]	,TamSX3("E2_FORNECE")[2]	,			,""			,TamSX3("E2_FORNECE")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadDados,{"Loja"				,"E2_LOJA"		,PesqPict("SE2","E2_LOJA")		,TamSX3("E2_LOJA")[1]		,TamSX3("E2_LOJA")[2]		,			,""			,TamSX3("E2_LOJA")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadDados,{"Nome"				,"E2_NOMFOR"	,PesqPict("SE2","E2_NOMFOR")	,TamSX3("E2_NOMFOR")[1]		,TamSX3("E2_NOMFOR")[2]		,			,""			,TamSX3("E2_NOMFOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadDados,{"Vencimento"		,"E2_VENCREA"	,PesqPict("SE2","E2_VENCREA")	,TamSX3("E2_VENCREA")[1]	,TamSX3("E2_VENCREA")[2]	,			,""			,TamSX3("E2_VENCREA")[3]	,""		,""				,""			,""			,			,'R'		,			,			,			})
	aAdd(aHeadDados,{"Valor"			,"E2_VALOR"		,PesqPict("SE2","E2_VALOR")		,TamSX3("E2_VALOR")[1]		,TamSX3("E2_VALOR")[2]	 	,			,""			,TamSX3("E2_VALOR")[3]		,""		,""				,""			,""			,			,'R'		,"U_DV97GAT()"	,		,			})

	oDlg := tDialog():New(100,100,600,1000,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oDlg,.F.)

	oArea:AddLine("L01",35,.T.)
	oArea:AddLine("L02",65,.T.)
	
	oArea:AddCollumn("L01COND", 60,.F.,"L01")
	oArea:AddCollumn("L01VALO", 25,.F.,"L01")
	oArea:AddCollumn("L01OPCO", 15,.F.,"L01")
	oArea:AddCollumn("L01TELA",100,.F.,"L02")
	
	oArea:AddWindow("L01COND","L01COND"  ,"Condi็ใo de Pagamento"		,100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01VALO","L01VALO"  ,"Valor dos Titulos"			,100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01OPCO","L01OPCO"  ,"Fun็๕es"						,100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01TELA","L01TELA"  ,"Renegicia็ใo dos Alugu้is"	,100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)

	oPainCond  := oArea:GetWinPanel("L01COND"  ,"L01COND"  ,"L01")
	oPainValo  := oArea:GetWinPanel("L01VALO"  ,"L01VALO"  ,"L01")
	oPainOpco  := oArea:GetWinPanel("L01OPCO"  ,"L01OPCO"  ,"L01")
	oPainTela  := oArea:GetWinPanel("L01TELA"  ,"L01TELA"  ,"L02")

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainOpco:nClientWidth)
	aTamObj[4] := (oPainOpco:nClientHeight)
	
	@ 05,240 BUTTON "OK" SIZE 14,10 PIXEL OF oPainCond ACTION DV02C13C(aCols3,cCond,cParce)
	
	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainOpco)
	oBotConf := tButton():New(aTamObj[1],aTamObj[2],"Confirmar",oPainOpco,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||Confirma(aPacelas)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Cancelar",oPainOpco,{|| CANCELA()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	@  07,    00 Say oSay1 Prompt 'Condi็ใo de Pagto:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  07,   150 Say oSay1 Prompt 'Qtde. Parcelas'			FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  20,    00 Say oSay1 Prompt 'Descri็ใo:'				FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel

	@  05,  75 	MSGet oCond		Var cCond	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 06 When .T.	F3 "SE4" 	Of oPainCond Valid AtualCmps(cCond)
	@  05, 200 	MSGet oParc		Var cParce	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  25, 06 When lParc			Of oPainCond 
	@  20,  75 	MSGet oDescr	Var cDescr	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE 150, 06 When .F. 			Of oPainCond

	@  02,    00 Say oSay1 Prompt 'V. Total dos Titulos R$ :'	FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainValo Pixel	
	@  10,    00 	MSGet oValTotS	Var NValTotS 			FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo

	@  23,    00 Say oSay1 Prompt 'V. Total Novos Titulos R$:'		FONT oFont11 COLOR CLR_BLUE Size  70, 08 Of oPainValo Pixel	
	@  31,    00 	MSGet oValTot	Var NValTot	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo

	@  42,    00 Say oSay1 Prompt 'Diferen็a R$:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainValo Pixel	
	@  50,    00 	MSGet oDifere	Var nDifere	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo


	oGetDados := MsNewGetDados():New(aCoord[1]   ,aCoord[2]   ,oPainTela:nClientWidth/2,oPainTela:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue","",aAlter,,9999,cFieldOk	,"AllwaysFalse()"	,"AllwaysFalse()"		,oPainTela	,aHeadDados,aPacelas,/*{|| U_DV97GAT(3)}*/)

	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oDlg:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Procurando Ocorr๊ncias...","Aguarde...",{ || /*DV02C13C()*/})})

Return()

////////////////////////////////////////////////
//MONTA ARQUIVO TEMPORARIO
////////////////////////////////////////////////

Static Function CANCELA()

	oDlg:End()
	
	GeraRank(.T.)

Return()

Static Function DV02C13C(_aCols,cCond,cParce)

	Local aValor	:= {}
	Local nValor	:= 0
	Local aRegs		:= {}
	Local nParc		:= 0
	Local cParc		:= ""
	Local cFornec	:= ""
	Local cLoja		:= ""
	Local cNome		:= ""
	Local nParce	:= 0
	Local dVenci	
	Local aDatas	:= {}
	Local nParcelas	:= 0
	Local dVencto
	Local ny
	Local nx
		
	Private aVenc	:= {}
	
	aPacelas	:= {}
	
	nValTot := 0
	nDifere := 0
	
	aSort(_aCols,,,{|x,y| x[8]+x[9] < y[8]+y[9] })
				
				For ny := 1 to Len(_aCols)	
								
					If _aCols[ny][1] == .T.	
						nValor 	+= _aCols[ny][13]
						cFornec := _aCols[ny][8]
						cLoja	:= _aCols[ny][9]
						cNome	:= _aCols[ny][10]
					Endif
					
				Next ny
	
				aVenc := Condicao(nValor,cCond,0)
				
				GeraSE2()
				
				nParce := Val(cParce)
				
				If lParc
					
					dVenci := aVenc[1][1]
					nValor := nValor / nParce
					
					For nx := 1 to nParce
						nParc++
						cParc := STRZERO(nParc, 3, 0)

						nParcelas++
						
						dVencto := MonthSum(dVenci,nParcelas)
							
						AADD(aPacelas,{cTitSE2,;
						cParc,;
						cFornec,;
						cLoja,;
						cNome,;
						dVencto,;
						nValor,;
					.F.})
					
					nValTot += nValor
					Next nx
				Else
					For nx := 1 to Len(aVenc)							
					nParc++
					cParc := STRZERO(nParc, 3, 0)
						
					AADD(aPacelas,{cTitSE2,;
					cParc,;
					cFornec,;
					cLoja,;
					cNome,;
					aVenc[nx][1],;
					aVenc[nx][2],;
					.F.})
					nValTot += aVenc[nx][2]
					Next nx
				Endif	
				
	oDifere:Refresh()			
	oValTot:Refresh()
	oGetDados:SetArray(aPacelas)
	oGetDados:Refresh()
	oGetDados:oBrowse:SetFocus()

Return

Static Function GeraSE2() //Gera novo titulo de acordo com os parโmetros

	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""
	Local cNaturez 	:= GETMV("IM_NATALU1") //Natureza do Titulo
	Local cPrefixo 	:= GETMV("IM_PRENEG") //Prefixo do Titulo
	Local cTipotit 	:= GETMV("IM_TIPNEG") //Tipo do Titulo
	Local cSiglaTi 	:= GETMV("IM_SIGLATI") //Sigla que ira compor os 3 primeiros caracteres da numeracao do novo titulo
		
		cQuery	:= "SELECT MAX(E2_NUM) AS MAXCODIGO		" 		+ CRLF
		cQuery	+= "FROM " + RetSQLName("SE2") + " SE2	"	 	+ CRLF
		cQuery	+= "WHERE E2_PREFIXO = '" + cPrefixo + "'" 		+ CRLF
		cQuery	+= "AND E2_NATUREZ 	 = '" + cNaturez + "'" 		+ CRLF
		cQuery	+= "AND E2_TIPO 	 = '" + cTipotit + "'" 		+ CRLF

		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(dbGoTop())

		cTitSE2 := SUBSTR((cAlias)->MAXCODIGO,4,9)
		
		cTitSE2 := Val(cTitSE2)	+ 1
		 
		cTitSE2 :=  cSiglaTi + STRZERO(cTitSE2, 6, 0)		
		 	
Return()

Static Function Confirma(aTitulos)
	
	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local cNaturez 	:= GETMV("IM_NATALU1") //Natureza do Titulo
	Local cPrefixo 	:= GETMV("IM_PRENEG") //Prefixo do Titulo
	Local cTipotit 	:= GETMV("IM_TIPNEG") //Tipo do Titulo
	Local cDirf		:= ""
	Local cCodRet	:= ""
	Local cXReg		:= ""
	Local cXRDesc	:= ""
	Local cTpCto	:= ""	
	Local nCont		:= 0
	Local no
	Local nz
	Local nx

	nCont := len(aTitulos)

	 For no := 1 To Len(aTitulos)
	 
	 	If aTitulos[no][7] == 0
	 		Alert("Aten็ใo, existem parcela com o valor 0 (ZERO), favor verificar.","Aten็ใo")
	 		Return(.F.)
	 	Endif
	 	
	 Next no

	 If nDifere > 0
	 	Alert("Aten็ใo, a soma dos valores dos tํtulos criados estแ maior que o total dos tํtulos selecionados.","Aten็ใo")
	 	Return(.F.)	 	
	 Elseif nDifere < 0
	 	Alert("Aten็ใo, a soma dos valores dos tํtulos criados estแ menor que o total dos tํtulos selecionados.","Aten็ใo")
	 	Return(.F.)	 
	 Endif

	DbSelectArea("SE2")
	DbSetOrder(21)
		
	DbSelectArea("SED")
	DbSetOrder(1)	
	
	DbSelectArea("CN9")
	DbSetOrder(1)	


	For nx := 1 to len(aCols)
		If aCols[nx][1] == .T.	
			IF SE2->(DbSeek(aCols[nx][4]+aCols[nx][5])) //Incluir busca por titulo e parcela
					RecLock("SE2", .F.)
					SE2->E2_SALDO := 0
					SE2->E2_BAIXA := Date()
					SE2->E2_XNEGALU		:= 'S'
					SE2->(Msunlock())
			EndIF

					If nCont > 0
								
							For nz := 1 To len(aTitulos)
							
								IF SED->(DbSeek(xFilial("SED")+cNaturez)) //Incluir busca por titulo e parcela							
									If SED->ED_CALCIRF == 'S'
										cDirf		:= '1'
									Elseif SED->ED_CALCIRF == 'N'
										cDirf		:= '2'
									Else
										cDirf		:= ''
									Endif							
									cCodRet		:= SED->ED_CODRET					
								Endif
								
								IF CN9->(DbSeek(xFilial("CN9")+aCols[nx][14]))					 
									 cXReg		:= CN9->CN9_XREG
									 cXRDesc	:= CN9->CN9_XRDESC
									 cTpCto		:= CN9->CN9_TPCTO				 
								Else				 
									cXReg		:= ""
									cXRDesc		:= ""				 	
									cTpCto		:= ""					
								Endif					
								RecLock("SE2", .T.)
								SE2->E2_FILIAL		:= xFilial("SE2")
								SE2->E2_PREFIXO		:= cPrefixo
								SE2->E2_TIPO	 	:= cTipotit
								SE2->E2_NUM			:= aTitulos[nz][1]
								SE2->E2_PARCELA		:= aTitulos[nz][2]
								SE2->E2_FORNECE		:= aTitulos[nz][3]
								SE2->E2_LOJA		:= aTitulos[nz][4]
								SE2->E2_NOMFOR		:= aTitulos[nz][5]
								SE2->E2_NATUREZ		:= cNaturez
								SE2->E2_EMISSAO		:= Date()
								SE2->E2_EMIS1		:= Date()
								SE2->E2_VENCTO		:= aTitulos[nz][6]
								SE2->E2_VENCREA		:= aTitulos[nz][6]
								SE2->E2_VALOR		:= aTitulos[nz][7]
								SE2->E2_SALDO		:= aTitulos[nz][7]
								SE2->E2_MOEDA		:= 1
								SE2->E2_XNEGALU		:= 'S'
								SE2->E2_DIRF		:= cDirf
								SE2->E2_CODRET		:= cCodRet
								SE2->E2_ORIGEM		:= 'IM06A01'
								SE2->E2_XCONTRA		:= aCols[nx][14]
								SE2->E2_XTPCTO		:= cTpCto
								SE2->E2_XREG		:= cXReg
								SE2->E2_XRDESC		:= cXRDesc
								SE2->E2_XEND		:= aCols[nx][15]
								SE2->E2_XBAIRRO		:= aCols[nx][17]
								SE2->E2_XMUN		:= aCols[nx][16]
								nCont--
								SE2->(Msunlock())
							Next nz		
							
					Endif
					
		Endif
		
	Next nx

	MsgAlert("Tํtulos incluidos com Sucesso.","Sucesso")
	
	oDlg:End()
	
	GeraRank(.T.)

Return()

Static Function AtualCmps(cCond)

	DbSelectArea("SE4")
	DbSetOrder(1)                                    		
	
	IF SE4->(DbSeek(xFilial("SE4")+cCond))
		If SE4->E4_TIPO == '7'
			lParc := .T.
			cParce := Space(2)	
		Else
			lParc := .F.
			cParce := ""
			oParc:Refresh()
		Endif
	Endif

	cDescr := POSICIONE("SE4", 1, xFilial("SE4") + cCond, "E4_DESCRI")
	
	DbCloseArea("SE4")
	

	oDescr:Refresh()
	oParc:Refresh()
	oParc:SetFocus()
	
Return()

User Function DV97GAT(nOp)

	Local nx

	nValTot := 0
	
	oGetDados:aCols[oGetDados:nAt][7] := M->E2_VALOR
	
	For nx := 1 To Len(aCols)
	
		nValTot += aCols[nx][7]
		
	Next nx
	
	nDifere := nValTot - NValTotS
	
	oDifere:Refresh()
	oValTot:Refresh()
	
	oGetDados:Refresh()
		
Return(.T.)
