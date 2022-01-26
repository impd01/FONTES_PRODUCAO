#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IM06A02    ºAutor  ³Vinicius Henrique       º Data ³18/09/2017    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IM06A02 - Aglutinação dos títulos dos Aluguéis			        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IM06A02()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IM06A02"

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
	Private aTamObj			:= Array(4)

	Private aCoord			:= FWGetDialogSize(oMainWnd)
	Private cVldDel			:= "AllwaysFalse()"
	Private cVldDelT		:= "AllwaysFalse()"
	Private cVldLOk			:= "AllwaysTrue()"
	Private cVldTOk			:= "AllwaysTrue()"
	Private cFieldOk		:= "AllwaysTrue()"
	Private nStyle			:= GD_UPDATE

	Private oOk				:= LoadBitmap( GetResources(), "LBOK"  )
	Private oNo				:= LoadBitmap( GetResources(), "LBNO"  )
	Private nMark_Est 		:= 0, nMark_End := 0,  nMark_XXX := 0,  nMark_Del := 0
	Private oCheckBOX
	Private lCheckBOX 		:= .F.
	Private cTitSE2 		:= ""
	Private lMarc			:= .T.	//MS20180208.n

	//	Variáveis de outra Função

	Private cObserv 	:= Space(150)
	Private lVazio 		:= .F.
	Private cCond		:= Space(3)
	Private aHeadDados 	:= {}
	Private aHeadTitu	:= {}
	Private aColsDados 	:= aCols
	Private lParc		:= .F.	
	Private oTela
	Private aPacelas	:= {}
	Private aMultJur	:= {}
	Private oFornec
	Private oLoja
	Private oCond
	Private oParc
	Private oDescr		
	Private cFornec		:= Space(6)
	Private cLoja		:= Space(3)
	Private cDescr		:= Space(30)
	Private cCond		:= Space(3)
	Private cParce		:= Space(2)	
	Private oValTotS		
	Private NValTotS	:= 0
	Private oValTot		
	Private NValTot		:= 0
	//Private oDifere		
	Private nDifere		:= 0
	Private nIRRF		:= 0	
	Private nTotalT		:= 0	
	Private cAcesso 	:= SuperGetMV("IM_06A02",.F.,"000000")
	Private cUsuario	:= Space(60)
	Private oUsuario
	Private lIrrf		:= .F.
	Private cNaturez 	:= '5005034'
	Private oBotPesq
	
	AADD(aCols, {.F.,"","","","","","","","","",CToD("  /  /  "),CToD("  /  /  "),0,"","","",""})
	AADD(aCols1,{.F.,"","","","","","","","","",CToD("  /  /  "),CToD("  /  /  "),0,"","","",""})

	sValidPerg(cPerg)

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Aglutinação dos Títulos dos Aluguéis"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",35,.T.)
	oArea:AddLine("L02",65,.T.)

	oArea:AddCollumn("L01PARA"  , 65,.F.,"L01")
	oArea:AddCollumn("L01TOTA"  , 25,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 10,.F.,"L01")
	oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

	oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Parâmetros"							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01TOTA" ,"L01TOTA"  ,"Totais"								, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Funções" 							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Títulos"							, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)		

	oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
	oPainTota  := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA"  ,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
	oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,aCposRank,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,/*uChange*/)
	oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)
																			
	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Gera Dados",oPainBoto,{||  FWMsgRun(, {|oSay| IM06A02G() }, "Rotina de Aglutinação", "Processando Registros..." )},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotPesq := tButton():New(aTamObj[1],aTamObj[2],"Pesquisa",oPainBoto,{|| MsgAlert("Função Indisponível") },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotPesq:lActive := .T. })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotDrill := tButton():New(aTamObj[1],aTamObj[2],"Aglutinar",oPainBoto,{|| U_IM06A02RN(aCols) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotDrill:lActive := .T. })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotImpr := tButton():New(aTamObj[1],aTamObj[2],"Imprimir",oPainBoto,{|| MsgAlert("Função Indisponível")},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotImpr:lActive := .T.})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	aCoordTota		:= FWGetDialogSize(oPainTota)
	oScroll 		:= TScrollBox():New(oPainTota,aCoordTota[1], aCoordTota[2], aCoordTota[3], aCoordTota[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT

	@  07,   00 Say oSay1 Prompt 'Contrato De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,   00 Say oSay1 Prompt 'Contrato Até:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,   00 Say oSay1 Prompt 'Vencimento De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,   00 Say oSay1 Prompt 'Vencimento Até:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  55,   00 Say oSay1 Prompt 'Titulo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  67,   00 Say oSay1 Prompt 'Titulo Até:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  57,  130 Say oSay1 Prompt 'Usuário:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  07,  130 Say oSay1 Prompt 'Fornecedor De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,  130 Say oSay1 Prompt 'Loja De:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,  130 Say oSay1 Prompt 'Fornecedor Até:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,  130 Say oSay1 Prompt 'Loja Até:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CN9" Of oPainPara
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CN9" Of oPainPara
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  53,  55 	MSGet oMV_PAR09	Var MV_PAR09 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SE2AGL" Of oPainPara	
	@  65,  55 	MSGet oMV_PAR10	Var MV_PAR10 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SE2AGL" Of oPainPara

	@  55,  185	MSGet oUsuario	Var cUsuario 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  170, 05 When .T.	Of oPainPara

	@  07,  185 MSGet oMV_PAR05	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  19,  185 MSGet oMV_PAR06	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  31,  185 MSGet oMV_PAR07	Var MV_PAR07 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	
	@  43,  185 MSGet oMV_PAR08	Var MV_PAR08 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CNC" Of oPainPara	

	@  07,  05 Say  oSay Prompt 'Total Titulos:'		FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  19,  05 Say  oSay Prompt 'Val. Titulos R$:'		FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  31,  05 Say  oSay Prompt 'Titulos Selecionados:'	FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll
	@  43,  05 Say  oSay Prompt 'Val. Tit. Selec. R$:'	FONT oFont11 COLOR CLR_BLUE pixel Size  60, 08 Of oScroll

	@  07,  70 MSGet oVlLiq		Var nTitulos	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  19,  70 MSGet oVlBru		Var nVlTitu		 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  31,  70 MSGet oTottit	Var nTitulosSel	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll
	@  43,  70 MSGet oVlTottit	Var nVlTituSEL		 	FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "@E@R 999,999,999.99" Of oScroll

	@  08, 280 CHECKBOX oCheckBOX VAR lCheckBOX PROMPT "Marcar/Desmarcar Todos" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainPara    

	@ .3, .1 LISTBOX oEstoque		FIELDS HEADER "","ID","Prefixo","No. Título","Parcela","Tipo","Natureza","Fornecedor","Loja","Nome","Emissao","Vencimento","Valor","Contrato","Endereço","Município","Bairro","Estado" FIELDSIZES 15,10,30,35,30,30,30,35,30,120,35,35,35,50,140,60,60 SIZE oPainRank:nClientWidth/2, oPainRank:nClientHeight/2.2 OF oPainRank

	ShowEst()

	oEstoque:bLDblClick := {|| aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1], aCols:DrawSelect() }

	oCheckBOX:bchange   := {||Seltodos(oGetRank:aCols) }	

	oTela:Activate(,,,.T.,/*valid*/,,{||FWMsgRun(, {|oSay| IM06A02G() }, "Rotina de Aglutinação", "Processando Registros..." )})
//	FWMsgRun(, {|oSay| IM06A02G() }, "Rotina de Aglutinação", "Processando Registros..." )
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IM06A02G   ºAutor  ³       º Data ³    							º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³														            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Grupo Dovac	                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IM06A02G()

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
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
	_cQuery	+= "FROM " + RetSQLName("SE2") + " SE2 (NOLOCK)											" + CRLF
	_cQuery	+= "LEFT JOIN " + RetSQLName("CN9") + " CN9		(NOLOCK)								" + CRLF
	_cQuery	+= "ON CN9.CN9_FILIAL = SE2.E2_FILIAL													" + CRLF
	_cQuery	+= "AND CN9.CN9_NUMERO = SE2.E2_XCONTRA													" + CRLF
	_cQuery	+= "AND CN9.D_E_L_E_T_ = ' '															" + CRLF
	_cQuery	+= "WHERE  SE2.D_E_L_E_T_ = ' '															" + CRLF
	_cQuery	+= "AND SE2.E2_VENCREA BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'	" + CRLF
	_cQuery	+= "AND SE2.E2_SALDO > 0																" + CRLF
	_cQuery	+= "AND SE2.E2_TIPO <> 'PR'																" + CRLF	
	_cQuery	+= "AND SE2.E2_TIPO <> 'PA'																" + CRLF	
	_cQuery	+= "AND SE2.E2_TIPO <> 'TX'																" + CRLF
	_cQuery	+= "AND SE2.E2_NUM BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "'	" + CRLF
	_cQuery	+= "AND SE2.E2_FORNECE BETWEEN '" + MV_PAR05 + "'	AND '" + MV_PAR07 + "'				" + CRLF	
	_cQuery	+= "AND SE2.E2_LOJA BETWEEN    '" + MV_PAR06 + "'	AND '" + MV_PAR08 + "'				" + CRLF
	If !Empty(Alltrim(MV_PAR01)) .And. !("ZZ" $ MV_PAR02)
		cContra1 := STRZERO(Val(MV_PAR01), 15, 0)     
		cContra2 := STRZERO(Val(MV_PAR02), 15, 0)	
		_cQuery	+= "AND SE2.E2_XCONTRA BETWEEN '" + cContra1 + "'	AND '" + cContra2 + "'					" + CRLF
	Else
		_cQuery	+= "AND SE2.E2_XCONTRA BETWEEN '" + MV_PAR01 + "'	AND '" + MV_PAR02 + "'					" + CRLF
	Endif	
	_cQuery	+= "AND SE2.E2_PREFIXO <> 'AGL'																" + CRLF	
	If Alltrim(cUsuario) <> ""
	_cQuery	+= "AND SE2.E2_XUSERLI LIKE '%"+Alltrim(cUsuario)+"%'								" + CRLF
	Endif
	_cQuery	+= "GROUP BY E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,							" + CRLF						
	_cQuery	+= "E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,									" + CRLF										
	_cQuery	+= "E2_VALOR,E2_XCC,E2_XCCDESC,E2_XCONTRA,CN9_END,CN9_MUN,								" + CRLF															
	_cQuery	+= "CN9_BAIRRO,CN9_ESTADO																" + CRLF

	MEMOWRITE("IM06A02.SQL",_cQuery)

	TCQUERY _cQuery NEW ALIAS (cAlias)

	(cAlias)->(DbGoTop())

	Do While !(cAlias)->(Eof()) 

		nCont++

		nVlTitu		+= (cAlias)->E2_VALOR

		AADD(aCols,{.F.,; 
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

Return()

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
//| Rotina | MarcaEst 	| Autor | Vinicius Henrique	 |Data| 18.09.2017 |
//+--------------------------------------------------------------------+
//| Descr. | Função para carregar o aTransf.						    |
//+--------------------------------------------------------------------+
//| Uso    | SIGAEST - Local									 	   |
//+--------------------------------------------------------------------+
Static Function MarcaEst(nOpc)

	Local _nx
	Private nLinha

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
		//MS20180208.bn
		nTitulosSel := 0
		nVlTituSEL	:= 0

		nMark_End := 0
		nMark_XXX := 0
		nMark_Est := 0

		For _nX := 1 to Len(aCols)

			If lMarc

				AchMarca()

				aCols[_nX][1] := lMarc
				oEstoque:DrawSelect()

				nMark_Est++
				aCols[_nX][2]   := cValToChar(nMark_Est)
				nTitulosSel ++
				nVlTituSEL	+=	aCols[_nX][13]

			Else

				oEstoque:DrawSelect()

				aCols[_nX][2]	:= " "
				aCols[_nX][1]	:= lMarc

				oEstoque:Refresh()		
				oTottit:Refresh()
				oVlTottit:Refresh()

			EndIF

		Next _nX

		lMarc := Iif(lMarc,.F.,.T.)
		//MS20180208.en

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

	Local ncol := oEstoque:ColPos

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

//Static Function U_IM06A02RN(aCols3)
User Function IM06A02RN(aCols3)

	Local aArea			:= GetArea()
	Local oArea			:= FWLayer():New()

	Local cTitulo 		:= "Aglutinação dos Títulos"

	Local cDelOk		:= "AllwaysFalse()"
	Local cSuperDel		:= "AllwaysFalse()"
	Local cLinhaOk		:= "AllwaysTrue()"
	Local cTudoOk		:= "AllwaysTrue()"
	Local cFieldOk		:= "AllwaysTrue()"
	Local cNature		:= GetMV("IM_NATAGLU") //Natureza do Titulo
	Local cPrefix		:= GetMV("IM_PREAGLU") //Prefixo do Titulo
	Local cTipo			:= GetMV("IM_TIPAGLU") //Tipo do Titulo
	Local aAlter		:= {"E2_VENCREA","E2_VALOR"}
	Local aAlter2		:= {"E2_MULTA","E2_JUROS","E2_IRRF"}

	Local aCalcIRPF		:= {}
	Local lCheckBx2		:= .F.
	Local cNatur		:= ""
	Local nx
	Private aIrrf		:= U_IMIRRF()


	DbSelectArea("SE4")
	DbSetOrder(1)   


	NValTotS := nVlTituSel


	nStyle := GD_UPDATE	
	aPacelas := {}
	aMultJur := {}

	aHeadDados := {}
	AADD(aHeadDados,{"No. Título"		,"E2_NUM"		,PesqPict("SE2","E2_NUM")		,TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]		,			,""			,TamSX3("E2_NUM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeadDados,{"Parcela"			,"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA")	,TamSX3("E2_PARCELA")[1]	,TamSX3("E2_PARCELA")[2]	,			,""			,TamSX3("E2_PARCELA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeadDados,{"Fornecedor"		,"E2_FORNECE"	,PesqPict("SE2","E2_FORNECE")	,TamSX3("E2_FORNECE")[1]	,TamSX3("E2_FORNECE")[2]	,			,""			,TamSX3("E2_FORNECE")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadDados,{"Loja"				,"E2_LOJA"		,PesqPict("SE2","E2_LOJA")		,TamSX3("E2_LOJA")[1]		,TamSX3("E2_LOJA")[2]		,			,""			,TamSX3("E2_LOJA")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadDados,{"Nome"				,"E2_NOMFOR"	,PesqPict("SE2","E2_NOMFOR")	,TamSX3("E2_NOMFOR")[1]		,TamSX3("E2_NOMFOR")[2]		,			,""			,TamSX3("E2_NOMFOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadDados,{"Vencimento"		,"E2_VENCREA"	,PesqPict("SE2","E2_VENCREA")	,TamSX3("E2_VENCREA")[1]	,TamSX3("E2_VENCREA")[2]	,			,""			,TamSX3("E2_VENCREA")[3]	,""		,""				,""			,""			,			,'R'		,			,			,			})
	AADD(aHeadDados,{"Valor"			,"E2_VALOR"		,PesqPict("SE2","E2_VALOR")		,TamSX3("E2_VALOR")[1]		,TamSX3("E2_VALOR")[2]	 	,			,""			,TamSX3("E2_VALOR")[3]		,""		,""				,""			,""			,			,'R'		,"U_DV06GAT(1)"	,		,			})

	aHeadTitu := {}
	AADD(aHeadTitu,{"No. Título"		,"E2_NUM"		,PesqPict("SE2","E2_NUM")		,TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]		,			,""			,TamSX3("E2_NUM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeadTitu,{"Parcela"			,"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA")	,TamSX3("E2_PARCELA")[1]	,TamSX3("E2_PARCELA")[2]	,			,""			,TamSX3("E2_PARCELA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeadTitu,{"Fornecedor"		,"E2_FORNECE"	,PesqPict("SE2","E2_FORNECE")	,TamSX3("E2_FORNECE")[1]	,TamSX3("E2_FORNECE")[2]	,			,""			,TamSX3("E2_FORNECE")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadTitu,{"Loja"				,"E2_LOJA"		,PesqPict("SE2","E2_LOJA")		,TamSX3("E2_LOJA")[1]		,TamSX3("E2_LOJA")[2]		,			,""			,TamSX3("E2_LOJA")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadTitu,{"Nome"				,"E2_NOMFOR"	,PesqPict("SE2","E2_NOMFOR")	,TamSX3("E2_NOMFOR")[1]		,TamSX3("E2_NOMFOR")[2]		,			,""			,TamSX3("E2_NOMFOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeadTitu,{"Contrato"			,"E2_XCONTRA"	,PesqPict("SE2","E2_XCONTRA")	,TamSX3("E2_XCONTRA")[1]	,TamSX3("E2_XCONTRA")[2]	,			,""			,TamSX3("E2_XCONTRA")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})		
	AADD(aHeadTitu,{"Valor"				,"E2_VALOR"		,PesqPict("SE2","E2_VALOR")		,TamSX3("E2_VALOR")[1]		,TamSX3("E2_VALOR")[2]	 	,			,""			,TamSX3("E2_VALOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
//	If __cUserID $ cAcesso
		AADD(aHeadTitu,{"IRRF"				,"E2_IRRF"		,PesqPict("SE2","E2_IRRF")		,TamSX3("E2_IRRF")[1]		,TamSX3("E2_IRRF")[2]	 	,			,""			,TamSX3("E2_IRRF")[3]		,""		,""				,""			,""			,			,'R'		,"U_DV06GAT(4)",		,			})
//	Else
//		AADD(aHeadTitu,{"IRRF"				,"E2_IRRF"		,PesqPict("SE2","E2_IRRF")		,TamSX3("E2_IRRF")[1]		,TamSX3("E2_IRRF")[2]	 	,			,""			,TamSX3("E2_IRRF")[3]		,""		,""				,""			,""			,			,'V'		,"U_DV06GAT(4)",		,			})
//	Endif
	AADD(aHeadTitu,{"Multa"				,"E2_MULTA"		,PesqPict("SE2","E2_MULTA")		,TamSX3("E2_MULTA")[1]		,TamSX3("E2_MULTA")[2]		,			,""			,TamSX3("E2_MULTA")[3]		,""		,""				,""			,""			,			,'R'		,"U_DV06GAT(2)",		,			})
	AADD(aHeadTitu,{"Juros"				,"E2_JUROS"		,PesqPict("SE2","E2_JUROS")		,TamSX3("E2_JUROS")[1]		,TamSX3("E2_JUROS")[2]	 	,			,""			,TamSX3("E2_JUROS")[3]		,""		,""				,""			,""			,			,'R'		,"U_DV06GAT(3)",		,			})
	AADD(aHeadTitu,{"Total"				,"E2_JUROS"		,PesqPict("SE2","E2_JUROS")		,TamSX3("E2_JUROS")[1]		,TamSX3("E2_JUROS")[2]	 	,			,""			,TamSX3("E2_JUROS")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})

	oDlg := tDialog():New(100,100,900,1400,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oDlg,.F.)

	oArea:AddLine("L01",25,.T.)
	oArea:AddLine("L02",25,.T.)
	oArea:AddLine("L03",50,.T.)

	oArea:AddCollumn("L01ACRE", 100,.F.,"L01")
	oArea:AddCollumn("L02COND",  60,.F.,"L02")
	oArea:AddCollumn("L02VALO",  25,.F.,"L02")
	oArea:AddCollumn("L02OPCO",  15,.F.,"L02")
	oArea:AddCollumn("L03TELA", 100,.F.,"L03")

	oArea:AddWindow("L01ACRE","L01ACRE"  ,"Juros e Multa"							,100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L02COND","L02COND"  ,"Condição de Pagamento"					,100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L02VALO","L02VALO"  ,"Valor dos Titulos"						,100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L02OPCO","L02OPCO"  ,"Funções"									,100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)
	oArea:AddWindow("L03TELA","L03TELA"  ,"Aglutinação dos Títulos dos Aluguéis"	,100,.F.,.F.,/*bAction*/,"L03",/*bGotFocus*/)

	oPainAcre  := oArea:GetWinPanel("L01ACRE"  ,"L01ACRE"  ,"L01")
	oPainCond  := oArea:GetWinPanel("L02COND"  ,"L02COND"  ,"L02")
	oPainValo  := oArea:GetWinPanel("L02VALO"  ,"L02VALO"  ,"L02")
	oPainOpco  := oArea:GetWinPanel("L02OPCO"  ,"L02OPCO"  ,"L02")
	oPainTela  := oArea:GetWinPanel("L03TELA"  ,"L03TELA"  ,"L03")

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainOpco:nClientWidth)
	aTamObj[4] := (oPainOpco:nClientHeight)
	
	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainOpco)
	oBotConf := tButton():New(aTamObj[1],aTamObj[2],"Confirmar",oPainOpco,{||  FWMsgRun(, {|oSay| Confirma(aPacelas) }, "Rotina de Aglutinação", "Aglutinando..." )},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Cancelar",oPainOpco,{|| CANCELA()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	@  07,    00 Say oSay1 Prompt 'Favorecido:'				FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  07,   150 Say oSay1 Prompt 'Loja'					FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  20,    00 Say oSay1 Prompt 'Condição de Pagto:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  20,   150 Say oSay1 Prompt 'Qtde. Parcelas'			FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel	
	@  34,    00 Say oSay1 Prompt 'Descrição:'				FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainCond Pixel

	@  05,  75 	MSGet oFornec	Var cFornec	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 06 When .T.	F3 "SA2AGL"		Of oPainCond 
	@  05, 200 	MSGet oLoja		Var cLoja	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  25, 06 When lParc				Of oPainCond 
	@  20,  75 	MSGet oCond		Var cCond	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 06 When .T.	F3 "SE4" 		Of oPainCond Valid AtualCmps(cCond)
	@  20, 200 	MSGet oParc		Var cParce	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE  25, 06 When lParc				Of oPainCond 
	@  35,  75 	MSGet oDescr	Var cDescr	 				FONT oFont11 COLOR CLR_BLUE Pixel SIZE 150, 06 When .F. 				Of oPainCond

	@  02,    00 Say oSay1 Prompt 'V. Total dos Titulos R$ :'	FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainValo Pixel	
	@  10,    00 	MSGet oValTotS	Var NValTotS 			FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo

	@  23,    00 Say oSay1 Prompt 'V. Total Novos Titulos R$:'		FONT oFont11 COLOR CLR_BLUE Size  70, 08 Of oPainValo Pixel	
	@  31,    00 	MSGet oValTot	Var NValTot	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo

	@  05,240 BUTTON "OK" SIZE 14,10 PIXEL OF oPainCond ACTION FWMsgRun(, {|oSay| U_IM06A02P(aCols3,cCond,cParce) }, "Rotina de Aglutinação", "Processando Registros..." )
																
//	@  20,240 CHECKBOX oCheckBx2 VAR lCheckBx2 PROMPT "Favorecido Fornecedor?" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainCond

//	oCheckBx2:bchange   := {|| Iif(lCheckBx2, oFornec:cf3 := "SA2AGL",oFornec:cf3 := "CNC_AG") }
	//@  42,    00 Say oSay1 Prompt 'Diferença R$:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oPainValo Pixel	
	//@  50,    00 	MSGet oDifere	Var nDifere	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 65, 06 When .F. Picture "@E@R 999,999,999.99" Of oPainValo


	oGetDados 	:= MsNewGetDados():New(aCoord[1]   ,aCoord[2]   ,oPainTela:nClientWidth/2,oPainTela:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue","",aAlter,,9999,cFieldOk	,"AllwaysFalse()"	,"AllwaysFalse()"		,oPainTela	,aHeadDados,aPacelas,/*{|| U_DV06GAT(3)}*/)
	oGetDados2	:= MsNewGetDados() :New(aCoord[1]   ,aCoord[2]   ,oPainAcre:nClientWidth/2,oPainAcre:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue","",aAlter2,,9999,cFieldOk	,"AllwaysFalse()"	,"AllwaysFalse()"		,oPainAcre	,aHeadTitu,aMultJur,/*{|| U_DV06GAT(2)}*/)

	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDados2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	For nx := 1 To len(aCols3)

		If aCols3[nx][1] == .T.	

			DbSelectArea("SE2")
			DbSetOrder(1) 

			IF SE2->(DbSeek(xFilial("SE2")+aCols[nx][3]+aCols[nx][4]+aCols[nx][5]+aCols[nx][6]+aCols[nx][8]+aCols[nx][9]))

				DbSelectArea("SA2")
				DbSetOrder(1) 

				IF SA2->(DbSeek(xFilial("SA2")+aCols[nx][8]+aCols[nx][9]))

					DbSelectArea("SED")
					DbSetOrder(1) 

					If SED->(DbSeek(xFilial("SED")+aCols[nx][7]))
							
						If SED->ED_CALCIRF == 'S'
						
							aCalcIRPF := U_F241BsIRPF(SE2->(Recno()),"SE2",aCols3[nx][13],.T.,,,,,.T.,,,.F.)
	
							nIRRF := Fa050TabIR(aCalcIRPF[1] - aCalcIRPF[4]) - aCalcIRPF[2]		
							
							lIrrf := .T.			
	
						Else
	
							nIRRF := 0
							
						Endif

					Endif

				Endif

			DbCloseArea()				
			DbCloseArea()
			DbCloseArea()

			Endif

			nTotalT := aCols3[nx][13] - nIRRF

			AADD(aMultJur,{aCols3[nx][4],aCols3[nx][5],aCols3[nx][8],aCols3[nx][9],aCols3[nx][10],aCols3[nx][14],aCols3[nx][13],nIRRF,0,0,nTotalT,.F.})

		Endif

	Next nx

	oValTotS:Refresh()

	oGetDados2:SetArray(aMultJur)
	oGetDados2:Refresh()
	oGetDados2:oBrowse:SetFocus()

	oDlg:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Procurando Ocorrências...","Aguarde...",{ || /*U_IM06A02P()*/})})

Return()

////////////////////////////////////////////////
//MONTA ARQUIVO TEMPORARIO
////////////////////////////////////////////////

Static Function CANCELA()

	oDlg:End()

	IM06A02G()

Return()

//Static Function U_IM06A02P(_aCols,cCond,cParce)
User Function IM06A02P(_aCols,cCond,cParce)

	Local nValor	:= 0
	Local aRegs		:= {}
	Local nParc		:= 0
	Local cParc		:= ""
	Local cNome		:= ""
	Local nParce	:= 0
	Local dVenci
	Local nParcelas	:= 0
	Local dVencto
	Local ny
	Local nx

	Private aVenc	:= {}

	If Alltrim(cFornec) == ""
		MsgAlert("Por favor, informe o Favorecido para geração dos Títulos", "Atenção")
		Return(.F.)
	Endif
	
	GeraSE2()

	RecLock("SZ8",.T.)
	SZ8->Z8_TITULO := cTitSE2
	SZ8->(MsUnlock())						

	aPacelas	:= {}

	nValTot := 0
	nDifere := 0

	aSort(_aCols,,,{|x,y| x[8]+x[9] < y[8]+y[9] })

	For ny := 1 to Len(aMultJur)	

		nValor 	+= oGetDados2:aCols[ny][11]

		nValTot 	+= oGetDados2:aCols[ny][07]
		nValTot 	+= oGetDados2:aCols[ny][10]
		nValTot 	+= oGetDados2:aCols[ny][09]

	Next ny

	aVenc := Condicao(nValor,cCond,0)

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
			POSICIONE("SA2", 1, xFilial("SA2") + cFornec + "01" , "A2_NOME"),;
			dVencto,;
			nValor,;
			.F.})

			//nValTot += nValor
		Next nx
	Else
		For nx := 1 to Len(aVenc)							
			nParc++
			cParc := STRZERO(nParc, 3, 0)

			AADD(aPacelas,{cTitSE2,;
			cParc,;
			cFornec,;
			cLoja,;
			POSICIONE("SA2", 1, xFilial("SA2") + cFornec + "01" , "A2_NOME"),;
			aVenc[nx][1],;
			aVenc[nx][2],;
			.F.})
			//nValTot += aVenc[nx][2]
		Next nx
	Endif	

	//oDifere:Refresh()			
	oValTot:Refresh()
	oGetDados:SetArray(aPacelas)
	oGetDados:Refresh()
	oGetDados:oBrowse:SetFocus()

Return

Static Function GeraSE2() //Gera novo titulo de acordo com os parâmetros

	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""
	Local cPrefixo 	:= SuperGetMV("IM_PREAGLU",.F.,"AGL")//GETMV("IM_PREAGLU") //Prefixo do Titulo
	Local cTipotit 	:= SuperGetMV("IM_TIPAGLU",.F.,"RC")//GETMV("IM_TIPAGLU") //Tipo do Titulo
	Local cSiglaTi 	:= "AGL" //Sigla que ira compor os 3 primeiros caracteres da numeracao do novo titulo

	cQuery	:= "SELECT MAX(Z8_TITULO) AS MAXCODIGO		" 		+ CRLF
	cQuery	+= "FROM " + RetSQLName("SZ8") + " SZ8	"	 	+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(dbGoTop())

	cTitSE2 := SUBSTR((cAlias)->MAXCODIGO,4,9)

	cTitSE2 := Val(cTitSE2)	+ 1

	cTitSE2 :=  cSiglaTi + STRZERO(cTitSE2, 6, 0)

Return()

Static Function Confirma(aTitulos)

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local cPrefixo 	:= "AGL"//GETMV("IM_PREAGLU") //Prefixo do Titulo
	Local cTipotit 	:= "RC"//GETMV("IM_TIPAGLU") //Tipo do Titulo
	Local nCont		:= 0
	Local cPar01
	Local cPar02
	Local cPar03
	Local cPar04
	Local cPar05
	Local cPar06
	Local cPar07
	Local cPar08
	Local nValnvT	:= 0 //Valor do novo titulo
	Local nTotAbat 	:= 0
	LOCAL nSalvRec	:=0
	Local nCentMd1	:= MsDecimais(1)
	Local nValOri	:= 0
	Local nValTit	:= 0
	Local nValCru	:= 0
	Local nValSal	:= 0
	Local cIdagl	:= ""
	Local cTitulos 	:= ""
	Local cParcela 	:= ""
	Local cFornece 	:= ""
	Local cLoja	   	:= ""
	Local cPrefixo	:= ""
	Local cIdfk		:= ""
	Local no
	Local i
	Local nz 

	Private lMsErroAuto := .F.
	Private aBaixa	:= {}
	Private aBaixa2	:= {}
	Private nDescont := nMulta := nJuros := 0
	
	cQuery	:= "SELECT MAX(E2_XIDAGL) AS MAXCODIGO		" 		+ CRLF
	cQuery	+= "FROM " + RetSQLName("SE2") + " SE2	"	 	+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(dbGoTop())

	cIdagl := (cAlias)->MAXCODIGO

	cIdagl := Val(cIdagl)	+ 1

	cIdagl :=  STRZERO(cIdagl, 6, 0)

	cPar01 := MV_PAR01
	cPar02 := MV_PAR02
	cPar03 := MV_PAR03
	cPar04 := MV_PAR04
	cPar05 := MV_PAR05
	cPar06 := MV_PAR06
	cPar07 := MV_PAR07
	cPar08 := MV_PAR08

	nCont := len(aTitulos)

	For no := 1 To Len(aTitulos)

		If aTitulos[no][7] == 0
			Alert("Atenção, existem parcela com o valor 0 (ZERO), favor verificar.","Atenção")
			Return(.F.)
		Endif

	Next no

	For i := 1 To Len(aMultJur)

		DbSelectArea("SE2")
		SE2->(dbSetOrder(24))

		If SE2->(dbSeek(aMultJur[i][1]+aMultJur[i][2]+aMultJur[i][3]+aMultJur[i][4]))

			If SE2->E2_SALDO > 0
			
				cHistBaixa := "Baixa Automatica"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Monta array com os dados da baixa a pagar do título³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 

				aBaixa := {}

				nJuros	:= oGetDados2:aCols[i][10] 
				nMulta	:= oGetDados2:aCols[i][9] 

				AADD(aBaixa, {"E2_FILIAL" 		, SE2->E2_FILIAL 			, Nil})
				AADD(aBaixa, {"E2_PREFIXO" 		, SE2->E2_PREFIXO 			, Nil})
				AADD(aBaixa, {"E2_NUM" 			, SE2->E2_NUM 				, Nil})
				AADD(aBaixa, {"E2_PARCELA" 		, SE2->E2_PARCELA			, Nil})
				AADD(aBaixa, {"E2_TIPO" 		, SE2->E2_TIPO 				, Nil})
				AADD(aBaixa, {"E2_FORNECE" 		, SE2->E2_FORNECE 			, Nil})
				AADD(aBaixa, {"E2_LOJA" 		, SE2->E2_LOJA 				, Nil}) 
				AADD(aBaixa, {"AUTMOTBX" 		, "DAC" 					, Nil})
				AADD(aBaixa, {"AUTDTBAIXA" 		, dDataBase 				, Nil}) 
				AADD(aBaixa, {"AUTDTCREDITO"	, dDataBase 				, Nil})
				AADD(aBaixa, {"AUTHIST" 		, cHistBaixa 				, Nil})
				AADD(aBaixa, {"AUTMULTA" 		, nMulta		 			, Nil})
				AADD(aBaixa, {"AUTJUROS" 		, nJuros		 			, Nil})
				AADD(aBaixa, {"E2_IRRF" 		, oGetDados2:aCols[i][8]	, Nil})
				
				ACESSAPERG("FIN080", .F.) 

				MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)

				If lMsErroAuto
					MOSTRAERRO() 
					Loop
				EndIf 

				cTitulos := SE2->E2_NUM
				cParcela := SE2->E2_PARCELA
				cFornece := SE2->E2_FORNECE
				cLoja	 := SE2->E2_LOJA
				cPrefixo := SE2->E2_PREFIXO
				cTitPai	 := SE2->E2_PREFIXO + SE2->E2_NUM + '  ' + SE2->E2_TIPO + ''+ SE2->E2_FORNECE + SE2->E2_LOJA
				cXfilial := SE2->E2_FILIAL 
				
				RecLock("SE2",.F.)
				SE2->E2_IRRF 		:= oGetDados2:aCols[i][8]
				SE2->E2_VRETIRF 	:= oGetDados2:aCols[i][8]
				SE2->E2_XIDAGL 		:= cIdagl
				SE2->(MsUnlock())					

				DbSelectArea("SE5")
				SE5->(dbSetOrder(23))
				
				If SE5->(dbSeek(cPrefixo+cTitulos+cParcela+cFornece+cLoja))
 
					RecLock("SE5",.F.)
					SE5->E5_VALOR 	:= oGetDados2:aCols[i][11]
					SE5->E5_VLMOED2 := oGetDados2:aCols[i][11]
					SE5->E5_VRETIRF := oGetDados2:aCols[i][8]
					SE5->E5_BASEIRF := SE2->E2_VALOR
					SE5->(MsUnlock())
					
					cIdfk := SE5->E5_IDORIG

				Endif
				
				If !Empty(cIdfk)

						DbSelectArea("FK2")
						FK2->(dbSetOrder(1))
		
						If FK2->(dbSeek(xFilial("FK2")+cIdfk))
		
							RecLock("FK2",.F.)
								FK2->FK2_VALOR 	:= oGetDados2:aCols[i][11]
								FK2->FK2_VLMOE2 := oGetDados2:aCols[i][11]
							FK2->(MsUnlock())
		
						Endif
		
						DbSelectArea("FK3")
						FK3->(dbSetOrder(3))
		
						If FK3->(dbSeek(xFilial("FK3")+cIdfk))
		
							RecLock("FK3",.F.)
								FK3->FK3_VALOR 	:= oGetDados2:aCols[i][8]
								FK3->FK3_BASIMP	:= SE2->E2_VALOR
							FK3->(MsUnlock())
		
						Endif
		
						DbSelectArea("FK4")
						FK4->(dbSetOrder(2))
		
						If FK4->(dbSeek(cIdfk))
		
							RecLock("FK4",.F.)
								FK4->FK4_VALOR 	:= oGetDados2:aCols[i][8]
								FK4->FK4_BASIMP	:= SE2->E2_VALOR
							FK4->(MsUnlock())
		
						Endif
						
				Endif
					
				DbSelectArea("SE2")
				SE2->(dbSetOrder(24))

				If SE2->(dbSeek(cTitulos+'001'+'UNIAO '+'00'))

					RecLock("SE2",.F.)
					SE2->E2_VALOR	:= 	oGetDados2:aCols[i][8]
					SE2->E2_SALDO	:= 	oGetDados2:aCols[i][8]
					SE2->E2_VLCRUZ	:= 	oGetDados2:aCols[i][8]
					SE2->(MsUnlock())
					
				Else
					If oGetDados2:aCols[i][8] > 0
						RecLock("SE2",.T.)
						SE2->E2_FILIAL		:= cXfilial
						SE2->E2_PREFIXO		:= cPrefixo
						SE2->E2_TIPO	 	:= 'TX'
						SE2->E2_NUM			:= cTitulos
						SE2->E2_PARCELA		:= '001'
						SE2->E2_FORNECE		:= 'UNIAO'
						SE2->E2_LOJA		:= '00'
						SE2->E2_NOMFOR		:= 'UNIAO'
						SE2->E2_NATUREZ		:= '5015004'
						SE2->E2_EMISSAO		:= ddatabase
						SE2->E2_EMIS1		:= ddatabase
						SE2->E2_VENCTO		:= ddatabase
						SE2->E2_VENCREA		:= ddatabase
						SE2->E2_VENCORI		:= ddatabase
						SE2->E2_VALOR		:= oGetDados2:aCols[i][8]
						SE2->E2_SALDO		:= oGetDados2:aCols[i][8]
						SE2->E2_VLCRUZ		:= oGetDados2:aCols[i][8]
						SE2->E2_MOEDA		:= 1
						SE2->E2_DIRF		:= '1'
						SE2->E2_CODRET		:= '3208'
						SE2->E2_ORIGEM		:= 'FINA080 '
						SE2->E2_HIST		:= "AGLUTINACAO"
						SE2->E2_FILORIG		:= xFilial("SE2") 
						SE2->E2_TITPAI		:= cTitPai
						SE2->E2_XUSERLI		:= cUserName
						SE2->E2_XHIST		:= "AGLUTINACAO"
						SE2->E2_XIDAGL		:= cIdagl
						MsUnLock()
					Endif
				Endif
				
			Else

				Alert("O título não possui saldo a pagar em aberto")

			EndIf 

		Else

			Alert("O título a pagar não foi localizado")

		EndIf

	Next i

	DbCloseArea()

	For nz := 1 To Len(aPacelas) 

		nValnvT := oGetDados:aCols[nz][7]

		RecLock("SE2",.T.)
		SE2->E2_FILIAL		:= xFilial("SE2")
		SE2->E2_PREFIXO		:= cPrefixo
		SE2->E2_TIPO	 	:= cTipotit
		SE2->E2_NUM			:= cTitSE2
		SE2->E2_PARCELA		:= aPacelas[nz][2]
		SE2->E2_FORNECE		:= aPacelas[nz][3]
		SE2->E2_LOJA		:= aPacelas[nz][4]
		SE2->E2_NOMFOR		:= aPacelas[nz][5]
		SE2->E2_NATUREZ		:= cNaturez
		SE2->E2_EMISSAO		:= ddatabase
		SE2->E2_EMIS1		:= ddatabase
		SE2->E2_VENCTO		:= ddatabase
		SE2->E2_VENCREA		:= ddatabase
		SE2->E2_VENCORI		:= ddatabase
		SE2->E2_VALOR		:= nValnvT
		SE2->E2_SALDO		:= nValnvT
		SE2->E2_VLCRUZ		:= nValnvT
		SE2->E2_MOEDA		:= 1
		SE2->E2_ORIGEM		:= 'FINA050 '
		SE2->E2_HIST		:= "AGLUTINACAO"
		SE2->E2_RATEIO		:= 'N'
		SE2->E2_OCORREN		:= '01'
		SE2->E2_FLUXO		:= 'S'
		SE2->E2_MULTNAT		:= '2'
		SE2->E2_MODSPB		:= '1'
		SE2->E2_FILORIG		:= xFilial("SE2") 
		SE2->E2_PRETPIS		:= '1'
		SE2->E2_PRETCOF		:= '1'
		SE2->E2_MDRTISS		:= '1'
		SE2->E2_FRETISS		:= '1'
		SE2->E2_PRETIRF		:= '1'
		SE2->E2_DATAAGE		:= ddatabase
		SE2->E2_TEMDOCS		:= '2'
		SE2->E2_STATLIB		:= '01'
		SE2->E2_RATFIN		:= '2'
		SE2->E2_XNUM		:= aPacelas[nz][1]
		SE2->E2_XUSERLI		:= cUserName
		SE2->E2_XHIST		:= "AGLUTINACAO"
		SE2->E2_XAUTOMA 	:= 'S'
		SE2->E2_XIDAGL		:= cIdagl
		MsUnLock()

	Next nz	

	DbCloseArea()

	MV_PAR01	:= cPar01
	MV_PAR02	:= cPar02 
	MV_PAR03	:= cPar03
	MV_PAR04	:= cPar04
	MV_PAR05	:= cPar05
	MV_PAR06	:= cPar06
	MV_PAR07	:= cPar07
	MV_PAR08	:= cPar08

	MsgInfo("Incluído título: "+cTitSE2+" Id de Aglutinação: "+cIdagl)

	oDlg:End()

	IM06A02G()

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

	oDescr:Refresh()
	oParc:Refresh()
	oParc:SetFocus()

Return()

User Function DV06GAT(nOp)

	Local nx

	DbSelectArea("SE2")
	DbSetOrder(24) 

	DbSelectArea("SA2")
	DbSetOrder(1) 

	DbSelectArea("SED")
	DbSetOrder(1) 

	nValTot := 0

	If nOp == 1

		oGetDados:aCols[oGetDados:nAt][7] := M->E2_VALOR

		For nx := 1 To Len(aCols)

			nValTot += aCols[nx][7]

		Next nx

	Elseif nOp == 2

		If oGetDados2:aCols[oGetDados2:nAt][9] > 0

			oGetDados2:aCols[oGetDados2:nAt][9] := 0
			oGetDados2:aCols[oGetDados2:nAt][8] := 0

		Endif

		oGetDados2:aCols[oGetDados2:nAt][11] := oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][10] + M->E2_MULTA - oGetDados2:aCols[oGetDados2:nAt][8]
		oGetDados2:aCols[oGetDados2:nAt][9] := M->E2_MULTA

		For nX := 1 to Len(aIrrf)

			If oGetDados2:aCols[oGetDados2:nAt][11] > aIrrf[nX][2] .And. oGetDados2:aCols[oGetDados2:nAt][11] < aIrrf[nX][1]
				
				IF SE2->(DbSeek(oGetDados2:aCols[oGetDados2:nAt][1]+oGetDados2:aCols[oGetDados2:nAt][2]+oGetDados2:aCols[oGetDados2:nAt][3]+oGetDados2:aCols[oGetDados2:nAt][4]))

					IF SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

						If SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
					
							If SED->ED_CALCIRF == 'S'
							
								oGetDados2:aCols[oGetDados2:nAt][8] := (((oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][10] + M->E2_MULTA) * aIrrf[nX][3]) / 100) - aIrrf[nX][4]
							
							Else
							
								oGetDados2:aCols[oGetDados2:nAt][8] := 0
							
							Endif
						
						Endif
					
					Endif
				
				Endif
				
				oGetDados2:aCols[oGetDados2:nAt][11] := (oGetDados2:aCols[oGetDados2:nAt][7] + M->E2_MULTA + oGetDados2:aCols[oGetDados2:nAt][10]) - oGetDados2:aCols[oGetDados2:nAt][8]
				
				Exit

			EndIf

		Next nX 

	Elseif nOp == 3

		If oGetDados2:aCols[oGetDados2:nAt][10] > 0

			oGetDados2:aCols[oGetDados2:nAt][10]	:= 0
			oGetDados2:aCols[oGetDados2:nAt][8]		:= 0

		Endif

		oGetDados2:aCols[oGetDados2:nAt][11] := oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][9] + M->E2_JUROS - oGetDados2:aCols[oGetDados2:nAt][8]
		oGetDados2:aCols[oGetDados2:nAt][10]	:= M->E2_JUROS

		For nX := 1 to Len(aIrrf)
		
		If oGetDados2:aCols[oGetDados2:nAt][11] > aIrrf[nX][2] .And. oGetDados2:aCols[oGetDados2:nAt][11] < aIrrf[nX][1]	

			IF SE2->(DbSeek(oGetDados2:aCols[oGetDados2:nAt][1]+oGetDados2:aCols[oGetDados2:nAt][2]+oGetDados2:aCols[oGetDados2:nAt][3]+oGetDados2:aCols[oGetDados2:nAt][4]))

				IF SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

					If SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
					
							If SED->ED_CALCIRF == 'S'
							
								oGetDados2:aCols[oGetDados2:nAt][8] := (((oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][9] + M->E2_JUROS) * aIrrf[nX][3]) / 100) - aIrrf[nX][4]
							
							Else
							
								oGetDados2:aCols[oGetDados2:nAt][8] := 0
							
							Endif
							
					Endif
					
				Endif
					
					oGetDados2:aCols[oGetDados2:nAt][11] := (oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][9] + M->E2_JUROS) - oGetDados2:aCols[oGetDados2:nAt][8]
					
					Exit
					
			EndIf
			
		Endif
			
		Next nX
		
		DbCloseArea()
		DbCloseArea()
		DbCloseArea()

	Elseif nOp == 4
 
		If oGetDados2:aCols[oGetDados2:nAt][8] > 0

			oGetDados2:aCols[oGetDados2:nAt][8]	:= 0

		Endif

		oGetDados2:aCols[oGetDados2:nAt][11] := oGetDados2:aCols[oGetDados2:nAt][7] + oGetDados2:aCols[oGetDados2:nAt][9] + oGetDados2:aCols[oGetDados2:nAt][10] - M->E2_IRRF
		oGetDados2:aCols[oGetDados2:nAt][8]	:= M->E2_IRRF

	Endif

	nDifere := nValTot - NValTotS

	nTotalT := oGetDados2:aCols[oGetDados2:nAt][11]

	oValTot:Refresh()

	oGetDados:Refresh()
	
	oGetDados2:Refresh()

Return(.T.)

Static Function sValidPerg(cPerg)

	Local j
	Local i

	cPerg := PADR(cPerg,10)
	aRegs := {}
	DbSelectArea("SX1")
	DbSetOrder(1)


	AADD(aRegs,{cPerg,"01","Contrato De ?"	  ,""	,"", "mv_ch1" ,"C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	AADD(aRegs,{cPerg,"02","Contrato Até ?"	  ,""	,"", "mv_ch2" ,"C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	AADD(aRegs,{cPerg,"03","Vencimento De ?"  ,""	,"", "mv_ch3" ,"D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Vencimento Até ?" ,""	,"", "mv_ch4" ,"D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Fornecedor De ?"  ,""	,"", "mv_ch5" ,"C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	AADD(aRegs,{cPerg,"06","Loja De ?"		  ,""	,"", "mv_ch6" ,"C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Fornecedor Até?"  ,""	,"", "mv_ch7" ,"C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	AADD(aRegs,{cPerg,"08","Loja Até ?"		  ,""	,""	,"mv_ch8" ,"C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Titulo De ?"  	  ,""	,"", "mv_ch9" ,"C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SE2AGL",""})
	AADD(aRegs,{cPerg,"10","Titulo Até ?"	  ,""	,""	,"mv_ch10","C",09,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SE2AGL",""})

	For i:=1 to LEN(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
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

User Function IM06A02CO()

	Local _cRet := ""
	Local _nx

	For _nX := 1 to Len(aMultJur)

		_cRet += aMultJur[_nX][3] + "/"

	Next _nX

Return _cRet

User Function IMIRRF()

	Local oDlg,oLbx
	Local cVar:=""
	Local nOpc := 0
	Local aCampos := {}
	Local cArqTmp := ""
	Local nX := 0
	Local nY := 0           
	Local nDiffWiz := 0

	//DEFAULT lWizard := .T.
	Local aArray := {}  
	Local nAnter := 0                          
	//DEFAULT lEdit := .F.                                                              

	aCampos := IRFStruArq()

	cArqTmp := CriaTrab( aCampos , .T.)
	dbUseArea( .T.,, cArqTmp, "cArqTmp", if(.F. .OR. .F., !.F., NIL), .F. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ "Importa" o arquivo TXT com a tabela do I.R.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "cArqTmp" )
	If File( "SIGAADV.IRF" )
		APPEND FROM SIGAADV.IRF SDF            
		nX := cArqTmp->(RecCount())
		If nX < 5
			For nY := nX+1 to 5
				RecLock( "cArqTmp" , .T. )
			Next
		Endif
	Else        
		For nX := 1 to 5
			RecLock( "cArqTmp" , .T. )
		Next
	Endif        
	dbGoTop()

	//If lWizard
	While !("cArqTmp")->(Eof())
		IF aScan(aArray,{|x| x[1] = Val(LIMITE)}) = 0
			Aadd(aArray, {Val(LIMITE), nAnter, Val(ALIQUOTA), Val(DEDUZIR)})
			nAnter := Val(LIMITE) + 0.01
		EndIf
		DbSkip()
	End
	
	DbCloseArea()

Return (aArray)
