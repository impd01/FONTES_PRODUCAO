#INCLUDE "PROTDEF.CH"
#INCLUDE "RWMAKE.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³OBBTRIB   ºAutor  ³Eduardo Augusto     º Data ³  26/02/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  "CNAB PAGFOR - Banco Bradesco (Tributos)"                 º±±
±±º          ³  Layout de exportacao - DARF								  º±±
±±º          ³	Layout de exportacao - GPS								  º±±
±±º          ³	Layout de exportacao - GARE								  º±±
±±º          ³	Layout de exportacao - GARE-120 via codigo de barras	  º±±
±±º          ³	Layout de exportacao - FGTS via codigo de barras		  º±±
±±º          ³	Layout de exportacao - DARF via codigo de barras		  º±±
±±º          ³	Layout de exportacao - IPTU/ISS via codigo de barras	  º±±
±±º          ³	Layout de exportacao - Outros via codigo de barras		  º±±
±±º          ³	Layout de exportacao - GNRE via codigo de barras		  º±±
±±º          ³	Layout de exportacao - GNRE via digitaçcao				  º±±
±±º          ³	Layout de exportacao - DARF                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Shoeller							                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function OBBTRIB()                      
Local _cRet		:=""
//Local _cCodUF	:=""
//Local _cCodMun	:=""
Local _cCodPla	:=""
If SEA->EA_MODELO$"16" //Pagamento de Darf Normal
	_cRet:="2"
    _cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)
	_cRet+=STRZERO((SE2->E2_SALDO)+(SE2->E2_JUROS)+(SE2->E2_MULTA)+(SE2->E2_ACRESC)*100,15)	
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+=STRZERO(0,4)
	_cRet+=StrZero(YEAR(SE2->E2_EMISSAO),4)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(DAY(SE2->E2_EMISSAO),2)
	_cRet+=STRZERO(SE2->E2_ESPRB,4)
	_cRet+=IIF(EMPTY(SE2->E2_ESNREF),STRZERO(0,17),STRZERO(SE2->E2_ESNREF,17))
	_cRet+=STRZERO(15)
	_cRet+=SPACE(80)
	_cRet+=SPACE(91)				
ElseIf SEA->EA_MODELO$"18"//Pagamento de Darf Simples
	_cRet:="1"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)
	_cRet+=STRZERO((SE2->E2_SALDO)+(SE2->E2_JUROS)+(SE2->E2_MULTA)+(SE2->E2_ACRESC)*100,15)	
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="6106"
	_cRet+=StrZero(YEAR(SE2->E2_EMISSAO),4)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(DAY(SE2->E2_EMISSAO),2)
	_cRet+=STRZERO(SE2->E2_ESPRB,4)
	_cRet+=IIF(EMPTY(SE2->E2_ESNREF),STRZERO(0,17),STRZERO(VAL(SUBSTR(SE2->E2_ESNREF,1,17)),17))
	_cRet+=STRZERO(SE2->E2_ESVRBA*100,15)
	_cRet+=SPACE(80)
	_cRet+=SPACE(91)		
ElseIf SEA->EA_MODELO$"17" //Pagamento GPS
	_cRet:="7"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_MULTA*100,15)
	_cRet+=STRZERO(SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO((SE2->E2_SALDO)+(SE2->E2_JUROS)+(SE2->E2_MULTA)+(SE2->E2_ACRESC)*100,15)	
	_cRet+=strzero(val(Substr(SE2->E2_ESCRT,1,4)),4)						
	_cRet+=Alltrim(SE2->E2_ESTPID)
	_cRet+=Alltrim(SE2->E2_ESIDPG)
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)
	_cRet+=STRZERO(MONTH(SE2->E2_EMISSAO),2)
	_cRet+=SPACE(80)	
	_cRet+=If(Alltrim(SE2->E2_ESCRT)$'2631/2658',PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,""),SPACE(40))
	_cRet+=SPACE(81)		
ElseIf SEA->EA_MODELO$"23" //Pagamento de Gare-DR
	_cRet:="5"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS*100,15)
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)
	_cRet+=STRZERO(SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO(SE2->E2_VLRHONO*100,15)	
	_cRet+=STRZERO((SE2->E2_SALDO + SE2->E2_JUROS + SE2->E2_MULTA + SE2->E2_ACRESC + SE2->E2_VLRHONO)*100,15)
	_cRet+=SPACE(02)	
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)
	_cRet+=strzero(val(Substr(SE2->E2_ESCRT,1,4)),4)	
	_cRet+=strzero(val(SE2->E2_ESGRP),1)
	_cRet+=STRZERO(MONTH(SE2->E2_EMISSAO),2)
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)
	_cRet+=PADL(ALLTRIM(SM0->M0_INSC),12,"0")
	_cRet+=SPACE(13)	
	_cRet+=SPACE(13)			
	_cRet+=SPACE(01) 
	_cRet+=SPACE(01)
	_cRet+=SPACE(40)				
	_cRet+=PADL(SUBSTR(ALLTRIM(SE2->E2_OBS),1,40),40,"")
	_cRet+=PADL(ALLTRIM(SM0->M0_CNAE),7,"0")
	_cCodPla:=Posicione("DA3",1,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_PLACA")	
	_cRet+=_cCodPla
	_cRet+=SPACE(42)
Elseif SEA->EA_MODELO$"22" //Pagamento de Gare-ICMS
	_cRet:="6"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS*100,15)
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)
	_cRet+=STRZERO(SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO(SE2->E2_VLRHONO*100,15)	
	_cRet+=STRZERO((SE2->E2_SALDO + SE2->E2_JUROS + SE2->E2_MULTA + SE2->E2_ACRESC + SE2->E2_VLRHONO)*100,15)
	_cRet+=SPACE(02)	
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)
	_cRet+=strzero(val(Substr(SE2->E2_ESCRT,1,4)),4)	
	_cRet+=strzero(val(SE2->E2_ESGRP),1)
	_cRet+=STRZERO(MONTH(SE2->E2_EMISSAO),2)
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)
	_cRet+=PADL(ALLTRIM(SM0->M0_INSC),12,"0")
	_cRet+=SPACE(13)	
	_cRet+=SPACE(13)			
	_cRet+=SPACE(01) 
	_cRet+=SPACE(01)
	_cRet+=SPACE(40)				
	_cRet+=PADL(SUBSTR(ALLTRIM(SE2->E2_OBS),1,40),40,"")
	_cRet+=PADL(ALLTRIM(SM0->M0_CNAE),7,"0")
	_cCodPla:=Posicione("DA3",1,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_PLACA")	
	_cRet+=_cCodPla
	_cRet+=SPACE(42)
ElseIf SEA->EA_MODELO$"24" //Pagamento de Gare-120
	_cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
ElseIf SEA->EA_MODELO$"35" // Pagamento de FGTS c/ Codigo de Barras
	_cRet:="F"
 	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(08)
	_cRet+=SPACE(15)
	_cRet+=SPACE(15)
	_cRet+=SPACE(45)
	_cRet+=SPACE(20)
	_cRet+=SPACE(222)
	_cRet+="S"
	_cRet+=SPACE(80)
ElseIf SEA->EA_MODELO$"13" // Contas de consumo via Codigo de Barras
	_cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
ElseIf SEA->EA_MODELO$"15" // Darf Via Codigo de Barras
	_cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
ElseIf SEA->EA_MODELO$"19" // IPTU/ISS Via Codigo de Barras
	_cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
ElseIf SEA->EA_MODELO$"91" // Outros Tributos Via Codigo de Barras
    _cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
ElseIf SEA->EA_MODELO$"92" // GNRE Via Codigo de Barras
	_cRet:="B"
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)	
	_cRet+=SPACE(15)
	_cRet+="S"
	_cRet+=SPACE(390)
//Elseif SEA->EA_MODELO$"90" // GNRE Via Digitação
	_cRet:="G"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_NOMECOM),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ENDCOB),1,40),40,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,8),8,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")	
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CIDCOB),1,20),20,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_BAIRCOB),1,20),20,"")	
	_cRet+="2"
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_CGC),1,15),15,"")
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_TEL),1,20),20,"")
	_cRet+=StrZero(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(DAY(SE2->E2_VENCREA),2)
	_cRet+="S"
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,15)
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)
	_cRet+=Strzero(0,15)
	_cRet+=iif(empty(SE2->E2_LINDG),"0000" + PADR(ALLTRIM(SE2->E2_CODBAR),44,"0"),PADR(ALLTRIM(SE2->E2_LINDG),48,"0"))
	_cRet+=STR(YEAR(SE2->E2_VENCREA),4)+STRZERO(MONTH(SE2->E2_VENCREA),2)+StrZero(Day(SE2->E2_VENCREA),2)		
	_cRet+=strzero(val(Substr(SE2->E2_ESCRT,1,4)),4)
	_cRet+=PADL(SUBSTR(ALLTRIM(SM0->M0_ESTCOB),1,2),2,"")
	_cRet+=strzero(SE2->E2_ESNORIG,13)
	_cRet+=Space(1)
	_cRet+=strzero(SE2->E2_ESNREF,9)
	_cRet+=STRZERO(MONTH(SE2->E2_VENCREA),2)
	_cRet+=StrZero(Day(SE2->E2_VENCREA),2)
	_cRet+=PADL(ALLTRIM(SM0->M0_INSC),12,"0")
	_cRet+=Space(40)
	_cRet+=Space(40)
	_cRet+=strzero(0,2)	
	_cRet+=Space(21)
	_cRet+=PADL(ALLTRIM(SE2->E2_ESCSR),2,"") //CODIGO DA SUB RECEITA
	_cRet+=Space(44)
	_cRet+=Space(02) 
EndIf
Return (_cRet)