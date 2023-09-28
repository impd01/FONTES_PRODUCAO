#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

#DEFINE TAMLINLOG 50
#DEFINE VALORDBT 5
#DEFINE VALORCRT 4
#DEFINE DATA_BX  1
#DEFINE HISTOR  2

/*/{Protheus.doc} PRFINP02
Rotina para importação de planilha csv para conciliação bancária
@type  Function
@author Vinicius Henrique
@since 16/08/2023
@version 1.0
/*/
User Function ImpcsvMov()

Local llOk      := .T.
Local alButton  := {}
Local alSay     := {}
Local clTitulo  := 'IMPORTAÇÃO DE PLANILHA DE AÇÕES'
Local clDesc1   := 'Esta rotina tem como objetivo fazer importacao de arquivo de '
Local clDesc2   := 'planilha para realizar lançamento de movimento bancario de forma automática'
Local clDesc3   := ''
Local llFirst   := .T.

Private cpFile	:= ""
Private cpSep	:= ""
Private cLocal
Private cpBanco
Private cpAgencia
Private cpConta
Private cpNameFile	:= "log_imp__" + dToS( date() ) + "_" + strTran( time(), ":", "" ) + ".txt"
Private nTotalDeb   := 0
Private nTotalCrd   := 0
Private aLog        := {}

AADD( alSay, clDesc1)
AADD( alSay, clDesc2)
AADD( alSay, clDesc3)

// Botoes do Formatch
AADD( alButton, { 01, .T., {|| llOk := .T., fechaBatch() }})
AADD( alButton, { 02, .T., {|| llOk := .F., fechaBatch() }})
AADD( alButton, { 05, .T., {|| getParam() } } )
    
while ( llOk;
        .and. ( empty( cpFile ) .or. empty( cpSep ) .or. empty( cpBanco ) .or. empty( cpAgencia ) .or. empty( cpConta ) );
        )
        
    if ( .not. llFirst .and. ( empty( cpFile ) .or. empty( cpSep ) .or. empty( cpBanco ) .or. empty( cpAgencia ) .or. empty( cpConta ) ) )
        alert( "Os parâmetros devem ser preenchidos!" )
        llOk := .F.
    endif
    
    getParam()
    formBatch( clTitulo, alSay, alButton )
    
    llFirst := .F.
    
endDo

if ( llOk )
    fwMsgRun(,{|oSay| impCSV( oSay ) },"Processando arquivo de conciliação bancária","Aguarde..." )
    msgInfo( "Processamento finalizado!" )
endif

Return

/*/{Protheus.doc} PRFINP02
Rotina para importação de planilha csv para conciliação bancária
@type  Function
@author Vinicius Henrique
@since 16/08/2023
@version 1.0
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

AADD(alParamBox,{6,"Informe o Arquivo CSV"	,space( 250 )	                    ,"@!",clVldSA11     ,".T."          ,75             ,.T.        ,"Arquivos .CSV |*.CSV"})	
AADD(alParamBox,{1,"Caracter Separador"		,space( 1 )		                    ,"@!"               ,".T."          ,""             ,""         ,15,.T.})
AADD(alParamBox,{1,"Banco"		            ,space( tamSX3( "A6_COD" )[1] )		,"@!",".T."         ,"SA6JUR"   ,"",15,.T.})
AADD(alParamBox,{1,"Agência"	            ,space( tamSX3( "A6_AGENCIA" )[1] )	,"@!",".T."         ,""         ,"",20,.T.})
AADD(alParamBox,{1,"Conta"		            ,space( tamSX3( "A6_NUMCON" )[1] )	,"@!",".T."         ,""         ,"",25,.T.})

llRet := ParamBox(alParamBox, clTitulo, alParams, blOk, alButtons, llCentered, nlPosx, nlPosy,, clLoad, llCanSave, llUserSave)

if ( llRet )
    cpFile	    := alParams[1]
    cpSep       := alParams[2]
    cpBanco     := alParams[3]  
    cpAgencia   := alParams[4]  
    cpConta     := alParams[5]      
endif

Return

/*/{Protheus.doc} PRFINP02
Rotina para importação de planilha csv para conciliação bancária
@type  Function
@author Vinicius Henrique
@since 16/08/2023
@version 1.0
/*/
Static Function impCSV( oSay )

	Local clDir			:= subs( cpFile, 1, rat( "\", cpFile ) )
	Local clFullName	:= clDir + cpNameFile
	Local alDados		:= {}
	Local nlLin			:= 1
	Local olFileRead	:= fwFileReader():New( cpFile )
	Local llFileOk		:= .T.
	Local llFirstLn		:= .T.
	Local cMsg          := ""

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
                                                
                        //oSay:setText( "Inventariando Produto: " + clProduto )

                        // Identifica titulo, e realiza a baixa automatica
                        If alDados[1] == 'Total'
                            Exit
                        else
                            cMsgLog := processa( alDados )
                        Endif
					endif

				else
					olFileRead:getLine()
				endif
				
				nlLin++
							
			endDo

            cMsg += 'TOTAIS DE REGISTROS PROCESSADOS' +CRLF + CRLF
            cMsg += 'TOTAL DE LINHAS: ' + cValtoChar(nlLin) + CRLF
            cMsg += 'TOTAL CREDITO: R$ ' + Alltrim(Transform(nTotalCrd,"@E 999,999,999.99")) + CRLF  
            cMsg += 'TOTAL DEBITO: R$ ' + Alltrim(Transform(nTotalDeb,"@E 999,999,999.99")) + CRLF + CRLF 
            cMsg += 'SALDO PROCESSAMENTO: R$ ' + Alltrim(Transform((nTotalCrd - nTotalDeb),"@E 999,999,999.99"))

            Aviso("Importação Extrato Bancário", cMsg, {"OK"}, 3, , , "BR_AZUL")

            geracsvlog(clDir)
			
		endif

	else
	   msgAlert("Erro de abertura do arquivo!", "ERRO!")
	endif
	
Return

/*/{Protheus.doc} PRFINP02
Rotina para importação de planilha csv para conciliação bancária
@type  Function
@author Vinicius Henrique
@since 16/08/2023
@version 1.0
/*/
Static Function processa( alDados )

Local aArea     := GetArea()
Local nOpc      := 0
Local aFINA100  := {}
Local cNatureza := ''
Local nValor    := 0
Local cRecPag   := ''
Local cMsgLog   := ''
Local lProcessa := .F.
Local cCusto    := ''
Local clFilial  := xFilial("SE5")
Local clExcNts  := GETMV("MV_EXCNTRS")

Private lMsErroAuto := .F.

    If alDados[1] <> "Data"

        IF alDados[2] <> "SALDO ANTERIOR"

            If val( allTrim( strTran( strTran( STRTRAN(alDados[4],"R$",""), ".", "" ), ",", "." ) ) ) > 0

                nValor := val( allTrim( strTran( strTran( STRTRAN(alDados[4],"R$",""), ".", "" ), ",", "." ) ) )
                nOpc := 4
                cRecPag := 'R'
                lProcessa := .T.
                AADD(aLog, {'CREDITADO',alDados[1],alDados[2],alDados[3],alDados[4],alDados[6],PswChave(RetCodUsr()),ddatabase, time()} )    
                nTotalCrd += nValor

                If 'TRANSFERENCIA PIX REM' $ alDados[2] .Or. 'PIX QR CODE ESTATIC REM' $ alDados[2] .Or.;
                    'TARIFA BANCARIA TRANSFER VIA NET' $ alDados[2]
                    cNatureza := '10001'
                Elseif 'SALDO DEV.TRANSF.PARA CL' $ alDados[2]
                    cNatureza := '1001004'
                else
                    cNatureza := '10004'
                Endif

            Else

                nValor := ( val( allTrim( strTran( strTran( STRTRAN(alDados[5],"R$",""), ".", "" ), ",", "." ) ) )*-1 )

                nTotalDeb += nValor

                If 'TRANSF CC PARA CC PJ IGREJA MUNDIAL DO PODER DE' $ alDados[2]
                    AADD(aLog, {'DEBITADO (DEMONSTRATIVO)',alDados[1],alDados[2],alDados[3],alDados[5],alDados[6],PswChave(RetCodUsr()),ddatabase, time()} )  
                    lProcessa := .F. 
                else
 
                    If 'TAR MALOTE MANUTENCAO' $ alDados[2] .Or. 'TARIFA BANCARIA LIQUIDACAO QRCODE PIX' $ alDados[2] .Or. 'TARIFA BANCARIA TRANSFER VIA NET' $ alDados[2] ;
                        .Or. 'TARIFA MANUTENCAO C/C TAR.MANUT.C/C' $ alDados[2] .Or. 'TARIFA MANUTENCAO C/C VR.PARCIAL TAR.MANUT.C/C' $ alDados[2]
                        cNatureza := '5014001'
                    elseif 'MORA ENC DESCOBERTO C.C' $ alDados[2]
                        cNatureza := '5014007'
                    elseif 'MORA DE OPERACAO' $ alDados[2]
                        cNatureza := '1001004'
                    elseif 'TARIFA BANCARIA TRANSFER VIA NET' $ alDados[2]
                        cNatureza := '10004'  
                    else
                        cNatureza := '10004'                   
                    Endif
                    AADD(aLog, {'DEBITADO',alDados[1],alDados[2],alDados[3],alDados[5],alDados[6],PswChave(RetCodUsr()),ddatabase, time()} )  
                    lProcessa := .T.

                    nOpc := 3
                    cRecPag := 'P'

                Endif

            Endif      

            If clFilial == '010001'
                cCusto := '10301010010001'
            Elseif clFilial == '010004'
                cCusto := '10107010010001'
            Elseif clFilial == '010005'
                cCusto := '10303010010001'
            Elseif clFilial == '010006'
                cCusto := '10001010010001'
            Elseif clFilial == '010007'
                cCusto := '10106010010001'
            Elseif clFilial == '010008'
                cCusto := '10005010010001'
            Elseif clFilial == '010009'
                cCusto := '10403010010001'
            Elseif clFilial == '010010'
                cCusto := '10007010010001'
            Elseif clFilial == '010011'
                cCusto := '10003010010001'
            Elseif clFilial == '010012'
                cCusto := '10101010010001'
            Elseif clFilial == '010013'
                cCusto := '10002010010001'
            Elseif clFilial == '010014'
                cCusto := '10105010010001'
            Elseif clFilial == '010015'
                cCusto := '10202010010001'
            Elseif clFilial == '010016'
                cCusto := '10402010010001'
            Elseif clFilial == '010017'
                cCusto := '10103010010001'
            Elseif clFilial == '010018'
                cCusto := '10404010010001'
            Elseif clFilial == '010019'
                cCusto := '10203010010001'
            Elseif clFilial == '010020'
                cCusto := '10302010010001'
            Elseif clFilial == '010021'
                cCusto := '10201010010001'
            Elseif clFilial == '010022'
                cCusto := '10109010010001'
            Elseif clFilial == '010023'
                cCusto := '10108010010001'
            Elseif clFilial == '010024'
                cCusto := '10204010010001'
            Elseif clFilial == '010025'
                cCusto := '10304010010001'
            Elseif clFilial == '010026'
                cCusto := '10006010010001'
            Elseif clFilial == '010027'
                cCusto := '10102010010001'
            Elseif clFilial == '010028'
                cCusto := '10104010010001'
            Elseif clFilial == '010029'
                cCusto := '10004010010001'
            Endif

            If cNatureza $ clExcNts 
                cCusto := ''
            Endif

            If nValor <= 0
                lProcessa := .F.
            Endif  

            If lProcessa

                aFINA100 := {   {"E5_FILIAL"      	,xFilial("SE5")            											,Nil},;
                                {"E5_DATA"        	,CTOD(alDados[1])        											,Nil},;
                                {"E5_MOEDA"       	,"M1"                  												,Nil},;
                                {"E5_VALOR"       	,nValor                                                             ,Nil},;
                                {"E5_NATUREZ"    	,cNatureza	           											    ,Nil},;
                                {"E5_BANCO"         ,cpBanco													        ,Nil},;
                                {"E5_AGENCIA"    	,cpAgencia														    ,Nil},;
                                {"E5_CONTA"         ,cpConta            	        								    ,Nil},;
                                {"E5_VENCTO"        ,CTOD(alDados[1])		         									,Nil},;
                                {"E5_DTDISPO"       ,CTOD(alDados[1])		         									,Nil},;
                                {"E5_DTDIGIT"       ,CTOD(alDados[1])		         									,Nil},;
                                {"E5_RECPAG"      	,cRecPag				        									,Nil},;
                                {"E5_RATEIO"      	,"N"					         									,Nil},;
                                {"E5_ORIGEM"      	,"FINA100"				         									,Nil},;
                                {"E5_CCUSTO"      	,cCusto 				         									,Nil},;
                                {"E5_HISTOR"    	,alDados[2]                                                      	,Nil}}

                MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,nOpc)

                If lMsErroAuto
                    MostraErro()
                Endif 

            Endif

        Endif

    Endif     

RestArea(aArea)

Return cMsgLog

/*/{Protheus.doc} geracsvlog
Gera excel com log de processamento
@type  Function
@author Vinicius Henrique
@since 16/08/2023
@version 1.0
/*/

Static Function geracsvlog(clDir)

Local oExcel 	:= FWMSExcel():New()
Local oExcelApp	:= Nil
Local cAba		:= "Conciliação Bancária"
Local cTabela	:= "Conciliação Bancária"
Local cArquivo	:= "Conciliação Bancária " + dToS( msDate() ) + "_" + strtran(time(), ":", "") + ".XLS"
Local cPath		:= "C:\TEMP\"
Local cDefPath	:= GetSrvProfString( "StartPath", "\system\" )
Local nX		:= 0

oExcel:AddWorkSheet(cAba)
oExcel:AddTable(cAba, cTabela)

oExcel:AddColumn(cAba, cTabela, "STATUS"   		        , 1, 1, .F.)
oExcel:AddColumn(cAba, cTabela, "DATA DO MOVIMENTO"		, 1, 1, .F.)
oExcel:AddColumn(cAba, cTabela, "HISTORICO"			    , 1, 1, .F.)
oExcel:AddColumn(cAba, cTabela, "VALOR"		    		, 1, 1, .F.)
oExcel:AddColumn(cAba, cTabela, "SALDO BANCÁRIO"		, 1, 2, .F.)
oExcel:AddColumn(cAba, cTabela, "USUARIO"				, 1, 2, .F.)
oExcel:AddColumn(cAba, cTabela, "DATA/HORA GERAÇÃO"		, 1, 2, .F.)

For nX := 1 to len(aLog)

    oExcel:AddRow(cAba,;
                 cTabela,;
                {aLog[nX][1]    ,;
                 aLog[nX][2]    ,;
                 aLog[nX][3]    ,;
                 aLog[nX][5]	,;
                 aLog[nX][6]    ,;
                 aLog[nX][7]    ,;
                 DTOC(aLog[nX][8]) + ' / ' + aLog[nX][9]})

Next nX

If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T(cDefPath+cArquivo, clDir)

    if ApOleClient("MSExcel")
        oExcelApp := MsExcel():New()
        oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
        oExcelApp:SetVisible(.T.)
    Endif

    Msginfo('Log de processamento gerado e saldo na pasta onde arquivo que foi processado está.')

EndIf 

return
 
    