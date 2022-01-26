#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002


User Function Leg001()
Local oLegenda  := FwLegend():New()

oLegenda:Add ("ZA4_ATIVO == '1'", "BR_VERDE", "Ativo")
oLegenda:Add ("ZA4_ATIVO == '2'", "BR_VERMELHO", "Inativo")
oLegenda:Add ("ZA4_TRANSF == '1'", "BR_PINK", "Transferido")
oLegenda:Add ("ZA4_BAN == '1'", "BR_CANCEL", "Banido")


oLegenda:Activate()
oLegenda:View()
oLegenda:DeActivate()

Return ( Nil )


User Function BrowseZA4()

	Local aCores  := {{ 'ZA4->ZA4_TRANSF="1"' , 'BR_PINK', "Transferido"},;   // Transferido
					  { 'ZA4->ZA4_BAN="1"' , 'BR_CANCEL', "Banido"},;    // Banido
					  { 'ZA4->ZA4_ATIVO="1"' , 'BR_VERDE', "Ativo" },;    // Ativo				 					 
					  { 'ZA4->ZA4_ATIVO="2"' , 'BR_VERMELHO', "Inativo"}}    // Inativo
					
	
	Private cAlias 		:= "ZA4"
	Private cCadastro	:= "Cadastro de Obreiros"
	Private aRotina		:= {}	

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	

	aRotina := {	{"Pesquisar",			'AxPesqui',	0,1,0,.F.},;
					{"Visualizar",			'AxVisual',	0,2,0,Nil},;
					{"Incluir",				'AxInclui',	0,3,0,Nil},;		
					{"Alterar",				'AxAltera',	0,6,0,Nil},;
					{ "Conhecimento","MsDocument"     , 0,4,0,Nil},;
					{"Legenda",             'U_Leg001', 0,5    },;
					{"Transferir" , "U_IM07A01T" , 0 , 4,15,NIL},;
					{"Excluir",     		'AxDeleta',	0,7,0,.F.} }


	mBrowse(,,,, cAlias,,,,,, aCores)

Return .T.


user function IM76U02(cCpf)

cCpf := Alltrim(cCpf)


		If !CGC(cCpf)
			MsgInfo("CPF ou CNPJ inválido","TOTVS")
			Return .F.
		Endif
	
		IF ZA4->(DbSeek(xFilial("ZA4")+cCpf))
		
			MsgInfo("Este CPF já está cadastrado","TOTVS")
			
			M->ZA4_CPF := ""

			Return .F.
		
		Endif


USER FUNCTION FTMSREL
LOCAL aEntidade := {}

AADD( aEntidade, { "ZA4", { "ZA4_COD" }, { || ZA4->ZA4_COD } } )

Return aEntidade


User Function FCopiaZA4()
  AxInclui("ZA4",ZA4->(Recno()), 3,, "U_IniCposZA4",,,.F.,,,,,,.T.,,,,,)
Return Nil

//Função para carregamento dos campos em variáveis de memória
User Function IniCposZA4()
  Local bCampo   := { |nCPO| Field(nCPO) }
  Local nCountCpo  := 0
  
  //Abre a Tabela de Cadastro de Obreiro
  DbSelectArea("ZA4")
  
  //Executa o laço de todos os campos da Tabela ZA4
  For nCountCpo := 1 TO ZA4->(FCount())
    If (AllTrim(FieldName( nCountCpo )) <> "ZA4_COD")
    
      //Inputa o valor do campo posicionado, na variável de memória
      M->&(EVAL(bCampo, nCountCpo)) := FieldGet(nCountCpo)
    EndIf
  Next nCountCpo
Return Nil


DbCloseArea()	

User Function IM07A01T()

	Local aArea			:= GetArea()
	Local oArea			:= FWLayer():New()

	Local cTitulo 		:= "Transferência de Obreiro"

	Local cDelOk		:= "AllwaysFalse()"
	Local cSuperDel		:= "AllwaysFalse()"
	Local cLinhaOk		:= "AllwaysTrue()"
	Local cTudoOk		:= "AllwaysTrue()"
	Local cFieldOk		:= "AllwaysTrue()"
	Local aCols			:= {}
	Private aTamObj			:= Array(4)
	
	nStyle := GD_UPDATE	

	aHeader := {} 

	AADD(aHeader,{"Nome"				,"ZA4_NOME"		,PesqPict("SE2","E2_NUM")		,TamSX3("E2_NUM")[1]		,TamSX3("E2_NUM")[2]		,			,""			,TamSX3("E2_NUM")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeader,{"CC Atual"			,"ZA4_CC"		,PesqPict("ZA4","ZA4_CC")		,TamSX3("ZA4_CC")[1]		,TamSX3("ZA4_CC")[2]		,			,""			,TamSX3("ZA4_CC")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})
	AADD(aHeader,{"Descrição"			,"ZA4_NOME"		,PesqPict("ZA4","ZA4_NOME")		,TamSX3("ZA4_NOME")[1]		,TamSX3("ZA4_NOME")[2]		,			,""			,TamSX3("ZA4_NOME")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeader,{"CC Destino"			,"ZA4_CC"		,PesqPict("ZA4","ZA4_CC")		,TamSX3("ZA4_CC")[1]		,TamSX3("ZA4_CC")[2]		,			,""			,TamSX3("ZA4_CC")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	
	AADD(aHeader,{"Descrição"			,"ZA4_NOME"		,PesqPict("ZA4","ZA4_NOME")		,TamSX3("ZA4_NOME")[1]		,TamSX3("ZA4_NOME")[2]		,			,""			,TamSX3("ZA4_NOME")[3]		,""		,""				,""			,""			,			,'V'		,			,			,			})	

	aCols := {ZA4->ZA4_NOME,ZA4->ZA4_CC,"","",""}

	oDlg := tDialog():New(100,100,300,900,OemToAnsi(cTitulo),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oArea:Init(oDlg,.F.)

	oArea:AddLine("L01",100,.T.)

	oArea:AddCollumn("L01OBRE", 75,.F.,"L01")
	oArea:AddCollumn("L01FUNC", 25,.F.,"L01")

	oArea:AddWindow("L01OBRE","L01OBRE"  ,"Transferencia de Obreiros",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oArea:AddWindow("L01FUNC","L01FUNC"  ,"Funções",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)

	oPainObre  := oArea:GetWinPanel("L01OBRE"  ,"L01OBRE"  ,"L01")
	oPainFunc  := oArea:GetWinPanel("L01FUNC"  ,"L01FUNC"  ,"L01")

	aFill(aTamObj,0)
	U_DefTamObj(@aTamObj)
	aTamObj[3] := (oPainOpco:nClientWidth)
	aTamObj[4] := (oPainOpco:nClientHeight)

	U_DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainFunc)
	oBotConf := tButton():New(aTamObj[1],aTamObj[2],"Confirmar",oPainFunc,{||  LJMsgRun('Gerando Dados','Aguarde, Gerando Dados',{||Alert("TRANSFERENCIA","TOTVS")})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"Cancelar",oPainFunc,{|| oDlg:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })
	
	oGetDados 	:= MsNewGetDados():New(aCoord[1]   ,aCoord[2]   ,oPainObre:nClientWidth/2,oPainObre:nClientHeight/2,nStyle,"AllWaysTrue","AllWaysTrue","",,,9999,cFieldOk	,"AllwaysFalse()"	,"AllwaysFalse()"		,oPainObre	,aHeader,/*aCols*/,/*{|| U_DV06GAT(3)}*/)

	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oDlg:Activate(,,,.T.,/*valid*/,,{||LJMsgRun("Procurando Ocorrências...","Aguarde...",{ || /*U_IM06A02P()*/})})

	oGetDados:SetArray(aCols)
	oGetDados:Refresh()
	oGetDados:oBrowse:SetFocus()
	
Return()
