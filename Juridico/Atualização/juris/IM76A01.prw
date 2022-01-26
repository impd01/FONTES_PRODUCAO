#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'
#Include 'FwMVCDef.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002
Static oArea		:= FWLayer():New()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM76A01    บAutor  ณVinicius Henrique       บ Data ณ26/06/2018    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM76A01 - Ocorr๊ncias Juridico							        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIgreja Mundial do Poder de Deus                                   บฑฑ
ฑฑฬออออออออออุอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออนฑฑ
ฑฑบRevisao   ณ           บAutor  ณ                      บ Data ณ                บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IM76A01()

	Local aArea				:= GetArea()
//	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IM76A01"

	Private oMV_PAR01
	Private oMV_PAR02
	Private oMV_PAR03
	Private oMV_PAR04
	Private oMV_PAR05
	Private oMV_PAR06
	Private oMV_PAR07
	Private oMV_PAR08
	Private oMV_PAR09
	Private oMV_PAR10
	Private oGetRank
	Private oAdvog
	Private oGetRank2
	Private oScroll	
	Private oScrol2	
	Private aHdr1			:= {}
	Private aHdr2			:= {}
	Private aCols			:= {}
	Private aCposRank		:= {}
	Private aCols1			:= {}
	Private	aCols2			:= {}
	Private aColsTotal		:= {}
	Private aTamObj			:= Array(4)

	Private aCoord			:= FWGetDialogSize(oMainWnd)
	Private cVldDel			:= "AllwaysFalse()"
	Private cVldDelT		:= "AllwaysFalse()"
	Private cVldLOk			:= "AllwaysTrue()"
	Private cVldTOk			:= "AllwaysTrue()"
	Private cFieldOk		:= "AllwaysTrue()"
	Private nStyle			:= GD_UPDATE
	Private oVlEnv
	Private oTotRegs
	Private nVlCausa		:= 0
	Private nVlEnv			:= 0
	Private nTotRegs		:= 0
	Private lDrill			:= .F.
	Private lIncPro			:= .T.
	Private lIncInf			:= .T.
	Private lArquiv			:= .T.
	Private nNivel			:= 1
	Private oDlg	 		:= Nil, oDlg1 := Nil, oDlg2 := Nil, oDlg3 := Nil
	Private oBotVolta
	Private oIncProc
	Private oIncInfo
	Private oIncInf2
	Private oAltInf
	Private oExcInfo
	Private aRecSel			:= {}
	Private oCombo1  	:= "3=Todos"
	Private _cCombo1 	:= "3=Todos"
	Private cAdvog		:= Space(60)

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	aAdd(aHdr1,{" "		 		 		,"Z9_CHANPER"	,"@BMP"							,TamSX3("Z9_CHANPER") [1] 	,TamSX3("Z9_CHANPER") [2]	,			,""			,TamSX3("Z9_CHANPER") [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{" "		 		 		,"Z9_CHANPER"	,"@BMP"							,TamSX3("Z9_CHANPER") [1] 	,TamSX3("Z9_CHANPER") [2]	,			,""			,TamSX3("Z9_CHANPER") [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Nฐ Processo"			,"Z9_NUMINI"	,PesqPict("SZ9","Z9_NUMINI")	,TamSX3("Z9_NUMINI")[1]		,TamSX3("Z9_NUMINI")[2]	 	,			,""			,TamSX3("Z9_NUMINI")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Parte Contrแria"		,"Z9_DESAUTO"	,PesqPict("SZ9","Z9_DESAUTO")	,35							,TamSX3("Z9_DESAUTO")[2]	,			,""			,TamSX3("Z9_DESAUTO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Reu"					,"Z9_DESREU"	,PesqPict("SZ9","Z9_DESREU")	,35							,TamSX3("Z9_DESREU")[2]		,			,""			,TamSX3("Z9_DESREU")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Advogado"				,"Z9_DESCADV"	,PesqPict("SZ9","Z9_DESCADV")	,35							,TamSX3("Z9_DESCADV")[2]	,			,""			,TamSX3("Z9_DESCADV")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Data Distribui็ใo"		,"Z9_DATDIST"	,PesqPict("SZ9","Z9_DATDIST")	,35							,TamSX3("Z9_DATDIST")[2]	,			,""			,TamSX3("Z9_DATDIST")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Data Prazo"			,"Z9_DTPRAZO"	,PesqPict("SZ9","Z9_DTPRAZO")	,35							,TamSX3("Z9_DTPRAZO")[2]	,			,""			,TamSX3("Z9_DTPRAZO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Cidade"				,"Z9_CIDADE"	,PesqPict("SZ9","Z9_CIDADE")	,35							,TamSX3("Z9_CIDADE ")[2]	,			,""			,TamSX3("Z9_CIDADE ")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Natureza"				,"Z9_DESNATU"	,PesqPict("SZ9","Z9_DESNATU")	,35							,TamSX3("Z9_DESNATU")[2]	,			,""			,TamSX3("Z9_DESNATU")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"A็ใo"					,"Z9_ACAO"		,PesqPict("SZ9","Z9_ACAO")		,35							,TamSX3("Z9_ACAO")[2]	 	,			,""			,TamSX3("Z9_ACAO")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Fase  "				,"Z9_DESAUTO"	,PesqPict("SZ9","Z9_DESAUTO")	,35							,TamSX3("Z9_DESAUTO")[2]	,			,""			,TamSX3("Z9_DESAUTO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Valor Causa"			,"Z9_VALCAUS"	,PesqPict("SZ9","Z9_VALCAUS")	,TamSX3("Z9_VALCAUS")[1]	,TamSX3("Z9_VALCAUS")[2]	,			,""			,TamSX3("Z9_VALCAUS")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr1,{"Valor Envolvido"		,"Z9_VALENVO"	,PesqPict("SZ9","Z9_VALENVO")	,TamSX3("Z9_VALENVO")[1]	,TamSX3("Z9_VALENVO")[2]	,			,""			,TamSX3("Z9_VALENVO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})

	aAdd(aHdr2,{" "						,"ZZ8_COD"		,"@BMP"							,TamSX3("ZZ8_COD")[1]		,TamSX3("ZZ8_COD")[2]	 	,			,""			,TamSX3("ZZ8_COD")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr2,{"ID"					,"ZZ8_COD"		,PesqPict("ZZ8","ZZ8_COD")		,TamSX3("ZZ8_COD")[1]		,TamSX3("ZZ8_COD")[2]	 	,			,""			,TamSX3("ZZ8_COD")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr2,{"Tipo"					,"ZZ8_TIPO"		,PesqPict("ZZ8","ZZ8_TIPO")		,TamSX3("ZZ8_TIPO")[1]		,TamSX3("ZZ8_TIPO")[2]		,			,""			,TamSX3("ZZ8_TIPO")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHdr2,{"Advogado"				,"ZZ8_DESCAD"	,PesqPict("ZZ8","ZZ8_DESCAD")	,TamSX3("ZZ8_DESCAD")[1]	,TamSX3("ZZ8_DESCAD")[2]	,			,""			,TamSX3("ZZ8_DESCAD")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHdr2,{"Data Acompanhamento"	,"ZZ8_DATACO"	,PesqPict("ZZ8","ZZ8_DATACO")	,TamSX3("ZZ8_DATACO")[1]	,TamSX3("ZZ8_DATACO")[2]	,			,""			,TamSX3("ZZ8_DATACO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	
//	aAdd(aHdr2,{"Descri็ใo"				,"ZZ8_DESC"		,"C"							,60							,TamSX3("ZZ8_DESC")[2]		,			,""			,TamSX3("ZZ8_DESC")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
//	aAdd(aHdr2,{"Observa็ใo"			,"ZZ8_OBS"		,PesqPict("SZ3","ZZ8_OBS")		,TamSX3("ZZ8_OBS")[1]		,TamSX3("ZZ8_OBS")[2]		,			,""			,TamSX3("ZZ8_OBS")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})		
	aAdd(aHdr2,{"Observa็ใo"			,"Z3_OBSRMUL"	,PesqPict("SZ3","Z3_OBSRMUL")	,TamSX3("Z3_OBSRMUL")[1]	,TamSX3("Z3_OBSRMUL")[2]	,			,""			,TamSX3("Z3_OBSRMUL")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})

	AADD(aCols, {"","","","",CToD("  /  /  "),"","","","","","","","","","","","",""})
	AADD(aCols2, {"","",CToD("  /  /  "),"",""})

	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD
	

	oDlg := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Juridico"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oDlg,.F.)

	oArea:AddLine("L01",30,.T.)
	oArea:AddLine("L02",35,.T.)
	oArea:AddLine("L03",35,.T.)

	oArea:AddCollumn("L01PARA"  , 60,.F.,"L01")
	oArea:AddCollumn("L01TOTA"  , 28,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 12,.F.,"L01")

	oArea:AddCollumn("L02DLG"   ,100,.F.,"L02")
	
	oArea:AddCollumn("L03DLG"   , 88,.F.,"L03")
	oArea:AddCollumn("L03BOTO"  , 12,.F.,"L03")
	
	oArea:AddWindow("L01PARA" ,"L01PARA"	,"Parโmetros"			, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01TOTA" ,"L01TOTA"	,"Totais" 				, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"	,"Fun็๕es" 				, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)

	oArea:AddWindow("L02DLG" ,"L02DLG"  	,"Processos"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L03DLG" ,"L03DLG"  	,"Informa็๕es"			, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)		
	oArea:AddWindow("L03BOTO" ,"L03BOTO"  	,"Fun็๕es"				, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)			

	oPainPara  := oArea:GetWinPanel("L01PARA"  	,"L01PARA" 	,"L01")
	oPainTota  := oArea:GetWinPanel("L01TOTA"  	,"L01TOTA" 	,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  	,"L01BOTO" 	,"L01")

	oPain1     := oArea:GetWinPanel("L02DLG"  	,"L02DLG"  	,"L02")
	oPain2	   := oArea:GetWinPanel("L03DLG"  	,"L03DLG"  	,"L03")
	oPainBot2  := oArea:GetWinPanel("L03BOTO"  	,"L03BOTO" 	,"L03")


	SetKey(VK_F1,{||Help("IM76A01")})
	SetKey(VK_F2,{||DV97A05L()})


	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth) 
	aTamObj[4] := (oPainBoto:nClientHeight)

	oScroll 		:= TScrollBox():New(oPainBoto,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT

	oScrol2 		:= TScrollBox():New(oPainPara,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
	oScrol2:Align 	:= CONTROL_ALIGN_ALLCLIENT

	oScrol3 		:= TScrollBox():New(oPainTota,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
	oScrol3:Align 	:= CONTROL_ALIGN_ALLCLIENT


	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Atualizar",oScroll,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||GeraRank(2)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Incluir Processo",oScroll,{|| INCPROC()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Visualizar Processo",oScroll,{|| VISUPROC(1)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Alterar Processo",oScroll,{|| VISUPROC(2)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Excluir Processo",oScroll,{|| VISUPROC(3)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oArquivo := tButton():New(aTamObj[1],aTamObj[2],"Arquivos",oScroll,{|| ARQUIVOS(aCols1[oDlg1:nAt][3])},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oArquivo:lActive := lArquiv })
	/*
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Gera REL",oScroll,{|| REL()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro})*/
	
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oIncProc := tButton():New(aTamObj[1],aTamObj[2],"Gerar Excel",oScroll,{|| GeraExcel(aCols1)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oIncProc:lActive := lIncPro*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oScroll,{|| oDlg:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })



	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBot2)
	oIncInf2 := tButton():New(aTamObj[1],aTamObj[2],"Incluir Informa็ใo",oPainBot2,{|| INCINFO()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncInf2:lActive := lIncInf })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oAltInf := tButton():New(aTamObj[1],aTamObj[2],"Visualizar Informa็ใo",oPainBot2,{|| VISUAL(1)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oAltInf := tButton():New(aTamObj[1],aTamObj[2],"Alterar Informa็ใo",oPainBot2,{|| VISUAL(2)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oAltInf := tButton():New(aTamObj[1],aTamObj[2],"Gerar Excel",oPainBot2,{|| GeraExcel2(aCols1)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })
	
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oExcInfo := tButton():New(aTamObj[1],aTamObj[2],"Excluir Informa็ใo",oPainBot2,{|| VISUAL(3)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oIncProc:lActive := lIncPro })


	@  07,   00 Say oSay1 Prompt 'Processo De:'		FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel	
	@  19,   00 Say oSay1 Prompt 'Processo At้:'	FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel
	@  31,   00 Say oSay1 Prompt 'Data De:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel	
	@  43,   00 Say oSay1 Prompt 'Data At้:'		FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel
	@  55,   00 Say oSay1 Prompt 'Natureza De:'		FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel	
	@  67,   00 Say oSay1 Prompt 'Natureza At้:'	FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel

	@  07,  130 Say oSay1 Prompt 'Reu De:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel
	@  19,  130 Say oSay1 Prompt 'Reu At้:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel
	@  31,  130 Say oSay1 Prompt 'Advogado:'		FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	Of oScrol2
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	Of oScrol2
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	Of oScrol2	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	Of oScrol2
	@  53,  55 	MSGet oMV_PAR03	Var MV_PAR05 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	F3 "ZZ7" Of oScrol2
	@  65,  55 	MSGet oMV_PAR04	Var MV_PAR06 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	F3 "ZZ7" Of oScrol2

	@  05,  185	MSGet oMV_PAR04	Var MV_PAR07 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	F3 "ZZ6" Of oScrol2
	@  17,  185	MSGet oMV_PAR04	Var MV_PAR08 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	F3 "ZZ6" Of oScrol2
	@  29,  185	MSGet oAdvog	Var cAdvog	 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE 120, 05 When .T. Of oScrol2

	@  07,  05 Say  oSay Prompt 'Total Registros:'		FONT oFont11 COLOR CLR_GRAY pixel Size  60, 08 Of oScrol3
	@  19,  05 Say  oSay Prompt 'Val. Causas R$:'		FONT oFont11 COLOR CLR_GRAY pixel Size  60, 08 Of oScrol3
	@  31,  05 Say  oSay Prompt 'Val. Envolvido R$:'	FONT oFont11 COLOR CLR_GRAY pixel Size  60, 08 Of oScrol3

	@  07,  70 MSGet oTotRegs	Var nTotRegs	 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .F. Picture "@R 99999" Of oScrol3
	@  19,  70 MSGet oVlCausa	Var nVlCausa	 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScrol3
	@  31,  70 MSGet oVlEnv		Var nVlEnv		 		FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScrol3

	@  43,  130 Say oSay1 Prompt 'Status:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScrol2 Pixel

	@  55,  190 Say  oSay Prompt 'Help F1'		FONT oFont11 COLOR CLR_GRAY Size  50, 280 Of oScrol2 Pixel
	@  55,  230 Say  oSay Prompt 'Legenda F2'	FONT oFont11 COLOR CLR_GRAY Size  50, 280 Of oScrol2 Pixel

	oCombo1 :=TComboBox():New( 41,  185,{|u|if(PCount()>0, _cCombo1:=u, _cCombo1)},{"1=Em andamento ","2=Encerrado","3=Todos"},085, 05, oScrol2, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

    _cCombo1 := '3'

    oArea:setWinTitle("L03DLG" ,"L03DLG","Informa็๕es do Processo","L03" )    
	
	oDlg:Activate(,,,.T.,/*valid*/,,{|| GeraRank(1) } )

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

	aCols1 			:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}
	aCols2 			:= {}
	nCont			:= 0
	nTotRegs		:= 0
	nVlEnv			:= 0
	nVlCausa		:= 0	
	cChance			:= ""
	cStatus			:= ""
	nValores		:=""
	cProces			:= ""
	
	cQuery	:= "SELECT *																	" 		+ CRLF
	cQuery	+= "FROM " + RetSQLName("SZ9") + " SZ9											" 		+ CRLF
	cQuery	+= "WHERE SZ9.D_E_L_E_T_ = ' '													" 		+ CRLF
	cQuery	+= "AND SZ9.Z9_NUMINI BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "				+ CRLF
	cQuery 	+= "AND SZ9.Z9_DATDIST BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "	+ CRLF
	cQuery 	+= "AND SZ9.Z9_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "				+ CRLF
	cQuery 	+= "AND SZ9.Z9_REU BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "					+ CRLF
	cQuery 	+= "AND SZ9.Z9_ADVOG BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "				+ CRLF
	
		If !Empty(Alltrim(cAdvog))
			cQuery += " AND SZ9.Z9_DESCADV LIKE '%" + Alltrim(cAdvog) +  "%' "						+ CRLF
		Endif
		
		If _cCombo1 <> '3'
			cQuery += " AND SZ9.Z9_STSPROS = '" + _cCombo1 +  "' "									+ CRLF		
		Endif
	
	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(DbGoTop())

		Do While !(cAlias)->(Eof())

			If (cAlias)->Z9_STSPROS == '1'
				cLeg_1 := LoadBitmap( GetResources(), "BR_VERDE" )
			Elseif (cAlias)->Z9_STSPROS == '2'
				cLeg_1 := LoadBitmap( GetResources(), "BR_VERMELHO" )
			Else
				cLeg_1 := LoadBitmap( GetResources(), "BR_BRANCO" )
			Endif
			
			cChance := (cAlias)->Z9_CHANPER
			If cChance == '1'
				cChance := "Remota"
			elseIf cChance =='2'
				cChance := "Possivel"
			elseIf cChance == '3'
				cChance := "Provavel"
			EndIf
			
			
			cStatus := (cAlias)->Z9_STSPROS
			If cStatus == '1'
				cStatus := "Em andamento"
			elseIf cStatus =='2'
				cStatus := "Encerrado"
			elseIf cStatus == '3'
				cStatus := "Despejo decretado"
			EndIf
			
			
			 cAdvogado := (cAlias)->Z9_ADVOG + " - " + (cAlias)->Z9_DESCADV
			  //cAutor := (cAlias)->Z9_AUTOR + " - " + (cAlias)->Z9_DESAUTO
			 cReu := (cAlias)->Z9_REU + " - " + (cAlias)->Z9_DESREU
			 	//cNaturez := (cAlias)->Z9_NATUREZ + " - " + (cAlias)->Z9_DESNATU
			 	//cDtPrazo  := DTOC(StoD((cAlias)->Z9_DATDIST) + (cAlias)->Z9_DIAS)
			
			If 1 > 2
				cLeg_2 := LoadBitmap( GetResources(), "BR_AZUL" )
			Else
				cLeg_2 := LoadBitmap( GetResources(), "BR_PRETO" )
			Endif
			
			nValores := (cAlias)->Z9_VALCAUS + (cAlias)->Z9_CUSTOS	+ (cAlias)->Z9_DEPRO + (cAlias)->Z9_DEPAIRO + (cAlias)->Z9_DEPRR +	(cAlias)->Z9_DEPAIRR + (cAlias)->Z9_DEPREX + (cAlias)->Z9_BLOQ1 + (cAlias)->Z9_BLOQ2
		
			aAdd(aCols1,{cLeg_1,;
			cLeg_2,;
			(cAlias)->Z9_NUMINI,;
			(cAlias)->Z9_DESAUTO,;
			cReu,;
			cAdvogado,;
			DtoC(StoD((cAlias)->Z9_DATDIST)),;
			(cAlias)->Z9_DTPRAZO,;
			(cAlias)->Z9_CIDADE,; //Comarca
			(cAlias)->Z9_DESNATU,;
			(cAlias)->Z9_ACAO,;
			(cAlias)->Z9_FASE,; //Andamento
			(cAlias)->Z9_VALCAUS,;
			nValores,;
			(cAlias)->Z9_LOCALID,;
			(cAlias)->Z9_ORGAO,;
			(cAlias)->Z9_VARA,;
			cChance,;
			cStatus,;
			})

			nTotRegs++
			nVlEnv 		+= (cAlias)->Z9_VALENVO
			nVlCausa 	+= (cAlias)->Z9_VALCAUS

			(cAlias)->(DbSkip())

		EndDo
 
			
	If nOpc <> 2
		oDlg1 := MsNewGetDados():New(aCoord[1],aCoord[2],oPain1:nClientHeight/2,oPain1:nClientWidth/2,nStyle,cVldLOk ,cVldTOk, ,aCposRank, ,9999,cFieldOk,cVldDelT ,cVldDel,oPain1,@aHdr1,@aCols1,{|| IM76ATU()})
		oDlg1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		oDlg1:oBrowse:brClicked := {|| LJMsgRun("Classificando...","Aguarde...",{|| ClasGrid(@aCols1,oDlg1:oBrowse:ColPos,@oDlg1,@oDlg),ClasGrid(@aCols2,oDlg2:oBrowse:ColPos,@oDlg2,@oDlg) } ) }
		
				//oDlg1 := MsNewGetDados():New(aCoord[1],aCoord[2],oPain1:nClientHeight/2,oPain1:nClientWidth/2,nStyle,cVldLOk ,cVldTOk,"",aCposRank, ,9999,cFieldOk,cVldDelT ,cVldDel,oPain1,@aHdr1,@aCols1,{|| IM76ATU(aCols1[oDlg1:nAt][3],[oDlg1:nAt][4])})
	    oDlg2 := MsNewGetDados():New(aCoord[1],aCoord[2],oPain2:nClientHeight/2,oPain2:nClientWidth/2,nStyle,cVldLOk ,cVldTOk,"", ,0 ,9999,cFieldOk,cVldDelT ,cVldDel,oPain2 ,@aHdr2 ,@aCols2,{|| }/*uChange*/)
	    oDlg2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
	    		//oDlg2:oBrowse:brClicked := {|| LJMsgRun("Classificando...","Aguarde...",{|| ClasGrid(@aCols2,oDlg2:oBrowse:ColPos,@oDlg2,@oDlg) } ) }
	Endif
	
	aCols2 := aSort(aCols2,,,{|x,y| x[3]+x[4] < y[3]+y[4]})
	
	oDlg1:SetArray(aCols1)
	oDlg1:oBrowse:SetFocus(1)
	oDlg1:Refresh()

	//oDlg2:SetArray(aCols2)
	//oDlg2:Refresh()

	
	(cAlias)->(DbCloseArea())

	If Len(aCols1) > 0
		IM76ATU()
	Endif

Return

/////////////////////////////////////////////
// Classifica็ใo do grid
/////////////////////////////////////////////

Static Function ClasGrid(aCols,nCol,oGetDados,oDlg)

	Local nxt

	If nCol > 0 .and. !Empty(aCols) .and. len(aCols) > 1
			
			if aCols[1,nCol] > aCols[len(aCols),nCol]
				aCols := aSort(aCols,,,{|x,y| x[nCol] < y[nCol] })
			else
				aCols := aSort(aCols,,,{|x,y| x[nCol] > y[nCol] })
			endif

		oGetDados:SetArray(aCols)
		oGetDados:Refresh()
		oDlg:Refresh()

	Endif

Return




Static Function INCPROC()

Private cCadastro 	:= "Inclusใo de Processo"

	Axinclui("SZ9",Recno(),3)
	
	GeraRank(2)
	
Return



Static Function INCINFO()

	Private cProcesso 	:= oDlg1:aCols[oDlg1:nAt][3]
	Private cCodigo 	:= GERACOD(cProcesso)
	Private cCadastro 	:= "Ocorr๊ncias Processo Juridico"

	Axinclui("ZZ8",Recno(),3)

	If ZZ8->ZZ8_STSINF == '2'

		DbSelectArea("SZ9")
		DbSetOrder(1)
		
		If  SZ9->( dbSeek( xFilial("SZ9") + cProcesso))
		
		RecLock( "SZ9", .F. )
			SZ9->Z9_STSPROS	:= '2'
		MsUnLock()	

		Endif
		
		DbCloseArea()
	
	Endif
	
	GeraRank(2)

    oDlg1:SetArray(aCols1)
	oDlg1:Refresh()
	
Return




Static Function GERACOD(cProcesso)

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()

	cQuery	:= "SELECT MAX(ZZ8_COD) AS MAXCODIGO		" 				+ CRLF
	cQuery	+= "FROM " + RetSQLName("ZZ8") + " ZZ8	"	 				+ CRLF
	cQuery	+= "WHERE ZZ8_FILIAL = '" + xFilial("ZZ8") + "'" 			+ CRLF
	cQuery	+= "AND ZZ8_PROCES = '" + cProcesso + "'" 					+ CRLF
	cQuery	+= "AND ZZ8.D_E_L_E_T_ = ' ' "								+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(dbGoTop())
	
	cCodigo	:= (cAlias)->MAXCODIGO
		
	cCodigo	:= STRZERO(Val(cCodigo) + 1,4,0)
	
Return(cCodigo)





Static Function SELARQUI(cProcesso)

	Local cArq 		:= ''
	Local cNomArq 	:= ""

	cArq := cGetFile('Arquivo PDF|*.Pdf','Selecione arquivo',0,'C:\Dir\',.T.,,.F.)

	cNomArq := RetFileName(cArq) + ".pdf"

		If !File(cArq)
			MsgInfo( "Opera็ใo cancelada ou arquivo invแlido. Verifique.")
			Return(.F.)
		Endif

	If __CopyFile( cArq, "\Arquivos Juridico\" + cNomArq + " ") // Copia arquivos do cliente para o Servidor 
		MsgInfo("Arquivo " + cNomArq + " armazenado em nosso servidor Cloud", "TOTVS")
		DbSelectArea("ZZ9")
	
		DbSetOrder(1)
		
		RecLock( "ZZ9", .T. )
			ZZ9->ZZ9_NUMINI	:= cProcesso
			ZZ9->ZZ9_NOMARQ	:= cNomArq
		MsUnLock()
	
		DbCloseArea()	
		
	Else
	
		MsgInfo("Nใo foi possivel copiar o arquivo para nosso servidor, favor contatar o administrador do sistema","Aten็ใo")
	
	Endif
	
	GeraInfo(cProcesso)

Return( Nil )



Static Function ARQUIVOS(cProcesso)

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()

	Private oGetRank
	Private aHeadRank		:= {}
	Private aColsRank		:= {}
	Private aTamObj			:= Array(4)

	Private aCoord			:= FWGetDialogSize(oMainWnd)

	Private oOk				:= LoadBitmap( GetResources(), "LBOK"  )
	Private oNo				:= LoadBitmap( GetResources(), "LBNO"  )
	Private nMark_Est 		:= 0, nMark_End := 0,  nMark_XXX := 0,  nMark_Del := 0
	Private oCheckBOX
	Private lCheckBOX 		:= .F.
	Private aArqs			:= {}
	Private oArquivos
	
	aAdd(aArqs, {.F.,"",""})

	//	Variแveis de outra Fun็ใo
	
	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3]-215,aCoord[4]-403,OemToAnsi("Rela็ใo de arquivos do Processo: " + cProcesso + " "),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",100,.T.)

	oArea:AddCollumn("L01FRET"  , 90,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 10,.F.,"L01")

	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Informa็๕es"							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)		
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Op็๕es" 								, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)

	oInfo  		:= oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L01")
	oPainBot  	:= oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")

	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oInfo:nClientWidth/2,oInfo:nClientHeight/2,GD_UPDATE,"AllwaysTrue()" ,"AllwaysTrue()",,{},0,9999,"AllwaysTrue()","AllwaysFalse()","AllwaysFalse()",oInfo,@aHeadRank,@aArqs,/*uChange*/)

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBot:nClientWidth)
	aTamObj[4] := (oPainBot:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBot)
	oBotUplo := tButton():New(aTamObj[1],aTamObj[2],"Incluir Arquivo",oPainBot,{|| SELARQUI(cProcesso)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotDown := tButton():New(aTamObj[1],aTamObj[2],"Baixar Arquivo",oPainBot,{|| BAIXAARQ(cProcesso)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oPainBot,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	@ 0, 0 LISTBOX oArquivos		FIELDS HEADER "","Nบ Processo","Arquivo" FIELDSIZES 15,10,30,35 SIZE oInfo:nClientWidth/2, oInfo:nClientHeight/2.2 OF oInfo

	ShowEst()

	oArquivos:bLDblClick := {|| aArqs[oArquivos:nAt][1] := !aArqs[oArquivos:nAt][1], aArqs:DrawSelect() }

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || GeraInfo(cProcesso)})})

	RestArea(aArea)

Return

Static Function GeraInfo(cProcesso)

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local nCnt		:= 0
	Local nCont		:= 0
	
	aArqs	  		:= {}
			
	_cQuery	:= "SELECT	*																			" + CRLF
	_cQuery	+= "FROM " + RetSQLName("ZZ9") + " ZZ9													" + CRLF
	_cQuery	+= "WHERE ZZ9.ZZ9_NUMINI = '" + cProcesso + "'											" + CRLF	
	_cQuery	+= "AND ZZ9.D_E_L_E_T_ = ' '															" + CRLF

	TCQUERY _cQuery NEW ALIAS (cAlias)
	
	(cAlias)->(DbGoTop())
 	
		Do While !(cAlias)->(Eof())

			nCont++
						
			aAdd(aArqs,{.F.,; 
			(cAlias)->ZZ9_NUMINI,;
			(cAlias)->ZZ9_NOMARQ})

			(cAlias)->(DbSkip())

		EndDo

	(cAlias)->(DbCloseArea())

	ShowEst()
	oArquivos:Refresh()
	oArquivos:bLDblClick := {|| MarcaEst(1) }
	oArquivos:brClicked  := {|| OrdemEst(1) }

	oGetRank:SetArray(aArqs)
	oGetRank:Refresh()
	oGetRank:oBrowse:SetFocus()

Return()

Static Function ShowEst()

	oArquivos:SetArray(aArqs)
	oArquivos:bLine	:= {||{If(aArqs[oArquivos:nAt,1],oOk,oNo),;
	aArqs[oArquivos:nAt,2],;
	aArqs[oArquivos:nAt,3] }}
	
Return

Static Function Seltodos(aArqs)

		MarcaEst(2)
		
Return()

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
	Local nLinha  := oArquivos:nAt
	Local ncoluna := oArquivos:ColPos
	Local sEnder   := 'XX'
	Local nsaldo   := 0

	///////////////////////////////////////////////////////////////////

		If nOpc == 1
			If aArqs[oArquivos:nAt][1]          ///////////////////Desmarcando Array
				nMark_Del := Val(aArqs[oArquivos:nAt,2])
				aArqs[oArquivos:nAt][1] := !aArqs[oArquivos:nAt][1]
				oArquivos:DrawSelect()
				oArquivos:Refresh()		
				Return			
			Endif
			
			AchMarca()  
		
			nMark_End := 0
			nMark_XXX := 0
		
			aArqs[oArquivos:nAt][1] := !aArqs[oArquivos:nAt][1]
			oArquivos:DrawSelect()
		
			If aArqs[oArquivos:nAt][1]
				nMark_Est++
				Else
			EndIf

		Else
			For nx := 1 To Len(aArqs)
						If aArqs[nx][1]          ///////////////////Desmarcando Array
							nMark_Del := Val(aArqs[nx][2])
							aArqs[nx][1] := !aArqs[nx][1]
							oArquivos:DrawSelect()
							oArquivos:Refresh()		
						Else
						
							AchMarca()  
						
							nMark_End := 0
							nMark_XXX := 0
						
							aArqs[nx][1] := !aArqs[nx][1]
							oArquivos:DrawSelect()
					
							If aArqs[nx][1]
								nMark_Est++
							EndIf
						Endif
			Next			
		
		Endif
	
	oArquivos:Refresh()
	nlinEst := nLinha 
	
Return

	
Static Function OrdemEst(nOpc)

	Local nLin := oArquivos:nAt
	Local ncol := oArquivos:ColPos
	Local nxt

	if nCol > 1 .and. !Empty(aArqs) .and. len(aArqs) > 1
		if aArqs[1,nCol] > aArqs[Len(aArqs)-1,nCol]
			aArqs     := aSort(aArqs,1,Len(aArqs)-1,{|x,y| x[nCol] < y[nCol] })		
		else
			aArqs     := aSort(aArqs,1,Len(aArqs)-1,{|x,y| x[nCol] > y[nCol] })
		endif
	endif
	ShowEst()
	oArquivos:Refresh()	
Return()

Static Function AchMarca()
	nMark_Est := 0
	For i := 1 To Len(aArqs)
		nMark_XXX := Val(aArqs[i,2])		
		If nMark_XXX  > nMark_Est
			nMark_Est := Val(aArqs[i,2])	
		Endif
	Next i
	
Return

Static Function BAIXAARQ(cProcesso)

Local cDirIg 	:= ""
Local lSelec	:= .F.

	For i := 1 to len(aArqs)

		If aArqs[i][1]
			lSelec := .T.
		Endif

	Next i

	If !lSelec
		MsgInfo("Nenhum registro selecionado","TOTVS")
		Return
	Endif

	cDirIg := cGetFile( '*.*' , 'Arquivos', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

	If Empty(Alltrim(cDirIg))
		Return(.F.)
	Endif

	If lSelec

		For nx := 1 to len(aArqs)

			If aArqs[nx][1]

			CpyS2T( "\Arquivos Juridico\" + aArqs[nx][3] , cDirIg, .F. )	

			shellExecute("Open", cDirIg+aArqs[nx][3], " /k dir", "C:\", 1 )
			
			Endif

		Next nx

		MsgInfo("Arquivos disponํveis no caminho: " + cDirIg+" ", "TOTVS")

		GeraInfo(cProcesso)

	Endif

Return

Static Function EXCLUIARQ(cProcesso)

	If MsgYesNo("Deseja realmente excluir arquivos selecionados?","TOTVS")
	
		For nx := 1 to len(aArqs)
		
			If aArqs[nx][1]
			
			MsErase('\Arquivos Juridico\' + aArqs[nx][3])		
	
			Endif
	
		Next nx
		
	Endif

Return

Static Function VISUARQ()

	For nx := 1 to len(aArqs)
	
		If aArqs[nx][1]
				
			MsErase('\Arquivos Juridico\' + aArqs[nx][3])		
			
		Endif
	
	Next nx

Return


/*
Funcao      : DV97A05L
Objetivos   : Tela de Legendas
*/
Static Function DV97A05L()

	Local ny       := 0
	Local nx       := 0

	Local aSit := {{ "BR_VERMELHO","Encerrado"},{ "BR_VERDE","Em Andamento"}}

	Local aCau := {{ "BR_AZUL","Dentro do Prazo"},{ "BR_PRETO","Fora do Prazo"}}
	
	Local aCompAgn :={{"BR_MARRON_OCEAN","Compromissos"},{"BR_AMARELO","Andamento"}}

	Local nXSize := 14
	Local aBmp := {}

	oDlgLeg := TDialog():New(000,000,300,250,OemToAnsi("Legendas"),,,,,,,,oMainWnd,.T.)

	//GRUPO 01
	oGrpLg1 := TGroup():New(000,002,60,160,'Status Processo - 1ฐ coluna',oDlgLeg,CLR_BLUE,,.T.)

	aBmp := array(Len(aSit))
	For nX := 1 to Len(aSit)
		@ nx*10,10 BITMAP aBmp[nx] RESNAME aSit[nx][1] of oGrpLg1 SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ nx*10,(nXSize/2) + 13 SAY If((ny+=1)==ny,aSit[ny][2]+If(ny==Len(aSit),If((ny:=0)==ny,"",""),""),"") of oGrpLg1 PIXEL
	Next nX
	ny := 0

	//GRUPO 02 	
	oGrpLg2 := TGroup():New(060,002,120,160,'Prazo Processo - 2ฐ coluna',oDlgLeg,CLR_BLUE,,.T.)

	aBmp := array(Len(aCau))
	For nX := 1 to Len(aCau)
		@ (nx*10)+60,10 BITMAP aBmp[nx] RESNAME aCau[nx][1] of oGrpLg2 SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ (nx*10)+60,(nXSize/2) + 13 SAY If((ny+=1)==ny,aCau[ny][2]+If(ny==Len(aCau),If((ny:=0)==ny,"",""),""),"") of oGrpLg2 PIXEL
	Next nX
	ny := 0
	
	
	//Informa็๕es
	oGrpLg3 := TGroup():New(120,002,240,160,'Informa็๕es do Processo',oDlgLeg,CLR_BLUE,,.T.)
	aBmp := array(Len(aCompAgn))
	For nx := 1 to Len(aCompAgn)
		@ (nx*10)+120,10 BITMAP aBmp[nx] RESNAME aCompAgn[nx][1] of oGrpLg3 SIZE 20,10 NOBORDER WHEN .F. PIXEL
		@ (nx*10)+120,(nXSize/3) + 13 SAY If((ny+=1)==ny,aCompAgn[ny][2]+If(ny==Len(aCompAgn),If((ny:=0)==ny,"",""),""),"") of oGrpLg3 PIXEL
	Next nx
	ny := 0

	oDlgLeg:Activate(,,,.T.,/*valid*/,,,)
	
Return





Static Function Help(cArq)
	
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



// ----------------------------------------------------------------------Tํtulo alterแvel ----------------------------------------------------------------
User Function S97TRA(cProcesso)

	DbSelectArea("SZ9")
	SZ9->(DbSetOrder())
	SZ9->(DbSeek(xFilial("SZ9") + cProcesso))

	If ALLTRIM(cProcesso) == ""
		oArea:setWinTitle("L03DLG" ,"L03DLG","Informa็๕es do Processo" ,"L03" )
	Else
		oArea:setWinTitle("L03DLG" ,"L03DLG","Nฐ do Processo: " + cProcesso + " | NฐPROC: " + SZ9->Z9_NPROC,"L03" )
	Endif
	
Return
// -------------------------------------------------------------------------------------------------------------------------------------------------------



Static Function IM76ATU()

	Local cProcesso := aCols1[oDlg1:nAt][3]
	Local cQuery1	:= ""
	Local cAlias	:= GetNextAlias()
	Local cTipo 	:= ""


	aCols2 := {}

	cQuery1	:= "SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZZ8_OBS)),'') AS ZZ8_OBSC , *
	cQuery1	+= "FROM " + RetSQLName("ZZ8") + " ZZ8											" 		+ CRLF
	cQuery1	+= "WHERE ZZ8.D_E_L_E_T_ = ' '													" 		+ CRLF
	cQuery1	+= "AND ZZ8.ZZ8_PROCES = '" + cProcesso + "' "											+ CRLF

	TCQUERY cQuery1 NEW ALIAS (cAlias)
			
	(cAlias)->(DbGoTop())

	Do While !(cAlias)->(Eof())
	
		cTipo := Alltrim((cAlias)->ZZ8_TIPO)
	
		If cTipo == 'ANDAMENTO'
			cLeg := LoadBitmap( GetResources(), "BR_AMARELO" )
		else
			cLeg := LoadBitmap( GetResources(), "BR_MARRON_OCEAN" )
		endif
		
		aAdd(aCols2,{cLeg,;
		(cAlias)->ZZ8_COD,;
		(cAlias)->ZZ8_TIPO,;
		(cAlias)->ZZ8_DESCAD,;
		DtoC(StoD((cAlias)->ZZ8_DATACO)),;
		(cAlias)->ZZ8_OBSC,;
		(cAlias)->ZZ8_PROCES,;
		.F.})

		(cAlias)->(dbSkip())
		
	EndDo

	(cAlias)->(DbCloseArea())

	oDlg2:SetArray(aCols2)
	oDlg2:Refresh()
	oDlg:Refresh()
	
	U_S97TRA(cProcesso)
	
Return



// ================================= Verificar ================================================

Static function REL()

	
ShellExecute( "REL", "C:\Users\aprendiz02.sistema\Documents\testerelatorio.rpm", "Juridico", "C:\", 4 )

Return
// ==========================================================================================



Static Function GeraExcel(aCols)

	Local aExcel := {} 
	Local nx
	Local cPro := aCols[nx,3]
		
		AADD(aExcel,{"NฐProcesso","Autor","Reu","Advogado","Data de distribui็ใo","Data Prazo","Localida","Cidade","Natureza","A็ใo","Fase","Valor da causa","Valor envolvido","Orgใo","Vara","Chance de perca ","Status do processo"})

		For nx := 1 to Len(aCols1)
			AADD(aExcel,{cPro,aCols[nx,4],aCols[nx,5],aCols[nx,6],aCols[nx,7],aCols[nx,8],aCols[nx,15], aCols[nx,9],aCols[nx,10],aCols[nx,11],aCols[nx,12],aCols[nx,13],aCols[nx,14],aCols[nx,16],aCols[nx,17],aCols[nx,18],aCols[nx,19],aCols[nx,20]})
		Next

		DlgToExcel({{"ARRAY", "Processos Jurํdicos", {}, aExcel}})

Return


//================================================ Relat๓rio Andamento/compromisso ================================================
Static Function GeraExcel2() 
	
	Local aColss  := {}
	Local aExcel  := {}
	Local cQuery2 := ""
	Local cAlias  := GetNextAlias()
	Local nx	
	Local cProcesso := aCols1[oDlg1:nAt][3]
	Local cOrigem := ""
	Local cAdvog := ""
	Local cObs := ""
	
	
	cQuery2 := "SELECT * FROM "  + RetSQLName("ZZ8") + " ZZ8" + CRLF
	cQuery2 += "WHERE ZZ8_PROCES = '" + cProcesso + "'      " + CRLF
	cQuery2 += "AND ZZ8.D_E_L_E_T_ = ' '					" + CRLF	
	
	TCQUERY cQuery2 NEW ALIAS (cAlias)
			
	(cAlias)->(DbGoTop())
	

	Do While !(cAlias)->(Eof())
	
		cOrigem := (cAlias)->ZZ8_ORIGEM
		//cAdvog  := (cAlias)->ZZ8_RESP " - " (cAlias)->ZZ8_DESCAD
		 
			If cOrigem == '1'
				cOrigem := "Interno"
			elseIf cOrigem =='2'
				cOrigem := "Forense"
			EndIf
			
			//cObs := cValToChar((cAlias)->ZZ8_OBS)
			
		AADD(aColss,{(cAlias)->ZZ8_TIPO,;
					(cAlias)->ZZ8_RESP,;
					(cAlias)->ZZ8_DSCORG,;
					cObs,;
					(cAlias)->ZZ8_TPCOMP,;
					(cAlias)->ZZ8_LOCAL,;
					(cAlias)->ZZ8_SOLICI,;
					DtoC(StoD((cAlias)->ZZ8_DTINI)),;
					(cAlias)->ZZ8_HRINI,;
					DtoC(StoD((cAlias)->ZZ8_DTFIM)),;
					(cAlias)->ZZ8_HRFIM,;
					(cAlias)->ZZ8_TPAND,;
					DtoC(StoD((cAlias)->ZZ8_DATACO)),;
					(cAlias)->ZZ8_HORA,;
					cOrigem,;
					(cAlias)->ZZ8_INSTAN,;
					.F. })
	
			(cAlias)->(dbSkip())
		
	ENDdO	
	
	(cAlias)->(DbCloseArea())
		
		//Tratar os campos de data *
		aadd(aExcel,{"Informa็ใo","Advogado","Orgใo","Observa็๕es","Tipo Comp.","Local Comp.","Solicitante","Data inicial Comp.","Hora ini.","Data final Comp.","Hora fim","Tipo And.","Data Acomp.","Hora And.","Origem And.","Instโncia","Descri็ใo And."})

		For nx := 1 to Len(aColss)
			aadd(aExcel,{aColss[nx,1], aColss[nx,2], aColss[nx,3],aColss[nx,4],aColss[nx,5],aColss[nx,6],aColss[nx,7],aColss[nx,8],aColss[nx,9],aColss[nx,10],aColss[nx,11],aColss[nx,12],aColss[nx,13],aColss[nx,14],aColss[nx,15],aColss[nx,16]})
		Next
		
		DlgToExcel({{"ARRAY", "Processo: " + cProcesso , {}, aExcel}})
Return






Static Function VISUAL(nOpc)

	Local cProcesso 	:= oDlg2:aCols[oDlg2:nAt][7]
	Local cId			:= oDlg2:aCols[oDlg2:nAt][2]
	Private cCadastro 	:= "Ocorr๊ncias Processos"
	
	DbSelectArea("ZZ8")
	ZZ8->(DbSetOrder(2))
	DbGoTop()

	If  ZZ8->( dbSeek( xFilial("ZZ8") + cProcesso + cId ))

		if nOpc == 1
				AxVisual("ZZ8",ZZ8->(Recno()),2)
		Elseif nOpc == 2
				AxAltera("ZZ8",ZZ8->(Recno()),4)
		Elseif nOpc == 3
			AxDeleta("ZZ8",ZZ8->(Recno()),5)
		Endif

	Endif

	GeraRank(2)

Return()




Static Function VISUPROC(nOpc)

	Local cProcesso 	:= aCols1[oDlg1:nAt][3]

	Private cCadastro 	:= "Processos Juridico"
	
	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1))
	DbGoTop()

	If  SZ9->( dbSeek( xFilial("SZ9") + cProcesso))
	
		If nOpc == 1
		
			AxVisual("SZ9",SZ9->(Recno()),2)
		
		Elseif nOpc == 2
		
			AxAltera("SZ9",SZ9->(Recno()),4)
		
		Elseif nOpc == 3
			
			AxDeleta("SZ9",SZ9->(Recno()),5)
		
		Endif
		
	Endif

	GeraRank(2)

Return()
