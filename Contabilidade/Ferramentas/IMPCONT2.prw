#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"

#DEFINE TAMLINLOG 50

// Definicao do layout de colunas a serem consideradas na leitura do arquivo Rede
#DEFINE NOTA     6
#DEFINE VALOR_BX 8
#DEFINE DATA_BX  14

/*/{Protheus.doc} IMPCONTV2
Rotina para importação de planilha para criaï¿½ï¿½o de título
@type  Function
@author Vinicius Henrique
@since 28/10/2019
@version 1.1
/*/

User Function IMPCONTV2()

Local llOk      := .T.
Local alButton  := {}
Local alSay     := {}
Local clTitulo  := 'IMPORTAÇÃO DE BAIXAS A PAGAR - IMPD'
Local clDesc1   := 'Esta rotina tem como objetivo fazer importacao de arquivo de '
Local clDesc2   := 'pagamentos no formato csv, e gerar o título de forma automatica'
Local clDesc3   := ''
Local llFirst   := .T.

Private cpFile	:= ""
Private cpSep	:= ""
Private cpNameFile	:= "log_imp_impd_" + dToS( date() ) + "_" + strTran( time(), ":", "" ) + ".txt"

AADD( alSay, clDesc1)
AADD( alSay, clDesc2)
AADD( alSay, clDesc3)

// Botoes do Formatch
AADD( alButton, { 01, .T., {|| llOk := .T., fechaBatch() }})
AADD( alButton, { 02, .T., {|| llOk := .F., fechaBatch() }})
AADD( alButton, { 05, .T., {|| getParam() } } )
    
while ( llOk;
        .and. ( empty( cpFile ) .or. empty( cpSep ) );
        )
    
    if ( .not. llFirst .and. ( empty( cpFile ) .or. empty( cpSep ) ) )
        alert( "Os parâmetros devem ser preenchidos!" )
        llOk := .F.
    endif
    
    getParam()
    formBatch( clTitulo, alSay, alButton )
    
    llFirst := .F.
    
endDo

if ( llOk )
    fwMsgRun(,{|oSay| impCSV( oSay ) },"Processando arquivo impd","Aguarde..." )
    msgInfo( "Processamento finalizado!" )
endif

Return

/*/{Protheus.doc} getParam
Funcao para controlar os parametros da importaï¿½ï¿½o
@author Vinicius Henrique
@since 28/10/2019
@version 1.0

@type function
/*/
Static Function getParam()

Local alParamBox	:= {}
Local clTitulo		:= "Parâmetros"
Local alButtons		:= {}
Local llCentered	:= .T.
Local nlPosx		:= Nil
Local nlPosy		:= Nil
Local clLoad		:= ""
Local llCanSave		:= .T.
Local llUserSave	:= .T.
Local llRet			:= .T.
Local clVldDt		:= ".T."
Local clVldSA11		:= ".T."
Local blOk			:= {|| &clVldDt }
Local alParams		:= {}

AADD(alParamBox,{6,"Informe o Arquivo"		,space( 250 )						,"@!",clVldSA11	,".T."		,75		,.T.,"Arquivos .CSV |*.CSV"})	
AADD(alParamBox,{1,"Caracter Separador"		,space( 1 )							,"@!"			,".T."     	,"" 	,""	,15,.T.})

llRet := ParamBox(alParamBox, clTitulo, alParams, blOk, alButtons, llCentered, nlPosx, nlPosy,, clLoad, llCanSave, llUserSave)

if ( llRet )
    cpFile	  := alParams[1]
    cpSep     := alParams[2]    
endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} impCSV
Rotina para realizaï¿½ï¿½o da leitura do arquivo Rede
@author  Vinicius Henrique
@since   28/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function impCSV( oSay )

	Local clDir			:= subs( cpFile, 1, rat( "\", cpFile ) )
	Local clFullName	:= clDir + cpNameFile
	Local alDados		:= {}
	Local nlLin			:= 1
	Local olFileRead	:= fwFileReader():New( cpFile )
	Local llFileOk		:= .T.
	Local llFirstLn		:= .T.
    
    Private cTitulo     := ""
	Private opFileWrit	:= fwFileWriter():New(clFullName, .F.)
    Private nTotBx      := 0
	
	olFileRead:nBufferSize := 5000
	
	if ( olFileRead:open() )
	
		if ( .not. olFileRead:eof() )
			
			if ( .not. opFileWrit:create() )
				
				llFileOk := .F.
				alert( "Não foi possível criar arquivo " + clFullName )
			
			endif
			
		endif
		
		if ( llFileOk )

			while ( olFileRead:hasLine() )
				
				if ( nlLin > 1 )
				
					alDados := aClone( separa( olFileRead:getLine(), cpSep, .T. ) )
					
					if ( len( alDados ) > 0 )
						
                        llFirstLn := .F.
                        cMsgLog := ""
                        
                        cTitulo := NextNum()

                        writeIniProc( nlLin, cTitulo )
                                                
                        // Gero tï¿½tulos a pagar
                        cMsgLog := criaTitulo( alDados, oSay )

                        writeFimProc( nlLin, cMsgLog )

					endif
					
				else
					olFileRead:getLine()
				endif
				
				nlLin++
							
			endDo
            opFileWrit:write( "Total dos títulos criados: R$ " + allTrim( transform( nTotBx, "@E 999,999,999.99" ) ) )
			opFileWrit:close()
			
		endif
		
		olFileRead:close()
		
	else
	   msgAlert("Erro de abertura do arquivo!", "ERRO!")
	endif
	
Return
/*/{Protheus.doc} criaTitulo( alDados )
Funcao que realiza a criaï¿½ï¿½o do tï¿½tulo no conta a pagar
@type  Static Function
@author Vinicius Henrique
@since 28/10/2019
@version 1.0
@param alDados, array, array com as colunas do CSV lido da planilha Rede
@return cMsg, caracter, mensagem de nï¿½o-conformidade no processamento
/*/
Static Function criaTitulo( alDados, oSay)

Local cMsg       := ""
Local cPrefixo   := ""
Local cParcela   := ""
Local cTipo      := ""
Local nVal	     := 0
Local cCliente   := ""
Local cLoja      := ""
Local cHistorico := ""
Local nValorE1   := 0
Local alErroAuto := {}
Local clMsgErro  := ""
Local cMod		 := ""
Local cBand		 := ""
Local aInc		 := {}
Local cForn		 := StrZero(Val(Alltrim(alDados[5])),6)
Local cLoja		 := StrZero(Val(Alltrim(alDados[7])),2)
Local nAcresc	 := 0

Private lMsErroAuto    := .F.
Private lMsHelpAuto    := .T.
Private lAutoErrNoFile := .T.

oSay:setText( "Incluindo titulo: " + cTitulo )

nVal := val( allTrim( strTran( strTran( STRTRAN(alDados[10],"R$",""), ".", "" ), ",", "." ) ) )
nAcresc := val( allTrim( strTran( strTran( STRTRAN(alDados[26],"R$",""), ".", "" ), ",", "." ) ) )

			if alDados[8] = ''
				alert("Título sem data de emissão!")
				return()
			endif

dbSelectArea("SA2")
SA2->( dbSetOrder( 1 ) )

if ( SA2->( dbSeek( fwxFilial( "SA2" ) + cForn + cLoja ) ) )

	aInc := {	{"E2_FILIAL" 		, xFilial("SE2") 	, Nil},;
				{"E2_PREFIXO" 		, '	'				, Nil},;
				{"E2_NUM" 			, cTitulo 			, Nil},;
				{"E2_PARCELA" 		, ' '				, Nil},;
				{"E2_TIPO" 			, alDados[3]		, Nil},;
				{"E2_FORNECE" 		, cForn 			, Nil},;
				{"E2_LOJA" 			, cLoja				, Nil},;
				{"E2_EMISSAO"		, CTOD(alDados[8])	, Nil},; 
				{"E2_VENCTO"		, CTOD(alDados[9])	, Nil},;
				{"E2_VENCREA"		, CTOD(alDados[9])	, Nil},;
				{"E2_VALOR"			, nVal				, Nil},; 
				{"E2_HIST"			, alDados[11]		, Nil},; 
				{"E2_ORIGEM"		, 'FINA050 '		, Nil},;
				{"E2_XAUTOMA"		, "S"				, Nil},; 
				{"E2_NATUREZ"		, alDados[13]		, Nil},; 
				{"E2_CCD"			, alDados[15]		, Nil},; 
				{"E2_RATFIN"		, "2"				, Nil},; 
				{"E2_XNUM"			, cTitulo			, Nil},; 
				{"E2_XUSERLI"		, cUserName			, Nil},; 
				{"E2_XHIST"			, alDados[11]		, Nil},; 
				{"E2_XPAG"			, alDados[25]		, Nil},;
				{"E2_ACRESC"		, nAcresc 			, Nil}}
	
	lMsErroAuto := .F. 
	MsExecAuto( { |x,y| FINA050(x,y)}, aInc,, 3)
		
	if lMsErroAuto
		                        
		alErroAuto := getAutoGRLog()
	    aEval( alErroAuto, {|x| clMsgErro += allTrim( x ) + '<br/>'})
		                                        
	    cMsg += "Não foi possível incluir o tíulo: " + cTitulo + CRLF
	    cMsg += clMsgErro + CRLF
		                                            
	else                                                 

	    cMsg  += "Titulo [" + cTitulo + "] incluído com sucesso!" + CRLF
	    nTotBx += nVal
		nTotBx += nAcresc // ------------------------------------------

	endif
	
Else

	cMsg += "Fornecedor [" + cForn + "], Loja [" + cLoja + "]  nao encontrado!" + CRLF

Endif

Return cMsg

//-------------------------------------------------------------------
/*/{Protheus.doc} writeIniProc
Funcao para escrever no log de forma padronizada, no inicio do log
@author  Vinicius Henrique
@since   29/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function writeIniProc( nlLin, cTitulo )

opFileWrit:write( replicate("=", TAMLINLOG) + CRLF )
opFileWrit:write( PADR( "= Processando linha " + allTrim( str( nlLin ) ) + " >> Titulo: " + cTitulo, (TAMLINLOG-1)) + "=" + CRLF )
opFileWrit:write( replicate("=", TAMLINLOG) + CRLF )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} writeIniProc
Funcao para escrever no log de forma padronizada, no fim do log
@author  Vinicius Henrique
@since   29/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function writeFimProc( nlLin, cMsgLog )

if ( !empty( cMsgLog ) )
    opFileWrit:write( cMsgLog + CRLF )
endif

//opFileWrit:write( replicate("=", TAMLINLOG) + CRLF )
opFileWrit:write( PADR( "Fim Processando linha " + allTrim( str( nlLin ) ), (TAMLINLOG-1)) + CRLF )
//opFileWrit:write( replicate("=", TAMLINLOG) + CRLF )

Return

Static Function NextNum() //Gera novo titulo de acordo com os parï¿½metros

Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

cQuery	:= "SELECT MAX(E2_NUM) AS MAXCODIGO		" 		+ CRLF
cQuery	+= "FROM " + RetSQLName("SE2") + " SE2	"	 	+ CRLF
cQuery	+= "WHERE SE2.D_E_L_E_T_ = ' '			"		+ CRLF
cQuery	+= "AND SE2.E2_NUM LIKE 'AUT%'			"		+ CRLF 
cQuery	+= "AND SE2.E2_XAUTOMA = 'S'			"		+ CRLF

TCQUERY cQuery NEW ALIAS (cAlias)

(cAlias)->(dbGoTop())

cTitulo := SUBSTR((cAlias)->MAXCODIGO,4,9)

If !Empty(Alltrim(cTitulo))

	cTitulo := Val(cTitulo)	+ 1
	cTitulo :=  "AUT" + STRZERO(cTitulo, 6, 0)

Endif

Return(cTitulo)
