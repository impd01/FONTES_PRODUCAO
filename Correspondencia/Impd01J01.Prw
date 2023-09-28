#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"
#INCLUDE "FWPrintSetup.ch"
#Include "RPTDEF.CH"
#Include 'FWMVCDef.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002

Static oBmpOk := LoadBitmap( GetResources(), "LBOK" )
Static oBmpNO := LoadBitmap( GetResources(), "LBNO" )

user function Impd01J01() 

Local aArea				:= GetArea()

Private oArea			:= FWLayer():New()
Private oEndereco
Private oIgreja
Private oTotCon
Private nCont		    := 0
Private nTotatPed       := 0
Private nTotQtd        := 0
Private oGetRank
Private oGetRank2
Private oGetRank3
Private oGetRank4
Private aHeadRank		:= {}
Private aHeadRank2		:= {}
Private aHeadRank3		:= {}
Private aHeadRank4		:= {}
Private aCols			:= {}
Private aCols1			:= {}
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
Private	aCols2			:= {}
Private	aCols3			:= {}
Private aCols4			:= {}
Private cProdDe			:= '          '
Private cProdAte		:= 'ZZZZZZZZZZ'
Private cPedido         := Space(8)
Private cCliAte         := 'ZZZZZZ'
Private cCodigo          := Space(6)
Private cLojaAte        := 'ZZ'
Private cVendDe         := '      '
Private cVendAte        := 'ZZZZZZ' 
Private cNome           := Space(15)
Private cMenNota        := Space(60)
Private cContrato		:= Space(12)
Private cItem       	:= Space(6)
Private dEmisDe         := CTOD("01/01/2000")
Private dEmisAte        := CTOD("31/12/2049")
Private dEntrgDe         := CTOD("01/01/2000")
Private dEntrgAte        := CTOD("31/12/2049")
Private oTela
Private oCombo1  		:= "3=Todos"
Private cCombo1			:= "3=Todos"
Private cTipProd		:= ''
Private oCombo2  		:= "3=Todos"
Private cCombo2			:= "3=Todos"
Private oCombo3  		:= "3=Todos"
Private cCombo3			:= "3=Todos"
Private oCombo4  		:= "3=Todos"
Private cCombo4			:= "3=Todos"
Private aAlter			:= {"JUST","DESC1"}
Private lPcCOr 			:= .F.
Private aGeral          := {}
Private nIdSeq          := 0
Private dDataDe			:= ddatabase
Private dDataAte		:= ddatabase
Private dDateret   		:= DTOC(dDatabase)
Private aColsGeral		:= {}
Private clDescIt		:= Space(30)
Private clUser			:= Space(30)

aAdd(aHeadRank,{" "					,"CHECK" 	    ,"@BMP"						    ,3							,TamSX3("C6_TES")[2]	 	,			,""			,TamSX3("C6_TES")[3]		    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{" "					,"LEG1" 	    ,"@BMP"						    ,3							,TamSX3("C6_TES")[2]	 	,			,""			,TamSX3("C6_TES")[3]		    ,""		,""				,""			,""			,			,'V'		,			,			,			})    
aAdd(aHeadRank,{"Pedido"	        ,"ZS6_CODPED"	,PesqPict("ZS6","ZS6_CODPED")	,TamSX3("ZS6_CODPED")[1]	,TamSX3("ZS6_CODPED")[2]    ,			,""			,TamSX3("ZS6_CODPED")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Destinatแrio"      ,"ZS6_CODD "    ,PesqPict("ZS6","ZS6_CODD ")	,TamSX3("ZS6_CODD ") [1]    ,TamSX3("ZS6_CODD ")[2]     ,   		,""			,TamSX3("ZS6_CODD ")[3]	        ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Nome"				,"ZS6_DESCDT "	,PesqPict("ZS6","ZS6_DESCDT ")	,TamSX3("ZS6_DESCDT ")[1]	,TamSX3("ZS6_DESCDT ")[2]	,			,""			,TamSX3("ZS6_DESCDT ")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Obs. Pedido"	    ,"ZS6_OBS    "	,PesqPict("ZS6","ZS6_OBS    ")	,TamSX3("ZS6_OBS    ")[1]	,TamSX3("ZS6_OBS    ")[2]	,			,""			,TamSX3("ZS6_OBS    ")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Usuแrio Inclusใo"  ,"ZS6_USERGI  "	,PesqPict("ZS6","ZS6_USERGI ")	,TamSX3("ZS6_USERGI ") [1] 	,TamSX3("ZS6_USERGI ")[2] 	,   		,""			,TamSX3("ZS6_USERGI ")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Data Inclusใo"     ,"ZS6_XDTLAN"	,PesqPict("ZS6","ZS6_XDTLAN")	,TamSX3("ZS6_XDTLAN") [1]   ,TamSX3("ZS6_XDTLAN")[2] 	,   		,""			,TamSX3("ZS6_XDTLAN")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank,{"Hora Inclusใo"    	,"ZS6_HORA  "   ,PesqPict("ZS6","ZS6_HORA  ")   ,TamSX3("ZS6_HORA  ") [1] 	,TamSX3("ZS6_HORA  ")[2]    ,   		,""			,TamSX3("ZS6_HORA  ")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})    

aAdd(aHeadRank3,{"Item 1"        	,"ZS6_CITEM1 "	,PesqPict("ZS6","ZS6_CITEM1 ")	,TamSX3("ZS6_CITEM1 ") [1]  ,TamSX3("ZS6_CITEM1 ")[2] 	,   		,""			,TamSX3("ZS6_CITEM1 ")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Descri็ใo "      	,"ZS6_DITEM1"	,PesqPict("ZS6","ZS6_DITEM1")	,TamSX3("ZS6_DITEM1") [1] 	,TamSX3("ZS6_DITEM1")[2] 	,   		,""			,TamSX3("ZS6_DITEM1")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Qtd.Item 1  "		,"ZS6_QITE1 "	,PesqPict("ZS6","ZS6_QITE1 ")	,TamSX3("ZS6_QITE1 ")[1]    ,TamSX3("ZS6_QITE1 ")[2]    ,			,""			,TamSX3("ZS6_QITE1 ")[3]		,""		,""				,""			,""			,			,'R'		,"U_PR01J6()"	,		,			})
aAdd(aHeadRank3,{"Item 2  "      	,"ZS6_CITEM2"	,PesqPict("ZS6","ZS6_CITEM2")	,TamSX3("ZS6_CITEM2") [1] 	,TamSX3("ZS6_CITEM2")[2] 	,   		,""			,TamSX3("ZS6_CITEM2")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Descri็ใo"	    ,"ZS6_DITEM2 "	,PesqPict("ZS6","ZS6_DESCDT ")	,TamSX3("ZS6_DESCDT ")[1]	,TamSX3("ZS6_DESCDT ")[2]	,			,""			,TamSX3("ZS6_DESCDT ")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Qtd. Item 2 "     ,"ZS6_QITE2 "	,PesqPict("ZS6","ZS6_CITEM2")	,TamSX3("ZS6_CITEM2") [1] 	,TamSX3("ZS6_CITEM2")[2] 	,   		,""			,TamSX3("ZS6_CITEM2")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Item 3 "      	,"ZS6_CITEM3"	,PesqPict("ZS6","ZS6_CITEM3")	,TamSX3("ZS6_CITEM3") [1]   ,TamSX3("ZS6_CITEM3")[2] 	,   		,""			,TamSX3("ZS6_CITEM3")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank3,{"Descri็ใo"      	,"ZS6_DITEM3"   ,PesqPict("ZS6","ZS6_DITEM3")   ,TamSX3("ZS6_DITEM3") [1] 	,TamSX3("ZS6_DITEM3")[2]    ,   		,""			,TamSX3("ZS6_DITEM3")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})    
aAdd(aHeadRank3,{"Qtd. Item 3 "     ,"ZS6_QITE3 "	,PesqPict("ZS6","ZS6_QITE3 ")	,TamSX3("ZS6_QITE3 ") [1] 	,TamSX3("ZS6_QITE3 ")[2] 	,   		,""			,TamSX3("ZS6_QITE3 ")[3]	    ,""		,""				,""			,""			,			,'V'		,			,			,			})

aAdd(aHeadRank4,{"DESCRIวรO"		,"C6_DESCRI"	,PesqPict("SC6","C6_DESCRI")	,35							,TamSX3("C6_DESCRI")[2]		,			,""			,TamSX3("C6_DESCRI")[3]			,""		,""				,""			,""			,			,'V'		,			,			,			})
aAdd(aHeadRank4,{"TOTAL"			,"C6_VALOR"		,PesqPict("SC6","C6_VALOR")		,TamSX3("C6_VALOR")[1]		,TamSX3("C6_VALOR")[2]		,			,""			,TamSX3("C6_VALOR")[3]			,""		,""				,""			,""			,			,'V'		,			,			,			})

DEFINE FONT oFont11    NAME "Arial"			SIZE 0, -11 BOLD
DEFINE FONT oFont13    NAME "COurier New"	SIZE 0, -11 BOLD
DEFINE FONT oFont16n   NAME "COurier New"	SIZE 0, -12 BOLD//
DEFINE FONT oFont11a   NAME "Arial"			SIZE 0, -11 BOLD

oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Painel de Controle - Correspond๊ncia"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
oArea:Init(oTela,.F.)

oArea:AddLine("L01",25,.T.)
oArea:AddLine("L02",40,.T.)
oArea:AddLine("L03",35,.T.)

oArea:AddCollumn("L01PARA"  , 58,.F.,"L01")
oArea:AddCollumn("L01TOTA"  , 30,.F.,"L01")
oArea:AddCollumn("L01BOTO"  , 12,.F.,"L01")

oArea:AddCollumn("L02DLG"   ,100,.F.,"L02")

//oArea:AddCollumn("L03DLG"   , 40,.F.,"L03")
oArea:AddCollumn("L03SEP"   , 100,.F.,"L03")

oArea:AddWindow("L01PARA" ,"L01PARA"	,"Parโmetros"						, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
oArea:AddWindow("L01TOTA" ,"L01TOTA"	,"Totais" 							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
oArea:AddWindow("L01BOTO" ,"L01BOTO"	,"Fun็๕es" 							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
oArea:AddWindow("L02DLG" ,"L02DLG"  	,"Informa็๕es dos Pedidos"							, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
			
oArea:AddWindow("L03SEP" ,"L03SEP"  	,"Informa็๕es dos Produtos"			, 100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)

oPainPara  := oArea:GetWinPanel("L01PARA"  	,"L01PARA" 	,"L01")
oPainRank4 := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA" 	,"L01")
oPainBoto  := oArea:GetWinPanel("L01BOTO"  	,"L01BOTO" 	,"L01")
oPainRank  := oArea:GetWinPanel("L02DLG"  	,"L02DLG"  	,"L02")

oPainRank3 := oArea:GetWinPanel("L03SEP"  	,"L03SEP"  	,"L03")

SetKey(VK_F5,{||FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )})
SetKey(VK_F9,{||fMarkAll()})
SetKey(VK_F10,{||fdMarkAll()})

aFill(aTamObj,0)
U_DefTamObj(@aTamObj)
aTamObj[3] := (oPainBoto:nClientWidth) 
aTamObj[4] := (oPainBoto:nClientHeight)

oScroll 		:= TScrollBox():New(oPainBoto,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT
	
oScroll2 		:= TScrollBox():New(oPainPara,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.T.,.T.)
oScroll2:Align 	:= CONTROL_ALIGN_ALLCLIENT

oScroll3 		:= TScrollBox():New(oPainRank4,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.T.,.T.)
oScroll3:Align 	:= CONTROL_ALIGN_ALLCLIENT

U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Atualizar - (F5)",oScroll,{||  FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotExcel := tButton():New(aTamObj[1],aTamObj[2],"Cadastro Destinatแrio",oScroll,{||  LJMsgRun('Exportando Dados...','Aguarde, Exportando Dados',{||fIncDest()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotExcel := tButton():New(aTamObj[1],aTamObj[2],"Cadastro Itens",oScroll,{||  LJMsgRun('Exportando Dados...','Aguarde, Exportando Dados',{||fIncItem()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotExcel := tButton():New(aTamObj[1],aTamObj[2],"Cadastro Pedido",oScroll,{||  LJMsgRun('Exportando Dados...','Aguarde, Exportando Dados',{||fIncPed()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotExcel := tButton():New(aTamObj[1],aTamObj[2],"Imprimir Etiqueta",oScroll,{||  LJMsgRun('Imprimindo Dados...','Aguarde, Imprimindo Dados',{||IMPCOR()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotExcel := tButton():New(aTamObj[1],aTamObj[2],"Gerar Excel",oScroll,{||  LJMsgRun('Exportando Dados...','Aguarde, Exportando Dados',{||geraexcel()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fecha",oScroll,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

@  07,   00 Say oSay1 Prompt 'Pedido:'		   		FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel
@  19,   00 Say oSay1 Prompt 'Cod.Dest.:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel	
@  31,   00 Say oSay1 Prompt 'Cod. Item:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel
@  43,   00 Say oSay1 Prompt 'Data De'				FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel
@  55,   00 Say oSay1 Prompt 'Data Ate'				FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel

@  05,  55 	MSGet oMV_PAR01	Var cPedido 			FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	         Of oScroll2
@  17,  55 	MSGet oMV_PAR02	Var cCodigo		    	FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.	         Of oScroll2
@  29,  55 	MSGet oMV_PAR03	Var cItem 				FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.          Of oScroll2
@  41,  55 	MSGet oMV_PAR04	Var dDataDe 			FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.          Of oScroll2
@  53,  55 	MSGet oMV_PAR05	Var dDataAte			FONT oFont11 COLOR CLR_GRAY Pixel SIZE  65, 05 When .T.          Of oScroll2

@  07,  130 Say oSay1 Prompt 'Nome.Dest.:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel
@  19,  130 Say oSay1 Prompt 'Desc. Item:'			FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel
@  31,  130 Say oSay1 Prompt 'Usuแrio:'				FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel

@  05, 	185 MSGet oMV_PAR06	Var cNome 				FONT oFont11 COLOR CLR_GRAY Pixel SIZE 120, 05 When .T.          Of oScroll2
@  17, 	185 MSGet oMV_PAR07	Var clDescIt			FONT oFont11 COLOR CLR_GRAY Pixel SIZE 120, 05 When .T.          Of oScroll2
@  29, 	185 MSGet oMV_PAR08	Var clUser				FONT oFont11 COLOR CLR_GRAY Pixel SIZE 120, 05 When .T.          Of oScroll2

@  07,  320 Say oSay1 Prompt 'Status?' 				FONT oFont11 COLOR CLR_GRAY Size  50, 08 Of oScroll2 Pixel

@  019, 320 Say  oSay Prompt '[F5] Atualiza'		FONT oFont11a COLOR CLR_LIGHTGRAY Size  50, 08 Of oScroll2 Pixel
@  031, 320 Say  oSay Prompt '[F9] Marcar Tudo'	    FONT oFont11a COLOR CLR_LIGHTGRAY Size  50, 08 Of oScroll2 Pixel
@  043, 320 Say  oSay Prompt '[F10] Desmarcar Tudo' FONT oFont11a COLOR CLR_LIGHTGRAY Size  65, 08 Of oScroll2 Pixel

oCombo2 :=TComboBox():New( 05,350,{|u|if(PCount()>0, cCombo2:=u, cCombo2)},{"1=Impressใo Pendente",;
       "2=Impressใo Realizada","3=Todos"}, 065, 05, oScroll2, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

cCombo2 := '3'

oTela:Activate(,,,.T.,/*valid*/,,{||FWMsgRun(, {|oSay| GeraRank(1) }, "Aguarde...", "Processando" )})
									
RestArea(aArea)
	
return

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

Local cQuery 	:= ''

Private Inclui	:= .F.

aCols  := {}
aCols1 := {}
aCols2 := {}
aCols3 := {}

aColsGeral := {}
nTotQtd     := 0
nCont       := 0
nTotatPed   := 0

aColsTotal := {}

cQuery := " SELECT ZS6_CODPED,ZS6_STSENV,ZS6_CODD,ZS6_DESCDT,ZS6_CITEM1,ZS6_DITEM1,ZS6_QITE1,ZS6_CITEM2,ZS6_DITEM2,ZS6_QITE2  " + CRLF
cQuery += ",ZS6_CITEM3,ZS6_DITEM3,ZS6_QITE3,ZS6_OBS,ZS6_USERGI,ZS6_XDTLAN,ZS6_HORA,ZS6_XUSRLI  " + CRLF

cQuery += " FROM 			                                                                    " + CRLF
cQuery += RetSQLName("ZS6") + " ZS6			                                                    " + CRLF

cQuery += " WHERE ZS6.D_E_L_E_T_= ' ' 

cQuery += " AND  ZS6_XDTLAN <> ' ' 

If .not. Empty( Alltrim( cPedido ) )
    cQuery += " AND ZS6_CODPED = '" + cPedido + "'							" + CRLF
Endif

If .not. Empty( Alltrim( cCodigo ) )
    cQuery += " AND ZS6_CODD = '" + cCodigo + "'							" + CRLF
Endif

cQuery += " AND ZS6_XDTLAN BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "'		" + CRLF

If .not. Empty( Alltrim( cItem ) )
    cQuery += " AND (ZS6_CITEM1 = '" + cItem + "' OR ZS6_CITEM2 = '" + cItem + "' OR ZS6_CITEM4 = '" + cItem + "')	" + CRLF
Endif

If .not. empty(alltrim(cNome))
    cQuery += " AND ZS6_DESCDT LIKE '%" + alltrim(cNome) + "%'                                 " + CRLF
Endif

If .not. empty(alltrim(clDescIt))
    cQuery += " AND (ZS6_DITEM1 LIKE '%" + alltrim(clDescIt) + "%' OR ZS6_DITEM2 LIKE '%" + alltrim(clDescIt) + "%'  OR ZS6_DITEM3 LIKE '%" + alltrim(clDescIt) + "%')  " + CRLF
Endif

If .not. empty(alltrim(clUser))
    cQuery += " AND ZS6_XUSRLI LIKE '%" + alltrim(clUser) + "%'  " + CRLF
Endif

If cCombo2 <> '3'
    cQuery += " AND ZS6_STSENV = '" + cCombo2 + "'                 " + CRLF
Endif

TCQUERY cQuery NEW ALIAS "TMP"

DbSelectArea("TMP")
TMP->(DbGotop())

AADD(aColsTotal,{'IMPRESSรO PENDENTE',0,.F.})
AADD(aColsTotal,{'IMPRESSรO REALIZADA'	            ,0,.F.})

While TMP->(!EOF())

    If TMP->ZS6_STSENV ==  '1'       
        cLeg_1 := LoadBitmap( GetResources(), "BR_VERDE" )    
        aColsTotal[1][2] ++
    ELseif TMP->ZS6_STSENV ==  '2'
        cLeg_1 := LoadBitmap( GetResources(), "BR_VERMELHO" )
        aColsTotal[2][2] ++
    ELSE
        cLeg_1 := LoadBitmap( GetResources(), "BR_MARROM" )
    ENDIF
        
    AADD(aColsGeral,{oBmpNO,cLeg_1,;//cLeg_1,;
    TMP->ZS6_CODPED,;
    TMP->ZS6_CODD,;
    TMP->ZS6_DESCDT,;
	' ',;
    TMP->ZS6_XUSRLI,;
    DTOC(STOD(TMP->ZS6_XDTLAN)),;
    TMP->ZS6_HORA,;
    TMP->ZS6_CITEM1,;
    TMP->ZS6_DITEM1,;
    TMP->ZS6_QITE1,;                   
    TMP->ZS6_CITEM2,;
    TMP->ZS6_DITEM2,;
    TMP->ZS6_QITE2,;
    TMP->ZS6_CITEM3,;
    TMP->ZS6_DITEM3,;
    TMP->ZS6_QITE3,;
    .F.} )

    AADD(aCols1,{oBmpNO,cLeg_1,;//cLeg_1,;
    			TMP->ZS6_CODPED,;
    			TMP->ZS6_CODD,;
    			TMP->ZS6_DESCDT,;
				' ',;
    			TMP->ZS6_XUSRLI,;
    			DTOC(STOD(TMP->ZS6_XDTLAN)),;
    			TMP->ZS6_HORA,.F.})

 TMP->(DbSkip())

EndDo

nTotQtd     := TRANSFORM(nTotQtd, 	"@E 999,999,999.99")
nCont       := TRANSFORM(nCont, 	"@E 999,999,999.99")
nTotatPed   := TRANSFORM(nTotatPed, "@E 999,999,999.99")

TMP->(DbCloseArea()) 

If nOpc <> 2

	oGetRank 	:= MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue",,aAlter,0,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,{|| IM69ATU2()}/*uChange*/)

    oGetRank3 	:= MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank3:nClientWidth/2,oPainRank3:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank3,@aHeadRank3,/*@aColsRank*/,/*uChange*/)
    oGetRank4 	:= MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank4:nClientWidth/2,oPainRank4:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank4,@aHeadRank4,/*@aColsRank*/,/*uChange*/)

	oGetRank:oBrowse:bLDblClick := {|| Iif(oGetRank:oBrowse:nColPos == 1 ,(DuploC(), oGetRank:oBrowse:Refresh()),oGetRank:EditCell()) }
	oGetRank:oBrowse:brClicked := {|| If( Empty(oGetRank:aCols[1,1]), Nil, LJMsgRun("Classificando...","Aguarde...",{|| ClasGrid(@aCols,oGetRank:oBrowse:ColPos,@oGetRank,@oTela) } )) }

	oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetRank3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetRank4:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Endif

oGetRank:SetArray(aCols1)
oGetRank4:SetArray(aColsTotal)

oGetRank:Refresh()
oGetRank4:Refresh()
oGetRank:oBrowse:SetFocus(1)

oTela:Refresh()

If Len(aCols1) > 0
	IM69ATU2()
Endif

Return

Static Function IM69ATU2()

Local clPedido      := oGetRank:aCols[oGetRank:nAt][3]
Local nX			:= 0

aCols2 := {}

For nX := 1 to len(aColsGeral)

	If aColsGeral[nX][3] == clPedido
		AADD(aCols2,{aColsGeral[nX][10],aColsGeral[nX][11],aColsGeral[nX][12],aColsGeral[nX][13],aColsGeral[nX][14],aColsGeral[nX][15],aColsGeral[nX][16],aColsGeral[nX][17],aColsGeral[nX][18],.F.})
	Endif

Next nX

oGetRank3:SetArray(aCols2)
oGetRank3:Refresh()

oTela:Refresh()

Return


Static Function ClasGrid(aCols,nCol,oGetDados,oTela)

Local aArea	 := GetArea()

If nCol > 0 .and. !Empty(aCols) .and. len(aCols) > 1

	If nCol == 6 .Or. nCol == 10

		if aCols[1,nCol] > aCols[len(aCols),nCol] //ordem crescente
			aCols := aSort(aCols,,,{|x,y| CTOD(x[nCol]) < CTOD(y[nCol]) })
		else
			aCols := aSort(aCols,,,{|x,y| CTOD(x[nCol]) > CTOD(y[nCol]) })
		endif		

	else

		if aCols[1,nCol] > aCols[len(aCols),nCol] 
			aCols := aSort(aCols,,,{|x,y| x[nCol] < y[nCol] })
		else
			aCols := aSort(aCols,,,{|x,y| x[nCol] > y[nCol] })
		endif

	Endif
	
	oGetDados:SetArray(aCols)
	oGetDados:Refresh()
	oTela:Refresh()

	RestArea(aArea)

Endif

Return

Static Function IMPCOR()

    Local lAdjustToLegacy := .F.
    Local lDisableSetup   := .T.
    Local cLocal          := "\spool"
    Local oPrinter
    Local cData           := DTOS(Date()) + "_" + StrTran(Time(),":",)

    Local nLinha 
    Local nLinhaE
    Local nLinhaD
    Local nAux  := 0
    Local nAuxD := 0
	Local lPulapg := .F.
	Local nLinhaC := 1
	
    oPrinter := FWMSPrinter():New("rel_etiquetas_"+cData, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )

	oPrinter:StartPage()

    oPrinter:Say( 40, 30, "Etiquetas geradas para folhas PIMACO 6282:")    
    
        For nLinha := 1 to Len(oGetRank:aCols)

			If oGetRank:aCols[nLinha][1] == oBmpOk

				dbSelectArea("ZS9")
				dbSetOrder(1)
				ZS9->( msSeek( fwxFilial("ZS9") + oGetRank:aCols[nLinha][4] ) )

				if nLinhaC <= 7 
					for nLinhaE := 90 to 700
						nLinhaE += nAux 

						if nAux <> 0
							nLinhaE -= 90
						EndIf

						if nLinhaE <= 700
							//Direita da folha PIMACO
							oPrinter:Say( nLinhaE, 50, allTrim(ZS9->ZS9_NOME))
								nLinhaE += 15
							oPrinter:Say( nLinhaE, 50, allTrim(ZS9->ZS9_END) +", "+alltrim(ZS9->ZS9_NUM))
								nLinhaE += 10
							If .not. empty( alltrim(ZS9->ZS9_COMP) )
								oPrinter:Say( nLinhaE, 50, Substr( allTrim(ZS9->ZS9_COMP) + ', ' + allTrim(ZS9->ZS9_BAIRRO),1,37))
							Else
								oPrinter:Say( nLinhaE, 50, allTrim(ZS9->ZS9_BAIRRO))
							Endif
								nLinhaE += 10
							oPrinter:Say( nLinhaE, 50, allTrim(ZS9->ZS9_DMUN))
								nLinhaE += 10
							oPrinter:Say( nLinhaE, 50, allTrim(TRANSFORM(ZS9->ZS9_CEP, "@R 99999-999")))
								//nLinhaE += 10
							oPrinter:Say( nLinhaE, 150, allTrim(ZS9->ZS9_EST))
								nLinhaE += 10
							oPrinter:Say( nLinhaE,150, "Ped.: " + allTrim(oGetRank:aCols[nLinha][3]))
						//  oPrinter:Say( nLinhaE,50, "Qtd.I: " + allTrim(aCols[nLinha][9]))
								nLinhaE += 40

								nAux := nLinhaE                            
							exit
						
						EndIf                
					next nLinhaE += 15

				else 

					for nLinhaD := 90 to 700
						nLinhaD += nAuxD

						if nAuxD <> 0
							nLinhaD -= 90
						EndIf
						
						if nLinhaD <= 700
							//Direita da folha PIMACO
							oPrinter:Say( nLinhaD, 350, allTrim(ZS9->ZS9_NOME))
								nLinhaD += 15
							oPrinter:Say( nLinhaD, 350, allTrim(ZS9->ZS9_END) +", "+alltrim(ZS9->ZS9_NUM) )
								nLinhaD += 10
							If .not. empty( alltrim(ZS9->ZS9_COMP) )
								oPrinter:Say( nLinhaD, 350, Substr( allTrim(ZS9->ZS9_COMP) + ', ' + allTrim(ZS9->ZS9_BAIRRO),1,37))
							Else
								oPrinter:Say( nLinhaD, 350, allTrim(ZS9->ZS9_BAIRRO))
							Endif
								nLinhaD += 10
							oPrinter:Say( nLinhaD, 350, allTrim(ZS9->ZS9_DMUN))
								nLinhaD += 10
							oPrinter:Say( nLinhaD, 350, allTrim(TRANSFORM(ZS9->ZS9_CEP, "@R 99999-999")))
								//nLinhaE += 10
							oPrinter:Say( nLinhaD, 450, allTrim(ZS9->ZS9_EST))
								nLinhaD += 10
							oPrinter:Say( nLinhaD,450, "Ped.: " + allTrim(oGetRank:aCols[nLinha][3]))
							//oPrinter:Say( nLinhaD,350, "Qtd.I: " + allTrim(aCols[nLinha][9]))
							nLinhaD += 40

							nAuxD := nLinhaD                            
							exit
						
						EndIf                
					
					next nLinhaD += 15                               
				
				EndIf

				// Update nos cadastros de destinatรกrios do browse
				dbSelectArea("ZS6")
				dbSetOrder(1)
			
				If ZS6->(MsSeek(XFILIAL("ZS6") + oGetRank:aCols[nLinha][3] + oGetRank:aCols[nLinha][4] ))
					
					If RecLock("ZS6",.F.)
						ZS6->ZS6_STSENV := "2"
						MsUnlock()
					Endif

				Endif

				If nLinhaC == 14
					lPulapg := .T.
					nLinhaE := 0
					nLinhaD	:= 0
					nLinhaC	:= 1
					nAuxD	:= 0
					nAux	:= 0
					oPrinter:EndPage()
					oPrinter:StartPage()
					oPrinter:Say( 40, 30, "Etiquetas geradas para folhas PIMACO 6282:")  
					lPulapg := .F.
				Else
					nLinhaC++
				Endif

			Endif

        next nLinha 

    oPrinter:Setup()

    If oPrinter:nModalResult == PD_OK
        oPrinter:Preview()   
        FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )
    Else 
        Return
    EndIf

Return

Static Function DuploC()

Local aArea		:= GetArea()

If oGetRank:aCols[oGetRank:nAt][1] == oBmpNo

	oGetRank:aCols[oGetRank:nAt][1] := oBmpOK

else

    oGetRank:aCols[oGetRank:nAt][1] := oBmpNo

Endif

oGetRank:Refresh()

RestArea(aArea)

Return

Static Function fIncDest()

Local aArea		:= GetArea()

u_BRWCOR()

FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )

RestArea(aArea)

Return

Static Function fIncItem()

Local aArea		:= GetArea()

u_BRWCORI()

FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )

RestArea(aArea)

Return

Static Function fIncPed()

Local aArea		:= GetArea()

u_BRWCORP()

FWMsgRun(, {|oSay| GeraRank(2) }, "Aguarde...", "Processando" )

RestArea(aArea)

Return

Static Function geraexcel()

alert("fun็ใo em desenvolvimento")

Return

Static Function fMarkAll()

Local nY 	:= 0
Local cMark	:= oBmpOK

If Len(oGetRank:aCols) > 0

	For nY := 1 to Len(oGetRank:aCols)
		oGetRank:aCols[nY][1] := cMark //Marco o markbrowse ou retiro a marca็ใo
	Next

	oGetRank:Refresh()

Endif

Return

Static Function fdMarkAll()

Local nY 	:= 0
Local cMark	:= oBmpNo

If Len(oGetRank:aCols)>0

	For nY := 1 to Len(oGetRank:aCols)
		oGetRank:aCols[nY][1] := cMark
	Next

	oGetRank:Refresh()

Endif

Return

User Function GetZs9Num() //Gera novo titulo de acordo com os par๏ฟฝmetros

Local clCod 	:= GETMV("MV_SEQZS9")

clCod := Val(clCod)	+ 1
clCod :=  STRZERO(clCod, 6, 0)

PUTMV("MV_SEQZS9",clCod)

/*
Local cAlias	:= GetNextAlias()
Local cQuery	:= ""
Local clCod 	:= ''

cQuery	:= "SELECT MAX(ZS9_COD) AS MAXCODIGO FROM ZS9010" 		+ CRLF
cQuery	+= "WHERE D_E_L_E_T_ = ' ' " 		+ CRLF
cQuery	+= "AND ZS9_COD LIKE '0%' " 		+ CRLF

TCQUERY cQuery NEW ALIAS (cAlias)

(cAlias)->(dbGoTop())

If !Empty(Alltrim((cAlias)->MAXCODIGO))

	clCod := Val(cTitulo)	+ 1
	clCod :=  STRZERO(clCod, 6, 0)
	
	PUTMV("MV_SEQZS9",(cAlias)->MAXCODIGO)
	 

Endif
*/
Return(clCod)
