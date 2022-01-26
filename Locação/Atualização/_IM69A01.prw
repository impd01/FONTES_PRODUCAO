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
ฑฑบPrograma  ณIM69A01    บAutor  ณVinicius Henrique       บ Data ณ08/11/2017    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM69A01 - Ocorr๊ncias de Loca็ใo							        บฑฑ
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

User Function IM69A01()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IM69A01"

	Private oMV_PAR01
	Private oMV_PAR02
	Private oMV_PAR03
	Private oMV_PAR04
	Private oMV_PAR05
	Private oMV_PAR06
	Private oMV_PAR07
	Private oMV_PAR08
	Private oEndereco
	Private oTotCon
	Private nCont		:= 0
	Private oGetRank
	Private oGetRank2
	
	Private aHeadRank		:= {}
	Private aHeadRank2		:= {}
	Private aCols			:= {}
	Private aCposRank		:= {}
	Private aColsRank		:= {}
	Private aColsTotal		:= {}
	Private aTamObj			:= Array(4)

	Private aCoord			:= FWGetDialogSize(oMainWnd)
	Private cVldDel			:= "AllwaysFalse()"
	Private cVldDelT		:= "AllwaysFalse()"
	Private cVldLOk			:= "AllwaysTrue()"
	Private cVldTOk			:= "AllwaysTrue()"
	Private cFieldOk		:= "AllwaysTrue()"
	Private nStyle			:= GD_UPDATE
	Private cEndereco		:= Space(50)
	Private cSituacao		:= "" 
	Private cCaucao			:= ""
	Private	aCols2			:= {}
//	Private cHora			:= ""
	Private oCombo1  		:= "4=Todos"
	Private cCombo1			:= "4=Todos"
	Private oScroll
	Private oScroll2
	Private	aAllUser	:= FWSFAllUsers()
	Private aCposUsu	:= {"PERMISS"}
	Private lInclui		:= .F.
	Private lVisual		:= .F.
	Private lAltera		:= .F.
	Private lExclui		:= .F.
	Private oBotIncl
	Private cAcesso 	:= SuperGetMV("IM_69A01FL",.F.,"000000")

	If SX5->(DbSeek(xFilial("SX5") + "_R" +__cUserID))
		lInclui := ! Empty(At("I",Alltrim(SX5->X5_DESCRI)))
		lVisual := ! Empty(At("V",Alltrim(SX5->X5_DESCRI)))
		lAltera := ! Empty(At("A",Alltrim(SX5->X5_DESCRI)))
		lExclui := ! Empty(At("E",Alltrim(SX5->X5_DESCRI)))
	EndIf

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	aAdd(aHeadRank,{"SIT"					,"SITUA1"		,"@BMP"							,3							,TamSX3("C6_TES")[2]	 	,			,""			,TamSX3("C6_TES")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"CAU"					,"SITUA2"		,"@BMP"							,3							,TamSX3("C6_TES")[2]	 	,			,""			,TamSX3("C6_TES")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Tipo Im๓vel"			,"CN9_XTIPO"	,PesqPict("CN9","CN9_XTIPO")	,TamSX3("CN9_XTIPO")[1]		,TamSX3("CN9_XTIPO")[2]		,			,""			,TamSX3("CN9_XTIPO")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Nฐ Contrato"			,"CN9_NUMERO"	,PesqPict("CN9","CN9_NUMERO")	,TamSX3("CN9_NUMERO")[1]	,TamSX3("CN9_NUMERO")[2]	,			,""			,TamSX3("CN9_NUMERO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Revisใo"				,"CN9_REVISA"	,PesqPict("CN9","CN9_REVISA")	,TamSX3("CN9_REVISA")[1]	,TamSX3("CN9_REVISA")[2]	,			,""			,TamSX3("CN9_REVISA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Data Inicio"			,"CN9_DTINIC"	,PesqPict("CN9","CN9_DTINIC")	,TamSX3("CN9_DTINIC")[1]	,TamSX3("CN9_DTINIC")[2]	,			,""			,TamSX3("CN9_DTINIC")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Data Fim"				,"CN9_DTINIC"	,PesqPict("CN9","CN9_DTINIC")	,TamSX3("CN9_DTINIC")[1]	,TamSX3("CN9_DTINIC")[2]	,			,""			,TamSX3("CN9_DTINIC")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Dias"					,"CN9_END"		,PesqPict("CN9","CN9_END")		,6							,TamSX3("CN9_END")[2]		,			,""			,TamSX3("CN9_END")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Endere็o"				,"CN9_XRDESC"	,PesqPict("CN9","CN9_XRDESC")	,TamSX3("CN9_XRDESC")[1]	,TamSX3("CN9_XRDESC")[2]	,			,""			,TamSX3("CN9_XRDESC")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Regiใo"				,"CN9_BAIRRO"	,PesqPict("CN9","CN9_BAIRRO")	,TamSX3("CN9_BAIRRO")[1]	,TamSX3("CN9_BAIRRO")[2]	,			,""			,TamSX3("CN9_BAIRRO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Bairro"				,"E2_FORNECE"	,PesqPict("CN9","CN9_ESTADO")	,TamSX3("CN9_ESTADO")[1]	,TamSX3("CN9_ESTADO")[2]	,			,""			,TamSX3("CN9_ESTADO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	

	aAdd(aHeadRank2,{"ID"					,"Z3_ID"		,"@!"							,4							,TamSX3("Z3_CONTRT")[2]		,			,""			,TamSX3("Z3_CONTRT")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Nฐ Contrato"			,"Z3_CONTRT"	,PesqPict("SZ3","Z3_CONTRT")	,TamSX3("Z3_CONTRT")[1]		,TamSX3("Z3_CONTRT")[2]		,			,""			,TamSX3("Z3_CONTRT")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Revisใo"				,"Z3_REVIS"		,PesqPict("SZ3","Z3_REVIS")		,TamSX3("Z3_REVIS")[1]		,TamSX3("Z3_REVIS")[2]		,			,""			,TamSX3("Z3_REVIS")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Data"				 	,"Z3_DTNOTI"	,PesqPict("SZ3","Z3_DTNOTI")	,TamSX3("Z3_DTNOTI")[1]		,TamSX3("Z3_DTNOTI")[2]		,			,""			,TamSX3("Z3_DTNOTI")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Status Atual"			,"Z3_NOTIFIN"	,PesqPict("SZ3","Z3_NOTIFIN")	,30							,TamSX3("Z3_NOTIFIN")[2]	,			,""			,TamSX3("Z3_NOTIFIN")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Ori. Notifica็ใo"		,"Z3_ORINOTI"	,PesqPict("SZ3","Z3_ORINOTI")	,30							,TamSX3("Z3_ORINOTI")[2]	,			,""			,TamSX3("Z3_ORINOTI")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Valor Renova็ใo"		,"TOTNF"		,"@E 999,999,999.99"			,TamSX3("F2_VALBRUT")[1]	,TamSX3("F2_VALBRUT")[2] 	,""			,""			,TamSX3("F2_VALBRUT")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Not. Ativa"			,"Z3_NOTINA"	,PesqPict("SZ3","Z3_NOTINA")	,TamSX3("Z3_NOTINA")[1]		,TamSX3("Z3_NOTINA")[2]		,			,""			,TamSX3("Z3_NOTINA")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Observa็ใo"			,"Z3_OBSRMUL"	,PesqPict("SZ3","Z3_OBSRMUL")	,TamSX3("Z3_OBSRMUL")[1]	,TamSX3("Z3_OBSRMUL")[2]	,			,""			,TamSX3("Z3_OBSRMUL")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Usuแrio"				,"Z3_USUARIO"	,PesqPict("SZ3","Z3_USUARIO")	,TamSX3("Z3_USUARIO")[1]	,TamSX3("Z3_USUARIO")[2]	,			,""			,TamSX3("Z3_USUARIO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Data"					,"Z3_DTUALT"	,PesqPict("SZ3","Z3_DTUALT")	,TamSX3("Z3_DTUALT")[1]		,TamSX3("Z3_DTUALT")[2]		,			,""			,TamSX3("Z3_DTUALT")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank2,{"Hora"					,"Z3_HRUALT"	,PesqPict("SZ3","Z3_HRUALT")	,TamSX3("Z3_HRUALT")[1]		,TamSX3("Z3_HRUALT")[2]		,			,""			,TamSX3("Z3_HRUALT")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})

	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Ocorrencias de Contratos"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",30,.T.)
	oArea:AddLine("L02",35,.T.)
	oArea:AddLine("L03",35,.T.)
	
	oArea:AddCollumn("L01PARA"  , 88,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 12,.F.,"L01")
	oArea:AddCollumn("L02DLG"   , 88,.F.,"L02")
	oArea:AddCollumn("L02TOT"   , 12,.F.,"L02")	
	oArea:AddCollumn("L03DLG"   , 88,.F.,"L03")
	oArea:AddCollumn("L03BOT"   , 12,.F.,"L03")
	
	oArea:AddWindow("L01PARA" ,"L01PARA"	,"Parโmetros"			, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"	,"Fun็๕es" 				, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L02DLG" ,"L02DLG"  	,"Contratos"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L02TOT" ,"L02TOT"  	,"Totais"				, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L03DLG" ,"L03DLG"  	,"Registros"			, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)			
	oArea:AddWindow("L03BOT" ,"L03BOT"  	,"Fun็๕es"				, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)			

	oPainPara  := oArea:GetWinPanel("L01PARA"  	,"L01PARA" 	,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  	,"L01BOTO" 	,"L01")
	oPainRank  := oArea:GetWinPanel("L02DLG"  	,"L02DLG"  	,"L02")
	oPainTota  := oArea:GetWinPanel("L02TOT"  	,"L02TOT"  	,"L02")
	oPainRank2 := oArea:GetWinPanel("L03DLG"  	,"L03DLG"  	,"L03")
	oPainBoto2 := oArea:GetWinPanel("L03BOT"  	,"L03BOT"  	,"L03")
	
	SetKey(VK_F1,{||U_Help("IM69A01")})
	SetKey(VK_F2,{||IM69A01L()})

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth) 
	aTamObj[4] := (oPainBoto:nClientHeight)

	oScroll 		:= TScrollBox():New(oPainBoto,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT
	
	oScroll2 		:= TScrollBox():New(oPainPara,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.T.,.T.)
	oScroll2:Align 	:= CONTROL_ALIGN_ALLCLIENT

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Atualizar",oScroll,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||GeraRank(2)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Visualizar Contrato",oScroll,{||  LJMsgRun('Buscando Contrato...','Aguarde, Buscando Contrato',{||VisuCt()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Banco Conhecimento",oScroll,{||  LJMsgRun('Buscando Banco Conhecimento...','Aguarde, Buscando Banco de Conhecimento',{||BcoCon()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Altera็๕es Contrato",oScroll,{|| U_IM69A02()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Exportar Excel",oScroll,{||  LJMsgRun('Exportando...','Aguarde, Exportando...',{||GeraExcel()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })
	
	If __cUserID $ cAcesso
		U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Controle Acessos",oScroll,{||  IM69A01F()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })
	Endif
	
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fecha",oScroll,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto2)
	oBotIncl := tButton():New(aTamObj[1],aTamObj[2],"Incluir Ocorr๊ncia",oPainBoto2,{|| INCLUIR() },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotIncl:lActive := lInclui })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotVis := tButton():New(aTamObj[1],aTamObj[2],"Visualizar",oPainBoto2,{||  VISUAL(1) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotVis:lActive := lVisual })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotDel := tButton():New(aTamObj[1],aTamObj[2],"Deletar",oPainBoto2,{||  VISUAL(3) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotDel:lActive := lExclui })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotAlt := tButton():New(aTamObj[1],aTamObj[2],"Alterar",oPainBoto2,{|| VISUAL(2) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotAlt:lActive := lAltera })

	@  07,   00 Say oSay1 Prompt 'Contrato De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel	
	@  19,   00 Say oSay1 Prompt 'Contrato At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
	@  31,   00 Say oSay1 Prompt 'Regiใo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel	
	@  43,   00 Say oSay1 Prompt 'Regiใo At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
	@  07,  130 Say oSay1 Prompt 'Data De:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
	@  19,  130 Say oSay1 Prompt 'Data At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
	@  31,  130 Say oSay1 Prompt 'Endere็o:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel	
	@  07,  260 Say  oSay Prompt 'Help [F1]'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel		
	@  07,  295 Say  oSay Prompt 'Legenda [F2]'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel	
	
	@  02,  00 Say  oSay Prompt 'Total de Contratos:'	FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainTota Pixel	

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTTCTR" Of oScroll2
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTTCTR" Of oScroll2
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTT"	Of oScroll2	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTT"	Of oScroll2
	@  05,  185	MSGet oMV_PAR04	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oScroll2
	@  17,  185	MSGet oMV_PAR04	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oScroll2
	@  29,  185 MSGet oEndereco	Var cEndereco 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 170, 05 When .T.	Of oScroll2	
	
	@  10,  00 MSGet oTotCon	Var nCont 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 07 When .F.	Of oPainTota

	@  43,  130 Say oSay1 Prompt 'Tipos de Im๓vel:'		FONT oFont11 COLOR CLR_BLUE Size  65, 08 Of oScroll2 Pixel	

	oCombo1 :=TComboBox():New( 41, 185,{|u|if(PCount()>0, cCombo1:=u, cCombo1)},{"1=Comercial",;
        "2=Residencial","3=Estacionamento","4=Todos"}, 065, 05, oScroll2, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

        cCombo1 := '4'

	@  05, 380 BUTTON oButton PROMPT "Situa็๕es Aluguel" SIZE 60, 15 Of oScroll2 ACTION Checkbx1() PIXEL
	@  05, 450 BUTTON oButton PROMPT "Tipos de Garantia" SIZE 60, 15 Of oScroll2 ACTION Checkbx2() PIXEL

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || GeraRank(1)})})

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณGeraRank   บAutor  ณVinicius Henrique      บ Data ณ08/11/2017     บฑฑ
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
Static Function GeraRank(nOpc)

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()

	Local cContra1	:= ""
	Local cContra2	:= ""
	Local cFinot	:= ""
	Local nDias
	Local cDias		:= ""
	Local cTipoIm	:= ""

	aColsRank 		:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}
	nCont			:= 0

	cQuery	:= "SELECT *																	" + CRLF
	cQuery	+= "FROM " + RetSQLName("CN9") + " CN9											" + CRLF
	cQuery	+= "LEFT JOIN "+RetSqlName("CN8")+" CN8 "										  + CRLF
	cQuery	+= "ON CN8.CN8_FILIAL 		= '"+xFilial("CN8")+"' "							  + CRLF
	cQuery	+= "AND CN8.CN8_CONTRA = CN9.CN9_NUMERO "										  + CRLF
	cQuery	+= "AND CN8.D_E_L_E_T_ = ' '													" + CRLF
	cQuery	+= "WHERE CN9.D_E_L_E_T_ = ' '													" + CRLF
	cQuery	+= "AND CN9.CN9_TPCTO = '001'													" + CRLF	
	If !Empty(Alltrim(MV_PAR01)) .And. !("ZZ" $ MV_PAR02)
		cContra1 := STRZERO(Val(MV_PAR01), 15, 0)     
		cContra2 := STRZERO(Val(MV_PAR02), 15, 0)	
	cQuery	+= "AND CN9.CN9_NUMERO BETWEEN '" + cContra1 + "'	AND '" + cContra2 + "'		" + CRLF
	Else
	cQuery	+= "AND CN9.CN9_NUMERO BETWEEN '" + MV_PAR01 + "'	AND '" + MV_PAR02 + "'		" + CRLF
	Endif	
	cQuery	+= "AND CN9.CN9_XREG BETWEEN '" + MV_PAR03 + "'	AND '" + MV_PAR04 + "'			" + CRLF
	If Alltrim(cEndereco) <> ""
	cQuery	+= "AND CN9.CN9_END LIKE '%"+Alltrim(cEndereco)+"%'								" + CRLF
	Endif
	cQuery	+= "AND CN9.CN9_DTFIM BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'  	" + CRLF
	if !(empty(cSituacao))
		cQuery	+= " AND CN9.CN9_SITUAC IN "+ cSituacao										  + CRLF
	endif
	if !(empty(cCaucao))
		cQuery	+= " AND CN8.CN8_TPCAUC IN "+ cCaucao										  + CRLF
	endif
	If cCombo1 <> '4'
		cQuery	+= "AND CN9.CN9_XTIPO = " + cCombo1 + "	"							          + CRLF
	Endif
	cQuery	+= " ORDER BY CN9.CN9_NUMERO, CN9.CN9_REVISA "									  + CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(DbGoTop())

		Do While !(cAlias)->(Eof())

			IF 		((cAlias)->CN9_SITUAC) == '01'
				cLeg_1 := LoadBitmap( GetResources(), "BR_VERMELHO" )
			Elseif  ((cAlias)->CN9_SITUAC) == '02'
				cLeg_1 := LoadBitmap( GetResources(), "BR_AMARELO" )
			Elseif  ((cAlias)->CN9_SITUAC) == '03'
				cLeg_1 := LoadBitmap( GetResources(), "BR_AZUL" )
			Elseif  ((cAlias)->CN9_SITUAC) == '04'
				cLeg_1 := LoadBitmap( GetResources(), "BR_LARANJA" )
			Elseif  ((cAlias)->CN9_SITUAC) == '05'
				cLeg_1 := LoadBitmap( GetResources(), "BR_VERDE" )
			Elseif  ((cAlias)->CN9_SITUAC) == '06'
				cLeg_1 := LoadBitmap( GetResources(), "BR_CINZA" )
			Elseif  ((cAlias)->CN9_SITUAC) == '07'
				cLeg_1 := LoadBitmap( GetResources(), "BR_MARROM" )
			Elseif  ((cAlias)->CN9_SITUAC) == '08'
				cLeg_1 := LoadBitmap( GetResources(), "BR_PRETO" )
			Elseif  ((cAlias)->CN9_SITUAC) == '09'
				cLeg_1 := LoadBitmap( GetResources(), "BR_PINK" )
			Elseif  ((cAlias)->CN9_SITUAC) == '10'
				cLeg_1 := LoadBitmap( GetResources(), "BR_BRANCO" )
			Endif

			cLeg_2 := LoadBitmap( GetResources(), "BR_PRETO" )

			IF 		((cAlias)->CN8_TPCAUC) == '001'
				cLeg_2 := LoadBitmap( GetResources(), "BR_VERMELHO" )
			Elseif  ((cAlias)->CN8_TPCAUC) == '002'
				cLeg_2 := LoadBitmap( GetResources(), "BR_AMARELO" )
			Elseif  ((cAlias)->CN8_TPCAUC) == '003'
				cLeg_2 := LoadBitmap( GetResources(), "BR_AZUL" )
			Elseif  ((cAlias)->CN8_TPCAUC) == '004'
				cLeg_2 := LoadBitmap( GetResources(), "BR_VERDE" )
			Endif

			cTipoIm := ""

			If (cAlias)->CN9_XTIPO == '1'
				cTipoIm := 'Comercial'
			Elseif (cAlias)->CN9_XTIPO == '2'
				cTipoIm := 'Residencial'
			Elseif (cAlias)->CN9_XTIPO == '3'
				cTipoIm := 'Estacionamento'
			Endif

			nDias := StoD((cAlias)->CN9_DTFIM) - date()

			aAdd(aCols,{cLeg_1,;
			cLeg_2,;
			cTipoIm,;
			(cAlias)->CN9_NUMERO,;
			(cAlias)->CN9_REVISA,;
			DtoC(StoD((cAlias)->CN9_DTINIC)),;
			DtoC(StoD((cAlias)->CN9_DTFIM)),;
			nDias,;
			(cAlias)->CN9_XEND,;
			(cAlias)->CN9_XRDESC,;
			(cAlias)->CN9_XBAIRR,;
			(cAlias)->CN9_XESTAD,;
			.F.})

			cFinot := ""	
			nCont++

			(cAlias)->(DbSkip())

		EndDo

	(cAlias)->(DbCloseArea())
/*
		If SX5->(DbSeek(xFilial("SX5") + "_R" +__cUserID))
			lInclui := ! Empty(At("I",Alltrim(SX5->X5_DESCRI)))
			lVisual := ! Empty(At("V",Alltrim(SX5->X5_DESCRI)))
			lAltera := ! Empty(At("A",Alltrim(SX5->X5_DESCRI)))
			lExclui := ! Empty(At("E",Alltrim(SX5->X5_DESCRI)))
		EndIf
*/
		If nOpc <> 2
			oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,{|| IM69ATU()}/*uChange*/)
			oGetRank2 := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank2:nClientWidth/2,oPainRank2:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank2,@aHeadRank2,/*@aColsRank*/,/*uChange*/)
			oGetRank:oBrowse:brClicked := {|| If( Empty(oGetRank:aCols[1,1]), Nil, LJMsgRun("Classificando...","Aguarde...",{|| ClasGrid(@aCols,oGetRank:oBrowse:ColPos,@oGetRank,@oTela) } )) }
			
			oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			oGetRank2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			oGetRank:SetArray(aCols)

		Endif

		oGetRank:SetArray(aCols)
		oGetRank:Refresh()
		oTotCon:Refresh()
		oGetRank:oBrowse:SetFocus(1)
		oTela:Refresh()
		
	If Len(aCols) > 0
		IM69ATU()
	Endif
	
Return

/*
Funcao      : IM69A01L
Objetivos   : Tela de Legendas
Autor       : Vinicius Henriques
Data/Hora   : 09/11/2017
*/

Static Function IM69A01L()

	Local ny       := 0
	Local nx       := 0

	Local aSit := {{ "BR_VERMELHO","Cancelado"},{ "BR_AMARELO","Em Elaboracao"},;
	{ "BR_AZUL","Emitido" },{ "BR_LARANJA","Em Aprovacao"},{ "BR_VERDE","Vigente"},{ "BR_CINZA","Paralisado"},;
	{ "BR_MARROM","Sol. Finalizacao"},{ "BR_PRETO","Finalizado"},{ "BR_PINK","Revisao"},{ "BR_BRANCO","Revisado"}}

	Local aCau := {{ "BR_VERMELHO","Deposito em Dinheiro"},{ "BR_AMARELO","Carta/Seguro Fian็a"},;
	{ "BR_AZUL","Tํtulo de Captaliza็ใo" },{ "BR_VERDE","Fiador com Im๓vel"}}

	Local nXSize := 14
	Local aBmp := {}

	oDlgLeg := TDialog():New(000,000,460,320,OemToAnsi("Legendas"),,,,,,,,oMainWnd,.T.)

	//GRUPO 01
	oGrpLg1 := TGroup():New(000,002,108,160,'SIT - Situa็๕es Contratos',oDlgLeg,CLR_BLUE,,.T.)

	aBmp := array(Len(aSit))
	For nX := 1 to Len(aSit)
		@ nx*10,10 BITMAP aBmp[nx] RESNAME aSit[nx][1] of oGrpLg1 SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ nx*10,(nXSize/2) + 13 SAY If((ny+=1)==ny,aSit[ny][2]+If(ny==Len(aSit),If((ny:=0)==ny,"",""),""),"") of oGrpLg1 PIXEL
	Next nX
	ny := 0

	//GRUPO 02 	
	oGrpLg2 := TGroup():New(110,002,180,160,'CAU - Tipos de Cau็ใo',oDlgLeg,CLR_BLUE,,.T.)

	aBmp := array(Len(aCau))
	For nX := 1 to Len(aCau)
		@ (nx*10)+110,10 BITMAP aBmp[nx] RESNAME aCau[nx][1] of oGrpLg2 SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ (nx*10)+110,(nXSize/2) + 13 SAY If((ny+=1)==ny,aCau[ny][2]+If(ny==Len(aCau),If((ny:=0)==ny,"",""),""),"") of oGrpLg2 PIXEL
	Next nX
	ny := 0
	oDlgLeg:Activate(,,,.T.,/*valid*/,,,)

Return

Static Function Checkbx1()

	Local oButton1
	Local oButton2
	Local oButton3
	Private oChkBx1
	Private lChkBx1 := .F.
	Private oChkBx2
	Private lChkBx2 := .F.
	Private oChkBx3
	Private lChkBx3 := .F.
	Private oChkBx4
	Private lChkBx4 := .F.
	Private oChkBx5
	Private lChkBx5 := .F.
	Private oChkBx6
	Private lChkBx6 := .F.
	Private oChkBx7
	Private lChkBx7 := .F.
	Private oChkBx8
	Private lChkBx8 := .F.
	Private oChkBx9
	Private lChkBx9 := .F.
	Private oChkBx10
	Private lChkBx10 := .F.
	Private oGroup

	Static oDlg1

	DEFINE MSDIALOG oDlg1 TITLE "Situa็๕es de Contratos" FROM 000, 000  TO 300, 280 COLORS 0, 16777215 PIXEL

	@ 000, 001 GROUP oGroup TO 210, 200 PROMPT "  Situa็๕es  " OF oDlg1 COLOR 0, 16777215 PIXEL

	@ 015, 007 CHECKBOX oChkBx1 	VAR lChkBx1 PROMPT 	"01=Cancelado" 			SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 025, 007 CHECKBOX oChkBx2 	VAR lChkBx2 PROMPT 	"02=Em Elaboracao" 		SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 035, 007 CHECKBOX oChkBx3 	VAR lChkBx3 PROMPT 	"03=Emitido" 			SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 045, 007 CHECKBOX oChkBx4 	VAR lChkBx4 PROMPT 	"04=Em Aprovacao" 		SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 055, 007 CHECKBOX oChkBx5 	VAR lChkBx5 PROMPT 	"05=Vigente" 			SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 065, 007 CHECKBOX oChkBx6 	VAR lChkBx6 PROMPT 	"06=Paralisado" 		SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 075, 007 CHECKBOX oChkBx7 	VAR lChkBx7 PROMPT 	"07=Sol. Finalizacao" 	SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 085, 007 CHECKBOX oChkBx8 	VAR lChkBx8 PROMPT 	"08=Finalizado" 		SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 095, 007 CHECKBOX oChkBx9 	VAR lChkBx9 PROMPT 	"09=Revisao" 			SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL
	@ 105, 007 CHECKBOX oChkBx10 	VAR lChkBx10 PROMPT	"10=Revisado" 			SIZE 070, 008 OF oGroup COLORS 0, 16777215 PIXEL

	@ 007, 075 BUTTON oButton1 PROMPT "Marcar Todos" 	SIZE 045, 012 OF oGroup ACTION Marcar1(.T.) PIXEL
	@ 022, 075 BUTTON oButton2 PROMPT "Desmarcar Todos" SIZE 045, 012 OF oGroup ACTION Marcar1(.F.) PIXEL
	@ 050, 075 BUTTON oButton3 PROMPT "Confirmar" 		SIZE 045, 012 OF oGroup ACTION Confirm1() PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return iif(empty(cSituacao),.F.,cSituacao)

Static Function Marcar1(cParam)

	If cParam
		lChkBx1 := lChkBx2 := lChkBx3 := lChkBx4 := lChkBx5 := lChkBx6 := lChkBx7 := lChkBx8 := lChkBx9 := lChkBx10 := .T.
	Else
		lChkBx1 := lChkBx2 := lChkBx3 := lChkBx4 := lChkBx5 := lChkBx6 := lChkBx7 := lChkBx8 := lChkBx9 := lChkBx10 := .F.
	Endif

Return 

Static Function Marcar2(cParam)

	If cParam
		lChkBx11 := lChkBx12 := lChkBx13 := lChkBx14 := .T.
	Else
		lChkBx11 := lChkBx12 := lChkBx13 := lChkBx14 := .F.
	Endif

Return 

Static Function Confirm1()

	cSituacao:= ""

	if lChkBx1 == .T.
		iif(empty(cSituacao),cSituacao += "'01'",cSituacao += ",'01'")
		lChkBx1 := .F.
	endif

	if lChkBx2 == .T.
		iif(empty(cSituacao),cSituacao += "'02'",cSituacao += ",'02'")
		lChkBx2 := .F.	
	endif

	if lChkBx3 == .T.
		iif(empty(cSituacao),cSituacao += "'03'",cSituacao += ",'03'")
		lChkBx3 := .F.
	endif

	if lChkBx4 == .T.
		iif(empty(cSituacao),cSituacao += "'04'",cSituacao += ",'04'")
		lChkBx4 := .F.
	endif

	if lChkBx5 == .T.
		iif(empty(cSituacao),cSituacao += "'05'",cSituacao += ",'05'")
		lChkBx5 := .F.
	endif
	
	if lChkBx6 == .T.
		iif(empty(cSituacao),cSituacao += "'06'",cSituacao += ",'06'")
		lChkBx6 := .F.
	endif
	
	if lChkBx7 == .T.
		iif(empty(cSituacao),cSituacao += "'07'",cSituacao += ",'07'")
		lChkBx7 := .F.
	endif

	if lChkBx8 == .T.
		iif(empty(cSituacao),cSituacao += "'08'",cSituacao += ",'08'")
		lChkBx8 := .F.
	endif

	if lChkBx9 == .T.
		iif(empty(cSituacao),cSituacao += "'09'",cSituacao += ",'09'")
		lChkBx9 := .F.
	endif
	
	if lChkBx10 == .T.
		iif(empty(cSituacao),cSituacao += "'10'",cSituacao += ",'10'")
		lChkBx10 := .F.
	endif

	if !(empty(cSituacao))
		cSituacao := '('+ cSituacao +')'
		oDlg1:End()
	endif
	
	If empty(cSituacao)
		oDlg1:End()
	Endif

Return iif(empty(cSituacao),.F.,cSituacao)
	
Static Function IM69ATU()

	Local cContra 	:= oGetRank:aCols[oGetRank:nAt][4]
	Local cRevisa 	:= oGetRank:aCols[oGetRank:nAt][5]
	Local cQuery1	:= ""
	Local cAlias	:= GetNextAlias()
	Local cFinot2	:= ""
	Local cTipodes	:= ""
	Local cTermodes	:= ""
	Local cObs		:= ""
	Local cOriNot	:= ""

			aCols2 := {}

			cQuery1	:= "SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), Z3_OBSRMUL)),'') AS Z3_OBSRMUL, * " + CRLF
			cQuery1	+= "FROM " + RetSQLName("SZ3") + " SZ3											" + CRLF
			cQuery1	+= "WHERE SZ3.D_E_L_E_T_ = ' '													" + CRLF
			cQuery1	+= "AND SZ3.Z3_CONTRT = '" + cContra + "'										" + CRLF	
			cQuery1	+= "AND SZ3.Z3_REVIS = '" + cRevisa + "'										" + CRLF	

			TCQUERY cQuery1 NEW ALIAS (cAlias)

			(cAlias)->(DbGoTop())

				Do While !(cAlias)->(Eof())

					IF 		((cAlias)->Z3_NOTIFIN) == 'DS'
						cFinot2 := 'NOTIFICAวรO DE DESOCUPAวรO'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'CI'
						cFinot2 := 'C.I.'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'VT'
						cFinot2 := 'VISTORIA'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'RN'
						cFinot2 := 'NOTIFICAวรO DE RENOVAวรO'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'DC'
						cFinot2 := 'DESOCUPAวรO'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'CN'
						cFinot2 := 'CONTRA NOTIFICAวรO'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'RF'
						cFinot2 := 'REFORMA/RESTITUIวรO'
					Elseif ((cAlias)->Z3_NOTIFIN) == 'RR'
						cFinot2 := 'RENฺNCIA DE REFORMA'
					Endif
 
					If ((cAlias)->Z3_DESOCUP) == 'RE'
						cTipodes	:= "RESTITUIวรO / REPARAวรO EM ESPษCIE"
					Elseif	((cAlias)->Z3_DESOCUP) == 'RF'
						cTipodes	:= "REFORMA"
					Endif

					If ((cAlias)->Z3_TPDEVOL) == 'TP'
						cTermodes	:= "TERMO PROVISำRIO"
					Elseif	((cAlias)->Z3_TPDEVOL) == 'TD'
						cTermodes	:= "TERMO DEFINITIVO"
					Elseif	((cAlias)->Z3_TPDEVOL) == 'RC'
						cTermodes	:= "RESCISรO CONTRATUAL"
					Endif

					If ((cAlias)->Z3_ORINOTI) == '1'
						cOriNot	:= "LOCADOR"
					Elseif	((cAlias)->Z3_ORINOTI) == '2'
						cOriNot	:= "LOCATมRIO"
					Endif

					aAdd(aCols2,{(cAlias)->Z3_ID,;
					(cAlias)->Z3_CONTRT,;
					(cAlias)->Z3_REVIS,;
					DtoC(StoD((cAlias)->Z3_DTNOTI)),;
					cFinot2,;
					cOriNot,;
					(cAlias)->Z3_VLRREN,;
					(cAlias)->Z3_NOTINA,;
					(cAlias)->Z3_OBSRMUL,;
					(cAlias)->Z3_USUARIO,;
					DtoC(StoD((cAlias)->Z3_DTUALT)),;
					(cAlias)->Z3_HRUALT,;			
					.F.})

					cOriNot		:= ""
					cFinot2		:= ""
					cTipodes 	:= ""
					cTermodes 	:= ""

					(cAlias)->(DbSkip())

				EndDo

			(cAlias)->(DbCloseArea())

	oGetRank2:SetArray(aCols2)
	oGetRank2:Refresh()
	oTela:Refresh()

Return

Static Function INCLUIR()

Local lIncluiu		:= .F.
Local cCodUsr		:= RetCodUsr()
		
	Private cContra 	:= oGetRank:aCols[oGetRank:nAt][4]
	Private cRevisa 	:= oGetRank:aCols[oGetRank:nAt][5]
	Private cCadastro 	:= "Ocorr๊ncias Contratos"
	Private cHora 		:= Time()
	Private cCodigo		:= GERACOD(cContra,cRevisa)

		Axinclui("SZ3",Recno(),3)

		IM69ATU()

		oGetRank:SetArray(aCols)
		oGetRank:Refresh()

Return()

User Function ATUCMPS()

	cContra := oGetRank:aCols[oGetRank:nAt][4]
	cRevisa := oGetRank:aCols[oGetRank:nAt][5]
	cHora	:= Time()

Return

/////////////////////////////////////////////
// Classifica็ใo do grid
/////////////////////////////////////////////

Static Function ClasGrid(aCols,nCol,oGetDados,oTela)

	Local nxt

	If nCol > 0 .and. !Empty(aCols) .and. len(aCols) > 1
			
			if aCols[1,nCol] > aCols[len(aCols),nCol]
				aCols := aSort(aCols,,,{|x,y| x[nCol] < y[nCol] })
			else
				aCols := aSort(aCols,,,{|x,y| x[nCol] > y[nCol] })
			endif

		oGetDados:SetArray(aCols)
		oGetDados:Refresh()
		oTela:Refresh()

	Endif

Return

User Function Help(cArq)
	
	Local oDlg
	Local cMemo
	Local oFont 
	Local cStartPath := GetSrvProfString("Startpath","")
	Local __cFileLog := StrTran(AllTrim(cStartPath) + "\xHelp\"+cArq+".txt", "\\", "\")

	If File(__cFileLog)

		cMemo := MemoRead(__cFileLog)

		DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

		DEFINE MSDIALOG oDlg TITLE "Ajuda" From 3,0 to 442,542 PIXEL

		@ 5,5 Get oMemo  VAR cMemo MEMO SIZE 260,188.5 /*When .T.*/ OF oDlg PIXEL READONLY
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont

		DEFINE SBUTTON  FROM 199,227.5 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga

		ACTIVATE MSDIALOG oDlg CENTER
	Else	
		MsgAlert("Op็ใo nใo Disponํvel.")
	Endif
 
Return

Static Function VISUAL(nOpc)

Local cId		:= oGetRank2:aCols[oGetRank2:nAt][1]
Local cContrat 	:= oGetRank2:aCols[oGetRank2:nAt][2]
Local cRevisao 	:= oGetRank2:aCols[oGetRank2:nAt][3]
Local cDtUAlt	:= oGetRank2:aCols[oGetRank2:nAt][10]
Local cHrUAlt	:= oGetRank2:aCols[oGetRank2:nAt][11]
Local cCodUsr	:= RetCodUsr()

Private cCadastro 	:= "Ocorr๊ncias Contratos"

		DbSelectArea("SZ3")
		SZ3->(DbSetOrder(2))
		DbGoTop()
	
		If  SZ3->( dbSeek( xFilial("SZ3") + cId + cContrat + cRevisao))
		
			If nOpc == 1
			
				AxVisual("SZ3",SZ3->(Recno()),2)
	
			Elseif nOpc == 2
					AxAltera("SZ3",SZ3->(Recno()),4)
					RecLock("SZ3",.F.)
					SZ3->Z3_DTUALT := Date()
					SZ3->Z3_HRUALT := Time()
					Msunlock()							
			Elseif nOpc == 3
				AxDeleta("SZ3",SZ3->(Recno()),5)
			Endif
			
		Endif
				
		IM69ATU()
				
		oGetRank:SetArray(aCols)
		oGetRank:Refresh()
		oGetRank2:SetArray(aCols2)
		oGetRank2:Refresh()
		oTela:Refresh()
			
Return()

Static Function Checkbx2()

	Local oButton1
	Local oButton2
	Local oButton3
	Private oChkBx11
	Private lChkBx11 := .F.
	Private oChkBx12
	Private lChkBx12 := .F.
	Private oChkBx13
	Private lChkBx13 := .F.
	Private oChkBx14
	Private lChkBx14 := .F.
	Private oGroup2

	Static oDlg2

	DEFINE MSDIALOG oDlg2 TITLE "Tipos de Garantia" FROM 000, 000  TO 170, 300 COLORS 0, 16777215 PIXEL

	@ 000, 001 GROUP oGroup2 TO 070, 150 PROMPT "  Tipos  " OF oDlg2 COLOR 0, 16777215 PIXEL

	@ 015, 007 CHECKBOX oChkBx11 VAR lChkBx11 PROMPT 	"001=Dep. Dinheiro" 			SIZE 080, 008 OF oGroup2 COLORS 0, 16777215 PIXEL
	@ 025, 007 CHECKBOX oChkBx12 VAR lChkBx12 PROMPT 	"002=Carta/Seguro Fian็a" 		SIZE 080, 008 OF oGroup2 COLORS 0, 16777215 PIXEL
	@ 035, 007 CHECKBOX oChkBx13 VAR lChkBx13 PROMPT 	"003=Tํtulo de Captaliza็ใo"	SIZE 080, 008 OF oGroup2 COLORS 0, 16777215 PIXEL
	@ 045, 007 CHECKBOX oChkBx14 VAR lChkBx14 PROMPT 	"004=Fiador com Im๓vel" 		SIZE 080, 008 OF oGroup2 COLORS 0, 16777215 PIXEL

	@ 007, 095 BUTTON oButton1 PROMPT "Marcar Todos" 	SIZE 045, 012 OF oGroup2 ACTION Marcar2(.T.) PIXEL
	@ 022, 095 BUTTON oButton2 PROMPT "Desmarcar Todos" SIZE 045, 012 OF oGroup2 ACTION Marcar2(.F.) PIXEL
	@ 050, 095 BUTTON oButton3 PROMPT "Confirmar" 		SIZE 045, 012 OF oGroup2 ACTION Confirm2() PIXEL

	ACTIVATE MSDIALOG oDlg2 CENTERED

Return iif(empty(cCaucao),.F.,cCaucao)

Static Function Confirm2()

	cCaucao:= ""

	if lChkBx11 == .T.
		iif(empty(cCaucao),cCaucao += "'001'",cCaucao += ",'001'")
		lChkBx11 := .F.
	endif

	if lChkBx12 == .T.
		iif(empty(cCaucao),cCaucao += "'002'",cCaucao += ",'002'")
		lChkBx12 := .F.	
	endif

	if lChkBx13 == .T.
		iif(empty(cCaucao),cCaucao += "'003'",cCaucao += ",'003'")
		lChkBx13 := .F.
	endif

	if lChkBx14 == .T.
		iif(empty(cCaucao),cCaucao += "'004'",cCaucao += ",'004'")
		lChkBx14 := .F.
	endif

	if !(empty(cCaucao))
		cCaucao := '('+ cCaucao +')'
		oDlg2:End()
	endif
	
	If empty(cCaucao)
		oDlg2:End()
	Endif

	Return iif(empty(cCaucao),.F.,cCaucao)

Static Function VisuCt()

Private aHeader
Private N

	DbSelectArea("CN9")
	CN9->(DbSetOrder(1))
	DbGoTop()

	If  CN9->( dbSeek( xFilial("CN9")  + oGetRank:aCols[oGetRank:nAt][4] + oGetRank:aCols[oGetRank:nAt][5]))

		CN300Visua()
	
	Endif 
	
Return

Static Function BcoCon()
	
Private cCadastro	:= "Contratos - Documentos"		//"Contratos - Documentos"

	DbSelectArea("CN9")
	CN9->(DbSetOrder(1))
	DbGoTop()

	If  CN9->( dbSeek( xFilial("CN9") + oGetRank:aCols[oGetRank:nAt][4] + oGetRank:aCols[oGetRank:nAt][5]))

		CN300Docum()

	Endif

Return

Static Functio Email()

Local cAccount 		:= GetMV("MV_EMCONTA")
Local cSmtp			:= GetMV("MV_EMSMTP")
Local cPassword 	:= GetMV("MV_EMSENHA")  
Local cServer 		:= GetMV("MV_RELSERV")
Local cEmailde 		:= cAccount
Local cDestEmail 	:= GetMV("IM_69A01EM",,"sistemas@impd.org.br")

Return()

Static Function GeraExcel()

	Local aExcel := {} 
	Local cAcessoEx := SuperGetMV("IM_69A01EX",.F.,"administrador")

	If cUserName $ cAcessoEx

		AADD(aExcel,{"Nฐ Contrato","Revisใo","Data Inicio","Data Fim","Dias","Regiใo","Bairro","Estado"})

		AADD(aExcel,{"'" + oGetRank:aCols[oGetRank:nAt][4],oGetRank:aCols[oGetRank:nAt][5],oGetRank:aCols[oGetRank:nAt][6],oGetRank:aCols[oGetRank:nAt][7],;
		oGetRank:aCols[oGetRank:nAt][8],oGetRank:aCols[oGetRank:nAt][9],oGetRank:aCols[oGetRank:nAt][10],oGetRank:aCols[oGetRank:nAt][11]})

		AADD(aExcel,{" "," "," "," "," "," "," "," "," "," "," "})

		AADD(aExcel,{"Nฐ Contrato","Revisใo","Data","Status Atual","Origem Notifica็ใo","Valor Renova็ใo","Observa็ใo","Usuแrio","Data","Hora"})

		For nx := 1 to Len(aCols2)
			If oGetRank:aCols[oGetRank:nAt][4] == aCols2[nx,2]
				AADD(aExcel,{"'" + aCols2[nx,1],aCols2[nx,2],aCols2[nx,3],aCols2[nx,4],aCols2[nx,5],aCols2[nx,6],aCols2[nx,7],aCols2[nx,8],aCols2[nx,9],;
				aCols2[nx,10],aCols2[nx,11]})
			Endif
		Next

		DlgToExcel({{"ARRAY", "Ocorrencias de Contratos", {}, aExcel}})

	Else

		Alert("Usuแrio nใo estแ relacionado no parโmetro de acesso (IM_69A01EX). Entre em contato com o administrador do sistema.")
		Return()

	EndIf

Return

Static Function GERACOD(cContra,cRevisa)

	Local cQuery1	:= ""
	Local cAlias	:= GetNextAlias()

	cQuery	:= "SELECT MAX(Z3_ID) AS MAXCODIGO		" 				+ CRLF
	cQuery	+= "FROM " + RetSQLName("SZ3") + " SZ3	"	 			+ CRLF
	cQuery	+= "WHERE Z3_FILIAL = '" + xFilial("SZ3") + "'" 		+ CRLF
	cQuery	+= "AND Z3_CONTRT = '" + cContra + "'" 					+ CRLF
	cQuery	+= "AND Z3_REVIS = '" + cRevisa + "'" 					+ CRLF
	
	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(dbGoTop())
	
	cCodigo	:= (cAlias)->MAXCODIGO
	
	cCodigo	:= STRZERO(Val(cCodigo) + 1,4,0)
	
Return(cCodigo)

Static Function IM69A01F()

	Local aArea			:= GetArea()
	Local lRet			:= .T.
	Local oAreaUsu		:= FWLayer():New()
	Local aCoordUsu		:= FWGetDialogSize(oMainWnd)

	Local cVldDel	:= "AllwaysFalse()"
	Local cVldDelT	:= "AllwaysFalse()"
	Local cVldLOk	:= "AllwaysTrue()"
	Local cVldTOk	:= "AllwaysTrue()"
	Local cFieldOk	:= "AllwaysTrue()"
	Local nStyle	:= GD_UPDATE

	Private aTamObj	:= Array(4)
	Private cCadastUsu	:= "Cadastro de Usuแrios X Fun็๕es"

	Private aHeadUsu	:= {}
	Private aColsUsu	:= {}

	aAdd(aHeadUsu,{"Usuแrio"				,"USUARIO"		,"@X"					,15 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"C๓digo"					,"CODIGOU"		,"@!"					,06 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"Nome Usuแrio"			,"NOMEUSU"		,"@!"					,40 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"Permiss๕es"				,"PERMISS"		,"@!"					,06 ,0 ,"U_IM69A01F2()"	,"","C","","","","",,'A'})
	aAdd(aHeadUsu,{""						,"BRANCO"		,"@!"					,01 ,0 ,""				,"","C","","","","",,'V'})

	SX5->(DbSeek(xFilial("SX5") + "_R"))
	Do While SX5->X5_FILIAL + SX5->X5_TABELA = xFilial("SX5") + "_R" .And. ! SX5->(Eof())
		nPosUser := aScan(aAllUser,{|x| x[2] == Alltrim(SX5->X5_CHAVE)})  
		If ! Empty(nPosUser)
			Aadd(aColsUsu,{aAllUser[nPosUser,3],Alltrim(SX5->X5_CHAVE),aAllUser[nPosUser,4],PadR(Alltrim(SX5->X5_DESCRI),6),,.F.})
		EndIf
		SX5->(DbSkip())
	EndDo  

	oTelaUsu := tDialog():New(aCoordUsu[1],aCoordUsu[2],aCoordUsu[3],aCoordUsu[4],OemToAnsi(cCadastUsu),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oAreaUsu:Init(oTelaUsu,.F.)
	
	oAreaUsu:AddLine("L01",100,.T.)
	
	oAreaUsu:AddCollumn("L01DADOS"  ,020,.F.,"L01")
	oAreaUsu:AddCollumn("L01FOLDER" ,080,.F.,"L01")
	
	oAreaUsu:AddWindow("L01DADOS" ,"L01BOTOES" ,"Fun็๕es"										, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oAreaUsu:AddWindow("L01FOLDER","L01FOLD01" ,"Cadastro de Usuแrios x Fun็๕es"				, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	
	oPainBot2  := oAreaUsu:GetWinPanel("L01DADOS"  ,"L01BOTOES"	,"L01")
	oPainFol21 := oAreaUsu:GetWinPanel("L01FOLDER" ,"L01FOLD01"	,"L01")

	oGetUsu := MsNewGetDados():New(aCoordUsu[1],aCoordUsu[2],oPainFol21:nClientWidth/4,oPainFol21:nClientHeight/2,nStyle,cVldLOk,cVldTOk,,aCposUsu,0,9999,cFieldOk,cVldDelT,cVldDel,oPainFol21,@aHeadUsu,@aColsUsu,{|| })
	oGetUsu:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBot2:nClientWidth)
	aTamObj[4] := (oPainBot2:nClientHeight)
	
	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBot2)
	oBotInc := tButton():New(aTamObj[1],aTamObj[2],"&Inclui Usuแrio",oPainBot2,{|| MsAguarde({||IncUsu()},'Incluindo Usuแrio','Aguarde, Incluindo Usuแrio')},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc2 := tButton():New(aTamObj[1],aTamObj[2],"&Fecha",oPainBot2,{|| oTelaUsu:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| })

	oTelaUsu:Activate(,,,.T.,/*valid*/,,{|| })

	If SX5->(DbSeek(xFilial("SX5") + "_R" +__cUserID))
		lInclui := ! Empty(At("I",Alltrim(SX5->X5_DESCRI)))
		lVisual := ! Empty(At("V",Alltrim(SX5->X5_DESCRI)))
		lAltera := ! Empty(At("A",Alltrim(SX5->X5_DESCRI)))
		lExclui := ! Empty(At("E",Alltrim(SX5->X5_DESCRI)))
	EndIf
	
	RestArea(aArea)

Return

User Function IM69A01F2()
	
	Local aArea		:= GetArea()
	Local lRet := .T.
	Local aLet	:= {}

	For nX := 1 to Len(M->PERMISS)
		If Substr(M->PERMISS,nX,1) = " "
			Loop
		EndIf
		If ! ( Substr(M->PERMISS,nX,1) $ "AIVE" )
			MsgAlert("Permissใo invแlida ! Somente permitido 'AIVE' ")
			lRet := .F.
			Exit
		Else
			If aScan(aLet, Substr(M->PERMISS,nX,1)) > 0 
				MsgAlert("Permissใo invแlida ! Aba Repetida")
				lRet := .F.
				Exit
			EndIf
			aAdd(aLet,Substr(M->PERMISS,nX,1))
		EndIf  
	Next nX

	If lRet
		aSort(aLet)
		cTextOrd := ""
		aEval(aLet,{|x| cTextOrd += x}) 
		M->PERMISS := PadR(cTextOrd,6)
		SX5->(DbSeek(xFilial("SX5")+"_R"+oGetUsu:aCols[oGetUsu:nAt][2]))
		RecLock("SX5",.F.)
		SX5->X5_DESCRI := Alltrim(M->PERMISS)
		SX5->(MsUnlock())	
	EndIf 
	
	RestArea(aArea)
	
Return(lRet)

Static Function IncUsu()
	
	Local aArea		:= GetArea()
	Local oDlg
	Local cTitle	:= 'Usuarios do Sistema'
	Local cPesq		:= SPACE(50)
	Local aList		:= {}
	Local cList		:= 0
	Local oBold
	Local oList
	Local aGroup	:= {}
	Local aCodigo	:= {}
	Local cRetorno	:= ''
	Local nOpc		:= 0
	Local lRet		:= .T.
	Local nTodos,cSeek
	Local nx

	For nX:=1 To Len(aAllUser)
		Aadd(aList,aAllUser[nX,3])
		Aadd(aCodigo,{aAllUser[nX,3],aAllUser[nX,2],aAllUser[nX,4]})
	Next nX

	aSort(aList)
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 114,180 TO 335,600 TITLE cTitle Of oMainWnd PIXEL
	
		@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 90,255 NOBORDER WHEN .F. PIXEL
		@ 12,60 TO 14,400 Label '' Of oDlg PIXEL
		@ 4  ,66   SAY 'Selecione o Usuario:' Of oDlg PIXEL SIZE 120,9 FONT oBold
		@ 77, 70 SAY 'Pesquisar' of oDlg PIXEL SIZE 30,9
		@ 18,70 LISTBOX oList VAR cList ITEMS aList PIXEL SIZE 127,56 OF oDlg ON DBLCLICK (If(!Empty(cList),(nOpc:=1,oDlg:End()),))
		oList:bChange := {||nList := oList:nAT}
	
		@ 76, 96 MSGET cPesq VALID If(aScan(aList,{|x| x=Alltrim(cPesq)})>0,;
	   								((oList:nAT :=aScan(aList,{|x| x=Alltrim(cPesq)})),(oList:Refresh())),Nil)  of oDlg PIXEL SIZE 100,9
	
	    @ 95,155 BUTTON '&Confirma >> '  SIZE 40 ,10  FONT oDlg:oFont ACTION If(!Empty(cList),(nOpc:=1,oDlg:End()),)  OF oDlg PIXEL
	    @ 95,110 BUTTON '<< Ca&ncelar' SIZE 40,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		nPosCod		:= aScan(aCodigo,{|x|x[1] == aList[nList]})
		cLogin		:= aCodigo[nPosCod][1]
		cCodUser	:= aCodigo[nPosCod][2]
		cUserNom	:= aCodigo[nPosCod][3]
		
		If ! Empty(aScan(aColsUsu,{|x|x[2] == cCodUser}))
			MsgAlert("Usuแrio jแ cadastrado")
		Else
			nPosUser := aScan(aAllUser,{|x| x[2] == cCodUser})  
			If ! Empty(nPosUser)
				Aadd(aColsUsu,{aAllUser[nPosUser,3],cCodUser,aAllUser[nPosUser,4],Space(6),,.F.})
			EndIf
			oGetUsu:SetArray(aColsUsu)
			oGetUsu:Refresh()
			RecLock("SX5",.T.)
			SX5->X5_FILIAL	:= xFilial("SX5")
			SX5->X5_TABELA	:= "_R"
			SX5->X5_CHAVE	:= cCodUser
			SX5->X5_DESCRI	:= Space(6)
			SX5->X5_DESCSPA	:= cLogin
			SX5->X5_DESCENG := cUserNom
			SX5->(MsUnlock())
			lRet  := .T.
		EndIf
	EndIf
	
	RestArea(aArea)

Return lRet
