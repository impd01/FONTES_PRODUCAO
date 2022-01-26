#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"
#include "AP5MAIL.CH"
#include "MSGRAPHI.CH"
#include "report.ch"
#DEFINE CRLF CHR(13)+CHR(10)

Static cHK			:= "&"
Static nAltBot		:= 010
Static nDistPad		:= 002

/*
Funcao      : IM43A01
Objetivos   : Tela de Cadastro de Agendamentos
Autor       : Vinicius Henrique
Data/Hora   : 07/02/2018
*/
User Function IM43A01()

	Local cPerg			:= "IM43A01"
	Private nOpc		:= 1
	Private oScroll
	Private MV_PAR01X	
	Private MV_PAR02X		
	Private MV_PAR03X	
	Private MV_PAR04X	
	Private MV_PAR05X	
	Private MV_PAR06X	
	Private nCont		:= 1
	Private nC			:= 0
	Private oCombo1  	:= "3=Todos"
	Private _cCombo1 	:= "3=Todos"
	Private oCombo2
	Private _cCombo2
	Private oCombo3
	Private _cCombo3
	Private cSolic	:= Space(80)
	Private cTelSol	:= Space(15)
	Private cDescV	:= Space(80)
	Private cOrigem	:= Space(80)
	Private cDestin	:= Space(80)
	Private cSetor	:= ""
	Private cCodVeic	:= Space(08)
	Private aRotina	:=	{{"STR0001", "AxPesqui" , 0 , 1},; //"Pesquisar"
	{"STR0002", "AxVisual" , 0 , 2},;  //"Visualizar"
	{"STR0003", "FC010CON" , 0 , 2},;  //"Consultar"
	{"STR0004", "FC010IMP" , 0 , 4}}   //"Impressao"

	CriaSX1(cPerg)
	If ! Pergunte(cPerg,.T.)
		Return
	Endif
	MV_PAR01X := MV_PAR01
	MV_PAR02X := MV_PAR02
	MV_PAR03X := MV_PAR03
	MV_PAR04X := MV_PAR04
	MV_PAR05X := MV_PAR05
	MV_PAR06X := MV_PAR06
	
	U_DV97A05A()
Return

User Function DV97A05A()

	Local aArea		:= GetArea()

	Private cnmCodTans 	:= ""
	Private cnmtransp 	:= ""
	Private cDepto 		:= ""
	Private dDtInc      := Date()
	Private cHrInc      := Time()
	Private cPSInc      := 0
	Private ccdmot      := Space(06)
	Private cplaca      := Space(08)
	Private cnmmot      := Space(80)
	Private cnmpla      := Space(80)
	Private cObserv     := Space(80)
	Private oArea		:= FWLayer():New()
	Private oMV_PAR01X
	Private oMV_PAR02X
	Private oMV_PAR03X
	Private oMV_PAR04X
	Private oMV_PAR05X
	Private oMV_PAR06X
	Private cCount		:= '1'
	Private cVldDel		:= "AllwaysFalse()"
	Private cVldDelT	:= "AllwaysFalse()"
	Private cVldLOk		:= "AllwaysTrue()"
	Private cVldTOk		:= "AllwaysTrue()"
	Private cFieldOk	:= "AllwaysTrue()"
	Private nStyle		:= GD_UPDATE
	Private aCoord		:= FWGetDialogSize(oMainWnd)
	Private cCadastro	:= "Controle de Agendamentos de Transportes"
	Private aTamObj		:= Array(4)
	Private nTolera		:= SuperGetMV("DV_97C07TO",.F.,5)
	Private cUserPerm	:= SuperGetMV("DV_97A01US",.F.,"vinicius.luiz")
	Private cPermAgen	:= SuperGetMV("DV_97A01AG",.F.,.F.)

	Private oGetRank
	Private aColsRank	:= {}
	Private aCols		:= {}
	Private aHeadRank	:= {}
	Private aCposRank	:= {}
	Private lTrue		:= .T.
	Private lRet		:= .T.

	aAdd(aHeadRank,{" "		 		 ,"Z0_STATUS"		,"@BMP"		,TamSX3("Z0_STATUS") [1] 	,TamSX3("Z0_STATUS") [2]	,	,""	,TamSX3("Z0_STATUS") [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"ID"			 ,"ID"				,"@!"		,4						 	,0	 						,"" ,""	,"N"						,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Sequencia"		 ,"Z0_CODIGO"		,"@!"		,TamSX3("Z0_CODIGO") [1] 	,TamSX3("Z0_CODIGO") [2]	,""	,""	,TamSX3("Z0_CODIGO") [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Data Agenda"	 ,"Z0_DATAINI"		,"@!"		,TamSX3("Z0_DATAINI")[1] 	,TamSX3("Z0_DATAINI")[2]	,""	,""	,TamSX3("Z0_DATAINI")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Hora Agenda"	 ,"Z0_HORAINI"		,"@!"		,TamSX3("Z0_HORAINI")[1] 	,TamSX3("Z0_HORAINI")[2]	,""	,""	,TamSX3("Z0_HORAINI")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Cod. Veiculo"	 ,"Z0_CDVEIC"		,"@!"		,TamSX3("Z0_CDVEIC")  [1] 	,TamSX3("Z0_CDVEIC")  [2]	,""	,""	,TamSX3("Z0_CDVEIC")  [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Placa"	         ,"Z0_PLACA"		,"@!"		,TamSX3("Z0_PLACA")  [1] 	,TamSX3("Z0_PLACA")  [2]	,""	,""	,TamSX3("Z0_PLACA")  [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Veiculo"	     ,"DA3_DESC"		,"@!"		,TamSX3("DA3_DESC")  [1] 	,TamSX3("DA3_DESC")  [2]	,""	,""	,TamSX3("DA3_DESC")  [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Cod Motorista"	 ,"Z0_CDMOTOR"		,"@!"		,TamSX3("Z0_CDMOTOR")[1] 	,TamSX3("Z0_CDMOTOR")[2]	,""	,""	,TamSX3("Z0_CDMOTOR")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Nome Motorista" ,"DA4_NOME"		,"@!"		,TamSX3("DA4_NOME")  [1] 	,TamSX3("DA4_NOME")  [2]	,""	,""	,TamSX3("DA4_NOME")  [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Telefone" 		 ,"DA4_TEL"			,"@!"		,TamSX3("DA4_TEL")  [1] 	,TamSX3("DA4_TEL")  [2]		,""	,""	,TamSX3("DA4_TEL")  [3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Data Realizado" ,"Z0_DATAFIM"		,"@!"		,TamSX3("Z0_DATAFIM")[1] 	,TamSX3("Z0_DATAFIM")[2]	,""	,""	,TamSX3("Z0_DATAFIM")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Hora Realizado" ,"Z0_HORAFIM"		,"@!"		,TamSX3("Z0_HORAFIM")[1] 	,TamSX3("Z0_HORAFIM")[2]	,""	,""	,TamSX3("Z0_HORAFIM")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Origem"		 ,"Z0_ORIGEM"		,"@!"		,TamSX3("Z0_ORIGEM")[1] 	,TamSX3("Z0_ORIGEM")[2]		,""	,""	,TamSX3("Z0_ORIGEM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Destino"		 ,"Z0_DESTINO"		,"@!"		,TamSX3("Z0_DESTINO")[1] 	,TamSX3("Z0_DESTINO")  [2]	,""	,""	,TamSX3("Z0_DESTINO")  [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Solicitante"	 ,"Z0_SOLICIT"		,"@!"		,TamSX3("Z0_SOLICIT")[1] 	,TamSX3("Z0_SOLICIT")[2]	,""	,""	,TamSX3("Z0_SOLICIT")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Telefone"		 ,"Z0_TELSOLI"		,"@!"		,TamSX3("Z0_TELSOLI")[1] 	,TamSX3("Z0_TELSOLI")[2]	,""	,""	,TamSX3("Z0_TELSOLI")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})	
	aAdd(aHeadRank,{"Setor"			 ,"Z0_SETOR"		,"@!"		,20					 		,TamSX3("Z0_SETOR")[2]		,""	,""	,TamSX3("Z0_SETOR")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Observacao"	 ,"Z0_OBSERV"		,"@!"		,TamSX3("Z0_OBSERV") [1] 	,TamSX3("Z0_OBSERV")[2]		,""	,""	,TamSX3("Z0_OBSERV") [3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Data Inclusao"  ,"Z0_DATAINC"		,"@!"		,TamSX3("Z0_DATAINC")[1] 	,TamSX3("Z0_DATAINC")[2]	,""	,""	,TamSX3("Z0_DATAINC")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Hora Inclusao"  ,"Z0_HORAINC"		,"@!"		,TamSX3("Z0_HORAINC")[1] 	,TamSX3("Z0_HORAINC")[2]	,""	,""	,TamSX3("Z0_HORAINC")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})
	aAdd(aHeadRank,{"Usuario"        ,"Z0_USUARIO"		,"@!"		,TamSX3("Z0_USUARIO")[1] 	,TamSX3("Z0_USUARIO")[2]	,""	,""	,TamSX3("Z0_USUARIO")[3]	,""		,""				,""			,""			,			,'V'		,			,			,			})

	DEFINE FONT oFont10    NAME "Arial"	SIZE 0, -10 BOLD
	DEFINE FONT oFont11    NAME "Arial"	SIZE 0, -11 BOLD
	DEFINE FONT oFont13    NAME "Arial"	SIZE 0, -13 BOLD

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cCadastro),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oTela,.F.)

	oArea:AddLine("L01",32,.T.)
	oArea:AddLine("L02",68,.T.)

	oArea:AddCollumn("L01PARA"  , 88,.F.,"L01")
	oArea:AddCollumn("L01BOTO"  , 12,.F.,"L01")
	oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

	oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Par‚metros"							, 100,.F.,.F.,,"L01",)
	oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"FunÁıes"							, 100,.F.,.F.,,"L01",)
	oArea:AddWindow("L01FRET" ,"L01FRET"  ,"Agendamentos"	           			, 100,.F.,.F.,,"L02",)

	oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
	oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
	oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

	SetKey(VK_F1,{||U_Help("IM43A01")})
	SetKey(VK_F2,{||DV97A05L()})

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBoto:nClientWidth)
	aTamObj[4] := (oPainBoto:nClientHeight)

	oScroll 		:= TScrollBox():New(oPainBoto,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.F.,.F.)
	oScroll:Align 	:= CONTROL_ALIGN_ALLCLIENT

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
	oBotGera := tButton():New(aTamObj[1],aTamObj[2],"Atualizar",oScroll,{||  LJMsgRun('Atualizando Dados','Aguarde, Atualizando Dados',{||GeraRank(2)  })},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotAgen := tButton():New(aTamObj[1],aTamObj[2],"Criar Agendamento",oScroll,{||  LJMsgRun('Criando...','Aguarde, Criando...',{||U_DV97A06I()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotExclu:= tButton():New(aTamObj[1],aTamObj[2],"Alterar Agendamento",oScroll,{||  LJMsgRun('Alterando...','Aguarde, Alterando...',{||U_DV97A06A(ALLTRIM(aColsRank[oGetRank:nAt,3]))})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotExclu:= tButton():New(aTamObj[1],aTamObj[2],"Cancelar Agendamento",oScroll,{||  LJMsgRun('Cancelando...','Aguarde, Cancelando...',{||U_DV97A06X(aColsRank[oGetRank:nAt,3])})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotExclu:= tButton():New(aTamObj[1],aTamObj[2],"Gerar Excel",oScroll,{||  LJMsgRun('Exportando...','Aguarde, Exportando...',{||GeraExcel(aColsRank)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotExclu:= tButton():New(aTamObj[1],aTamObj[2],"Imprimir",oScroll,{||  LJMsgRun('Imprimindo...','Aguarde, Imprimindo...',{||U_IM43R01(aColsRank,MV_PAR05X,MV_PAR06X)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotExclu:= tButton():New(aTamObj[1],aTamObj[2],"RelatÛrio/Grafico",oScroll,{||  LJMsgRun('Imprimindo...','Aguarde, Imprimindo...',{||TpHtml(aColsRank)})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/})

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Fechar",oScroll,{||oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| })	

	@  05,  00  Say  oSay Prompt 'Data De?'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  04,  70  MSGet oMV_PAR05X Var MV_PAR05X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 ""		Of oPainPara

	@  15,  00  Say  oSay Prompt 'Data Ate?'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  14,  70  MSGet oMV_PAR06X Var MV_PAR06X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 ""		Of oPainPara

	@  25,  00  Say  oSay Prompt 'Veiculo De?'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  24,  70  MSGet oMV_PAR03X Var MV_PAR03X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "DA3_01"		Of oPainPara

	@  35,  00  Say  oSay Prompt 'Veiculo Ate?'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  34,  70  MSGet oMV_PAR04X Var MV_PAR04X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "DA3_01"		Of oPainPara

	@  45,  00  Say  oSay Prompt 'Motorista De?'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  44,  70  MSGet oMV_PAR01X Var MV_PAR01X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "DA4_01"	Of oPainPara

	@  55,  00  Say  oSay Prompt 'Motorista AtÈ?'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel
	@  54,  70  MSGet oMV_PAR02X Var MV_PAR02X		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "DA4_01"	Of oPainPara

	@  05,  160  Say  oSay Prompt 'Status:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	oCombo1 :=TComboBox():New( 04,  190,{|u|if(PCount()>0, _cCombo1:=u, _cCombo1)},{"A=Agendamento Em Aberto ","X=PrÈ Agendamento",;
    "F=Agendamento Finalizado", "C=Agendamento Cancelado", "M=Agendamento Alterado", "P=Agendamento Andamento","T=Todos"},;
    085, 05, oPainPara, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@  25,  160  Say  oSay Prompt 'Setor:'			FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainPara Pixel

	oCombo3 :=TComboBox():New( 24,  190,{|u|if(PCount()>0, _cCombo3:=u, _cCombo3)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
	"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
	"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros","T=Todos"},;
    085, 05, oPainPara, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@  50,  190 Say  oSay Prompt 'Help F1'		FONT oFont11 COLOR CLR_BLUE Size  50, 280 Of oPainPara Pixel
	@  50,  230 Say  oSay Prompt 'Legenda F2'	FONT oFont11 COLOR CLR_BLUE Size  50, 280 Of oPainPara Pixel
	oArea:setWinTitle("L01FRET" ,"L01FRET","InformaÁıes do Motorista","L02" )

	_cCombo1 := "T"

	_cCombo3 := "T"

	MV_PAR05X := Date()
	MV_PAR06X := Date()

	oTela:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Consultando Banco De Dados...","Aguarde...",{ || GeraRank(1)})})

	RestArea(aArea)

Return(.T.)

/*
Funcao      : GeraRank
Objetivos   : Consulta Banco de Dados e cria Alias
Autor       : Vinicius Henrique
Data/Hora   : 07/02/2018
*/

Static Function GeraRank(nOpc)

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local cSetor	:= ""
	Local cTpCalc 	:= ""
	Local cBasCal 	:= ""
	Local nVlrCalc 	:= 0
	Local nCusto	:= 0
	Local nPrazo	:= 0
	Local cTpMovimto := ""

	Local nTotCal 	:= 0 //Variavel utilizada para c·lculo do Frete negociado + ICMS
	
	nC			:= 0

	cQuery := " SELECT * FROM " + RetSQLName("SZ0") + " Z0 "										+ CRLF
	cQuery += " WHERE Z0_FILIAL = '"+xFilial("SZ0") + "' "											+ CRLF
	cQuery += " AND Z0_CDMOTOR BETWEEN '" + MV_PAR01X + "' AND '" + MV_PAR02X + "' "				+ CRLF
	cQuery += " AND Z0_CDVEIC BETWEEN '" + MV_PAR03X + "' AND '" + MV_PAR04X + "' "					+ CRLF	
	cQuery += " AND Z0_DATAINI BETWEEN '" + DtoS(MV_PAR05X) + "' AND '" + DtoS(MV_PAR06X) + "' "	+ CRLF
	If _cCombo1 <> 'T'
		cQuery += " AND Z0_STATUS = '" + _cCombo1 +  "' "											+ CRLF
	Endif
	If _cCombo3 <> 'T'
		cQuery += " AND Z0_SETOR = '" + _cCombo3 +  "' "											+ CRLF
	Endif
	cQuery += " AND Z0.D_E_L_E_T_ = ' ' "															+ CRLF
	cQuery += " ORDER BY Z0_CODIGO "																+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	aColsRank := {}

	(cAlias)->(DbGoTop())

		Do While !(cAlias)->(Eof())
			cLeg_1 := IiF((cAlias)->Z0_STATUS = 'A',LoadBitmap( GetResources(), "BR_VERDE" ),;
			IiF((cAlias)->Z0_STATUS = 'F',LoadBitmap( GetResources(), "BR_AZUL"),;
			IiF((cAlias)->Z0_STATUS = 'P',LoadBitmap( GetResources(), "BR_AMARELO"),;
			IiF((cAlias)->Z0_STATUS = 'C',LoadBitmap( GetResources(), "BR_VERMELHO"),;
			IiF((cAlias)->Z0_STATUS = 'M',LoadBitmap( GetResources(), "BR_LARANJA"),;
			IiF((cAlias)->Z0_STATUS = 'X',LoadBitmap( GetResources(), "BR_PRETO" ),LoadBitmap( GetResources(), "BR_LARANJA" )))))))

			DbSelectArea("SZ0")
			SZ0->(DbSetOrder(1))
			SZ0->(DbSeek(xFilial("SZ0") + (cAlias)->Z0_CODIGO))

			DbSelectArea("DA4")
			DA4->(DbSetOrder(1))
			DA4->(DbSeek(xFilial("DA4") + (cAlias)->Z0_CDMOTOR))

			DbSelectArea("DA3")
			DA3->(DbSetOrder(1))
			DA3->(DbSeek(xFilial("DA3") + (cAlias)->Z0_CDVEIC))
/*
			oCombo2 :=TComboBox():New( 109,  050,{|u|if(PCount()>0, _cCombo2:=u, _cCombo2)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
			"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
			"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros"},;
		    065, 05, oTelaInc, ,,,,,.T.,,,.F.,{||.T.},.T.,,)
*/

			If (cAlias)->Z0_SETOR == "01"
				cSetor := "Livraria"
			Elseif (cAlias)->Z0_SETOR == "02"
				cSetor := "Som"
			Elseif (cAlias)->Z0_SETOR == "03"
				cSetor := "Igreja"
			Elseif (cAlias)->Z0_SETOR == "04"
				cSetor := "Central"
			Elseif (cAlias)->Z0_SETOR == "05"
				cSetor := "Amas"
			Elseif (cAlias)->Z0_SETOR == "06"
				cSetor := "Financeiro"
			Elseif (cAlias)->Z0_SETOR == "07"
				cSetor := "GS"
			Elseif (cAlias)->Z0_SETOR == "08"
				cSetor := "WS"
			Elseif (cAlias)->Z0_SETOR == "09"
				cSetor := "SESMT"
			Elseif (cAlias)->Z0_SETOR == "10"
				cSetor := "Paises"
			Elseif (cAlias)->Z0_SETOR == "11"
				cSetor := "Almoxarifado"
			Elseif (cAlias)->Z0_SETOR == "12"
				cSetor := "Redes"
			Elseif (cAlias)->Z0_SETOR == "13"
				cSetor := "Juliana"
			Elseif (cAlias)->Z0_SETOR == "14"
				cSetor := "TV"
			Elseif (cAlias)->Z0_SETOR == "15"
				cSetor := "JurÌdico"
			Elseif (cAlias)->Z0_SETOR == "16"
				cSetor := "RH"
			Elseif (cAlias)->Z0_SETOR == "17"
				cSetor := "Controladoria"
			Elseif (cAlias)->Z0_SETOR == "18"
				cSetor := "Banda"
			Elseif (cAlias)->Z0_SETOR == "19"
				cSetor := "Compras"
			Elseif (cAlias)->Z0_SETOR == "20"
				cSetor := "Engenharia"
			Elseif (cAlias)->Z0_SETOR == "21"
				cSetor := "LocaÁ„o"
			Elseif (cAlias)->Z0_SETOR == "22"
				cSetor := "Contabilidade"
			Elseif (cAlias)->Z0_SETOR == "23"
				cSetor := "Outros"
			Endif
	
			nC++	
			aAdd(aColsRank,{cLeg_1,;
			STRZERO(nC,4),;
			(cAlias)->Z0_CODIGO ,;
			DTOC(STOD((cAlias)->Z0_DATAINI)),;
			(cAlias)->Z0_HORAINI,;
			(cAlias)->Z0_CDVEIC,;
			(cAlias)->Z0_PLACA,;
			DA3->DA3_DESC,;	
			(cAlias)->Z0_CDMOTOR,;
			DA4->DA4_NOME,;
			DA4->DA4_TEL,;
			DTOC(STOD((cAlias)->Z0_DATAFIM)),;			
			(cAlias)->Z0_HORAFIM,;
			(cAlias)->Z0_ORIGEM,;
			(cAlias)->Z0_DESTINO,;
			(cAlias)->Z0_SOLICIT,;
			(cAlias)->Z0_TELSOLI,;
			cSetor,;
			(cAlias)->Z0_OBSERV,;
			DTOC(STOD((cAlias)->Z0_DATAINC)),;
			(cAlias)->Z0_HORAINC,;
			(cAlias)->Z0_USUARIO,;		
			.F.}) 
			(cAlias)->(DbSkip())
			lRet := .T.
		EndDo

	If nOpc == 1
		oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],oPainRank:nClientWidth/2,oPainRank:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue","",,/*1*/,9999,cFieldOk,cVldDelT,cVldDel,oPainRank,@aHeadRank,@aColsRank,{|| U_S97C05TRA(aColsRank[oGetRank:nAt,9],aColsRank[oGetRank:nAt,10])}/*uChange*/)
		oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGetRank:oBrowse:brClicked  := {|| LJMsgRun("Classificando...","Aguarde...",{|| ClasGrid(@aColsRank,oGetRank:oBrowse:ColPos,@oGetRank,@oTela) } ) }
		oGetRank:oBrowse:bLDblClick := {|| LJMsgRun("Abrindo InformaÁıes","Aguarde...",{|| U_DV97A06V(ALLTRIM(aColsRank[oGetRank:nAt,3])) } )}
	Endif
	
	aColsRank := aSort(aColsRank,,,{|x,y| x[4]+x[5] < y[4]+y[5]})

	oGetRank:SetArray(aColsRank)
	oGetRank:Refresh()
	oGetRank:oBrowse:SetFocus()
	
	(cAlias)->(DbCloseArea())

Return(.T.)

/*
Funcao      : CriaSX1
Objetivos   : Cria Perguntes
Autor       : Vinicius Henrique
Data/Hora   : 07/02/2018
*/
Static Function CriaSX1(cPerg1)
	cPerg1      := PADR(cPerg1,10)
	aRegs       := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	If !Dbseek(cPerg1)
		AADD(aRegs,{cPerg1,"01","Transp. De?"				,""	,"", "mv_ch1" ,"C",06,0,0,"G","","mv_par01X","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
		AADD(aRegs,{cPerg1,"02","Transp. Ate?"				,""	,"", "mv_ch2" ,"C",06,0,0,"G","","mv_par02X","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
		AADD(aRegs,{cPerg1,"03","Data De?"					,""	,"", "mv_ch3" ,"D",09,0,0,"G","","mv_par03X","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg1,"04","Data Ate?"					,""	,"", "mv_ch4" ,"D",09,0,0,"G","","mv_par04X","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	EndIf

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

/*
Funcao      : DV97A05L
Objetivos   : Tela de Legendas
*/
Static Function DV97A05L()
	Local ny       := 0
	Local nx       := 0
	Local aSit := {;
	{ "BR_VERDE"   ,"Agendamento Em Aberto "},;
	{ "BR_AZUL"    ,"Agendamento Finalizado"},;
	{ "BR_AMARELO" ,"Agendamento Andamento "},;
	{ "BR_VERMELHO","Agendamento Cancelado "},;
	{ "BR_LARANJA" ,"Agendamento Alterado  "},;
	{ "BR_PRETO"   ,"PrÈ Agendamento  "}}

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

/////////////////////////////////////////////
// ClassificaÁ„o do grid
/////////////////////////////////////////////

Static Function ClasGrid(aCols,nCol,oGetDados,oTela)
	Local nxt
	if nCol > 0 .and. !Empty(aCols) .and. len(aCols) > 1

		if aCols[1,nCol] > aCols[len(aCols),nCol]
			aCols := aSort(aCols,,,{|x,y| x[nCol] < y[nCol] })
		else
			aCols := aSort(aCols,,,{|x,y| x[nCol] > y[nCol] })
		endif
		oGetDados:SetArray(aCols)
		oGetDados:Refresh()
		oTela:Refresh()
	endif
	
	nReord := 1	//GERA NOVO CONTADOR DE REGISTRO
	aColsRank := aEval(oGetRank:aCols,{|x|x[2] := STRZERO(nReord++,4)},,len(oGetRank:aCols))
	oGetRank:Refresh()
	
Return	

User Function S97C05TRA(cCodMotr, cNomeMotr)

	Local nLinha:= oGetRank:oBrowse:nAt
	DbSelectArea("DA4")
	DA4->(DbSetOrder(1))
	DA4->(DbSeek(xFilial("DA4") + cCodMotr))

	If ALLTRIM(cCodMotr) == ""
	oArea:setWinTitle("L01FRET" ,"L01FRET","InformaÁıes do Motorista" ,"L02" )
	Else
	oArea:setWinTitle("L01FRET" ,"L01FRET","Motorista: " + cCodMotr + " | "+ ALLTRIM(cNomeMotr) + " - Tel:" + DA4->DA4_TEL,"L02" )
	Endif
	
Return

User Function DV97A06I()
           
	Local nLinha:= oGetRank:oBrowse:nAt
	Local cTitulo := "Inclus„o de Agendamento"
	Local ctipo   := "I"
	Local cTipoMov := ""

	cdoc := '000000000'
	cCodVeic	:= Space(08)
	cSolic		:= Space(80)
	cTelSol		:= Space(15)
	cDescV		:= Space(80)
	cOrigem		:= Space(80)
	cDestin		:= Space(80)
	cSetor		:= ""	
	dDtInc      := Date() +1
	cHrInc      := "99:99:99"
	ccdmot      := Space(06)
	cplaca      := Space(08)
	cnmmot      := Space(80)
	cnmpla      := Space(80)
	cObserv     := Space(80)

	oTelaInc := tDialog():New(100,100,415,630,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)

	@  05, 005 Say  oSay Prompt "Cod. Veiculo:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel 
	@  20, 005 Say  oSay Prompt "Desc. VeÌculo:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  20, 150 Say  oSay Prompt "Placa:"		 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 005 Say  oSay Prompt "Data Agendada:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 110 Say  oSay Prompt "Hora:"          	FONT oFont11 COLOR CLR_BLUE Size  80, 08 Of oTelaInc Pixel
	@  50, 005 Say  oSay Prompt "Motorista:    " 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  65, 005 Say  oSay Prompt "Origem:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  80, 005 Say  oSay Prompt "Destino:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  95, 005 Say  oSay Prompt "Solicitante:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  95, 150 Say  oSay Prompt "Tel:"   			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 110, 005 Say  oSay Prompt "Setor:"   			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 125, 005 Say  oSay Prompt "ObservaÁoes:"   	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel

	@  04, 050 MSGet oTxt_1	Var cCodVeic		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA3"	            	Of oTelaInc
	@  19, 050 MSGet oTxt_2	Var cDescV			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            				Of oTelaInc
	@  19, 170 MSGet oTxt_2	Var cplaca			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            				Of oTelaInc
	@  34, 050 MSGet oTxt_3	Var dDtInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T.                        	Of oTelaInc
	@  34, 135 MSGet oTxt_4	Var cHrInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  025, 06 When .T. Picture "99:99:99"     	Of oTelaInc
	@  49, 050 MSGet oTxt_6	Var ccdmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA4"		        	Of oTelaInc
	@  49, 110 MSGet oTxt_7	Var cnmmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 06 When .F.        		        	Of oTelaInc
	@  64, 050 MSGet oTxt_8	Var cOrigem			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 				        	Of oTelaInc
	@  79, 050 MSGet oTxt_9	Var cDestin			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 		                	Of oTelaInc
	@  94, 050 MSGet oTxt_9	Var cSolic			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .T. 		                	Of oTelaInc
	@  94, 170 MSGet oTxt_11 Var cTelSol		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .T. Picture "(99) 99999-9999"	Of oTelaInc

	oCombo2 :=TComboBox():New( 109,  050,{|u|if(PCount()>0, _cCombo2:=u, _cCombo2)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
	"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
	"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros"},;
    065, 05, oTelaInc, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@ 124, 050 MSGet oTxt_10 Var cObserv		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T.                        Of oTelaInc

	oBotUpd := tButton():New(139,170,"Confirmar",oTelaInc,{||IIf(LEN(ALLTRIM(cHrInc)) < 8 ,ApMsgStop("Informe Foramato Hora Correto (HHMMSS)!"),DV97A06G(cDoc,dDtInc,cHrInc,cTipo) ) },40,10,,,,.T.,,,,)
	oBotFim := tButton():New(139,215,"Cancelar",oTelaInc,{|| oTelaInc:End()},40,10,,,,.T.,,,,)

	oTelaInc:Activate(,,,.T.,/*valid*/,,)

Return

User Function DV97A06A(cDoc)

	Local nLinha  := oGetRank:oBrowse:nAt
	Local cTitulo := "AlteraÁao de Agendamento"
	Local ctipo   := "A"
	Local cTipoMovA := ""

	IF Len(aColsRank) <= 0
		RETURN
	ENDIF
	if nlinha < 1 
		nLinha:= 1
	Endif       

	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	SZ0->(DbSeek(cDoc))

	IF SZ0->Z0_STATUS $  "F/C/M/P"
		MSGINFO ("Agendamento n„o pode ser alterado. ","AtenÁ„o")
		Return
	Endif  

	DbSelectArea("DA4")
	DA4->(DbSetOrder(1))
	DA4->(DbSeek(xFilial("DA4") + SZ0->Z0_CDMOTOR))

	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	DA3->(DbSeek(xFilial("DA3") + SZ0->Z0_CDVEIC))

	cCodVeic	:= SZ0->Z0_CDVEIC
	cDescV		:= DA3->DA3_DESC
	dDtInc  	:= SZ0->Z0_DATAINI
	cHRInc  	:= SZ0->Z0_HORAINI
	ccdmot  	:= SZ0->Z0_CDMOTOR
	cnmmot  	:= DA4->DA4_NOME
	cplaca  	:= SZ0->Z0_PLACA
	cnmpla  	:= DA3->DA3_DESC
	cObserv		:= SZ0->Z0_OBSERV
	cOrigem		:= SZ0->Z0_ORIGEM
	cDestin		:= SZ0->Z0_DESTINO
	cSolic		:= SZ0->Z0_SOLICIT
	cSetor		:= SZ0->Z0_SETOR
	cTelSol		:= SZ0->Z0_TELSOLI
	
	oTelaInc := tDialog():New(100,100,415,630,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)

	@  05, 005 Say  oSay Prompt "Cod. Veiculo:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel 
	@  20, 005 Say  oSay Prompt "Desc. VeÌculo:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  20, 150 Say  oSay Prompt "Placa:"		 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 005 Say  oSay Prompt "Data Agendada:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 110 Say  oSay Prompt "Hora:"          	FONT oFont11 COLOR CLR_BLUE Size  80, 08 Of oTelaInc Pixel
	@  50, 005 Say  oSay Prompt "Motorista:    " 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  65, 005 Say  oSay Prompt "Origem:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  80, 005 Say  oSay Prompt "Destino:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  95, 005 Say  oSay Prompt "Solicitante:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 110, 005 Say  oSay Prompt "Setor:"   			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 125, 005 Say  oSay Prompt "ObservaÁoes:"   	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel

	@  04, 050 MSGet oTxt_1	Var cCodVeic		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA3"	            Of oTelaInc
	@  19, 050 MSGet oTxt_2	Var cDescV			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  19, 170 MSGet oTxt_2	Var cplaca			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  34, 050 MSGet oTxt_3	Var dDtInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T.                        Of oTelaInc
	@  34, 135 MSGet oTxt_4	Var cHrInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  025, 06 When .T. Picture "99:99:99"     Of oTelaInc
	@  49, 050 MSGet oTxt_6	Var ccdmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA4"		        Of oTelaInc
	@  49, 110 MSGet oTxt_7	Var cnmmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 06 When .F.        		        Of oTelaInc
	@  64, 050 MSGet oTxt_8	Var cOrigem			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 				        Of oTelaInc
	@  79, 050 MSGet oTxt_9	Var cDestin			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 		                Of oTelaInc
	@  94, 050 MSGet oTxt_9	Var cSolic			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 		                Of oTelaInc

	oCombo2 :=TComboBox():New( 109,  050,{|u|if(PCount()>0, _cCombo2:=u, _cCombo2)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
	"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
	"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros"},;
    065, 05, oTelaInc, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@ 124, 050 MSGet oTxt_10 Var cObserv		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T.                        Of oTelaInc

	oBotUpd := tButton():New(139,170,"Confirmar",oTelaInc,{||IIf(LEN(ALLTRIM(cHrInc)) < 8 ,ApMsgStop("Informe Foramato Hora Correto (HHMMSS)!"),DV97A06G(cDoc,dDtInc,cHrInc,cTipo) ) },40,10,,,,.T.,,,,)
	oBotFim := tButton():New(139,215,"Cancelar",oTelaInc,{|| oTelaInc:End()},40,10,,,,.T.,,,,)

	oTelaInc:Activate(,,,.T.,/*valid*/,,)

Return

User Function DV97A06V(cDoc)

	Local nLinha  := oGetRank:oBrowse:nAt
	Local cTitulo := "VisualizaÁ„o de Agendamento"
	Local ctipo   := "V"
	Local cTipoMovA := ""

	IF Len(aColsRank) <= 0
		RETURN
	ENDIF
	if nlinha < 1 
		nLinha:= 1
	Endif       

	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	SZ0->(DbSeek(cDoc))

	DbSelectArea("DA4")
	DA4->(DbSetOrder(1))
	DA4->(DbSeek(xFilial("DA4") + SZ0->Z0_CDMOTOR))

	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	DA3->(DbSeek(xFilial("DA3") + SZ0->Z0_CDVEIC))

	cCodVeic	:= SZ0->Z0_CDVEIC
	cDescV		:= DA3->DA3_DESC
	dDtInc  	:= SZ0->Z0_DATAINI
	cHRInc  	:= SZ0->Z0_HORAINI
	ccdmot  	:= SZ0->Z0_CDMOTOR
	cnmmot  	:= DA4->DA4_NOME
	cplaca  	:= SZ0->Z0_PLACA
	cnmpla  	:= DA3->DA3_DESC
	cObserv		:= SZ0->Z0_OBSERV
	cOrigem		:= SZ0->Z0_ORIGEM
	cDestin		:= SZ0->Z0_DESTINO
	cSolic		:= SZ0->Z0_SOLICIT
	cSetor		:= SZ0->Z0_SETOR
	cTelSol		:= SZ0->Z0_TELSOLI
	
	oTelaInc := tDialog():New(100,100,415,630,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)

	@  05, 005 Say  oSay Prompt "Cod. Veiculo:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel 
	@  20, 005 Say  oSay Prompt "Desc. VeÌculo:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  20, 150 Say  oSay Prompt "Placa:"		 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 005 Say  oSay Prompt "Data Agendada:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 110 Say  oSay Prompt "Hora:"          	FONT oFont11 COLOR CLR_BLUE Size  80, 08 Of oTelaInc Pixel
	@  50, 005 Say  oSay Prompt "Motorista:    " 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  65, 005 Say  oSay Prompt "Origem:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  80, 005 Say  oSay Prompt "Destino:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  95, 005 Say  oSay Prompt "Solicitante:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 110, 005 Say  oSay Prompt "Setor:"   			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 125, 005 Say  oSay Prompt "ObservaÁoes:"   	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel

	@  04, 050 MSGet oTxt_1	Var cCodVeic		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .F. F3 "DA3"	            Of oTelaInc
	@  19, 050 MSGet oTxt_2	Var cDescV			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  19, 170 MSGet oTxt_2	Var cplaca			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  34, 050 MSGet oTxt_3	Var dDtInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .F.                        Of oTelaInc
	@  34, 135 MSGet oTxt_4	Var cHrInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  025, 06 When .F. Picture "99:99:99"     Of oTelaInc
	@  49, 050 MSGet oTxt_6	Var ccdmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .F. F3 "DA4"		        Of oTelaInc
	@  49, 110 MSGet oTxt_7	Var cnmmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 06 When .F.        		        Of oTelaInc
	@  64, 050 MSGet oTxt_8	Var cOrigem			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .F. 				        Of oTelaInc
	@  79, 050 MSGet oTxt_9	Var cDestin			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .F. 		                Of oTelaInc
	@  94, 050 MSGet oTxt_9	Var cSolic			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .F. 		                Of oTelaInc

	oCombo2 :=TComboBox():New( 109,  050,{|u|if(PCount()>0, _cCombo2:=u, _cCombo2)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
	"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
	"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros"},;
    065, 05, oTelaInc, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@ 124, 050 MSGet oTxt_10 Var cObserv		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .F.                        Of oTelaInc

	oBotFim := tButton():New(139,215,"Fechar",oTelaInc,{|| oTelaInc:End()},40,10,,,,.T.,,,,)

	oTelaInc:Activate(,,,.T.,/*valid*/,,)

Return

User Function DV97A06X(cDoc)

	Local nLinha  := oGetRank:oBrowse:nAt
	Local cTitulo := "Cancelamento de Agendamento"
	Local ctipo   := "C"
	Local cTipoMovC := ""

	IF Len(aColsRank) <= 0
		RETURN
	ENDIF
	if nlinha < 1 
		nLinha:= 1
	Endif       

	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	SZ0->(DbSeek(cDoc))

	IF SZ0->Z0_STATUS $  "F/C/M/P"
		MSGINFO ("Agendamento nao pode ser Alterado. !!!")
		Return
	Endif  

	DbSelectArea("DA4")
	DA4->(DbSetOrder(1))
	DA4->(DbSeek(xFilial("DA4") + SZ0->Z0_CDMOTOR))

	DbSelectArea("DA3")
	DA3->(DbSetOrder(1))
	DA3->(DbSeek(xFilial("DA3") + SZ0->Z0_CDVEIC))

	cCodVeic   	:= SZ0->Z0_CDVEIC
	cDescV		:= DA3->DA3_DESC
	dDtInc  	:= SZ0->Z0_DATAINI
	cHRInc  	:= SZ0->Z0_HORAINI
	ccdmot  	:= SZ0->Z0_CDMOTOR
	cnmmot  	:= DA4->DA4_NOME
	cplaca  	:= SZ0->Z0_PLACA
	cnmpla  	:= DA3->DA3_DESC
	cObserv		:= SZ0->Z0_OBSERV
	cOrigem		:= SZ0->Z0_ORIGEM
	cDestin		:= SZ0->Z0_DESTINO
	cSolic		:= SZ0->Z0_SOLICIT
	cSetor		:= SZ0->Z0_SETOR
	cTelSol		:= SZ0->Z0_TELSOLI

	oTelaInc := tDialog():New(100,100,415,630,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)

	@  05, 005 Say  oSay Prompt "Cod. Veiculo:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel 
	@  20, 005 Say  oSay Prompt "Desc. VeÌculo:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  20, 150 Say  oSay Prompt "Placa:"		 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 005 Say  oSay Prompt "Data Agendada:" 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  35, 110 Say  oSay Prompt "Hora:"          	FONT oFont11 COLOR CLR_BLUE Size  80, 08 Of oTelaInc Pixel
	@  50, 005 Say  oSay Prompt "Motorista:    " 	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  65, 005 Say  oSay Prompt "Origem:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  80, 005 Say  oSay Prompt "Destino:" 			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@  95, 005 Say  oSay Prompt "Solicitante:"		FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 110, 005 Say  oSay Prompt "Setor:"   			FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel
	@ 125, 005 Say  oSay Prompt "ObservaÁoes:"   	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel

	@  04, 050 MSGet oTxt_1	Var cCodVeic		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA3"	            Of oTelaInc
	@  19, 050 MSGet oTxt_2	Var cDescV			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  19, 170 MSGet oTxt_2	Var cplaca			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  090, 06 When .F.            			Of oTelaInc
	@  34, 050 MSGet oTxt_3	Var dDtInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T.                        Of oTelaInc
	@  34, 135 MSGet oTxt_4	Var cHrInc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  025, 06 When .T. Picture "99:99:99"     Of oTelaInc
	@  49, 050 MSGet oTxt_6	Var ccdmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 06 When .T. F3 "DA4"		        Of oTelaInc
	@  49, 110 MSGet oTxt_7	Var cnmmot			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 06 When .F.        		        Of oTelaInc
	@  64, 050 MSGet oTxt_8	Var cOrigem			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 				        Of oTelaInc
	@  79, 050 MSGet oTxt_9	Var cDestin			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 		                Of oTelaInc
	@  94, 050 MSGet oTxt_9	Var cSolic			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T. 		                Of oTelaInc

	oCombo2 :=TComboBox():New( 109,  050,{|u|if(PCount()>0, _cCombo2:=u, _cCombo2)},{"01=Livraria","02=Som","03=Igreja","04=Central","05=Amas","06=Financeiro",;
	"07=GS","08=WS","09=SESMT","10=Paises","11=Almoxarifado","12=Redes","13=Juliana","14=TV","15=JurÌdico","16=RH","17=Controladoria","18=Banda","19=Compras",;
	"20=Engenharia","21=LocaÁ„o","22=Contabilidade","23=Outros"},;
    065, 05, oTelaInc, ,,,,,.T.,,,.F.,{||.T.},.T.,,)

	@ 124, 050 MSGet oTxt_10 Var cObserv		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  210, 06 When .T.                        Of oTelaInc

	oBotUpd := tButton():New(139,170,"Confirmar",oTelaInc,{||IIf(LEN(ALLTRIM(cHrInc)) < 8 ,ApMsgStop("Informe Foramato Hora Correto (HHMMSS)!"),DV97A06G(cDoc,dDtInc,cHrInc,cTipo) ) },40,10,,,,.T.,,,,)
	oBotFim := tButton():New(139,215,"Cancelar",oTelaInc,{|| oTelaInc:End()},40,10,,,,.T.,,,,)

	oTelaInc:Activate(,,,.T.,/*valid*/,,)

Return

////////////////////////////////////////////////
//GRAVA OBSERVA«√O NA BASE DE DADOS
////////////////////////////////////////////////

Static Function DV97A06G(cDoc,dDtInc,cHrInc,cTipo)

	Local _aArea	:= GetArea()
	Local _MAXCODIGO:= "000000001"
	Local cAlias	:= GetNextAlias()
	Local _cQuery   :=	""	
	Local cDiaSem	:=  cValtoChar(ALLTRIM(DiaSemana(dDtInc)))
	Local cQuery	:= ""
	Local cAlias2	:= GetNextAlias()
	

	If cTipo = 'A' .or. cTipo = 'I'
		IF dDtInc < DDATABASE
			msginfo ("Agendamento Inferior a Data de Sistema.")
			oTelaInc:End()
			gerarank(2) 
			Return 
		Endif

	Endif

	If cTipo == 'I'

		cplaca := Alltrim(cplaca)
		cplaca := STRTRAN(cplaca,"-","")

		If (SUBSTR(cplaca,7,1) == '1' .or. SUBSTR(cplaca,7,1) == '2') .and. cDiaSem == 'Segunda'
			If !MsgYesNo("AtenÁ„o, este veÌculo est· sendo agendado em data do RODÕZIO, deseja prosseguir?", "AtenÁ„o")
				Return
			Endif
		Elseif (SUBSTR(cplaca,7,1) == '3' .or. SUBSTR(cplaca,7,1) == '4')  .and. cDiaSem == 'TerÁa'
			If !MsgYesNo("AtenÁ„o, este veÌculo est· sendo agendado em data do RODÕZIO, deseja prosseguir?", "AtenÁ„o")
				Return
			Endif
		Elseif (SUBSTR(cplaca,7,1) == '5' .or. SUBSTR(cplaca,7,1) == '6')  .and. cDiaSem == 'Quarta'
			If !MsgYesNo("AtenÁ„o, este veÌculo est· sendo agendado em data do RODÕZIO, deseja prosseguir?", "AtenÁ„o")
				Return
			Endif
		Elseif (SUBSTR(cplaca,7,1) == '7' .or. SUBSTR(cplaca,7,1) == '8')  .and. cDiaSem == 'Quinta'
			If !MsgYesNo("AtenÁ„o, este veÌculo est· sendo agendado em data do RODÕZIO, deseja prosseguir?", "AtenÁ„o")
				Return
			Endif
		Elseif (SUBSTR(cplaca,7,1) == '9' .or. SUBSTR(cplaca,7,1) == '0')  .and. cDiaSem == 'Sexta'
			If !MsgYesNo("AtenÁ„o, este veÌculo est· sendo agendado em data do RODÕZIO, deseja prosseguir?", "AtenÁ„o")
				Return
			Endif
		Endif
	Endif

	_cQuery := " SELECT MAX(Z0_CODIGO) AS MAXCODIGO FROM " + RetSqlName("SZ0") + " Z0 "			
	_cQuery += " WHERE Z0_FILIAL         = '" + xFilial("SZ0") + "' "
	_cQuery += " AND   Z0.D_E_L_E_T_     = ' ' "

	TCQUERY _cQuery NEW ALIAS (cAlias)
	(cAlias)->(DbGoTop())
	Do While ! (cAlias)->(Eof())
		_MAXCODIGO := (cAlias)->MAXCODIGO
		_MAXCODIGO := Soma1(_MAXCODIGO,9)
		(cAlias)->(DbSkip())
	EndDo
	(cAlias)->(DbCloseArea())

	If cTipo = 'A'
		DbSelectArea("SZ0")
		DbSetOrder(1)                                    	
		If SZ0->(DbSeek(cDoc))
			RecLock("SZ0",.F.)
				If SZ0->Z0_STATUS == 'X'
					SZ0->Z0_DATAINI := dDtInc
					SZ0->Z0_HORAINI := cHrInc
					SZ0->Z0_CDMOTOR := ccdmot 
					SZ0->Z0_PLACA   := cplaca 
					SZ0->Z0_OBSERV  := cObserv
					SZ0->Z0_USUARIO := cUserName
					SZ0->Z0_DATAINC := DDATABASE
					SZ0->Z0_HORAINC := TIME()
					SZ0->Z0_ORIGEM	:= cOrigem
					SZ0->Z0_DESTINO	:= cDestin
					SZ0->Z0_SOLICIT	:= cSolic
					SZ0->Z0_SETOR	:= _cCombo2
					SZ0->Z0_CDVEIC	:= cCodVeic
					SZ0->Z0_TELSOLI	:= cTelSol
					If Empty(Alltrim(ccdmot)) .Or.  Empty(Alltrim(cCodVeic))
						SZ0->Z0_STATUS := 'X'
					Else
						SZ0->Z0_STATUS	:= 'A'
					Endif
					MsUnlock("SZ0")
					oTelaInc:End()
					gerarank(2)
					Return
				Else
					SZ0->Z0_STATUS := "M"
				Endif
			MsUnlock("SZ0")
		Endif
	
	Endif

	If cTipo = 'C'
		DbSelectArea("SZ0")
		DbSetOrder(1)                                    	
		If SZ0->(DbSeek(cDoc))
			RecLock("SZ0",.F.)
			SZ0->Z0_STATUS := "C"
			MsUnlock("SZ0")
		Endif
		oTelaInc:End()
		gerarank(2)	
		Return			
	Endif

	DbSelectArea("SZ0")
	DbSetOrder(1)                                    	
	If SZ0->(DbSeek(_MAXCODIGO))
		RecLock("SZ0",.F.)
	Else
		RecLock("SZ0",.T.)
	EndIf
	If Empty(Alltrim(ccdmot)) .Or.  Empty(Alltrim(cCodVeic))
		If MsgYesNo("AtenÁ„o, CÛdigo(s) do Motorista e/ou CÛdigo do VeÌculo n„o informado(s), deseja incluir um PrÈ Agendamento?","AtenÁ„o")
			SZ0->Z0_STATUS  := "X"
			SZ0->Z0_TPMOVTO := "X"
		Else
			Return
		Endif
	Else
		SZ0->Z0_STATUS  := "A"
		SZ0->Z0_TPMOVTO := "A"		
	Endif
	SZ0->Z0_CODIGO  := _MAXCODIGO
	SZ0->Z0_DATAINI := dDtInc
	SZ0->Z0_HORAINI := cHrInc
	SZ0->Z0_PESOAGE := cPsInc
	SZ0->Z0_CDMOTOR := ccdmot 
	SZ0->Z0_PLACA   := cplaca 
	SZ0->Z0_OBSERV  := cObserv
	SZ0->Z0_USUARIO := cUserName
	SZ0->Z0_DATAINC := DDATABASE
	SZ0->Z0_HORAINC := TIME()
	SZ0->Z0_ORIGEM	:= cOrigem
	SZ0->Z0_DESTINO	:= cDestin
	SZ0->Z0_SOLICIT	:= cSolic
	SZ0->Z0_SETOR	:= _cCombo2
	SZ0->Z0_CDVEIC	:= cCodVeic
	SZ0->Z0_TELSOLI	:= cTelSol
	MsUnlock("SZ0")

	oTelaInc:End()
	gerarank(2)

Return

Static Function GeraExcel(aCols)

	Local aExcel := {} 

		AADD(aExcel,{"Hora","Placa","Veiculo","Motorista","Telefone","Solicitante","Setor","Origem","Destino","ObservaÁ„o"})

		For nx := 1 to Len(aCols)
				AADD(aExcel,{aCols[nx,05],aCols[nx,07],aCols[nx,08],aCols[nx,10],aCols[nx,11],aCols[nx,16],aCols[nx,17],aCols[nx,14],aCols[nx,15],;
				aCols[nx,18]})
		Next

		DlgToExcel({{"ARRAY", "", {}, aExcel}})

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ TpHtml   ∫Autor  ≥Alexis Duarte		       ∫ Data ≥30/09/2016            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ SeleÁ„o do relatorio que ser· impresso e enviado via email no modelo HTML ∫±±
±±∫          ≥                                                                           ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametros≥ aHeadRank,aColsRank --> Gera com base nas informaÁıes que est„o na tela.  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function TpHtml(aColsRank)

	Local nOpc := 0
	nOpc := U_SelectRel()

	if nOpc > 0
		if nOpc == 1 
			RelHtmlSET(aColsRank)			
		Elseif nOpc == 2
			RelHtmlCRN(aColsRank)				
		Endif
	Endif

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ SelectRel   ∫Autor  ≥Alexis Duarte		       ∫ Data ≥03/10/2016    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ GeraÁ„o da tela para seleÁ„o do relatorio a ser gerado				 ∫±±
±±∫          ≥ Componente utilizado; RadioButton                                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametros≥ Gera com base nas informaÁıes que est„o na tela.                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function SelectRel()

	Local oGroup1
	Local oRadMenu1
	Local nRadMenu1 := 0
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "RelatÛrios de Controle de Agendamentos" FROM 000, 000  TO 230, 440 COLORS 0, 16777215 PIXEL

	@ 005, 003 GROUP oGroup1 TO 094, 220 PROMPT "  OpÁıes Para GeraÁ„o  " OF oDlg COLOR 0, 16777215 PIXEL
	@ 017, 009 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "1- RelatÛrio de Agendamento X Setores",;
	"2- Cronograma Di·rio" SIZE 210, 140 OF oDlg COLOR 0, 16777215 PIXEL
	@ 096, 003 BUTTON oButton1 PROMPT "Confimar" SIZE 217, 016 OF oDlg ACTION oDlg:end() PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	Return nRadMenu1

Static Function RelHtmlSET(aColsImp)

//Local cAccount 	:= GetMV("MV_EMCONTA")
//Local cPassword := GetMV("MV_EMSENHA")  
//Local cServer 	:= GetMV("MV_RELSERV")
//Local cEmailde 	:= cAccount
//Local cDestEmail := GetMV("DV_97C02HT",,"vinicius.luiz@dovac.com.br")
Local cAssunto 	:= "RelatÛrio de Controle de Agendamentos"
Local cHtml 	:= "" 
Local cCss 		:= ""
Local _nHSaida 	:= 0
Local _nBtSaida := 0
//Local cDir 		:= "C:\RelatÛrios\" //Diretorio que sera gravado o arquivo
Local cDir 		:= "C:\RelatÛrios\IM43A01\" //Diretorio que sera gravado o arquivo
Local cArqHtml 	:= "IM43A01SET.html" //Nome do arquivo HTML
Local cData 	:= ""
Local aCols		:= {}
Local aCols5	:= {}
Local nCont		:= 0
Local nContReg	:= 0
Local nScan		:= 0
Local nScan2	:= 0

	_nHSaida := FCREATE(cDir+cArqHtml)
	cHtml := "<script src='C:\RelatÛrios\IM43A01\Chart.js'></script>"
	cHtml += "<style type='text/css'>"
	cHtml += "*{font-family: calibri;}"
	cHtml += ".box {margin: 0px auto;width: 70%;}"
	cHtml += ".box-chart {width: 100%;margin: 0 auto;padding: 10px;}"
	cHtml += "</style>"

	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'><br>"
	cHtml += "	<center>"
	cHtml += 	"<img src='C:\RelatÛrios\IM43A01\logo_full-medium.png' style='width:450' ;=''>"
	cHtml += "	</br>"
	cHtml += "	</br>"
	cHtml += "	</center>"
	cHtml += "		<p><font face='Arial' size='5'><center><strong>Controle de Agendamentos</strong></center></font></p>"
	//cHtml += "		<p><font face='Arial' size='4'><center><strong>Periodo De:" + DtoC(MV_PAR05X) +" AtÈ: "+ DtoC(MV_PAR06X) + " </strong></center></font></p>"
	cHtml += "	</td><br>"
	cHtml += "</table><br>"

	// Par‚metros ------------------->>>>
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "	<p><font face='Arial' size='3'><strong>Par‚metros: </strong></left></font><font face='Arial' size='3'><strong>PerÌodo de: " + DtoC(MV_PAR05X) +" AtÈ: "+ DtoC(MV_PAR06X) + " </strong></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"
	_nBtSaida := FWRITE(_nHSaida, (cHtml) )	
		aColsImp := aSort(aColsImp,,,{|x,y| x[4]+x[5] < y[4]+y[5]})
		
	cHtml := "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"

	cHtml += "	<tr>"
	cHtml +="		<td width='10' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='center'><font face='Arial' size='4'><b><center>CÛdigo</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Data/Hora Agendamento</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>VeÌculo</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='30' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Motorista</center></b></font></p>"
	cHtml +="		</td>"
		
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Solicitante</center></b></font></p>"
	cHtml +="		</td>"
	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Setor</center></b></font></p>"
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
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + ALLTRIM(aColsImp[ny][7]) + " - " + ALLTRIM(aColsImp[ny][8]) +"</font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='30' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='left'><font face='Arial' size='3'><center>"+ ALLTRIM(aColsImp[ny][10]) + "</center></font></p>"
				cHtml += "   	</td>"
				
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + UPPER(ALLTRIM(aColsImp[ny][16])) +"</font></p>"
				cHtml += "   	</td>"

				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='3'><center>" + UPPER(ALLTRIM(aColsImp[ny][18])) + "</font></p>"
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
		nCont := aScan(aCols,{|x| x[1] == aColsImp[nx][18]})
		If nCont == 0
			AADD(aCols,{aColsImp[nx][18],1})
		Else
			aCols[nCont][2]++
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
			cLabels += "'"+ aCols[ny][1] +"'],"
		else
			cLabels += "'"+ aCols[ny][1] +"',"
		Endif
	Next ny

	cHtml += cLabels

	cHtml += "datasets: ["
	cHtml += "{"
	cHtml += "label: 'Dados prim·rios',"
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
	cHtml += "		<p><font face='Arial' size='4'><center><strong>Data da GeraÁ„o: "+ DtoC(date()) +"  -  Relatorio gerado e Enviado Por: "+ Alltrim(UsrRetName(__cUserId)) +"</strong></center></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"

	_nBtSaida := FWRITE(_nHSaida, (cHtml) )		
	FCLOSE(_nHSaida)
	
	ShellExecute("Open", cDir+cArqHtml, " /k dir", "C:\", 1 )
	
Return

Static Function RelHtmlCRN(aColsImp)

//Local cAccount 	:= GetMV("MV_EMCONTA")
//Local cPassword := GetMV("MV_EMSENHA")  
//Local cServer 	:= GetMV("MV_RELSERV")
//Local cEmailde 	:= cAccount
//Local cDestEmail := GetMV("DV_97C02HT",,"vinicius.luiz@dovac.com.br")
Local cAssunto 	:= "RelatÛrio de Controle de Agendamentos"
Local cHtml 	:= "" 
Local cCss 		:= ""
Local _nHSaida 	:= 0
Local _nBtSaida := 0
//Local cDir 		:= "C:\RelatÛrios\" //Diretorio que sera gravado o arquivo
Local cDir 		:= "C:\RelatÛrios\IM43A01\" //Diretorio que sera gravado o arquivo
Local cArqHtml 	:= "IM43A01CRN.html" //Nome do arquivo HTML
Local cData 	:= ""
Local aCols		:= {}
Local aCols5	:= {}
Local nCont		:= 0
Local nContReg	:= 0
Local nScan		:= 0
Local nScan2	:= 0

	_nHSaida := FCREATE(cDir+cArqHtml)
	cHtml := "<script src='C:\RelatÛrios\IM43A01\Chart.js'></script>"
	cHtml += "<style type='text/css'>"
	cHtml += "*{font-family: calibri;}"
	cHtml += ".box {margin: 0px auto;width: 70%;}"
	cHtml += ".box-chart {width: 100%;margin: 0 auto;padding: 10px;}"
	cHtml += "</style>"

	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'><br>"
	cHtml += "	<center>"
	cHtml += 	"<img src='C:\RelatÛrios\IM43A01\logo_full-medium.png' style='width:450' ;=''>"
	cHtml += "	</br>"
	cHtml += "	</br>"
	cHtml += "	</center>"
	cHtml += "		<p><font face='Arial' size='5'><center><strong>Cronograma de Agendamentos</strong></center></font></p>"
	//cHtml += "		<p><font face='Arial' size='4'><center><strong>Periodo De:" + DtoC(MV_PAR05X) +" AtÈ: "+ DtoC(MV_PAR06X) + " </strong></center></font></p>"
	cHtml += "	</td><br>"
	cHtml += "</table><br>"

	// Par‚metros ------------------->>>>
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "	<p><font face='Arial' size='3'><strong>Par‚metros: </strong></left></font><font face='Arial' size='3'><strong>PerÌodo de: " + DtoC(MV_PAR05X) +" AtÈ: "+ DtoC(MV_PAR06X) + " </strong></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"
	_nBtSaida := FWRITE(_nHSaida, (cHtml) )	
		aColsImp := aSort(aColsImp,,,{|x,y| x[4]+x[5] < y[4]+y[5]})
		
	cHtml := "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"

	cHtml += "	<tr>"
	cHtml +="		<td width='10' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='center'><font face='Arial' size='4'><b><center>Data/Horario</center></b></font></p>"
	cHtml +="		</td>"

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Carro</center></b></font></p>"
	cHtml +="		</td>"

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Motorista</center></b></font></p>"
	cHtml +="		</td>"

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Solicitante</center></b></font></p>"
	cHtml +="		</td>"

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Setor</center></b></font></p>"
	cHtml +="		</td>"		

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Origem</center></b></font></p>"
	cHtml +="		</td>"

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>Destino</center></b></font></p>"
	cHtml +="		</td>"		

	cHtml +="		<td width='15' bgcolor='#87CEFF' height='19'>"
	cHtml +="			<p align='left'><font face='Arial' size='4'><b><center>ObservaÁıes</center></b></font></p>"
	cHtml +="		</td>"		

	cHtml += "</tr>"
	cHtml += "<br>"

	_cCor :=	"DFEFFF"

	_nBtSaida := FWRITE(_nHSaida, (cHtml) )
	
		For ny := 1 To Len(aColsImp)
			
				cHtml := "	<tr>"
				cHtml += "		<td width='10' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='center'><font face='Arial' size='2'><center>" + ALLTRIM(aColsImp[ny][4]) + " - " + ALLTRIM(aColsImp[ny][5]) + "</center></font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + ALLTRIM(aColsImp[ny][7]) + " - " + ALLTRIM(aColsImp[ny][8]) +"</font></p>"
				cHtml += "   	</td>"
		
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + ALLTRIM(aColsImp[ny][10]) + " - " + ALLTRIM(aColsImp[ny][11]) +"</font></p>"
				cHtml += "   	</td>"
						
				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + UPPER(ALLTRIM(aColsImp[ny][16])) + " - " + ALLTRIM(aColsImp[ny][17]) +"</font></p>"
				cHtml += "   	</td>"

				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + UPPER(ALLTRIM(aColsImp[ny][18])) + "</font></p>"
				cHtml += "   	</td>"

				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + UPPER(ALLTRIM(aColsImp[ny][14])) +"</font></p>"
				cHtml += "   	</td>"

				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + UPPER(ALLTRIM(aColsImp[ny][15])) + "</font></p>"
				cHtml += "   	</td>"

				cHtml += "		<td width='15' bgcolor='#"+_cCor+"' height='19'>"
				cHtml += "     		<p align='right'><font face='Arial' size='2'><center>" + UPPER(ALLTRIM(aColsImp[ny][19])) + "</font></p>"
				cHtml += "   	</td>"

				If _cCor == "DFEFFF" //Tratamento de cores nas linhas
					_cCor := "FFFFFF"
				Else
					_cCor := "DFEFFF"
				EndIf

				_nBtSaida := FWRITE(_nHSaida, (cHtml) )

	Next ny

	cHtml := "<br>"	
	cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='100%'>"
	cHtml += "	<td width='20' bgcolor='FFFFFF' height='19'>"
	cHtml += "		<p><font face='Arial' size='4'><center><strong>Data da GeraÁ„o: "+ DtoC(date()) +"  -  Relatorio gerado e Enviado Por: "+ Alltrim(UsrRetName(__cUserId)) +"</strong></center></font></p>"
	cHtml += "	</td>"
	cHtml += "</table>"

	_nBtSaida := FWRITE(_nHSaida, (cHtml) )		
	FCLOSE(_nHSaida)

	ShellExecute("Open", cDir+cArqHtml, " /k dir", "C:\", 1 )
	
Return
	