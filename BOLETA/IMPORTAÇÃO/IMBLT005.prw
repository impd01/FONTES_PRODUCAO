#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002

User Function IMBLT005()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IMPBOLTA"

	Private oRegs
	Private oValor
	Private nRegs			:= 0
	Private nValor			:= 0
	Private oMV_PAR01
	Private oMV_PAR02
	Private oMV_PAR03
	Private oMV_PAR04
	Private oMV_PAR05
	Private oMV_PAR06
	Private oMV_PAR07
	Private oMV_PAR08
	Private MV_PAR01
	Private MV_PAR02
	Private MV_PAR03
	Private MV_PAR04
	Private MV_PAR05
	Private MV_PAR06
	Private MV_PAR07
	Private MV_PAR08

	Private oGetRank

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
	Private	oImp			:= LoadBitmap( GetResources(), "BR_VERMELHO"  )
	Private oProc			:= LoadBitmap( GetResources(), "BR_VERDE"  )
	Private nMark_Est 		:= 0, nMark_End := 0,  nMark_XXX := 0,  nMark_Del := 0
	Private oCheckBOX
	Private lCheckBOX 		:= .F.
	Private lMarc			:= .T.	
	Private cEndereco		:= Space(50)
	Private oEndereco		
	Private oCombo1  		:= "T=Todos"
	Private cCombo1			:= "T=Todos"
	
	AADD(aCols, {.F.,"@BMP",CToD("  /  /  "),"","","","","","","","","","","","",""})
	AADD(aCols1, {.F.,"@BMP",CToD("  /  /  "),"","","","","","","","","","","","",""})

	sValidPerg(cPerg)

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD
	DEFINE FONT oFont13    NAME "Arial"	SIZE 0, -14 

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Registros Boleta Eletr๔nica"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",35,.T.)
	oArea:AddLine("L02",65,.T.)

	oArea:AddCollumn("L01PARA"  , 65,.F.,"L01")
	oArea:AddCollumn("L01TOTA"  , 25,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 10,.F.,"L01")
	oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

	oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Parโmetros"									, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01TOTA" ,"L01TOTA"  ,"Totais"										, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Fun็๕es" 									, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Registros de Importa็ใo Boleta Eletr๔nica"	, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)		

	oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
	oPainTota  := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA"  ,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
	oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,aCposRank,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,/*uChange*/)

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Gera Dados",oPainBoto,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||IM06A02G()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotProc := tButton():New(aTamObj[1],aTamObj[2],"Processar",oPainBoto,{|| LJMsgRun('Processando Dados','Aguarde, Processando Dados',{||IMBLTPRC()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

//	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
//	oBotRel:= tButton():New(aTamObj[1],aTamObj[2],"Relat๓rio/Grafico",oPainBoto,{||  LJMsgRun('Imprimindo...','Aguarde, Imprimindo...',{||TpHtml(aCols)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	@  07,   00 Say oSay1 Prompt 'Data De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,   00 Say oSay1 Prompt 'Data At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,   00 Say oSay1 Prompt 'Igreja De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,   00 Say oSay1 Prompt 'Igreja At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  07,  130 Say oSay1 Prompt 'Pastor De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,  130 Say oSay1 Prompt 'Pastor At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,  130 Say oSay1 Prompt 'Boleta De:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,  130 Say oSay1 Prompt 'Boleta At้:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel


	@  55,  130 Say oSay1 Prompt 'Endere็o:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  55,   00 Say oSay1 Prompt 'Status:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1BLT" 	Of oPainPara	
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1BLT" 	Of oPainPara

	@  05, 185 	MSGet oMV_PAR05	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SRA01" 	Of oPainPara	
	@  17, 185 	MSGet oMV_PAR06	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SRA01" 	Of oPainPara
	@  29, 185 	MSGet oMV_PAR07	Var MV_PAR07 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T. Of oPainPara	
	@  41, 185 	MSGet oMV_PAR08	Var MV_PAR08 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	Of oPainPara

	@  53, 185  MSGet oEndereco	Var cEndereco 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE 170, 05 When .T.	Of oPainPara	

	@  07,  05 Say  oSay Prompt 'Total Registros:'		FONT oFont13 COLOR CLR_BLUE pixel Size  60, 08 Of oPainTota
	@  27,  05 Say  oSay Prompt 'Total R$:'				FONT oFont13 COLOR CLR_BLUE pixel Size  60, 08 Of oPainTota

	@  07,  70 MSGet oRegs		Var nRegs	 			FONT oFont13 COLOR CLR_BLUE Pixel SIZE  80, 09 When .F. Of oPainTota
	@  27,  70 MSGet oValor		Var nValor		 		FONT oFont13 COLOR CLR_BLUE Pixel SIZE  80, 09 When .F. Picture "@E@R 999,999,999,999.99" Of oPainTota

	oCombo1 :=TComboBox():New( 53, 55,{|u|if(PCount()>0, cCombo1:=u, cCombo1)},{"I=Importados",;
        "P=Processados","T=Todos"}, 065, 05, oPainPara, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

    cCombo1 := 'T'

	@  65, 185 CHECKBOX oCheckBOX VAR lCheckBOX PROMPT "Marcar/Desmarcar Todos" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainPara 
	
	@ 0, 0 LISTBOX oEstoque		FIELDS HEADER "","","Boleta","Data","Horario","Valor","Igreja","Descri็ใo","Endere็o","Igreja Superior","CPF Pastor","Nome","Banco","Agencia","Conta","Tipo Pagamento" FIELDSIZES 15,15,15,15,30,40,30,35,120,120,30,120,30,30,35,35 SIZE oPainRank:nClientWidth/2,oPainRank:nClientHeight/2 OF oPainRank

	ShowEst()

	oEstoque:bLDblClick := {|| aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1], aCols:DrawSelect() }

	oCheckBOX:bchange   := {||Seltodos(oGetRank:aCols) }	

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || IM06A02G()})})

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณIM06A02G   บAutor  ณ       บ Data ณ    บฑฑ
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
Static Function IM06A02G()

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local nCont		:= 0
	Local cEnd		:= ""
	Local cTpPagto	:= ""

	aColsRank 		:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}

	lCheckBOX 		:= .F.
	
	nValor := 0
	
	_cQuery	:= "SELECT Z5_DATA,																		" + CRLF
	_cQuery	+= "Z5_BOLETA,																			" + CRLF
	_cQuery	+= "Z5_VALOR,																			" + CRLF
	_cQuery	+= "Z5_XIGREJA,																			" + CRLF
	_cQuery	+= "A1_NOME,																			" + CRLF
	_cQuery	+= "A1_END,																				" + CRLF
	_cQuery	+= "A1_XDESSUP,																			" + CRLF
	_cQuery	+= "A1_XNUMERO,																			" + CRLF
	_cQuery	+= "Z5_XMAT,																			" + CRLF
	_cQuery	+= "RA_NOME,																			" + CRLF
	_cQuery	+= "Z5_BANCO,																			" + CRLF
	_cQuery	+= "Z5_AGENCIA,																			" + CRLF
	_cQuery	+= "Z5_CONTA,																			" + CRLF
	_cQuery	+= "Z5_XTPPGTO,																			" + CRLF
	_cQuery	+= "Z5_STATUS,																			" + CRLF
	_cQuery	+= "Z5_CPF,																				" + CRLF
	_cQuery	+= "Z5_XHREUNI																			" + CRLF
	_cQuery	+= "FROM SZ5010 SZ5																		" + CRLF
	_cQuery	+= "LEFT JOIN SRA010 SRA																" + CRLF
	_cQuery	+= "ON SRA.RA_CIC = SZ5.Z5_CPF															" + CRLF
	_cQuery	+= "LEFT JOIN SA1010 SA1																" + CRLF
	_cQuery	+= "ON SA1.A1_COD = SZ5.Z5_XIGREJA														" + CRLF
	_cQuery	+= "WHERE																				" + CRLF
	_cQuery	+= "SZ5.D_E_L_E_T_ = ' '																" + CRLF
	_cQuery	+= "AND SZ5.Z5_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'		" + CRLF
	_cQuery	+= "AND SZ5.Z5_XIGREJA BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'				" + CRLF
	_cQuery	+= "AND SZ5.Z5_CPF BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'					" + CRLF
	_cQuery	+= "AND SZ5.Z5_BOLETA BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'					" + CRLF
	If Alltrim(cEndereco) <> ""
	_cQuery	+= "AND SA1.A1_END LIKE '%"+Alltrim(cEndereco)+"%'										" + CRLF
	Endif
	If cCombo1 <> 'T'
		_cQuery	+= "AND SZ5.Z5_STATUS = '" + cCombo1 + "'											" + CRLF
	Endif
	_cQuery	+= "GROUP BY Z5_DATA,Z5_BOLETA,Z5_VALOR,Z5_XIGREJA,A1_NOME,A1_END,A1_XDESSUP,A1_XNUMERO,Z5_XMAT,RA_NOME,Z5_BANCO,Z5_AGENCIA,Z5_CONTA,Z5_XTPPGTO,Z5_STATUS,Z5_CPF,Z5_XHREUNI " + CRLF

	MEMOWRITE("IMBLT005.SQL",_cQuery)

	TCQUERY _cQuery NEW ALIAS (cAlias)

	Do While !(cAlias)->(Eof()) 

		If (cAlias)->Z5_XTPPGTO == 'TT'
			cTpPagto := "Transfer๊ncia TV"
		Elseif (cAlias)->Z5_XTPPGTO == 'TS'	
			cTpPagto := "Transfer๊ncia Saldo"
		Elseif (cAlias)->Z5_XTPPGTO == 'ED'	
			cTpPagto := "Entrada Dinheiro"
		Elseif (cAlias)->Z5_XTPPGTO == 'EC'	
			cTpPagto := "Entrada Cheque"
		Endif

		nCont++

		nValor += (cAlias)->Z5_VALOR

		cEnd := Alltrim((cAlias)->A1_END) + ", " + (cAlias)->A1_XNUMERO

//		cValor	:= TRANSFORM((cAlias)->Z5_VALOR, '@E 9,999,999.99')

		cHora	:= TRANSFORM((cAlias)->Z5_XHREUNI, '@R XX:XX')  

		AADD(aCols,{.F.,; 
		(cAlias)->Z5_STATUS,;
		(cAlias)->Z5_BOLETA,;
		DtoC(StoD((cAlias)->Z5_DATA)),;
		cHora,;
		(cAlias)->Z5_VALOR,;
		(cAlias)->Z5_XIGREJA,;
		(cAlias)->A1_NOME,;
		cEnd,;
		(cAlias)->A1_XDESSUP,;
		(cAlias)->Z5_CPF,;
		(cAlias)->RA_NOME,;
		(cAlias)->Z5_BANCO,;
		(cAlias)->Z5_AGENCIA,;
		(cAlias)->Z5_CONTA,;
		cTpPagto,;
		.F.})

		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())  
	
	nRegs := nCont
	
	ASORT(aCols,,,{|x,y| x[4]+x[5] < y[4]+y[5] })

	ShowEst()
	oEstoque:Refresh()
	oValor:Refresh()
	oRegs:Refresh()
	oEstoque:bLDblClick := {|| MarcaEst(1) }
	oEstoque:brClicked  := {|| OrdemEst(1) }

	aColsRank := aClone(aCols)
	oGetRank:SetArray(aColsRank)
	oGetRank:Refresh()
	oGetRank:oBrowse:SetFocus()

Return()

Static Function ShowEst()

	oEstoque:SetArray(aCols)
	oEstoque:bLine	:= {||{If(aCols[oEstoque:nAt,1],oOk,oNo),;
	Iif(aCols[oEstoque:nAt,2] == 'I',oImp,oProc),;
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
	aCols[oEstoque:nAt,15]}}

Return

Static Function ShowEnd()

	oOper:Refresh()
	oEndereco:SetArray(aCol1)
	oEndereco:bLine	:= {||{If(aCol1[oEndereco:nAt,1],oOk,oNo),;
	Iif(aCol1[oEndereco:nAt,2] == 'I',oImp,oProc),;
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
	aCol1[oEndereco:nAt,15]}}

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
	
		If aCols[oEstoque:nAt][2] == 'P'
			MsgInfo("Aten็ใo, registro jแ processado.","Aten็ใo")
			Return
		Else
	
			If aCols[oEstoque:nAt][1]          ///////////////////Desmarcando Array
				nMark_Del := Val(aCols[oEstoque:nAt,2])
	
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
			EndIf
		
		Endif
		
	Else

		nMark_End := 0
		nMark_XXX := 0
		nMark_Est := 0

		For _nX := 1 to Len(aCols)

			If aCols[_nX][2] == 'P'
				Loop
			Endif

			If lMarc

				AchMarca()

				aCols[_nX][1] := lMarc
				oEstoque:DrawSelect()

				nMark_Est++

			Else

				oEstoque:DrawSelect()

				aCols[_nX][1]	:= lMarc

				oEstoque:Refresh()		

			EndIF

		Next _nX

		lMarc := Iif(lMarc,.F.,.T.)

	Endif
	oEstoque:Refresh()
	nlinEst := nLinha 


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

Static Function Seltodos(aCols)

	MarcaEst(2)

Return()

Static Function IMBLTPRC()

Local lMsErroAuto 	:= .F.
Local cCcusto		:= ""

	cPar01 := MV_PAR01
	cPar02 := MV_PAR02
	cPar03 := MV_PAR03
	cPar04 := MV_PAR04
	cPar05 := MV_PAR05
	cPar06 := MV_PAR06
	cPar07 := MV_PAR07
	cPar08 := MV_PAR08


		For nx := 1 to Len(aCols)

				If aCols[nx][1]

					DbSelectArea("SA1")
					DbSetOrder(1)

					If SA1->(DbSeek(xFilial("SA1")+aCols[nx][7]+"01"))
						cCcusto	:= SA1->A1_XCC
					Endif

			       aFINA100 := {     {"E5_FILIAL"      	,xFilial("SE5")            											,Nil},; 
			        				 {"E5_DATA"        	,CTOD(aCols[nx][4])        											,Nil},;
			                         {"E5_MOEDA"       	,"M1"                  												,Nil},;
			                         {"E5_VALOR"       	,aCols[nx][6]													,Nil},;
			                         {"E5_NATUREZ"    	,"10001"		           											,Nil},;
			                         {"E5_BANCO"        ,aCols[nx][13]														,Nil},;
			                         {"E5_AGENCIA"    	,aCols[nx][14]														,Nil},;
			                         {"E5_CONTA"        ,aCols[nx][15]			        									,Nil},;
			                         {"E5_VENCTO"       ,CTOD(aCols[nx][4])		         									,Nil},;
			                         {"E5_DTDISPO"      ,CTOD(aCols[nx][4])		         									,Nil},;
			                         {"E5_DTDIGIT"      ,CTOD(aCols[nx][4])		         									,Nil},;
			                         {"E5_RECPAG"      	,"R"					        									,Nil},;
			                         {"E5_RATEIO"      	,"N"					         									,Nil},;
			                         {"E5_ORIGEM"      	,"FINA100"				         									,Nil},;
			                         {"E5_HISTOR"    	,"BOLETA - MOVIMENTO DE DOAวรO - " + Alltrim(aCols[nx][8]) + " " 	,Nil},;
			                         {"E5_CCUSdTO"    	,cCcusto			    										 	,Nil}}

			                         MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)

			                        If lMsErroAuto
							            MostraErro()
							            Loop
							        Else
										DbSelectArea("SZ5")
										DbSetOrder(1)
										cHora := strtran(aCols[nx][5],":","")
										If SZ5->(DbSeek(DTOS(CTOD(aCols[nx][4]))+aCols[nx][7]+aCols[nx][11]+aCols[nx][3]+cHora+cValtoChar(aCols[nx][6])))
											RecLock( "SZ5", .F. )
											SZ5->Z5_STATUS	:= 'P'
											MsUnLock()
										EndiF

									EndIf
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

	   IM06A02G()

Return()

Static Function sValidPerg(cPerg)

	cPerg := PADR(cPerg,10)
	aRegs := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	AADD(aRegs,{cPerg,"01","Data De ?"  	,""	,"", "mv_ch1" ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data At้ ?" 	,""	,"", "mv_ch2" ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Igreja De ?"  	,""	,"", "mv_ch3" ,"C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1BLT",""})
	AADD(aRegs,{cPerg,"04","Igreja At้?"  	,""	,"", "mv_ch4" ,"C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1BLT",""})
	AADD(aRegs,{cPerg,"05","Pastor De ?"  	,""	,"", "mv_ch5" ,"C",11,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA01",""})
	AADD(aRegs,{cPerg,"06","Pastor At้ ?"	,""	,""	,"mv_ch6" ,"C",11,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA01",""})
	AADD(aRegs,{cPerg,"07","Boleta De ?"  	,""	,"", "mv_ch7" ,"C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Boleta At้ ?"	,""	,""	,"mv_ch8" ,"C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ TpHtml   บAutor  ณAlexis Duarte		       บ Data ณ30/09/2016            บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Sele็ใo do relatorio que serแ impresso e enviado via email no modelo HTML บฑฑ
ฑฑบ          ณ                                                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ aHeadRank,aColsRank --> Gera com base nas informa็๕es que estใo na tela.  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TpHtml(aColsRank)

	Local nOpc := 0
	nOpc := SelectRel()

	if nOpc > 0
		if nOpc == 1 
			RelHtmlFIN(aColsRank)			
		Endif
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ SelectRel   บAutor  ณAlexis Duarte		       บ Data ณ03/10/2016    บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Gera็ใo da tela para sele็ใo do relatorio a ser gerado				 บฑฑ
ฑฑบ          ณ Componente utilizado; RadioButton                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Gera com base nas informa็๕es que estใo na tela.                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelectRel()

	Local oGroup1
	Local oRadMenu1
	Local nRadMenu1 := 0
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Relat๓rios Financeiro Boleta Eletr๔nica" FROM 000, 000  TO 230, 440 COLORS 0, 16777215 PIXEL

	@ 005, 003 GROUP oGroup1 TO 094, 220 PROMPT "  Op็๕es Para Gera็ใo  " OF oDlg COLOR 0, 16777215 PIXEL
	@ 017, 009 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "1- Relat๓rio de Registros Importados",;
	"2- Cronograma Diแrio" SIZE 210, 140 OF oDlg COLOR 0, 16777215 PIXEL
	@ 096, 003 BUTTON oButton1 PROMPT "Confimar" SIZE 217, 016 OF oDlg ACTION oDlg:end() PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	Return nRadMenu1

Static Function RelHtmlFIN(aColsImp)

Local cAssunto 	:= "Relat๓rio Financeiro Boleta Eletr๔nica"
Local cHtml 	:= "" 
Local cCss 		:= ""
Local _nHSaida 	:= 0
Local _nBtSaida := 0
//Local cDir 		:= "C:\Relat๓rios\" //Diretorio que sera gravado o arquivo
Local cDir 		:= "C:\Relat๓rios\IMBLT005\" //Diretorio que sera gravado o arquivo
Local cArqHtml 	:= "IMBLT005FIN.html" //Nome do arquivo HTML
Local cData 	:= ""
Local aCols		:= {}
Local aCols5	:= {}
Local nCont		:= 0
Local nContReg	:= 0
Local nScan		:= 0
Local nScan2	:= 0

	_nHSaida := FCREATE(cDir+cArqHtml)
	cHtml := "<script src='C:\Relat๓rios\IM43A01\Chart.js'></script>"
	cHtml += "<style type='text/css'>"
	cHtml += "*{font-family: calibri;}"
	cHtml += ".box {margin: 0px auto;width: 70%;}"
	cHtml += ".box-chart {width: 100%;margin: 0 auto;padding: 10px;}"
	cHtml += "</style>"

	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'><br>"
	cHtml += "	<center>"
	cHtml += 	"<img src='C:\Relat๓rios\IM43A01\logo_full-medium.png' style='width:450' ;=''>"
	cHtml += "	</br>"
	cHtml += "	</br>"
	cHtml += "	</center>"
	cHtml += "		<p><font face='Arial' size='5'><center><strong>Relat๓rio Financeiro Boleta Eletr๔nica</strong></center></font></p>"
	//cHtml += "		<p><font face='Arial' size='4'><center><strong>Periodo De:" + DtoC(MV_PAR05X) +" At้: "+ DtoC(MV_PAR06X) + " </strong></center></font></p>"
	cHtml += "	</td><br>"
	cHtml += "</table><br>"

	// Parโmetros ------------------->>>>
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "	<p><font face='Arial' size='3'><strong>Parโmetros: </strong></left></font><font face='Arial' size='3'><strong>Perํodo de: " + DtoC(MV_PAR01) +" At้: "+ DtoC(MV_PAR02) + " </strong></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"
	_nBtSaida := FWRITE(_nHSaida, (cHtml) )	
		aColsImp := aSort(aColsImp,,,{|x,y| x[4]+x[5] < y[4]+y[5]})
		
	cHtml := "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"

	cHtml += "	<tr>"
	cHtml +="		<td width='10' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='center'><font face='Arial' size='4'><b><center>C๓digo Boleta</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Data/Hora Lan็amento</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Valor</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='30' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Igreja</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Pastor</center></b></font></p>"
	cHtml +="		</td>"
	cHtml += "</tr>"
	cHtml += "<br>"

	_cCor :=	"DFEFFF"
			
	_nBtSaida := FWRITE(_nHSaida, (cHtml) )
	
		For ny := 1 To Len(aColsImp)
			
				cHtml := "	<tr>"
				cHtml += "		<td width='10' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='center'><font face='Arial' size='3'><center>"+ ALLTRIM(aColsImp[ny][3]) + "</center></font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + ALLTRIM(aColsImp[ny][4]) + " - " + ALLTRIM(aColsImp[ny][5]) +"</font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + TRANSFORM(aColsImp[ny][6], '@E 9,999,999.99') +"</font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='30' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='left'><font face='Arial' size='3'><center>"+ ALLTRIM(aColsImp[ny][7]) + " - " + ALLTRIM(aColsImp[ny][8]) + "</center></font></p>"
				cHtml += "   	</td>"
				
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + ALLTRIM(aColsImp[ny][11]) + " - " + ALLTRIM(aColsImp[ny][12]) +"</font></p>"
				cHtml += "   	</td>"

				If _cCor == "DFEFFF" //Tratamento de cores nas linhas
					_cCor := "FFFFFF"
				Else
					_cCor := "DFEFFF"
				EndIf
				
				_nBtSaida := FWRITE(_nHSaida, (cHtml) )

	Next ny

	cHtml := "</table>"
	cHtml += "<br>"	
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "		<p><font face='Arial' size='5'><center><strong></center></font></p>"
	cHtml += "	</td><br>"
	cHtml += "</table><br>"
	
	For nx := 1 to Len (aColsImp) 
		nCont := aScan(aCols,{|x| x[1] == aColsImp[nx][7]})
		If nCont == 0
			AADD(aCols,{aColsImp[nx][7],1})
		Else
			aCols[nCont][2] += aColsImp[nx][6] 
		Endif
	Next

	cHtml += "<div class='box'>"
	cHtml += "<div class='box-chart'>"
	cHtml += "<canvas id='GraficoBarra' style='width:100%;'></canvas>"
	cHtml += "<script type='text/javascript'>"
	cHtml += "var options = {responsive:true};"
	cHtml += "var data = {"

	cLabels := "labels: ["
	for ny := 1 To Len(aCols)
		if ny == Len(aCols)
			cLabels += "'"+ aCols[ny][1] + " - R$ " +"'],"
		else
			cLabels += "'"+ aCols[ny][1] + " - R$ " +"',"
		Endif
	Next ny

	cHtml += cLabels

	cHtml += "datasets: ["
	cHtml += "{"
	cHtml += "label: 'Dados primแrios',"
	cHtml += "fillColor: 'rgba(30,144,255,0.5)',"
	cHtml += "strokeColor: 'rgba(30,144,255,0.8)',"
	cHtml += "highlightFill: 'rgba(30,144,255,0.75)',"
	cHtml += "highlightStroke: 'rgba(30,144,255,1)',"

	cHtml += "data: ["    
	for ny := 1 To Len(aCols)
		if ny == Len(aCols)
			cData += cValtoChar(aCols[ny][2]) +"]"
		else
			cData += cValtoChar(aCols[ny][2]) +","
		Endif
	Next ny

	cHtml += cData

	cHtml += "}]};"

	cHtml += "window.onload = function(){"
	cHtml += "var ctx = document.getElementById('GraficoBarra').getContext('2d');"
	cHtml += "var BarChart = new Chart(ctx).Bar(data, options);"
	cHtml += "}"
	cHtml += "</script>"
	cHtml += "</div>"
	cHtml += "</div>"

	cHtml += "<br>"	
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "		<p><font face='Arial' size='4'><center><strong>Data da Gera็ใo: "+ DtoC(date()) +"  -  Relatorio gerado e Enviado Por: "+ Alltrim(UsrRetName(__cUserId)) +"</strong></center></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"

	_nBtSaida := FWRITE(_nHSaida, (cHtml) )		
	FCLOSE(_nHSaida)
	
	ShellExecute("Open", cDir+cArqHtml, " /k dir", "C:\", 1 )
	
Return
