#INCLUDE "protheus.ch"
#INCLUDE "dbtree.ch"
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

User Function TesteCad()

	Private aButtons	:= {}
	Private cAlias 		:= "ZA1"
	Private cCadastro	:= "Cadastro de Visitante"
	Private aRotina		:= {}
	Private aCores		:= {}
	Private nOpc		:= 0
	Private cCdVste		:= ""
	Private cNmVste		:= ""
	Private cCod

	aCores := 	 {{'ZA1_STSVST =="A"' , 'BR_VERMELHO'}}

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	
	aRotina := {	{"Pesquisar",		'PesqBrw',		0,1,0,.F.},;
					{"Visualizar",		'AxVisual',		0,2,0,Nil},; //Rotina de alteracao foi trocada pela 'Saida do Visitante'
					{"Incluir",			'U_IncVisit',	0,3,0,Nil},; //Todas as Rotinas foram trocadas por 'Visita'
					{"Visita",			'U_Visita',		0,4,0,Nil},;
					{"Alterar",			'AxAltera',		0,6,0,Nil},;
					{"Excluir",     	'AxDeleta',		0,7,0,.F.} }

	mBrowse( 6,1,22,75,cAlias,,,,,6,aCores)

Return

User Function Visita()

	Local cTitulo := "Documento Visitante"
	Local oTxt_1

	Private lVisita		:= .T. //.T. = Abertura de Visita | .F. = Encerramento de Visita
	Private oTelaInc

	DEFINE FONT oFont11    NAME "Courier New"	SIZE 0, 15 BOLD

	cDoc	:= Space(11)

	oTelaInc := tDialog():New(100,100,200,630,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)

	@  05, 005 Say  oSay Prompt "Documento:"	FONT oFont11 COLOR CLR_BLUE Size  90, 08 Of oTelaInc Pixel 

	@  04, 050 MSGet oTxt_1	Var cDoc			FONT oFont11 COLOR CLR_BLUE Pixel SIZE  070, 08 When .T. Of oTelaInc

	oBotUpd := tButton():New(04,170,"Confirmar",oTelaInc,{|| Confirma(cDoc) },40,10,,,,.T.,,,,)
	oBotFim := tButton():New(04,215,"Cancelar",oTelaInc,{|| oTelaInc:End()},40,10,,,,.T.,,,,)

	oTelaInc:Activate(,,,.T.,/*valid*/,,)

Return

Static Function Confirma(cCpf)

Local aParam 	:= {}
Local cAlias	:= GetNextAlias() //Gera proximo numero de visitante
Local cQuery	:= ""
Local lStatus	:= .F. //.T. = Visita em aberto || .F. = Visita Encerrada

Private cCadastro := "Cadastro de Visitas" // título da tela   

	lVisita := .T.

	aAdd( aParam,  {|| U_Before() } )  //antes da abertura
	aAdd( aParam,  {|| U_tdOK() } )  //ao clicar no botao ok
	aAdd( aParam,  {|| U_Transaction() } )  //durante a transacao
	aAdd( aParam,  {|| U_Fim() } )       //termino da transacao                                                                  

	If !CGC(cCpf)
		Alert("CPF inválido","TOTVS")
		Return(.F.)
	Endif

	DbSelectArea("ZA1")
	DbSetOrder(2)                                    	

	If ZA1->(DbSeek(cCpf))

	cCdVste		:= ZA1->ZA1_COD
	cNmVste		:= ZA1->ZA1_NOME

		cQuery := " SELECT * FROM " + RetSqlName("ZA2")			+ CRLF 
		cQuery += " WHERE D_E_L_E_T_ = ' ' "					+ CRLF 
		cQuery += " AND ZA2_VSTNTE = '" + ZA1->ZA1_COD + "' "	+ CRLF 
		cQuery += " ORDER BY R_E_C_N_O_ DESC "					+ CRLF 

		TCQUERY cQuery NEW ALIAS (cAlias)

		(cAlias)->(dbGoTop())

		DbSelectArea("ZA2")

		DbSetOrder(1)
		
		If ZA2->(DbSeek(xFilial("ZA2")+(cAlias)->ZA2_COD))

			If ZA2->ZA2_STSVST == 'A'
			
			If MsgYesNo("Já existe uma visita em aberto para este CPF, deseja encerra-la?","TOTVS")
				
				lVisita := .F.
				
				AxAltera("ZA2",ZA2->(Recno()),4,,{"ZA2_OBS"},,,"U_tdOK()","U_Transaction","U_Before()",aButtons,aParam,,,.T.,,,,,)
			
			Endif
			
			Else

			    AxInclui("ZA2",ZA2->(Recno()),3,,"U_Before",,"U_tdOK()",.F.,"U_Transaction",aButtons,aParam,,,.T.,,,,,)

			Endif

		Else

			AxInclui("ZA2",ZA2->(Recno()),3,, "U_Before",, "U_tdOK()", .F., "U_Transaction", aButtons, aParam,,,.T.,,,,,)

		Endif

	Else
	
		If MsgYesNo("Não existe nenhum visitante cadastrado com o CPF informado, deseja realizar o cadastro?","TOTVS")

			IncVisit()
		
		Endif
	
	Endif

Return

Static Function EncVst()

Return

User Function Before()

  	IF !lVisita
		M->ZA2_SAIDA	:=	Date()
		M->ZA2_HORSAI	:=	Time()  		
  	Endif

	M->ZA2_VSTNTE := cCdVste
	M->ZA2_DESCVS := cNmVste

Return

User function tdOK()	

//	MsgAlert("Clicou botao ok")

Return .T.    

User function Transaction()	

//	MsgAlert("Chamada durante transacao")

Return .T.                              

User function Fim()	

	If lVisita
		RecLock("ZA2",.F.)
			ZA2->ZA2_STSVST	:=	'A'
		MsUnlock("ZA2")
		
	DbSelectArea("ZA1")
	DbSetOrder(1)                                    	

	If ZA1->(DbSeek(M->ZA2_VSTNTE))
		RecLock("ZA1",.F.)
			ZA1->ZA1_STSVST := "A"
		MsUnlock("ZA1")	
	Endif
	
	DbCloseArea()
		
	Else
		RecLock("ZA2",.F.)
			ZA2->ZA2_STSVST	:=	'E'
			ZA2->ZA2_SAIDA	:=	Date()
			ZA2->ZA2_HORSAI	:=	Time()
		MsUnlock("ZA2")
		
	DbSelectArea("ZA1")
	DbSetOrder(1)                                    	

	If ZA1->(DbSeek(M->ZA2_VSTNTE))
		RecLock("ZA1",.F.)
			ZA1->ZA1_STSVST := "E"
		MsUnlock("ZA1")	
	Endif
	
	DbCloseArea()

	MsgInfo("Visita encerrada com sucesso.","TOTVS")
		
	Endif
	
	oTelaInc:End()
	
Return .T.

User Function IncVisit()

Local aParam2 	:= {}

Private cCadastro 	:= "Inclusão de Visitante"
Private aButtons	:= {}

	AADD(aButtons,{'Tirar Foto', {|| U_zTstWeb(M->ZA1_COD)}, 'Tirar Foto', 'Tirar Foto'})

//	aAdd( aParam2,  {|| U_Before2() } )  //antes da abertura
//	aAdd( aParam2,  {|| U_tdOK() } )  //ao clicar no botao ok
//	aAdd( aParam2,  {|| U_Transaction() } )  //durante a transacao
//	aAdd( aParam2,  {|| U_Fim() } )       //termino da transacao                                                                  

	DbSelectArea("ZA1")
	DbSetOrder(1)

//	U_NextVisit()

	AxInclui("ZA1",2,3,/* <aAcho>*/, /*<cFunc>*/, /*<aCpos>*/,/* <cTudoOk>*/,/* <lF3>*/, /*"U_Before2()"*/, aButtons, aParam2, /*<aAuto>*/, /*<lVirtual>*/,.T.)

Return

User Function Before2()

	M->ZA1_CGC	:=	cCpf

Return .T.

User Function NextVisit()

Local cAlias	:= GetNextAlias() //Gera proximo numero de visitante
Local cQuery	:= ""

//	If INCLUI
		cQuery := " SELECT MAX(ZA1_COD) AS MAXCODIGO FROM " + RetSqlName("ZA1")	+ CRLF 
		cQuery += " WHERE D_E_L_E_T_ = ' ' "			 						+ CRLF 
	
		TCQUERY cQuery NEW ALIAS (cAlias)
	
		(cAlias)->(dbGoTop())
	
		cCod := Val((cAlias)->MAXCODIGO) +1
		
		cCod := STRZERO(cCod,6)
		
		M->ZA1_COD := cCod
//	Endif

Return(cCod)

User Function ESPnome()

Return("Controle de Visitantes")
