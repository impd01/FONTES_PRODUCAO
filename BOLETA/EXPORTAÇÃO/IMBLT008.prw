#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002

User Function IMBLT008()

	Local aArea				:= GetArea()
	Local oArea				:= FWLayer():New()
	Local cPerg				:= "IMBLT008"

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

	AADD(aCols, {.F.,"","","","","","","","","","","",""})
	AADD(aCols1, {.F.,"","","","","","","","","","","",""})

	sValidPerg(cPerg)

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD
	DEFINE FONT oFont13    NAME "Arial"	SIZE 0, -14 

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi("Registros Boleta Eletrônica"),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",35,.T.)
	oArea:AddLine("L02",65,.T.)

	oArea:AddCollumn("L01PARA"  , 85,.F.,"L01")
//	oArea:AddCollumn("L01TOTA"  , 25,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 15,.F.,"L01")
	oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

	oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Parâmetros"									, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
//	oArea:AddWindow("L01TOTA" ,"L01TOTA"  ,"Totais"										, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Funções" 									, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Registros de Alterações de Igrejas"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)		

	oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
//	oPainTota  := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA"  ,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
	oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

	SetKey(VK_F2,{||DV97A05L()})

	oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,cVldLOk ,cVldTOk,        ,aCposRank,0      ,9999,cFieldOk,cVldDelT ,cVldDel,oPainRank,@aHeadRank,@aColsRank,/*uChange*/)

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Atualizar Dados",oPainBoto,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||IM06A02G()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotProc := tButton():New(aTamObj[1],aTamObj[2],"Gerar TXT",oPainBoto,{|| LJMsgRun('Processando Dados','Aguarde, Processando Dados',{||IMBLTPRC()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	@  07,   00 Say oSay1 Prompt 'Igreja De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  19,   00 Say oSay1 Prompt 'Igreja Até:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  31,   00 Say oSay1 Prompt 'C. Custo De:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel	
	@  43,   00 Say oSay1 Prompt 'C. Custo Até:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	@  05,  55 	MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1IGR" Of oPainPara
	@  17,  55 	MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1IGR" Of oPainPara
	@  29,  55 	MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTT"	Of oPainPara
	@  41,  55 	MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "CTT"	Of oPainPara

	@  07, 130 CHECKBOX oCheckBOX VAR lCheckBOX PROMPT "Marcar/Desmarcar Todos" FONT oFont11 COLOR CLR_BLUE Pixel SIZE  109, 05 When .T.	Of oPainPara 
	
	@ 	0,   0 LISTBOX oEstoque		FIELDS HEADER "","Código","Descrição","Endereço","Numero","Bairro","Municipio","Descrição","Estado","CEP","Email","Igreja Superior","Status" FIELDSIZES 15,15,15,15,15,15,30,40,30,35,30,15,30 SIZE oPainRank:nClientWidth/2,oPainRank:nClientHeight/2 OF oPainRank

	@  19, 130 Say  oSay Prompt 'Legenda F2'	FONT oFont11 COLOR CLR_BLUE Size  50, 280 Of oPainPara Pixel

	ShowEst()

	oEstoque:bLDblClick := {|| aCols[oEstoque:nAt][1] := !aCols[oEstoque:nAt][1], aCols:DrawSelect() }

	oCheckBOX:bchange   := {||Seltodos(oGetRank:aCols) }	

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Processando...","Aguarde...",{ || IM06A02G()})})

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IM06A02G   ºAutor  ³       º Data ³    º±±
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
	Local cEnd		:= ""
	Local cStatus	:= ""
	Local cTipo		:= ""
	Local cXstatus	:= ""

	aColsRank 		:= {}
	aColsTotal 		:= {}
	aCols	  		:= {}

	lCheckBOX 		:= .F.
	
	nValor := 0
	
	_cQuery	:= "SELECT * FROM SA1010 SA1															" + CRLF
	_cQuery	+= "WHERE																				" + CRLF
	_cQuery	+= "SA1.D_E_L_E_T_ = ' '																" + CRLF
	_cQuery	+= "AND SA1.A1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'					" + CRLF
	_cQuery	+= "AND SA1.A1_XCC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'		" + CRLF

	MEMOWRITE("IMBLT008.SQL",_cQuery)

	TCQUERY _cQuery NEW ALIAS (cAlias)

	Do While !(cAlias)->(Eof()) 
			
		If (cAlias)->Z6_XSTATUS == 'S'
			cStatus := 'ATIVA'
		Elseif (cAlias)->Z6_XSTATUS == 'N'
			cStatus := 'INATIVA'
		Endif
				
		nCont++

		AADD(aCols,{.F.,; 
		(cAlias)->A1_COD,;
		(cAlias)->A1_NOME,;
		(cAlias)->A1_END,;
		(cAlias)->A1_XNUMERO,;
		(cAlias)->A1_BAIRRO,;
		(cAlias)->A1_COD_MUN,;
		(cAlias)->A1_MUN,;
		(cAlias)->A1_EST,;
		(cAlias)->A1_CEP,;
		(cAlias)->A1_XEMAIL,;
		(cAlias)->A1_XSUP,;
		(cAlias)->A1_XSTATUS})			

		(cAlias)->(DbSkip())


	EndDo

	(cAlias)->(DbCloseArea())  
	
	nRegs := nCont

	ShowEst()
	oEstoque:Refresh()
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
	aCols[oEstoque:nAt,13]}}

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
	aCol1[oEndereco:nAt,13]}}

Return

//+--------------------------------------------------------------------+
//| Rotina | MarcaEst 	| Autor | Vinicius Henrique	 |Data| 18.09.2017 |
//+--------------------------------------------------------------------+
//| Descr. | Função para carregar o aTransf.						   |
//+--------------------------------------------------------------------+
//| Uso    | SIGAEST - Local									 	   |
//+--------------------------------------------------------------------+
Static Function MarcaEst(nOpc)

	Private nx

	///////////////////////////////////////////////////////////////////

	If nOpc == 1
	
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

				aCols[_nX][1]	:= lMarc

				oEstoque:Refresh()		

			EndIF

		Next _nX

		lMarc := Iif(lMarc,.F.,.T.)

	Endif
	oEstoque:Refresh()
	nlinEst := nx 

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

	Local 	cArqIg   	:= "Cad_Igrejas"+ "_" +DTOS(Date())+"_" + StrTran(Time(),":","")+".txt"
	Local 	cTipo		:= " "
	Local   cStatus		:= ""

	Private cDirIg
	Private nHandle
	
	cPar01 := MV_PAR01
	cPar02 := MV_PAR02
	cPar03 := MV_PAR03
	cPar04 := MV_PAR04

	cDirIg := cGetFile( '*.*' , 'Arquivos', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

	nHandle 	:= FCreate(cDirIg+cArqIg)
	
		For nx := 1 to Len(aCols)

				If aCols[nx][1]

						If aCols[nx][17] = 'ALTERAÇÃO'
							cTipo := 'A'
						Elseif aCols[nx][17] = 'INCLUSÃO'
							cTipo := 'I'
						Endif

						If nHandle < 0
							MsgAlert("Erro durante criação do arquivo.")
						Else

							FWrite(nHandle, cTipo + "      " + aCols[nx][5] + aCols[nx][6] + aCols[nx][7] + aCols[nx][8] + ;
							aCols[nx][9] + aCols[nx][10] + aCols[nx][11] + aCols[nx][12] + aCols[nx][13] + aCols[nx][15] + aCols[nx][16] + aCols[nx][19] + CRLF)  

							_cQuery := " UPDATE "+RetSqlName("SZ6")
							_cQuery += " SET Z6_SITU = 'G' "
							_cQuery += " WHERE D_E_L_E_T_ = ' ' "
							_cQuery += " AND R_E_C_N_O_ = "+cValtoChar(aCols[nx][20])+" "

							If TcSqlExec(_cQuery) < 0
								alert(TcSqlError())
							Else
								TcSqlExec( "COMMIT" )				
							Endif

						EndIf

				Endif

	   Next nx

	   FClose(nHandle)

	   MV_PAR01 := cPar01
	   MV_PAR02 := cPar02
	   MV_PAR03 := cPar03
	   MV_PAR04 := cPar04

	   MsgInfo("Arquivo '" + cArqIg + "' gerado e gravado no caminho: '" + cDirIg + "'")

	   IM06A02G()

Return()

Static Function sValidPerg(cPerg)

	cPerg := PADR(cPerg,10)
	aRegs := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	AADD(aRegs,{cPerg,"01","Igreja De ?"  	,""	,"", "mv_ch1" ,"C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1BLT",""})
	AADD(aRegs,{cPerg,"02","Igreja Até?"  	,""	,"", "mv_ch2" ,"C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1BLT",""})
	AADD(aRegs,{cPerg,"03","C. Custo De ?"  ,""	,"", "mv_ch3" ,"D",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	AADD(aRegs,{cPerg,"04","C. Custo Até ?" ,""	,"", "mv_ch4" ,"D",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})

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

Static Function DV97A05L()

	Local ny       := 0
	Local nx       := 0
	Local aSit := {;
	{ "BR_VERDE"   ,"Arquivo TXT Gerado"},;
	{ "BR_VERMELHO","Registro Processado"}}

	Local nXSize := 14
	Local aBmp := {}
	////de 220 para 150
	oDlgLeg := TDialog():New(000,000,170,220,OemToAnsi("Legendas"),,,,,,,,oMainWnd,.T.)

	oGrpLg1 := TGroup():New(000,002,070,111,'Status',oDlgLeg,CLR_BLUE,,.T.)
	aBmp := array(Len(aSit))
	For nX := 1 to Len(aSit)
		@ nx*10,10 BITMAP aBmp[nx] RESNAME aSit[nx][1] of oGrpLg1 SIZE 20,20 NOBORDER WHEN .F. PIXEL
		@ nx*10,(nXSize/2) + 13 SAY If((ny+=1)==ny,aSit[ny][2]+If(ny==Len(aSit),If((ny:=0)==ny,"",""),""),"") of oGrpLg1 PIXEL
	Next nX
	ny := 0
	oDlgLeg:Activate(,,,.T.,/*valid*/,,,)
	
Return

