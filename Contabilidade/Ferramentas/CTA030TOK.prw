#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTA030TOK   ºAutor  ³Vinicius Henrique     º Data ³31/03/2019	    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CTA030TOK - Ponto de Entrada para controlar tabela de Centro de 	º±±
º±±						  Custos na empresa 02									º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CTA030TOK()

	Local cQuery := ""
	Local Altera
	Local lRet := .F.
	
	If cEmpAnt == '01'
	
		If !Inclui	
		
			If M->CTT_XCONF == '1'
		
				cQuery := " UPDATE CTT020 SET
				cQuery += " CTT_CUSTO = '" + M->CTT_CUSTO + "', "
				cQuery += " CTT_CLASSE ='" + M->CTT_CLASSE + "', "
				cQuery += " CTT_DESC01 ='" + M->CTT_DESC01 + "', "
				cQuery += " CTT_BLOQ = 	'" + M->CTT_BLOQ + "', "
				cQuery += " CTT_CCLP = 	'" + M->CTT_CCLP + "', "
				cQuery += " CTT_CCSUP = '" + M->CTT_CCSUP + "', "
				cQuery += " CTT_RES = 	'" + M->CTT_RES + "', "
				cQuery += " CTT_ITOBRG ='" + M->CTT_ITOBRG + "', "
				cQuery += " CTT_CLOBRG ='" + M->CTT_CLOBRG + "', "
				cQuery += " CTT_ACITEM ='" + M->CTT_ACITEM + "', "
				cQuery += " CTT_ACCLVL ='" + M->CTT_ACCLVL + "' "
				cQuery += " WHERE CTT_CUSTO = '"+M->CTT_CUSTO+"' "
				
				lRet := .T.
				
				If TcSqlExec(cQuery) < 0
					alert(TcSqlError())
				Else
					TcSqlExec( "COMMIT" )				
				Endif
			
			Endif	
			
		Else
			  
			  cRec := LastRacno()
			  
			  cQuery := " INSERT INTO CTT020(
			  cQuery += " CTT_FILIAL,
			  cQuery += " CTT_CUSTO,
			  cQuery += " CTT_CLASSE,
			  cQuery += " CTT_DESC01,
			  cQuery += " CTT_BLOQ,
			  cQuery += " CTT_CCLP,
			  cQuery += " CTT_CCSUP,
			  cQuery += " CTT_RES,
			  cQuery += " CTT_ITOBRG,
			  cQuery += " CTT_CLOBRG,
			  cQuery += " CTT_ACITEM,
			  cQuery += " CTT_ACCLVL,
			  cQuery += " R_E_C_N_O_ )
			  cQuery += " VALUES(
			  cQuery += " '010010001', "
			  cQuery += " '" + M->CTT_CUSTO + "', "
			  cQuery += " '" + M->CTT_CLASSE + "', "
			  cQuery += " '" + M->CTT_DESC01 + "', "
			  cQuery += " '" + M->CTT_BLOQ + "', "
			  cQuery += " '" + M->CTT_CCLP + "', "
			  cQuery += " '" + M->CTT_CCSUP + "', "
			  cQuery += " '" + M->CTT_RES + "', "
			  cQuery += " '" + M->CTT_ITOBRG + "', "
			  cQuery += " '" + M->CTT_CLOBRG + "', "
			  cQuery += " '" + M->CTT_ACITEM + "', "
			  cQuery += " '" + M->CTT_ACCLVL + "', "
			  cQuery += " '" + cRec + "' )
			  
			  
			  If TcSqlExec(cQuery) < 0
				alert(TcSqlError())
			  Else
				TcSqlExec( "COMMIT" )				
			  Endif
		
		Endif
	
	Endif
	
Return()

Static Function LastRacno()

	Local cQuery := ""
	Local cAlias	:= GetNextAlias()

	cQuery	:= "SELECT MAX(R_E_C_N_O_) AS MAXCODIGO FROM CTT020	"

		TCQUERY cQuery NEW ALIAS (cAlias)
	
		(cAlias)->(dbGoTop())
	
		cRec := (cAlias)->MAXCODIGO
	
		cRec := cRec + 1
		
		cRec := cValtoChar(cRec)
	
return(cRec)