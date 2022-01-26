#INCLUDE "Totvs.ch"


/*/{Protheus.doc} u_uLogClass
Funcao para Compilacao da Classe

@author Jorge Heitor
@since 24/05/2017
@version 1.0
/*/
User Function uLogClass()

Return


/*/{Protheus.doc} uLogClass
Classe para criação de logs e apresentação dos mesmos (com a opção de salvar)
@author Jorge Heitor
@since 24/05/2017
@version 1.0
/*/

Class uLogClass

	data aLog
	
	Method New()
	Method Add()
	Method Skip()
	Method Dash()
	Method Show()

EndClass

/*/{Protheus.doc} New
Inicializacao do Objeto

@author Jorge Heitor
@since 26/01/2016
@version P12
/*/
Method New() Class uLogClass

	::aLog	:= {}
	
Return Self

/*/{Protheus.doc} Add
Incrementa linha no Log

@author Jorge Heitor
@since 24/05/2017
@version 1.0
/*/
Method Add(cLinha) Class uLogClass

	aAdd(::aLog,cLinha + (Chr(13)+Chr(10)))
	
Return .T.

/*/{Protheus.doc} Skip
Pula linha no log

@author Jorge Heitor
@since 24/05/2017
@version 1.0
/*/
Method Skip(nQtd) Class uLogClass

	Local x
	
	Default nQtd := 1
	
	For x:= 1 To nQtd 
		
		aAdd(::aLog, " " + (Chr(13)+Chr(10)))
		
	Next x
	
Return .T.

/*/{Protheus.doc} Dash
Pula linha no log

@author Jorge Heitor
@since 24/05/2017
@version 1.0
/*/
Method Dash(nQtd) Class uLogClass

	Local cDash := ""
	
	Default nQtd := 20
	
	cDash := Replicate("-",nQtd)
	
	aAdd(::aLog, " " + (Chr(13)+Chr(10)))
	
Return .T.

/*/{Protheus.doc} Show
Mostra o Log com a opção de salvar

@author Guilherme Santos
@since 26/01/2016
@version P12
/*/
Method Show() Class uLogClass

	Local oDlg
	Local oFont
	Local oMemo
	Local cTexto	:= ""
	Local x
	Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
	
	For x := 1 To Len(::aLog)
	
		cTexto += ::aLog[x]
		
	Next x
	
	Define Font oFont Name "Mono AS" Size 5, 12

	Define MsDialog oDlg Title "Operação concluída" From 3, 0 to 340, 417 Pixel

	@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
	oMemo:bRClicked := { || AllwaysTrue() }
	oMemo:oFont     := oFont

	Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
	Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
	MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

	Activate MsDialog oDlg Center

Return .T.