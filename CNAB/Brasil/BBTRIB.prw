#INCLUDE "PROTDEF.CH"
#INCLUDE "RWMAKE.CH" 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TECH08    �Autor  �Eduardo Augusto     � Data �  26/02/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �CNAB SISPAG - Banco do Brasil							      ���
���          � "PAGAMENTO DE TRIBUTOS"							          ���
�������������������������������������������������������������������������͹��
���Uso       � Evora - Regularizacao Documental Ltda                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TECH08()                      
Local _cRet		:=""
Local _cCodUF	:=""
Local _cCodMun	:=""
Local _cCodPla	:=""
Local _cCodRen	:=""
If SEA->EA_MODELO$"17" //Pagamento GPS
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,4),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4)	//Competencia / 135-140
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)									//Valor de pagamento do INSS / 141-155
	_cRet+=STRZERO(SE2->E2_ACRESC*100,15)									//Valor somado ao valor do documento / 156-170
	_cRet+=REPL("0",15)														//Atualiza��o monetaria / 171-185
	_cRet+=Space(45)														//Exclusivo Febraban / 186-230
ElseIf SEA->EA_MODELO$"16" //Pagamento de Darf Normal
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,4),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=StrZero(Day(SE2->E2_EMISSAO),2)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4) //Competencia / 135-142
	_cRet+=STRZERO(SE2->E2_ESNREF,17)										//Numero de referencia / 143-159
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)									//Valor Principal / 160-174
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)									//Valor da Multa / 175-189
	_cRet+=STRTRAN(STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,16,2),".","")	//Valor de Juros+Encargos / 190-204
	_cRet+=StrZero(Day(SE2->E2_VENCREA),2)+STRZERO(MONTH(SE2->E2_VENCREA),2)+STR(YEAR(SE2->E2_VENCREA),4)//Data de Vencimento / 205-212
	_cRet+=Space(18)														//Exclusivo Febraban / 213-230
ElseIf SEA->EA_MODELO$"18"//Pagamento de Darf Simples
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,4),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=StrZero(Day(SE2->E2_EMISSAO),2)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4) //Competencia / 135-142
	_cRet+=STRZERO(SE2->E2_ESVRBA*100,15)									//Valor da receita bruta acumulada / 143-157
	_cRet+=STRZERO(SE2->E2_ESPRB,7)											//Percentual da receita Bruta / 158-164
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)									//Valor principal / 165-179
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)									//Valor da Multa / 180-194
	_cRet+=STRTRAN(STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,16,2),".","")	//Valor de Juros+Encargos / 195-209
	_cRet+=Space(21)														//Exclusivo Febraban / 210-230
ElseIf SEA->EA_MODELO$"22/23/24" //Pagamento de Gare-SP (ICMS/DR/ITCMD)
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,4),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=StrZero(Day(SE2->E2_EMISSAO),2)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4) //Competencia / 135-142
	_cRet+=SUBS(SM0->M0_INSC,1,12)            								//Numero Inscri��o Estadual  / 143-154
	_cRet+=PADL(ALLTRIM(SE2->E2_ESCDA),13,"0")								//Codigo da divida Ativa / 155-167
	_cRet+=STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4)	//Periodo de Referencia / 168-173
	_cRet+=PADL(ALLTRIM(SE2->E2_ESNPN),13,"0")								//Numero Parcela-Notifica��o / 174-186
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)									//Valor da receita / 187-201
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,14)						//Valor de Juros+Encargos / 202-215
	_cRet+=STRZERO(SE2->E2_MULTA*100,14)									//Valor da Multa / 216-229
	_cRet+=Space(01)														//Exclusivo Febraban / 230-230	
ElseIf SEA->EA_MODELO$"25" //Pagamentto de IPVA
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,6),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)									//Competencia / 135-138
	_cRet+=PADL(ALLTRIM(SE2->E2_RENAV),9,"0")								//Codigo do Renavan / 139-147
	_cRet+=PADL(ALLTRIM(SE2->E2_UFESPAN),2,"0")							//UF do estado do veiculo / 148-149
	_cRet+=PADL(ALLTRIM(SE2->E2_MUESPAN),5,"0")							//Codigo do Municipio / 150-154
	_cRet+=PADL(STRTRAN(ALLTRIM(SE2->E2_PLACA),"-",""),7,"0")				//Placa do Veiculo / 155-161
//	_cCodRen:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_RENAVA")
//	_cRet+=PADL(ALLTRIM(_cCodRen),9,"0")									//Codigo do Renavan / 139-147
//	_cCodUF:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_ESTPLA")	
//	_cRet+=_cCodUF															//UF do estado do veiculo / 148-149
//	_cCodMun:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_CODMIN")	
//	_cRet+=_cCodMun															//Codigo do Municipio / 150-154
//	_cCodPla:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_PLACA")	
//	_cRet+=StrTran(_cCodPla,"-","")                                         //Placa do Veiculo / 155-161
	_cRet+=Alltrim(SE2->E2_ESOPIP)											//Codigo da cond. de pgto / 162-162
	_cRet+=Space(68)														//Exclusivo Febraban / 163-230		
ElseIf SEA->EA_MODELO$"27" //Pagamento DPVAT
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,6),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)									//Competencia / 135-138
	_cRet+=PADL(ALLTRIM(SE2->E2_RENAV),9,"0")								//Codigo do Renavan / 139-147
	_cRet+=PADL(ALLTRIM(SE2->E2_UFESPAN),2,"0")							//UF do estado do veiculo / 148-149
	_cRet+=PADL(ALLTRIM(SE2->E2_MUESPAN),5,"0")							//Codigo do Municipio / 150-154
	_cRet+=PADL(STRTRAN(ALLTRIM(SE2->E2_PLACA),"-",""),7,"0")				//Placa do Veiculo / 155-161
//	_cCodRen:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_RENAVA")
//	_cRet+=PADL(ALLTRIM(_cCodRen),9,"0")									//Codigo do Renavan / 139-147
//	_cCodUF:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_ESTPLA")	
//	_cRet+=_cCodUF															//UF do estado do veiculo / 148-149
//	_cCodMun:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_CODMIN")	
//	_cRet+=_cCodMun															//Codigo do Municipio / 150-154
//	_cCodPla:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_PLACA")	
//	_cRet+=StrTran(_cCodPla,"-","")                                         //Placa do Veiculo / 155-161
	_cRet+=Alltrim(SE2->E2_ESOPIP)											//Codigo da cond. de pgto / 162-162
	_cRet+=Space(68)														//Exclusivo Febraban / 163-230		
ElseIf SEA->EA_MODELO$"26" // Pagamento de Licenciamento
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,6),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=Alltrim(SEA->EA_MODELO)											//Codigo de identifica��o do contribuinte - Modelo de pagamento / 133-134
	_cRet+=STR(YEAR(SE2->E2_EMISSAO),4)									//Competencia / 135-138
	_cRet+=PADL(ALLTRIM(SE2->E2_RENAV),9,"0")								//Codigo do Renavan / 139-147
	_cRet+=PADL(ALLTRIM(SE2->E2_UFESPAN),2,"0")							//UF do estado do veiculo / 148-149
	_cRet+=PADL(ALLTRIM(SE2->E2_MUESPAN),5,"0")							//Codigo do Municipio / 150-154
	_cRet+=PADL(STRTRAN(ALLTRIM(SE2->E2_PLACA),"-",""),7,"0")				//Placa do Veiculo / 155-161
//	_cCodRen:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_RENAVA")
//	_cRet+=PADL(ALLTRIM(_cCodRen),9,"0")									//Codigo do Renavan / 139-147
//	_cCodUF:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_ESTPLA")	
//	_cRet+=_cCodUF															//UF do estado do veiculo / 148-149
//	_cCodMun:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVE,"DA3_CODMIN")	
//	_cRet+=_cCodMun															//Codigo do Municipio / 150-154
//	_cCodPla:=Posicione("DA3",3,xFilial("DA3")+SE2->E2_ESCODVEI,"DA3_PLACA")	
//	_cRet+=StrTran(_cCodPla,"-","")                                         //Placa do Veiculo / 155-161
	_cRet+=Alltrim(SE2->E2_ESOPIP)											//Codigo da cond. de pgto / 162-162
	_cRet+=Alltrim(SE2->E2_ESCRVL)											//Op��o de Retirada do CRVL / 163-163		
	_cRet+=Space(67)														//Exclusivo Febraban / 164-230		
ElseIf SEA->EA_MODELO$"21" // Pagamento de DARJ
	_cRet:=PADL(Substr(SE2->E2_ESCRT,1,6),6,"0")							//Codigo da Receita do Tributo / pos. 111-116
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 117-118
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 119-132
	_cRet+=SUBS(SM0->M0_INSC,1,8)            								//Numero Inscri��o Estadual  / 133-140
	_cRet+=STRZERO(SE2->E2_NUM,16)											//Numero do documento de origem / 141-156
	_cRet+=STRZERO(SE2->E2_SALDO*100,15)									//Valor da receita / 157-171
	_cRet+=REPL("0",15)														//Atualiza��o monetaria / 172-186	
	_cRet+=STRZERO(SE2->E2_JUROS+SE2->E2_ACRESC*100,15)						//Valor de Juros+Encargos / 187-201
	_cRet+=STRZERO(SE2->E2_MULTA*100,15)									//Valor da Multa / 202-216
	_cRet+=StrZero(Day(SE2->E2_EMISSAO),2)+STRZERO(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4) //Competencia / 217-224
	_cRet+=Space(06)														//Exclusivo Febraban / 225-230
ElseIf SEA->EA_MODELO$"11/35" // Pagamento de FGTS c/ Codigo de Barras
	_cRet:="01"																//Identificador do Tributo / pos. 177-178
	_cRet+=Substr(SE2->E2_ESCRT,1,6)										//Codigo da Receita do Tributo / pos. 179-184
	_cRet+=Substr(SE2->E2_ESTIC,1,2)										//Tipo de Identifica��o do Contribuinte / pos. 185-186
	_cRet+=PADL(ALLTRIM(SM0->M0_CGC),14,"0")								//Identifica��o do Contribuinte - CNPJ/CGC/CPF / 187-200
	_cRet+=STRZERO(SE2->E2_ESNFGTS,16)										//Campo Identificador do FGTS / 201-216
	_cRet+=STRZERO(SE2->E2_ESLACRE,9)										//Codigo do Lacre / 217-225
	_cRet+=STRZERO(SE2->E2_ESDGLAC,2)					   					//Digito do codigo do Lacre / 226-227
	_cRet+=Space(01)														//Exclusivo Febraban / 228-228
EndIf
Return(_cRet)