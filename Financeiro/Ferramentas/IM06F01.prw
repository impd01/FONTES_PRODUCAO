#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM06F01    บAutor  ณVinicius Henrique       บ Data ณ01/11/2018    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM06F01 - Analisa e exclui titulos errados do setor de alugueis   บฑฑ
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

//Indices criados no SQL para otimiza็ใo da QUERY

/*
USE [P12DSV]
GO
CREATE NONCLUSTERED INDEX IM06F01001
ON [dbo].[SE2010] ([E2_SALDO],[D_E_L_E_T_],[E2_XIDAGL],[E2_PREFIXO],[E2_NUM],[E2_TIPO],[E2_FORNECE],[E2_NATUREZ],[E2_EMISSAO],[E2_VENCTO])
INCLUDE ([E2_PARCELA],[E2_LOJA],[E2_NOMFOR],[E2_VENCREA],[E2_VALOR],[E2_XUSERLI])
GO
*/

/*
USE [P12DSV]
GO
CREATE NONCLUSTERED INDEX IM06F01002
ON [dbo].[SE2010] ([D_E_L_E_T_],[E2_XIDAGL],[E2_PREFIXO],[E2_NUM],[E2_TIPO],[E2_FORNECE],[E2_NATUREZ],[E2_EMISSAO],[E2_VENCTO])
INCLUDE ([E2_PARCELA],[E2_LOJA],[E2_NOMFOR],[E2_VENCREA],[E2_VALOR],[E2_SALDO],[E2_XUSERLI])
GO
*/

User Function IM06F01()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IM06F01B"

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
	Private oMV_PAR11
	Private oMV_PAR12
 	Private oMV_PAR13
	Private oMV_PAR14

	Private aHeadRank		:= {}
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

	Private oOk				:= LoadBitmap( GetResources(), "LBOK"  )
	Private oNo				:= LoadBitmap( GetResources(), "LBNO"  )
	Private nMark_Est 		:= 0, nMark_End := 0,  nMark_XXX := 0,  nMark_Del := 0
	Private oCheckBOX
	Private lCheckBOX 		:= .F.
	Private lMarc			:= .T.
	Private cUsuario		:= Space(25)		
	Private oUsuario
	Private oTela
	Private oCombo1  		:= "1=Sim"
	Private cCombo1			:= "1=Nใo"
	Private nCont			:= 0
	Private oVlLiq
	Private nTitulos		:= 0
	Private oGetRank
	
	AADD(aCols, {.F.,"","","","","","","","",CToD("  /  /  "),CToD("  /  /  "),CToD("  /  /  "),0,0,"",""})

//	sValidPerg(cPerg)

	If ! Pergunte(cPerg,.T.)
		Return
	Endif
	
	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Tํtulos Financeiros"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
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

//	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,aCposRank,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,/*uChange*/)
//	oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Gera Dados",oPainBoto,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||IM06F02()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)  
	oBotDrill := tButton():New(aTamObj[1],aTamObj[2],"Excluir Tํtulos",oPainBoto,{|| Processa( {|| IM06F01P(aCols) },"Aguarde Excluindo Tํtulos" ) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| oBotDrill:lActive := .T. })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	aCoordTota		:= FWGetDialogSize(oPainTota)
	oScroll 		:= TScrollBox():New(oPainTota,aCoordTota[1], aCoordTota[2], aCoordTota[3], aCoordTota[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT

	@  07,   00 Say oSay1 Prompt 'Emissใo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,   00 Say oSay1 Prompt 'Emissใo At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,   00 Say oSay1 Prompt 'Vencimento De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,   00 Say oSay1 Prompt 'Vencimento At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  55,   00 Say oSay1 Prompt 'Titulo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  67,   00 Say oSay1 Prompt 'Titulo At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  32,  280 Say oSay1 Prompt 'Usuแrio:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  07,  130 Say oSay1 Prompt 'Fornecedor De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,  130 Say oSay1 Prompt 'Fornecedor Ate:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,  130 Say oSay1 Prompt 'Prefixo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,  130 Say oSay1 Prompt 'Prefixo At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  55,  130 Say oSay1 Prompt 'Natureza De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  67,  130 Say oSay1 Prompt 'Natureza At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  07,  280 Say oSay1 Prompt 'ID AGL De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,  280 Say oSay1 Prompt 'ID AGL At้:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  07,  00 Say oSay1 Prompt 'Total Titulos:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oScroll Pixel	

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  53,  55 	MSGet oMV_PAR05	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  65,  55 	MSGet oMV_PAR06	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara

	@  31,  320	MSGet oUsuario	Var cUsuario 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  170, 05 When .T.	Of oPainPara

	@  07,  185 MSGet oMV_PAR07	Var MV_PAR07 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA2" Of oPainPara	
	@  19,  185 MSGet oMV_PAR08	Var MV_PAR08 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA2" Of oPainPara	
	@  31,  185 MSGet oMV_PAR09	Var MV_PAR09 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  43,  185 MSGet oMV_PAR10	Var MV_PAR10 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara	
	@  53,  185 MSGet oMV_PAR11	Var MV_PAR11 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SED" Of oPainPara	
	@  65,  185 MSGet oMV_PAR12	Var MV_PAR12 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SED" Of oPainPara

	@  07,  320 MSGet oMV_PAR13	Var MV_PAR13 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  19,  320 MSGet oMV_PAR14	Var MV_PAR14 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara


	@  07,  55 MSGet oVlLiq		Var nTitulos	 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .F. Picture "99999" Of oScroll

	@  57, 280 CHECKBOX oCheckBOX VAR lCheckBOX PROMPT "Marcar/Desmarcar Todos" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainPara    

	@ .3, .1 LISTBOX oEstoque		FIELDS HEADER "","No. Tํtulo","Parcela","Tipo","Prefixo","Fornecedor","Loja","Nome","Natureza","Emissao","Vencimento","Venc. Real","Valor","Saldo","Usuแrio","ID AGL" FIELDSIZES 15,40,30,35,30,30,30,120,30,35,35,35,35,35,50,35 SIZE oPainRank:nClientWidth/2, oPainRank:nClientHeight/2.2 OF oPainRank

	ShowEst()

	oEstoque:bLDblClick := {|| aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1], aCols:DrawSelect() }

	oCheckBOX:bchange   := {||Seltodos() }	

	@  44,  280 Say oSay1 Prompt 'Aglutina็ใo?:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	oCombo1 :=TComboBox():New( 43, 320,{|u|if(PCount()>0, cCombo1:=u, cCombo1)},{"1=Sim",;
        "2=Nใo"}, 065, 05, oPainPara, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

    cCombo1 := '1'

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || IM06F02()})})

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM06F02    บAutor  ณVinicius Henrique       บ Data ณ05/11/2018    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณIM06F02 - Processa Query e carrega Array com informa็๕es recebidasบฑฑ
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

Static Function IM06F02()

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	
	aColsRank 		:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}
	
	nCont := 0

	lCheckBOX 		:= .F.

	cQuery	:= "SELECT E2_NUM, E2_PARCELA, E2_TIPO, E2_PREFIXO, E2_FORNECE,E2_LOJA, E2_NOMFOR,				" + CRLF 
	cQuery	+= "E2_NATUREZ, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_XUSERLI, E2_XIDAGL, E2_SALDO	" + CRLF
	cQuery	+= "FROM " + RetSQLName("SE2") + " SE2 (NOLOCK)													" + CRLF
	cQuery	+= "WHERE  SE2.D_E_L_E_T_ = ' '													 				" + CRLF
	cQuery	+= "AND SE2.E2_EMISSAO BETWEEN 	'" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'			" + CRLF
	cQuery	+= "AND SE2.E2_VENCTO BETWEEN 	'" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'			" + CRLF
	cQuery	+= "AND SE2.E2_NUM BETWEEN 		'" + MV_PAR05 + "' AND '" + MV_PAR06			 + "'			" + CRLF
	cQuery	+= "AND SE2.E2_FORNECE BETWEEN 	'" + MV_PAR07 + "' AND '" + MV_PAR08			 + "'			" + CRLF
	cQuery	+= "AND SE2.E2_PREFIXO BETWEEN 	'" + MV_PAR09 + "' AND '" + MV_PAR10			 + "'			" + CRLF
	cQuery	+= "AND SE2.E2_NATUREZ BETWEEN 	'" + MV_PAR11 + "' AND '" + MV_PAR12			 + "'			" + CRLF
	cQuery	+= "AND SE2.E2_XIDAGL BETWEEN 	'" + MV_PAR13 + "' AND '" + MV_PAR14			 + "'			" + CRLF
	If Alltrim(cUsuario) <> ""
		cQuery	+= "AND SE2.E2_XUSERLI LIKE '%"+Alltrim(cUsuario)+"%'										" + CRLF
	Endif
	If cCombo1 == '1'
		cQuery	+= "AND SE2.E2_XIDAGL <> ''																	" + CRLF
	Else
		cQuery	+= "AND SE2.E2_XIDAGL = ''																	" + CRLF
	Endif
	cQuery	+= "AND SE2.E2_TIPO <> 'PR'																		" + CRLF	
//	cQuery	+= "AND SE2.E2_SALDO < SE2.E2_VALOR																" + CRLF	

	MEMOWRITE("IM06F01.SQL",cQuery)

	TCQUERY cQuery NEW ALIAS (cAlias)

	(cAlias)->(DbGoTop())

	nTitulos := 0

	Do While !(cAlias)->(Eof()) 

		AADD(aCols,{.F.,;
		(cAlias)->E2_NUM,;
		(cAlias)->E2_PARCELA,;
		(cAlias)->E2_TIPO,;
		(cAlias)->E2_PREFIXO,;
		(cAlias)->E2_FORNECE,;
		(cAlias)->E2_LOJA,;
		(cAlias)->E2_NOMFOR,;
		(cAlias)->E2_NATUREZ,;
		DtoC(StoD((cAlias)->E2_EMISSAO)),;
		DtoC(StoD((cAlias)->E2_VENCTO)),;
		DtoC(StoD((cAlias)->E2_VENCREA)),;
		(cAlias)->E2_VALOR,;
		(cAlias)->E2_SALDO,;
		(cAlias)->E2_XUSERLI,;
		(cAlias)->E2_XIDAGL,;
		.F.})
		
		nTitulos++

		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())  

	ShowEst()

	oEstoque:Refresh()
	oEstoque:bLDblClick := {|| MarcaEst(1) }
	oEstoque:brClicked  := {|| OrdemEst(1) }

	aColsRank := aClone(aCols)
//	oGetRank:SetArray(aColsRank)
	oVlLiq:Refresh()
//	oGetRank:Refresh()
//	oGetRank:oBrowse:SetFocus()
	
Return

Static Function IM06F01P(aCols)

Local aBaixa := {}
Local nTotal	:= 0
Local lSelec	:= .F.
	
	cPar01 := MV_PAR01
	cPar02 := MV_PAR02
	cPar03 := MV_PAR03
	cPar04 := MV_PAR04
	cPar05 := MV_PAR05
	cPar06 := MV_PAR06
	cPar07 := MV_PAR07
	cPar08 := MV_PAR08
	cPar09 := MV_PAR09
	cPar10 := MV_PAR10
	cPar11 := MV_PAR11
	cPar12 := MV_PAR12
	cPar13 := MV_PAR13
	cPar14 := MV_PAR14

	cHistBaixa := 'Exclusใo de baixa automatica'
	
	ProcRegua(nCont) 
	
	For nx := 1 To Len(aCols)

		IF aCols[nx][1]
		
			lSelec := .T.

			DbSelectArea("SE2")
			SE2->(dbSetOrder(24))
	
			If SE2->(dbSeek(aCols[nx][2]+aCols[nx][3]+aCols[nx][6]+aCols[nx][7]))
					
					IncProc("Excluindo Tํtulo: " + SE2->E2_NUM)					

					lMsErroAuto := .F.

					aBaixa := {}

					AADD(aBaixa, {"E2_FILIAL" 		, SE2->E2_FILIAL 			, Nil})
					AADD(aBaixa, {"E2_PREFIXO" 		, SE2->E2_PREFIXO 			, Nil})
					AADD(aBaixa, {"E2_NUM" 			, SE2->E2_NUM 				, Nil})
					AADD(aBaixa, {"E2_PARCELA" 		, SE2->E2_PARCELA			, Nil})
					AADD(aBaixa, {"E2_TIPO" 		, SE2->E2_TIPO 				, Nil})
					AADD(aBaixa, {"E2_FORNECE" 		, SE2->E2_FORNECE 			, Nil})
					AADD(aBaixa, {"E2_LOJA" 		, SE2->E2_LOJA 				, Nil}) 

					ACESSAPERG("FIN080", .F.) 
					
					If SE2->E2_SALDO == SE2->E2_VALOR
						RecLock( 'SE2', .F. )
							SE2->( dbDelete() )
						SE2->( MsUnlock() )                		
						
						nTotal++
						Loop
					Else
						MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 6)
						If lMsErroAuto
							MOSTRAERRO() 
							Loop
						EndIf
						RecLock( 'SE2', .F. )
							SE2->( dbDelete() )
						SE2->( MsUnlock() )                		
						
						nTotal++
						Loop
					Endif

			Endif
	
			DbCloseArea()
		
		Endif
		
	Next nx
	
	MV_PAR01 := cPar01
	MV_PAR02 := cPar02
	MV_PAR03 := cPar03
	MV_PAR04 := cPar04
	MV_PAR05 := cPar05
	MV_PAR06 := cPar06
	MV_PAR07 := cPar07
	MV_PAR08 := cPar08
	MV_PAR09 := cPar09
	MV_PAR10 := cPar10
	MV_PAR11 := cPar11
	MV_PAR12 := cPar12
	MV_PAR13 := cPar13
	MV_PAR14 := cPar14
	
	If lSelec
	
		MsgInfo(cValtoChar(nTotal) + " Tํtulos Excluํdos","TOTVS")
		IM06F02()
	ELse
	
		MsgAlert("Nenhum Tํtulo Selecionado.","TOTVS")
	
	Endif

Return()

Static Function ShowEst()

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
	aCols[oEstoque:nAt,16] }}

Return

//+--------------------------------------------------------------------+
//| Rotina | MarcaEst 	| Autor | Vinicius Henrique	 |Data| 18.09.2017 |
//+--------------------------------------------------------------------+
//| Descr. | Fun็ใo para carregar o aTransf.						   |
//+--------------------------------------------------------------------+
//| Uso    | SIGAEST - Local									 	   |
//+--------------------------------------------------------------------+
Static Function MarcaEst(nOpc)

	Private nLinha

	///////////////////////////////////////////////////////////////////

	If nOpc == 1
		If aCols[oEstoque:nAt][1]          ///////////////////Desmarcando Array
			//nMark_Del := Val(aCols[nAt,2])
			nMark_Del := Val(aCols[oEstoque:nAt,2])
			nCont++
			aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1]
			oEstoque:DrawSelect()
			oEstoque:Refresh()		
			Return			
		Endif

		AchMarca()  

		nMark_End := 0
		nMark_XXX := 0

		aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1]
		oEstoque:DrawSelect()

		If aCols[oEstoque:nAt][1]
			nMark_Est++
		Else
			aCols[oEstoque:nAt][2]   := " "
		EndIf

	Else

		nMark_End := 0
		nMark_XXX := 0
		nMark_Est := 0

		For _nX := 1 to Len(aCols)

			If lMarc

				AchMarca()

				aCols[_nX][1] := lMarc
				oEstoque:DrawSelect()

				nMark_Est++

			Else

				oEstoque:DrawSelect()
				aCols[_nX][1] := lMarc
				oEstoque:Refresh()		

			EndIF

		Next _nX

		lMarc := Iif(lMarc,.F.,.T.)
		//MS20180208.en
		
	Endif

Return

Static Function AchMarca()
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

Static Function Seltodos()

	MarcaEst(2)
	oEstoque:Refresh()	
	
Return()

Static Function sValidPerg(cPerg)
	cPerg := PADR(cPerg,10)
	aRegs := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	AADD(aRegs,{cPerg,"01","Contrato De ?"	  ,""	,"", "mv_ch1" ,"C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	AADD(aRegs,{cPerg,"02","Contrato At้ ?"	  ,""	,"", "mv_ch2" ,"C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	AADD(aRegs,{cPerg,"03","Vencimento De ?"  ,""	,"", "mv_ch3" ,"D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Vencimento At้ ?" ,""	,"", "mv_ch4" ,"D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Fornecedor De ?"  ,""	,"", "mv_ch5" ,"C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	AADD(aRegs,{cPerg,"06","Loja De ?"		  ,""	,"", "mv_ch6" ,"C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Fornecedor At้?"  ,""	,"", "mv_ch7" ,"C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	AADD(aRegs,{cPerg,"08","Loja At้ ?"		  ,""	,""	,"mv_ch8" ,"C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Titulo De ?"  	  ,""	,"", "mv_ch9" ,"C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SE2AGL",""})
	AADD(aRegs,{cPerg,"10","Titulo At้ ?"	  ,""	,""	,"mv_ch10","C",09,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SE2AGL",""})

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
