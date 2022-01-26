#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'
#include 'TbiConn.ch'

/*/{Protheus.doc} FA050DEL
Esse ponto de entrada � chamado para validar ou n�o a exclus�o do t�tulo a pagar

Link TDN: https://tdn.totvs.com/pages/releaseview.action?pageId=6071105

@author Vinicius Henrique
@since 20/11/2019
@version 1.0
@return llRet, Define se opera��o � valida.

@type function
/*/

user function FA050DEL()

Local cIdagl 	:= SE2->E2_XIDAGL
Local cQuery 	:= ''
Local aDados	:= {}
Local lRet		:= .T.
Local cAlias	:= GetNextAlias()
Local nCont		:= 0
Local nOpc		:= 0
Local nx

Default lContinua := .T.

If !Empty( alltrim( cIdagl ) )

	If lContinua

		cQuery := "SELECT *										" + CRLF
		cQuery += "FROM " + RetSQLName("SE2") + " SE2			" + CRLF
		cQuery += "WHERE SE2.D_E_L_E_T_ = ' '					" + CRLF
		cQuery += "AND SE2.E2_XIDAGL = '" + cIdagl + "'			" + CRLF
		
		TCQUERY cQuery NEW ALIAS (cAlias)
		
		(cAlias)->(DbGoTop())
		
		Do While (cAlias)->(!EoF())
		
			AADD(aDados,{(cAlias)->E2_NUM, (cAlias)->E2_PARCELA, (cAlias)->E2_PREFIXO,;
						(cAlias)->E2_FORNECE, (cAlias)->E2_LOJA, (cAlias)->E2_VALOR,(cAlias)->E2_FILIAL})
			
			nCont ++
			
			(cAlias)->(DbSkip())
		
		EndDO 
		
		(cAlias)->(DbCloseArea())
		
		cMsg := "Este titulo faz parte do ID de Aglutinação " +cIdagl+ ", o sistema irá realizar o estorno de todo o processo de aglutinação deste ID." + CRLF 	+ CRLF 
		
		cMsg += "Títulos envolvidos: " + CRLF 	+ CRLF 
			
		For nX := 1 to Len(aDados)
			cMsg += "Título: " + PADR(aDados[nX][1],10) + " Parcela: " + PADR(aDados[nX][2],4) + " Prefixo: " + PADR(aDados[nX][3],4) + CRLF
		Next nX
		
		cMsg += CRLF + CRLF 
		
		cMsg += "Deseja Prosseguir?"
			
		nOpc := Aviso("AGLUTINAÇÃO", cMsg, {"Sim", "Não"}, 3, "Estorno")
			
		If nOpc == 1
			fwMsgRun(,{|oSay| Processa( aDados, oSay, cIdagl ) },"Processando títulos","Aguarde..." )
		Else
			lRet := .F.
		EndIf

	Else
		lRet := .T.
	Endif
Else
	lRet := .T.
Endif

return lRet

/*/{Protheus.doc} Processa
//TODO Descri��o Processa os arquivos enviados atrav�s do array
@author Vinicius Henrique
@since 20/11/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function Processa(aRegs, oSay, cIdagl)

Local lMsErroAuto 	:= .F.
Local aBaixa		:= {}
Local nX

For nX := 1 to Len(aRegs)
	
	dbSelectArea("SE2")
	SE2->(dbSetOrder(27))
	SE2->(dbGoTop())
	
	lContinua := .T.

	If SE2->(MsSeek(aRegs[nX][7]+aRegs[nX][1] + aRegs[nX][2] + aRegs[nX][4] + aRegs[nX][5]))
	
		Begin Transaction

		RecLock("SE2",.F.)
		SE2->E2_XIDAGL := ''
		SE2->(MsUnlock())								
		
		If SE2->E2_SALDO = SE2->E2_VALOR
					
				// --> Monta o array com os dados a serem exclu�dos.
				aBaixa:= { {"E2_FILIAL" , SE2->E2_FILIAL  , Nil},;
						   {"E2_PREFIXO", SE2->E2_PREFIXO , Nil},;
						   {"E2_NUM"    , SE2->E2_NUM     , Nil},;
						   {"E2_VALOR"  , SE2->E2_VALOR	  , Nil}}
							   	
				lContinua := .F.
				
				oSay:setText( "Excluindo titulo: " + SE2->E2_NUM )
				
				MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aBaixa,, 5)
					
				If lMsErroAuto 
					DisarmTransaction()
					MostraErro()
					RecLock("SE2",.F.)
					SE2->E2_XIDAGL := cIdagl
					SE2->(MsUnlock())									
				EndIf
			
		Else
			cHistBaixa := "Cancelamento de Baixa"
			//�������������������������������������������������������
			//�Monta array com os dados da baixa a pagar do t�tulo�
			//������������������������������������������������������� 
			aBaixa := {}
			AADD(aBaixa, {"E2_FILIAL" 	, SE2->E2_FILIAL 	, Nil})
			AADD(aBaixa, {"E2_PREFIXO" 	, SE2->E2_PREFIXO 	, Nil})
			AADD(aBaixa, {"E2_NUM" 		, SE2->E2_NUM 		, Nil})
			AADD(aBaixa, {"E2_PARCELA" 	, SE2->E2_PARCELA 	, Nil})
			AADD(aBaixa, {"E2_TIPO" 	, SE2->E2_TIPO 		, Nil})
			AADD(aBaixa, {"E2_FORNECE" 	, SE2->E2_FORNECE 	, Nil})
			AADD(aBaixa, {"E2_LOJA" 	, SE2->E2_LOJA 		, Nil}) 
			AADD(aBaixa, {"E2_HIST" 	, cHistBaixa 		, Nil}) 
			
			lContinua := .F.
			
			oSay:setText( "Cancelando baixa titulo: " + SE2->E2_NUM )
						
			MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 5)
			
			If lMsErroAuto
				RecLock("SE2",.F.)
				SE2->E2_XIDAGL := cIdagl
				SE2->(MsUnlock())								
				MOSTRAERRO() 
				DisarmTransaction()
			EndIf 

		Endif
		
		SE2->(DbCloseArea())
		
		End Transaction

	EndIf
	
Next nX

msgInfo( "Processamento finalizado!" )

Return