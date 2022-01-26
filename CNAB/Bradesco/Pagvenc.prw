#INCLUDE "RWMAKE.CH"        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³PAGVENC   ºAutor  ³Eduardo Augusto     º Data ³  26/02/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Declaracao de variaveis utilizadas no programa atraves da   º±±
±±º			 ³funcao SetPrvt, que criara somente as variaveis definidas   º±±
±±º			 ³pelo usuario, identificando as variaveis publicas do sistemaº±±
±±º			 ³utilizadas no codigo. 									  º±±
±±º 		 ³Incluido pelo assistente de conversao do AP5 IDE 			  º±±
±±º 		 ³															  º±±
±±º 		 ³"VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS."			  º±±
±±º          ³CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (139-150)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shoeller								                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PAGVENC()
SetPrvt("_VENCVAL")
// VERIFICACAO DO VENCIMENTO DO CODIGO DE BARRAS 
_VENCVAL  :=  ""
IF !Empty(SE2->E2_CODBAR)
   _VENCVAL := PADL(SUBSTR(SE2->E2_CODBAR,6,14),14,"0")
EndIf
IF Empty(_VENCVAL)                                
	If !EMPTY(SE2->E2_ACRESC) .OR. !EMPTY(SE2->E2_DECRESC)
  	 	_VENCVAL := STRZERO(SE2->(E2_SALDO + E2_ACRESC - E2_DECRESC)*100,14)        
 	ElseIf EMPTY(SE2->E2_ACRESC) .OR. EMPTY(SE2->E2_DECRESC)
  		_VENCVAL  :=  "00000000000000"
    EndIf
EndIf
Return(_VENCVAL)