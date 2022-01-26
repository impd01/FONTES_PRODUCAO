#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "IMPRPA.CH"

/*



uno    ?ImpRpa   ?Autor ?MARINALDO DE JESUS         ?Data ?31/05/00 ?

escrio ?RPA - RECIBO DE PAGAMENTO DE AUTONOMOS                          ?

intaxe   ?Chamada padr para programas em RdMake                         ?

arametros?                                                                ?

so       ?Generico                                                        ?

bservacao?-Para a Impressao do Numero de Inscricao do Autonomo no INSS    ?
?         ?do Tipo de Servico e do Orgao Emissor do RG, sera necessario    ?
?         ?estar incluido, no Cadastro de Funcionarios, os Campos:         ?
?         ?                                                                ?
?         ?RA_NUMINSC - Tipo Caracter,Tamanho 11 Masc @R 9999.9999.999     ?
?         ?RA_SERVICO - Tipo Caracter,Tamanho 60 Masc @!                   ?
?         ?RA_ORGEMRG - Tipo Caracter,Tamanho 05 Masc @R! NNN/NN           ?

?        ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                  
?
rogramador ?Data   ?Chd./Requisito ? Motivo da Alteracao                     ?
?
?Ademar Jr. ?8/03/13|Requisito:      ?Unificacao dos fontes da fase padrao com ?
?           ?       HU210_09_12    ?a fase 4 (localizacoes).                 ?
?           ?       ?               ?                                         ? 
hristiane V?7/06/14|    TPUSHG      orreo do posicion. do campo RA_SERVICO ?
aquel Hager?9/06/16|TVGHFB          juste no filtro de Categorias.           ?
aquel Hager?6/06/16|TVGHFB          emoo de tratamento para Valores Extras.?
?
?
?
*/
User Function ImpRpa01()

/*

?Define Variaveis Basicas Genericas                           ?
*/  
Private CSTRING,AORD,CDESC1,CDESC2,CDESC3,LEND,NLASTKEY,CPERG,NOMEPROG,;
ARETURN,TITULO,LI,NTAMANHO,WNREL,NORDEM,NTIPORPA,CSEMANA,CFILDE,CFILATE,;
CCCDE,CCCATE,CMATDE,CMATATE,CNOMEDE,CNOMEATE,CSITUACAO,CCATEGORIA,CNUMRPA,DDATAREF,LATUAL,;
CARQANT,CARQNEW,LIGUAL,CSAVSCR1,CSAVCUR1,CSAVROW1,;
CSAVCOL1,CSAVCOR1,CINDRC,CRCNTX,NPOSANOMES,CDATAANT,;
CEXCLUI,CINICIO,CFIM,CFILIALANT,CCCANT,CNUMANT,;
CFILMAT,CDESC_FIL,CDESC_CC,CDESC_CGC,CLOCAL_FIL,AINFO,;
ACODFOL,NVALORAUT,NINSSAUT,NIRRFAUT,NOUTVENC,NOUTDESC,;
NTOTVENC,NTOTDESC,NLIQUIDO,NOUTVEN,CQUERY,;
AIMPRPA,NCOLUNAS,CRET1,CRET2,CEXTENSO,NPOSRPA,AREGS

Private lFase4  := (cPaisLoc $ "ANG|ARG|COL|PTG|VEN")
Private cMes	:= ""
Private cAno    := ""

Private aPerAberto	:= {}
Private aPerFechado	:= {}
Private cProcesso	:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro	:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo	:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).

cString   := 'SRA'                                  //Alias do arquivo principal (Base).
//aOrd      := {STR0001,STR0002,STR0003,STR0004}      //'Matricula'###'C.Custo'###'Nome'###'C.Custo + Nome'
aOrd      := {STR0001,STR0002,STR0003,STR0004,STR0040,STR0041} //"Matricula"###"C.Custo"###"Nome"###"C.Custo + Nome"###"Depto."###"Depto. + Nome"
cDesc1    := STR0005                                //'Emiss de Recibos de Pagamento de Autonomo.'
cDesc2    := STR0006                                //'Ser?impresso de acordo com os parametros solicitados pelo'
cDesc3    := STR0007                                //'usuario.'
lEnd      := .F.
nLastKey  := 0
cPerg     := 'IMPRPA'
nomeprog  := 'RPA'
aReturn   := {STR0008, 1,STR0009, 2, 2, 1, '',1 }   //'Zebrado'###'Administrao'

/*

?Titulo do Relatorio                                          ?
*/
Titulo		:= cDesc1

/*

?Variaveis Para a Funcao fImpRpa()                            ?
*/
Li			:= 0
nTamanho	:= "P"

/*

?Variaveis de Acesso do Usuario                               ?
*/
cAcessaSRA	:= &( " { || " + ChkRH( "IMPRPA" , "SRA" , "2" ) + " } " )

/*

?Verifica as Perguntas Selecionadas nos Parametros            ?
*/
Pergunte(cPerg,.F.)

/*

?Envia controle para a funcao SETPRINT                        ?
*/
WnRel := 'RPA' // Nome Default do relatorio em Disco.
WnRel := SetPrint(cString,Wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

IF nLastKey == 27
	Return Nil
EndIF

SetDefault(aReturn,cString)

IF nLastKey == 27
	Return Nil
EndIF

/*

?Chamada do Relatorio.                                        ?
*/
RptStatus( { |lEnd| fIncRpa() } , Titulo )

Return Nil


/***********************/
Static Function fIncRpa()
/***********************/

Local cAliasAux		:= "SRC"
Local cPrefixo		:= "RC_"
Local cAcessaVLD	:= ""

/*

?Verifica Ordem do Relatorio                                  ?
*/
nOrdem    := aReturn[8]

/*

?Verifica as Perguntas Selecionadas nos Parametros            ?
*/
Pergunte(cPerg,.F.)

/*

?Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ?
*/
cProcesso  := mv_par01
cRoteiro   := mv_par02
cPeriodo   := mv_par03
cSemana    := mv_par04

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRoteiro	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				cSemana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRoteiro	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			cSemana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado

If !Empty(aPerAberto)
	dDataRef 	:= aPerAberto[1,7]
	cAliasAux	:= "SRC"
	cPrefixo	:= "RC_"
	cAcessaVLD	:= &( " { || " + ChkRH( "IMPRPA" , "SRC" , "2" ) + " } " )
ElseIf !Empty(aPerFechado)
	dDataRef 	:= aPerFechado[1,7]
	cAliasAux	:= "SRD"
	cPrefixo	:= "RD_"
	cAcessaVLD	:= &( " { || " + ChkRH( "IMPRPA" , "SRD" , "2" ) + " } " )
Else			
	dDataRef := CtoD("01/" + cMes + "/" + cAno)
EndIf

cFilDe		:= MV_PAR05
cFilAte		:= MV_PAR06
cCcDe		:= MV_PAR07
cCcAte		:= MV_PAR08
cMatDe		:= MV_PAR09
cMatAte		:= MV_PAR10
cNomeDe		:= MV_PAR11
cNomeAte	:= MV_PAR12
cSituacao	:= MV_PAR13
cCategoria	:= MV_PAR14
cNumRpa		:= MV_PAR15
cDeptoDe	:= mv_par16
cDeptoAte	:= mv_par17

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)


/*?
loco que definira a Consistencia da Parametrizacao dos Intervalos sele?
ionados nas Perguntas De? Ate? para o Skip/Loop e Para a SetRegua()   ?
?*/
cExclui := ""
cExclui := cExclui + "{ || "
cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or."
cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or."
cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or."
cExclui := cExclui + "(RA_DEPTO   < cDeptoDe   .or. RA_DEPTO   > cDeptoAte  ).or."
cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$'A')"
cExclui := cExclui + " } "

/*

?Seleciona Arquivo Principal e Carrega Regua de Processamento ?
*/
dbSelectArea('SRA')
SetRegua( SRA->( RecCount() ) )
dbGotop()

/*

?Posicionando no Primeiro Registro do Parametro               ?
*/
IF nOrdem == 1
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cMatDe, .T. )
	cInicio := '{ || RA_FILIAL + RA_MAT }'
	cFim    := cFilAte + cMatAte
ElseIF nOrdem == 2
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cCcDe + cMatDe, .T. )
	cInicio  := '{ || RA_FILIAL + RA_CC + RA_MAT }'
	cFim     := cFilAte + cCcAte + cMatAte
ElseIF nOrdem == 3
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cNomeDe + cMatDe, .T. )
	cInicio := '{ || RA_FILIAL + RA_NOME + RA_MAT }'
	cFim    := cFilAte + cNomeAte + cMatAte
ElseIF nOrdem == 4
	dbSetOrder(08)
	dbSeek( cFilDe + cCcDe + cNomeDe, .T. )
	cInicio  := '{ || RA_FILIAL + RA_CC + RA_NOME } '
	cFim     := cFilAte + cCcAte + cNomeAte
ElseIf nOrdem == 5
	dbSetOrder(21)
	dbSeek(cFilDe + cDeptoDe + cMatDe, .T.)
	cInicio  := '{ || RA_FILIAL + RA_DEPTO + RA_MAT } '
	cFim     := cFilAte + cDeptoAte + cMatAte
ElseIf nOrdem == 6
	dbSetOrder(22)
	dbSeek(cFilDe + cDeptoDe + cNomeDe, .T.)
	cInicio  := '{ || RA_FILIAL + RA_DEPTO + RA_NOME } '
	cFim     := cFilAte + cDeptoAte + cNomeAte
EndIF

/*

?Variaveis Para Impressao dos Dados da Empresa/Autonomo       ?
*/
cFilialAnt	:= Space(FWGETTAMFILIAL)
cCcAnt		:= Space(GetSx3Cache("RA_CC", "X3_TAMANHO"))
cNumAnt		:= cNumRpa
cFilMat		:= ""
cDesc_Fil	:= ""
cDesc_Cc	:= ""
cDesc_CGC	:= ""
cLocal_Fil  := ""
aInfo		:= {}
aCodFol		:= {}
nValorAut	:= 0
nINSSAut	:= 0
nIRRFAut	:= 0
nOutVenc	:= 0
nOutDesc	:= 0
nTotVenc	:= 0
nTotDesc	:= 0
nLiquido	:= 0

/*

?Ira Executar Enquanto Estiver dentro do Escopo dos Parametros?
*/
While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
	
	/*
	
	?Reinicializa Variaveis                                       ?
	*/
	nValorAut := 0 ; nIRRFAut := 0 ; nINSSAut := 0
	nOutVenc  := 0 ; nOutDesc := 0 ; nTotVenc := 0
 	nTotDesc  := 0 
	
	/*
	
	?Movimenta Regua Processamento                                ?
	*/
	IncRegua()
	
	/*
	
	?Cancela Impres                                             ?
	*/
	IF lEnd
		@ Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	/*
	
	?Consiste Parametrizacao do Intervalo de Impressao            ?
	*/
	IF SRA->( Eval ( &(cExclui) ) )
		dbSelectArea("SRA")
		dbSkip()
		Loop
	EndIF
	
	cFilMat := SRA->( RA_FILIAL + RA_MAT )
	
	/*
	?
	onsiste Filiais e Acessos                                             ?
	?/
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
		dbSkip()
		Loop
	EndIF
	
	/*
	
	?Carregando Informacoes das Verbas e da Filial                ?
	*/
	IF SRA->RA_FILIAL != cFilialAnt
		IF !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) .or. !fInfo(@aInfo,SRA->RA_FILIAL)
			/*
			
			?Encerra o Loop se Nao Existir Cadastro de Verbas ou Filial   ?
			*/
			Exit
		EndIF
		/*
		
		?Descricao da Filial e do CGC                                 ?
		*/
		cDesc_Fil	:= aInfo[3]
		cLocal_FIl	:= aInfo[5]
		cDesc_CGC	:= aInfo[8]
		/*
		
		?Atualiza a Variavel cFilialAnt                               ?
		*/
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	EndIF
	
	/*
	
	?TIPO DE ROTEIRO (cTipoRot)                                   ?
	?==========================                                   ?
	?1- Folha de Pagamento                                        ?
	?2- Adiantamento                                              ?
	?3- Ferias                                                    ?
	?4- Rescisao                                                  ?
	?5- 1a.Parcela 13o.Salario                                    ?
	?6- 2a.Parcela 13o.Salario                                    ?
	?7- Outros                                                    ?
	?8- Vale Transporte                                           ?
	?9- Autonomos                                                 ?
	?A- Provisao                                                  ?
	*/
	
	dbSelectArea(cAliasAux)
	dbSetOrder(1)
	IF dbSeek( cFilMat , .T. )
		While (cAliasAux)->( !Eof() .and. &(cPrefixo+"FILIAL") + &(cPrefixo+"MAT") == cFilMat )
			
			/*
			
			?Cancela Impressao.                                           ?
			*/
			IF lEnd
				Exit
			EndIF
			
			If !Eval(cAcessaVLD)
				dbSelectArea(cAliasAux)
				dbSkip()
				Loop
			EndIf
			
			/*
			
			?Faz as verificacoes iniciais basicas                         ?
			*/
			If (cAliasAux)->&(cPrefixo+"PROCES") <> cProcesso
				dbSelectArea(cAliasAux)
				dbSkip()
				Loop
			EndIf
			
			If (cAliasAux)->&(cPrefixo+"ROTEIR") <> cRoteiro
				dbSelectArea(cAliasAux)
				dbSkip()
				Loop
			EndIf
			
			If (cAliasAux)->&(cPrefixo+"PERIODO") <> cPeriodo
				dbSelectArea(cAliasAux)
				dbSkip()
				Loop
			EndIf
			
			IF (cAliasAux)->&(cPrefixo+"SEMANA") # cSemana .And. cSemana # "99"
				dbSelectArea(cAliasAux)
				dbSkip()
				Loop
			EndIF
			
			/*
			
			?Identificador de Calculo da Verba de Desconto do Adiantamento?
			*/
			IF (cAliasAux)->&(cPrefixo+"PD") $ aCodFol[007,1] +"*"+ aCodFol[008,1] +"*"+ aCodFol[022,1]
				nOutVenc += (cAliasAux)->&(cPrefixo+"VALOR")
				
				/*
				
				?Identificador de Calculo da Verba de I.R.R.F. Sobre o Adto.  ?
				*/
			ElseIF (cAliasAux)->&(cPrefixo+"PD") $ aCodFol[012,1] +"*"+ aCodFol[066,1] +"*"+ aCodFol[071,1]
				nIRRFAut += (cAliasAux)->&(cPrefixo+"VALOR")
				
				/*
				
				?Identificador de Calculo da Verba de Pagamento de Autonomo.  ?
				*/
			ElseIF (cAliasAux)->&(cPrefixo+"PD") == aCodFol[218,1]
				nValorAut += (cAliasAux)->&(cPrefixo+"VALOR")
				
				/*
				
				dentificadores de Calculo da Verba de IRRF,  do INSS Autonomo?
				o INSS de Folha, Ferias e de 13o. Salario.                   ?
				*/
			ElseIF (cAliasAux)->&(cPrefixo+"PD") $ aCodFol[222,1] +"*"+ aCodFol[064,1] +"*"+ aCodFol[065,1] +"*"+ aCodFol[070,1]
				nINSSAut += (cAliasAux)->&(cPrefixo+"VALOR")
				
			Else
				/*
				
				?Verifica as Verbas de Proventos que se Referem a Adiantamento?
				*/
				IF PosSrv( (cAliasAux)->&(cPrefixo+"PD") , SRA->RA_FILIAL, "RV_TIPOCOD") == "1" //Proventos
				
					IF !( (cAliasAux)->&(cPrefixo+"PD") == aCodFol[218,1] )
						/*
						
						?Outros Vencimentos                                           ?
						*/
						nOutVenc += (cAliasAux)->&(cPrefixo+"VALOR")
					EndIF
					/*
					
					?Verifica as Verbas de Descontos que se Referem a Adiantamento?
					*/
				ElseIF PosSrv( (cAliasAux)->&(cPrefixo+"PD") , SRA->RA_FILIAL, "RV_TIPOCOD") == "2" //Descontos
				
					IF !( (cAliasAux)->&(cPrefixo+"PD") $ aCodFol[222,1] +"*"+ aCodFol[064,1] +"*"+ aCodFol[065,1] +"*"+ aCodFol[070,1] )
						/*
						
						utros Descontos                                              ?
						*/
						nOutDesc += (cAliasAux)->&(cPrefixo+"VALOR")
					EndIF
				EndIF
			EndIF
			
			dbSelectArea(cAliasAux)
			dbSkip()
		Enddo
	EndIF
	
	nTotVenc := nValorAut + nOutVenc
	nTotDesc := nIRRFAut  + nINSSAut + nOutDesc
	
	nLiquido := Max( nTotVenc - nTotDesc , 0 )
	
	/*
	
	?Se Nao Tiver Valores a Imprimir, Salta Para o Proximo Regitro?
	*/
	dbSelectArea("SRA")
	IF nTotVenc == 0 .and. nTotDesc == 0
		dbSkip()
		Loop
	EndIF
	
	/*
	
	?Numeracao do Recibo                                          ?
	*/
	IF cNumAnt != cNumRpa
		cNumRpa := StrZero( Val(cNumRpa) + 1 , 10 )
	EndIF
	
	/*
	
	?Imprime os Recibos de Autonomo                               ?
	*/
	fImpRPA()
	
	/*
	
	?Proximo Registro                                             ?
	*/
	dbSelectArea("SRA")
	dbSkip()
	cNumAnt := ""
Enddo

/*

?Grava o Ultimo Numero Impresso no SX1                        ?
*/
dbSelectArea( "SX1" )
dbSetOrder(1)
IF dbSeek( cPerg + "15" )	//-MV_PAR15
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := cNumRpa
	MsUnlock()
EndIF

/*

?Restaura a Ordem Primaria dos Indices.                       ?
*/
dbSelectArea("SRC") ; dbSetOrder(1)
dbSelectArea("SRD") ; dbSetOrder(1)
dbSelectArea("SRA") ; dbSetOrder(1)

IF aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(WnRel)
EndIF

MS_FLUSH()
Return


/*
?
uno    ImpRPA   ?Autor arinaldo de Jesus     ?Data ?2/06/2000?
?
escrio mprime Recibo de Pagamento de Autonomo                     ?
?/*/

Static Function fImpRPA()

Local nCarCH
Local nPosRpa

aImpRpa		:= {}
nColunas	:= IF(nTamanho == "P" , 80 , IF( nTamanho == "G", 220 , 132) )
cRet1		:= ""
cRet2		:= ""

/*

?Extraindo o Extenso do Liquido.                              ?
*/
cExtenso	:= Extenso(nLiquido,.F.,1 )

/*

?Separando o Extenso para impressao em 2 Linhas.              ?
*/
SepExt(cExtenso,43,80,@cRet1,@cRet2)

cRet1 := IF( !Empty(cRet1), "(" + cRet1 , cRet1 )
cRet1 := IF( !Empty(cRet1) .and. Len(AllTrim(cRet1)) < 43 .and. Empty(cRet2), AllTrim(cRet1) + ")",cRet1)
cRet2 := IF( !Empty(cRet2), AllTrim(cRet2) + ".****)" , cRet2 )

/*

?Carrega a Mascara do Recibo.                                 ?
*/
//                                  10        20        30        40        50        60        70        80
//                          12345678901234567890123456789012345678901234567890123456789012345678901234567890
aAdd( aImpRpa, '       RECIBO DE PAGAMENTO - RPA                  +-------- No.RECIBO ---------+' ) //'       RECIBO DE PAGAMENTO - RPA                  +-------- No.RECIBO ---------+' 01
aAdd( aImpRpa, STR0012 ) //'                                                  |                            |' 02
aAdd( aImpRpa, STR0013 ) //'+-------------------------------------------------+----------------------------+' 03
aAdd( aImpRpa, STR0014 ) //'| NOME OU RAZAO SOCIAL DA EMPRESA                 |   MATRICULA (GCG ou INSS)  |' 04
aAdd( aImpRpa, STR0015 ) //'|                                                 |                            |' 05
aAdd( aImpRpa, STR0016 ) //'+-------------------------------------------------+----------------------------+' 06
aAdd( aImpRpa, '|         RECEBI DA INSTITUICAO ACIMA IDENTIFICADA, PELO EXERCICIO DE MINISTRO |' ) //'           RECEBI DA INSTITUICAO ACIMA IDENTIFICADA, PELO EXERCICIO DE MINISTRO ' 07
aAdd( aImpRpa, '|RELIGIOSO A IMPORTANCIA DE:                                                   |' ) //'                                                                                ' 08
aAdd( aImpRpa, '|                                                                              |' ) //'RELIGIOSO A IMPORTANCIA DE:                                                     ' 09
aAdd( aImpRpa, STR0020 ) //'                                                                                ' 10
aAdd( aImpRpa, STR0021 ) //'+--------- NUMERO DE INSCRICAO ---------+ ESPECIFICACAO:                        ' 11
aAdd( aImpRpa, '| NO INSS :                             | I PREBENDA.............              |' ) //'| NO INSS :                             | I PREBENDA.............               ' 12
aAdd( aImpRpa, '| NO CPF  :                             | II AD PREBENDA/REPASSE.              |' ) //'| NO CPF  :                             | II AD PREBENDA/REPASSE.               ' 13
aAdd( aImpRpa, STR0024 ) //'+------------- IDENTIDADE --------------+      SOMA..............               ' 14
aAdd( aImpRpa, STR0025 ) //'| NUMERO :                              |                                       ' 15
aAdd( aImpRpa, STR0026 ) //'| ORGAO EMISSOR :          UF :         | DESCONTOS:                            ' 16
aAdd( aImpRpa, STR0027 ) //'+-------------- ENDERECO ---------------+ III  I.R.R.F...........               ' 17
aAdd( aImpRpa, STR0028 ) //'|                                       | IV   INSS..............               ' 18
aAdd( aImpRpa, '|                                       | V    REPASSE/OUTROS....              |' ) //'|                                       | V    REPASSE/OUTROS....               ' 19
aAdd( aImpRpa, STR0030 ) //'|                                       |                                       ' 20
aAdd( aImpRpa, STR0031 ) //'|                                       | VALOR LIQUIDO..........               ' 21
aAdd( aImpRpa, STR0032 ) //'+------- LOCALIDADE -------+--- DATA ---+ +------------ ASSINATURA ------------+' 22
aAdd( aImpRpa, STR0033 ) //'|                          |            | |                                    |' 23
aAdd( aImpRpa, STR0034 ) //'+--------------------------+------------+ +------------------------------------+' 24
aAdd( aImpRpa, 'C.CUSTO:                                  +-----------BISPO / PASTOR(A)--------+' ) //'C.CUSTO:                                  +-----------BISPO / PASTOR(A)--------+' 25
aAdd( aImpRpa, STR0036 ) //'                                          |                                    |' 26
aAdd( aImpRpa, STR0037 ) //'                                          +------------------------------------+' 27

/*

?Inclui as Informacoes da Empresa/Autonomo                    ?
*/
For nPosRpa := 1 To Len(aImpRpa)
	
	IF nPosRpa == 2
		/*
		
		?Carrega o Numero do Recibo.                                  ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 69 , Len(cNumRpa) , cNumRpa )
	
	ElseIF nPosRpa == 4 .And. cPaisLoc != "BRA"
		/*
		
		?Configura o titulo como RUC.                                 ?
		*/            
		IF SRA->( FieldPos("RA_SERVICO") != 0 )
			cString := RetTitle("RA_CIC",5)+"/"+RetTitle("RA_SERVICO",5)+")"
		Else
			cString := RetTitle("RA_CIC",5)+")"
		EndIf
		
        If Len(cString) < 12
        	cString := cString+Space(12-Len(cString))
        EndIf
      	nTam := Len(cString)

		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , nTam, cString)
	
	ElseIF nPosRpa == 5
		/*
		
		?Carrega o Nome da Empresa                                    ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim( cDesc_Fil) ) , AllTrim( cDesc_Fil ) )
		/*
		
		?Carrega o CGC da Empresa                                     ?
		*/
		If cPaisLoc != "BRA"
			cString := Transform(cDesc_CGC, PesqPict("SA1","A1_CGC"))
			
	        If Len(cString) < 17
	        	cString := cString+Space(17-Len(cString))
	        EndIf
	      	nTam := Len(cString)

			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 61 , nTam , cString )
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 61 , Len(Transform(cDesc_CGC, "@R ##.###.###/####-##")) , Transform(cDesc_CGC, "@R ##.###.###/####-##") )
		EndIf
	
	ElseIF nPosRpa == 08
		/*
		
		?Se Existir o Campo no Cadastro de Funcionarios, Carrega a Des?
		?cricao do Tipo de Servico Prestado.(Tipo Caract., Tamanho 80)?
		*/
		IF SRA->( FieldPos("RA_SERVICO") != 0 )
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 02 , Len(AllTrim(SRA->RA_SERVICO) ) , AllTrim(SRA->RA_SERVICO ) )
		EndIF
	
	ElseIF nPosRpa == 09
		/*
		
		?Carrega o Valor Liquido                                      ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 19 , Len(AllTrim(STR0038))  , AllTrim(STR0038) )
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 22 , Len(TransForm(nLiquido, "@E 999,999,999.99")) , TransForm(nLiquido, "@E 999,999,999.99") )
		/*
		
		?Carrega o Extenso (1a. Linha)                                ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 36 , Len( cRet1 ) , cRet1 )
	
	ElseIF nPosRpa == 10
		/*
		
		?Carrega o Extenso (2a. Linha)                                ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len( cRet2 ) , cRet2 )
	
	ElseIF nPosRpa == 12
		/*
		
		?Carrega o Numero de Inscricao no INSS (Autonomo)             ?
		*/
		IF SRA->( FieldPos("RA_NUMINSC") != 0 ) .And. !Empty(SRA->RA_NUMINSC)
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , Len(TransForm(SRA->RA_NUMINSC, "@R 9999.9999.999")) , TransForm(SRA->RA_NUMINSC, "@R 9999.9999.999") )
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , Len(TransForm(SRA->RA_PIS, "@R 9999.9999.999")) , TransForm(SRA->RA_PIS, "@R 9999.9999.999") )
		EndIF
		/*
		
		?Carrega o Valor da Prestacao de Servico                      ?
		*/
		If cPaisLoc != "BRA"
			IF SRA->( FieldPos("RA_SERVICO") != 0 )
				aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 06 , 06, RetTitle("RA_SERVICO",5)+":" )
			Else
				aImpRpa[nPosRpa] := StrTran( aImpRpa[nPosRpa], SubStr(aImpRpa[nPosRpa],2,10), Space(10) )
			EndIf
		EndIf
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nValorAut, "@E 999,999,999.99")) , TransForm(nValorAut, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 13
		/*
		
		?Carrega o Numero do CPF do Autonomo                          ?
		*/
		If cPaisLoc <> "BRA"
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 06 , 06, RetTitle("RA_CIC",5)+":" )
			cString := TransForm(SRA->RA_CIC, PesqPict("SRA","RA_CIC"))
			If Len(cString) < 14
				cString := cString+Space(14-Len(cString))
			EndIf
			nTam := Len(cString)
			
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , nTam , cString )
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , Len(TransForm(SRA->RA_CIC, "@R 999.999.999-99")) , TransForm(SRA->RA_CIC, "@R 999.999.999-99") )
		EndIf
		/*
		
		?Carrega o Valor de Outros Vencimentos                        ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nOutVenc, "@E 999,999,999.99")) , TransForm(nOutVenc, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 14
		/*
		
		?Carrega a Soma dos Vencimentos                               ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nTotVenc, "@E 999,999,999.99")) , TransForm(nTotVenc, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 15
		/*
		
		?Carrega o Numero do RG do Autonomo                           ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , Len(TransForm(SRA->RA_RG, "@R 999.999.999-99")) , TransForm(SRA->RA_RG, "@R 999.999.999-99") )
	
	ElseIF nPosRpa == 16
		/*
		
		e Existir o Campo RA_ORGEMRG, no Cadastro de Funcionarios,Car?
		ega o Orgao Emissor do RG e a U.F.(Tipo Caracter, Tam 05)    ?
		*/
		IF SRA->( FieldPos("RA_ORGEMRG") != 0 ) .And. !Empty(SRA->RA_ORGEMRG)
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 19 , Len(Subst(SRA->RA_ORGEMRG,1,3)) , Subst(SRA->RA_ORGEMRG,1,3) )
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 33 , Len(Subst(SRA->RA_ORGEMRG,4,2)) , Subst(SRA->RA_ORGEMRG,4,2) )
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 19 , Len(TransForm(SRA->RA_RGORG, "@R 999")) , SRA->RA_RGORG )

			If SRA->( FieldPos("RA_RGUF") != 0 ) .And. !Empty(SRA->RA_RGUF)
				aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 33 , Len(TransForm(SRA->RA_RGUF, "@R 99")) , SRA->RA_RGUF )
			Endif
		EndIF
	
	ElseIF nPosRpa == 17
		/*
		
		?Carrega o Valor do I.R.R.F.                                  ?
		*/
		If cPaisLoc != "BRA"
			aImpRpa[nPosRpa] := StrTran( aImpRpa[nPosRpa], SubStr(aImpRpa[nPosRpa],48,18), Replicate(".",18) )
		EndIf
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nIRRFAut, "@E 999,999,999.99")) , TransForm(nIRRFAut, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 18
		/*
		
		?Carrega o Endereco do Funcionario                            ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(SRA->RA_ENDEREC)) , AllTrim(SRA->RA_ENDEREC) )
		/*
		
		?Carrega o Valor do INSS de Autonomos                         ?
		*/
		If cPaisLoc != "BRA"
			aImpRpa[nPosRpa] := StrTran( aImpRpa[nPosRpa], SubStr(aImpRpa[nPosRpa],48,18), Replicate(".",18) )
		EndIf
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nINSSAut, "@E 999,999,999.99")) , TransForm(nINSSAut, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 19
		/*
		
		?Carrega o Complemento do Endereco do Funcionario             ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(SRA->RA_COMPLEM)) , AllTrim(SRA->RA_COMPLEM) )
		/*
		
		?Carrega o Valor de Outros Descontos                          ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nOutDesc, "@E 999,999,999.99")) , TransForm(nOutDesc, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 20
		/*
		
		?Carrega o Bairro do Funcionario                              ?
		*/
		If cPaisLoc == "PER"
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(RetContUbigeo("SRA->RA_CEP", "RA_BAIRRO"))) , AllTrim(RetContUbigeo("SRA->RA_CEP", "RA_BAIRRO")) )
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(SRA->RA_BAIRRO)) , AllTrim(SRA->RA_BAIRRO) )		
		Endif	

	ElseIF nPosRpa == 21
		/*
		
		?Carrega a Cidade do Funcionario                              ?
		*/
		If cPaisLoc == "PER"
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(RetContUbigeo("SRA->RA_CEP", "RA_MUNICIP"))) , AllTrim(RetContUbigeo("SRA->RA_CEP", "RA_MUNICIP")) )		
		Else
			aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(SRA->RA_MUNICIP)) , AllTrim(SRA->RA_MUNICIP) )
		Endif
		
		/*
		
		?Carrega o Valor Liquido                                      ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 66 , Len(TransForm(nLiquido, "@E 999,999,999.99")) , TransForm(nLiquido, "@E 999,999,999.99") )
	
	ElseIF nPosRpa == 23
		/*
		
		?Carrega o Local                                              ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(cLocal_Fil)) , AllTrim(cLocal_Fil) )
		/*
		
		?Carrega o Data                                               ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 30 , Len(Dtoc(dDataRef)) , Dtoc(dDataRef) )
	
	ElseIF nPosRpa == 25
		/*
		
		?Carrega o Codigo do Centro de Custo                          ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 13 , Len(AllTrim(SRA->RA_CC)) , AllTrim(SRA->RA_CC) )
	
	ElseIF nPosRpa == 26
		/*
		
		?Carrega a Descricao do Centro de Custo                       ?
		*/
		cDesc_CC := fDesc("SI3",SRA->RA_CC,"I3_DESC")
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 03 , Len(AllTrim(cDesc_CC)) , AllTrim(cDesc_CC) )
		/*
		
		?Carrega o Nome do Funcionario                                ?
		*/
		aImpRpa[nPosRpa] := Stuff( aImpRpa[nPosRpa], 45 , Len(AllTrim(SRA->RA_NOME)) , AllTrim(SRA->RA_NOME)   )
	EndIF
	
Next nPosRpa

/*

?Imprime o Recibo                                             ?
*/
@ Li, 00 PSAY AvalImp( nColunas ) 
For nCarCH := 1 To Len(aImpRpa)
	
	/*
	
	?Cancela Impres ao se pressionar <ALT> + <A>                ?
	*/
	IF lEnd == .T.
		Exit
	EndIF
	
	/*
	
	?Impressao do Recibo                                          ?
	*/
	Li := Li + 1
	@ Li, 00 PSAY aImpRpa[nCarCH]
	
Next nCarCH

Li := Li + 2

/*

?Imprime o Separador de Recibo ou Reinicializa Li             ?
*/
IF Li == 29
	@ Li, 00 PSAY Replicate("-",nColunas)
	Li := Li + 1
Else
	Li := 0
EndIF

Return
