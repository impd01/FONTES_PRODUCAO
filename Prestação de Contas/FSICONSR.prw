#Include 'Protheus.ch'
#Include 'TopConn.ch'
#include 'tbiconn.ch'

Static cRet

/*/{Protheus.doc} FSICONSR
(long_description)
@type function
@author Carlos Xavier
@since 06/05/2016
@version 1.0
@return Logico
@example
Função que monta consulta especifica para a Tabela SRA 
Ex: Empresa Atual 01
na consulta padrão irei montar conforme o retorno do combo a query para apresentar a consulta.

@see (links_or_references)
/*/
User Function FSICONSR() //ti@718293?
local xEmp1
PUBLIC ARETSRA := ARRAY(4)  // ARETSRA[1] = NOME /ARETSRA[2]= MAT  /ARETSRA[3] = FILIAL 
	xEmp1 := CriaCombo()
	lRet := GeraSra(@xEmp1)
Return lRet

/*/{Protheus.doc} GeraSra
(long_description)
@type function
@author Carlos Xavier
@since 10/05/2016
@version 1.0
@param xEmp1, variável, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
FUNÇAO RESPONSAVEL PELA MONSTAGEM DA TELA E QUERY DE APRESENTAÇÃO
DA CONSULTA
@see (links_or_references)
/*/Static Function GeraSra(xEmp1)
Local 		cQuery

local 		aCampos 	:= 	{}
local 		aField		:=	{}
Local		aCombo		:=	{}
//==============================
//Variaveis de Objetos
//==============================
Local 		oDlg
local 		oBrowse
local 		cGPesq		:= Space(50)
Local		oFont
Local 		oSay
local 		oIcombo
local 		oLayer
local 		oTBok
local		oTcan

//==============================
//Blocos de Codigo
//==============================
local 		bIcombo 	:= 	{|u|if(PCount()>0,_Indice:=u,_Indice)}
local		bGpesq		:=	{|u| if( Pcount( )>0, cGpesq:= u,cGpesq )}
local		bOk			:= 	{||Confirm(@oDlg)}
//==============================
//Outras
//==============================
local 		_Indice
local 		cInd

AADD(aField,{"FILIAL"     	, "C" ,TamSX3("RA_FILIAL")		[1],0})	
AADD(aField,{"MAT"     		, "C" ,TamSX3("RA_MAT")			[1],0})
AADD(aField,{"NOME"     	, "C" ,TamSX3("RA_NOME")		[1],0})
//	IF xEmp1 == "02"
  		AADD(aField,{"XTIPO"     	, "C" ,TamSX3("RA_XTIPO")		[1],0})	
	//EndIF
AADD(aField,{"MSBLQL"     	, "C" ,TamSX3("RA_MSBLQL")		[1],0})



//cArqTrab   := CriaTrab(aField,.T.)
MsCreate(cArqTrab,aField,"TOPCONN")	//CodeAnalysis
	
	
	If Select("TRB") <> 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf	

dbUseArea(.T.,"TOPCONN", cArqTrab,"TRB",.F.,.F.)

//dbUseArea(.T.,, cArqTrab,"TRB",.F.,.F.)

///TRB->(IndRegua("TRB", cArqTrab, "MAT", , , "Criando índices..."))
	
//TRB->(dbSetIndex(cArqTrab+OrdBagExt()))
//atribui ao arquivo temporario criado o indice criado
//TRB->(IndRegua("TRB", cArqTrab, "NOME", , , "Criando índices..."))
//TRB->(dbClearIndex())
//TRB->(dbSetIndex(cArqTrab+OrdBagExt()))

//Query para Trazer resultado da empresa selecionada no combo
cQuery	:= " SELECT  SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_MSBLQL, "
  //	IF xEmp1 == "02"
cQuery += " SRA.RA_XTIPO "
//	Endif
cQuery 	+= "FROM "
cQuery 	+="SRA"+xEmp1+"0 SRA "
cQuery 	+=	" WHERE  SRA.RA_MSBLQL != '1' AND SRA.D_E_L_E_T_ = '' " 


	
	If Select("TSRA") >0
		TSRA->(DBCLOSEAREA())
	EndIF	

TcQuery cQuery New Alias "TSRA"

TSRA->(DBGOTOP())

	//---------------------------------------------------------
	//	CARGA DE DADOS NA TEMP PARA UTILIZACAO NO ACAMPOS
	//---------------------------------------------------------
		while TSRA->(!EOF())
					Reclock("TRB",.T.)
					TRB->FILIAL	:= TSRA->RA_FILIAL
					TRB->MAT	:= TSRA->RA_MAT
					TRB->NOME	:= TSRA->RA_NOME
				   //	IF xEmp1 == "02"
						TRB->XTIPO	:= TSRA->RA_XTIPO	
				   //	Endif
					TRB->MSBLQL	:= TSRA->RA_MSBLQL
					
					TRB->(Msunlock())
				TSRA->(dbskip())
		EndDo
	
	TRB->(dbgotop())
	

	AADD(aCampos,{ "Filial"           	,{||TRB->FILIAL}, "C" ,TamSX3("RA_FILIAL")	[1]	,X3Picture("RA_FILIAL")	})	
	AADD(aCampos,{ "Matricula"         	,{||TRB->MAT} 	, "C" ,TamSX3("RA_MAT")		[1],X3Picture("RA_MAT")  	})
	AADD(aCampos,{ "Nome"          		,{||TRB->NOME}  , "C" ,TamSX3("RA_NOME")	[1],X3Picture("RA_NOME") 	})	
  //	IF xEmp1 == "02"
		AADD(aCampos,{ "Função"          		,{||TRB->XTIPO}  , "C" ,TamSX3("RA_XTIPO")	[1],X3Picture("RA_XTIPO") 	})					
   //	Endif
	  
	
	//Montagem da dialog e seus componetes
	DEFINE DIALOG oDlg TITLE "Consulta Funcionario" FROM 180,180 TO 500,700 PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)//600 700
	
	oLayer := Fwlayer():New()
	oLayer:Init(oDlg,.T.)
	oLayer:AddLine( 'TOP', 80, .F. )
	oLayer:AddCollumn( 'TP01', 100, .T., 'TOP' )
	oPanelUp := oLayer:GetColPanel( 'TP01', 'TOP' )
	
	oBrowse := TCBrowse():New( 01 , 01, 260, 130/*156*/,,{'Filial','Matricrula','Nome'},{20,50,50,20},oPanelUp,,,,,{||},,,,,,,.F.,"TRB",.T.,,.F.,,.T.,.T.)
	oBrowse:bldblclick:={||Confirm(@oDlg)}
	oBrowse:AddColumn(TCColumn():New('Filial',{||TRB->FILIAL},,,,'LEFT',,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New('Codigo',{||TRB->MAT},,,,'LEFT',,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New('Descricao',{||TRB->NOME},,,,'LEFT',,.F.,.F.,,,,.F.,))
	IF xEmp1 == "02"
		oBrowse:AddColumn(TCColumn():New('Funcao',{||TRB->XTIPO},,,,'LEFT',,.F.,.F.,,,,.F.,))
	ENDIF
	aCombo := {"Nome","Matricula"}//U_PEGADESC()
	oIcombo := TComboBox():New(150,10,bIcombo,aCombo,90,05,oDlg,,,,,,.T.,,,,,,,,,'_Indice')
	
 	oFont 	:= TFont():New('Arial',,-14,.T.)
 	oSay	:= TSay():Create(oDlg,{||'Pesquisar'},150,110,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)//150 65
	//oTxVi	:= TButton():New( 150,100, "Visualizar",oDlg,{||AxVisual()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )//170 100
	//oGpesq	:= TGet():New( 150,150,bGpesq,oDlg,50,05,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGpesq,,,, )//150 90 
	//oGpesq:lReadOnly := .T.
	@ 150, 150 MSGET oGpesq VAR cGpesq SIZE 050, 005 OF oDlg VALID {||Spesq(@cGpesq,@oBrowse,@cArqTrab,@_Indice)} COLORS 0, 16777215 PIXEL
	oTBok	:= TButton():New( 150,200, "OK",oDlg,bOk, 20,10,,,.F.,.T.,.F.,,.F.,,,.F. )   //150 150
	oTCan	:= TButton():New( 150,230, "Cancel",oDlg,{||oDlg:End()	}, 20,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // 150 200
		
	
	ACTIVATE DIALOG oDlg CENTERED //ON INIT (EnchoiceBar(oDlg,{||Confirm(@oDlg),oDlg:End()},{||oDlg:End()},,))

TRB ->(dbCloseArea())
Return .T.

/*/{Protheus.doc} CriaCombo
(long_description)
@type function
@author Carlos Xavier
@since 10/05/2016
@version 1.0
@return XEMP EMPRESA SELECIONADA
@example
COMBO EXEMPLO:
////////////////////////////////
//	SELECIONE A EMPRESA		  //
//							 //
//			O1				 //
///////////////////////////////
MONTO A QUERY DO GRID BASEANDO NO RETORNO DO COMBO
@see (links_or_references)
/*/static function CriaCombo()
Local aItems:= {}//{"01","02"},
local aItens := {}
local cArea := GetArea()
local _Titulo := "Informe a Empresa"
local xBuffer :=""

	//==============================================================
	//MONTO O COMBO BASEANDO-SE NA SM0 PARA POSSIVEIS CRIAÇÃO DE
	//NOVAS EMPRESAS!
	//============================================================== 
		SM0->(Dbgotop())
		
		WHILE SM0->(!EOF()) 
			if xBuffer != SM0->M0_CODIGO .AND. SM0->M0_CODIGO != "99"
				AADD(aItems,SM0->M0_CODIGO)
				xBuffer := SM0->M0_CODIGO
			endif
			SM0->(DBSKIP())
		ENDDO
		
	
	//==============================================================
	//MONTAGEM DO COMBO PARA SELECAO DA EMPRESA!
	//==============================================================

 
    DEFINE DIALOG oDlg TITLE _Titulo FROM 40,40 TO 150,200 PIXEL 
        // Usando New
        xEmp:= aItems[1]
        oCombo1 := TComboBox():New(10,30,{|u|if(PCount()>0,xEmp:=u,xEmp)},;
        aItems,30,20,oDlg,,;
        ,,,,.T.,,,,,,,,,'xEmp')
    	 oTBok	 := TButton():New( 30,30, "OK",oDlg,{||oDlg:End()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
     ACTIVATE DIALOG oDlg CENTERED
     

RestArea(cArea)
Return xEmp 

static Function Confirm(oDlg)

cRet:= TRB->NOME
ARETSRA[1]:= TRB->NOME
ARETSRA[2]:= TRB->MAT
ARETSRA[3]:= TRB->FILIAL 
ARETSRA[4]:= 	PEGADESC(TRB->XTIPO)
oDlg:End()

Return 

/*/{Protheus.doc} FSSRARET
(long_description)
@type function
@author Carlos Xavier
@since 10/05/2016
@version 1.0
@return CRET
@example
A VARIAVEL CRET E UMA STATIC ONDE RECEBRA O NOME DO FUNCIONARIO
@see (links_or_references)
/*/User Function FSSRARET()      

Return cRet                                                                                                                                                                                                                                      


/*/{Protheus.doc} sPesq
(long_description)
@type function
@author Carlos Xavier
@since 10/05/2016
@version 1.0
@param cGpesq, character, (Descrição do parâmetro)
@param oBrowse, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
RELIZA A PESQUISA NO GRID
@see (links_or_references)
/*/Static Function sPesq(cGpesq,oBrowse,cArqTrab,_Indice)


	if _Indice == "Nome" 
		TRB->(IndRegua("TRB", cArqTrab, "NOME", , , "",.F.))
		TRB->(dbClearIndex())
		TRB->(dbSetIndex(cArqTrab+OrdBagExt()))
	
	Else
		TRB->(IndRegua("TRB", cArqTrab, "MAT", , , "",.F.))
		TRB->(dbClearIndex())
		TRB->(dbSetIndex(cArqTrab+OrdBagExt()))
	EndiF

TRB->(DBSETORDER(1))
	If TRB->(Dbseek(Alltrim(Upper(cGpesq))))
		oBrowse:Refresh()
	else
		Alert("Funcionario não encontrado")
	Endif

Return 


Static Function PEGADESC(xPar)
Local cCampo	:= 'RA_XTIPO'
Local aCombo
local nX
local xCombo
//local xPar := "2"
local cArea := GetArea()
local cRet
dbSelectArea('SX3')
SX3->( dbSetOrder(2) )
SX3->( dbSeek( cCampo ) )
                
cValor	:= X3CBox()	
xCombo 	:= StrTokArr2( cValor, ";" )
//aCombo := Separa(cValor,"=")

	for nX := 1 to len(xCombo)
		If Substr(xCombo[nX] ,1,1) == xPar
			cRet := substr(xCombo[nX],3)
		Endif
	Next nX
RestArea(cArea)
Return cRet

