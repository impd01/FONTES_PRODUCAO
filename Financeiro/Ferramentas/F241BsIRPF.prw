#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

STATIC dDtMinPCC 			//necessario pois utiliza no FINA590.      
STATIC __lPCCBaixa	:= NIL	// Verifica o momento da retencao do PCC
STATIC aSelFil		:= {}
Static dLastPcc  := CTOD("22/06/2015")
Static lIsIssBx := FindFunction("IsIssBx")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³F241BsIRPF³Autor  ³João G. de Oliveira   ³ Data ³18/08/2008	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula a base de cálculo através da leitura do período referente³±±
±±³          ³ao documento                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 - Número de registro do documento a ser analisado          ³±±   
±±³          ³ExpC2 - Apelido do arquivo a ser avaliado                        ³±±   
±±³          ³ExpN3 - Valor a ser considerado no cálculo da base de cálculo    ³±±   
±±³          ³        (Valor do pagamento)                                     ³±±  
±±³          ³ExpL4 - Determina se deverá somar o valor do documento a base    ³±±   
±±³          ³        de cálculo do IRPF                                       ³±±  
±±³          ³ExpC5 - Fornecedor a ter a base calculada                        ³±±   
±±³          ³ExpC6 - Loja do fornecedor que deverá ter a base calculada       ³±±    
±±³          ³ExpC7 - Numero do borderô de pagamento                           ³±±    
±±³          ³ExpD8 - Data do documento                                        ³±±     
±±³          ³ExpL9 - Define se retorna lista com títulos que compoem a base   ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 - Vetor com 3 elementos: Base de cálculo,IRPF retido,      ³±±   
±±³          ³        vetor com registros que compõem a base de cálculo e valor³±±    
±±³          ³        de dedução para IR                                       ³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³FINA241/FINA080/FINA090/FINA590/FINA375                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F241BsIRPF(nRegiDoct,cAlias,nValPgto,lAgreValo,cFornece,cLoja,cNumBor,dDataDoct,lListTitu,lRecalc,lFina241,lCarret)


Local aArea		:= (cAlias)->( GetArea() ) 
Local lCampDepe	:= .T.
Local nBaseDepe	:= GetMV("MV_TMSVDEP",,0)
Local nValoDedu	:= 0
Local lBaseIRPF	:= .F.
Local nProp		:= 1
Local lValLiq	:= SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local nI		:= 0
Local cTitulo	:= ""
Local lPrimCalc	:= .T.
Local aAreaSE2	:= {}
Local cFilterSE2:= ""
Local aImpIss 	:= {}
Local nLimInss  := GetMv("MV_LIMINSS",.F.,0)
Local lFatura	:= SE2->E2_FATURA="NOTFAT"
Local lBaseTot  := .F.
Local nVrRed	:=	0
Local lIRPFBaixa := IIf( cPaisLoc == "BRA", SA2->A2_CALCIRF == "2", .F.) 
					
Local aStruct   := {} 
Local aCampos   := {} 
Local cAliasQry := ""  
Local cSepRec   := If("|"$MVPAGANT,"|",",")	
Local cSepNeg   := If("|"$MV_CPNEG,"|",",")
Local cSepProv  := If("|"$MVPROVIS,"|",",")

//Considero juros multa ou desconto na base do imposto.
// 1 = Considera valores juros multa ou desconto
// 2 = Nao considera valores juros multa ou desconto

Local aCalcIRPF := {0,0,{},0}
Local aRegsIRPF := {}
Local dDataInic := FirstDay( dDataBase )   
Local dDataFina := LastDay( dDataBase )
Local lFatBase	:= .F. 
Local lFina590	:= IsInCallStack("FINA590")  
Local lFina050	:= IsInCallStack("FINA050") 
Local nValBrut	:= 0
Local nPosTit	:= 1

Default nValPgto	:= 0
Default lAgreValo	:= .T.
Default cFornece	:= SE2->E2_FORNECE
Default cLoja		:= SE2->E2_LOJA
Default nRegiDoct	:= 0
Default cNumBor		:= ""
Default dDataDoct	:= dDataBase
Default lListTitu	:= .F.
Default lRecalc		:= .F.
Default lFina241	:= IsInCallStack("FINA241")
Default lCarret     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utilizado para Deduzir o INSS do IRRF(Carreteiro)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('nINSSRet')=="U"
	nINSSRet  := 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Encontra valor para dedução com dependentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataInic := FirstDay( dDataDoct )   
dDataFina := LastDay( dDataDoct ) 
If lCampDepe .And. nBaseDepe > 0
	nNumeDepe := Posicione("SA2",1,xfilial("SA2") + cFornece + cLoja,"A2_NUMDEP") 
	nValoDedu := nBaseDepe * nNumeDepe
EndIf

//Gestao
F241PccBx()  // verificar PCC

//Posiciona Natureza para verificação de base de IRRF
//Se for inclusão de PA, utilizo os campos de memoria
//para posicionar a Natureza
If IsInCallStack("FINA050")  
	SED->(dbSetOrder(1))
	SED->(MsSeek(xFilial("SED")+M->E2_NATUREZ))
	lBaseIRPF := If (!lCarret ,F050BIRPF(1),.F.)
Else
	SED->(dbSetOrder(1))
	SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
	lBaseIRPF := If (!lCarret ,F050BIRPF(2),.F.)
Endif 

//Eh Base Bruta ou IR com base reduzida      
If lValLiq .Or. lBaseIRPF
	lRecalc := .T.
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma valor do título que está sendo avaliado à base de ³
//³cálculo para IRPF                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAgreValo 
	//Base reduzida de IRPF
	If IIF(lBaseIrpf, SE2->E2_BASEIRF > 0,.F.) .OR.(lFina050 .AND. SED->ED_BASEIRF>0)
		nVrRed	:= 0
		//Tratamento para geracao do bordero com impostos
		If lFina241
			aCalcIRPF[1] += nValPgto
		ElseIF !lFina050
			//Possui base reduzida de IR e nao se trata da geracao de um bordero CP com impostos
  			nValorBase := SE2->E2_BASEIRF - If((SuperGetMv("MV_INSIRF",.F.,"2") == "1"),SE2->E2_INSS,0)

			//Obtenho o valor bruto do titulo 
			nValBrut := SE2->(E2_VALOR + E2_SEST)
			nValBrut += Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),SE2->E2_INSS,0)//Verifica se deve somar o INSS para compor a base de cálculo
			nValBrut += Iif(!GetCalcIss(SE2->E2_FILORIG),SE2->E2_ISS,0)//Verifica se deve somar o ISS para compor a base de cálculo			
			nValBrut += Iif(!__lPCCBaixa,Iif(SE2->E2_PRETPIS == ' ',SE2->E2_VRETPIS,0)+Iif(SE2->E2_PRETCOF == ' ',SE2->E2_VRETCOF,0)+Iif(SE2->E2_PRETCSL == ' ',SE2->E2_VRETCSL,0),0)//Verifica se deve somar o PCC para compor a base de cálculo						
			nValBrut += IIf(!lIRPFBaixa, SE2->E2_IRRF,0)

			nProp := IIf(nValPgto == 0,nValorBase,nValPgto)/nValBrut

			//Se a baixa for total, nao proporcionaliza
			//Exemplo:
			//Titulo de R$ 10.000 com base de IR de R$ 8.000
			//Caso se proporcionalize, teremos: 
			//nProp := IIf(nValPgto == 0,8000,10000)/ 8000 = 1.25
			//aCalcIRPF[1] += SE2->E2_BASEIRF * nProp	= 8000 x 1.25 = 10.000
			If nValPgto > 0 .and. STR(nValPgto,17,2) == STR(nValBrut,17,2)
				nProp := 1
				lBaseTot := .T.
			Endif

			nVrRed	:= (SE2->E2_BASEIRF - Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),0,SE2->E2_INSS)) * nProp					
			If SED->ED_BASEIRF > 0 .AND. SE2->E2_BASEIRF > 0 .AND. SE2->E2_VALOR > nValPgto //Caso seja baixa parcial de base reduzida...
				nVrRed := ((nVrRed * SED->ED_BASEIRF) / 100)			
			Endif
			aCalcIRPF[1] += nVrRed
		Elseif M->E2_TIPO == MVPAGANT //Se for PA irá buscar os valores da memória
						//Possui base reduzida de IR e nao se trata da geracao de um bordero CP com impostos
  			nValorBase := M->E2_BASEIRF - If((SuperGetMv("MV_INSIRF",.F.,"2") == "1"),M->E2_INSS,0)

			//Obtenho o valor bruto do titulo 
			nValBrut := M->(E2_VALOR + E2_SEST)
			nValBrut += Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),M->E2_INSS,0)//Verifica se deve somar o INSS para compor a base de cálculo
			nValBrut += Iif(!GetCalcIss(SE2->E2_FILORIG),M->E2_ISS,0)//Verifica se deve somar o ISS para compor a base de cálculo			
			nValBrut += Iif(!__lPCCBaixa,Iif(SE2->E2_PRETPIS == ' ',M->E2_VRETPIS,0)+Iif(M->E2_PRETCOF == ' ',M->E2_VRETCOF,0)+Iif(M->E2_PRETCSL == ' ',M->E2_VRETCSL,0),0)//Verifica se deve somar o PCC para compor a base de cálculo						
			nValBrut += IIf(!lIRPFBaixa, M->E2_IRRF,0)

			nProp := IIf(nValPgto == 0,nValorBase,nValPgto)/nValBrut

			//Se a baixa for total, nao proporcionaliza
			//Exemplo:
			//Titulo de R$ 10.000 com base de IR de R$ 8.000
			//Caso se proporcionalize, teremos: 
			//nProp := IIf(nValPgto == 0,8000,10000)/ 8000 = 1.25
			//aCalcIRPF[1] += SE2->E2_BASEIRF * nProp	= 8000 x 1.25 = 10.000
			If nValPgto > 0 .and. STR(nValPgto,17,2) == STR(nValBrut,17,2)
				nProp := 1
				lBaseTot := .T.
			Endif

			nVrRed	:= (M->E2_BASEIRF - Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),0,M->E2_INSS)) * nProp					
			If SED->ED_BASEIRF > 0 .AND. M->E2_BASEIRF > 0 .AND. M->E2_VALOR > nValPgto //Caso seja baixa parcial de base reduzida...
				nVrRed := ((nVrRed * SED->ED_BASEIRF) / 100)			
			Endif
			aCalcIRPF[1] += nVrRed
		Endif
	Else
		//Nao possui tratamento de base reduzida		
		aCalcIRPF[1] += IIf(nValPgto == 0,SE2->E2_SALDO+Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),SE2->E2_INSS,0)+Iif(GetCalcIss(SE2->E2_FILORIG),0,SE2->E2_ISS),nValPgto)
		If SA2->A2_TIPO == "J" .and. lIRPFBaixa .and. nValPgto <> 0  .and. SE2->(E2_SALDO+E2_IRRF) == nValPgto
			aCalcIRPF[1] += Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "2"),SE2->E2_INSS,0)//Verifica se deve somar o INSS para compor a base de cálculo
			aCalcIRPF[1] += Iif(!GetCalcIss(SE2->E2_FILORIG),SE2->E2_ISS,0)//Verifica se deve somar o ISS para compor a base de cálculo			
			aCalcIRPF[1] += Iif(!__lPCCBaixa,Iif(SE2->E2_PRETPIS == ' ',SE2->E2_VRETPIS,0)+Iif(SE2->E2_PRETCOF == ' ',SE2->E2_VRETCOF,0)+Iif(SE2->E2_PRETCSL == ' ',SE2->E2_VRETCSL,0),0)//Verifica se deve somar o PCC para compor a base de cálculo						
		EndIf	
	Endif
	nBaseIrpf := aCalcIRPF[1]
	cTitulo   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma valores relacionados e retenção de IRPF dos  ³
//³títulos com retenção na baixa para determinar     ³ 
//³a base de cálculo com exceção dos que tem borderô ³ 
//³emitido                                           ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := { "E5_VALOR","E5_VRETIRF","E5_VLJUROS","E5_VLMULTA","E5_VLDESCO"} 

//Base IRPF reduzida
IF lBaseIrpf
	aCampos := { "E5_BASEIRF"} 
Endif

aStruct := SE5->( dbStruct() ) 				
cAliasQry := GetNextAlias()
SE5->( dbCommit() ) 

cQuery := " SELECT"
cQuery += " SUM(E5_VALOR) BASEBAIX" 
cQuery += ", SUM(E5_VRETIRF) RETEBAIX"
cQuery += ", SUM(E5_VRETISS) RETEISS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se tratar-se de titulo de carreteiro, soma valor de INSS, ISS e SEST para recompor base de calculo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
cQuery += ", SUM(E2_INSS) INSS"
cQuery += ", SUM(E2_ISS) ISS"
cQuery += ", SUM(E2_SEST) SEST"

If lListTitu 
	cQuery += ", E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA"	
EndIf	

cQuery += " FROM"
cQuery += " " + RetSqlName( "SE5" ) + " SE5, " + RetSqlName( "SE2" ) + " SE2, " + RetSqlName( "SED" ) + " SED"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
cQuery += " AND E5_CLIFOR='"	+ cFornece + "'"
cQuery += " AND E5_LOJA='" + cLoja + "'"
cQuery += " AND E5_DATA>= '" + DTOS( dDataInic ) + "'"
cQuery += " AND E5_DATA<= '"	+ DTOS( dDataFina ) + "'"
cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
cQuery += " AND E5_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) 
cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVPAGANT,cSepRec) 	
cQuery += " AND E5_RECPAG = 'P'"

//Base IRPF reduzida
IF lBaseIrpf
	cQuery += " AND E5_BASEIRF = 0 "
Endif

cQuery += " AND E5_MOTBX NOT IN ('FAT','CMP','IRF','PCC','LIQ','ISS')"
cQuery += " AND E5_SITUACA <> 'C'"
cQuery += " AND SE5.D_E_L_E_T_=' '"                                             
cQuery += " AND E2_FILIAL  = '" + xFilial("SE2") + "'"
cQuery += " AND E2_PREFIXO = E5_PREFIXO AND E2_NUM = E5_NUMERO"
cQuery += " AND E2_PARCELA = E5_PARCELA AND E2_FORNECE = E5_CLIFOR AND E2_LOJA = E5_LOJA"
cQuery += " AND E2_TIPO = E5_TIPO"
cQuery += " AND E2_NUMBOR = '" + Space(TamSX3("E2_NUMBOR")[1]) + "'"
cQuery += " AND E2_NATUREZ = ED_CODIGO "
If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN"
	cQuery += " AND ED_CALCIRF = 'S' 
EndIf

// Quando o titulo de IRPJ for gerado na baixa do titulo principal, 
// calcula isoladamente o valor para este titulo sem acumular
If lIRPFBaixa .AND. SA2->A2_TIPO == "J"
	cQuery += " AND ( E2_IRRF > 0 AND E2_VRETIRF < E2_IRRF )"
EndIf

cQuery += " AND SE2.D_E_L_E_T_=' '"
cQuery += " AND NOT EXISTS ("
cQuery += 		" SELECT A.E5_NUMERO"
cQuery += 		" FROM "+RetSqlName("SE5")+" A"
cQuery += 		" WHERE A.E5_FILIAL='"+xFilial("SE5")+"'"
cQuery +=		" AND A.E5_PREFIXO=SE5.E5_PREFIXO"
cQuery +=		" AND A.E5_NUMERO=SE5.E5_NUMERO"
cQuery +=		" AND A.E5_PARCELA=SE5.E5_PARCELA"
cQuery +=		" AND A.E5_TIPO=SE5.E5_TIPO"
cQuery +=		" AND A.E5_CLIFOR=SE5.E5_CLIFOR"
cQuery +=		" AND A.E5_LOJA=SE5.E5_LOJA"
cQuery +=		" AND A.E5_SEQ=SE5.E5_SEQ"
cQuery +=		" AND A.E5_TIPODOC = 'ES'"
cQuery +=		" AND A.E5_RECPAG <> 'P'"
cQuery +=		" AND A.D_E_L_E_T_<>'*')"		   

If lListTitu 
	cQuery += " GROUP BY E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA "
EndIf	
			
cQuery := ChangeQuery( cQuery ) 			
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )				

TCSetField( cAliasQry, "BASEBAIX", "N", 12, 2 )	 
TCSetField( cAliasQry, "RETEBAIX", "N", 12, 2 )			
TCSetField( cAliasQry, "RETEISS",  "N", 12, 2 )

dbSelectArea(cAliasQry)
dbGoTop()
While ! (cAliasQry)->(Eof())

	If lListTitu 
			
		aAreaSE2 := SE2->(GetArea())
		cFilterSE2 := SE2->(dbFilter())
		
		SE2->(dbClearFilter())
		SE2->(dbSetOrder(1))        
		SE2->(dbGoTop())
		
		If SE2->(dbSeek(xfilial("SE2") + (cAliasQry)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA)))
		
			lFatBase	:= SE2->E2_FATURA="NOTFAT"
			If aScan(aRegsIRPF,SE2->(Recno())) == 0
				aAdd(aRegsIRPF,SE2->(Recno()))			
			EndIf 
			
			//ISS
			If (!Empty((cAliasQry)->RETEBAIX) .And. cTitulo != SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)) .Or.;
			   (cTitulo == SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO) .And. lValLiq)
				
				aAdd(aImpIss,Iif(GetCalcIss(SE2->E2_FILORIG),FVRetISSBx(),Iif(cTitulo == SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO),0,SE2->E2_ISS)))
				lPrimCalc := .F.
					
			Endif
  	    
  	    dbSelectArea("SE2")
  	    SE2->(RestArea(aAreaSE2))
  	    Set Filter to &cFilterSE2
  		
     EndIf
     
	EndIf	

	If lFatBase .And. lListTitu 		
		aRet := FinFatAbat((cAliasQry)->E5_PREFIXO,(cAliasQry)->E5_NUMERO,(cAliasQry)->E5_CLIFOR,(cAliasQry)->E5_LOJA)
		nTotIss	:= aRet[1]
		nTotIns	:= aRet[2]
		nTotIrf	:= aRet[3]
		nTotPis := aRet[4]
		nTotCof	:= aRet[5]
		nTotCsl	:= aRet[6]
		nTotSes	:= aRet[7]
		DbSelectArea(cAliasQry)
    Else
		nTotIss	:= (cAliasQry)->RETEISS
		nTotIns	:= (cAliasQry)->INSS
		nTotSes	:= (cAliasQry)->SEST
    Endif

	If GetCalcIss(iif(lListTitu,SE2->E2_FILORIG,cFilAnt)) .And. !IsInCallStack("FA080VALVR")
		aCalcIRPF[1] += (cAliasQry)->BASEBAIX + Iif(lRecalc .And. lPrimCalc .And. !lCarret,0,(cAliasQry)->RETEBAIX) + nTotIss
	Else
		aCalcIRPF[1] += (cAliasQry)->BASEBAIX + Iif(lRecalc .And. lPrimCalc .And. !lCarret,0,(cAliasQry)->RETEBAIX)
	EndIf
	aCalcIRPF[2] += (cAliasQry)->RETEBAIX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tratar-se de titulo de carreteiro, soma valor de INSS, ISS e SEST para recompor base de calculo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	If lCarret
		aCalcIRPF[1] += nTotIns + nTotIss + nTotSes	//-- Recompoe valor para base de calculo
	EndIf			
	nINSSRet += nTotIns //-- Valor de INSS JAH RETIDO

	(cAliasQry)->(dbSkip())	
		
Enddo

(cAliasQry)->(dbCloseARea())

//Refaz a base com os valores de ISS descontados.
For nI := 1 to Len(aImpIss)          
	aCalcIRPF[1] += aImpIss[nI]	
Next nI

//Base IRPF reduzida
IF lBaseIrpf

	cQuery := " SELECT"
	cQuery += " SUM(E5_BASEIRF) BASEBAIX" 
	cQuery += ", SUM(E5_VRETIRF) RETEBAIX"                           
	cQuery += ", SUM(E5_VRETISS) RETEISS"
	cQuery += ", E2_INSS "
	cQuery += ", E2_SALDO "

	If lListTitu 
		cQuery += ", E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA"	
	EndIf	

	cQuery += " FROM"
	cQuery += " " + RetSqlName( "SE5" ) + " SE5, " + RetSqlName( "SE2" ) + " SE2"	
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
	cQuery += " AND E5_CLIFOR='"	+ cFornece + "'"
	cQuery += " AND E5_LOJA='" + cLoja + "'"
	cQuery += " AND E5_DATA>= '" + DTOS( dDataInic ) + "'"
	cQuery += " AND E5_DATA<= '"	+ DTOS( dDataFina ) + "'"
	cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
	cQuery += " AND E5_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
	cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) 
	cQuery += " AND E5_TIPO NOT IN " + FormatIn(MVPAGANT,cSepRec) 	
	cQuery += " AND E5_RECPAG = 'P'"
	cQuery += " AND E5_BASEIRF > 0 "

	// Quando o titulo de IRPJ for gerado na baixa do titulo principal, 
	// calcula isoladamente o valor para este titulo sem acumular
	If lIRPFBaixa .AND. SA2->A2_TIPO == "J"
		cQuery += " AND ( E2_IRRF > 0 AND E2_VRETIRF < E2_IRRF )"
	EndIf

	cQuery += " AND E5_MOTBX NOT IN ('FAT','CMP','IRF','PCC','LIQ','ISS')"
	cQuery += " AND E5_SITUACA <> 'C'"
	cQuery += " AND SE5.D_E_L_E_T_=' '"                                             
	cQuery += " AND E2_FILIAL  = '" + xFilial("SE2") + "'"
	cQuery += " AND E2_PREFIXO = E5_PREFIXO AND E2_NUM = E5_NUMERO"
	cQuery += " AND E2_PARCELA = E5_PARCELA AND E2_FORNECE = E5_CLIFOR AND E2_LOJA = E5_LOJA"
	cQuery += " AND E2_TIPO = E5_TIPO"
	If !lFina241 .Or. lFina590
		cQuery += " AND E2_NUMBOR = '" + Space(TamSX3("E2_NUMBOR")[1]) + "'"
	EndIf
	cQuery += " AND SE2.D_E_L_E_T_=' '"
	cQuery += " AND NOT EXISTS ("
	cQuery += 		" SELECT A.E5_NUMERO"
	cQuery += 		" FROM "+RetSqlName("SE5")+" A"
	cQuery += 		" WHERE A.E5_FILIAL='"+xFilial("SE5")+"'"
	cQuery +=		" AND A.E5_PREFIXO=SE5.E5_PREFIXO"
	cQuery +=		" AND A.E5_NUMERO=SE5.E5_NUMERO"
	cQuery +=		" AND A.E5_PARCELA=SE5.E5_PARCELA"
	cQuery +=		" AND A.E5_TIPO=SE5.E5_TIPO"
	cQuery +=		" AND A.E5_CLIFOR=SE5.E5_CLIFOR"
	cQuery +=		" AND A.E5_LOJA=SE5.E5_LOJA"
	cQuery +=		" AND A.E5_SEQ=SE5.E5_SEQ"
	cQuery +=		" AND A.E5_TIPODOC = 'ES'"
	cQuery +=		" AND A.E5_RECPAG <> 'P'"
	cQuery +=		" AND A.D_E_L_E_T_<>'*')"
                                                                                 
	If nRegiDoct > 0
		cQuery += " AND SE2.R_E_C_N_O_ <> " + Str(nRegiDoct) 
	EndIf			   
	
	If lListTitu 
		cQuery += " GROUP BY E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E2_SALDO, E2_INSS "
	Else
		cQuery += " GROUP BY E2_SALDO, E2_INSS"			
	EndIf	
				
	cQuery := ChangeQuery( cQuery ) 			
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )				
	
	TCSetField( cAliasQry, "BASEBAIX", "N", 12, 2 )	 
	TCSetField( cAliasQry, "RETEBAIX", "N", 12, 2 )
	TCSetField( cAliasQry, "RETEISS",  "N", 12, 2 )
	
	dbSelectArea(cAliasQry)
	dbGoTop()
	While ! Eof()		
	
		If lListTitu 
				
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek(xfilial("SE2") + (cAliasQry)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA)))
				If aScan(aRegsIRPF,SE2->(Recno())) == 0
					aAdd(aRegsIRPF,SE2->(Recno()))			
				EndIf	
			EndIf
		EndIf	

		If lIRPFBaixa
			If (cAliasQry)->E2_SALDO > 0 .AND. SuperGetMv("MV_INSIRF",.F.,"2") == "1" .AND. nValPgto != (cAliasQry)->E2_SALDO .AND. !IsInCallStack("FINA080")
				aCalcIRPF[1] += (cAliasQry)->BASEBAIX - (cAliasQry)->E2_INSS
			Else
				aCalcIRPF[1] += (cAliasQry)->BASEBAIX	
			EndIf
		ElseIf !lBaseTot
			If GetCalcIss(iif(lListTitu,SE2->E2_FILORIG,cFilAnt)) .And. !IsInCallStack("FA080VALVR")
				aCalcIRPF[1] += (cAliasQry)->BASEBAIX + (cAliasQry)->RETEISS
			Else
				aCalcIRPF[1] += (cAliasQry)->BASEBAIX
			EndIf
		EndIf
		aCalcIRPF[2] += (cAliasQry)->RETEBAIX	

		(cAliasQry)->(dbSkip())
			
	Enddo

	(cAliasQry)->(dbCloseARea())
Endif	

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma as retenções das baixas parciais ³
//³do título que está sendo baixado      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If lIRPFBaixa .And. lBaseIrpf .And. SA2->A2_TIPO == "F"
	cQuery := " SELECT"
	cQuery += " SUM(E5_BASEIRF) BASEBAIX" 
	cQuery += ",SUM(E5_VRETIRF) RETEBAIX"

	cQuery += " FROM"
	cQuery += " " + RetSqlName( "SE5" ) + " SE5
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
	cQuery += " AND E5_CLIFOR='"	+ cFornece + "'"
	cQuery += " AND E5_LOJA='" + cLoja + "'"
	cQuery += " AND E5_DATA>= '" + DTOS( dDataInic ) + "'"
	cQuery += " AND E5_DATA<= '"	+ DTOS( dDataFina ) + "'"	
	cQuery += " AND E5_RECPAG = 'P'"
	cQuery += " AND E5_BASEIRF > 0 "
	cQuery += " AND E5_MOTBX NOT IN ('FAT','CMP','IRF','PCC')"
	cQuery += " AND E5_SITUACA <> 'C'"                                
	
	cQuery += " AND E5_PREFIXO = '" + SubStr(cTitulo,1,TamSx3("E2_PREFIXO")[1])+ "'"
	nPosTit+= TamSx3("E2_PREFIXO")[1]
	
	cQuery += " AND E5_NUMERO = '" + SubStr(cTitulo,nPosTit,TamSx3("E2_NUM")[1])+ "'"
	nPosTit+= TamSx3("E2_NUM")[1]
	
	cQuery += " AND E5_PARCELA = '" + SubStr(cTitulo,nPosTit,TamSx3("E2_PARCELA")[1])+ "'"  
	nPosTit+= TamSx3("E2_PARCELA")[1]
	
	cQuery += " AND E5_TIPO = '" + SubStr(cTitulo,nPosTit,TamSx3("E2_TIPO")[1])+ "'"
	
	cQuery += " AND E5_DOCUMEN = '" + Space(TamSX3("E5_DOCUMEN")[1]) + "'" 
    
    cQuery += " AND SE5.D_E_L_E_T_=' '"
	cQuery += " AND NOT EXISTS ("
	cQuery += 		" SELECT A.E5_NUMERO"
	cQuery += 		" FROM "+RetSqlName("SE5")+" A"
	cQuery += 		" WHERE A.E5_FILIAL='"+xFilial("SE5")+"'"
	cQuery +=		" AND A.E5_PREFIXO=SE5.E5_PREFIXO"
	cQuery +=		" AND A.E5_NUMERO=SE5.E5_NUMERO"
	cQuery +=		" AND A.E5_PARCELA=SE5.E5_PARCELA"
	cQuery +=		" AND A.E5_TIPO=SE5.E5_TIPO"
	cQuery +=		" AND A.E5_CLIFOR=SE5.E5_CLIFOR"
	cQuery +=		" AND A.E5_LOJA=SE5.E5_LOJA"
	cQuery +=		" AND A.E5_SEQ=SE5.E5_SEQ"
	cQuery +=		" AND A.E5_TIPODOC = 'ES'"
	cQuery +=		" AND A.E5_RECPAG <> 'P'"
	cQuery +=		" AND A.D_E_L_E_T_<>'*')"		   
	
	cQuery += " GROUP BY E5_BASEIRF, E5_VRETIRF "
			
	cQuery := ChangeQuery( cQuery ) 			
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )				
	
	TCSetField( cAliasQry, "RETEBAIX", "N", 12, 2 )
	
	dbSelectArea(cAliasQry)
	dbGoTop()
	While !Eof() 
		If lBaseTot 
			nBaseIrpf	-= (cAliasQry)->BASEBAIX
		Else
			aCalcIRPF[1]+= (cAliasQry)->BASEBAIX				
		EndIf
		
		aCalcIRPF[2]+= (cAliasQry)->RETEBAIX	
		(cAliasQry)->(dbSkip())
	EndDo
	
	(cAliasQry)->(dbCloseARea())

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma valor da base dos títulos que tiveram        ³
//³borderô emitido                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasQry := GetNextAlias()
		
SE2->( dbCommit() ) 

cQuery := " SELECT "
cQuery += " SUM(E2_VALOR) BASEBORD" 
cQuery += ", SUM(E2_IRRF) RETEBORD"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se tratar-se de titulo de carreteiro, soma valor de INSS, ISS e SEST para recompor base de calculo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
If lCarret
	cQuery += ", SUM(E2_INSS) INSS"
	cQuery += ", SUM(E2_ISS) ISS"
	cQuery += ", SUM(E2_SEST) SEST"
EndIf	

If lListTitu 
	cQuery += ", E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_, E2_FILORIG"
EndIf

cQuery += " FROM"
cQuery += " " + RetSqlName( "SE2" ) + " SE2" 	
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
cQuery += " AND E2_FORNECE='"	+ cFornece + "'"
cQuery += " AND E2_LOJA='" + cLoja + "'"
cQuery += " AND E2_NUMBOR <> '" + cNumBor + "'"
cQuery += " AND E2_NUMBOR <> '" + Space(TamSX3("E2_NUMBOR")[1]) + "'"
cQuery += " AND E2_DTBORDE >= '" + DTOS( dDataInic ) + "'"
cQuery += " AND E2_DTBORDE <= '"	+ DTOS( dDataFina ) + "'"

//Base IRPF reduzida
IF lBaseIrpf
	cQuery += " AND E2_BASEIRF = 0 "
Endif

cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv)       
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTAXA,,3)
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTXA,,3)
cQuery += " AND NOT EXISTS ("
cQuery += 		" SELECT A.E5_NUMERO"
cQuery += 		" FROM "+RetSqlName("SE5")+" A"
cQuery += 		" WHERE A.E5_FILIAL='"+xFilial("SE5")+"'"
cQuery +=		" AND A.E5_PREFIXO=SE2.E2_PREFIXO"
cQuery +=		" AND A.E5_NUMERO=SE2.E2_NUM"
cQuery +=		" AND A.E5_PARCELA=SE2.E2_PARCELA"
cQuery +=		" AND A.E5_TIPO=SE2.E2_TIPO"
cQuery +=		" AND A.E5_CLIFOR=SE2.E2_FORNECE"
cQuery +=		" AND A.E5_LOJA=SE2.E2_LOJA"
cQuery +=		" AND A.E5_MOTBX IN ('NOR','IRF')"
cQuery +=		" AND A.E5_RECPAG = 'P' "
cQuery +=		" AND A.E5_SITUACA != 'C' "
cQuery +=		" AND A.D_E_L_E_T_<>'*')"

If nRegiDoct > 0
	cQuery += " AND SE2.R_E_C_N_O_ <> " + Str(nRegiDoct) 
EndIf	

cQuery += " AND SE2.D_E_L_E_T_= ' '"                                             

If lListTitu 		
	cQuery += " GROUP BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_, E2_FILORIG "
EndIf	
			
cQuery := ChangeQuery( cQuery ) 			
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )			

TCSetField( cAliasQry, "BASEBORD", "N", 12, 2 )	
TCSetField( cAliasQry, "RETEBORD", "N", 12, 2 )		

dbSelectArea(cAliasQry)
dbGoTop()
While ! Eof()		
	If lListTitu 
		If aScan(aRegsIRPF,(cAliasQry)->R_E_C_N_O_) == 0
			aAdd(aRegsIRPF,(cAliasQry)->R_E_C_N_O_)			
		EndIf
	EndIf				

	aCalcIRPF[1] += (cAliasQry)->BASEBORD				
	aCalcIRPF[2] += (cAliasQry)->RETEBORD
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tratar-se de titulo de carreteiro, soma valor de INSS, ISS e SEST para recompor base de calculo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCarret
		aCalcIRPF[1] += (cAliasQry)->INSS + (cAliasQry)->ISS + (cAliasQry)->SEST //-- Recompoe valor para base de calculo			
		nINSSRet += (cAliasQry)->INSS //-- Valor de INSS a deduzir			
	EndIf									                                             
		
	(cAliasQry)->(dbSkip())						
					
Enddo

(cAliasQry)->(dbCloseARea())

//Base IRPF reduzida
IF lBaseIrpf
	cAliasQry := GetNextAlias()
		
	SE2->( dbCommit() ) 
	
	cQuery := " SELECT "
	cQuery += " SUM(E2_BASEIRF) BASEBORD" 
	cQuery += ", SUM(E2_IRRF) RETEBORD"
	cQuery += ", SUM(E2_INSS) RETINSBD"
	
	If lListTitu 
		cQuery += ", E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_, E2_FILORIG"
	EndIf
	
	cQuery += " FROM"
	cQuery += " " + RetSqlName( "SE2" ) + " SE2" 	
	cQuery += " INNER JOIN " + RetSqlName("SED") + " SED "
	// Traz somente títulos com natureza financeira que calcula impostos de renda
	cQuery += " ON SE2.D_E_L_E_T_ = ' ' AND SE2.E2_NATUREZ = SED.ED_CODIGO AND SED.ED_CALCIRF = 'S' " 	
	cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
	cQuery += " AND E2_FORNECE='"	+ cFornece + "'"
	cQuery += " AND E2_LOJA='" + cLoja + "'"

	//Para a manutencao de borderos (FINA590) devo considerar tambem os titulos do mesmo bordero
	//Para os demais considera-se apenas os titulos de borderos diferentes do atual.
	If !lFina590
		cQuery += " AND E2_NUMBOR <> '" + cNumBor + "'"
	Endif
	
	cQuery += " AND E2_NUMBOR <> '" + Space(TamSX3("E2_NUMBOR")[1]) + "'"
	cQuery += " AND ( (E2_DTBORDE >= '" + DTOS( dDataInic ) + "' AND E2_DTBORDE <= '"	+ DTOS( dDataFina ) + "') "
	cQuery += " OR (E2_BAIXA >= '" + DTOS( dDataInic ) + "' AND E2_BAIXA <= '"	+ DTOS( dDataFina ) + "') )"
	cQuery += " AND E2_BASEIRF > 0 "
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv)       
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTAXA,,3)
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTXA,,3)
	If nRegiDoct > 0
		cQuery += " AND SE2.R_E_C_N_O_ <> " + Str(nRegiDoct) 
	EndIf	
		
	cQuery += " AND SE2.D_E_L_E_T_=' '"                                             
	cQuery += " AND NOT EXISTS ("
	cQuery += 		" SELECT A.E5_NUMERO"
	cQuery += 		" FROM "+RetSqlName("SE5")+" A"
	cQuery += 		" WHERE A.E5_FILIAL='"+xFilial("SE5")+"'"
	cQuery +=		" AND A.E5_PREFIXO=SE2.E2_PREFIXO"
	cQuery +=		" AND A.E5_NUMERO=SE2.E2_NUM"
	cQuery +=		" AND A.E5_PARCELA=SE2.E2_PARCELA"
	cQuery +=		" AND A.E5_TIPO=SE2.E2_TIPO"
	cQuery +=		" AND A.E5_CLIFOR=SE2.E2_FORNECE"
	cQuery +=		" AND A.E5_LOJA=SE2.E2_LOJA"
	cQuery +=		" AND A.E5_MOTBX IN ('IRF','NOR')"
	cQuery +=		" AND A.E5_RECPAG = 'P' "
	cQuery +=		" AND A.E5_SITUACA != 'C' "
	cQuery +=		" AND A.D_E_L_E_T_<>'*')"
	
	If lListTitu 		
		
		cQuery += " GROUP BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_, E2_FILORIG"
		
	EndIf	
				
	cQuery := ChangeQuery( cQuery ) 			
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )			
	
	TCSetField( cAliasQry, "BASEBORD", "N", 12, 2 )	
	TCSetField( cAliasQry, "RETEBORD", "N", 12, 2 )		
	
	dbSelectArea(cAliasQry)
	dbGoTop()
	While ! Eof()		
		
		If lListTitu 

			If aScan(aRegsIRPF,(cAliasQry)->R_E_C_N_O_) == 0
				
				aAdd(aRegsIRPF,(cAliasQry)->R_E_C_N_O_)			
			
			EndIf
			
		EndIf				

		aCalcIRPF[1] += (cAliasQry)->BASEBORD - Iif(!GetCalcIss(iif(lListTitu,(cAliasQry)->E2_FILORIG,cFilAnt)) .AND. SA2->A2_TIPO == "F",(cAliasQry)->RETINSBD,0)				
		aCalcIRPF[2] += (cAliasQry)->RETEBORD							                                             
			
		(cAliasQry)->(dbSkip())						
						
	Enddo	
	
	(cAliasQry)->(dbCloseARea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma valores dos títulos de pagamento antecipado  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasQry := GetNextAlias()
		
SE2->( dbCommit() ) 	

cQuery := "SELECT"
cQuery += " SUM(E2_VALOR) BASERETE"
cQuery += ", SUM(E2_IRRF) RETEPGAN "

If lListTitu 
	cQuery += ", E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_"
EndIf	

cQuery += " FROM"
cQuery += " " + RetSqlName( "SE2" ) + " SE2" 	
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
cQuery += " AND E2_FORNECE='"	+ cFornece + "'"
cQuery += " AND E2_LOJA='" + cLoja + "'"
cQuery += " AND E2_EMISSAO >= '" + DTOS( dDataInic ) + "'"
cQuery += " AND E2_EMISSAO <= '"	+ DTOS( dDataFina ) + "'"
cQuery += " AND E2_TIPO IN " + FormatIn(MVPAGANT,"|") 
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) 
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTAXA,,3)
cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTXA,,3)

//Base IRPF reduzida
IF lBaseIrpf
	cQuery += " AND E2_BASEIRF = 0 "
Endif

// Quando o titulo de IRPJ for gerado na baixa do titulo principal, 
// calcula isoladamente o valor para este titulo sem acumular
If lIRPFBaixa .AND. SA2->A2_TIPO == "J"
	cQuery += " AND ( E2_IRRF > 0 AND E2_VRETIRF < E2_IRRF )"
EndIf

cQuery += " AND D_E_L_E_T_ = ' '"                                             

If lListTitu 
	cQuery += " GROUP BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_"
EndIf	
			
cQuery := ChangeQuery( cQuery ) 			
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )			

TCSetField( cAliasQry, "BASERETE", "N", 12, 2 )	
TCSetField( cAliasQry, "RETEPGAN", "N", 12, 2 )	

dbSelectArea(cAliasQry)
dbGoTop()
While ! Eof()	
	If lListTitu 
		If aScan(aRegsIRPF,(cAliasQry)->R_E_C_N_O_) == 0
			aAdd(aRegsIRPF,(cAliasQry)->R_E_C_N_O_)
		EndIf                                     
	EndIf	

	aCalcIRPF[1] += ((cAliasQry)->BASERETE + (cAliasQry)->RETEPGAN)
	aCalcIRPF[2] += (cAliasQry)->RETEPGAN	
	
	(cAliasQry)->(dbSkip())						
					
End
(cAliasQry)->(dbCloseARea())

//Base IRPF reduzida
IF lBaseIrpf

	cAliasQry := GetNextAlias()
			
	SE2->( dbCommit() ) 	

	cQuery := "SELECT"
	cQuery += " SUM(E2_VALOR) BASERETE"
	cQuery += ", SUM(E2_IRRF) RETEPGAN "

	If lListTitu 
		cQuery += ", E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_"
	EndIf	

	cQuery += " FROM"
	cQuery += " " + RetSqlName( "SE2" ) + " SE2" 	
	cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
	cQuery += " AND E2_FORNECE='"	+ cFornece + "'"
	cQuery += " AND E2_LOJA='" + cLoja + "'"
	cQuery += " AND E2_EMISSAO >= '" + DTOS( dDataInic ) + "'"
	cQuery += " AND E2_EMISSAO <= '"	+ DTOS( dDataFina ) + "'"
	cQuery += " AND E2_TIPO IN " + FormatIn(MVPAGANT,"|") 
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") 
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) 
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTAXA,,3)
	cQuery += " AND E2_TIPO NOT IN " + FormatIn(MVTXA,,3)
	cQuery += " AND E2_BASEIRF > 0 "
	cQuery += " AND D_E_L_E_T_ = ' '"                                             

	// Quando o titulo de IRPJ for gerado na baixa do titulo principal, 
	// calcula isoladamente o valor para este titulo sem acumular
	If lIRPFBaixa .AND. SA2->A2_TIPO == "J"
		cQuery += " AND ( E2_IRRF > 0 AND E2_VRETIRF < E2_IRRF )"
	EndIf


	If lListTitu 
		cQuery += " GROUP BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, SE2.R_E_C_N_O_"
	EndIf	
				
	cQuery := ChangeQuery( cQuery ) 			
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )			
	
	TCSetField( cAliasQry, "BASERETE", "N", 12, 2 )	
	TCSetField( cAliasQry, "RETEPGAN", "N", 12, 2 )	
		
	dbSelectArea(cAliasQry)
	dbGoTop()
	While ! Eof()	
		If lListTitu 
			If aScan(aRegsIRPF,(cAliasQry)->R_E_C_N_O_) == 0
				aAdd(aRegsIRPF,(cAliasQry)->R_E_C_N_O_)
			EndIf                                     
		EndIf	
	
		aCalcIRPF[1] += ((cAliasQry)->BASERETE + (cAliasQry)->RETEPGAN)
		aCalcIRPF[2] += (cAliasQry)->RETEPGAN	
			
		(cAliasQry)->(dbSkip())						
							
	Enddo
	(cAliasQry)->(dbCloseARea())

Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma ou deduz valores apurados a partir da        ³
//³rotina FINA375                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 	        
cAliasQry := GetNextAlias()
		
SE2->( dbCommit() ) 

cQuery := " SELECT "
cQuery += "	CASE WHEN SE2.E2_TIPO = 'NDF' THEN SUM(E2_VALOR) WHEN SE2.E2_TIPO <> 'NDF' THEN 0 END IRPFNDF "  
cQuery += ", CASE WHEN SE2.E2_TIPO = 'NCF' THEN SUM(E2_VALOR) WHEN SE2.E2_TIPO <> 'NCF' THEN 0 END IRPFNCF " 
cQuery += " FROM"
cQuery += " " + RetSqlName( "SE2" ) + " SE2" 	
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
cQuery += " AND E2_FORNECE='"	+ cFornece + "'"
cQuery += " AND E2_LOJA='" + cLoja + "'"
cQuery += " AND E2_NUMTIT = 'FINA375'"
cQuery += " AND E2_EMISSAO >= '" + DTOS( dDataInic ) + "'"
cQuery += " AND E2_EMISSAO <= '"	+ DTOS( dDataFina ) + "'"
cQuery += " AND E2_TIPO IN ('NCF','NDF')" 	
cQuery += " AND D_E_L_E_T_ = ' '"                                             
cQuery += " GROUP BY E2_TIPO "
			
cQuery := ChangeQuery( cQuery ) 	
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )			

TCSetField( cAliasQry, "IRPFNDF", "N", 12, 2 )	
TCSetField( cAliasQry, "IRPFNCF", "N", 12, 2 )		

dbSelectArea(cAliasQry)
dbGoTop()
While ! Eof()				

	aCalcIRPF[2] += (cAliasQry)->IRPFNDF 
	aCalcIRPF[2] -= (cAliasQry)->IRPFNCF
		
	(cAliasQry)->(dbSkip())						
					
Enddo	

(cAliasQry)->(dbCloseARea())
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento especifico para titulos de carreteiro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If lCarret
	
	SE2->(DbGoto(nRegiDoct))				
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aplica a reducao de base de calculo (Se houver)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
	If SED->ED_BASEIRC > 0
		aCalcIRPF[1] := ((aCalcIRPF[1] * SED->ED_BASEIRC) / 100)
	EndIf

EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deduz o INSS do IRRF 					                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//--Verifica se o valor do INSS ultrapassou o valor limite.
If nLimInss > 0 .And. nINSSRet > nLimInss
	nINSSRet := nLimInss
EndIf		
	
aCalcIRPF[1] := aCalcIRPF[1] - nINSSRet	

// Diminui valor com dedução de dependentes da base de 
// cálculo do IRPF                                     
If !lListTitu 
	aCalcIRPF[1] -= IIf(aCalcIRPF[1] > 0,nValoDedu,0)
Else
	aCalcIRPF[3] := aRegsIRPF
	aCalcIRPF[4] := nValoDedu
EndIf	

RestArea(aArea)

Return(aCalcIRPF)

Static Function GetCalcIss( cFilTit )
Local cFilOld	:= cFilAnt
Local lRet		:= .F.

Default cFilTit := cFilAnt

cFilAnt := cFilTit

If lIsIssBx
	lRet := IsIssBx("P")
Else
	lRet := (SuperGetMv("MV_MRETISS",.F.,"1") == "2")
Endif 

cFilAnt := cFilOld 

Return lRet