#INCLUDE "Totvs.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IGCONA01º Autor ³	Rafael Domingues º Data ³ 18/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescript. ³ Revisao e reajuste automaticos dos contratos          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Igreja                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IGCONA01()

	Local cQuery		:= ""
	Local aParam		:= {}
	Private nReaj		:= 0
	Private nTaxa		:= 0
	Private nTotCNB		:= 0
	Private cRevisa		:= ""
	Private aStrCN9		:= CN9->(dbStruct())
	Private aStrCNA		:= CNA->(dbStruct())
	Private aStrCNB		:= CNB->(dbStruct())
	Private aStrCNC		:= CNC->(dbStruct())
	Private aStrCNF		:= CNF->(dbStruct())
	Private aStrCNS		:= CNS->(dbStruct())
	Private aStrSE2		:= SE2->(dbStruct())
	Private lParam		:= .F.
	Private nRecCN9N	:= 0
	Private oLog		:= uLogClass():New() 
	
	//Carrega Parâmetros
	aParam := IGCONA01P()
	
	oLog:Add("Data de Processamento: " + DtoC(Date()))
	oLog:Add("Início do Processamento: " + Time())
	oLog:Skip()
	oLog:Add(" Dados Ambiente")
	oLog:Dash()
	oLog:Add(" Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
	oLog:Add(" Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ))
	oLog:Add(" Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ))
	oLog:Add(" DataBase...........: " + DtoC( dDataBase ) )
	oLog:Add(" Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time() )
	oLog:Add(" Environment........: " + GetEnvServer() )
	oLog:Add(" StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
	oLog:Add(" RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
	oLog:Add(" Versao.............: " + GetVersao(.T.) )
	oLog:Add(" Usuario TOTVS .....: " + __cUserId + " " +  cUserName)
	oLog:Dash()

	oLog:Skip()

	If lParam
		//Tratativa para erro do parambox
		If ValType(mv_par01) == "N"
		
			mv_par01 := StrZero(mv_par01,2)
			
		ElseIf ValType(mv_par01) == "C"
		
			mv_par01 := SubsTring(mv_par01,1,2)
			
		Endif
		
		oLog:Add("Processando Reajustes de Contratos")
		Processa({|| IGCONA1A()}, "Gerando revisões de contrato...")
	EndIf
	
	//Término do processamento
	oLog:Dash()
	oLog:Add("Término do processamento: " + Time())

	oLog:Show()

Return

Static Function IGCONA1A()

	Local cQuery	:= ""
	Local _cYear	:= MV_PAR02 //AllTrim(Str(Year(dDataBase)))
	Local _cMonth	:= MV_PAR01
	Local cCompet	:= _cMonth + '/' + _cYear //A competência de execução é o Mes parametrizado e o Ano de execução.
	
	cQuery := "SELECT DISTINCT "
	cQuery += "CN9_FILIAL, CN9_NUMERO  , CN9_DTINIC, CN9_DTASSI, CN9_UNVIGE, CN9_VIGE  , CN9_DTFIM , CN9_CLIENT, CN9_LOJACL, CN9_MOEDA , CN9_CONDPG, CN9_CODOBJ, CN9_TPCTO ,"
	cQuery += "CN9_VLINI , CN9_VLATU   , CN9_INDICE, CN9_FLGREJ, CN9_FLGCAU, CN9_TPCAUC, CN9_MINCAU, CN9_DTENCE, CN9_TIPREV, CN9_REVATU, CN9_SALDO , CN9_MOTPAR, CN9_XDTFIN,"
	cQuery += "CN9_DTFIMP, CN9_DTREIN  , CN9_CODJUS, CN9_CODCLA, CN9_DTREV , CN9_DTREAJ, CN9_VLREAJ, CN9_VLADIT, CN9_NUMTIT, CN9_VLMEAC, CN9_TXADM , CN9_FORMA , CN9_DTENTR,"
	cQuery += "CN9_LOCENT, CN9_CODENT  , CN9_DESFIN, CN9_CONTFI, CN9_DTINPR, CN9_PERPRO, CN9_UNIPRO, CN9_VLRPRO, CN9_DTPROP, CN9_DTULST, CN9_DTINCP, CN9_SITUAC, CN9_DESCRI,"
	cQuery += "CN9_END   , CN9_MUN     , CN9_BAIRRO, CN9_EST   , CN9_ESTADO, CN9_ALCISS, CN9_INSSMO, CN9_INSSME, CN9_DIACTB, CN9_NODIA , CN9_VLDCTR, CN9_DTVIGE, CN9_APROV ,"
	cQuery += "CN9_CODED , CN9_NUMPR   , CN9_USUAVA, CN9_PROGRA, CN9_ULTAVA, CN9_PROXAV, CN9_RESREM, CN9_FILORI, CN9_FILCTR, CN9_XTIPO , CN9_XREG  , CN9_XRDESC, CN9_XCEP  ,"
	cQuery += "CN9.R_E_C_N_O_ AS CN9REC, ISNULL(CN7_VLREAL,0) AS CN7_VLREAL, MAX(CN9_REVISA) AS CN9_REVISA, ISNULL(CN7_COMPET,'') AS CN7_COMPET "

	cQuery += " FROM "+RetSqlName("CN9")+" CN9 "
	cQuery += " INNER JOIN "+RetSqlName("CN6")+" CN6 ON CN6.D_E_L_E_T_ = '' AND CN6_FILIAL = '" + FWxFilial("CN6") + "' AND CN6_CODIGO = CN9_INDICE "
	cQuery += " LEFT JOIN "+RetSqlName("CN7")+" CN7 ON CN7.D_E_L_E_T_ = '' AND CN7_FILIAL = CN6_FILIAL AND CN7_CODIGO = CN6_CODIGO AND CN7_COMPET = '" + cCompet + "'"

	cQuery += " WHERE "
	cQuery += " CN9.D_E_L_E_T_ = '' "
	cQuery += " AND CN9_FILIAL = '" + FWxFilial("CN9") + "'"
	cQuery += " AND CN9_TPCTO = '001'  "
	cQuery += " AND CN9_SITUAC = '05' "
	cQuery += " AND SUBSTRING(CN9_DTINIC,5,2) = '" + _cMonth + "' "
	cQuery += " AND SUBSTRING(CN9_DTINIC,1,4) < '" + _cYear + "' "
	cQuery += " AND (SELECT COUNT(*) AS QTD FROM " + RetSqlName("CNA") + " CNA WHERE CNA.D_E_L_E_T_ = '' AND CNA.CNA_FILIAL = CN9.CN9_FILIAL AND CNA.CNA_CONTRA = CN9.CN9_NUMERO AND CNA.CNA_REVISA = CN9.CN9_REVISA AND CNA.CNA_FLREAJ = '1')  > 0 "
	cQuery += " AND ( (CN9_DTREAJ <> '' AND SUBSTRING(CN9_DTREAJ,1,4) < '" + _cYear + "') OR (CN9_DTREAJ = '') ) "
	
	
	//Query para testes
	cQuery += " AND CN9_NUMERO BETWEEN '000000000003531' AND '000000000003532' " 

	cQuery += " GROUP BY "
	cQuery += " CN9_FILIAL, CN9_NUMERO  , CN9_DTINIC, CN9_DTASSI, CN9_UNVIGE, CN9_VIGE  , CN9_DTFIM , CN9_CLIENT, CN9_LOJACL, CN9_MOEDA , CN9_CONDPG, CN9_CODOBJ, CN9_TPCTO , "
	cQuery += " CN9_VLINI , CN9_VLATU   , CN9_INDICE, CN9_FLGREJ, CN9_FLGCAU, CN9_TPCAUC, CN9_MINCAU, CN9_DTENCE, CN9_TIPREV, CN9_REVATU, CN9_SALDO , CN9_MOTPAR, CN9_XDTFIN, "
	cQuery += " CN9_DTFIMP, CN9_DTREIN  , CN9_CODJUS, CN9_CODCLA, CN9_DTREV , CN9_DTREAJ, CN9_VLREAJ, CN9_VLADIT, CN9_NUMTIT, CN9_VLMEAC, CN9_TXADM , CN9_FORMA , CN9_DTENTR, "
	cQuery += " CN9_LOCENT, CN9_CODENT  , CN9_DESFIN, CN9_CONTFI, CN9_DTINPR, CN9_PERPRO, CN9_UNIPRO, CN9_VLRPRO, CN9_DTPROP, CN9_DTULST, CN9_DTINCP, CN9_SITUAC, CN9_DESCRI, "
	cQuery += " CN9_END   , CN9_MUN     , CN9_BAIRRO, CN9_EST   , CN9_ESTADO, CN9_ALCISS, CN9_INSSMO, CN9_INSSME, CN9_DIACTB, CN9_NODIA , CN9_VLDCTR, CN9_DTVIGE, CN9_APROV , "
	cQuery += " CN9_CODED , CN9_NUMPR   , CN9_USUAVA, CN9_PROGRA, CN9_ULTAVA, CN9_PROXAV, CN9_RESREM, CN9_FILORI, CN9_FILCTR, CN9_XTIPO , CN9_XREG  , CN9_XRDESC, CN9_XCEP  , "
	cQuery += " CN9.R_E_C_N_O_, CN7_VLREAL,CN9_REVISA, CN7_COMPET "

	TcQuery cQuery New Alias "TMP"
	
	For ni := 1 to Len(aStrCN9)
		If aStrCN9[ni,2] $ "D#N"
			TCSetField('TMP', aStrCN9[ni,1], aStrCN9[ni,2],aStrCN9[ni,3],aStrCN9[ni,4])
		Endif
	Next
	
	DbSelectArea("TMP")
	DbGoTop()
	
	If ! TMP->( Eof() )
		While !Eof()
			
			If Empty(TMP->CN7_COMPET) .Or. TMP->CN7_VLREAL == 0 //Caso nao tenha cadastrado corretamente o historico do índice de reajuste
			
				//Log
				oLog:Add("O Contrato " + TMP->CN9_NUMERO + " não possui índice ou competência cadastrada para o período.")
				TMP->(dbSkip())
				Loop
				
			EndIf
			
			nTaxa   := TMP->CN7_VLREAL/100
			nReaj   := Round((TMP->CN9_SALDO * TMP->CN7_VLREAL) / 100,2)
			cRevisa := Padl(AllTrim(Str(Val(TMP->CN9_REVISA) + 1)),3,"0")
			_dDtMov	:= STOD(AllTrim(Str(Year(dDatabase))) + SubsTring(DtoS(TMP->CN9_DTINIC),5,4))
			
			DbSelectArea("CN9")
			RecLock("CN9",.T.)
			CN9->CN9_FILIAL  := TMP->CN9_FILIAL
			CN9->CN9_NUMERO  := TMP->CN9_NUMERO
			CN9->CN9_DTINIC  := TMP->CN9_DTINIC
			CN9->CN9_DTASSI  := TMP->CN9_DTASSI
			CN9->CN9_UNVIGE  := TMP->CN9_UNVIGE
			CN9->CN9_VIGE    := TMP->CN9_VIGE
			CN9->CN9_DTFIM   := TMP->CN9_DTFIM
			CN9->CN9_CLIENT  := TMP->CN9_CLIENT
			CN9->CN9_LOJACL  := TMP->CN9_LOJACL
			CN9->CN9_MOEDA   := TMP->CN9_MOEDA
			CN9->CN9_CONDPG  := TMP->CN9_CONDPG
			CN9->CN9_CODOBJ  := TMP->CN9_CODOBJ
			CN9->CN9_TPCTO   := TMP->CN9_TPCTO
			CN9->CN9_VLINI   := TMP->CN9_VLINI
			CN9->CN9_VLATU   := TMP->CN9_VLATU
			CN9->CN9_INDICE  := TMP->CN9_INDICE
			CN9->CN9_FLGREJ  := TMP->CN9_FLGREJ
			CN9->CN9_REVISA  := cRevisa
			CN9->CN9_FLGCAU  := TMP->CN9_FLGCAU
			CN9->CN9_TPCAUC  := TMP->CN9_TPCAUC
			CN9->CN9_MINCAU  := TMP->CN9_MINCAU
			CN9->CN9_DTENCE  := TMP->CN9_DTENCE
			CN9->CN9_TIPREV  := "002"
			CN9->CN9_REVATU  := TMP->CN9_REVATU
			CN9->CN9_SALDO   := TMP->CN9_SALDO
			CN9->CN9_MOTPAR  := TMP->CN9_MOTPAR
			CN9->CN9_DTFIMP  := TMP->CN9_DTFIMP
			CN9->CN9_DTREIN  := TMP->CN9_DTREIN
			CN9->CN9_CODJUS  := TMP->CN9_CODJUS
			CN9->CN9_CODCLA  := TMP->CN9_CODCLA
			CN9->CN9_DTREV   := dDatabase
			CN9->CN9_DTREAJ  := _dDtMov
			CN9->CN9_VLREAJ  := nReaj
			CN9->CN9_DTULST  := dDataBase
			CN9->CN9_VLADIT  := TMP->CN9_VLADIT
			CN9->CN9_NUMTIT  := TMP->CN9_NUMTIT
			CN9->CN9_VLMEAC  := TMP->CN9_VLMEAC
			CN9->CN9_TXADM   := TMP->CN9_TXADM
			CN9->CN9_FORMA   := TMP->CN9_FORMA
			CN9->CN9_DTENTR  := TMP->CN9_DTENTR
			CN9->CN9_LOCENT  := TMP->CN9_LOCENT
			CN9->CN9_CODENT  := TMP->CN9_CODENT
			CN9->CN9_DESFIN  := TMP->CN9_DESFIN
			CN9->CN9_CONTFI  := TMP->CN9_CONTFI
			CN9->CN9_DTINPR  := TMP->CN9_DTINPR
			CN9->CN9_PERPRO  := TMP->CN9_PERPRO
			CN9->CN9_UNIPRO  := TMP->CN9_UNIPRO
			CN9->CN9_VLRPRO  := TMP->CN9_VLRPRO
			CN9->CN9_DTPROP  := TMP->CN9_DTPROP
			CN9->CN9_DTINCP  := TMP->CN9_DTINCP
			CN9->CN9_SITUAC  := "05"
			CN9->CN9_DESCRI  := TMP->CN9_DESCRI
			CN9->CN9_END     := TMP->CN9_END
			CN9->CN9_MUN     := TMP->CN9_MUN
			CN9->CN9_BAIRRO  := TMP->CN9_BAIRRO
			CN9->CN9_EST     := TMP->CN9_EST
			CN9->CN9_ESTADO  := TMP->CN9_ESTADO
			CN9->CN9_ALCISS  := TMP->CN9_ALCISS
			CN9->CN9_INSSMO  := TMP->CN9_INSSMO
			CN9->CN9_INSSME  := TMP->CN9_INSSME
			CN9->CN9_DIACTB  := TMP->CN9_DIACTB
			CN9->CN9_NODIA   := TMP->CN9_NODIA
			CN9->CN9_VLDCTR  := TMP->CN9_VLDCTR
			CN9->CN9_DTVIGE  := TMP->CN9_DTVIGE
			CN9->CN9_APROV   := TMP->CN9_APROV
			CN9->CN9_CODED   := TMP->CN9_CODED
			CN9->CN9_NUMPR   := TMP->CN9_NUMPR
			CN9->CN9_USUAVA  := TMP->CN9_USUAVA
			CN9->CN9_PROGRA  := TMP->CN9_PROGRA
			CN9->CN9_ULTAVA  := TMP->CN9_ULTAVA
			CN9->CN9_PROXAV  := TMP->CN9_PROXAV
			CN9->CN9_RESREM  := TMP->CN9_RESREM
			CN9->CN9_FILORI  := TMP->CN9_FILORI
			CN9->CN9_FILCTR  := TMP->CN9_FILCTR
			CN9->CN9_XTIPO   := TMP->CN9_XTIPO
			CN9->CN9_XREG    := TMP->CN9_XREG
			CN9->CN9_XRDESC  := TMP->CN9_XRDESC
			CN9->CN9_XCEP    := TMP->CN9_XCEP
			CN9->CN9_XDTFIN  := TMP->CN9_XDTFIN
			MsUnLock()
			
			nRecCN9N := CN9->(Recno())
			
			DbSelectArea("CN9")
			DbGoTo(TMP->CN9REC)
			RecLock("CN9",.F.)
			CN9->CN9_REVATU := cRevisa
			CN9->CN9_SITUAC  := "10"
			MsUnLock()
			
			Processa({|| IGCONA1B()}, "Gerando cabecalho da planilha...")
			Processa({|| IGCONA1G()}, "Gerando cronograma financeiro...")
			Processa({|| IGCONA1I()}, "Gerando contas a pagar...")
			
			DbSelectArea("TMP")
			DbSkip()
			
		End
		
	Else
	
		oLog:Add("Nenhum registro encontrado com os parâmetros solicitados.")
		
	EndIf
	
	DbSelectArea("TMP")
	DbCloseArea()

Return

//ATUALIZA CNA - CABECALHO DA PLANILHA
Static Function IGCONA1B()

Local cFornAtu	:= ""
Local cFornNew	:= ""
Local lGravaCNC	:= .T.
//Variaveis para atualização do Saldo e Valor Atual do Contrato
Local nVlTot	:= 0
Local nSaldo	:= 0

Private lReajuste	:= .F.

cQuery := " SELECT * FROM "+RetSqlName("CNA")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNA_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNA_REVISA = '"+TMP->CN9_REVISA+"'	"
TcQuery cQuery New Alias "TMPA"

For ni := 1 to Len(aStrCNA)
	If aStrCNA[ni,2] $ "D#N"
		TCSetField('TMPA', aStrCNA[ni,1], aStrCNA[ni,2],aStrCNA[ni,3],aStrCNA[ni,4])
	Endif
Next

DbSelectArea("TMPA")
DbGoTop()

While !Eof()
	
	lReajuste := TMPA->CNA_FLREAJ == "1"
	
	nReaj := Iif(lReajuste,Round((TMPA->CNA_SALDO * TMP->CN7_VLREAL) / 100,2),0)
	
	DbSelectArea("CNA")
	RecLock("CNA",.T.)
	CNA->CNA_FILIAL := TMPA->CNA_FILIAL
	CNA->CNA_CONTRA := TMPA->CNA_CONTRA
	CNA->CNA_NUMERO := TMPA->CNA_NUMERO
	CNA->CNA_REVISA := cRevisa
	CNA->CNA_FORNEC := TMPA->CNA_FORNEC
	CNA->CNA_LJFORN := TMPA->CNA_LJFORN
	CNA->CNA_CLIENT := TMPA->CNA_CLIENT
	CNA->CNA_LOJACL := TMPA->CNA_LOJACL
	CNA->CNA_DTINI  := TMPA->CNA_DTINI
	CNA->CNA_VLTOT  := TMPA->CNA_VLTOT + nReaj
	CNA->CNA_SALDO  := TMPA->CNA_SALDO + nReaj
	CNA->CNA_TIPPLA := TMPA->CNA_TIPPLA
	CNA->CNA_DTFIM  := TMPA->CNA_DTFIM
	CNA->CNA_CRONOG := TMPA->CNA_CRONOG
	CNA->CNA_ESPEL  := TMPA->CNA_ESPEL
	CNA->CNA_FLREAJ := TMPA->CNA_FLREAJ
	CNA->CNA_DTMXMD := TMPA->CNA_DTMXMD
	CNA->CNA_CRONCT := TMPA->CNA_CRONCT
	CNA->CNA_VLCOMS := TMPA->CNA_VLCOMS
	MsUnLock()
	
	nTotCNB := TMPA->CNA_SALDO + nReaj
	
	Processa({|| IGCONA1C()}, "Gerando itens da planilha...")
	If lGravaCNC
		Processa({|| IGCONA1D()}, "Gerando amarracao fornecedor x contrato...")
	EndIf
	Processa({|| IGCONA1E()}, "Gerando cabecalho medicao...")
	Processa({|| IGCONA1F()}, "Gerando itens medicao...")
	Processa({|| IGCONA1H()}, "Gerando cronograma fisico...")
	
	DbSelectArea("TMPA")
	
	cFornAtu := TMPA->CNA_FORNEC
	
	nVlTot	+= TMPA->CNA_VLTOT + nReaj
	nSaldo	+= TMPA->CNA_SALDO + nReaj
	
	
	DbSkip()
	If !Eof()
		
		cFornNew := TMPA->CNA_FORNEC
	
		If cFornNew <> cFornAtu
			
			lGravaCNC := .T.
			
		Else
		
			lGravaCNC := .F.
			
		EndIf
		
	EndIf	
	
End

DbSelectArea("TMPA")
DbCloseArea()

//Atualiza Saldo e Valor Atual do Contrato
_aAreaTmp := GetArea()

dbSelectArea("CN9")
dbGoTo(nRecCN9N)
RecLock("CN9", .F.)

	Replace CN9->CN9_VLATU With nVlTot
	Replace CN9->CN9_SALDO With nSaldo
	
MsUnlock()

RestArea(_aAreaTmp)

Return

//ATUALIZA CNB - ITENS DA PLANILHA
Static Function IGCONA1C()

cQuery := " SELECT * FROM "+RetSqlName("CNB")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNB_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNB_REVISA = '"+TMP->CN9_REVISA+"'	"
cQuery += " AND CNB_NUMERO = '"+TMPA->CNA_NUMERO+"'	"
cQuery += " ORDER BY R_E_C_N_O_ DESC "
TcQuery cQuery New Alias "TMPB"

For ni := 1 to Len(aStrCNB)
	If aStrCNB[ni,2] $ "D#N"
		TCSetField('TMPB', aStrCNB[ni,1], aStrCNB[ni,2],aStrCNB[ni,3],aStrCNB[ni,4])
	Endif
Next

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	If TMPB->CNB_QTDMED == 0
		
		DbSelectArea("CNB")
		RecLock("CNB",.T.)
		CNB->CNB_FILIAL := TMPB->CNB_FILIAL
		CNB->CNB_NUMERO := TMPB->CNB_NUMERO
		CNB->CNB_REVISA := cRevisa
		CNB->CNB_ITEM   := "001"
		CNB->CNB_PRODUT := TMPB->CNB_PRODUT
		CNB->CNB_DESCRI := TMPB->CNB_DESCRI
		CNB->CNB_UM     := TMPB->CNB_UM
		CNB->CNB_QUANT  := TMPB->CNB_QUANT
		CNB->CNB_REALI  := TMPB->CNB_REALI
		CNB->CNB_DTREAL := TMPB->CNB_DTREAL
		CNB->CNB_VLTOTR := TMPB->CNB_VLTOTR
		CNB->CNB_VLUNIT := nTotCNB/TMPB->CNB_QUANT
		CNB->CNB_VLTOT  := nTotCNB
		CNB->CNB_DESC   := TMPB->CNB_DESC
		CNB->CNB_VLDESC := TMPB->CNB_VLDESC
		CNB->CNB_CODMEN := TMPB->CNB_CODMEN
		CNB->CNB_DTANIV := TMPB->CNB_DTANIV
		CNB->CNB_CONORC := TMPB->CNB_CONORC
		CNB->CNB_CONTRA := TMPB->CNB_CONTRA
		CNB->CNB_DTCAD  := TMPB->CNB_DTCAD
		CNB->CNB_DTPREV := TMPB->CNB_DTPREV
		CNB->CNB_QTDMED := 1
		CNB->CNB_CONTA  := TMPB->CNB_CONTA
		CNB->CNB_PERC   := TMPB->CNB_PERC
		CNB->CNB_RATEIO := TMPB->CNB_RATEIO
		CNB->CNB_TIPO   := TMPB->CNB_TIPO
		CNB->CNB_ITSOMA := TMPB->CNB_ITSOMA
		CNB->CNB_PRCORI := TMPB->CNB_VLUNIT
		CNB->CNB_QTDORI := TMPB->CNB_QUANT
		CNB->CNB_QTRDAC := TMPB->CNB_QTRDAC
		CNB->CNB_QTRDRZ := TMPB->CNB_QTRDRZ
		CNB->CNB_QTREAD := TMPB->CNB_QTREAD
		CNB->CNB_VLREAD := TMPB->CNB_VLREAD
		CNB->CNB_VLRDGL := TMPB->CNB_VLRDGL
		CNB->CNB_PERCAL := TMPB->CNB_PERCAL
		CNB->CNB_FILHO  := TMPB->CNB_FILHO
		CNB->CNB_SLDMED := TMPB->CNB_SLDMED
		CNB->CNB_NUMSC  := TMPB->CNB_NUMSC
		CNB->CNB_ITEMSC := TMPB->CNB_ITEMSC
		CNB->CNB_QTDSOL := TMPB->CNB_QTDSOL
		CNB->CNB_SLDREC := TMPB->CNB_SLDREC
		CNB->CNB_FLGCMS := TMPB->CNB_FLGCMS
		CNB->CNB_TE     := TMPB->CNB_TE
		CNB->CNB_TS     := TMPB->CNB_TS
		CNB->CNB_COPMED := TMPB->CNB_COPMED
		CNB->CNB_ITMDST := TMPB->CNB_ITMDST
		CNB->CNB_ULTAVA := TMPB->CNB_ULTAVA
		CNB->CNB_PROXAV := TMPB->CNB_PROXAV
		CNB->CNB_ITEMCT := TMPB->CNB_ITEMCT
		CNB->CNB_TABPRC := TMPB->CNB_TABPRC
		CNB->CNB_GERBIN := TMPB->CNB_GERBIN
		CNB->CNB_BASINS := TMPB->CNB_BASINS
		CNB->CNB_FILORI := TMPB->CNB_FILORI
		MsUnLock()
		
	Else
		
		DbSelectArea("CNB")
		RecLock("CNB",.T.)
		CNB->CNB_FILIAL := TMPB->CNB_FILIAL
		CNB->CNB_NUMERO := TMPB->CNB_NUMERO
		CNB->CNB_REVISA := cRevisa
		CNB->CNB_ITEM   := "001"
		CNB->CNB_PRODUT := TMPB->CNB_PRODUT
		CNB->CNB_DESCRI := TMPB->CNB_DESCRI
		CNB->CNB_UM     := TMPB->CNB_UM
		CNB->CNB_QUANT  := TMPB->CNB_QTDMED
		CNB->CNB_REALI  := TMPB->CNB_REALI
		CNB->CNB_DTREAL := TMPB->CNB_DTREAL
		CNB->CNB_VLTOTR := TMPB->CNB_VLTOTR
		CNB->CNB_VLUNIT := TMPB->CNB_VLUNIT
		CNB->CNB_VLTOT  := TMPB->CNB_VLUNIT * TMPB->CNB_QTDMED
		CNB->CNB_DESC   := TMPB->CNB_DESC
		CNB->CNB_VLDESC := TMPB->CNB_VLDESC
		CNB->CNB_CODMEN := TMPB->CNB_CODMEN
		CNB->CNB_DTANIV := TMPB->CNB_DTANIV
		CNB->CNB_CONORC := TMPB->CNB_CONORC
		CNB->CNB_CONTRA := TMPB->CNB_CONTRA
		CNB->CNB_DTCAD  := TMPB->CNB_DTCAD
		CNB->CNB_DTPREV := TMPB->CNB_DTPREV
		CNB->CNB_QTDMED := 1
		CNB->CNB_CONTA  := TMPB->CNB_CONTA
		CNB->CNB_PERC   := TMPB->CNB_PERC
		CNB->CNB_RATEIO := TMPB->CNB_RATEIO
		CNB->CNB_TIPO   := TMPB->CNB_TIPO
		CNB->CNB_ITSOMA := TMPB->CNB_ITSOMA
		CNB->CNB_PRCORI := TMPB->CNB_VLUNIT
		CNB->CNB_QTDORI := TMPB->CNB_QUANT
		CNB->CNB_QTRDAC := TMPB->CNB_QTRDAC
		CNB->CNB_QTRDRZ := TMPB->CNB_QTRDRZ
		CNB->CNB_QTREAD := TMPB->CNB_QTREAD
		CNB->CNB_VLREAD := TMPB->CNB_VLREAD
		CNB->CNB_VLRDGL := TMPB->CNB_VLRDGL
		CNB->CNB_PERCAL := TMPB->CNB_PERCAL
		CNB->CNB_FILHO  := TMPB->CNB_FILHO
		CNB->CNB_SLDMED := 0
		CNB->CNB_NUMSC  := TMPB->CNB_NUMSC
		CNB->CNB_ITEMSC := TMPB->CNB_ITEMSC
		CNB->CNB_QTDSOL := TMPB->CNB_QTDSOL
		CNB->CNB_SLDREC := TMPB->CNB_QTDMED
		CNB->CNB_FLGCMS := TMPB->CNB_FLGCMS
		CNB->CNB_TE     := TMPB->CNB_TE
		CNB->CNB_TS     := TMPB->CNB_TS
		CNB->CNB_COPMED := TMPB->CNB_COPMED
		CNB->CNB_ITMDST := "002"
		CNB->CNB_ULTAVA := TMPB->CNB_ULTAVA
		CNB->CNB_PROXAV := TMPB->CNB_PROXAV
		CNB->CNB_ITEMCT := TMPB->CNB_ITEMCT
		CNB->CNB_TABPRC := TMPB->CNB_TABPRC
		CNB->CNB_GERBIN := TMPB->CNB_GERBIN
		CNB->CNB_BASINS := TMPB->CNB_BASINS
		CNB->CNB_FILORI := TMPB->CNB_FILORI
		MsUnLock()
		
		DbSelectArea("CNB")
		RecLock("CNB",.T.)
		CNB->CNB_FILIAL := TMPB->CNB_FILIAL
		CNB->CNB_NUMERO := TMPB->CNB_NUMERO
		CNB->CNB_REVISA := cRevisa
		CNB->CNB_ITEM   := "002"
		CNB->CNB_PRODUT := TMPB->CNB_PRODUT
		CNB->CNB_DESCRI := TMPB->CNB_DESCRI
		CNB->CNB_UM     := TMPB->CNB_UM
		CNB->CNB_QUANT  := TMPB->CNB_QUANT - TMPB->CNB_QTDMED
		CNB->CNB_REALI  := TMPB->CNB_REALI
		CNB->CNB_DTREAL := TMPB->CNB_DTREAL
		CNB->CNB_VLTOTR := TMPB->CNB_VLTOTR
		CNB->CNB_VLUNIT := nTotCNB/(TMPB->CNB_QUANT - TMPB->CNB_QTDMED)
		CNB->CNB_VLTOT  := nTotCNB
		CNB->CNB_DESC   := TMPB->CNB_DESC
		CNB->CNB_VLDESC := TMPB->CNB_VLDESC
		CNB->CNB_CODMEN := TMPB->CNB_CODMEN
		CNB->CNB_DTANIV := TMPB->CNB_DTANIV
		CNB->CNB_CONORC := TMPB->CNB_CONORC
		CNB->CNB_CONTRA := TMPB->CNB_CONTRA
		CNB->CNB_DTCAD  := TMPB->CNB_DTCAD
		CNB->CNB_DTPREV := TMPB->CNB_DTPREV
		CNB->CNB_QTDMED := 0
		CNB->CNB_CONTA  := TMPB->CNB_CONTA
		CNB->CNB_PERC   := TMPB->CNB_PERC
		CNB->CNB_RATEIO := TMPB->CNB_RATEIO
		CNB->CNB_TIPO   := TMPB->CNB_TIPO
		CNB->CNB_ITSOMA := TMPB->CNB_ITSOMA
		CNB->CNB_PRCORI := TMPB->CNB_VLUNIT
		CNB->CNB_QTDORI := TMPB->CNB_QUANT
		CNB->CNB_QTRDAC := TMPB->CNB_QTRDAC
		CNB->CNB_QTRDRZ := TMPB->CNB_QTRDRZ
		CNB->CNB_QTREAD := TMPB->CNB_QTREAD
		CNB->CNB_VLREAD := TMPB->CNB_VLREAD
		CNB->CNB_VLRDGL := TMPB->CNB_VLRDGL
		CNB->CNB_PERCAL := TMPB->CNB_PERCAL
		CNB->CNB_FILHO  := TMPB->CNB_FILHO
		CNB->CNB_SLDMED := TMPB->CNB_QUANT - TMPB->CNB_QTDMED
		CNB->CNB_NUMSC  := TMPB->CNB_NUMSC
		CNB->CNB_ITEMSC := TMPB->CNB_ITEMSC
		CNB->CNB_QTDSOL := TMPB->CNB_QTDSOL
		CNB->CNB_SLDREC := TMPB->CNB_QUANT - TMPB->CNB_QTDMED
		CNB->CNB_FLGCMS := TMPB->CNB_FLGCMS
		CNB->CNB_TE     := TMPB->CNB_TE
		CNB->CNB_TS     := TMPB->CNB_TS
		CNB->CNB_COPMED := TMPB->CNB_COPMED
		CNB->CNB_ITMDST := TMPB->CNB_ITMDST
		CNB->CNB_ULTAVA := TMPB->CNB_ULTAVA
		CNB->CNB_PROXAV := TMPB->CNB_PROXAV
		CNB->CNB_ITEMCT := TMPB->CNB_ITEMCT
		CNB->CNB_TABPRC := TMPB->CNB_TABPRC
		CNB->CNB_GERBIN := TMPB->CNB_GERBIN
		CNB->CNB_BASINS := TMPB->CNB_BASINS
		CNB->CNB_FILORI := TMPB->CNB_FILORI
		MsUnLock()
		
	EndIf
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA CNC - AMARRACAO FORNECEDOR X CONTRATO
Static Function IGCONA1D()

cQuery := " SELECT DISTINCT * FROM "+RetSqlName("CNC")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNC_NUMERO = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNC_REVISA = '"+TMP->CN9_REVISA+"'	"
cQuery += " AND CNC_CODIGO = '"+TMPA->CNA_FORNEC+"'	"
TcQuery cQuery New Alias "TMPB"

For ni := 1 to Len(aStrCNC)
	If aStrCNC[ni,2] $ "D#N"
		TCSetField('TMPB', aStrCNC[ni,1], aStrCNC[ni,2],aStrCNC[ni,3],aStrCNC[ni,4])
	Endif
Next

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	DbSelectArea("CNC")
	RecLock("CNC",.T.)
	CNC->CNC_FILIAL := TMPB->CNC_FILIAL
	CNC->CNC_NUMERO := TMPB->CNC_NUMERO
	CNC->CNC_CODIGO := TMPB->CNC_CODIGO
	CNC->CNC_LOJA   := TMPB->CNC_LOJA
	CNC->CNC_CODED  := TMPB->CNC_CODED
	CNC->CNC_NUMPR  := TMPB->CNC_NUMPR
	CNC->CNC_REVISA := cRevisa
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA CND - CABECALHO MEDICAO
Static Function IGCONA1E()

cQuery := " SELECT R_E_C_N_O_ AS RECCND FROM "+RetSqlName("CND")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CND_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CND_REVISA = '"+TMP->CN9_REVISA+"'	"
cQuery += " AND CND_NUMERO = '"+TMPA->CNA_NUMERO+"'	"
TcQuery cQuery New Alias "TMPB"

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	DbSelectArea("CND")
	DbGoTo(TMPB->RECCND)
	RecLock("CND",.F.)
	CND->CND_REVISA := cRevisa
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA CNE - ITENS MEDICAO
Static Function IGCONA1F()

cQuery := " SELECT R_E_C_N_O_ AS RECCNE FROM "+RetSqlName("CNE")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNE_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNE_REVISA = '"+TMP->CN9_REVISA+"'	"
cQuery += " AND CNE_NUMERO = '"+TMPA->CNA_NUMERO+"'	"
TcQuery cQuery New Alias "TMPB"

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	DbSelectArea("CNE")
	DbGoTo(TMPB->RECCNE)
	RecLock("CNE",.F.)
	CNE->CNE_REVISA := cRevisa
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA CNF - CRONOGRAMA FINANCEIRO
Static Function IGCONA1G()

Local lReajuste	:= .F.

cQuery := " SELECT * FROM "+RetSqlName("CNF")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNF_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNF_REVISA = '"+TMP->CN9_REVISA+"'	"
TcQuery cQuery New Alias "TMPB"

For ni := 1 to Len(aStrCNF)
	If aStrCNF[ni,2] $ "D#N"
		TCSetField('TMPB', aStrCNF[ni,1], aStrCNF[ni,2],aStrCNF[ni,3],aStrCNF[ni,4])
	Endif
Next

DbSelectArea("TMPB")
DbGoTop()

While ! TMPB->(Eof())
	
	//Verifica se tem Reajuste ou Não
	cQuery := " SELECT CNA_FLREAJ FROM " + RetSqlName("CNA") + " CNA "
	cQuery += " WHERE CNA.D_E_L_E_T_ = '' "
	cQuery += " AND CNA_CRONOG = '" + TMPB->CNF_NUMERO + "' "
	cQuery += " AND CNA_FILIAL = '" + TMPB->CNF_FILIAL + "' "
	cQuery += " AND CNA_CONTRA = '" + TMPB->CNF_CONTRA + "' "
	cQuery += " AND CNA_REVISA = '" + TMPB->CNF_REVISA + "' "
	
	TcQuery cQuery Alias "TREAJ" NEW
	
	dbSelectArea("TREAJ")
	lReajuste := TREAJ->CNA_FLREAJ == "1"
	TREAJ->(dbCloseArea())
	
	DbSelectArea("CNF")
	RecLock("CNF",.T.)
	CNF->CNF_FILIAL := TMPB->CNF_FILIAL
	CNF->CNF_NUMERO := TMPB->CNF_NUMERO
	CNF->CNF_CONTRA := TMPB->CNF_CONTRA
	CNF->CNF_PARCEL := TMPB->CNF_PARCEL
	CNF->CNF_COMPET := TMPB->CNF_COMPET
	If TMPB->CNF_SALDO == 0
		CNF->CNF_VLPREV := TMPB->CNF_VLPREV
		CNF->CNF_VLREAL := TMPB->CNF_VLREAL
		CNF->CNF_SALDO  := TMPB->CNF_SALDO
		CNF->CNF_DTREAL := TMPB->CNF_DTREAL
	Else
		CNF->CNF_VLPREV := TMPB->CNF_VLPREV + Iif(lReajuste,(TMPB->CNF_VLPREV * nTaxa),0)
		CNF->CNF_VLREAL := 0
		CNF->CNF_SALDO  := TMPB->CNF_SALDO + Iif(lReajuste,(TMPB->CNF_SALDO * nTaxa),0)
	EndIf
	CNF->CNF_DTVENC := TMPB->CNF_DTVENC
	CNF->CNF_PRUMED := TMPB->CNF_PRUMED
	CNF->CNF_MAXPAR := TMPB->CNF_MAXPAR
	CNF->CNF_REVISA := cRevisa
	CNF->CNF_PERANT := TMPB->CNF_PERANT
	CNF->CNF_TXMOED := TMPB->CNF_TXMOED
	CNF->CNF_PERIOD := TMPB->CNF_PERIOD
	CNF->CNF_DIAPAR := TMPB->CNF_DIAPAR
	CNF->CNF_CONDPG := TMPB->CNF_CONDPG
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA CNS - CRONOGRAMA FISICO
Static Function IGCONA1H()

cQuery := " SELECT * FROM "+RetSqlName("CNS")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CNS_CONTRA = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND CNS_REVISA = '"+TMP->CN9_REVISA+"'	"
cQuery += " AND CNS_PLANI =  '"+TMPA->CNA_NUMERO+"'	"
TcQuery cQuery New Alias "TMPB"

For ni := 1 to Len(aStrCNS)
	If aStrCNS[ni,2] $ "D#N"
		TCSetField('TMPB', aStrCNS[ni,1], aStrCNS[ni,2],aStrCNS[ni,3],aStrCNS[ni,4])
	Endif
Next

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	DbSelectArea("CNS")
	RecLock("CNS",.T.)
	CNS->CNS_FILIAL	:= TMPB->CNS_FILIAL
	CNS->CNS_CONTRA	:= TMPB->CNS_CONTRA
	CNS->CNS_REVISA	:= cRevisa
	CNS->CNS_CRONOG	:= TMPB->CNS_CRONOG
	CNS->CNS_PARCEL	:= TMPB->CNS_PARCEL
	CNS->CNS_PLANI	:= TMPB->CNS_PLANI
	CNS->CNS_ITEM	:= TMPB->CNS_ITEM
	CNS->CNS_PRVQTD	:= TMPB->CNS_PRVQTD
	CNS->CNS_RLZQTD	:= TMPB->CNS_RLZQTD
	CNS->CNS_SLDQTD	:= TMPB->CNS_SLDQTD
	CNS->CNS_ITOR	:= TMPB->CNS_ITOR
	
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//ATUALIZA SE2 - CONTAS A PAGAR
Static Function IGCONA1I()

cQuery := " SELECT * FROM "+RetSqlName("SE2")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E2_MDCONTR = '"+TMP->CN9_NUMERO+"' "
cQuery += " AND E2_MDREVIS = '"+TMP->CN9_REVISA+"'	"
TcQuery cQuery New Alias "TMPB"

For ni := 1 to Len(aStrSE2)
	If aStrSE2[ni,2] $ "D#N"
		TCSetField('TMPB', aStrSE2[ni,1], aStrSE2[ni,2],aStrSE2[ni,3],aStrSE2[ni,4])
	Endif
Next

DbSelectArea("TMPB")
DbGoTop()

While !Eof()
	
	DbSelectArea("SE2")
	DbGoTo(TMPB->R_E_C_N_O_)
	RecLock("SE2",.F.)
	DbDelete()
	MsUnLock()
	
	RecLock("SE2",.T.)
	SE2->E2_FILIAL  := TMPB->E2_FILIAL
	SE2->E2_PREFIXO := TMPB->E2_PREFIXO
	SE2->E2_NUM     := TMPB->E2_NUM
	SE2->E2_PARCELA := TMPB->E2_PARCELA
	SE2->E2_TIPO    := TMPB->E2_TIPO
	SE2->E2_NATUREZ := TMPB->E2_NATUREZ
	SE2->E2_PORTADO := TMPB->E2_PORTADO
	SE2->E2_FORNECE := TMPB->E2_FORNECE
	SE2->E2_LOJA    := TMPB->E2_LOJA
	SE2->E2_NOMFOR  := TMPB->E2_NOMFOR
	SE2->E2_EMISSAO := TMPB->E2_EMISSAO
	SE2->E2_VENCTO  := TMPB->E2_VENCTO
	SE2->E2_VENCREA := TMPB->E2_VENCREA
	SE2->E2_VALOR   := (TMPB->E2_VALOR * nTaxa) + TMPB->E2_VALOR
	SE2->E2_ISS     := TMPB->E2_ISS
	SE2->E2_IRRF    := TMPB->E2_IRRF
	SE2->E2_NUMBCO  := TMPB->E2_NUMBCO
	SE2->E2_INDICE  := TMPB->E2_INDICE
	SE2->E2_BAIXA   := TMPB->E2_BAIXA
	SE2->E2_BCOPAG  := TMPB->E2_BCOPAG
	SE2->E2_EMIS1   := TMPB->E2_EMIS1
	SE2->E2_HIST    := TMPB->E2_HIST
	SE2->E2_LA      := TMPB->E2_LA
	SE2->E2_LOTE    := TMPB->E2_LOTE
	SE2->E2_MOTIVO  := TMPB->E2_MOTIVO
	SE2->E2_MOVIMEN := TMPB->E2_MOVIMEN
	SE2->E2_OP      := TMPB->E2_OP
	SE2->E2_SALDO   := (TMPB->E2_SALDO * nTaxa) + TMPB->E2_SALDO
	SE2->E2_OK      := TMPB->E2_OK
	SE2->E2_DESCONT := TMPB->E2_DESCONT
	SE2->E2_MULTA   := TMPB->E2_MULTA
	SE2->E2_JUROS   := TMPB->E2_JUROS
	SE2->E2_CORREC  := TMPB->E2_CORREC
	SE2->E2_VALLIQ  := TMPB->E2_VALLIQ
	SE2->E2_VENCORI := TMPB->E2_VENCORI
	SE2->E2_VALJUR  := TMPB->E2_VALJUR
	SE2->E2_PORCJUR := TMPB->E2_PORCJUR
	SE2->E2_MOEDA   := TMPB->E2_MOEDA
	SE2->E2_NUMBOR  := TMPB->E2_NUMBOR
	SE2->E2_FATPREF := TMPB->E2_FATPREF
	SE2->E2_FATURA  := TMPB->E2_FATURA
	SE2->E2_PROJETO := TMPB->E2_PROJETO
	SE2->E2_CLASCON := TMPB->E2_CLASCON
	SE2->E2_RATEIO  := TMPB->E2_RATEIO
	SE2->E2_DTVARIA := TMPB->E2_DTVARIA
	SE2->E2_VARURV  := TMPB->E2_VARURV
	SE2->E2_VLCRUZ  := (TMPB->E2_VLCRUZ * nTaxa) + TMPB->E2_VLCRUZ
	SE2->E2_DTFATUR := TMPB->E2_DTFATUR
	SE2->E2_ACRESC  := TMPB->E2_ACRESC
	SE2->E2_TITORIG := TMPB->E2_TITORIG
	SE2->E2_IMPCHEQ := TMPB->E2_IMPCHEQ
	SE2->E2_PARCIR  := TMPB->E2_PARCIR
	SE2->E2_ARQRAT  := TMPB->E2_ARQRAT
	SE2->E2_OCORREN := TMPB->E2_OCORREN
	SE2->E2_ORIGEM  := TMPB->E2_ORIGEM
	SE2->E2_IDENTEE := TMPB->E2_IDENTEE
	SE2->E2_FLUXO   := TMPB->E2_FLUXO
	SE2->E2_PARCISS := TMPB->E2_PARCISS
	SE2->E2_ORDPAGO := TMPB->E2_ORDPAGO
	SE2->E2_DESDOBR := TMPB->E2_DESDOBR
	SE2->E2_INSS    := TMPB->E2_INSS
	SE2->E2_PARCINS := TMPB->E2_PARCINS
	SE2->E2_NUMLIQ  := TMPB->E2_NUMLIQ
	SE2->E2_BCOCHQ  := TMPB->E2_BCOCHQ
	SE2->E2_AGECHQ  := TMPB->E2_AGECHQ
	SE2->E2_CTACHQ  := TMPB->E2_CTACHQ
	SE2->E2_DATALIB := TMPB->E2_DATALIB
	SE2->E2_APROVA  := TMPB->E2_APROVA
	SE2->E2_TIPOFAT := TMPB->E2_TIPOFAT
	SE2->E2_FLAGFAT := TMPB->E2_FLAGFAT
	SE2->E2_ANOBASE := TMPB->E2_ANOBASE
	SE2->E2_MESBASE := TMPB->E2_MESBASE
	SE2->E2_TXMOEDA := TMPB->E2_TXMOEDA
	SE2->E2_SDACRES := TMPB->E2_SDACRES
	SE2->E2_DECRESC := TMPB->E2_DECRESC
	SE2->E2_SDDECRE := TMPB->E2_SDDECRE
	SE2->E2_USUALIB := TMPB->E2_USUALIB
	SE2->E2_MULTNAT := TMPB->E2_MULTNAT
	SE2->E2_NUMTIT  := TMPB->E2_NUMTIT
	SE2->E2_PROJPMS := TMPB->E2_PROJPMS
	SE2->E2_PLLOTE  := TMPB->E2_PLLOTE
	SE2->E2_DIRF    := TMPB->E2_DIRF
	SE2->E2_CODRET  := TMPB->E2_CODRET
	SE2->E2_MODSPB  := TMPB->E2_MODSPB
	SE2->E2_IDCNAB  := TMPB->E2_IDCNAB
	SE2->E2_PARCCSS := TMPB->E2_PARCCSS
	SE2->E2_RETENC  := TMPB->E2_RETENC
	SE2->E2_CONTAD  := TMPB->E2_CONTAD
	SE2->E2_CODORCA := TMPB->E2_CODORCA
	SE2->E2_SEST    := TMPB->E2_SEST
	SE2->E2_PARCSES := TMPB->E2_PARCSES
	SE2->E2_FILDEB  := TMPB->E2_FILDEB
	SE2->E2_FILORIG := TMPB->E2_FILORIG
	SE2->E2_FORNISS := TMPB->E2_FORNISS
	SE2->E2_LOJAISS := TMPB->E2_LOJAISS
	SE2->E2_DEBITO  := TMPB->E2_DEBITO
	SE2->E2_CCD     := TMPB->E2_CCD
	SE2->E2_ITEMD   := TMPB->E2_ITEMD
	SE2->E2_CLVLDB  := TMPB->E2_CLVLDB
	SE2->E2_CREDIT  := TMPB->E2_CREDIT
	SE2->E2_CCC     := TMPB->E2_CCC
	SE2->E2_ITEMC   := TMPB->E2_ITEMC
	SE2->E2_CLVLCR  := TMPB->E2_CLVLCR
	SE2->E2_COFINS  := TMPB->E2_COFINS
	SE2->E2_PIS     := TMPB->E2_PIS
	SE2->E2_CSLL    := TMPB->E2_CSLL
	SE2->E2_PARCCOF := TMPB->E2_PARCCOF
	SE2->E2_PARCPIS := TMPB->E2_PARCPIS
	SE2->E2_PARCSLL := TMPB->E2_PARCSLL
	SE2->E2_TITPIS  := TMPB->E2_TITPIS
	SE2->E2_TITCOF  := TMPB->E2_TITCOF
	SE2->E2_TITCSL  := TMPB->E2_TITCSL
	SE2->E2_TITINS  := TMPB->E2_TITINS
	SE2->E2_VRETPIS := TMPB->E2_VRETPIS
	SE2->E2_VRETCOF := TMPB->E2_VRETCOF
	SE2->E2_VRETCSL := TMPB->E2_VRETCSL
	SE2->E2_PRETPIS := TMPB->E2_PRETPIS
	SE2->E2_PRETCOF := TMPB->E2_PRETCOF
	SE2->E2_PRETCSL := TMPB->E2_PRETCSL
	SE2->E2_SEQBX   := TMPB->E2_SEQBX
	SE2->E2_CODBAR  := TMPB->E2_CODBAR
	SE2->E2_BASECOF := TMPB->E2_BASECOF
	SE2->E2_BASEPIS := TMPB->E2_BASEPIS
	SE2->E2_BASECSL := TMPB->E2_BASECSL
	SE2->E2_VRETISS := TMPB->E2_VRETISS
	SE2->E2_VENCISS := TMPB->E2_VENCISS
	SE2->E2_VBASISS := TMPB->E2_VBASISS
	SE2->E2_MDRTISS := TMPB->E2_MDRTISS
	SE2->E2_VARIAC  := TMPB->E2_VARIAC
	SE2->E2_PERIOD  := TMPB->E2_PERIOD
	SE2->E2_MDCONTR := TMPB->E2_MDCONTR
	SE2->E2_MDREVIS := cRevisa
	SE2->E2_MDPLANI := TMPB->E2_MDPLANI
	SE2->E2_MDCRON  := TMPB->E2_MDCRON
	SE2->E2_MDPARCE := TMPB->E2_MDPARCE
	SE2->E2_FRETISS := TMPB->E2_FRETISS
	SE2->E2_TXMDCOR := TMPB->E2_TXMDCOR
	SE2->E2_APLVLMN := TMPB->E2_APLVLMN
	SE2->E2_CLEARIN := TMPB->E2_CLEARIN
	SE2->E2_HORASPB := TMPB->E2_HORASPB
	SE2->E2_PRETIRF := TMPB->E2_PRETIRF
	SE2->E2_SEFIP   := TMPB->E2_SEFIP
	SE2->E2_TRETISS := TMPB->E2_TRETISS
	SE2->E2_VRETIRF := TMPB->E2_VRETIRF
	SE2->E2_PLOPELT := TMPB->E2_PLOPELT
	SE2->E2_CODRDA  := TMPB->E2_CODRDA
	SE2->E2_PARCFET := TMPB->E2_PARCFET
	SE2->E2_FETHAB  := TMPB->E2_FETHAB
	SE2->E2_FORORI  := TMPB->E2_FORORI
	SE2->E2_LOJORI  := TMPB->E2_LOJORI
	SE2->E2_STATUS  := TMPB->E2_STATUS
	SE2->E2_DTDIRF  := TMPB->E2_DTDIRF
	SE2->E2_TITADT  := TMPB->E2_TITADT
	SE2->E2_TITPAI  := TMPB->E2_TITPAI
	SE2->E2_INSSRET := TMPB->E2_INSSRET
	SE2->E2_CODAGL  := TMPB->E2_CODAGL
	SE2->E2_PROCPCC := TMPB->E2_PROCPCC
	SE2->E2_FORNPAI := TMPB->E2_FORNPAI
	SE2->E2_CODISS  := TMPB->E2_CODISS
	SE2->E2_USUASUS := TMPB->E2_USUASUS
	SE2->E2_USUACAN := TMPB->E2_USUACAN
	SE2->E2_DATASUS := TMPB->E2_DATASUS
	SE2->E2_DATACAN := TMPB->E2_DATACAN
	SE2->E2_LIMCAN  := TMPB->E2_LIMCAN
	SE2->E2_PREOP   := TMPB->E2_PREOP
	SE2->E2_BASEISS := TMPB->E2_BASEISS
	SE2->E2_NUMPRO  := TMPB->E2_NUMPRO
	SE2->E2_INDPRO  := TMPB->E2_INDPRO
	SE2->E2_PARCAGL := TMPB->E2_PARCAGL
	SE2->E2_NODIA   := TMPB->E2_NODIA
	SE2->E2_DIACTB  := TMPB->E2_DIACTB
	SE2->E2_MDMULT  := TMPB->E2_MDMULT
	SE2->E2_MDBONI  := TMPB->E2_MDBONI
	SE2->E2_MDDESC  := TMPB->E2_MDDESC
	SE2->E2_RETCNTR := TMPB->E2_RETCNTR
	SE2->E2_CIDE    := TMPB->E2_CIDE
	SE2->E2_PRETINS := TMPB->E2_PRETINS
	SE2->E2_VRETINS := TMPB->E2_VRETINS
	SE2->E2_FATFOR  := TMPB->E2_FATFOR
	SE2->E2_FATLOJ  := TMPB->E2_FATLOJ
	SE2->E2_BASEIRF := TMPB->E2_BASEIRF
	SE2->E2_DATAAGE := TMPB->E2_DATAAGE
	SE2->E2_TEMDOCS := TMPB->E2_TEMDOCS
	SE2->E2_STATLIB := TMPB->E2_STATLIB
	SE2->E2_CODAPRO := TMPB->E2_CODAPRO
	SE2->E2_IDMOV   := TMPB->E2_IDMOV
	SE2->E2_PRINSS  := TMPB->E2_PRINSS
	SE2->E2_BASEINS := TMPB->E2_BASEINS
	SE2->E2_PARCCID := TMPB->E2_PARCCID
	SE2->E2_CODRCSL := TMPB->E2_CODRCSL
	SE2->E2_CODRPIS := TMPB->E2_CODRPIS
	SE2->E2_CODRCOF := TMPB->E2_CODRCOF
	SE2->E2_TIPOLIQ := TMPB->E2_TIPOLIQ
	SE2->E2_PARIMP5 := TMPB->E2_PARIMP5
	SE2->E2_PARIMP4 := TMPB->E2_PARIMP4
	SE2->E2_PARIMP3 := TMPB->E2_PARIMP3
	SE2->E2_PARIMP2 := TMPB->E2_PARIMP2
	SE2->E2_PARIMP1 := TMPB->E2_PARIMP1
	SE2->E2_CODINS  := TMPB->E2_CODINS
	SE2->E2_IDDARF  := TMPB->E2_IDDARF
	SE2->E2_DTBORDE := TMPB->E2_DTBORDE
	SE2->E2_MSIDENT := TMPB->E2_MSIDENT
	SE2->E2_PRISS   := TMPB->E2_PRISS
	SE2->E2_RATFIN  := TMPB->E2_RATFIN
	SE2->E2_NUMSOL  := TMPB->E2_NUMSOL
	SE2->E2_CODOPE  := TMPB->E2_CODOPE
	SE2->E2_FABOV   := TMPB->E2_FABOV
	SE2->E2_FACS    := TMPB->E2_FACS
	SE2->E2_PARCFAB := TMPB->E2_PARCFAB
	SE2->E2_PARCFAC := TMPB->E2_PARCFAC
	SE2->E2_FIMP    := TMPB->E2_FIMP
	SE2->E2_NFELETR := TMPB->E2_NFELETR
	SE2->E2_AGLIMP  := TMPB->E2_AGLIMP
	SE2->E2_PLACA   := TMPB->E2_PLACA
	SE2->E2_XAPURAC := TMPB->E2_XAPURAC
	SE2->E2_ESCRT   := TMPB->E2_ESCRT
	SE2->E2_ESNFGTS := TMPB->E2_ESNFGTS
	SE2->E2_ESLACRE := TMPB->E2_ESLACRE
	SE2->E2_ESDGLAC := TMPB->E2_ESDGLAC
	SE2->E2_ESOPIP  := TMPB->E2_ESOPIP
	SE2->E2_MUESPAN := TMPB->E2_MUESPAN
	SE2->E2_ESNPN   := TMPB->E2_ESNPN
	SE2->E2_ESCDA   := TMPB->E2_ESCDA
	SE2->E2_ESNORIG := TMPB->E2_ESNORIG
	SE2->E2_ESPRB   := TMPB->E2_ESPRB
	SE2->E2_ESVRBA  := TMPB->E2_ESVRBA
	SE2->E2_ESNREF  := TMPB->E2_ESNREF
	SE2->E2_ESOCOR2 := TMPB->E2_ESOCOR2
	SE2->E2_RENAV   := TMPB->E2_RENAV
	SE2->E2_UFESPAN := TMPB->E2_UFESPAN
	SE2->E2_XCOMPET := TMPB->E2_XCOMPET
	SE2->E2_XCC     := TMPB->E2_XCC
	SE2->E2_XCCDESC := TMPB->E2_XCCDESC
	SE2->E2_XTPAG   := TMPB->E2_XTPAG
	SE2->E2_XNOME   := TMPB->E2_XNOME
	SE2->E2_XFUNC   := TMPB->E2_XFUNC
	SE2->E2_TPDESC  := TMPB->E2_TPDESC
	SE2->E2_XVLINSS := TMPB->E2_XVLINSS
	SE2->E2_XOUTENT := TMPB->E2_XOUTENT
	SE2->E2_XACRFIN := TMPB->E2_XACRFIN
	SE2->E2_XCTSN   := TMPB->E2_XCTSN
	SE2->E2_XCONTRA := TMPB->E2_XCONTRA
	MsUnLock()
	
	DbSelectArea("TMPB")
	DbSkip()
	
End

DbSelectArea("TMPB")
DbCloseArea()

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} IGCONA01P
Parâmetros de execução da rotina de Reajuste

@author Jorge Heitor
@since  22/05/2017
@description Função que chama ParamBox para apresentar os parâmetros de execução da rotina
/*/
Static Function IGCONA01P()

	Local aRet := {}
	Local aParamBox := {}
	Local aMeses := {"01-Janeiro","02-Fevereiro","03-Março","04-Abril","05-Maio","06-Junho","07-Julho","08-Agosto","09-Setembro","10-Outubro","11-Novembro","12-Dezembro"}
	Local i := 0
	
	Private cCadastro := "Reajuste Automático de Contratos: " + AllTrim(DtoC(dDataBase))
	
	aAdd(aParamBox,{2,"Informe o Mês",Month(dDataBase),aMeses,50,"",.T.})
	aAdd(aParamBox,{1,"Informe o Ano"  ,Space(4),"","","","",50,.T.})
	// Tipo 2 -> Combo
	//           [2]-Descricao
	//           [3]-Numerico contendo a opcao inicial do combo
	//           [4]-Array contendo as opcoes do Combo
	//           [5]-Tamanho do Combo
	//           [6]-Validacao
	//           [7]-Flag .T./.F. Parametro Obrigatorio ?
	// Cuidado, há um problema nesta opção quando selecionado a 1ª opção.
	
	lParam := ParamBox(aParamBox, cCadastro, @aRet)
	
Return aRet
