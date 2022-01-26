#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'
#include 'FileIo.ch'
#INCLUDE "FWMVCDEF.CH"

/*���������������������������������������������������������������������������������
���Programa  �GP020TOK   �Autor  �Felipe Barros      � Data �06/05/2019       	���
�������������������������������������������������������������������������������͹��
���Descricao �GP020VAlPE - Ponto de Entrada para Exportar 	        			���
���							Arquivos de Dependtendes para TXT					���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�������������������������������������������������������������������������������͹��
���Retorno   �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       �Igreja Mundial do Poder de Deus                                   ���
�������������������������������������������������������������������������������͹��
���Revisao   �           �Autor  �                      � Data �                ���
�������������������������������������������������������������������������������͹��
���Descricao � 																	���
http://tdn.totvs.com/display/public/PROT/GP020VAlPE+-+Dados+de+Dependentes+--+23615       
���������������������������������������������������������������������������������*/

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
				
					If Len(aCols2) == 0					//-->	E aqui ir� verificar se n�o tiver dado no array � Inclus�o, sen�o Alter��o.
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
				
		FWMsgRun(, {|oSay| U_IMB011(aCols, nOpc) }, "Integra��o Boleta Eletr�nica", "Gerando Arquivo" )	
							
			RestArea(aArea)
	Return(.T.)
		
Return

/*������������������������������������������������������������������������������������
���Programa  �IMB011      �Autor  �Vinicius Henrique       � Data �17/09/2018      ���
����������������������������������������������������������������������������������͹��
���Descricao �IMB011  -  Gera arquivo txt com os dados de altera��o Dependentes    ���
����������������������������������������������������������������������������������͹��
���Parametros�                                                                     ���
����������������������������������������������������������������������������������͹��
���Retorno   �                                                                     ���
����������������������������������������������������������������������������������͹��
���Uso       �Igreja Mundial do Poder de Deus                                      ���
����������������������������������������������������������������������������������͹��
���Revisao   �  �Autor  �Felipe Barros                  � Data � 07/03/2019        ���
����������������������������������������������������������������������������������͹��
�� contato  �felipexd1945@hotmail.com 								 	��
����������������������������������������������������������������������������������͹��
���Descricao �
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
GROUP BY RA_MAT, RA_CIC, RB_NOME, RB_CIC, RB_DTNASC, RB_SEXO, RB_GRAUPAR			���
��������������������������������������������������������������������������������0����*/

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
					MsgAlert("Erro durante cria��o do arquivo.")		
				Else
																								
					If nOpc == 1 // --> Verifica qual tipo de opera��o est� sendo executada <--
						nOpc2 := "I"
					ElseIf nOpc == 2
						nOpc2 := "A"
					ElseIf nOpc == 3
						nOpc2 := "E"
					Endif			
									                                                               
							For nLinha := 1 to Len(aCols)
							
								cDtNasc := DTOS(aCols[nLinha][5])
								    //FWrite - Comando reponsavel pela grava��o do texto.
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