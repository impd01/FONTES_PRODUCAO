#INCLUDE "INKEY.CH"
#INCLUDE "GPER1020.CH"
#INCLUDE "protheus.ch"      
#INCLUDE "report.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao     ³ GPER020  ³ Autor ³ RH - Ze Maria                ³ Data ³   03/03/95    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Relacao de Liquidos                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ GPER020                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Generico                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                 ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³  FNC    		³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                                   
±±³Raquel Hager ³14/03/2013³M12RH01   RQ4509³Unificacao da Folha de Pagamento.		   ³±± 
±±³Raquel Hager ³12/11/2013³M12RH01   RQ4504³Alteracoes nas funcoes Gp020BuscaLiq/     ³±±  
±±³             ³          ³                ³fRoteiro/SelecRoteiro.                    ³±±
±±³Sidney O.    ³21/03/2014³M_RH003   294904³Criacao dos totalizadores para Un. Neg. e ³±±  
±±³             ³          ³                ³Empresa                                   ³±±
±±³Sidney O.    ³27/05/2014³M_RH003   294904³Ajuste para empresas que nao usam gestao  ³±±  
±±³             ³          ³                ³corporativa e relatorios sinteticos que   ³±±
±±³             ³          ³                ³nao apresentavam informacoes              ³±±
±±³Sidney O.    ³04/06/2014³M_RH003   294904³Ajuste na ordenacao Bco/Agencia           ³±±
±±³Sidney O.    ³13/06/2014³M_RH003   294904³Ajuste na ordenacao Bco/Agencia / CC      ³±±     
±±³Flavio Correa³22/06/2015³TSRHGG          ³Ajuste na busca da SR para ferias,        ³±±     
±±³             ³          ³                ³RR_DATA = RH_DATAINI                      ³±±
±±³Eduardo K.M  ³14/06/2016³TVIMQO			³Criado nova ordem para impressão do 	   ³±±
±±³			    ³		   ³                ³relatório. ( FILIAL + BANCO/AG).   	   ³±±
±±ºRenan Borges ³17/06/2016³TVGBXY          ³Disponibilizado relatório de resumo por   ³±±
±±º             ³          ³                ³competência, sendo possível a impressão   ³±±
±±º             ³          ³                ³para todos os processos em uma determinada³±±
±±º             ³          ³                ³competência.                              ³±±
±±ºP. Pompeu....³28/06/2016³TVLNVO          ³Correção para quando a funcao BuscLiq era ³±±
±±º             ³          ³ 				³chamada do fonte GPEM080.                 ³±±
±±ºRaquel Hager ³17/06/2016³TVGBXY          ³Troca de grupo de perguntas para acerto de³±±
±±º             ³          ³                ³falha criada por UPDDISTR.				   ³±±
±±³Jonathan Glez³18/01/2016³PCREQ-7944      ³Localizacion GPE CHI v12.                 ³±±
±±³             ³          ³                ³-Se elimina columna FUNCBENEF para CHILE. ³±±
±±³             ³          ³                ³-Se cambia el emcabezado  del informe por ³±±
±±³             ³          ³                ³"RELACION DE LIQUIDO A PAGAR".            ³±±
±±³             ³          ³                ³-Modifcaciones a diccionario.(Menu/Pergun)³±±
±±ºAllyson M    ³10/02/2017³MRH-5930        ³Ajuste em fRoteiro() p/ exibir roteiro ADI³±±
±±º             ³          ³                ³fno relatório GPER670.				   	   ³±±
±±ºRenan Borges ³10/03/2017³MRH-5946        ³Ajuste para ao gerar o relatório de líqui-³±±
±±º             ³          ³                ³dos com a pergunta "TOTALIZA AGÊNCIA =    ³±±
±±º             ³          ³                ³SIM", o sistema totalize corretamente inde³±±
±±º             ³          ³                ³pendente se esta sendo impresso só funcio-³±±
±±º             ³          ³                ³nários, ou só beneficiários.              ³±±
±±ºGabriel A.   ³24/03/2017³MRH-8458        ³Ajuste na "picture" do campo agência e    ³±±
±±º             ³          ³                ³para demonstrar sempre o totalizador por  ³±±
±±º             ³          ³                ³banco.                                    ³±±
±±ºJônatas A.   ³09/05/2017³DRHPAG-1661     ³Ajuste para exclusão das condições que    ³±±
±±º             ³          ³                ³validavam data de demissão. Os roteiros e ³±±
±±º             ³          ³                ³verbas não se sobrepõem, a duplicidade é  ³±±
±±º             ³          ³                ³validada apenas para pensões alim.        ³±±
±±ºCecília C.   ³05/07/2017³DRHPAG-3730     ³Ajuste para impresão de Líquidos p/ func. ³±±
±±º             ³          ³                ³transferidos.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Function GPER020()
Local 	oReport 	
Private nPgQuant	:= 0
Private nPgValor	:= 0                                                      

	// Interface de impressao
	Pergunte("GPE20R3",.F.)        
   	oReport := ReportDef()
   	oReport:PrintDialog()    

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ReportDef ³ Autor ³ RH - Tatiane Matias  ³ Data ³ 13/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Definicao do relatorio.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()
Local oReport 
Local oSection
Local oTransp
Local cDesc		:=	( IIF( cPaisLoc == "CHI" , STR0064 + ". " , STR0011 )) + STR0012 + ". "+STR0013 //"Relacao de Liquidos." # "Ser  impresso de acordo com os parametros solicitados pelo" # //"usu rio."
Local aOrd	  	:=	{	STR0001,;	//"Filial+Bco/Ag.+Mat"
			 			STR0002,;	//"Filial+Bco/Ag.+Cc+Mat"
						STR0003,;	//"Filial+Bco/Ag.+Nome"
						STR0004,;	//"Filial+Bco/Ag.+Cta"
						STR0005,;	//"Filial+Bco/Ag.+Cc+Nome"
						STR0006,;	//"Bco/Ag.+Mat"
						STR0007,;	//"Bco/Ag.+Cc+Mat"
						STR0008,;	//"Bco/Ag.+Nome"
						STR0009,;	//"Bco/Ag.+Cta"
						STR0010,;	//"Bco/Ag.+Cc+Nome"
						STR0065}	//"Filial+Bco/Ag."
Local cTitBcAg	:= GetSx3Cache("RA_BCDEPSA", "X3_TITULO")

    If cPaisLoc == "MEX" 
    	aAdd( aOrd, STR0059 )  //Filial+Localidade de Pago
	EndIf

	DEFINE REPORT oReport NAME "GPER020" TITLE IIF(cPaisLoc == "CHI",OemToAnsi(STR0064),  OemToAnsi(STR0018)) PARAMETER "GPE20R3" ACTION {|oReport| PrintReport(oReport)} DESCRIPTION cDesc TOTAL IN COLUMN PAGE TOTAL IN COLUMN

		DEFINE SECTION oSection OF oReport TABLES "SRA" ORDERS aOrd TOTAL IN COLUMN TITLE STR0058
		oSection:SetHeaderBreak(.T.)
		
			DEFINE CELL NAME "RA_FILIAL" 	OF oSection ALIAS "SRA"
			DEFINE CELL NAME "RA_BCDEPSA"	OF oSection ALIAS "SRA" SIZE 10 TITLE cTitBcAg
			DEFINE CELL NAME "RA_CC"		OF oSection ALIAS "SRA"
			DEFINE CELL NAME "RA_MAT" 		OF oSection ALIAS "SRA"
			DEFINE CELL NAME "RA_NOME" 		OF oSection ALIAS "SRA"
			DEFINE CELL NAME "RA_CIC" 		OF oSection ALIAS "SRA"
			DEFINE CELL NAME "RA_CTDEPSA" 	OF oSection ALIAS "SRA"
			DEFINE CELL NAME "VALOR" 		OF oSection ALIAS "   " ALIGN RIGHT TITLE STR0048 PICTURE "@E  99,999,999,999.99" SIZE 17
			if cPaisLoc <> "CHI"
				DEFINE CELL NAME "FUNCBENEF" 	OF oSection ALIAS "   "
			endif
			If cPaisLoc == "MEX"
				DEFINE CELL NAME "RA_KEYLOC" OF oSection ALIAS "SRA"
			EndIf
			
			// Total de Pagina                                       
			DEFINE FUNCTION NAME "PAGQUANT" FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT PRINT WHEN {|| oSection:GetFunction("PAGQUANT"):PageValue() > 0 } NO END SECTION NO END REPORT END PAGE
			DEFINE FUNCTION NAME "PAGVALOR" FROM oSection:Cell("VALOR")			FUNCTION SUM 	PRINT WHEN {|| oSection:GetFunction("PAGVALOR"):PageValue() > 0 } PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT END PAGE
	
			// Transportado Pagina Anterior
			DEFINE FUNCTION oTransp NAME "TPAGQUANT" FROM oSection:Cell("RA_CTDEPSA")	FUNCTION ONPRINT FORMULA {|| nPgQuant += oSection:GetFunction("PAGQUANT"):PageValue(), nPgQuant - oSection:GetFunction("PAGQUANT"):PageValue()} PRINT WHEN {|| nPgQuant <> oSection:GetFunction("PAGQUANT"):PageValue() .And. oSection:GetFunction("TPAGQUANT"):PageValue() > 0 } NO END SECTION NO END REPORT END PAGE
			DEFINE FUNCTION 		NAME "TPAGVALOR" FROM oSection:Cell("VALOR")		FUNCTION ONPRINT FORMULA {|| nPgValor += oSection:GetFunction("PAGVALOR"):PageValue(), nPgValor - oSection:GetFunction("PAGVALOR"):PageValue()} PRINT WHEN {|| nPgValor <> oSection:GetFunction("PAGVALOR"):PageValue() .And. oSection:GetFunction("TPAGVALOR"):PageValue() > 0 } PICTURE "@E  99,999,999,999.99"  NO END SECTION NO END REPORT END PAGE
			
			oTransp:SetTitle(STR0027) // "TRANSPORTADO PAGINA ANTERIOR    "
			oTransp:ShowHeader()

Return( oReport )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PrintReport ³ Autor ³ RH - Tatiane Matias   ³ Data ³ 13/06/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Liquidos - Release 3                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport)  
// Objeto
Local oSection 	:= oReport:Section(1)    
Local oBreakTPg
Local oBreakCc
Local oBreakAg
Local oBreakBc
Local oBreakFil
Local oBreakUnN
Local oBreakEFil
Local oBreakLP
// Array
Local aValBenef 	:= {}
Local aCodFol  		:= {}   
Local aVerba		:= {} 
// Bloco
Local bCond			:= {||}
// String
Local cTitulo		:= ""
Local cCabec		:= STR0016 //"                                     |-------  F U N C I O N A R I O  -------|                                   "
Local cAliasX		:= ""   
Local cSitQuery	:= ""      
Local cCatQuery	:= ""
Local cOrdem		:= ""           
Local cArqNtx		:= ""   
Local cFiltro		:= ""    
Local cParBanco 	:= ""
Local cParConta 	:= ""
Local cRProc		:= ""
Local cAuxPrc		:= ""
Local cTitFil		:= ""
Local cTitUnN		:= ""
Local cTitEFil		:= ""
Local cTitCc		:= ""
Local cTitLP		:= ""
//-- Numerico
Local nOrdem		:= oSection:GetOrder()
Local nReg			:= 0
Local nValor    	:= 0  
Local nValor2    	:= 0  
Local nValBenef		:= 0
Local nTamCod		:= 0
Local nTPgQuant		:= 0
Local nTPgValor		:= 0
Local nVerba        := 0
Local lFuncTrf    := .F.
	
Private nTamBcAg	:= GetSx3Cache( "RA_BCDEPSA" , "X3_TAMANHO" )
Private cPicBcAg	:= GetSx3Cache( "RA_BCDEPSA" , "X3_PICTURE" )
Private nTamBco		:= 0
Private nTamAge		:= 0	
// String
Private cUltAg 		:= ""
Private cBcoUlt  	:= ""	
// Variaveis de Acesso do Usuario                               
Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER020" , "SRA" , "2" ) + " } " )
Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER020" , "SRC" , "2" ) + " } " )
Private cAcessaSRD	:= &( " { || " + ChkRH( "GPER020" , "SRD" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER020" , "SRR" , "2" ) + " } " )
Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER020" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER020" , "SRH" , "2" ) + " } " )	
// Array                                                                  
Private aInfo			:= {}
Private aRoteiros		:= {}

Private lCorpManage	:= fIsCorpManage( FWGrpCompany() )	// Verifica se o cliente possui Gestão Corporativa no Grupo Logado

	If lCorpManage
		Private lUniNeg	:= !Empty(FWSM0Layout(cEmpAnt, 2)) // Verifica se possui tratamento para unidade de Negocios
		Private lEmpFil	:= !Empty(FWSM0Layout(cEmpAnt, 1)) // Verifica se possui tratamento para Empresa
		Private cLayoutGC 	:= FWSM0Layout(cEmpAnt)
		Private nStartEmp	:= At("E",cLayoutGC)
		Private nStartUnN	:= At("U",cLayoutGC)
		Private nEmpLength	:= Len(FWSM0Layout(cEmpAnt, 1))
		Private nUnNLength	:= Len(FWSM0Layout(cEmpAnt, 2))
	EndIf

	If Empty(cPicBcAg)
		cPicBcAg := '@R 999/99999'
	EndIf 
	
	nTamBco := At( "/" , cPicBcAg ) - At( "9" , cPicBcAg )
	nTamAge := nTamBcAg - nTamBco   

	// Carregando array aRoteiros com os roteiros selecionados      
	// em mvpar01, mvpar02 e mvpar03.                               
	If Len(MV_PAR01) > 0 .Or. Len(MV_PAR02) > 0 .Or. Len(MV_PAR03) > 0
		SelecRoteiros()	
	EndIf
	
	lRescisao   := .F. 	// Definida para utilizacao em fBuscaLiq()
	ComConta	:= If(MV_PAR04 == 1,"C",(If(MV_PAR04 == 2,"S","A")))	                // Qto. a Conta Corrente 
	cSituacao	:= MV_PAR11																// Situacao
	Quebloc		:= If(MV_PAR12 == 1,.T.,.F.)											// Totalizar por Filial
	cSalta		:= If(MV_PAR13 == 1,"S","N")											// Imprime Filial em Outra Pagina 
	LstNome		:= If(MV_PAR14 == 1,"S","N")											// Mostrar Nomes dos Funcionarios
	dDataDe		:= MV_PAR15																// Data Pagamento De
	dDataAte	:= MV_PAR16																// Data Pagamento Ate
	cSaltaAg	:= If(MV_PAR17 == 1,"S","N")											// Quebra Pagina p/Agencia   Sim,Nao 
	cTotAgen	:= If(MV_PAR18 == 1,"S","N")											// Totaliza por Agencia 
	cTipoRel	:= If(MV_PAR19 == 1, "A" , "S" )										// Tipo de Relacao:1-Analitica, 2-Sintetica 
	nFunBenAmb  := MV_PAR20  															// Imprimir : 1-Funcionarios  2-Beneficiarias  3-Ambos
	cCategoria	:= MV_PAR21 															// Categorias
	cProcessos	:= If( Empty(MV_PAR22),"", AllTrim(MV_PAR22) )							// Processos para Impressao
	cBanco    	:= MV_PAR07 															// Banco
	cConta 		:= MV_PAR10																// Conta
	
	// Altera o titulo do relatorio
	if cPaisLoc == "CHI"
		cTitulo := STR0064 //"RELACION DE LIQUIDO A PAGAR"
	else
		cTitulo := STR0018	//"RELACAO DE LIQUIDOS"
	endif
	cTitulo += " ("+StrZero( nOrdem , 2 )+")"+ IF(cTipoRel="A",STR0041,STR0042) //Analitica###Sintetica
	If !(AllTrim(oReport:Title())==AllTrim(IIF(cPaisLoc == "CHI", OemToAnsi(STR0019),  OemToAnsi(STR0018))))
		cTitulo	:= oReport:Title()
	Endif
     
/*
    If (nOrdem >= 6 .AND. nOrdem <= 10) // Nao efetuar quebra por filial / UN / Empresa nas ordens de Bco/Ag 
		Quebloc := .F.
    EndIf
*/
    
	//------------------------------------------------------------
	// Total Centro de Custo
	//------------------------------------------------------------
	If (nOrdem == 2 .Or. nOrdem == 5 .Or. nOrdem == 7 .Or. nOrdem == 10)

		If (nOrdem == 2 .Or. nOrdem == 5) .AND. Quebloc
			DEFINE BREAK oBreakCc OF oSection WHEN {|| oSection:Cell("RA_FILIAL"):GetText() + Iif(Empty(oSection:Cell("RA_BCDEPSA"):GetText()), Space(nTamBcAg), oSection:Cell("RA_BCDEPSA"):GetText()) + oSection:Cell("RA_CC"):GetText()}
			oBreakCc:OnBreak({|x,y|cTitCc:=OemToAnsi(STR0029)+Substr(x,Len(oSection:Cell("RA_FILIAL"):GetText())+nTamBcAg+1)})	//"Total Centro de Custo"
		Else
			DEFINE BREAK oBreakCc OF oSection WHEN {|| Iif(Empty(oSection:Cell("RA_BCDEPSA"):GetText()), Space(nTamBcAg), oSection:Cell("RA_BCDEPSA"):GetText()) + oSection:Cell("RA_CC"):GetText()}
			oBreakCc:OnBreak({|x,y|cTitCc:=OemToAnsi(STR0029)+Substr(x,nTamBcAg+1)})	//"Total Centro de Custo"
		EndIf

		DEFINE FUNCTION FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT BREAK oBreakCc NO END SECTION NO END REPORT
		DEFINE FUNCTION FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakCc  PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT

		oBreakCc:SetTotalText({||cTitCc})
	EndIf

	//------------------------------------------------------------
	// Total Agencia
	//------------------------------------------------------------
	// Verifica se deseja totalizar por Agencia
	If cTotAgen == "S"
		If (nOrdem >= 1 .AND. nOrdem <= 5) .AND. Quebloc
			DEFINE BREAK oBreakAg OF oSection WHEN {|| oSection:Cell("RA_FILIAL"):GetText() + oSection:Cell("RA_BCDEPSA"):GetText()}
			oBreakAg:OnBreak({|x| cUltAg := Substr(x,Len(oSection:Cell("RA_FILIAL"):GetText())+nTamBco+1)})
		Else
			DEFINE BREAK oBreakAg OF oSection WHEN {|| oSection:Cell("RA_BCDEPSA"):GetText()}
			oBreakAg:OnBreak({|x| cUltAg := AllTrim(SubStr(x,nTamBco+1,nTamAge))})
		EndIf
	
			oBreakAg:SetTotalText({||STR0031 + cUltAg})
			If cSaltaAg == "S"
				oBreakAg:SetPageBreak(.T.)
			EndIf    
			
			DEFINE FUNCTION FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT 	BREAK oBreakAg 	 NO END SECTION NO END REPORT
			DEFINE FUNCTION FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakAg   PICTURE "@E  99,999,999,999.99"  NO END SECTION NO END REPORT
	EndIf

	
	//------------------------------------------------------------
	// Total Local de Pago
	//------------------------------------------------------------
	If cPaisLoc == "MEX" .And. nOrdem == 11
		DEFINE BREAK oBreakLP OF oSection WHEN {|x| oSection:Cell("RA_FILIAL"):GetText() + oSection:Cell("RA_KEYLOC"):GetText() } TITLE STR0060
		DEFINE FUNCTION FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT BREAK oBreakLP NO END SECTION
		DEFINE FUNCTION FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakLP  PICTURE "@E  99,999,999,999.99" NO END SECTION	
		oBreakLP:OnBreak({|x,y|cTitLP:=OemToAnsi(STR0060)+x})	//"Total da Local de Pago"
		oBreakLP:SetTotalText({||cTitLP})
	EndIf		
	
		//------------------------------------------------------------
		// Total Banco
		//------------------------------------------------------------
		If (nOrdem >= 1 .AND. nOrdem <= 5) .AND. Quebloc .And. (nOrdem <> 11)
			DEFINE BREAK oBreakBc OF oSection WHEN {|| oSection:Cell("RA_FILIAL"):GetText() + SubStr(oSection:Cell("RA_BCDEPSA"):GetText(),1,nTamBco)}
			oBreakBc:OnBreak({|x| cBcoUlt := SubStr(x, Len(oSection:Cell("RA_FILIAL"):GetText())+1)})
		ElseIf (nOrdem >= 6 .OR. nOrdem <= 10) .OR. ((nOrdem >= 1 .AND. nOrdem <= 6) .AND. !Quebloc)
			DEFINE BREAK oBreakBc OF oSection WHEN {|| SubStr(oSection:Cell("RA_BCDEPSA"):GetText(),1,nTamBco)}
			oBreakBc:OnBreak({|x| cBcoUlt := x})
		EndIf

			oBreakBc:SetTotalText({||STR0033 + cBcoUlt})
			
			DEFINE FUNCTION FROM oSection:Cell("RA_BCDEPSA") 	FUNCTION COUNT BREAK oBreakBc  NO END SECTION
			DEFINE FUNCTION FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakBc  PICTURE "@E  99,999,999,999.99"  NO END SECTION

			If cSaltaAg == "S"
				oBreakBc:SetPageBreak(.T.)
			EndIf 
   
	//------------------------------------------------------------
	// Total Filial
	//------------------------------------------------------------
	// Verifica se deseja totalizar por Filial
	If (Quebloc .And. (nOrdem <= 5 .Or. If(cPaisLoc == "MEX", nOrdem == 11, .F.))) .OR. (cTipoRel == "S" .AND. (nOrdem >= 1 .AND. nOrdem <= 5))
		DEFINE BREAK oBreakFil OF oSection WHEN oSection:Cell("RA_FILIAL") TITLE STR0035
		If cSalta == "S"
			oBreakFil:SetPageBreak(.T.)
		EndIf 
		
		oBreakFil:OnBreak({|x,y|cTitFil:=OemToAnsi(STR0035)+x})	//"Total da Filial"
		oBreakFil:SetTotalText({||cTitFil})
		
		DEFINE FUNCTION FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT BREAK oBreakFil NO END SECTION NO END REPORT
		DEFINE FUNCTION FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakFil PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT

		If lCorpManage
			If lUniNeg
				DEFINE BREAK oBreakUnN OF oSection WHEN { || Substr((cAliasX)->RA_FILIAL, nStartUnN, nUnNLength) }

				If cSalta == "S"
					oBreakUnN:SetPageBreak(.T.)
				EndIf 

				oBreakUnN:OnBreak({ |x, y| cTitUnN := OemToAnsi(STR0063) + " " + x})	//"Total Unidade de Negocios:"
				oBreakUnN:SetTotalText({ || cTitUnN })
				oBreakUnN:SetTotalInLine(.F.)

				DEFINE FUNCTION NAME "FUNNCTDESPSA" FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT BREAK oBreakUnN NO END SECTION NO END REPORT
				DEFINE FUNCTION NAME "FUNNVALOR" FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakUnN PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT
			EndIf   	 
			If lEmpFil
				DEFINE BREAK oBreakEFil OF oSection WHEN { || Substr((cAliasX)->RA_FILIAL, nStartEmp, nEmpLength) }

				If cSalta == "S"
					oBreakEFil:SetPageBreak(.T.)
				EndIf 

				oBreakEFil:OnBreak({ |x,y| cTitEFil := OemToAnsi(STR0037) + " " + x})	//"Total Empresa"
				oBreakEFil:SetTotalText({ || cTitEFil })
				oBreakEFil:SetTotalInLine(.F.)

				DEFINE FUNCTION NAME "FEFCTDESPSA" FROM oSection:Cell("RA_CTDEPSA") 	FUNCTION COUNT BREAK oBreakEFil NO END SECTION NO END REPORT
				DEFINE FUNCTION NAME "FEFVALOR" FROM oSection:Cell("VALOR") 		FUNCTION SUM 	BREAK oBreakEFil PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT
			EndIf   
		EndIf

	EndIf
	
	//------------------------------------------------------------
	// Total Filial + Banco
	//------------------------------------------------------------
	// Verifica se deseja totalizar por Filial e Banco

	If nOrdem == 11	 
		DEFINE BREAK oBreakFil OF oSection WHEN {||"RA_FILIAL"+"RA_BCDEPSA"} TITLE STR0035
								
		DEFINE FUNCTION NAME "CTDESPSA" FROM oSection:Cell("RA_CTDEPSA") FUNCTION COUNT BREAK oBreakFil NO END SECTION NO END REPORT
		DEFINE FUNCTION NAME "VALOR" FROM oSection:Cell("VALOR") FUNCTION SUM BREAK oBreakFil NO END SECTION NO END REPORT
	
		If cSalta == "S"
			oBreakFil:SetPageBreak(.T.)
		EndIf
	EndIf	
*/
	////Define se devera ser impresso Funcionarios ou Beneficiarios 
	dbSelectArea( "SRQ" )
	lImprFunci  := ( nFunBenAmb # 2 )
	lImprBenef  := ( nFunBenAmb # 1 )

	// Informa a nao existencia dos campos de bco/age/conta corrente
	If nFunBenAmb # 1 .And. !lImprBenef
		fAvisoBC()
		Return .F.
	Endif
	
	If lImprBenef
		If nFunBenAmb == 2
			cCabec := STR0043		//"                                     -------  B E N E F I C I A R I O  -------                                   "
		Else
			cCabec := STR0044		//"                         -------  F U N C I O N A R I O / B E N E F I C I A R I O  -------                       "
		EndIf
	EndIf

	oReport:OnPageBreak({|| oReport:SkipLine(),oReport:PrintText(cCabec)})
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro

	MakeSqlExpr("GPE20R3")	
	// Faz filtro no arquivo...                                                 
	// Monta a string de Processos para Impressao                   
	If AllTrim(cProcessos) <> "*"
		cRProc := ""
		nTamCod := GetSx3Cache( "RCJ_CODIGO" , "X3_TAMANHO" )
		For nReg := 1 to Len(cProcessos) Step 5
			If Len(Subs(cProcessos,nReg,5)) < nTamCod
				cAuxPrc := Subs(cProcessos,nReg,5) + Space(nTamCod - Len(Subs(cProcessos,nReg,5)))
			Else
				cAuxPrc := Subs(cProcessos,nReg,5)
			EndIf
			cRProc += cAuxPrc
			If ( nReg+5 ) <= Len(cProcessos)
				cRProc += "','"
			EndIf
		Next X
		cFiltro += "SRA.RA_PROCES IN ('"+ cRProc + "') "
	EndIf

	// Adiciona no filtro o parametro tipo Range   
	
	// Filial
	If !Empty(mv_par05)
		cFiltro += If( !Empty(cFiltro), " AND " + MV_PAR05, MV_PAR05 )
	EndIf
	
	// Centro de Custo
	If !Empty(mv_par06)
		cFiltro += If( !Empty(cFiltro), " AND  " + MV_PAR06, MV_PAR06 )
	EndIf  
	
	// Banco/Ag
	If !Empty(mv_par07)
		cFiltro += If( !Empty(cFiltro), " AND"  + MV_PAR07, MV_PAR07 )
	EndIf 
	
	// Matricula
	If !Empty(mv_par08)
		cFiltro += If( !Empty(cFiltro), " AND " + MV_PAR08, MV_PAR08 )
	EndIf 
	
	// Nome
	If !Empty(mv_par09)
		cFiltro += If( !Empty(cFiltro), " AND " + MV_PAR09, MV_PAR08 )
	EndIf 
	
	// Conta Corrente
	If !Empty(mv_par10)      
		cFiltro += If( !Empty(cFiltro), " AND " + MV_PAR10, MV_PAR08 )
	EndIf

	cFiltro := If( !Empty(cFiltro), "% " + cFiltro + " AND %", "%%" )
    
	// Neste caso foi utilizado o alias fixo com o mesmo nome da tabela (e nao GetNextAlias, conforme o 
	// padrao de programacao), pois neste relatorio existe chamadas para outras funcoes e essas funcoes 
	// utilizam sempre "SRA".
	cAliasX := "SRA"
	// Modifica variaveis para a Query
	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += "," 
		EndIf
	Next nReg     
	cSitQuery := "%" + cSitQuery + "%"
	
	cCatQuery := ""
	For nReg:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cCategoria)
			cCatQuery += "," 
		EndIf
	Next nReg
	cCatQuery := "%" + cCatQuery + "%"	            

	If nOrdem == 1
		If Quebloc
			cOrdem += "%RA_FILIAL, RA_BCDEPSA,RA_MAT%"
		Else
			cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_MAT%"
		EndIf
	ElseIf nOrdem == 2
		If Quebloc
			cOrdem += "%RA_FILIAL, RA_BCDEPSA, RA_CC, RA_MAT%"
		Else
			cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_CC, RA_MAT%"
		EndIf
	ElseIf nOrdem == 3
		If Quebloc
			cOrdem += "%RA_FILIAL, RA_BCDEPSA, RA_NOME%"
		Else
			cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_NOME%"
		EndIf
	Elseif nOrdem == 4
		If Quebloc
			cOrdem += "%RA_FILIAl, RA_BCDEPSA, RA_CTDEPSA%"
		Else
			cOrdem += "%RA_BCDEPSA, RA_FILIAl, RA_CTDEPSA%"
		EndIf
	ElseIf nOrdem == 5
		If Quebloc
			cOrdem += "%RA_FILIAL, RA_BCDEPSA, RA_CC, RA_NOME%"
		Else
			cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_CC, RA_NOME%"
		EndIf
	ElseIf nOrdem == 6
		cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_NOME%"
	ElseIf nOrdem == 7
		cOrdem += "%RA_BCDEPSA, RA_CC, RA_FILIAL, RA_MAT%"
	Elseif nOrdem == 8
		cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_NOME%"
	ElseIf nOrdem == 9
		cOrdem += "%RA_BCDEPSA, RA_FILIAL, RA_CTDEPSA%"
	ElseIf nOrdem == 10
		cOrdem += "%RA_BCDEPSA, RA_CC, RA_FILIAL, RA_NOME%"
	ElseIf nOrdem == 11  .And. cPaisLoc == "MEX"
		cOrdem += "%RA_FILIAL, RA_KEYLOC, RA_NOME%"
	Elseif nOrdem == 11
		cOrdem += "%RA_FILIAL, RA_BCDEPSA%"
		EndIf
                 
	//NAO RETIRAR ESTA LINHA
	//Este relatorio abre a query abaixo com o nome de "SRA" e
	//como a tabela "SRA" eh utilizada em varios outros programas,
	//foi preciso fechar primeiro a area para depois poder utiliza-la.
	SRA->( dbCloseArea() )
		
	BeginSql alias cAliasX
		SELECT *
		FROM %table:SRA% SRA
		WHERE SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
			   SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
			   %exp:cFiltro% 
			   SRA.%notDel%   
		ORDER BY %exp:cOrdem%       
	EndSql
	
	// Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	// parametro a pergunta ou vetor com perguntas do tipo Range que foramadmin	 alterados 
   	// pela funcao MakeSqlExpr para serem adicionados a query
	    
	FilAnt := Replicate("!", FWGETTAMFILIAL)

	// Define o total da regua da tela de processamento do relatorio
	oReport:SetMeter((cAliasX)->( RecCount() ))  
	
	// Incializa impressao   
	oSection:Init(.F.)                                 
	
	While (cAliasX)->( !EOF() )                   
	
		// Incrementa a regua da tela de processamento do relatorio
  		oReport:IncMeter()
                                
		// Verifica se o usuario cancelou a impressao do relatorio
		If oReport:Cancel()
			Exit
		EndIf               

		nValor    	:= 0 
		nValor2		:= 0
		aValBenef 	:= {}

		If (cAliasX)->RA_FILIAL # FilAnt
			If !Fp_CodFol(@aCodFol,(cAliasX)->RA_FILIAL) .Or. !fInfo(@aInfo,(cAliasX)->RA_FILIAL)
				Exit
			EndIf
			FilAnt := (cAliasX)->RA_FILIAL
		EndIf 
		
		If !Empty(oSection:aUserFilter) .And. !Empty(oSection:aUserFilter[1,2]) .And. !(cAliasX)->&(oSection:aUserFilter[1,2])
			(cAliasX)->( dbSkip() )
			Loop
        EndIf

		// Consiste controle de acessos e filiais validas               
		If !((cAliasX)->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			(cAliasX)->( dbSkip() )
			Loop
		EndIf

       lFuncTrf := .F.
		// Verif. se Demitido esta dentro da Data de Pagamento do Parametro
		// No Mexico pode alterar status para D e nao calcular a rescisao. 
		If (cAliasX)->RA_SITFOLH <> "T" //se estiver como "T", busca os valores. Senão, verifica se na transferência foi gravado como "D".
			If ((cAliasX)->RA_SITFOLH == "D") .And. cPaisLoc <> "MEX"
				dbSelectArea("SRG") 
				If dbSeek( (cAliasX)->(RA_FILIAL + RA_MAT )  )
					While !( SRG->( Eof() ) )  .And. (cAliasX)->(RA_FILIAL + RA_MAT ) ==  SRG->(RG_FILIAL + RG_MAT )
						If SRG->RG_DATAHOM >= dDataDe .And. SRG->RG_DATAHOM <= dDataAte 
							lRescisao := .T.
						EndIf
						SRG->( dbSkip()) 
					Enddo
				Else
				    //Antes de ir para o próximo funcionário, verificar se não é transferência
				    If (cAliasX)->RA_AFASFGT $ "N1/N2/N3"
			            lFuncTrf := .T.
			       ElseIf (cAliasX)->RA_RESCRAI $ "31/32"
	     		        lFuncTrf := .T.
			       EndIf
			       If !lFuncTrf			    
						dbSelectArea("SRA")		 
						(cAliasX)->( dbSkip() )
						Loop
	              EndIf
				EndIf
			EndIf 	
       EndIf
		
		// Busca os valores de Liquido e beneficios                     
		Gp020BuscaLiq(@nValor,@aValBenef)  
		
		// Ponto de Entrada para despresar funcionario caso retorne .F. 
		// Identico ao ponto de entrada GP450DES de geracao dos liquidos
		If ExistBlock("GP020DES")
			If !(ExecBlock("GP020DES",.F.,.F.))
				dbSelectArea( "SRA" )
				SRA->(dbSkip())
				Loop
			EndIf
		EndIf
			
		// Consiste parametros de banco e conta do funcionario			
		// Se nFunBenAmb=2, apenas sera testado a Bco e conta do Beneficario

		If nFunBenAmb # 2 	.And.  ;	//Se nao for Beneficiario, testa Bco e Conta do Funcionario 
		   (( ComConta = "C" .And. (cAliasX)->RA_CTDEPSA == Space(Len((cAliasX)->RA_CTDEPSA)) .And. nFunBenAmb # 2) .Or.;
			 ( ComConta = "S" .And. (cAliasX)->RA_CTDEPSA #  Space(Len((cAliasX)->RA_CTDEPSA)) .And. nFunBenAmb # 2))
			nValor := 0
		EndIf

		// Consiste parametros de banco e conta do beneficiario 		  
		// aValBenef: 1-Nome  2-Banco  3-Conta  4-Verba  5-Valor  6-CPF 
		If Len(aValBenef) > 0 
			aBenefCop  := aClone(aValBenef) 
			aValBenef  := {} 
					
			If ( nFunBenAmb == 2 .Or. nFunBenAmb == 3)   

				// Como as perguntes Banco e Conta sao do tipo Range, para fazer o aEval no
				// array aBenefCop, foi preciso substituir os campos da expressao (pergunte range)
				// por X[2] ou X[3]. 
				// Ex.: Pergunte range tem o seguinte conteudo:
				//--			(((cAliasX)->RA_CTDEPSA >= '000000000001' .AND. (cAliasX)->RA_CTDEPSA <= '999999999999'))
				//--      substituindo:
				//--			((X[3] >= '000000000001' .AND. X[3] <= '999999999999'))			
				mv_par07 := cBanco
				mv_par10 := cConta
				MakeAdvplExpr("GPE20R3")			

				cParBanco := ""
				cParConta := ""
				                   
				cParBanco := StrTran(mv_par07, "RA_BCDEPSA","X[2]") 
				cParConta := StrTran(mv_par10, "RA_CTDEPSA","X[3]") 

				If ComConta == "C" 					// Beneficiario e  com Conta, testo a Conta 
					If !Empty(cParBanco) .And. !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And. ( ' + cParConta + ' .And. !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					ElseIf !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And. ( !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					ElseIf !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParConta + ' .And. !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					Else
						&('Aeval(aBenefCop, { |X| If(	( !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					EndIf

				ElseIf ComConta == "S"				// Se for beneficiario,  sem  Conta 
					If !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And.  ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) , AADD(aValBenef,X ), ""  )  })')
					Else
						&('Aeval(aBenefCop, { |X| If(	( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) , AADD(aValBenef,X ), ""  )  })')
					EndIf
					
				ElseIf ComConta == "A" 
					If !Empty(cParBanco) .And. !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParBanco + ' ) .And. ( ' + cParConta + ' ) ) .Or. ( 	( ' + cParBanco + ' ) .And.  ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), AADD(aValBenef,X ), ""  )  })')
					ElseIf !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParBanco + ' ) ) , AADD(aValBenef,X ), ""  )  })')
					ElseIf !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParConta + ' ) ), AADD(aValBenef,X ), ""  )  })')
					Else
						&('Aeval(aBenefCop, { |X| AADD(aValBenef,X ) })')
					EndIf
				EndIf 
			EndIf	
		EndIf

		// 1- Testa Com Conta								 		 
		// 2- Testa Sem Conta								 		 
		// 3- Testa se Valor == 0							 		 
		// 4- Testa se beneficiario              					 	
		If	( nValor == 0 .And. Len(aValBenef) == 0 ) .Or. ;
			( nFunBenAmb == 2 .And. Len(aValBenef) == 0) 
			(cAliasX)->( dbSkip() )
			Loop
		EndIf

		nValBenef := 0  
		If nValor > 0
		// Alteracao do conteudo das colunas                 		     
		// Verifica o conteudo que sera impresso na coluna nome conforme parametro.
		If LstNome <> "S"
			// Atualiza campo nome
			oSection:Cell("RA_NOME"):SetBlock({|| STR0040}) // "***  N o m e   Oculto   ***   "
		EndIf      
		
		// Atualiza campo Valor
	   	oSection:Cell("VALOR"):SetBlock({|| nValor})
	   	 
		if cPaisLoc <> "CHI"		
			If Len(aValBenef) > 0
	   			oSection:Cell("FUNCBENEF"):SetValue("-" + STR0045) // "-Func."			     
			Else  
				oSection:Cell("FUNCBENEF"):SetValue("")
			EndIf
		endif
	 	
	 	If cTipoRel == "S"	// So Imprime Dados dos Funcionarios quando Relacao For Analitica.
			// Habilita a impressao das colunas
			oSection:SetHeaderBreak(.F.)               		  
			oSection:Hide()
		EndIf  

		oSection:PrintLine()		 
		EndIf
	 
		// Impressao dos Beneficiarios                          		 
	  	For nReg := 1 To Len(aValBenef) 
			If !Empty(aValBenef[nReg,1]) .And. aValBenef[nReg,5] > 0 
				
				// Alteracao do conteudo das colunas                    		  
				// Verifica o conteudo que sera impresso na coluna nome conforme parametro.
				// Atualiza campo nome
				If LstNome = "S"
					oSection:Cell("RA_NOME"):SetBlock({|| Subs(aValBenef[nReg,1],1,30) })
				Else
					oSection:Cell("RA_NOME"):SetBlock({|| STR0040 })
				EndIf             
				
				// Atualiza campo Banco
				oSection:Cell("RA_BCDEPSA"):SetBlock({|| aValBenef[nReg,2] })
				// Atualiza campo nome
				oSection:Cell("RA_CIC"):SetBlock({|| aValBenef[nReg,6]})
				// Atualiza campo Conta
				oSection:Cell("RA_CTDEPSA"):SetBlock({|| aValBenef[nReg,3]})
				// Atualiza campo Valor
				oSection:Cell("VALOR"):SetBlock({|| aValBenef[nReg,5]})

				if cPaisLoc <> "CHI"
	   				oSection:Cell("FUNCBENEF"):SetValue("-" + STR0046) // "-Benef."
	   			endif

                // Atualiza campo Valor 2 - Uruguai

			 	If cTipoRel == "S"	// So Imprime Dados dos Funcionarios quando Relacao For Analitica.
					// Habilita a impressao das colunas
					oSection:SetHeaderBreak(.F.)                  		  
					oSection:Hide()
				EndIf 
				
				oSection:PrintLine()	 		
	            
				oSection:Cell("RA_NOME"):SetValue()
				oSection:Cell("RA_BCDEPSA"):SetValue()
				oSection:Cell("RA_CIC"):SetValue()
				oSection:Cell("RA_CTDEPSA"):SetValue()
				oSection:Cell("VALOR"):SetValue()  
				if cPaisLoc <> "CHI"
	   				oSection:Cell("FUNCBENEF"):SetValue()   
	   			endif

			EndIf	
		Next nReg

		(cAliasX)->( dbSkip() )
	EndDo                    

  	   
	// Finaliza impressao inicializada pelo metodo Init             
	oSection:Finish()
    
	If ExistBlock("GPR020FIN")
		ExecBlock("GPR020FIN",.F.,.F.)
	EndIf	 
	
	// Termino do relatorio                                         
	dbSelectArea("SRA")
	dbCloseArea()
	ChkFile("SRA")

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ fChkConta ³ Autor ³ Equipe RH	      ³ Data ³  11/03/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o campo de Conta Corrente (Func/Benef) de acordo    º±±
±±º          ³ com mv_par04 (Com Conta/Sem Conta).                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Function fChkConta( cConteudo )
	
	If mv_par04 == 1 .And. Empty(cConteudo) // Com  conta Corrente, nao permite q cpo de Conta Corrente fique em  branco 
		Alert(oemToAnsi(STR0047) ) 			// Este Campo deve ser informado. Foi selecionado a opcao "Com  Conta Corrente"
		Return(.F.)	
	EndIf 

Return(.T.)

/*
Regra : De Acordo com  o parametro nFunBenAmb e ComConta, fica determinado:
		Se nFunBenAmb = 
			-Funcionario : Testa Banco/Ag e C.Corrente somente do Funcionario.  Não testa Bco/Ag. e C.Corrente do Beneficiario.
			-Beneficiario: Testa Banco/Ag e C.Corrente somente do Beneficiario. Nao testa Bco/Ag. e C.Corrente do Funcionario.
			-Ambos       : Testa Banco/Ag e C.Corrente de Ambos 
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fRoteiro ³ Autor ³ Tatiane Matias        ³ Data ³ 28/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Selecionar o Roteiro.                               		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function fRoteiro(l1Elem, lTipoRet, aElem)
Local cTitulo	:= OemToAnsi(STR0061) //"Roteiro de Calculo"
Local nFor		:= 0
Local nElem		:= 0
Local MvPar
Local MvParDef	:=""
Local MvRetor	:= ""
Local nX3Tam	:= 0
Private aSit:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)
	
	DEFAULT lTipoRet 	:= .T. 
	DEFAULT aElem		:= {}
	
	cAlias := Alias() 					// Salva Alias Anterior
	
	If lTipoRet
		MvPar:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIf

	dbSelectArea("SRY")
	If dbSeek(cFilial)
		CursorWait()
		While !Eof() .And. SRY->RY_FILIAL == cFilial
			If AllTrim(Upper(FunName())) == "GPER020"      
				If SRY->RY_TIPO $ "1/2/3/4/5/6/7/9/F/K"
					Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
					MvParDef += SRY->RY_CALCULO  
				EndIf
			ElseIf AllTrim(Upper(FunName())) == "GPER670"      
				If SRY->RY_TIPO $ "1/2/6/9"
					Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
					MvParDef += SRY->RY_CALCULO  
				EndIf
			Else
				Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
				MvParDef += SRY->RY_CALCULO  
			EndIf
			dbSkip()
		Enddo  
		If Len(aElem) > 0
			For nElem := 1 to Len(aElem)	
				Aadd(aSit, aElem[nElem]) 				//	"EXT - Valores Extras"
				MvParDef += SubStr(aElem[nElem], 1, 3)	//	MvParDef += "EXT"
			Next nElem
		EndIf
		CursorArrow()
	EndIf
	
	If lTipoRet         
		nX3Tam := GetSx3Cache("RY_CALCULO","X3_TAMANHO")
		If f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,,,l1Elem, nX3Tam)  // Chama funcao f_Opcoes
			CursorWait()
			For nFor := 1 To Len( mVpar ) Step 3
				If ( SubStr( mVpar , nFor , 3 ) # "***" )
					mvRetor += SubStr( mVpar , nFor , 3 )
				EndIf
			Next nFor
		   	If( Empty(mvRetor) )
				mvRetor := Space(nX3Tam)
			EndIf                       
			&MvRet 	:= mvRetor
			CursorArrow()	
		EndIf	
	EndIf

	dbSelectArea(cAlias) // Retorna Alias

Return( If( lTipoRet , .T. , MvParDef ) )
            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ SelecRoteiros ³ Autor ³ Tatiane Matias       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carregar no array aRoteiros os roteiros selecionados em        ³±±
±±³          ³ mv_par01, mv_par02 e mv_par03.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function SelecRoteiros(cVerba, nCampos)
Local nRot		:= 1
Local nPos		:= 1
Local nPrior	:= 0
Local cAuxRot	:= ""
Local cVarRot	:= ""
Local cAddVerba	:= If(Empty(cVerba), "", cVerba)
Local cTipoCalc	:= "" 

DEFAULT cVerba 	:= ""
DEFAULT nCampos	:= 3
	
dbSelectArea("SRY")
For nRot := 1 to nCampos
	cVarRot := &("mv_par0" + STR(nRot,1,0))
	nPos := 1                 
	//Incluir cada roteiro selecionado em mv_par01, mv_par02 e mv_par03, 
	// com o tipo de roteiro e a verba.
	While nPos <= Len(cVarRot)      
		cAuxRot	:= SubStr(cVarRot, nPos, 3)  
		If dbSeek(xFilial("SRY")+cAuxRot)
			cTipoCalc := SRY->RY_TIPO
			If (aScan( aRoteiros, { |x| x[1] == cAuxRot  } ) == 0)
				If Empty(cVerba)
					Do Case
						Case cTipoCalc $ "1/9/7" 	// Folha de Pagto
							cAddVerba 	:= fGetCodFol("0047")
							nPrior		:= 8
						Case cTipoCalc == "2"  //Adiantamento
							cAddVerba 	:= fGetCodFol("0546")
							nPrior		:= 1
						Case cTipoCalc == "3"  // Ferias
							cAddVerba 	:= fGetCodFol("0102")
							nPrior		:= 2
						Case cTipoCalc == "4"  // Rescisao
							cAddVerba	:= fGetCodFol("0126")
							nPrior		:= 3
						Case cTipoCalc == "5" .And. cPaisLoc == "BRA"  // 1a parcela 13o Salario
							cAddVerba 	:= fGetCodFol("0678")
							nPrior		:= 4
						Case cTipoCalc == "6" .Or. cTipoCalc == "5" // 2a parcela 13o Salario
							cAddVerba	:= fGetCodFol("0021")
							nPrior		:= 5                                
						Case cTipoCalc == "A"  //Aplicacao de Rescisao - Mex
							cAddVerba	:= fGetCodFol("0126")
							nPrior		:= 9
						Case cTipoCalc == "F"  // PLR
							cAddVerba	:= fGetCodFol("0836")
							nPrior		:= 6
						Case cTipoCalc == "K"  // Valores Extras
							cAddVerba	:= fGetCodFol("1411")
							nPrior		:= 7
					EndCase		    
				EndIf
				
				Aadd(aRoteiros, {cAuxRot, cTipoCalc, cAddVerba, nPrior} )
			EndIf
		// Valores Extras                
		ElseIf cAuxRot == "EXT" .And. (Ascan( aRoteiros, { |x| x[1] == cAuxRot  } ) == 0)
			Aadd(aRoteiros, {cAuxRot, "E", "", 7} )
		EndIf
		nPos += 3
	EndDo
Next nRot

If !Empty( aRoteiros )
	aSort( aRoteiros , Nil , Nil , { |x,y| x[4] < y[4] } )
EndIf 
	
Return( Nil )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GPER020  ³ Autor ³ Valdeci Lira       º Data ³  27/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Traz a descricao de um cod de localidade pago com base na  º±±
±±º          ³ tabela RGC e keyLoc da localidade pago.                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function RDescLocPago(cLoc)   
Local aArea		:= GetArea()
Local cRet      := ""
Default cLoc	:= ""
		
	dbSelectArea("RGC")
	RGC->(dbSetOrder(1))
	RGC->(dbSeek(xFilial("RGC")+cLoc))
	
	cRet := RGC->RGC_DESLOC
	
	RestArea(aArea) 

Return( cRet )     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gp020BuscaLiq ³ Autor ³ Tatiane Matias       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca os valores de liquido e beneficios                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Gp020BuscaLiq(nValLiq,aValBenef)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nValLiq     - Valor do liquido a receber                   	  ³±±
±±³          ³ aValBenef   - 1-Nome/2-Banco/3-Conta/4-Verba/5-Valor Benef 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function Gp020BuscaLiq(nValLiq,aValBenef,cVerba)
Local aCodBenef   	:= {}
Local aChaveBusca 	:= {}
Local aAreaSra    	:= SRA->( GetArea() )
Local aPensPd		:= {} //{ cRoteiro, PERIODO, SEMANA, ORIGEM, DATAPAG, DTREF, PD }
Local cVerbaBusca 
Local cRoteiro
Local cAcessaSRC	:= &( " { || " + ChkRH( "GPER020" , "SRC" , "2" ) + " } " )
Local cAcessaSRD	:= &( " { || " + ChkRH( "GPER020" , "SRD" , "2" ) + " } " )
Local cAcessaSRR	:= &( " { || " + ChkRH( "GPER020" , "SRR" , "2" ) + " } " )
Local cAcessaSRG	:= &( " { || " + ChkRH( "GPER020" , "SRG" , "2" ) + " } " )
Local cAcessaSRH	:= &( " { || " + ChkRH( "GPER020" , "SRH" , "2" ) + " } " )     
Local lResArea 		:= .F.
Local nCntP,nCntP2,nPosBenef
Local nRoteiro   
Local nPosFol
Local nValVrb  		:= 0
Local nValBenef		:= 0

Private nLiqAux 	:= 0 // Variavel para acumular outros valores de liquidos para utilizacao no Ponto de Entrada.
Private	cTipoRot	:= ""	
	If Type("lImprFunci") = "U"
		Private lImprFunci := .T.
	EndIf 
	
	If Type("lImprBenef") = "U"
		Private lImprBenef := .T.
	EndIf
	
	Default cVerba := ""

	// Ponto de Entrada para alterar as variaveis de liquido. Ex. lAdianta    
	// Impressao/Geracao de liquidos : A partir da 7.10, a rotina passou a    
	// listar  valor liquido da rescisão contratual dos funcionários demitidos
	// de acordo com  as faixas de datas de pagamento selecionadas.           
	// No entanto, algumas empresas lancam o Id47 (Liq. a receber)no SRC e    
	// neste caso, nao deveria pegar o Liq.Rescisao, duplicando o Vlr. Liq.ge-
	// rado no Relat./Geracao Liq.                                            
	If ExistBlock("GPCHKLIQ")
		ExecBlock("GPCHKLIQ",.F.,.F.)
		nValLiq += nLiqAux
	EndIf

	For nRoteiro := 1 to Len(aRoteiros)
	
		cRoteiro 	:= aRoteiros[nRoteiro, 1]
		cTipoRot 	:= aRoteiros[nRoteiro, 2]
		cVerbaBusca := If(Empty(cVerba),aRoteiros[nRoteiro, 3],cVerba)	
	
		// Busca liquido e beneficios das Ferias			   			 
		If cTipoRot == "3"		
			dbSelectArea( "SRH" )
			dbSetOrder( 3 ) 
			If lImprFunci // Busca Liquido
				If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro ) .And. Eval(cAcessaSRH)
					While !Eof() .And. Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro) = Alltrim(SRH->RH_FILIAL + SRH->RH_MAT + SRH->RH_ROTEIR)
						If (SRH->RH_DTRECIB >= dDataDe .And. SRH->RH_DTRECIB <= dDataAte ) 
							dDtBusFer := SRH->RH_DATAINI
							dbSelectArea( "SRR" )
							dbSetOrder( 3 )
							If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "F" + DTOS(dDtBusFer) + cVerbaBusca + cRoteiro )
								nValLiq += SRR->RR_VALOR
								If !Empty(cVerba)
									nValVrb += SRR->RR_VALOR
								EndIf
							EndIf
						EndIf
						dbSelectArea("SRH")
						dbSkip()
					Enddo
				EndIf
			EndIf
			If lImprBenef // Busca beneficios
				fBusCadBenef(@aCodBenef,cRoteiro,, .T.) //"FER"
				If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro ) .And. Eval(cAcessaSRH)
					While !Eof() .And. Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro) = Alltrim(SRH->RH_FILIAL + SRH->RH_MAT + SRH->RH_ROTEIR)
						If (SRH->RH_DTRECIB >= dDataDe .And. SRH->RH_DTRECIB <= dDataAte )
							dDtBusFer := SRH->RH_DATAINI
							dbSelectArea( "SRR" )
							dbSetOrder( 3 )
							For nCntP := 1 To Len(aCodBenef)
								If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "F" + DTOS(dDtBusFer) + aCodBenef[nCntP,1] + cRoteiro )
									nPosBenef := Ascan( aValBenef, { |x| x[2]+x[3] == aCodBenef[nCntP,10]+aCodBenef[nCntP,11]+aCodBenef[nCntP,12]+aCodBenef[nCntP,01] } )
									If nPosBenef == 0
										Aadd(aValBenef, {  aCodBenef[nCntP,09],  aCodBenef[nCntP,10], aCodBenef[nCntP,11], SRR->RR_PD, SRR->RR_VALOR,aCodBenef[nCntP,12],aCodBenef[nCntP,19],"SRQ", If(Len(aCodBenef[nCntP]) >= 22, aCodBenef[nCntP,22], ""),aCodBenef[nCntP,23],aCodBenef[nCntP,24] } ) 
									Else
										aValBenef[nPosBenef,5] += SRR->RR_VALOR
									EndIf
									
									If Empty(aPensPd) .Or. aScan(aPensPd, { |x| x[1] == cRoteiro .And. x[2] == SRR->RR_PERIODO .And. x[3] == SRR->RR_SEMANA .And. x[4] == SRR->RR_TIPO3 .And. x[5] == SRR->RR_DATAPAG .And. x[6] == SRR->RR_DTREF .And. x[7] == SRR->RR_PD } ) == 0
										Aadd(aPensPd, { cRoteiro, SRR->RR_PERIODO, SRR->RR_SEMANA, SRR->RR_TIPO3, SRR->RR_DATAPAG, SRR->RR_DTREF, SRR->RR_PD } )
									Endif
								EndIf
							Next nCntP
						EndIf
						dbSelectArea("SRH")
						dbSkip()
					Enddo
				EndIf
			EndIf							 
		ElseIf cTipoRot $ "4*A" // Busca liquido e beneficios da Rescisao	
			// Verifica Todos os Registros do Funcionario no "SRG"          
			dbSelectArea("SRG")                                                       
			dbSetOrder( 2 )
			If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro) .And. Eval(cAcessaSRG)
				aChaveBusca := {}
				While !Eof() .And. ( AllTrim(SRA->RA_FILIAL + SRA->RA_MAT + cRoteiro) ) == ( AllTrim(SRG->RG_FILIAL + SRG->RG_MAT + SRG->RG_ROTEIR) )
					If SRG->RG_DATAHOM >= dDataDe .And. SRG->RG_DATAHOM <= dDataAte
						Aadd(aChaveBusca, SRG->RG_FILIAL + SRG->RG_MAT + "R" + DTOS(SRG->RG_DTGERAR))
					EndIf
					dbSkip()
				Enddo
				
				// Verifica Qual Registro Deve Buscar no "SRR"                  
				nBusca := If( Len(aChaveBusca) == 1, 1, Len(aChaveBusca) )
				If nBusca > 0
					If lImprFunci // Busca Liquido
						dbSelectArea( "SRR" )
							
						If dbSeek( aChaveBusca[nBusca] + cVerbaBusca )
							nValLiq += SRR->RR_VALOR
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Busca os beneficios definidos no cadastro beneficiarios		 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nValBenef := 0
					If lImprBenef // Busca beneficios 
						fBusCadBenef(@aCodBenef, cRoteiro,,.T.)
						
						For nCntP := 1 To Len(aCodBenef)
							cCodPdBenef		:= aCodBenef[nCntP, 16 ] //-- Todas as verbas dos beneficiarios
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Busca todas a verbas de pensao da rescisao              	 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							For nCntP2:= 1 To Len(cCodPdBenef) Step 6
								
								cCodVerba	:= substr(cCodPdBenef,nCntP2+3,3)
								dbSelectArea( "SRR" )
								
								If dbSeek( aChaveBusca[nBusca] + cCodVerba ) .And. Eval(cAcessaSRR)
									nValBenef	+= SRR->RR_VALOR
									
									If Empty(aPensPd) .Or. aScan(aPensPd, { |x| x[1] == cRoteiro .And. x[2] == SRR->RR_PERIODO .And. x[3] == SRR->RR_SEMANA .And. x[4] == SRR->RR_TIPO3 .And. x[5] == SRR->RR_DATAPAG .And. x[6] == SRR->RR_DTREF .And. x[7] == SRR->RR_PD } ) == 0
										Aadd(aPensPd, { cRoteiro, SRR->RR_PERIODO, SRR->RR_SEMANA, SRR->RR_TIPO3, SRR->RR_DATAPAG, SRR->RR_DTREF, SRR->RR_PD } )
									Endif
								EndIf
							Next nPd
							
							nPosBenef := Ascan( aValBenef, { |x| x[2] + x[3] + x[4] == aCodBenef[nCntP,10] + aCodBenef[nCntP,11] + aCodBenef[nCntP,01] } )
							
							If nPosBenef == 0
								Aadd(aValBenef, {  aCodBenef[nCntP,09],  aCodBenef[nCntP,10], aCodBenef[nCntP,11], SRR->RR_PD, nValBenef ,aCodBenef[nCntP,12],,,,aCodBenef[nCntP,23],aCodBenef[nCntP,24]} )
							Else
								aValBenef[nPosBenef,5]	+= 	nValBenef
							EndIf
							
							nValBenef		:= 0
			
						Next nCntP
						
						dbSelectArea("SRG")
					EndIf				
				EndIf
			EndIf
		Else
			// Movimento Aberto
			dbSelectArea( "SRC" )
			dbSetOrder( 8 )
			If lImprFunci // Busca Liquido
				If SRC->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cVerbaBusca + cRoteiro))  .And. Eval(cAcessaSRC)
					While !Eof() .And. ( Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + cVerbaBusca + cRoteiro) = ;
						AllTrim(SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD + SRC->RC_ROTEIR) )
						If SRC->RC_DATA >= dDataDe .And. SRC->RC_DATA <= dDataAte
							nValLiq += SRC->RC_VALOR
							If !Empty(cVerba)
								nValVrb += SRC->RC_VALOR
							EndIf
						EndIf
						dbSkip()
					EndDo
				EndIf
			EndIf

			If lImprBenef // Busca beneficios
				fBusCadBenef(@aCodBenef, cRoteiro,,.T.) 
				If cTipoRot $ "1/2/5/6/F"  // FOL/ADI/131/132/PLR (Roteiros que tem pensao)
					For nCntP := 1 To Len(aCodBenef)
						For nCntP2 := 1 To 3
							nPosVb := If( nCntP2 == 1, 1,If( nCntP2 == 2, 8, 7 ) ) // 1-Pensao Folha   2-Pensao PLR 3-Pensao Dif.13sal.
							If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,nPosVb] + cRoteiro) .And. Eval(cAcessaSRC)
								While !Eof() .And. ( Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,nPosVb] + cRoteiro) = ;
									Alltrim(SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD + SRC->RC_ROTEIR) )
									If (SRC->RC_DATA >= dDataDe .And. SRC->RC_DATA <= dDataAte) .And.;
									   PosSrv(SRC->RC_PD,SRC->RC_FILIAL,"RV_TIPOCOD") == "2"
									   
									   	If Empty(aPensPd) .Or. SRC->RC_TIPO2 # "G" .Or. aScan(aPensPd, { |x| x[2] == SRC->RC_PERIODO .And. x[3] == SRC->RC_SEMANA .And. x[5] == SRC->RC_DATA .And. x[7] == SRC->RC_PD }) == 0
											
											nPosBenef := Ascan( aValBenef, { |x| x[2]+x[3] == aCodBenef[nCntP,10]+aCodBenef[nCntP,11]+aCodBenef[nCntP,12]+aCodBenef[nCntP,01] } )
											If nPosBenef == 0
												Aadd(aValBenef, {  aCodBenef[nCntP,09],  aCodBenef[nCntP,10], aCodBenef[nCntP,11], SRC->RC_PD, SRC->RC_VALOR,aCodBenef[nCntP,12],aCodBenef[nCntP,19],"SRQ", If(Len(aCodBenef[nCntP]) >= 22, aCodBenef[nCntP,22], ""),aCodBenef[nCntP,23],aCodBenef[nCntP,24]  } ) 					
											Else
												aValBenef[nPosBenef,5] += SRC->RC_VALOR
											EndIf
										EndIf
									EndIf
									dbSkip()
								EndDo
							EndIf
						Next nCntP2
					Next nCntP 
				Else  
					For nCntP := 1 To Len(aCodBenef)
						If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,1] + cRoteiro) .And. Eval(cAcessaSRC)
							While !Eof() .And. ( Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,1] + cRoteiro) = ;
								Alltrim(SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD + SRC->RC_ROTEIR) )
								If (SRC->RC_DATA >= dDataDe .And. SRC->RC_DATA <= dDataAte) .And.;
								    PosSrv(SRC->RC_PD,SRC->RC_FILIAL,"RV_TIPOCOD") == "2"
									
									If Empty(aPensPd) .Or. SRC->RC_TIPO2 # "G" .Or. aScan(aPensPd, { |x| x[2] == SRC->RC_PERIODO .And. x[3] == SRC->RC_SEMANA .And. x[5] == SRC->RC_DATA .And. x[7] == SRC->RC_PD }) == 0	
										nPosBenef := Ascan( aValBenef, { |x| x[2]+x[3] == aCodBenef[nCntP,10]+aCodBenef[nCntP,11]+aCodBenef[nCntp,12]+aCodBenef[nCntp,01]  } ) 
										If nPosBenef == 0
											Aadd(aValBenef, {  aCodBenef[nCntP,09],  aCodBenef[nCntP,10], aCodBenef[nCntP,11], SRC->RC_PD, SRC->RC_VALOR,aCodBenef[nCntP,12],aCodBenef[nCntP,19],"SRQ", If(Len(aCodBenef[nCntP]) >= 22, aCodBenef[nCntP,22], "") } ) 
										Else
											aValBenef[nPosBenef,5] += SRC->RC_VALOR
										EndIf
									EndIf
								Endif
								dbSkip()
							EndDo
						Endif
						lResArea := .T.
					Next nCntP
				EndIf
			EndIf
	
			// Movimento Fechado  
			dbSelectArea( "SRD" )
			dbSetOrder( 6 )
			If lImprFunci // Busca Liquido
				If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cVerbaBusca + cRoteiro) .And. Eval(cAcessaSRD)
					While !Eof() .And. ( Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + cVerbaBusca + cRoteiro) = ;
						Alltrim(SRD->RD_FILIAL + SRD->RD_MAT + SRD->RD_PD + SRD->RD_ROTEIR) )
						If SRD->RD_DATPGT >= dDataDe .And. SRD->RD_DATPGT <= dDataAte
							nValLiq += SRD->RD_VALOR
							If !Empty(cVerba)
								nValVrb += SRD->RD_VALOR
							EndIf
						EndIf
						dbSkip()
					EndDo
				EndIf
			EndIf
			
			If lImprBenef // Busca beneficios
				fBusCadBenef(@aCodBenef,cRoteiro,, .T.) //"FOL"
				For nCntP := 1 To Len(aCodBenef)
					For nCntP2 := 1 To 3
						nPosVb := If( nCntP2 == 1, 1,If( nCntP2 == 2, 8, 7 ) ) // 1-Pensao Folha   2-Pensao PLR 3-Pensao Dif.13sal.
						dbSelectArea( "SRD" )
						dbSetOrder( 6 )
						If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,nPosVb] + cRoteiro) .And. Eval(cAcessaSRD)
							While !Eof() .And. ( Alltrim(SRA->RA_FILIAL + SRA->RA_MAT + aCodBenef[nCntP,nPosVb] + cRoteiro) = ;
								Alltrim(SRD->RD_FILIAL + SRD->RD_MAT + SRD->RD_PD + SRD->RD_ROTEIR) )
								If (SRD->RD_DATPGT >= dDataDe .And. SRD->RD_DATPGT <= dDataAte) .And.;
								   PosSrv(SRD->RD_PD,SRD->RD_FILIAL,"RV_TIPOCOD") == "2"
									
									If Empty(aPensPd) .Or. SRD->RD_TIPO2 # "G" .Or. aScan(aPensPd, { |x| x[2] == SRD->RD_PERIODO .And. x[3] == SRD->RD_SEMANA .And. x[5] == SRD->RD_DATPGT .And. x[7] == SRD->RD_PD }) == 0
										
										nPosBenef := Ascan( aValBenef, { |x| x[2]+x[3] == aCodBenef[nCntP,10]+aCodBenef[nCntP,11]+aCodBenef[nCntP,12]+aCodBenef[nCntP,01] } )
										If nPosBenef == 0
											Aadd(aValBenef, {  aCodBenef[nCntP,09],  aCodBenef[nCntP,10], aCodBenef[nCntP,11], SRD->RD_PD, SRD->RD_VALOR,aCodBenef[nCntP,12],aCodBenef[nCntP,19],"SRQ", If(Len(aCodBenef[nCntP]) >= 22, aCodBenef[nCntP,22], ""),aCodBenef[nCntP,23],aCodBenef[nCntP,24] } ) 
										Else
											aValBenef[nPosBenef,5] += SRD->RD_VALOR
										EndIf
									EndIf
								EndIf
								dbSkip()
							EndDo
						EndIf
					Next nCntP2
				Next nCntP
			EndIf              
		EndIf
		
	Next nRoteiro      
	
	If nValVrb > 0
		nValLiq := nValVrb
	EndIf

Return( Nil )       
