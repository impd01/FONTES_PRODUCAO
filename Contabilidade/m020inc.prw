#INCLUDE "Protheus.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ∫m020inc   ∫Autor∫Adilson Gomes         ∫ Data ∫ 31/03/2005  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ∫ Efetua a gravaÁ„o do Item Cont·bil (CTD) autom·ticamente   ∫±±
±±∫          ∫ Conforme definiÁ„o do projeto, o item cont·bil registrar·  ∫±±
±±∫          ∫ a contabilizaÁ„o de Cliente e Fornecedores, permitindo     ∫±±
±±∫          ∫ que a contabilidade tenha um plano de contas.              ∫±±
±±∫          ∫                                                            ∫±±
±±∫          ∫ O cadastro dos itens cont·beis ser· composto de:           ∫±±
±±∫          ∫ Fornecedores: "F" + SA2->A2_COD + SA2->A2_LOJA             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ∫ Especifico da BMA/SIGAFIN                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function M020INC()
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local aGetArea    := GetArea()
Local cCTDCod	  := "F00000"
Local cItemContab := "F" + SA2->(A2_COD+A2_LOJA)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Vari·veis para disparar emails≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	Local _cString	:= ""
	Local _cAssunto := "Fornecedor adicionado"
	Local _cTo		:= ""
	Local _cCopia	:= ""
	Local _lExibeMsg:= .T.	

	Local cNomeFor 	
	Local cCodFor	
    //Local cTipoFor
    Local cCgc      //CPF/CNPJ
////////////////////////////////////

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica se existe a conta superior≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
CTD->(dbSetOrder(1))
CTD->(dbGotop())
if !CTD->(dbSeek(xFilial("CTD")+cCTDCod))
	Reclock("CTD",.T.)
	CTD->CTD_FILIAL	:= xFilial("CTD")
	CTD->CTD_ITEM	:= cCTDCod
	CTD->CTD_CLASSE	:= "1"
	CTD->CTD_NORMAL	:= "0"
	CTD->CTD_DESC01	:= "CADASTRO DE FORNECEDOR"
	CTD->CTD_BLOQ	:= "2"
	CTD->CTD_DTEXIS	:= StoD("19800101")
	CTD->CTD_ITLP	:= cCTDCod
	CTD->CTD_ACCLVL	:= "1"
	CTD->CTD_CLOBRG	:= "2"
	MsUnlock()
Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica se esse item j· existe≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
CTD->(dbSetOrder(1))
CTD->(dbGotop())
if !CTD->(dbSeek(xFilial("CTD")+cItemContab))
	Reclock("CTD",.T.)
	CTD->CTD_FILIAL	:= xFilial("CTD")
	CTD->CTD_ITEM	:= Alltrim(cItemContab)
	CTD->CTD_CLASSE	:= "2"
	CTD->CTD_NORMAL	:= "0"
	CTD->CTD_DESC01	:= Alltrim(SA2->A2_NOME)    
	CTD->CTD_RES	:= Alltrim(SA2->A2_NREDUZ)	
	CTD->CTD_BLOQ	:= "2"
	CTD->CTD_DTEXIS	:= StoD("19800101")
	CTD->CTD_ITLP	:= Alltrim(cItemContab)
	CTD->CTD_ITSUP	:= cCTDCod
	CTD->CTD_ACCLVL	:= "1"
	CTD->CTD_CLOBRG	:= "2"
	MsUnlock()	
Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica se esse item j· existe≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//if empty(SA2->A2_ITCTB)
//	RecLock("SA2",.F.)
//	SA2->A2_ITCTB := cItemContab
//	MsUnlock()
//Endif

RestArea(aGetArea)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ∫m020inc   ∫Autor∫Felipe Barros         ∫ Data ∫ 07/10/2020  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ∫ Efetua o disparo de email para os emails na vari·vel __cTo ∫±±
±±∫          ∫ sempre que for incluÌdo um novo fornecedor.                ∫±±
±±∫          ∫                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ∫ MATA020                                                    ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
    
   //Local lExecuta := .T.// Valida√ß√µes do usu√°rio para inclus√£o de fornecedorReturn (lExecuta)

	cNomeFor := SA2->A2_NOME
	cCodFor	 := SA2->A2_COD
    cCgc     := SA2->A2_CGC
    
	_cTo		:= "felipe.silva@impd.org.br, rafael.albuquerque@impd.org.br, endrew.nunes@impd.org.br, conciliacao@impd.org.br"	//Destinat√°rios da notifica√ß√£o

    _cString	:= ""
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> VocÍ esta recebendo uma mensagem autom·tica da rotina de inclus„o de Fornecedores do sistema Protheus: </span> </p>"
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Cod: <b>" + cCodFor + "</b> </span> </p>"
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Razao Social: <b>" + cNomeFor + " </b> </span> </p>"
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> CPF/CNPJ: <b>" + cCgc + "</b> </span> </p>"
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Obs.: Este email n„o dever· ser respondido.</p> "

	U_ZSendMail(_cTo ,_cCopia   ,_cAssunto,_cString  ,  ,_lExibeMsg)

Return .T.
