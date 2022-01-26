#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'
#include 'FileIo.ch'
#INCLUDE "FWMVCDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³GP020TOK   ºAutor  ³Felipe Barros      º Data ³06/05/2019       	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³GP020VAlPE - Ponto de Entrada para Exportar 	        			º±±
º±±							Arquivos de Dependtendes para TXT					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³           ºAutor  ³                      º Data ³                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ 																	º±±
http://tdn.totvs.com/display/public/PROT/GP020VAlPE+-+Dados+de+Dependentes+--+23615       
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GP020VAlPE()
	
	Local nOpc
	Local cQuery := ""
	Local aCols  := {}
	Local aCols2 := {}
	Local aArea	 := GetArea()
	Local cAlias := GetNextAlias()
	Local oModel := FwModelActive()
	//oModel		 := FwLoadModel("GPEA020")
	Local oGrid  := oModel:GetModel("GPEA020_SRB")	

	Local cCod	 := Alltrim(oGrid:GetValue("RB_COD"))
		
			If INCLUI
				nOpc := 1
				
			elseIf ALTERA					
													
				cQuery := "SELECT * FROM SRB020 WHERE RB_MAT = '"+SRA->RA_MAT+"' AND RB_COD = '"+cCod+"' AND D_E_L_E_T_ = ' ' " + CRLF

				TCQUERY cQuery NEW ALIAS (cAlias)
								
				Do While !(cAlias)->(Eof()) 
				
					aAdd(aCols2,{(cAlias)->RB_MAT,; 	//--> 	Somente para verificar se retorna algum resultado
								 (cAlias)->RB_NOME})		
							
							(cAlias)->(DbSkip())
				EndDo
				
					If Len(aCols2) == 0					//-->	E aqui irá verificar se não tiver dado no array é Inclusão, senão Alterção.
						nOpc := 1 //Incluir
					else 
						nOpc := 2 //Alterar
					endif
				
			else
				nOpc := 3 		 //Excluir
				
			endif	
			
				aAdd(aCols,{.F.				,;
				SRA->RA_CIC					,;		
				oGrid:GetValue("RB_NOME")	,;
				oGrid:GetValue("RB_CIC")	,;
				oGrid:GetValue("RB_DTNASC")	,; 
				oGrid:GetValue("RB_SEXO")	,;
				oGrid:GetValue("RB_GRAUPAR")})	
				
		FWMsgRun(, {|oSay| U_IMB011(aCols, nOpc) }, "Integração Boleta Eletrônica", "Gerando Arquivo" )	
							
			RestArea(aArea)
	Return(.T.)
		
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³IMB011      ºAutor  ³Vinicius Henrique       º Data ³17/09/2018      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³IMB011  -  Gera arquivo txt com os dados de alteração Dependentes    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Igreja Mundial do Poder de Deus                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³  ºAutor  ³Felipe Barros                  º Data ³ 07/03/2019        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± contato  ³felipexd1945@hotmail.com 								 	±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³
Gerar todos os dependentes: 
SELECT RA_MAT, RA_CIC, RB_NOME, RB_CIC, RB_DTNASC, RB_SEXO, RB_GRAUPAR FROM SRA020 SRA 
LEFT JOIN SRB020 SRB ON																  
SRA.RA_FILIAL = SRB.RB_FILIAL													     
AND SRA.RA_MAT = SRB.RB_MAT															 
AND SRB.D_E_L_E_T_ = ''																  
WHERE SRA.D_E_L_E_T_ = ''	
--AND SRA.RA_MAT='000017'														  
AND SRA.RA_DEMISSA = ''																 
AND RB_NOME IS NOT NULL																  
GROUP BY RA_MAT, RA_CIC, RB_NOME, RB_CIC, RB_DTNASC, RB_SEXO, RB_GRAUPAR			º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß0ßßßß*/

User Function IMB011(aCols, nOpc)

	Local 	cQuery	:= ""
	Local 	cAlias	:= GetNextAlias()
	Local 	cArqIg  := "dependentes" + "_" + DTOS(Date()) + "_" + StrTran(Time(),":","") + ".txt"
	Local 	nLinha	:= 0
	Local   cDirIg	:= "\Arquivos Boleta\Dependentes\"
	Local 	nOpc2 	

		If Len(aCols) > 0

			nHandle := FCreate(cDirIg+cArqIg)

				If nHandle < 0			
					MsgAlert("Erro durante criação do arquivo.")		
				Else
																								
					If nOpc == 1 // --> Verifica qual tipo de operação está sendo executada <--
						nOpc2 := "I"
					ElseIf nOpc == 2
						nOpc2 := "A"
					ElseIf nOpc == 3
						nOpc2 := "E"
					Endif			
									                                                               
							For nLinha := 1 to Len(aCols)
							
								cDtNasc := DTOS(aCols[nLinha][5])
								    //FWrite - Comando reponsavel pela gravação do texto.
								FWrite(nHandle,nOpc2 + PADR(aCols[nLinha][2],11,"") + PADR(aCols[nLinha][3],70,"") + PADR(aCols[nLinha][4],11,"");  
								+ cDtNasc + PADR(aCols[nLinha][6],1,"") + PADR(aCols[nLinha][7],1,"") + CRLF)  
				
							Next nLinha
	
						
					FClose(nHandle) //FClose - Comando que fecha o arquivo, liberando o uso para outros programas. 
					
					//MsgAlert("Efetuado com sucesso!")
				EndIf	
				
				If U_IMPDFTP()
					U_ImpdCpyFTP(cArqIg, 'DEPENDENTES')
				Endif
		EndIf
Return