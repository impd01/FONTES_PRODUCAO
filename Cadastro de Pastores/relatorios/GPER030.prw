#INCLUDE "GPER1030.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

#DEFINE Imp_Spool      	2
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   	1
#DEFINE ALIGN_V_BOTTON 	2

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER030  � Autor � R.H. - Ze Maria       � Data � 14.03.95 	        ���
�����������������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao de Recibos de Pagamento                                      ���
�����������������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER030(void)                                             	        ���
�����������������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                               		   		���
�����������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                        ���
�����������������������������������������������������������������������������������Ĵ��
���Programador � Data   � Chd./Requisito �  Motivo da Alteracao                     ���
�����������������������������������������������������������������������������������Ĵ��
���Ademar Jr.  �22/03/13�Requisito:      �-Unificacao dos fontes da fase padrao com ���
���            �        �RHU210_09_13    � a fase 4 (localizacoes).                 ���
���Sidney O.   �02/04/14�M_RH007   TPDCQD�Alteracao da funcao f030Roteiro - nao     ���
���            �        �                �exibe mais os roteiros G e J (INC e MUV)  ���
���Raquel Hager�02/09/14�TQM075			 �Utilizacao de tabela S036 para Mensagens. ���
���Renan Borges�09/10/14�TQNUVG          �Ajuste para imprimir log de ocorr�ncias   ���
���			   � 		�                �corretamente e sem gerar um relat�rio va- ���
���			   � 		�                �zio ap�s a impress�o do log de ocorr�ncias���
���Wag Mobile  �31/10/14�TQTXLQ          �Ajuste para imprimir verificando filtro da���
���			   � 		�                �aba de filtro corretamente.               ���
���Allyson M   �19/02/15�TRMMMT          �Ajuste na validacao da data de aniversario���
���			   � 		�                �no recibo enviado por email.	 			���
���Mariana M   �08/04/15�TRVPPK        	 �Ajuste no relatorio Zebrado para que no   ���
���			   � 		�                �mes do aniversario do funcionario,apresen-���
���			   � 		�                �tando a mensagem "Feliz Aniversario"		���
���	Emerson Ca�09/07/15� PCREQ-4461      �Criar a op��o de envio de PDF por email   ���
���	          �        �                 �Changset 294739                           ���
���Renan Borges�03/12/15�TTTLGI          �Ajuste para enviar recibo de pagamento no ���
���			   � 		�                �formato pdf por e-mail.                   ���
���C�cero Alves�17/12/15�TUABIP          �Ajuste para imprimir bases no recibo da 1����
���			   � 		�                �parcela do 13� em PDF				        ���
���Victor A.   �03/05/16�TUOBR0          �Ajuste na impress�o direto na LPT1.       ���
���P. Pompeu...�30/06/16�TVNITS          �Quebra por Func. e � Exibir Bases no Zebr.���
���Matheus M.  �27/07/16�TRMMMT          �Ajuste para n�o exibir caracteres estra-  ���
���			   � 		�                �nhos quando o driver de impress�o for  	���
���			   � 		�                �HP500C.								  	���
���Jonathan Glz�23/11/16�MMI-32          �Ajuste en el reporte para la localizacion ���
���			   � 		�                �para republica dominicana.                ���
���Isabel N.   �04/01/17�MRH-3746        �Ajuste no nome dos campos RA_CTDEPSAL para���
���            �        �                �RA_CTDEPSA e RA_BCDEPSAL para RA_BCDEPSA, ���
���            �        �                �conforme cadastrado no ATUSX.             ���
���Oswaldo L.  �01/02/17�MRH-5780        �Trativa para que o sistema apenas utilize ���
���            �        �                �os campos de acordo com o pais conectado  ���
���M. Silveira �09/02/17�MRH-6466        �Geracao de LOG com as matriculas que nao  ���
���            �        �                �foram enviadas por e-mail.				���
���Paulo O     �06/03/17�MRH-5873        �Acerto para Fun��o fContinua() pular 7 ao ���
���Inzonha     �        �                �inves de 8 linhas ap�s o texto "Continua" ���
���Paulo O     �26/04/17�DRHPAG-578      �Ajuste para ignorar a op��o Quebra por    ���
���Inzonha 	   �		�				 �Funcion�rio quando impresso direto na porta���
���            �        �                �Adicionada uma linha antes do cabe�alho    ���
���            �        �				 �quando n�o � continua��o do recibo anterior���
���Paulo O     �04/05/17�DRHPAG-578      �Ajuste para Adicionar uma linha antes do   ���
���Inzonha 	   �		�				 �Funcion�rio quando impresso direto na porta���
���            �        �                �cabe�alho quando  o recibo atual n�o �     ���
���            �        �				 �continua��o por�m o anterior � continua��o ���
���Paulo O.    �02/06/17�DRHPAG-1640     �Ajuste no layout do relat�rio para que     ���
���Inzonha     �        �                �sejam impressas as tr�s mensagem quando o  ���
���            �        �                �mesmo n�o tiver as bases.                  ��� 
�������������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
*/
User Function GPER030(lTerminal,cFilTerminal,cMatTerminal,cProcTerminal, nRecTipo, cPerTerminal, cSemanaTerminal)                 

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {STR0001,STR0002,STR0003,STR0004,STR0005,STR0177,STR0178} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"###"Depto."###"Depto. + Nome"
Local cDesc1 := STR0006		//"Emiss�o de Recibos de Pagamento."
Local cDesc2 := STR0007		//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0008		//"usu�rio."
Local aDriver:= ReadDriver(.T.)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local cIndCond
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
Local Baseaux := "S", cDemit := "N"
Local cHtml 	:= ""
Local cDriver	:= SuperGetMv("MV_DRIVER",.F.,"EPSON")

Private cMes	  := ""
Private cAno    := ""
Private aEmail  := {}
//��������������������������������������������������������������Ŀ
//� Define o numero da linha de impress�o como 0                 �
//����������������������������������������������������������������
SetPrc(0,0)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0009, 1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private nomeprog :="GPER030"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    :="GPER030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe , nTipRel

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

Private cFilRCJ := ""

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aLanca 			:= {}
Private aProve 			:= {}
Private aDesco 			:= {}
Private aBases 			:= {}
Private aInfo  			:= {}
Private aCodFol			:= {}
Private li     			:= _PROW()
Private Titulo 			:= STR0011		//"EMISS�O DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk 		:= .F.
Private lRetCanc		:= .t.
Private cIRefSem    	:= GetMv("MV_IREFSEM",,"S")
Private aPerAberto		:= {}
Private aPerFechado		:= {}
Private cProcesso		:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro		:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo		:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
Private cCcto			:= ""
Private cCond			:= ""
Private cRot			:= ""
Private lDepSf			:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
Private lLpt1			:= .F.
Private lFase4  		:= (cPaisLoc $ "ANG|ARG|COL|PTG|VEN")

//��������������������������������������������������������������Ŀ
//� Define Variaveis da Impressao Grafica                        �
//����������������������������������������������������������������
Private oPrint   
Private oArial08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N		:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)//Normal
Private oArial10N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot
Private oPrinter		:= ""
Private oFont1 			:=	TFont():New( "Verdana", 10, 10, , .F., , , , .T., .F. )//Verbas
Private oFont2 			:=	TFont():New( "Verdana", 10, 10 , , .F., , , , .T., .F. )//Cabe�alho e Rodap�
Private oFont2N 		:= 	TFont():New( "Verdana", 10, 10, , .T., , , , .T., .F. )//Cabe�alho e Rodap� Negrito
Private oFont3 			:=	TFont():New( "Verdana", 12, 12, , .T., , , , .T., .F. )//Titulo Interno
Private oFont4 			:=	TFont():New( "Verdana", 14, 14, , .T., , , , .T., .F. )//Titulo Maior
Private Semana
Private cSemana
Private lPDFEmail		:= .T. //PDF � por Email quando for .F. Visualizar o PDF no remote
Private lIsDriver		:= Iif(cDriver == "EPSON",.T.,.F.)
Private lContAnt        := .F.  //Controle para verificar se o recibo anterior � continua��o

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER030"            //Nome Default do relatorio em Disco

//��������������������������������������������������������������Ŀ
//� Verifica se o programa foi chamado do terminal - TCF         �
//����������������������������������������������������������������
lTerminal := If( lTerminal == Nil, .F., lTerminal )

IF !( lTerminal )
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
Else           
	If Select("SRC")>0
		SRC->(DbCloseArea())
	EndIf
EndIF

//��������������������������������������������������������������Ŀ
//� Define a Ordem do Relatorio                                  �
//����������������������������������������������������������������
nOrdem := IF( !( lTerminal ), aReturn[8] , 1 )

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
If !IsBlind()
	Pergunte(cPerg, .F.)
EndIf

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//��������������������������������������������������������������Ŀ
//� Verificar se o sistema esta trabalhando com ou sem roteiro   �
//����������������������������������������������������������������
DbSelectArea( "RCH" )
DbSetOrder( 4 )
DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. )
If Eof()
	DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. )
Else
	cRotBlank := cRoteiro
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRotBlank	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
			
dDataRef   := CTOD("01/" + cMes + "/" + cAno)

nTipRel    := IF( !( lTerminal ), mv_par05 , 3				)	//Tipo de Recibo (Pre-Impress�o/Zebrado/EMail/PDF)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA	)	//Chapa De
ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA	)	//Chapa Ate
Mensag1    := mv_par16										 	//Mensagem 1
Mensag2    := mv_par17											//Mensagem 2
Mensag3    := mv_par18											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := IF( !( lTerminal ),If(mv_par21 == 1,"S","N"),"S")	//Imprimir Bases
cDeptoDe   := IF( !( lTerminal ),mv_par22,SRA->RA_DEPTO 	)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par23,SRA->RA_DEPTO 	)	//Depto. Ate
lQuebraFun := IIF( !( lTerminal ) .And. !Empty(MV_PAR24),(MV_PAR24 == 1),.F.) //Quebra por Funcion�rio?

If nTipRel == 1 .AND. cPaisLoc = "BOL"
	nTipRel := 2
Endif

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf

If nTipRel == 4 //Apenas visualizar o PDF
	lPDFEmail	:= .F.
EndIf

limpArqPdf() //Limpar Recibos que por ventura ainda estejam no servidor

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
If aReturn[5] == 3	//Impressao Direta na Porta
	lLpt1 := .T.
EndIf

IF !( lTerminal )
	//��������������������������������������������������������������Ŀ
	//� Inicializa Impressao                                         �
	//����������������������������������������������������������������
	If ! fInicia(cString,nTipRel)
		Return
	Endif 
EndIF

DbSelectArea( "SRA" )
IF nTipRel==3
	IF lTerminal
		cHtml := R030Imp(.F.,wnRel,cString,cMesAnoRef,lTerminal)
		If Select("SRC")>0
			SRC->(DbCloseArea())
		EndIf
	Else
		ProcGPE({|lEnd| R030IMP(@lEnd,wnRel,cString,cMesAnoRef,.f.)},,,.T.)  // Chamada do Processamento
	EndIF
Else
	RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio
EndIF

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R030IMP  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento Para emissao do Recibo                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local aCodBenef   	:= {}
Local aTInss	  		:= {}
Local cAcessaSR1  	:= &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   	:= &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local cHtml		  	:= ""
Local nHoras      	:= 0
Local nMes, nAno
Local nX
Local nReg		  		:= 0
Local cPerAnt	  		:= ""                    
Local cKey		  		:= ""
Local cInicio	  		:= ""
Local nBInssPA	  	:= 0 //Teto da base de INSS dos pro-labores/autonomos
Local dDataLibRh
Local cPerCorrente	:= ""
Local cSemCorrente	:= ""
Local cMesCorrente 	:= ""
Local cAnoCorrente 	:= ""

Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF 
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec
Local nPosMsg1		:= 0
Local nPosMsg2		:= 0
Local nPosMsg3		:= 0
Local cFilter	   	:= aReturn[7]
Local cPath			:= supergetmv("MV_RELT",,"\spool\")
		
Private tamanho   	:= "M"
Private limite		:= 132
Private cDtPago   	:= ""
Private cTipoRot 		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc 	:= {}
Private aTitle		:= {}
Private aLog		:= {}
Private cRotBlank
Private nHraExtra 	:= 0
Private nPagoDom		:= 0

Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "@E 999,999.99"

Private nSalario		:= 0

//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

If nDec = 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)

//��������������������������������������������������������������Ŀ
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//����������������������������������������������������������������
If lTerminal

	dbSelectArea("RCH")
	dbSetOrder(6)
	IF cPaisLoc == "ARG" 
  			cKey := "xFilial('RCH') + cProcesso" 
 			cInicio := "RCH_FILIAL + RCH_PROCES" 		
	Else
		cKey    := "xFilial('RCH') + cProcesso" + IIf(cRoteiro == "EXT", "", " + cRoteiro")
		cInicio := "RCH_FILIAL + RCH_PROCES" + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
	Endif
	
	DbSeek( &(cKey))
	If Eof()
		cRotBlank 	:= Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
		cKey := "xFilial('RCH') + cProcesso " + IIf(cRoteiro == "EXT", "", " + cRotBlank")
		cInicio := "RCH_FILIAL + RCH_PROCES " + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
		DbSeek( &(cKey))
	EndIf
	If !Eof()
		While RCH->( !Eof() .and. &(cInicio) == &(cKey))
			If Empty(RCH->RCH_DTFECH)
				cPerCorrente := RCH->RCH_PER
				cSemCorrente := RCH->RCH_NUMPAG
				cMesCorrente := RCH->RCH_MES
				cAnoCorrente := RCH->RCH_ANO
				Exit
			EndIf		
			RCH->( dbSkip() )
		EndDo
	EndIf

	If	(cPerCorrente == cPeriodo .AND. cSemCorrente == Semana)  .OR. ;
		( MesAno(dDataRef) >= (cAnoCorrente + cMesCorrente) )

		If  cTipoRot == "2" //Adiantamento
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDADT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			EndIf
		ElseIf cTipoRot == "1" .and. !empty(nTCFDFOL) //Folha
			dDataLibRh := fMontaDtTcf(cMesCorrente + cAnoCorrente,nTCFDFOL)
			If Date() < dDataLibRH 
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "5" //1a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
  			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD131,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "6" //2a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD132,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cRoteiro == "EXT"  // Valores Extras
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDEXT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		EndIf
	Endif
Endif

If cPaisLoc == "ARG"
	nMes := Month(dDataRef) - 1
	nAno := Year(dDataRef)
	If nMes == 0
		nMes := 12
		nAno := nAno - 1
	Endif
	If nMes < 0
		nMes := 12 - ( nMes * -1 )
		nAno := nAno - 1
	Endif
	
	dbSelectArea( "RCH")
	dbSetOrder(6)
	dbSeek(xFilial("RCH") + cProcesso + cRoteiro + Transform(nAno,"9999") + Transform(nMes,"99"))
	If Eof()
		dbSeek(xFilial("RCH") + cProcesso + Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" )) +Transform(nAno,"9999") + Transform(nMes,"99"))
	EndIF
	If !Eof()
		cPerAnt := RCH->RCH_PER + RCH->RCH_NUMPAG
	EndIf	
Endif

//��������������������������������������������������������������Ŀ
//� Selecionando a Ordem de impressao escolhida no parametro.    �
//����������������������������������������������������������������
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"C.Custo"
		dbSetOrder(2)
	ElseIf nOrdem == 3		//"Nome"
		dbSetOrder(3)
	Elseif nOrdem == 4		//"Chapa"
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
	
	ElseIf nOrdem == 5		//"C.Custo + Nome"
		dbSetOrder(8)
	ElseIf nOrdem == 6		//"Depto"
		dbSetOrder(21)
	ElseIf nOrdem == 7		//"Depto. + Nome"
		dbSetOrder(22)
	Endif
	
	dbGoTop()
	
	If nTipRel == 2
		@ LI,00 PSAY AvalImp(Limite)
	Endif
EndIF

//��������������������������������������������������������������Ŀ
//� Selecionando o Primeiro Registro e montando Filtro.          �
//����������������������������������������������������������������
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !( lTerminal )
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem == 6
	dbSeek(cFilDe + cDeptoDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_MAT"
	cFim     := cFilAte + cDeptoAte + cMatAte
ElseIf nOrdem == 7
	dbSeek(cFilDe + cDeptoDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_NOME"
	cFim     := cFilAte + cDeptoAte + cNomAte
Endif

dbSelectArea("SRA")
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                  �
//����������������������������������������������������������������
#IFDEF TOP                  
	cAliasTMP := "QNRO"
	BeginSql alias cAliasTMP
		SELECT COUNT(*) as NROREG
		FROM %table:SRA% SRA
		WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte% 
			   AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
			   AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte% 
			   AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte% 
			   AND SRA.%notDel%
	EndSql

	nRegProc := (cAliasTMP)->(NROREG)
	( cAliasTMP )->( dbCloseArea() )	
	IF nTipRel # 3
		SetRegua(nRegProc)	// Total de elementos da regua
	Else
		IF !( lTerminal )
			GPProcRegua(nRegProc)// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ELSE
	IF nTipRel # 3
		SetRegua(RecCount())	// Total de elementos da regua
	Else
		IF !( lTerminal )
			GPProcRegua(RecCount())// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ENDIF 

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
Desc_Comp:= Desc_Est := Desc_Cid:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := Space(FwGetTamFilial)
Vez        := 0
OrdemZ     := 0

If nTipRel == 2 .and. !( lTerminal )
	If cPaisLoc=="PTG"
		oPrint:= TMSPrinter():New(Titulo)//Emissao de Recibos de Pagamentos
		oPrint:SetPortrait()            //Define que a impressao deve ser RETRATO//
	Endif
Endif

While SRA->( !Eof() .And. &cInicio <= cFim )

	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IF !( lTerminal )

		IF nTipRel # 3
			IncRegua()  // Anda a regua
		ElseIF !( lTerminal )
			GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		EndIF

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif

		//��������������������������������������������������������������Ŀ
		//� Consiste Filtro da setprint						             �
		//����������������������������������������������������������������
		If ! Empty(cFilter) .And. ! SRA->(&(cFilter))
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->RA_CHAPa > ChapaAte) .Or. ;
			(FtAcento( SRA->RA_NOME )   < cNomDe) .Or. (FtAcento( SRA->RA_NOME ) > cNomAte)   .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)

			SRA->(dbSkip(1))
			Loop
		EndIf

	EndIF

	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//��������������������������������Ŀ
	//� Verifica Data Demissao         �
	//����������������������������������
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//-Busca o Salario Base do Funcionario
	nSalario := fBuscaSal(dDataRef,,,.F.)
	If nSalario == 0
		nSalario := SRA->RA_SALARIO
	EndIf
	
	IF !( lTerminal )
		
		//��������������������������������������������������������������Ŀ
		//� Consiste situacao e categoria dos funcionarios			     |
		//����������������������������������������������������������������
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			SRA->(dbSkip())
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			SRA->(dbSkip())
			Loop
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Consiste controle de acessos e filiais validas				 |
		//����������������������������������������������������������������
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Return Nil
		Endif      
		Desc_Fil := If( lLpt1, fTAcento(aInfo[3]), aInfo[3] )
		Desc_End := If( lLpt1, fTAcento(aInfo[4]), aInfo[4] )	// Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+If( lLpt1, fTAcento(aInfo[6]), aInfo[6] ),"X5DESCRI()"),1,20)
		Desc_Comp:= If( lLpt1, fTAcento(aInfo[14]), aInfo[14] )	// Complemento Cobranca
		Desc_Cid := If( lLpt1, fTAcento(aInfo[5]), aInfo[5] )
		End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
					aInfo[06] + " " + aInfo[07]//endere�o + bairro + cidade + estado + cep
		Desc_EndC:= If( lLpt1, fTAcento( End_Compl ), End_Compl )
		// MENSAGENS
		If !Empty(MENSAG1)        
		
			nPosMsg1		:= fPosTab("S036",Alltrim(MENSAG1), "==", 4)
			If nPosMsg1 > 0 
				DESC_MSG1	:= fTabela("S036",nPosMsg1,5)
			EndIf
		Endif   
		
		nPosMsg2		:= fPosTab("S036",Alltrim(MENSAG2), "==", 4)
		If nPosMsg2 > 0 
			DESC_MSG2	:= fTabela("S036",nPosMsg2,5)
		EndIf  
		
		nPosMsg3		:= fPosTab("S036",Alltrim(MENSAG3), "==", 4)
		If nPosMsg3 > 0 
			DESC_MSG3	:= fTabela("S036",nPosMsg3,5)
		EndIf
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	            
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	If !cPaisLoc $ "CHI|PAR|DOM|" .AND. !lFase4
		Car_inss(@aTInss,MesAno(dDataRef))
	EndIf
	
	If Len(aTinss) > 0
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que dever�o ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados

	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If cPaisLoc $ "ANG*PER" .AND. cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34"
					dbSkip()
		   			Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				If cPaisLoc == "PAR" .and. Eval(cNroHoras) = 30
					LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
				Else
					nHoras := aVerbasFunc[nReg,6]	//-Eval(cNroHoras)
				Endif
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
				
				If cPaisLoc == "BOL"       //soma Horas Extras para localizacao Bolivia
					If PosSrv(aVerbasFunc[nReg,3], SRA->RA_FILIAL, "RV_HE") == "S"
						nHraExtra:= nHraExtra + aVerbasFunc[nReg,6]
					Endif                                          
					//Soma a verba de Horas Trabalhadas no Domingo id 0779
					
					If (aVerbasFunc[nReg,3] == aCodFol[779,1])  
						nPagoDom:= nPagoDom + aVerbasFunc[nReg,6]
					Endif                                        
				Endif 
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				Endif
			Endif
		
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg

	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR  
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif             
	     
	If cPaisLoc == "ARG"
		dbSelectArea("SRD")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cProcesso + cRoteiro + cPerAnt)
			cDtPago := dtoc(SRD->RD_DATPGT)
		Endif
	Endif
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	             
	If Vez == 0 .And. cTipoRot == "1"	//--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	If nTipRel == 1 .and. !( lTerminal )
		fImpressao()   // Impressao do Recibo de Pagamento
		IF !( lTerminal )
			If nTipRel # 3  .And. (aReturn[5] == 3 .Or. aReturn[5] == 2)//--> S� faz teste de impress�o quando impress�o for direto na porta
				//��������������������������������������������������������������Ŀ
				//� Descarrega teste de impressao                                �
				//����������������������������������������������������������������
				fImpTeste(cString)
				If !lRetCanc
					Exit
				Endif
				TotDesc := TotVenc := 0
				If nTipRel == 2 
					Loop
				Endif
				
			ENDIF
		EndIF
	ElseIf nTipRel == 2 .and. !( lTerminal )
		For nX := 1 to If(cPaisLoc <> "ARG",1,2)
			If cPaisLoc=="PTG"
				fImpreGraf()
			Else	
				fImpreZebr()
			Endif
		Next nX
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)      
	ElseIf nTipRel == 3 .or. lTerminal
		//��������������������������������������������������������������Ŀ
		//� Ponto de entrada para alterar layout do recibo.				 |
		//����������������������������������������������������������������
		If ExistBlock("GP030HTM")
			cHtml := ExecBlock("GP030HTM",.F.,.F.)
		Else
			cHtml := fSendDPgto(lTerminal)   //Monta o corpo do e-mail e envia-o
		Endif
	ElseIf (nTipRel == 4 .OR. nTipRel == 5) .and. !( lTerminal ) //4 Visualizar o PDF 5 Enviar PDF por email
		fImprPDF(lPDFEmail,cPath)
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)    
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )	
	if(lQuebraFun) .AND. aReturn[5] <> 3  /*Se desejar imprimir um comprovante por folha...ignorada quando impresso direto na porta (formulario continuo)*/	
		__Eject()	
	   	LI := 4
		SetPrc(LI,0)
	endIf
	
	TOTDESC := TOTVENC := 0
EndDo

If nTipRel == 4 .and. !( lTerminal )
	IF ( Type( "oPrinter" ) == "O" )
		oPrinter:Preview()
		oPrinter:EndPage()                                                          
		FreeObj(oPrinter)
		oPrinter := Nil
	Else
		MSGALERT( STR0203, STR0202 ) //"N�o foram localizados demonstrativos de pagamentos dispon�veis para esta consulta."  -  "Aten��o!"	
	EndIf
ElseIf nTipRel == 5 .and. !( lTerminal )	
	fEnvPDFEmail(cPath)
EndIf

If nTipRel == 2 .and. !( lTerminal ) 
	If cPaisLoc=="PTG"
		oPrint:Preview()  
	Endif
Endif               

IF !( lTerminal ).And.cPaisLoc<>"PTG" 
	
	//��������������������������������������������������������������Ŀ
	//� Termino do relatorio                                         �
	//����������������������������������������������������������������
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRD")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")
	
	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif
	
	Set Device To Screen
	
	If lEnvioOK
		APMSGINFO(STR0042)
	ElseIf nTipRel== 3
		APMSGINFO(STR0043)
	EndIf

	//Gera LOG dos funcionarios que nao foram enviados
	If !Empty(aLog) .And. MsgYesNo(OemToAnsi(STR0208),OemToAnsi(STR0207)) //"Deseja imprimir o LOG das matr�culas que n�o foram enviadas?"#"Aten��o"
		fMakeLog(aLog,aTitle,,,"GPER030LOG",OemToAnsi(STR0209),"G","L",,.F.) //"LOG das matr�culas que n�o foram enviadas"
	EndIf

	SeTPgEject(.F.)
	nlin:= 0	
	If aReturn[5] = 1 .and. (nTipRel == 1 .OR.  nTipRel == 2)
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
	
EndIF

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpressao� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpressao()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpressao()

Local lLinhaRoda := .T.	// Variavel que informa se foram impressas todas as linhas do miolo do recibo.
Local nConta  := 0
Local nContr  := 0
Local nContrT :=0
Private nLinhas:=16              // Numero de Linhas do Miolo do Recibo
Private lContinua := .F.        //identificador se o proximo recibo � continua��o do anterior

Ordem_Rel := 1

If cPaisLoc == "ARG"
	fCabecArg() 
ElseIf cPaisLoc == "PER"
	fCabecPer()	
Else
	fCabec()
Endif

For nConta = 1 To Len(aLanca)
	fLanca(nConta)
	nContr ++
	nContrT ++
	If nContr = nLinhas .And. nContrT < Len(aLanca)
		nContr:=0
		Ordem_Rel ++
		fContinua()
		If cPaisLoc == "ARG"
			fCabecArg()
		Elseif cPaisLoc == "PER"
			fCabecPer()		
		Else
			fCabec()
		Endif
	Endif
Next nConta
Li:=Li -1
Li+=IF( lLinhaRoda := (nLinhas-nContr) == 0,1,(nLinhas-nContr))
If cPaisLoc == "ARG"
	@ ++LI,01 PSAY TRANS(TOTVENC,cPict1)
	@ LI,44 PSAY TRANS(TOTDESC,cPict1)
	@ LI,88 PSAY TRANS((TOTVENC-TOTDESC),cPict1)
	Li +=2
	@ Li,01 PSAY MesExtenso(MONTH(dDataRef)) + " de "+ STR(YEAR(dDataRef),4)
	@ ++Li,01 PSAY EXTENSO(TOTVENC-TOTDESC,,,)+REPLICATE("*",130-LEN(EXTENSO(TOTVENC-TOTDESC,,,)))
	@ ++Li,01 PSAY StrZero(Day(dDataRef),2) + " de " + MesExtenso(MONTH(dDataRef)) + " de "+STR(YEAR(dDataRef),4)
	@ ++Li,01 PSAY TRANS((TOTVENC-TOTDESC),cPict1)
Else
	fRodape(lLinhaRoda)
Endif

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpreZebr� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpreZebr()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpreZebr()

Local nConta    := nContr := nContrT:=0

If li >= 60
	li := 0
Endif
If cPaisLoc == "ARG"
	fCabecZArg()
Elseif cPaisLoc == "BOL"
	fCabecZBol()
Elseif cPaisLoc == "PER"
	fCabecZPer()
Elseif cPaisLoc == "DOM"
	fCabecZDom()
Else
	fCabecZ()
Endif   
If cPaisLoc == "BOL" 
	fLancaZBol(nConta)
Else
	fLancaZ(nConta)
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpreGraf� Autor � SSERVICE				� Data � 05.05.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO GRAFICO                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpreGraf()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpreGraf()

Local nConta    := nContr := nContrT:=0

fCabecG()
fLancaG(nConta)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabec    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form Continuo                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabec()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabec()   		// Cabecalho do Recibo
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDescRot		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")
Local cNomeFunc     := ""       //-- Nome do Funcionario  
Local cFilFunc		:= ""
Local cLayoutGC 	:= ""
Local lCorpManage	:= fIsCorpManage( FWGrpCompany() )	// Verifica se o cliente possui Gest�o Corporativa no Grupo Logado
Local nStartFil		:= 0
Local nFilLength	:= 0

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
cNomeFunc := fTAcento(Left(SRA->RA_NOME,28)) 
cNomeFunc := fTrocaCar(cNomeFunc)

If lCorpManage
	cLayoutGC 	:= FWSM0Layout(cEmpAnt)
	nStartFil	:= At("F",cLayoutGC)
	nFilLength	:= Len(FWSM0Layout(cEmpAnt, 3))
	cFilFunc	:= AllTrim(Substr(SRA->RA_Filial,nStartFil,nFilLength))
Else
	cFilFunc := SRA->RA_Filial
EndIf

IF LI > 37   
	LI := 0
Endif

IF !lContinua .AND. lContAnt //adiciona linha quando n�o for continua��o por�m o recebo anterior � continua��o
	LI ++
Endif

lContAnt  := lContinua

@ PROW(),PCOL() PSAY ""
LI ++

If lIsDriver
	@ LI,01 PSAY &cNormal+DESC_Fil
Else
	@ LI,01 PSAY DESC_Fil
EndIf

LI ++
@ LI,01 PSAY DESC_END
LI ++
@ LI,01 PSAY DESC_CGC

If !Empty(Semana) .And. Semana # '99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
	@ Li,37 pSay STR0013 + Semana + ' (' + cSem_De + STR0014 + ;	//'Semana '###' a '
	cSem_Ate + ')'
Else
	@ LI,20 PSAY "- " + cDescRot + " - " + MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - " + Semana
EndIf

LI +=2
@ LI,01 PSAY SRA->RA_Mat
@ LI,08 PSAY cNomeFunc
@ LI,37 PSAY fTAcento(fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef))
@ LI,44 PSAY cFilFunc
If !Empty(SRA->RA_DEPTO)
	@ LI,47 PSAY SRA->RA_DEPTO
	@ LI,58 PSAY ALLTRIM(SRA->RA_CC)
Else
	@ LI,53 PSAY PADC(ALLTRIM(SRA->RA_CC),20)
EndIf
@ LI,73 PSAY ORDEM_REL PICTURE "99"
LI ++

cDet := STR0015 + cCodFunc						//-- Funcao
cDet += If( lLpt1, fTAcento(cDescFunc), cDescFunc ) + ' '
cDet += DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
cDet += STR0016 + SRA->RA_CHAPA					//'CHAPA: '
@ Li,01 pSay If( lLpt1, fTAcento(cDet), cDet )

Li += 3 //2
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecz   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form ZEBRADO                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecz()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecZ()   // Cabecalho do Recibo Zebrado
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDescCC		:= ""		//-- Descricao do Centro de Custo

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
If Li == 0
@ Li,00 PSAY Avalimp(Limite)
Endif
LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY "RECIBO DE PAGAMENTO - RPA"		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY STR0018 +  DESC_Fil		//"| Empresa   : "

If cPaisLoc == "BRA"
	@ LI,92+7 PSAY STR0099 + "   " + Desc_CGC	//"CNPJ  : "
Else
	@ LI,92+7 PSAY AllTrim(RetTitle("A1_CGC")) + ": " + Desc_CGC	//"CNPJ  : "	
EndIf
@ LI,131 PSAY "|"

LI ++
cDescCC := If( lLpt1, fTAcento(DescCc(SRA->RA_CC,SRA->RA_FILIAL)), DescCc(SRA->RA_CC,SRA->RA_FILIAL) )
@ LI,00 PSAY STR0020 + SRA->RA_CC + " - " + cDescCC		//"| C Custo   : "
If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	@ Li,92+7 PSay STR0021 + Semana + " (" + cSem_De + STR0022 + ;   //'Sem.'###' a '
	cSem_Ate + ")"
Else
	@ LI,92+7 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf
@ LI,131 PSAY "|"

LI ++
ORDEMZ ++
@ LI,00   PSAY "|" +  " Prebenda  :" + "  " + Alltrim(Transform(nSalario,cPict2)) //"| Salario    : "
//@ LI,24    PSAY STR0024 + If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME )	//"Nome  : "
@ LI,92+7  PSAY STR0025						//"Ordem : "
@ LI,100+7 PSAY StrZero(ORDEMZ,4) Picture "9999"
@ LI,131 PSAY "|"

LI ++
//@ LI,00   PSAY STR0026+cCodFunc+" - "+If( lLpt1, fTAcento(cDescFunc), cDescFunc ) //"| Funcao    : "
@ LI,00  PSAY "| Bispo / Pastor(a) : " + If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME )		//"| Matricula : "


If !Empty(SRA->RA_DEPTO)
	@ LI,46   PSAY STR0177 + ": " + SRA->RA_DEPTO + " - " + fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')	//-9caracteres+30caracteres
EndIf
@ LI,91+7 PSAY STR0019 + SRA->RA_FILIAL	//" Local : "
@ LI,131  PSAY "|"

CPF := SRA-> RA_CIC
CPF := TRANSFORM (CPF, "@R 999.999.999-99")
LI++
@ LI,00    PSAY "| CPF : " + If( lLpt1, fTAcento(CPF), CPF )	//"| CPF: "
@ LI,131   PSAY "|"

LI ++

@ LI,00   PSAY "|"
//@ LI,91+7 PSAY STR0214 + fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef)	//" CBO : "
@ LI,131  PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0027		//"| P R O V E N T O S "

if(cBaseAux == 'S')	
	@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
	@ LI,088 PSAY STR0029		//"  B A S E S"
else
	@ LI,064 PSAY STR0028		//"  D E S C O N T O S"
endIf

@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecG   � Autor � SSERVICE              � Data � 04.05.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Grafico                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecG()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecG()   // Cabecalho do Recibo Zebrado 
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cStartPath	:= GetSrvProfString("Startpath","")

oPrint:StartPage() 		
oPrint:Box(20,15,160,2400 )                
oPrint:SayBitmap(030,060,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath
oPrint:Say(030,1000,titulo,oArial10N)
oPrint:Say(080,0600,STR0142+DESC_Fil+" - "+STR0143+SRA->RA_FILIAL,oArial08N)		//Empresa : #Local :
oPrint:Say(120,0600,STR0117+ cProcesso + SPACE(27) + STR0118 + cRoteiro + SPACE(16) + STR0119 + cPeriodo + SPACE(17) + STR0120 + Semana,oArial08N)
cDataBase:=Substr(Dtos(Date()),7,2)+"/"+Substr(Dtos(Date()),5,2)+"/"+Substr(Dtos(Date()),1,4)
//Box do Cabecalho recibo de vencimento
oPrint:Box(0170,0015,0320,1000)        
//Box Mensagem
oPrint:Box(0330,0015,0600,1000)          
//Box Informacoes do Funcionario
oPrint:Box(0170,1010,0480,2400)
//Box da categoria 
oPrint:Box(0490,1010,0600,2400) 
oPrint:Line(0550,1010,0550,2400)         
oPrint:Line(0550,1700,0600,1700)
//Box Nib                       
oPrint:Box(0610,0015,0660,2400)
oPrint:Line(0610,0100,0660,0100)
//Box N  Empregado,categoria,dep irs,n benef. e n contrib.
oPrint:Box(0670,0015,0790,2400)         
oPrint:Line(0730,0015,0730,2400)         
oPrint:Line(0670,0200,0790,0200)
oPrint:Line(0670,1000,0790,1000)
oPrint:Line(0670,1460,0790,1460)
oPrint:Line(0670,1930,0790,1930)


oPrint:Say(0190,0030,Space(20)+STR0017,oArial08N) //"RECIBO DE PAGAMENTO    
oPrint:Line(0250,0015,0250,1000)
oPrint:Say(0270,0030,STR0145,oArial08N) //"PROCESSAMENTO 
oPrint:Line(0250,0500,0320,0500 )
oPrint:Say(0270,0510,cDaTaBase,oArial08  )  
oPrint:Line(0320,0015,0320,1000)     
//==============================================================================
oPrint:Say(0340,0030,STR0146,oArial08N)//MENSAGEM  
oPrint:Line(0380,0015,0380,1000)                
nMsg:=420
If !Empty(DESC_MSG1)
	oPrint:Say(nMsg,0030,DESC_MSG1		,oArial08 )  
	nMsg+=60
Endif
If !Empty(DESC_MSG2) 
	oPrint:Say(nMsg,0030,DESC_MSG2		,oArial08) 
	nMsg+=60
Endif
If !Empty(DESC_MSG3) 
	oPrint:Say(nMsg,0030,DESC_MSG3		,oArial08)  
Endif
//============================================================================== 
ORDEMZ ++
oPrint:Say(0190,1015,STR0147+SRA->RA_MAT+"  "+STR0024+" "+;
IIF(!EMPTY(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME),oArial08)								//Matricula e Nome
oPrint:Say(0190,1950,STR0025+StrZero(ORDEMZ,4),oArial08)										//Ordem 
oPrint:Say(0250,1015,Alltrim(SRA->RA_ENDEREC)+"-"+Alltrim(SRA->RA_COMPLEM),oArial08)			//Endereco e Complemento
oPrint:Say(0250,1950,STR0148+SRA->RA_CC,oArial08)												//Centro de Custo
oPrint:Say(0310,1015,Alltrim(SRA->RA_BAIRRO)+"-"+Alltrim(SRA->RA_CEP),oArial08)					//Bairro e Cep 
oPrint:Say(0310,1950,STR0149+DescCc(SRA->RA_CC,SRA->RA_FILIAL),oArial08)						//Descricao Centro de Custo
IF cPaisloc == "COL"
   oPrint:Say(0370,1015,FDESC("VAM",SRA->RA_MUNICIP,"VAM_DESCID")+"-"+SRA->RA_ESTADO,oArial08)	//Estado e Municipio
ELSE
   oPrint:Say(0370,1015,Alltrim(RA_MUNICIP)+"-"+RA_ESTADO,oArial10)								//Estado e Municipio ////oArial08 - d
ENDIF
oPrint:Say(0370,1950,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4),oArial08)			//Mes e Ano de de Referencia  
/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
oPrint:Say(0430,1015,STR0150+cCodFunc+" - "+cDescFunc,oArial08)									//Funcao e a Descricao      
//==============================================================================                                

cCodSeg:=""
DbSelectArea("RCC")
RCC->(DbSetOrder(RetOrder("RCC","RCC_FILIAL+RCC_CODIGO")))
RCC->(DbGoTop())
If RCC->(DbSeek(xFilial("RCC")+"S021"))               
	Do While RCC->(!Eof()).And. RCC->RCC_CODIGO=="S021"	
		If SUBSTR(RCC->RCC_CONTEU,1,FwGetTamFilial)==SRA->RA_FILIAL
			cCodSeg:=SUBSTR(RCC->RCC_CONTEU,FwGetTamFilial+1,2)
			Exit
		Endif	
		RCC->(DbSkip())
	End	    
Endif       

//Cadastro da Seguradora  
DbSelectArea("RGI")
RGI->(DbSetOrder(RetOrder("RGI","RGI_FILIAL+RGI_CODIGO")))
RGI->(DbGoTop())
cDescSeg:="-"
cNumApol:="-"
If RGI->(DbSeek(SRA->RA_FILIAL+cCodSeg))
	cDescSeg:=RGI->RGI_DESCRI
	cNumApol:=RGI->RGI_NRAPOL
Endif


oPrint:Say(0500,1015,STR0151,oArial08N)//"SEGURO DE ACIDENTES DE TRABALHO" 
oPrint:Say(0560,1015,cDescSeg,oArial08)  
oPrint:Say(0560,1710,STR0152+cNumApol,oArial08)//APOLICE 
//==============================================================================
oPrint:Say(0620,0030,STR0153,oArial08N)//NIB  
//==============================================================================

oPrint:Say(0680,0030,STR0154,oArial08N)//N.EMPR  
oPrint:Say(0680,0210,STR0155,oArial08N)//CATEGORIA   
oPrint:Say(0680,1010,STR0156,oArial08N)//DEP. IRS   
oPrint:Say(0680,1470,STR0157,oArial08N)//N.BENEFICIARIO  
oPrint:Say(0680,1940,STR0158,oArial08N)//N.CONTRIBUINTE  

If cPaisLoc == "ANG" .or. cPaisLoc == "EQU" .or. cPaisLoc == "PTG"
	cCodCat:=Posicione("RGG",1,xFilial("RGG")+SRA->RA_CODCAT,"RGG_DESCRI") 
Else
	cCodCat:= ' '
EndIf

oPrint:Say(0740,0030,SRA->RA_CHAPA	,oArial08)  
oPrint:Say(0740,0210,cCodCat		,oArial08)  
oPrint:Say(0740,1010,SRA->RA_DEPIR	,oArial08)  
oPrint:Say(0740,1470,""				,oArial08)             
oPrint:Say(0740,1940,SRA->RA_CIC 	,oArial08)  

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaG() � Autor � SSERVICE              � Data � 04.05.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Detalhe do Grafico                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � flancaG()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaG()   
Local nCont     := 0
//Local nCont1    := 0
Local nValidos  := 0
//Local nTam		:= 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

//Box do Detalhe do Recibo de vencimento
oPrint:Box(0800,0015,2100,2400)        
oPrint:Line(0860,0015,0860,2400)          
oPrint:Line(0800,0800,2100,0800)          
oPrint:Line(0800,1600,2100,1600)          

oPrint:Say(0810,0040,STR0159,oArial08N)//P R O V E N T O S  
oPrint:Say(0810,0810,STR0028,oArial08N)//D E S C O N T O S
oPrint:Say(0810,1610,STR0029,oArial08N)//B A S E S

nLinDet:=870
For nCont := 1 To nTermina
	IF nCont <= Len(aProve)
		oPrint:Say(nLinDet,0040,aProve[nCont,1],oArial08)
		oPrint:Say(nLinDet,0600,TRANSFORM(aProve[nCont,2],'999.99')+TRANSFORM(aProve[nCont,3],cPict3),oArial08)
	ENDIF
	IF nCont <= Len(aDesco)
		oPrint:Say(nLinDet,0810,aDesco[nCont,1],oArial08)
		oPrint:Say(nLinDet,1400,TRANSFORM(aDesco[nCont,2],'999.99')+TRANSFORM(aDesco[nCont,3],cPict3),oArial08)
	ENDIF
	IF nCont <= Len(aBases)
		oPrint:Say(nLinDet,1610,aBases[nCont,1],oArial08)
		oPrint:Say(nLinDet,2200,TRANSFORM(aBases[nCont,2],'999.99')+TRANSFORM(aBases[nCont,3],cPict3),oArial08)
	Endif
	//====================================================
	//---- Soma 1 nos nValidos e Linha
	//====================================================
	nValidos ++
	nLinDet+=40   
	
	If nLinDet>=2060
		nLinDet+=40
		oPrint:Say(nLinDet,2200,STR0030,oArial08)		
		oPrint:EndPage() 		
		fCabecG()
		nValidos := 0
	Endif         
	
Next nCont
oPrint:Box(2110,0015,2400,2400)        
oPrint:Say(2120,0040,STR0160,oArial10N)//TOTAL BRUTO
oPrint:Say(2120,0300,SPACE(10)+TRANS(TOTVENC,cPict1),oArial08N)	
oPrint:Say(2120,0810,STR0161,oArial10N)//TOTAL DESCONTOS
oPrint:Say(2120,1090,SPACE(10)+TRANS(TOTDESC,cPict1),oArial08N)	
oPrint:Say(2120,1610,STR0162,oArial10N)//LIQUIDO A RECEBER
oPrint:Say(2120,1890,SPACE(10)+TRANS((TOTVENC-TOTDESC),cPict1),oArial08N)
//oPrint:Say(2180,0040,STR0163,oArial10N)//CREDITO
//oPrint:Say(2180,0200,SRA->RA_BCDEPSA+"-"+SUBSTR(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,44),oArial08N)
//oPrint:Say(2180,0810,STR0164,oArial10N)//CONTA
oPrint:Say(2180,1090,SRA->RA_CTDEPSA,oArial08N)	
oPrint:Say(2260,0040,"Recebi da institui��o acima identificada, pelo exercicio de ministro religioso a importancia de: " + TRANS((TOTVENC-TOTDESC),cPict1),oArial10N)
oPrint:Say(2340,0040,STR0166+ Replicate("_",60),oArial10N)//Assinatura
oPrint:EndPage() 		
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecArg �Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do Cabecalho - Argentina                          ���
���          �Pre Impresso                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecArg()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= ""		//-- Codigo do Cargo do funcionario

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

@ ++LI,01 PSAY DESC_Fil
@ ++LI,01 PSAY Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+" "+Desc_Cid
@ ++LI,01 PSAY DESC_CGC
@ ++LI,01 PSAY cDtPago

@ LI,40 PSAY Alltrim(SRA->RA_BCDEPSA) + "-" + DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL)
Li +=2
@ Li,01 PSAY If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME )
@ Li,45 PSAY SRA->RA_CIC
@ ++Li,01 PSAY SRA->RA_ADMISSA
@ Li,12 PSAY If( lLpt1, fTAcento(Substr(cDescFunc,1,15)), Substr(cDescFunc,1,15) )
cCargo := If( lLpt1, fTAcento(fGetCargo(SRA->RA_MAT)), fGetCargo(SRA->RA_MAT) )
@ Li,30 PSAY Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,10)
Li += 2

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecZArg�Autor  �Microsiga           � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Cabecalho - Argentina                         ���
���          � Zebrado                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/      
Static Function fCabecZArg()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= ""		//-- Codigo do Cargo do Funcionario

/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )


@ ++LI,00 PSAY "*"+REPLICATE("=",130)+"*"

@ ++LI,00  PSAY  "|"
@ LI,46  PSAY STR0090		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"

@ ++LI,00 PSAY "| "+STR0119 + cPeriodo + " " + STR0120 + Semana // "Periodo" "No.Pago:"
@ LI,131 PSAY "|"

@ ++LI,00  PSAY STR0087 + DESC_Fil		//"| Empregador   : "
@ LI,131 PSAY "|"

@ ++LI,00  PSAY STR0088 + Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+"-"+Desc_Est	//" Domicilio : "
@ LI,131 PSAY "|"

@ ++Li,00 PSAY STR0089 + DESC_CGC
@ LI,131 PSAY "|"
@ ++LI,00 PSAY STR0071 + cDtPago
@ LI,35 PSAY STR0072
@ LI,70 PSAY STR0073 + Alltrim(SRA->RA_BCDEPSA) + "-" + DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++Li,00 PSAY STR0074 + If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME )
@ Li,45 PSAY STR0075 + SRA->RA_CIC
@ LI,130 PSAY "|"

@ ++Li,00 PSAY STR0076 + DTOC(SRA->RA_ADMISSA)
@ Li,30  PSAY STR0077 + If( lLpt1, fTAcento(Substr(cDescFunc ,1,15)), Substr(cDescFunc ,1,15) )
cCargo := If( lLpt1, fTAcento(fGetCargo(SRA->RA_MAT)), fGetCargo(SRA->RA_MAT) )
@ Li,80 PSAY STR0078 + Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,6)
@ LI,131 PSAY "|"
LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0091		//"| H A B E R E S "
@ LI,046 PSAY STR0092		//"  D E D U C C I O N E S"
@ LI,090 PSAY STR0029		//"  B A S E S
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecZBol�Autor  �Erika               � Data �  19/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Cabecalho - Bolivia                           ���
���          � Zebrado                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/      
Static Function fCabecZBol()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDepto        := ""       
Local nTc			:= 0		//-- T. C. 
Local dData         := "00/00/00"

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc)   
 
//calcula o ultimo dia do mes do Periodo selecionado para buscar o campo nTc
dData:=  F_UltDia(dDataRef)     
dData:= DaySum( dDataRef , dData-Day(dDataRef) )
nTc := fTabela( "S009", 1, 5, dData)
 
//carrega departamento                                            
cDepto:= fDesc("CTT", SRA->RA_CC, "CTT->CTT_DESC01", 30)

@ ++LI,00 PSAY "*"+REPLICATE("=",130)+"*"
                                                    
LI++
@ LI,00  PSAY "|"
@ LI,02  PSAY Alltrim(Desc_Fil)
@ LI,113 PSAY STR0130 + DTOC(date())
@ LI,131 PSAY "|"

LI++            
@ LI,00  PSAY "|" 
@ LI,115 PSAY STR0131 + time()
@ LI,131 PSAY "|"

@ ++LI,00  PSAY  "|"
@ LI,58  PSAY "BOLETA DE PAGO"
@ LI,131 PSAY "|"

@ ++LI,00  PSAY  "|"  
@ LI,02  PSAY Alltrim(Desc_Cid) + "- BOLIVIA"
@ LI,57  PSAY STR0134		//"PLANILLA MENSUAL"
@ LI,115 PSAY MesExtenso(Month(dDataRef)) + "/" + left(DTOS(dDataRef),4)
@ LI,131 PSAY "|"

@ ++LI,00  PSAY  "|" 
@ LI,100 PSAY STR0141 + Transform(nTc, "99.99999") 		//T.C.: 
@ LI,131 PSAY "|"

@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"

@ ++LI,00 PSAY "| " + STR0105 + SRA->RA_NOME
@ LI,61 PSAY STR0127 + SRA->RA_CIC 
@ LI,103 PSAY STR0111 + DTOC(SRA->RA_ADMISSA)
@ LI,131 PSAY "|"
                  
@ ++LI,00 PSAY "| " + STR0123 + cDescFunc
@ LI,61  PSAY STR0138 + SRA->RA_MAT

If cPaisLoc == "BOL"
	@ LI,105 PSAY STR0128 + SRA->RA_SEGUROS 
EndIf

@ LI,131 PSAY "|"
 
@ ++LI,00 PSAY "| " + STR0132 + cDepto 
@ LI,61 PSAY STR0140 + cValtoChar(nHraExtra)
@ LI,105 PSAY STR0139 + "30.00"
@ LI,131 PSAY "|" 

@ ++LI,00 PSAY "| " + STR0167 + cValtoChar(nPagoDom)
@ LI,131 PSAY "|"
LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00 PSAY "|"
@ LI,027 PSAY STR0129		//" I N G R E S O S "
@ LI,090 PSAY STR0125		//"  E G R E S O S"
@ LI,131 PSAY "|"

LI++
nPagoDom	:= 0
nHraExtra	:= 0
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLanca    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Form. Continuo          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLanca()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLanca(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],cPict2)
Local nCol := If(aLanca[nConta,1]="P",41,If(aLanca[nConta,1]="D",56,27))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,05 PSAY aLanca[nConta,3]
If aLanca[nConta,1] # "B"        // So Imprime se nao for base
	@ LI,36 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif
@ LI,nCol PSAY cString
Li ++

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaZ   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Zebrado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancaZ()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaZ(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0
Local nTam		:= 0
Local aPos      := {}
Local nSpace    := 0
Local nReplicar := 0
Local nGera     := 0
Local cMsgAniv  := ""
Local nLenPic   := 0
Local lImprBases	:= (cBaseAux == "S")
Local lImpMsg		:= (!Empty(DESC_MSG1) .Or. !Empty(DESC_MSG2) .Or. !Empty(DESC_MSG3))

If ( Ascan(aProve , {|aProve| aProve[3] >= 1000000} ) > 0 ) 
  cPict3 := "@E 999,999,999.99" // Variavel private criada na funcao R030Imp
  if(lImprBases)  	
  	aPos := {1,43,45,87,89}
  else
  	aPos := {1,63,65,87,89}
  endIf 
  nSpace := 1
  nReplicar := 87
  nLenPic := 3
Else  
  cPict3 := "@E 999,999.99"
  if(lImprBases)
  	aPos := {2,44,46,88,90}    
  else
  	aPos := {2,64,66,88,90}
  endIf    
  nReplicar := 86
EndIf	

aEval(aProve,{|x|x[1] := PadR(x[1],(Len(x[1]) - nLenPic)-1) + Space(1)})
aEval(aDesco,{|x|x[1] := PadR(x[1],(Len(x[1]) - nLenPic)-1) + Space(1)})
aEval(aBases,{|x|x[1] := PadR(x[1],(Len(x[1]) - nLenPic)-1) + Space(1)})

nTermina := IIF(lImprBases,Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases)),Max(LEN(aProve),LEN(aDesco)))

For nCont := 1 To nTermina
 
	@ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)	  		
		@ LI,aPos[1] PSAY aProve[nCont,1] + TRANSFORM(aProve[nCont,2],'999.99') + SPACE(nSpace)+ TRANSFORM(aProve[nCont,3] , cPict3 )                                 
	ENDIF
	@ LI,aPos[2] PSAY "|"

	IF nCont <= LEN(aDesco)
		@ LI,aPos[3] PSAY aDesco[nCont,1] + TRANSFORM(aDesco[nCont,2],'999.99') + SPACE(nSpace)+ TRANSFORM(aDesco[nCont,3] , cPict3 )
	ENDIF

	if(lImprBases)
		@ LI,aPos[4] PSAY "|"
		IF nCont <= LEN(aBases)
			@ LI,aPos[5] PSAY aBases[nCont,1] + TRANSFORM(aBases[nCont,2],'999.99') + SPACE(nSpace)+ TRANSFORM(aBases[nCont,3] , cPict3 )
		ENDIF		
	endIf	

	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++

	// somente imprime CONTINUA e quebra o recibo em dois se houver mais verbas a serem impressas
	If nValidos = If(cPaisLoc <> "ARG",12,10) .and. nTermina > nValidos
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY STR0030			// "CONTINUA !!!"
		//		@ LI,76 PSAY "|"+&cCompac
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		If li >= 60
			li := 0
		Endif
		If cPaisLoc == "ARG"
			fCabecZArg()
   		Elseif cPaisLoc == "BOL"
 			fCabecZBol()
		Elseif cPaisLoc == "PER"
			fCabecZPer()
		Elseif cPaisLoc == "DOM"
			fCabecZDom()
		Else
			fCabecZ()
		Endif
		nValidos := 0

		// quando ha quebra na impressao do recibo para um mesmo funcionario, nao obedecia a qtde
		// de recibos por pagina, estourando a impressao em tela com 3 recibos em uma mesma pagina
		nGera++		
	ENDIF
Next nCont

For nCont1 := nValidos+1 To If(cPaisLoc <> "ARG",12,10)
	@ Li,00  PSAY "|"
	@ Li,aPos[2]  PSAY "|"
	if(lImprBases)		
		@ Li,aPos[4] PSAY "|"
	endIf
	@ Li,131 PSAY "|"
	Li++
Next nCont1

If cPaisLoc <> "ARG"
	@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
	LI++	
	if(lImprBases)
		@ LI,00 PSAY "|"
		@ LI,005 PSAY If( lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 )	
	endIf
	
	
	if(lImprBases)			
		@ LI,aPos[2] PSAY STR0031+SPACE(10)+TRANSFORM( TOTVENC , cPict3 )	//"| TOTAL BRUTO     "
		@ LI,aPos[4] PSAY "|"+STR0032+SPACE(07)+TRANSFORM(TOTDESC , cPict3)	//" TOTAL DESCONTOS     "
		@ LI,131 PSAY "|"
	else
		@ LI,aPos[1]- 2 	PSAY STR0031 + SPACE(10)+ TRANSFORM( TOTVENC , cPict3 )//"| TOTAL BRUTO     "
		@ LI,aPos[2]	PSAY "|"+STR0032+SPACE(07)+ TRANSFORM(TOTDESC , cPict3)	//" TOTAL DESCONTOS     "
		@ LI,131 PSAY "|"
	endIf	
	LI ++
	@ LI,000 PSAY "|"
	if(lImprBases)
		@ LI,005 PSAY If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 )
		@ LI,aPos[2] PSAY "|"+REPLICATE("-" ,  nReplicar)+"|"
	else
		@ LI,aPos[1]-1 PSAY REPLICATE("-" ,  130)+"|"
	endIf
	
	LI ++
	if(lImprBases)
		@ LI,000 PSAY "|"      
		@ LI,005 PSAY If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG3), DESC_MSG3 )
//		@ LI,aPos[2] PSAY STR0033+SRA->RA_BCDEPSA+"-"+ Substr(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,25)	//"| CREDITO:"
		@ LI,aPos[4] PSAY STR0034 + SPACE(05)+TRANSFORM((TOTVENC-TOTDESC) , cPict3 )			//"| LIQUIDO A RECEBER     "
		@ LI,131 PSAY "|"
	else
//		@ LI,aPos[1]- 2 PSAY STR0033+SRA->RA_BCDEPSA+"-"+ Substr(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,25)	//"| CREDITO:"
		@ LI,aPos[2] PSAY STR0034 + SPACE(05) + TRANSFORM((TOTVENC-TOTDESC) , cPict3 )			//"| LIQUIDO A RECEBER     "
		@ LI,131 PSAY "|"	
	endIf
	
	LI ++
	@ LI,000 PSAY "|"
	cMsgAniv := Space(38)	
	IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
		cMsgAniv := STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
	ENDIF
	@ LI,005 PSAY cMsgAniv
	
	if(lImprBases)		
		@ LI,aPos[2] PSAY "|"
		@ LI,088 PSAY "|"
	else
		@ LI,aPos[2] PSAY "|"
	endIf

	@ LI,131 PSAY "|"

	LI ++
	@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	LI ++
/*	if(lImprBases)
		@ LI,000 PSAY "|"
		If cPaisLoc $ "PER"
			@ LI,044 PSAY STR0035 + SRA->RA_CTDEPSA		//"| CONTA:"
		Else
			@ LI,034 PSAY STR0035 + SRA->RA_CTDEPSA		//"| CONTA:"
		Endif	
		@ LI,aPos[4] PSAY "|"
	else
		@ LI,000 PSAY STR0035 + SRA->RA_CTDEPSA		//"| CONTA:"
		@ LI,aPos[2] PSAY "|"
	endIf
*/	@ LI,131 PSAY "|"
	
	
	/* CRIA LINHA E IMPRIME MENSAGENS QUANDO IMPRIME BASES = N�O */	
	if(lImpMsg .AND. !lImprBases)
		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,2 PSAY If(lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 )
		if!(Empty(DESC_MSG2))
			@ LI,44 PSAY If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 )
		endIf
		if!(Empty(DESC_MSG3))
			@ LI,87 PSAY If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG2), DESC_MSG3 )
		endIf
		@ LI,131 PSAY "|"
	endIf
		LI ++
		@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	IF cPaisloc == "DOM"
		LI ++
		@ LI,00  PSAY STR0205 + Replicate("_",40)		//"| Recibi el valor anterior el (fecha y firma del trabajador)___/___/___ "
		@ li,131 PSAY "|"
	ELSE
		LI ++
		@ LI,00  PSAY "| Recebi da institui��o acima identificada, pelo exercicio de ministro religioso a importancia de: R$ " + TRANSFORM((TOTVENC-TOTDESC),cPict1) + CRLF + "| Na data de ___/___/___ " //"Recebi da institui��o acima identificada, pelo exercicio de ministro religioso a importancia de: " + TRANSFORM((TOTVENC-TOTDESC),cPict1),oArial10N)
	//	@ li,131 PSAY "|"
	ENDIF
	
	LI ++
	LI ++
	@ LI,00  PSAY "| Assinatura: " + Replicate("_",40)
	@ li,131 PSAY "|"

	LI ++
	@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
Else
	fRodapeArg()
Endif

Li += 1

//Quebrar pagina
If LI > 63
	If nGera == 2
		SetPrc(4,0)
   	nGera := 0 
   	LI := 4
	Endif
EndIf
cPict3 := "@E 999,999.99"  // Restauro o valor original de cPict3, declarado na funcao R030Imp.
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaZBol� Autor � Erika                 � Data � 19/03/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Zebrado (Bolivia)       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancaZBol()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaZBol(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0
Local dFechPago := RCH->RCH_DTPAGO
            

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases)) 

For nCont := 1 To nTermina
	@ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)
		@ LI,02 PSAY aProve[nCont,1]
		@ LI,30 PSAY TRANSFORM(aProve[nCont,2],'999.99')
		@ LI,50 PSAY TRANSFORM(aProve[nCont,3],cPict2)
	ENDIF
	@ LI,65 PSAY "|"
	IF nCont <= LEN(aDesco)
		@ LI,67 PSAY aDesco[nCont,1]
		@ LI,95 PSAY TRANSFORM(aDesco[nCont,2],'999.99')
		@ LI,115 PSAY TRANSFORM(aDesco[nCont,3],cPict3)
	ENDIF
	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++
	
	If nValidos = 12
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY STR0030			// "CONTINUA !!!"
		//		@ LI,76 PSAY "|"+&cCompac
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		
		If li >= 60
			li := 0
		Endif        
		
		nValidos := 0
		fCabecZBol()
		
	Endif
	
	
Next nCont

For nCont1 := nValidos+1 To 12
	@ Li,00  PSAY "|"
	@ Li,65  PSAY "|"
	@ Li,131 PSAY "|"
	Li++
Next nCont1

    @ LI,00 PSAY STR0124 + SPACE(10)      //"| TOTAL INGRESOS"
    @ LI,45 PSAY TRANS(TOTVENC, cPict1)  
    @ LI,67 PSAY STR0126 + SPACE(10)      //" TOTAL EGRESOS"
    @ LI,110 PSAY TRANS(TOTDESC, cPict1)   
    @ LI,131 PSAY "|"
    
    LI ++
	@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

	LI ++
	@ LI,00 PSAY "|"
	@ LI,05 PSAY DESC_MSG1
	@ LI,45 PSAY STR0135 + SPACE(10) + TRANS((TOTVENC-TOTDESC),cPict1) //"LIQUIDO PAGABLE: "
	@ LI,90 PSAY STR0136    											//"BOLIVIANOS"
	@ LI,131 PSAY "|" 
	
	LI++
	@ LI,00 PSAY "|"
	@ LI,05 PSAY DESC_MSG2
	@ LI,131 PSAY "|"   
	
	LI++
	@ LI,00 PSAY "|"
	@ LI,05 PSAY DESC_MSG3
	@ LI,131 PSAY "|"
	
	LI++
	@ LI,00 PSAY "|"
	@ LI,80 PSAY REPLICATE("_",40)
	@ LI,131 PSAY "|"
	
	LI++
	@ LI,00 PSAY "|"     
	@ LI,10 PSAY Desc_Cid + ", " + cValtoChar(Day(dFechPago)) + STR0080 + MesExtenso(Month(dFechPago)) + STR0080 + cValtoChar(Year(dFechPago)) + "."
	@ LI,90 PSAY STR0137 				//"RECIBI CONFORME"
	@ LI,131 PSAY "|"
	

	LI ++
	@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"



Li += 1

//Quebrar pagina
If LI > 60
	LI := 0
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fContinua � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressap da Continuacao do Recibo                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fContinua()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fContinua()    // Continuacao do Recibo

lContinua := .T.
Li+=1
If lIsDriver
	@ LI,05 PSAY &cNormal + STR0037		//"CONTINUA !!!"
Else
	@ LI,05 PSAY STR0037				//"CONTINUA !!!"
EndIf
Li+= 7

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRodape   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Rodape                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fRodape()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRodape(lLinhaRoda)    // Rodape do Recibo

If !lLinhaRoda
	LI += 1
Endif
@ LI,05 PSAY If( lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 )
LI ++
@ LI,05 PSAY If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 )
@ LI,41 PSAY TOTVENC PICTURE cPict1
@ LI,55 PSAY TOTDESC PICTURE cPict1
LI ++
@ LI,05 PSAY If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG3), DESC_MSG3 )
LI ++
IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
	@ LI, 02 PSAY STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
ENDIF
@ LI,55 PSAY TOTVENC - TOTDESC PICTURE cPict1
LI +=2

If lIsDriver
	@ LI,05 PSAY &cCompac+Transform(nSalario,cPict2)
Else
	@ LI,05 PSAY Transform(nSalario,cPict2)
EndIf

If cTipoRot = "2"  // Bases de Adiantamento
	If cBaseAux = "S" .And. nBaseIr # 0
		@ LI,89 PSAY nBaseIr PICTURE cPict1
	Endif
ElseIf cTipoRot = "1" .Or. cTipoRot = "6"  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		@ LI,23 PSAY Transform(nAteLim,cPict1)
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE cPict1
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE cPict2
		Endif
		If nBaseIr # 0
			@ LI,87 PSAY nBaseIr PICTURE cPict1
		Endif
		@ LI,101 PSAY Transform(nBaseIrfE,cPict1)
	Endif
ElseIf cTipoRot = "5" // Bases de FGTS e FGTS Depositado da 1� Parcela
	If cBaseAux = "S"
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE cPict1
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE cPict2
		Endif
	Endif
Endif

If lIsDriver
	@ LI,Pcol() Psay &cNormal
EndIf

Li ++
IF SRA->RA_BCDEPSA # SPACE(8)
	Desc_Bco := If( lLpt1, fTAcento(DescBco(Sra->Ra_BcDepSa,Sra->Ra_Filial)), DescBco(Sra->Ra_BcDepSa,Sra->Ra_Filial) )
	@ LI,01 PSAY STR0039	//"CRED:"
	@ LI,06 PSAY SRA->RA_BCDEPSA
	@ LI,14 PSAY "-"
	@ LI,15 PSAY DESC_BCO
	@ LI,50 PSAY STR0040 + SRA->RA_CTDEPSA	//"CONTA:"
ENDIF

If LI > 37
  	LI ++
Else
	LI += 2
Endif   

@ LI,05 PSAY " "
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRodapeArg�Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Rodape-Argentina                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fRodapeArg()

@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++LI,00 PSAY "| " + STR0094 + TRANS(TOTVENC,cPict1)
@ LI,44 PSAY STR0095 +TRANS(TOTDESC,cPict1)
@ LI,88 PSAY STR0096 +TRANS((TOTVENC-TOTDESC),cPict1)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130)+"|"
Li ++
@ Li,00 PSAY STR0079 + MesExtenso(MONTH(dDataRef)) + STR0080 + STR(YEAR(dDataRef),4)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130) + "|"
@ ++Li,00 PSAY STR0081 +EXTENSO(TOTVENC-TOTDESC,,,"-")+REPLICATE("*",95-LEN(EXTENSO(TOTVENC-TOTDESC,,,"-")))
@ LI,131 PSAY "|"
@ ++Li,00 PSAY STR0082
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"+STR0083
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131 PSAY "|"
@ ++Li,00 PSAY STR0084 + StrZero(Day(dDataRef),2) + STR0080 + MesExtenso(MONTH(dDataRef)) + STR0080+STR(YEAR(dDataRef),4)
@ Li,070 PSAY + REPLICATE("_",40)
@ LI,131 PSAY "|"
@ ++Li,00 PSAY STR0085 + TRANS((TOTVENC-TOTDESC),cPict1)
@ LI,131 PSAY "|"
@ ++Li,00 PSAY STR0086
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "*"+REPLICATE("-",130)+"*"

Return Nil


********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************
Local aAreaRCF	:= RCF->(GetArea())
Local cChaveSem	:= ""  

dbSelectArea( "RCF" )
dbSetOrder(1)

If !Empty(Semana)
	// Turno do funcionario
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB  
	
	If !dbSeek(xFilial("RCF") + cChaveSem + Semana, .T. )
		cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+"@@@"
		If !dbSeek(xFilial("RCF") + cChaveSem + Semana  )
			HELP( " ",1,"GPCALEND",  )	// "Nao existe calendario cadastrado para a competencia,  Turno ou semana."
			Return(NIL)
		Endif
	Endif
	cSem_De  := DtoC(RCF->RCF_DTINI,'DDMMYY')
	cSem_Ate := DtoC(RCF->RCF_DTFIM,'DDMMYY')
EndIf

RestArea(aAreaRCF)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSomaPdRec� Autor � R.H. - Mauro          � Data � 24.09.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Somar as Verbas no Array                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fSomaPdRec(Tipo,Verba,Horas,Valor)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Static lAglutPd // Sera utilizada em todas as chamadas da funcao fSomaPdRec()

If lAglutPd == Nil
	 lAglutPd := ( GetMv("MV_AGLUTPD",,"1") == "1" ) // 1-Aglutina verbas   2-Nao Aglutina
EndIf

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0 .Or. !lAglutPd
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0 .Or. !lAglutPd
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSendDPgto| Autor � R.H.-Natie            � Data � 15.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio de E-mail -Demonstrativo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico :Envio Demonstrativo de Pagto atraves de eMail  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fSendDPgto(lTerminal)

Local aSvArea		:= GetArea()
Local aGetArea		:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
Local cHtml			:= ""
Local cSubject		:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cTipo			:= ""
Local cTitTotal		:= STR0065
Local cTitTDesc		:= STR0066
Local cTitTLiq  	:= STR0067
Local cReferencia	:= ""
Local cVerbaLiq		:= ""
Local dDataPagto	:= Ctod("//")
Local nBase    		:= 0
Local nDesco
Local nZebrado		:= 0.00
Local nResto		:= 0.00
Local nProv
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario      
Local cDescUbigeo   := "" 

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

aGetArea	:= SRC->( GetArea() )
cTipo		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")

IF cTipoRot == "2"
	cVerbaLiq	:= PosSrv( "007ADT" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "1"
	cVerbaLiq	:= PosSrv( "047CAL" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "5"
	cVerbaLiq	:= PosSrv( "022C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF cTipoRot == "6"
	cVerbaLiq	:= PosSrv( "021C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
ElseIF  cRoteiro == "EXT"
	cVerbaLiq	:= ""
EndIF

IF  cRoteiro <> "EXT"
	dDataPagto := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro) , SRA->RA_FILIAL , "RCH_DTPAGO")
EndIf

IF !( lTerminal )
	
	//��������������������������������������������������������������Ŀ
	//� Busca parametros                                             �
	//����������������������������������������������������������������
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		If Empty(aTitle)
			Aadd( aTitle, OemToAnsi(STR0209) ) //"LOG das matr�culas que n�o foram enviadas"
			Aadd( aLog,{} )
			Aadd( aLog, { PADR( OemToAnsi(STR0212), FWGETTAMFILIAL) + " - " + PADR( OemToAnsi(STR0001), 10 ) + " - " + PADR( OemToAnsi(STR0003), 45 ) + " - " + OemToAnsi(STR0210) } ) //"Filial"#"Matr�cula"#"Nome"#"Ocorr�ncia"
	    EndIf
		Aadd( aLog, { PADR( SRA->RA_FILIAL, FWGETTAMFILIAL) + " - " + PADR( SRA->RA_MAT, 10) + " - " + PADR( SRA->RA_NOME, 45) + " - " + OemToAnsi(STR0211) } ) //"Sem e-mail cadastrado e/ou nao recebe e-mail (verif. campos: RA_EMAIL/RA_RECMAIL)"
		Return
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe o SMTP Server                             �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a CONTA                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a Senha                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailSenha)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
EndIF

If cPaisloc == "PER" .And. !( lTerminal )
	cDescUbigeo := fRDescUbig()
Endif

IF ( !Empty(Semana) .and. ( Semana # "99" ) .and. ( Upper(SRA->RA_TIPOPGT) == "S" ) )
	/*
	��������������������������������������������������������������Ŀ
	� Carrega Datas Referente a semana                             �
	����������������������������������������������������������������*/
	PerSemana()
	cReferencia := STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" //"Semana  "###" a "

ElseIf cPaisloc == "BOL"
	cReferencia	:= cTipo
Else
	cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + "-" + cPeriodo + "/" + Semana + " )"
EndIf

cHtml +=	'<?xml version="1.0" encoding="iso-8859-1"?>'
cHtml +=	'<!doctype html public "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cHtml +=	'<html xmlns="http://www.w3.org/1999/xhtml">'
cHtml +=	'<head>'
IF !( lTerminal )
	
	cHtml += 		'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
	cHtml +=	'</head>'
	cHtml +=		'<body bgcolor="#F0F0F0"  topmargin="0" leftmargin="0">'
	cHtml +=			'<center>'
	cHtml +=				'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#000082" bgcolor="#000082" width=598 height="637">'

	//Cabecalho
	cHtml +=    				'<td width="598" height="181" bgcolor="#FFFFFF">'
	cHtml += 					'<center>'
	cHtml += 					'<font color="#000000">'
	cHtml +=					'<b>'
	cHtml += 					'<h4 size="03">'
	cHtml +=					'<br>'
	cHtml += 						STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 					'<br>'
	
Else
	
	cHtml += 		'<title>RH Online</title>' + CRLF
	cHtml += 		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += 		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">' + CRLF
	cHtml += 	'</head>' + CRLF
	cHtml += 	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += 		'<Table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	
	//Cabecalho completo - TERMINAL
	Do Case
	Case cPaisLoc == "ARG"
		cHtml += 			CabHtmlArg( cReferencia , dDataPagto , dDataRef )
	Case cPaisLoc == "BOL"
		cHtml += 			CabHtmlBOL( cReferencia , dDataPagto , dDataRef )
	Otherwise
		cHtml += 			CabecHtml( cReferencia , dDataPagto , dDataRef )
	EndCase	
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=	 				"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	cHtml +=			"<TABLE border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
EndIF

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
Else
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
EndIf

/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

IF !( lTerminal )

	If cPaisloc <> "PER"	
		cHtml += '</b></h4></font></center>'
	cHtml += '<hr width = 100% align=right color="#000082">'

	//��������������������������������������������������������������Ŀ
	//� Dados da Empresa	                                         �
	//����������������������������������������������������������������
	cHtml += '<!Dados da Empresa>'
	cHtml += '<p align=left  style="margin-top: 0">'
	cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;' + Desc_Fil+'</i></b></font><br>'  //Empresa
	cHtml += 	'<font color="#000082" face="Courier New" size="2">'
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;'+ STR0098  + Desc_End	+'<br>'		//Endere�o
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;' +STR0179  + Desc_Cid	+ '&nbsp;&nbsp;&nbsp;' + STR0180 + Desc_Est + '<br>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;'+ STR0099  + Transform( Desc_CGC , "@R 99.999.999/9999-99")  	//CNPJ
	cHtml += '</p></font>'

		//��������������������������������������������������������������Ŀ
		//� Dados do funcionario                                         �
		//����������������������������������������������������������������
	cHtml += '<hr width = 100% align=right color="#000082">'
		cHtml += '<!Dados do Funcionario>'
		cHtml += '<p align=left  style="margin-top: 0">'
		cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp;' + SRA->RA_NOME + "- " + SRA->RA_MAT+'</i></b></font><br>'
	cHtml += 	'<font color="#000082" face="Courier New" size="2">'
	cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;' + STR0048 + cCodFunc + "  "+cDescFunc	+'<br>' //"Funcao    - "
	cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;' + STR0047 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
	cHtml +=    '&nbsp;&nbsp;&nbsp;&nbsp;' + STR0049 + SRA->RA_BCDEPSA+" - "+DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSA //"Bco/Conta - "
	cHtml += '</p></font>'

		cHtml += '<!Proventos e Desconto>'
		cHtml += '<div align="center">'
		cHtml += '<Center>'
	cHtml += '<Table bgcolor="#F0F8FF" style="border: 1px #003366 solid;" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
	cHtml +=    '<tr bgcolor="A2B5CD">' 
	cHtml += 	'<td><font face="Arial" size="02" color="#000082"><b>' + STR0050 + '</b></font></td>' //"Cod  Descricao "
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + STR0051 + '</b></font></td>' //"Referencia"
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + STR0052 + '</b></font></td>' //"Valores"
	cHtml += 	'<td>&nbsp;</td>'
	cHtml += 	'</tr>'
	ELSE //Cabecalho utilizado pela localizacao Peru
		cHtml += '</b></h4></font></center>'                                  
		cHtml += '<hr whidth = 100% align=right color="#FF812D">'            
		//��������������������������������������������������������������Ŀ
		//� Dados do funcionario                                         �
		//����������������������������������������������������������������
		cHtml += '<!Dados do Funcionario>'
		cHtml += '<p align=left  style="margin-top: 0">'
		cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
		cHtml +=  	'&nbsp;&nbsp' + STR0001 + ":" + '&nbsp;' + SRA->RA_MAT + '&nbsp;' + "-" + '&nbsp;' + SRA->RA_NOME +'</i><br>' //Funcionario
		cHtml += 	'&nbsp;&nbsp' + "DNI" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  '&nbsp;' + SRA->RA_RG      + '&nbsp;&nbsp;' + STR0174 + '&nbsp;' +":"+ '&nbsp;' + AllTrim(STR(SRA->RA_HRSMES))+'<br>' //"DNI + Horas Mensais
		
		If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
			cHtml += 	'&nbsp;&nbsp' + "AFP" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  Space(1) + SRA->RA_CODAFP  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + "Ubigeo :" + '&nbsp;' + cDescUbigeo +'<br>' //"DNI + Horas Mensais
		Else
			cHtml += 	'&nbsp;&nbsp' + "AFP" + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ":"   +  Space(1) + ' '             + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + "Ubigeo :" + '&nbsp;' + cDescUbigeo +'<br>' //"DNI + Horas Mensais
		EndIf
		
		cHtml += 	'&nbsp;&nbsp' + STR0103 + '&nbsp;&nbsp;' + ":" + '&nbsp;' + cCodFunc   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + STR0069 + '&nbsp;' + ":" + '&nbsp;' + cDescFunc	+'<br>' //"Funcao    - Descricao "
		cHtml +=  	'&nbsp;&nbsp' + STR0002 + '&nbsp;&nbsp'  + ":" + '&nbsp;' + SRA->RA_CC + '&nbsp;'+ "-" + '&nbsp;' + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
		cHtml +=	'&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSA+"-"+DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSA //"Bco/Conta - "
		cHtml += '</b></p></font>'
		cHtml += '<!Proventos e Desconto>'
		cHtml += '<div align="center">'
		cHtml += '<Center>'
		cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
		cHtml += '<TBody><Tr>'
		cHtml +=	'<font face="Arial" size="02" color="#000082"><b>'
		cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
		cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
		cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
		cHtml += 	'</b></font></tr>'
		cHtml += '<font color=#000082 face="Courier new"  size=2">'
	ENDIF
	
	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Cabecalho e os Proventos/Descontos          �
	//����������������������������������������������������������������
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
Else
	
	//Cabecalho dos valores
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml += 							'<tr align="center">' + CRLF
	cHtml += 								'<td width="45" height="1">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="Left">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="left">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0070  + '</span></div>' + CRLF //Refer&ecirc;ncia
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0052 + '</span></div>' + CRLF //Valores
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right"> (+/-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml += 					'</TABLE>' + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Proventos                                                    �
//����������������������������������������������������������������
For nProv:=1 To Len( aProve )
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,2],'999.99')+'</b></font></td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,3],cPict3) + '</b></font></td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" vAlign=top height="1" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" vAlign=top height="1">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" vAlign=top="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nProv

IF ( lTerminal )
	cHtml +=							"</TR>" + CRLF
	cHtml +=							"<TR>" + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Descontos                                                    �
//����������������������������������������������������������������
For nDesco := 1 to Len(aDesco)
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,2],'999.99') + '</b></font></td>'
		cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,3],cPict3) + '</b></font></td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" align="center" height="19" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" align="center" height="19">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nDesco

IF ( lTerminal )
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
	//��������������������������������������������������������������Ŀ
	//� Terminal - Impressao de Bases                                �
	//����������������������������������������������������������������
	IF cBaseAux = "S"

		For nBase:=1 To Len( aBases )
	
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										aBases[nBase,1] + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,2],'999.99') + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(aBases[nBase,3],cPict1) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF

        Next

		If Len( aBases ) > 0   // Espaco apos impressao bases

			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc"></td>'
			cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
			cHtml += 		'<td class="td18_18_AlignL"></td>'
			cHtml += 	'</tr>'
		
		EndIf

	EndIf
EndIF

IF !( lTerminal )
	
	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Proventos e Descontos e os Totais           �
	//����������������������������������������������������������������
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//��������������������������������������������������������������Ŀ
	//� Totais                                                       �
	//����������������������������������������������������������������
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTVENC,cPict3) + '</b></font></td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTDESC,cPict3) +  '</b></font></td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>'
	cHtml += 		'<td align=right height="18" width="95" Style=border-top:1px solid #000082 bgcolor=#4B87C2">'
	cHtml +=        '<font color="#000082">' + Transform((TOTVENC-TOTDESC),cPict3) + '</font></td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
	
Else
	
	If cPaisLoc == "ARG"
		cTitTotal := AllTrim(SubsTr(STR0094,2))
		cTitTDesc := AllTrim(SubsTr(STR0095,2))
		cTitTLiq  := AllTrim(SubsTr(STR0096,2))
	EndIf

	//Total de Proventos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTotal + '</div>' + CRLF //"Total Bruto: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTVENC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	//Total de Descontos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + cTitTDesc + '</div>' + CRLF //"Total de Descontos: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTDESC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	
	//Liquido
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas">' + cTitTLiq  + '</div>' + CRLF //"L&iacute;quido a Receber: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (=) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Espacos Entre os Totais e as Bases                           �
//����������������������������������������������������������������
IF !( lTerminal )
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp;</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//��������������������������������������������������������������Ŀ
	//� Salario Base                                                 �
	//����������������������������������������������������������������
	cHtml +=	'<tr>'
	cHtml +=		'<td class="tdPrinc"><p class="pStyle1">'+STR0181+'</p></td>' //"Salario Base
	cHtml +=		'<td class="td26_94_AlignR"><p></p></td>'
	cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nSalario,cPict1)+ '</b></font></td>'
	cHtml += '</tr>'
	
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Base de Adiantamento                                         �
//����������������������������������������������������������������
If cTipoRot = "2"
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !( lTerminal )
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict1)+ '</b></font></td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
			cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,cPict3) + '</div></td>' + CRLF
			cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,cPict3) + '</div></td>' + CRLF
			cHtml += '</tr>'
		EndIF
	Endif
	//��������������������������������������������������������������Ŀ
	//� Base de Folha e de 13o 20 Parc.                              �
	//����������������������������������������������������������������
ElseIf (cTipoRot = "1" .Or. cTipoRot = "6") .And. cPaisloc == "BRA"
	
	IF cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0056 +'</p></td>'//"Base FGTS/Valor FGTS"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict3)+ '</b></font></td>'
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts    ,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0057 +'</p></td>'//"Base IRRF Folha/Ferias"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict3)+ '</b></font></td>'
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIrfe,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'                                   
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0116 +'</p></td>'//"Base INSS"
			cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nAteLim,cPict3)+ '</b></font></td>'
			cHtml += '</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas'>"
			cHtml +=										STR0057 + CRLF //"Base IRRF Folha/Ferias"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados'>" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nBaseIr,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados'>"  + CRLF
			cHtml += 										"<div align='right'>" + Transform(nBaseIrFe,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados'>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas' bgcolor='#FAFBFC' >"
			cHtml +=										STR0116 + CRLF //"Base INSS"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas" bgcolor="#FAFBFC"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nAteLim,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados' bgcolor='#FAFBFC' >"  + CRLF
			cHtml += 										"<div align='right'></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
		EndIF
		
		//�������������������������������������������������������������������������������������������������������Ŀ
		//�Motivo: Permitir que possam ser exibidos no rodape do recibo de pagamento valores de verbas especificas�
		//���������������������������������������������������������������������������������������������������������
		If ExistBlock("GP30BASEHTM")
			cHtmlAux := ExecBlock("GP30BASEHTM",.F.,.F.)
			If ValType(cHtmlAux) = "C"
				cHtml  += cHtmlAux
			Endif	
		Endif
	EndIF
	//��������������������������������������������������������������Ŀ
	//� Bases de FGTS e FGTS Depositado da 1� Parcela                �
	//����������������������������������������������������������������
ElseIf cTipoRot = "5" .And. cPaisloc == "BRA"
	
	If cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc">'
			cHtml +=		'<p class="pStyle1">'+ STR0056 +'</td>' //"Base FGTS / Valor FGTS"
			cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict1) + '</b></font></td>'
			cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts,cPict2) + '</b></font></td>'
			cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
			cHtml += 	'</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
		EndIF
		
	Endif
	
EndIF

IF !( lTerminal )
	
	cHtml += '</font></i></b>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#000082">'
	
	//��������������������������������������������������������������Ŀ
	//� Espaco para Observacoes/mensagens                            �
	//����������������������������������������������������������������
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor="#FFFFFF" border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082"><b>'+STR0146+'</b></font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	If Month(dDataRef) == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Arial" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
	
Else
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=			 		"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Rodape
	cHtml +=	RodaHtml()
	
	cHtml += 		'</TABLE>' + CRLF
	cHtml += 		'<p align="right"><a href="javascript:self.print()"><img src="imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += 	'</body>' + CRLF
	cHtml += '</html>' + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Envia e-mail p/funcionario                                   �
//����������������������������������������������������������������
IF !( lTerminal )
	lEnvioOK := GPEMail(cSubject,cHtml,cEMail)
EndIF

RestArea( aSvArea )

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpTeste �Autor  �R.H. - Natie        � Data �  11/29/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Testa impressao de Formulario Teste                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fImpTeste(cString,nTipoRel)
Local nArea := 0
//--Comando para nao saltar folha apos o MsFlush.
SetPgEject(.F.)

//��������������������������������������������������������������Ŀ
//� Descarrega teste de impressao                                �
//����������������������������������������������������������������
MS_Flush()

If !fInicia(cString,nTipRel)
	Return
EndIf

//����������������������������������������������������������������������������������Ŀ
//� Define o Li com a a linha de impress�o correten para n�o saltar linhas no teste  �
//������������������������������������������������������������������������������������
li := _Prow()

If nTipoRel == 2
	@ LI,00 PSAY AvalImp(Limite)
Endif

nArea := Select("SRA")
If nArea > 0
	DbSelectArea(nArea)
EndIF

//--> S� pergunta na primeira impress�o!
If Vez == 0
	Vez++
	lRetCanc	:= Pergunte("GPR30A",.T.)
EndIf

Return Vez

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fInicia   �Autor  �Natie               � Data �  04/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializa parametros para impressao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  fInicia(cString,nTipoRel)

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

If nTipoRel == 1 .OR. nTipoRel == 2
	SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �CabecHtml  		�Autor�Marinaldo de Jesus � Data �18/09/2003�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Cabecalho HTML para o RHOnLine                      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������
*/
Static Function CabecHtml( cReferencia , dDataPagto , dDataRef )

Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cAltLogo		:= SUPERGETMV("MV_GPALTLOGO",,"30")
Local cLarLogo		:= SUPERGETMV("MV_GPLARLOGO",,"206")
Local cTCFCxFx		:= SUPERGETMV("MV_TCFCXFX",,'')
Local cTCFSDoc		:= SuperGetMv( "MV_TCFSDOC" , .F. , "1" ) // '1' = Utiliza CPF   '2'= Utiliza RG
Local cDescSDoc		:= OemToAnsi( AllTrim( RetTitle( If( cTCFSDoc=="2", "RA_RG", "RA_CIC" ) ) ) )
Local cTitPagto		:= STR0044  // Titulo p/ o Comprovante de Pagto.
// PER
Local cDescUbigeo   := "" 
Local dDataPerAd	:= cTod("")
Local dDataPerAt	:= cTod("")
Local dDataIniF     := cTod("")
Local dDAtaFimF		:= cTod("") 
Local nDiastb		:= 0    //Dias Trabalhados
Local nDiasAfas		:= 0    //Dias de Afastamento
Local nDiasAfs		:= 0	//Dias de Afastanentos subsidiados  
Local cUltDia	    := StrZero( f_UltDia(CTOD( "01/" + cMes + "/"+ cAno , "DDMMYY" ) ) , 2 ) //Ultimo dia do mes deste periodo
Local dData   	    := Ctod( cUltDia + "/" + cMes + "/" + cAno , "DDMMYY" ) //data formatada com o ultimo dia do mes.
Local nHorOrd       := 0 //Quantidade de horas trabalhadas pelo funcionario
Local nHorExt       := 0 //Quantidade de horas extras trabalhadas pelo funcionario

DEFAULT cReferencia	:= ""

Private nTotDias := 0	 //-- Total de Dias da Semana 
Private cDiasMes := Getmv("MV_DIASMES") 
Private DiasDsr  := 0

If cPaisLoc == "PER"

	If SRA->RA_TIPOPGT = "S"
		nTotDias := 7						//-- Total de Dias da Semana 
	EndIf   
	
	cDescUbigeo := fRDescUbig() 
	cTpEmprega  := fRTipoEmp()
	fRetFerFunc(@dDataPerAd, @dDataPerAt ,@dDataIniF , @dDAtaFimF)
	cDescAfp    := fRDescAFP()  
	
	// -- Apura Dias Trabalhados
	FDiasTrab(@nDiastb,cDiasMes,.F.,dData,.F.)
	
	// -- Apura Dias de Afastamento
	fDiasAfast(@nDiasAfas,@nDiastb,dData) 
	
	//Busca dias de afastamento subsidiados
	fAfasSub(@nDiasAfs)
	
	//Busca horas ordinarias
	fHorasFunc( .F. , @nHorOrd , Semana)
	
	//Busca horas extras
	fHorasFunc( .T. , @nHorExt, Semana)

	nSalario := SRA->RA_SALARIO
EndIf	

/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )   

//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
If !Empty(cLarLogo) .And. !Empty(cAltLogo)
	cHtml +=			"<img src='" + cLogoEmp +"' width='"+cLarLogo+"' height='"+cAltLogo+"'align=left hspace=30>" + CRLF
Else
	cHtml +=			"<img src='" + cLogoEmp +"' width='206' height='030' align=left hspace=30>" + CRLF
EndIf
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( cTitPagto ) + "</span>" + CRLF //DEMONSTRATIVO DE PAGAMENTO
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empresa
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0097 + CRLF //"Empresa: "
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Endereco e CNPJ
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0098 + CRLF //"Endere�o:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( AllTrim( Desc_End ) ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0099 + CRLF	//"CNPJ:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( Desc_CGC , "@R 99.999.999/9999-99") + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Data do Credito e Conta Corrente
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0101 + CRLF //"Cr�dito em:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc(dDataPagto) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0102 + CRLF //"Banco/Ag�ncia/Conta:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( Transform( SRA->RA_BCDEPSA , "@R 999/999999" ) ) + "/" + SRA->RA_CTDEPSA + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Referencia
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0100 + CRLF //"Referencia:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cReferencia + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='75%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0105 + CRLF //"Nome:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF

If "RA_NOME" $ cTCFCxFx .or. cTCFCxFx == '*'
	cHtml +=								AllTrim( SRA->RA_NOME ) + CRLF
Else
	cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
EndIf

cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0106 + CRLF //"Matricula:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

If cPaisLoc $ 'PER'

	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF

	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0111 + CRLF //"Admiss�o:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
	cHtml +=						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "DNI: "+ CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							Transform( SRA->RA_RG , PesqPict('SRA','RA_RG') ) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + STR0174 + CRLF  // Horas Mensais  
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(STR(SRA->RA_HRSMES)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF

	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "AFP: "+ CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	
	If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
		cHtml +=	SRA->RA_CODAFP + CRLF
	Else	
		cHtml +=	' ' + CRLF
	EndIf
	
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Ubigeo : " + CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							cDescUbigeo + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF

	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias Lab: "+ CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiastb)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias Subs: "+ CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiasAfs)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "Dias No Lab: "+ CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nDiasAfas)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF


	//Separador
	cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF

	cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "N. Hrs Ord: " + CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nHorOrd)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + "N. Hrs Ext: " + CRLF 
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							AllTrim(Str(nHorExt)) + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF

ElseIf cPaisLoc <> "URU"
	//CTPS, Serie e CPF
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF

	cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0107 + CRLF	//"CTPS:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=							SRA->RA_NUMCP + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0108 + CRLF //"S�rie:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								SRA->RA_SERCP + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=				"<TD vAlign=top width='172' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=					"<span class='etiquetas'>" + cDescSDoc + CRLF // Titulo de RA_CIC ou RA_RG
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	If cTCFSDoc == '2'
		cHtml +=							Transform( SRA->RA_RG , PesqPict('SRA','RA_RG') ) + CRLF
	Else
		cHtml +=							Transform( SRA->RA_CIC , PesqPict('SRA','RA_CIC') ) + CRLF
	EndIf
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF

	cHtml +=	 		"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
EndIf

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0103  + CRLF //Funcao
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF

If "RA_CODFUNC" $ cTCFCxFx .or. cTCFCxFx == '*'
	cHtml +=								AllTrim( cDescFunc ) + CRLF
Else
	cHtml +=								Capital( AllTrim( cDescFunc ) ) + CRLF
EndIf

cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + If(cPaisLoc=="PER",STR0175,STR0104) + CRLF //Rem.Basica##Salario Nominal:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( nSalario , cPict1 ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Centro de Custo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0110 + CRLF //Centro de Custo:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF

If "RA_CC" $ cTCFCxFx .or. cTCFCxFx == '*'
	cHtml +=								AllTrim( SRA->RA_CC ) + " - " + AllTrim(fDesc("SI3",SRA->RA_CC,"I3_DESC",TamSx3("I3_DESC")[1]) ) + CRLF
Else
	cHtml +=								AllTrim( SRA->RA_CC ) + " - " + Capital( AllTrim(fDesc("SI3",SRA->RA_CC,"I3_DESC",TamSx3("I3_DESC")[1]) ) ) + CRLF	
EndIf

cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

If cPaisLoc $ 'BRA'
	//Admissao
	cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=		"<TBODY>" + CRLF
	cHtml +=			"<TR>" + CRLF
	cHtml +=				"<TD vAlign=top width='329' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0111 + CRLF //"Admiss�o:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
	cHtml +=						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
	cHtml +=				"<TD vAlign=top width='231' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0112 + CRLF //"Dependente(s) IR:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								SRA->RA_DEPIR + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
If lDepSf
	cHtml +=				"<TD vAlign=top width='390' height=1>" + CRLF
	cHtml +=					"<P align=left>" + CRLF
	cHtml +=						"<span class='etiquetas'>" + STR0113 + CRLF //"Dependente(s) Sal�rio Fam�lia:"
	cHtml += 						"</span>" + CRLF
	cHtml +=						"<span class='dados'>" + CRLF
	cHtml +=								SRA->RA_DEPSF + CRLF
	cHtml += 						"</span>" + CRLF
	cHtml +=					"</P>" + CRLF
	cHtml +=				"</TD>" + CRLF
EndIf
	cHtml +=			"</TR>" + CRLF
	cHtml +=		"</TBODY>" + CRLF
	cHtml +=	"</TABLE>" + CRLF
EndIf
	
Return( cHtml )


/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �CabHtmlArg		�Autor�Ricardo Berti	  � Data �13/01/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Cabecalho HTML para o RHOnLine - Argentina          �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������
*/
Static Function CabHtmlArg( cReferencia , dDataPagto , dDataRef )

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= fGetCargo(SRA->RA_MAT)	//-- Codigo do Cargo do Funcionario
Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()

/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
cHtml +=			"<img src='" + cLogoEmp +"' width='206' height='030' align=left hspace=30>" + CRLF
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( STR0090 ) + "</span>" + CRLF //RECIBO DE HABERES
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0119 + CRLF	//"Periodo: xxxx"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cPeriodo + CRLF 
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "  " + STR0120 + CRLF	//"No.Pago:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Semana + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empleador
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0087,3) + CRLF //"Empleador:"
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Domicilio
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0088,3) + CRLF //"Domicilio:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+"-"+Desc_Est ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//CUIT
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0089,3) + CRLF //"CUIT:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Desc_CGC + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Fec.ULT.DEP + DEP.BCO:
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0071,3) + CRLF //"Fec. Ult. Dep.:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cDtPago + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0073 + CRLF //"Dep. en Bco:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Alltrim(SRA->RA_BCDEPSA) + "-" + DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e CUIL
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0074,3) + CRLF //"Beneficiario:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0106 + CRLF //"Matricula:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Admissao e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='50%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + SubsTr(STR0076,3) + CRLF //"Fec. de Ing.:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='50%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "CUIL:" + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_CIC + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF

// funcao + cargo
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0077 + CRLF //"Calif. Prof.:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cDescFunc + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0078 + CRLF //"Tarea Cump."
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=							Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,6) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �CabHtmlBOL		�Autor�Ricardo Berti	  � Data �10/01/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Cabecalho HTML para o RHOnLine - BOLIVIA            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function CabHtmlBOL( cReferencia , dDataPagto , dDataRef )

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()
Local cTitPagto		:= "BOLETA DE PAGO"  // Titulo p/ o Comprovante de Pagto.
Local cDepto        := ""       
Local dData			:= "00/00/00"
Local nTc			:= 0		//-- T. C. 

DEFAULT cReferencia	:= ""

//Private nTotDias := 0	 //-- Total de Dias da Semana 
//Private cDiasMes := Getmv("MV_DIASMES") 
//Private DiasDsr  := 0

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )   

//calcula o ultimo dia do mes do Periodo selecionado para buscar o campo nTc
dData	:= F_UltDia(dDataRef)
dData	:= DaySum( dDataRef , dData-Day(dDataRef) )
nTc		:= fTabela( "S009", 1, 5, dData)
//carrega departamento                                            
cDepto:= fDesc("CTT", SRA->RA_CC, "CTT->CTT_DESC01", 30)
cReferencia:= '('+cReferencia + ' - ' + MesExtenso(Month(dDataRef)) + "/" + left(DTOS(dDataRef),4)+')'
 
//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
cHtml +=			"<img src='" + cLogoEmp +"' width='206' height='030' align=left hspace=30>" + CRLF
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( cTitPagto ) + "</span>" + CRLF //DEMONSTRATIVO DE PAGAMENTO
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empresa
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0097 + CRLF //"Empresa: "
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Endereco e NIT
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0098 + CRLF //"Endere�o:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( AllTrim( Desc_End ) ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "NIT:" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Desc_CGC + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//T.C. e Conta Corrente

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0141 + CRLF	//"T.C.:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform(nTc, "99.99999") + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0102 + CRLF //"Banco/Ag�ncia/Conta:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( Transform( SRA->RA_BCDEPSA , "@R 999/999999" ) ) + "/" + SRA->RA_CTDEPSA + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Mes (Referencia)
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" +  "Mes:" + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cReferencia + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='75%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0105 + CRLF //"Nome:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Codigo:" + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF

// Cargo + C.ID + Admissao
cHtml +=				"<TD vAlign=top width='50%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0123  + CRLF //"Cargo:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( cDescFunc ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=					"<span class='etiquetas'>" + "CI: "+ CRLF 
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=							SRA->RA_RG + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0111 + CRLF //"Ingreso:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Depto (Centro de Custo) + CI
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF

cHtml +=				"<TD vAlign=top width='70%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0132 + CRLF //"DPTO.:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cDepto + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=					"<span class='etiquetas'>" + STR0128 + CRLF //"Seguro S.:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF


If cPaisLoc == "BOL"
	cHtml +=	SRA->RA_SEGUROS + CRLF 
Else
	cHtml +=	' ' + CRLF
EndIf


cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Horas domingo trab + H.Extras + #Dias
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF

cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0167 + CRLF //"Horas Domingo Trabajado"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cValtoChar(nPagoDom) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0140 + CRLF //"H. EXTRAS:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cValtoChar(nHraExtra) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=				"<TD vAlign=top width='30%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + STR0139 + CRLF //"H. EXTRAS:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								"30.00" + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF

cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )


/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �RodaHtml  		�Autor�Marinaldo de Jesus � Data �18/09/2003�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Rodape HTML para o RHOnLine                         �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function RodaHtml()

Local cHtml	:= ""

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top height=1>" + CRLF
cHtml +=					"<P align=center>" + CRLF
cHtml += 							STR0114 + CRLF //"Valido como Comprobante Mensual de Remuneracion"
cHtml +=						"<br>" + CRLF
If cPaisLoc == "BRA"
	cHtml += 							STR0115 + CRLF //"( Artigo no. 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991 )"
EndIf
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �fMontaDtTcf 	�Autor�Ricardo Duarte     � Data �13/08/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna a data valida para a consulta do Terminal Consulta  �
�          �do Funcionario                                         		�
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function fMontaDtTcf(cMesAno,nDia)

Local dDataValida
Default nDia := 0

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia

return(dDataValida)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o	 �f030Roteiro� Autor � Tatiane Matias        � Data � 28/02/05 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Selecionar o Roteiro                               		   ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe	 � f030Roteiro()											   ���
��������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function f030Roteiro(l1Elem, lTipoRet, lVExtras)

Local cTitulo	:="Roteiro de Calculo"
Local nFor		:= 0
Local nElem		:= 0
Local MvPar
Local MvParDef	:=""
Local MvRetor	:= ""

Private aSit:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

DEFAULT lTipoRet 	:= .T.                    
DEFAULT lVExtras	:= .T.

cAlias := Alias() 					// Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

dbSelectArea("SRY")
If dbSeek(cFilial)
	CursorWait()
	While !Eof() .And. SRY->RY_FILIAL == cFilial
		If !(SRY->RY_TIPO $ "3*4*G*J")
			Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
			MvParDef += SRY->RY_CALCULO
		EndIf
		dbSkip()
	Enddo  
	If lVExtras
		Aadd(aSit, "EXT - Valores Extras")
		MvParDef += "EXT"
	EndIf
	CursorArrow()
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,,,l1Elem, GetSx3Cache("RY_CALCULO","X3_TAMANHO"))  // Chama funcao f_Opcoes
		CursorWait()
		For nFor := 1 To Len( mVpar ) Step 3
			IF ( SubStr( mVpar , nFor , 3 ) # "***" )
				mvRetor += SubStr( mVpar , nFor , 3 )
			Endif
		Next nFor
		&MvRet := Mvretor
		CursorArrow()	
	EndIF	
EndIF

dbSelectArea(cAlias) // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecPer � Autor � Alceu Pereira         � Data � 05.02.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Cabe�alho em Formulario Continuo              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecPer()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Localizacao Peru                                           ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecPer()		// Cabecalho do Recibo

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cDescRot		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")
Local cDescUbigeo   := "" 
Local dDataPerAd	:= cTod("")
Local dDataPerAt	:= cTod("")
Local dDataIniF     := cTod("")
Local dDAtaFimF		:= cTod("") 
Local nDiastb		:= 0    //Dias Trabalhados
Local nDiasAfas		:= 0    //Dias de Afastamento
Local nDiasAfs		:= 0	//Dias de Afastanentos subsidiados  
Local cUltDia	    := StrZero( f_UltDia(CTOD( "01/" + cMes + "/"+ cAno , "DDMMYY" ) ) , 2 ) //Ultimo dia do mes deste periodo
Local dData   	    := Ctod( cUltDia + "/" + cMes + "/" + cAno , "DDMMYY" ) //data formatada com o ultimo dia do mes.
Local nHorOrd       := 0 //Quantidade de horas trabalhadas pelo funcionario
Local nHorExt       := 0 //Quantidade de horas extras trabalhadas pelo funcionario

Private nTotDias := 0	 //-- Total de Dias da Semana 
Private cDiasMes := Getmv("MV_DIASMES") 
Private DiasDsr  := 0

If SRA->RA_TIPOPGT = "S"
	nTotDias := 7						//-- Total de Dias da Semana 
EndIf   

cDescUbigeo := fRDescUbig() 
cTpEmprega  := fRTipoEmp()
fRetFerFunc(@dDataPerAd, @dDataPerAt ,@dDataIniF , @dDAtaFimF)
cDescAfp    := fRDescAFP()  

// -- Apura Dias Trabalhados
FDiasTrab(@nDiastb,cDiasMes,.F.,dData,.F.)

// -- Apura Dias de Afastamento
fDiasAfast(@nDiasAfas,@nDiastb,dData) 

//Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

//Busca dias de afastamento subsidiados
fAfasSub(@nDiasAfs)

//Busca horas ordinarias
fHorasFunc( .F. , @nHorOrd , Semana)

//Busca horas extras
fHorasFunc( .T. , @nHorExt, Semana)

/*��������������������������������������������������������������Ŀ
  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
  ����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )   

cDescUbigeo := fRDescUbig()

@ PROW(),PCOL() PSAY ""

LI ++

If lIsDriver
	@ LI,01 PSAY &cNormal+DESC_Fil  + " " + DESC_CGC 
Else
	@ LI,01 PSAY DESC_Fil  + " " + DESC_CGC 
EndIf

LI ++                
@ LI,01 PSAY AllTrim(DESC_END) + Space(1) + AllTrim(DESC_COMP) + Space(1) + AllTrim(DESC_EST) + Space(1) + AllTrim(DESC_CID)

LI ++
@ LI,01 PSAY cDescRot + " - " + cPeriodo+"/"+Semana
 
LI ++              
@ LI,01 PSAY "Per. Vac.:"  + Substr(Dtos(dDataPerAd),7,2) + "/" + Substr(Dtos(dDataPerAd),5,2) + "/" + Substr(Dtos(dDataPerAd),1,4) + "-" + Substr(Dtos(dDataPerAt),7,2) + "/" + Substr(Dtos(dDataPerAt),5,2) + "/" + Substr(Dtos(dDataPerAt),1,4)

LI +=2
@ LI,01 PSAY SRA->RA_Mat
@ LI,08 PSAY Left(SRA->RA_NOME,28)
@ LI,37 PSAY fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef)
@ LI,44 PSAY SRA->RA_FILIAL
@ LI,47 PSAY PADC(ALLTRIM(SRA->RA_CC),20)
@ LI,67 PSAY ORDEM_REL PICTURE "99"
@ LI,73 PSAY AllTrim(SRA->RA_HRSMES)
@ LI,80 PSAY "Fecha Nacimiento : " +  Substr(Dtos(SRA->RA_NASC),7,2) + "/" + Substr(Dtos(SRA->RA_NASC),5,2) + "/" + Substr(Dtos(SRA->RA_NASC),1,4)

LI ++      

cDet := STR0015       + cCodFunc				    //-- Funcao
cDet += cDescFunc     + ' '
cDet += DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
cDet += STR0016 + SRA->RA_CHAPA					   //'CHAPA: '
cDet += + Space(6) + STR0170 +  '   ' + cProcesso   
@ LI,01 PSAY cDet   

LI +=1

@ LI,01 PSAY "DNI : " + SRA->RA_RG
@ LI,37 PSAY "Desc. AFP: " +  cDescAfp

If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
	@ LI,73 PSAY "COD AFP : " + AllTrim(SRA->RA_CODAFP)
Else
	@ LI,73 PSAY "COD AFP : " 
EndIf

LI +=1

@ LI,01 PSAY "Fecha Ingresso   : "  + Substr(Dtos(SRA->RA_ADMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),1,4)
@ LI,37 PSAY "Fecha Cese: "  + Substr(Dtos(SRA->RA_DEMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),1,4)

If cPaisLoc == "PER"
	@ LI,73 PSAY "C.U.S.P.P. : "   +  SRA->RA_CUSPP
Else
	@ LI,73 PSAY "C.U.S.P.P. : "   
EndIf

LI +=1

@ LI,01 PSAY "Tipo/Cat trab   : "  + Substr(cTpEmprega,1,15)
@ LI,37 PSAY "Inicio Vac.: " + Substr(Dtos(dDataIniF),7,2) + "/" + Substr(Dtos(dDataIniF),5,2) + "/" + Substr(Dtos(dDataIniF),1,4) 
@ LI,73 PSAY "Fim Vac.   : " + Substr(Dtos(dDAtaFimF),7,2) + "/" + Substr(Dtos(dDAtaFimF),5,2) + "/" + Substr(Dtos(dDAtaFimF),1,4)

LI +=1

@ LI,01 PSAY "Dias Lab: "   + AllTrim(Str(nDiastb)) 
@ LI,37 PSAY "Dias Subs: " + AllTrim(Str(nDiasAfs))
@ LI,73 PSAY "Dias No Lab: "  + AllTrim(Str(nDiasAfas))
      
LI +=1
@ LI,01 PSAY "N. Hrs Ord: "   + AllTrim(Str(nHorOrd)) 
@ LI,37 PSAY "N. Hrs Ext: " + AllTrim(Str(nHorExt))
@ LI,73 PSAY "Rem. Basica:  "  + AllTrim(Transform((SRA->RA_SALARIO), cPict1))

LI +=1
@ LI,01 PSAY "Cod.Ubigeo: " + SRA->RA_CEP + " - " + cDescUbigeo

Li += 2 
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabeczPer� Autor � R.H. - Alceu Pereira  � Data � 08.02.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO do cabe�alho formulario zebrado (Peru)            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabeczPer()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Localizacao Peru                                           ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecZPer()    // Cabecalho do Recibo Zebrado 

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario 
Local cDescUbigeo   := ""   
Local cDescRot		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_DESC")
Local cDescAfp      := "" 
Local dDataPerAd	:= cTod("")
Local dDataPerAt	:= cTod("")
Local dDataIniF     := cTod("")
Local dDAtaFimF		:= cTod("") 
Local nDiastb		:= 0    //Dias Trabalhados
Local nDiasAfas		:= 0    //Dias de Afastamento
Local nDiasAfs		:= 0	//Dias de Afastanentos subsidiados  
Local cUltDia	    := StrZero( f_UltDia(CTOD( "01/" + cMes + "/"+ cAno , "DDMMYY" ) ) , 2 ) //Ultimo dia do mes deste periodo
Local dData   	    := Ctod( cUltDia + "/" + cMes + "/" + cAno , "DDMMYY" ) //data formatada com o ultimo dia do mes.
Local nHorOrd       := 0 //Quantidade de horas trabalhadas pelo funcionario
Local nHorExt       := 0 //Quantidade de horas extras trabalhadas pelo funcionario

Private nTotDias := 0	 //-- Total de Dias da Semana 
Private cDiasMes := Getmv("MV_DIASMES") 
Private DiasDsr  := 0

If SRA->RA_TIPOPGT = "S"
	nTotDias := 7						//-- Total de Dias da Semana 
EndIf   
cDescUbigeo := fRDescUbig() 
cTpEmprega  := fRTipoEmp()
fRetFerFunc(@dDataPerAd, @dDataPerAt ,@dDataIniF , @dDAtaFimF)
cDescAfp    := fRDescAFP()  

// -- Apura Dias Trabalhados
FDiasTrab(@nDiastb,cDiasMes,.F.,dData,.F.)

// -- Apura Dias de Afastamento
fDiasAfast(@nDiasAfas,@nDiastb,dData) 

//Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

//Busca dias de afastamento subsidiados
fAfasSub(@nDiasAfs)

//Busca horas ordinarias
fHorasFunc( .F. , @nHorOrd , Semana)

//Busca horas extras
fHorasFunc( .T. , @nHorExt, Semana)

@ Li,00 PSAY Avalimp(Limite)
LI ++                                       
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY STR0017		//"RECIBO DE PAGAMENTO  "  
@ LI,131 PSAY "|"

LI ++             
@ LI,00  PSAY  "|"
@ LI,30  PSAY "(" + Space(1) + MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4) + Space(1) + "-" + Space(1) + AllTrim(cDescRot) +  SPACE(1) + "-" + Space(1) + STR0119 + cPeriodo + SPACE(1) + "/" + Space(1) + Semana + ")"
@ LI,131 PSAY "|"  

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY STR0018 +  AllTrim(DESC_CGC) + Space(5) + "-"    //"| Empresa   : "  
@ LI,39  PSAY AllTrim(DESC_Fil) 
@ LI,87  PSAY "-"	    			 
@ LI,90  PSAY "Filial :" + AllTrim(SRA->RA_FILIAL) 	 //" Local : "  
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY  "|"
@ LI,02 PSAY STR0168 + Space(1) + AllTrim(DESC_END) + " - " + AllTrim(DESC_COMP) + " - " + AllTrim(DESC_EST) + " - " + AllTrim(DESC_CID)
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY  "|"
@ LI,02  PSAY STR0001 + Space(1) + ":"  + Space(1) + SRA->RA_MAT //"| Matricula : "  
@ LI,33  PSAY "-"
@ LI,39  PSAY STR0003 + Space(7) + ":" + Space(1) + SRA->RA_NOME	//"Nome  : "
@ LI,87  PSAY "-"
@ LI,90  PSAY STR0170 +  ' ' + cProcesso
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Fecha Nacimiento : " +  Substr(Dtos(SRA->RA_NASC),7,2) + "/" + Substr(Dtos(SRA->RA_NASC),5,2) + "/" + Substr(Dtos(SRA->RA_NASC),1,4) //+  DtoS(SRA->RA_NASC)
@ LI,33  PSAY "-"
@ LI,39  PSAY "Fecha Ingresso   : "  + Substr(Dtos(SRA->RA_ADMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_ADMISSA),1,4)//+  Dtos(SRA->RA_ADMISSA) 
@ LI,87  PSAY "-"
@ LI,90  PSAY "Fecha Cese: "  + Substr(Dtos(SRA->RA_DEMISSA),7,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),5,2)+"/"+Substr(Dtos(SRA->RA_DEMISSA),1,4)//+  Dtos(SRA->RA_DEMISSA) 			
@ LI,131  PSAY "|"  

LI ++
@ LI,00  PSAY "|"

If cPaisLoc == "PER"
	@ LI,02  PSAY "C.U.S.P.P. : "   +  SRA->RA_CUSPP
Else
	@ LI,02  PSAY "C.U.S.P.P. : "   
EndIf

@ LI,33  PSAY "-"
@ LI,39  PSAY "Tipo/Cat trab   : "  + Substr(cTpEmprega,1,15)
@ LI,87  PSAY "-"
@ LI,90  PSAY "DNI     : "   +  SRA->RA_RG
@ LI,131  PSAY "|"  

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY  "Per. Vac.:"  + Substr(Dtos(dDataPerAd),7,2) + "/" + Substr(Dtos(dDataPerAd),5,2) + "/" + Substr(Dtos(dDataPerAd),1,4) + "-" + Substr(Dtos(dDataPerAt),7,2) + "/" + Substr(Dtos(dDataPerAt),5,2) + "/" + Substr(Dtos(dDataPerAt),1,4)
@ LI,33  PSAY "-"
@ LI,39  PSAY "Inicio Vac.: " + Substr(Dtos(dDataIniF),7,2) + "/" + Substr(Dtos(dDataIniF),5,2) + "/" + Substr(Dtos(dDataIniF),1,4)
@ LI,87  PSAY "-"
@ LI,90  PSAY "Fim Vac.   : " + Substr(Dtos(dDAtaFimF),7,2) + "/" + Substr(Dtos(dDAtaFimF),5,2) + "/" + Substr(Dtos(dDAtaFimF),1,4)
@ LI,131  PSAY "|"  

LI ++
@ LI,00  PSAY "|"     

If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
	@ LI,02  PSAY "Cod.  AFP: "   + AllTrim(SRA->RA_CODAFP)
Else
	@ LI,02  PSAY "Cod.  AFP: " 
EndIf

@ LI,33  PSAY "-"
@ LI,39  PSAY "Desc. AFP: " +  cDescAfp
@ LI,87  PSAY "-"
@ LI,90  PSAY STR0169 +  AllTrim(STR(SRA->RA_HRSMES))		//"| Horas Mensais : "
@ LI,131  PSAY "|"  

LI ++
@ LI,00  PSAY "|"
@ LI,02  PSAY "Dias Lab: "   + AllTrim(Str(nDiastb)) 
@ LI,33  PSAY "-"
@ LI,39  PSAY "Dias Subs: " + AllTrim(Str(nDiasAfs))
@ LI,87  PSAY "-"
@ LI,90  PSAY "Dias No Lab: "  + AllTrim(Str(nDiasAfas))
@ LI,131  PSAY "|"  

LI ++
@ LI,00  PSAY "|"                                   
@ LI,02  PSAY "N. Hrs Ord: "   + AllTrim(Str(nHorOrd)) 
@ LI,33  PSAY "-"
@ LI,39  PSAY "N. Hrs Ext: " + AllTrim(Str(nHorExt))
@ LI,87  PSAY "-"
@ LI,90  PSAY "Rem. Basica:  "  + AllTrim(Transform((SRA->RA_SALARIO), cPict1))
@ LI,131  PSAY "|"  


LI ++            
@ LI,00  PSAY "|"  
@ LI,02  PSAY "Cod.Ubigeo:" + Space(1) + AllTrim(SRA->RA_CEP)
@ LI,33  PSAY "-"
@ LI,39  PSAY STR0069 + "  :" + Space(1) + cDescUbigeo
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY STR0020 + SRA->RA_CC + Space(9) + " - "+ Space(4) + STR0069 + "  :" + Space(1) + DescCc(SRA->RA_CC,SRA->RA_FILIAL)	//"| C Custo   : " "Desc. CC.:
@ LI,131 PSAY "|"

LI++
@ LI,00  PSAY STR0026+cCodFunc + Space(12) + " - "+ Space(4) + STR0069 + "  :" + Space(1) + cDescFunc											//"| Funcao    : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0027		//"| P R O V E N T O S "
@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
@ LI,088 PSAY STR0029		//"  B A S E S"   
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fRDescUbig �Autor  �Alceu Pereira       � Data �  09/02/10   ���
��������������������������������������������������������������������������͹��
���Desc.     �Exibir descricao do Ubigeo contido na tabela auxiliar para   ���
���          �localizacao Peru.                                            ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function fRDescUbig()

Local nAux:= 1       
Local cDescUbigeo := STR0020
Local aTabUbiGeo := {}
    
fCarrTab( @aTabUbiGeo, "S022", Nil)
    
IF ( len(aTabUbiGeo) >= 1 )
    nAux := 1
	While ( nAux <= len(aTabUbiGeo) )               
        If ( aTabUbiGeo[nAux,1] == "S022" .And. aTabUbiGeo[nAux,5] == SubStr(SRA->RA_CEP,1,2) .And. aTabUbiGeo[nAux,6] == SubStr(SRA->RA_CEP,3,2) .And. aTabUbiGeo[nAux,7] == SubStr(SRA->RA_CEP,5,2) )
    		cDescUbigeo := aTabUbiGeo[nAux,8]
    		nAux := LEN(aTabUbiGeo)
    	Endif
    	nAux++
    End
Endif

Return cDescUbigeo

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fRTipoEmpre�Autor  �Alceu Pereira       � Data �  15/07/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Exibir descricao do tipo de empregado da tabela S029 para    ���
���          �localizacao Peru.                                            ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function fRTipoEmp()

Local nAux:= 1       
Local cTpEmprega := ""
Local aTabTipoEmp := {}
    
fCarrTab( @aTabTipoEmp, "S029", Nil)
    
IF ( len(aTabTipoEmp) >= 1 )
    nAux := 1    
    
    If cPaisLoc == "PER"
		While ( nAux <= len(aTabTipoEmp) )               
	        If ( aTabTipoEmp[nAux,1] == "S029" .And. aTabTipoEmp[nAux,5] == SRA->RA_TPFUNC )
	    		cTpEmprega := Trim(aTabTipoEmp[nAux,6])
	    		nAux := LEN(aTabTipoEmp)
	    	Endif
	    	nAux++
	    End          
    Else
    	cTpEmprega := " "
    EndIf
Endif

Return cTpEmprega

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fRetFerFunc�Autor  �Alceu Pereira       � Data �  19/07/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Retornar as datas de periodo aquisitivo, data inicio e data  ���
���          �fim das ferias de um funcionario.                            ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function fRetFerFunc(dDataPerAd, dDataPerAt ,dDataIniF , dDAtaFimF)

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()

dbSelectArea("SRH")  
DbSetOrder( 1 )
	If dbSeek( cFil + cMat )
		While !Eof() .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
			If AllTrim(Str(Ano(SRH->RH_DATAINI))) == cAno .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
				dDataPerAd := SRH->RH_DATABAS 
				dDataPerAt := SRH->RH_DBASEAT
				dDataIniF := SRH->RH_DATAINI
				dDAtaFimF := SRH->RH_DATAFIM
				Exit		
			Endif
		dbSkip()
		EndDo
	Endif
RestArea(aArea)   
Return         

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fRTipoEmpre�Autor  �Alceu Pereira       � Data �  19/07/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Exibir descricao do tipo de AFP da tabela S004 para          ���
���          �localizacao Peru.                                            ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function fRDescAFP()
                                         
Local nAux:= 1       
Local cDescAfp := ""
Local aTabDescAFP := {}
    
fCarrTab( @aTabDescAFP, "S004", Nil)
    
IF ( len(aTabDescAFP) >= 1 )
    nAux := 1     
    
    If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
		While ( nAux <= len(aTabDescAFP) )               
	        If ( aTabDescAFP[nAux,1] == "S004" .And. aTabDescAFP[nAux,5] == SRA->RA_CODAFP )
	    		cDescAfp := Trim(aTabDescAFP[nAux,6])
	    		nAux := LEN(aTabDescAFP)
	    	Endif
	    	nAux++
	    End    
    Else
		cDescAfp := ' '    
    EndIf
Endif

Return cDescAfp

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fAfasSub   �Autor  �Alceu Pereira       � Data �  25/07/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Retorna quantidade de dias de afastamentos subsidiados pela  ���
���          �empresa.                                                     ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru.                                  ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function fAfasSub(nDiasAfs) 

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()        

dbSelectArea("SR8")  
DbSetOrder( 1 )
	If dbSeek( cFil + cMat )
		While !Eof() .AND. SR8->R8_FILIAL == cFil .AND. SR8->R8_MAT == cMat
			If cMes >= StrZero(Month(SR8->R8_DATAINI),2) .AND. cMes <= StrZero(Month(SR8->R8_DATAFIM),2) .AND. cAno = StrZero(Year(SR8->R8_DATAFIM),4)
				If SR8->R8_DPAGAR > 0
					nDiasAfs := nDiasAfs + SR8->R8_DPAGAR
				Endif                               
			Endif			
		  dbSkip()
		EndDo
	Endif
RestArea(aArea)

Return nDiasAfs 

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fHorasFunc �Autor  �Alceu Pereira       � Data �  25/07/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Retorna quantidade de horas trabalhadas ou quantidade de     ���
���          �horas extras feitas pelo funcionario.                        ���
��������������������������������������������������������������������������͹��
���Uso       � Generico Localizacao Peru.                                  ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/            
Static Function fHorasFunc(lHorasExtras, nQuantHoras, Semana)

Local aArea	        := GetArea()        
Local cChaveSem     := ""
Local aVerbasLIQ    := {}
Local nAux			:= 0	
Local aPerAberto    := {}
Local aPerFechado   := {}
Local aPerTodos     := {}

If lHorasExtras == .T.

	fRetPerComp( 	cMes		  ,;	// Obrigatorio - Mes para localizar as informacoes
					cAno		  ,;	// Obrigatorio - Ano para localizar as informacoes
					xFilial("RCH"),;	// Opcional - Filial a Pesquisar
							  ,;		// Opcional - Filtro por Processo
				              ,;		// Opcional - Filtro por Roteiro
					@aPerAberto	  ,;	// Por Referencia - Array com os periodos Abertos
					@aPerFechado, ;		// Por Referencia - Array com os periodos Fechados
					@aPerTodos    ;		// Por Referencia - Array com os periodos Abertos e Fechados em Ordem Crescente
					 )
Endif					 

nQuantHoras := 0	   

cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2) 

dbSelectArea( "RCF" )
DbSetOrder( 1 )                                                                     

If RCF->( dbSeek( xFilial("RCF") + cChaveSem,.T.)) .AND. lHorasExtras == .F.
	nQuantHoras := RCF->RCF_HRSTRA + RCF->RCF_HRSDSR
Else
	aVerbasLIQ := RetornaVerbasFunc(SRA->RA_FILIAL, SRA->RA_MAT, ,fGetCalcRot("1"), , aPerAberto, aPerFechado )  
	For nAux:= 1 to len(aVerbasLIQ)
		If (PosSrv(aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_HE")) == "S"
			If PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "1*3"
				nQuantHoras += aVerbasLIQ[nAux,6]
			Elseif PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "2*4"
				nQuantHoras -= aVerbasLIQ[nAux,6]
			Endif
		Endif 
	Next		
Endif

RestArea (aArea)      
Return nQuantHoras


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fTrocaCar      � Autor � Alceu Pereira    � Data �10/12/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Troca carecter da string passada como parametro            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPER030                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fTrocaCar(cTexto) 

Local aAcento:={}
Local aAcSubs:={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""   
Local nTamTxt := Len(cTexto)	
Local nCount  := 0
Local nPos
  
aAcento := 	{	"�","�","�","�","�","�","�","�","�",;
					"�","�","�","�","�","�","�","�","�",;
					"�","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"&"}

aAcSubs := 	{	"C","c","A","A","a","a","a","a","a",;
					"E","e","e","i","o","o","o","o","o",;
					"u","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"E"}

For nCount :=1 TO Len(AllTrim(cTexto))
	cImpCar	:=SubStr(cTexto,nCount,1)
	cAux	:=Space(01)  
    nPos 	:= 0
	nPos 	:= Ascan(aAcento,cImpCar)
	If nPos > 0
		cAux := aAcSubs[nPos]
	Elseif (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0
		cAux :=	""
	EndIf		
    cAux1 	:= 	cAux
	cImpCar	:=	cAux
	cImpLin	:=	cImpLin+cImpCar

Next nCount

cImpLin := Left(cImpLin+Space(nTamTxt),nTamTxt)

Return cImpLin  

/************Impress�o PDF**********************************************************************************************/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImprPDF  � Autor � R.H. - Emerson Cmapos � Data �30/06/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO EM PDF                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImprPDF()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImprPDF(lPDFEmail,cPath)
Local nConta 		:= 0
Local cFile		:= ""
Local cEmail		:= ""
Local cIdentUni	:= ""

//Gerar o PDF na Tela
If ! lPDFEmail .AND. Empty(oPrinter)
	oPrinter	:= FWMSPrinter():New("GPER030"  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lViewPDF 	:= .T.
EndIf

//Gerar o PDF no Servidor para enviar via email
If lPDFEmail
	cIdentUni	:= DtoS(date())+SUBSTR(TIME()	, 1, 2) +SUBSTR(TIME(), 4, 2) +SUBSTR(TIME(), 7, 2)+AllTrim(Str(Int(Seconds()))) 
	cFile		:= SRA->RA_FILIAL+SRA->RA_MAT+dtos(dDataRef)+cIdentUni+"RecPag"  
	oPrinter	:= FWMSPrinter():New(cFile  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lInJob 		:= .T.
	cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"")
	If Empty(cEmail) 
		If Empty(aTitle)
			Aadd( aTitle, OemToAnsi(STR0209) ) //"LOG das matr�culas que n�o foram enviadas"
			Aadd( aLog,{} )
			Aadd( aLog, { PADR( OemToAnsi(STR0212), FWGETTAMFILIAL) + " - " + PADR( OemToAnsi(STR0001), 10 ) + " - " + PADR( OemToAnsi(STR0003), 45 ) + " - " + OemToAnsi(STR0210) } ) //"Filial"#"Matr�cula"#"Nome"#"Ocorr�ncia"
		EndIf
		Aadd( aLog, { PADR( SRA->RA_FILIAL, FWGETTAMFILIAL) + " - " + PADR( SRA->RA_MAT, 10) + " - " + PADR( SRA->RA_NOME, 45) + " - " + OemToAnsi(STR0211) } ) //"Sem e-mail cadastrado e/ou nao recebe e-mail (verif. campos: RA_EMAIL/RA_RECMAIL)"
		Return()
	Else
		aAdd(aEmail, {{SRA->RA_NOME, cEmail,If(SRA->RA_RECMAIL=="S",.T.,.F.)},SRA->RA_FILIAL,SRA->RA_MAT,dtos(dDataRef),cIdentUni})	
    EndIf
EndIf

oPrinter:lServer 			:= .T.
oPrinter:SetResolution(75)
oPrinter:SetPortrait() //SetLandscape() // 
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(60,60,60,60)
oPrinter:nDevice 			:= IMP_PDF
oPrinter:StartPage()

If li >= 60
	li := 0
Endif
//Cabe�alho
fCabPDF(oPrinter)
//Corpo
fLancPDF(oPrinter, nConta)

If lPDFEmail
	oPrinter:Preview()
	oPrinter:EndPage()
	//oPrinter:Print()                                                           
	FreeObj(oPrinter)
	oPrinter := Nil
Else
	oPrinter:EndPage()
EndIF

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabPDF   � Autor � R.H. - Emerson Campos � Data �30/06/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabecalho em PDF                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabPDF()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabPDF(oPrinter)
Local cCodFunc	:= ""		//-- Codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario
Local cDescCC		:= ""		//-- Descricao do Centro de Custo
Local nLi			:= 0
Local _cCPF
/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

nLi += 10
oPrinter:Box(  nLi, 004, nLi+20, 585, "-4" )			// Caixa da linha 
nLi += 10
oPrinter:SayAlign(nLi-8,004," RECIBO DE PAGAMENTO - RPA ",oFont4,585,005, /**/, 2, 1 ) //"RECIBO DE PAGAMENTO  "
nLi += 10
oPrinter:Box(  nLi+5, 004, nLi+65, 585, "-4" )			// Caixa da linha
nLi += 20
oPrinter:Say(nLi,004,Space(3)+Substr(STR0018, 3) +  DESC_Fil,oFont2N)	//"| Empresa   : "

If cPaisLoc == "BRA"
	oPrinter:Say(nLi,450,STR0099+ " " + Desc_CGC,oFont2N)	//"CNPJ  : "
Else
	oPrinter:Say(nLi,450,AllTrim(RetTitle("A1_CGC")) + ": " + Desc_CGC,oFont2N)	//"CNPJ  : "
EndIf

nLi += 10
cDescCC := If( lLpt1, fTAcento(DescCc(SRA->RA_CC,SRA->RA_FILIAL)), DescCc(SRA->RA_CC,SRA->RA_FILIAL) )
oPrinter:Say(nLi, 004,Space(3)+Substr(STR0020, 3) + SRA->RA_CC + " - " + cDescCC,oFont2N)	//"| C Custo   : "

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	oPrinter:Say(nLi, 450,STR0021 + Semana + " (" + cSem_De + STR0022 + cSem_Ate + ")",oFont2N)	//'Sem.'###' a '
Else
	oPrinter:Say(nLi, 450,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4),oFont2N)
EndIf

nLi += 10
oPrinter:Say(nLi,000,Space(3)+" Bispo/Pastor(a): " + SRA->RA_NOME,oFont2N)	//"| Bispo/Pastor(a): "
//oPrinter:Say(nLi,004,Space(3)+Substr(STR0023,3) + SRA->RA_MAT + "   " + STR0024 + If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME ),oFont2N)	//"| Matricula : " XXXXX +"   " + Nome  : " XXXXXXXXXXXXXXX
oPrinter:Say(nLi,447,STR0019 + SRA->RA_FILIAL,oFont2N)	//" Local : "

_cCPF := SRA-> RA_CIC
_cCPF := TRANSFORM (_cCPF, "@R 999.999.999-99")

oPrinter:Say(nLi +10,004, Space(2)+" CPF: " + _cCPF,oFont2N)	//" CBO : "

nLi += 10
//oPrinter:Say(nLi,004,Space(3)+" Bispo/Pastor(a): "+cCodFunc+" - "+If( lLpt1, fTAcento(cDescFunc), cDescFunc ),oFont2N)	//"| Funcao    : "
If !Empty(SRA->RA_DEPTO)
	oPrinter:Say(nLi,240,STR0177 + ": " + SRA->RA_DEPTO + " - " + fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC'),oFont2N)	//-9caracteres+30caracteres
EndIf
//oPrinter:Say(nLi,448,STR0019 + SRA->RA_FILIAL,oFont2N)	//" Local : "
ORDEMZ ++
oPrinter:Say(nLi,447,space(1)+ STR0025,oFont2N)	//"Ordem : "
oPrinter:Say(nLi,500,Alltrim(StrZero(ORDEMZ,4)),oFont2N)
nLi += 10

oPrinter:Say(nLi,004,Space(2) + " Prebenda: "  + "  " + Alltrim(Transform(nSalario,cPict2)),oFont2N)	//Prebenda
//oPrinter:Say(nLi,447, STR0214 + fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef),oFont2N)	//" CBO : "


nLi += 10

oPrinter:Box(  nLi, 004, nLi+23, 585, "-4" )			// Caixa da linha 
nLi += 15
oPrinter:Say(nLi,004,"   "+Substr(STR0027, 3),oFont3)	//"| P R O V E N T O S "
oPrinter:Say(nLi,195,STR0028,oFont3)	//"  D E S C O N T O S"
oPrinter:Say(nLi,390,STR0029,oFont3)	//"  B A S E S"
nLi += 05
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancPDF  � Autor � R.H. - Emerson Campos � Data �01/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) PDF                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancPDF()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancPDF(oPrinter, nConta)   // Impressao dos Lancamentos

Local nTermina  	:= 0
Local nCont    	:= 0
Local nCont1   	:= 0
Local nValidos  	:= 0
Local aPos     	:= {}
Local nSpace    	:= 0
Local cMsgAniv  	:= ""
Local nPosFCab	:= 114 //Posi��o final do cabe�alho fCabPDF()
Local nLi			:= nPosFCab

	If ( Ascan(aProve , {|aProve| aProve[3] >= 1000000} ) > 0 ) 
	  cPict3 := "@E 9999,999.99" // Variavel private criada na funcao R030Imp
	  aPos := {004,006,193,195,388,390,585}
	  nSpace := 1
	Else  
	  cPict3 := "@E 999,999.99"
	  aPos := {004,006,195,197,390,392,585}  
	EndIf
	
	nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))
	
	oPrinter:Box(  nLi+5, aPos[1], nLi+520, aPos[7], "-4" )
	oPrinter:Box(  nLi+5, aPos[3], nLi+520, aPos[5], "-4" )
	
	For nCont := 1 To nTermina
		
		//Quebrar pagina
		// somente imprime CONTINUA e quebra o recibo em dois se houver mais verbas a serem impressas
		If nValidos == 50 .and. nTermina > nValidos
			nLi += 20
			oPrinter:Box(  nLi+5, aPos[1], nLi+40, aPos[7], "-4" )
			nLi += 20		
			oPrinter:SayAlign(nLi-5,aPos[1],STR0030,oFont3,aPos[7],005, /**/, ALIGN_H_CENTER, ALIGN_V_CENTER ) // "CONTINUA !!!"
			nLi += 20
			
			oPrinter:EndPage()
			oPrinter:StartPage()
			
			fCabPDF(oPrinter)
			
			nValidos := 0
			
			If nLi >= 614
				nLi := nPosFCab   //Posi��o final do cabe�alho fCabPDF()
			Endif	
			
			oPrinter:Box(  nLi+5, aPos[1], nLi+520, aPos[7], "-4" )
			oPrinter:Box(  nLi+5, aPos[3], nLi+520, aPos[5], "-4" )
					
		EndIf
	 
	 	nLi += 10	
		//Imprime Proventos
		IF nCont <= LEN(aProve)	
			oPrinter:SayAlign(nLi,aPos[2],aProve[nCont,1],oFont1,195,005,,ALIGN_H_LEFT)  
 			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)  
			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,3] , cPict3 ),oFont1,189,005,,ALIGN_H_RIGHT)  
		ENDIF
		//Imprime Descontos
		IF nCont <= LEN(aDesco)
			oPrinter:SayAlign(nLi,aPos[4],aDesco[nCont,1],oFont1,390,005,,ALIGN_H_LEFT)
			oPrinter:SayAlign(nLi,aPos[4],TRANSFORM(aDesco[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)
			oPrinter:SayAlign(nLi,aPos[4],TRANSFORM(aDesco[nCont,3] , cPict3 ),oFont1,192,005,,ALIGN_H_RIGHT)
		ENDIF
		//Imprime Base
		IF nCont <= LEN(aBases)
			If cBaseAux = "S" 
				oPrinter:SayAlign(nLi,aPos[6],aBases[nCont,1],oFont1,390,005,,ALIGN_H_LEFT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,3] , cPict3 ),oFont1,192,005,,ALIGN_H_RIGHT)
			EndIf
		ENDIF	
		
		//---- Soma 1 nos nValidos e Linha
		nValidos ++	
	Next nCont
	
	//Quando o total de verbas n�o atinge o total m�ximo, seta nlin para come�ar o cabe�alho.
	nLi	+= (52 - nValidos) * 10
	
	oPrinter:Box(  nLi+5, aPos[1], nLi+65, aPos[3], "-4" )
	
	oPrinter:SayAlign(nLi+8,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 ),oFont1,196,005, , 0, 1 )   //Mensagem
	oPrinter:SayAlign(nLi+23,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 ),oFont1,196,005, , 0, 1 )   //Mensagem
	oPrinter:SayAlign(nLi+38,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG3), DESC_MSG3 ),oFont1,196,005, , 0, 1 )   //Mensagem
	
	cMsgAniv := " 	                                     "	
	IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
		cMsgAniv := Space(2)+STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
	ENDIF
	
	oPrinter:SayAlign(nLi+53,005,Space(2)+cMsgAniv,oFont1,196,005, , 0, 1 )	
	
	oPrinter:Box(  nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER(STR0065),oFont2N,196,005, , 0, 1 )   //"| TOTAL BRUTO    "
	oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER(STR0066),oFont2N,196,005, , 0, 1 )     //" TOTAL DESCONTOS     "
	oPrinter:SayAlign(nLi-10,aPos[4],TRANSFORM( TOTVENC , cPict3 )+ Space(2),oFont2,196,005, , 1, 1 )   //"| TOTAL BRUTO    "
	oPrinter:SayAlign(nLi-10,aPos[6],TRANSFORM(TOTDESC , cPict3)+ Space(2),oFont2,196,005, , 1, 1 )     //" TOTAL DESCONTOS     "
	
	oPrinter:Box(  nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+Substr(STR0033,3)+ Space(2) + AllTrim(SRA->RA_BCDEPSA)+" - "+substr(DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,25),oFont2,196,005, , 0, 1 )  	//"| CREDITO:"
	oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER(STR0055)+":",oFont2N,196,005, , 0, 1 )   //"| LIQUIDO A RECEBER     "
	oPrinter:SayAlign(nLi-10,aPos[6],TRANSFORM((TOTVENC-TOTDESC) , cPict3 )+ Space(2),oFont2,196,005, , 1, 1 )   //"| LIQUIDO A RECEBER     "
	
	oPrinter:Box(  nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER(STR0040)+ Space(2)+SRA->RA_CTDEPSA,oFont2,196,005, , 0, 1 )   //"| CONTA:"
		
	oPrinter:Box(  nLi+5, aPos[1], nLi+50, aPos[7], "-4" )
	nLi += 40
	oPrinter:SayAlign(nLi-25,005," Recebi da institui��o acima identificada, pelo exerc�cio de ministro religioso a import�ncia de: R$ "+ Alltrim(TRANSFORM((TOTVENC-TOTDESC) , cPict3 )) ,oFont2N,585,005, , ALIGN_H_LEFT, 1 )
	oPrinter:SayAlign(nLi-5 ,005," Na data de ____/____/_____     __________________________________ ",oFont2N,585,005, , ALIGN_H_LEFT, 1)
		
	oPrinter:EndPage()
	
	cPict3 := "@E 999,999.99"  // Restauro o valor original de cPict3, declarado na funcao R030Imp.
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � fEnvPDFEmail� Autor � Emerson Campos     � Data �09/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descricao � Prepara o envio do email com o PDF Anexado                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fEnvPDFEmail(cPath)
Local nI			:= 0
Local cSubject	:= STR0196		//" Demosntrativo de Pagamento "
Local cMsg			:= ""
Local cPathFile	:= "" 
Local cMsgErr1	:= ""	//Erro envio
Local cMsgErr2	:= ""	//Sem email cadastrado
Local cMsgErr3	:= ""	//Op��o n�o envia email habilitada

Private cEmailDP		:= NIL
Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL
	
	// Busca parametros 
	cMailConta		:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha		:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	cEmailDP		:=If(cEmailDP == NIL,GETMV("MV_GPEMAIL"),cEmailDP)					//Email do respons�vel de Depto Pessoal
	
	// Verifica se existe o SMTP Server 
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	For nI := 1 To Len(aEmail)
		cPathFile	:= cPath+aEmail[nI,2]+aEmail[nI,3]+aEmail[nI,4]+aEmail[nI,5]+"RecPag"

		If aEmail[nI,1,3]
			If ! Empty(AllTrim(aEmail[nI,1,2]))
				cSubject	:= STR0196 + " - " + MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)
				
				cMsg := STR0193+chr(13)+ "  " + aEmail[nI,1,1]+","+chr(10)	//"Sr.(a)"  
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += STR0194+" "+MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)+chr(13)+chr(10) //"Segue em anexo o seu demonstrativo referente a:" Maio/2015
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += STR0195+chr(13)+chr(10)  //"Atenciosamente,"				
				
				// Envia e-mail p/funcionario 
				If !GPEMail(cSubject,cMsg,aEmail[nI,1,2],{cPathFile+".pdf"})
					//Falha no envio
					cMsgErr1	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
				Else
					lEnvioOK := .T.
				EndIf				
			Else
				//Sem Email cadastrado
				cMsgErr2	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
			EndIf
		Else
			//Marcado para n�o receber o email
			cMsgErr3	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
		EndIf
		
		If File(cPathFile+".pdf")
			fErase(cPathFile+".pdf")
		EndIf
		
		If File(cPathFile+".rel")
			fErase(cPathFile+".rel")
		EndIf
	Next nI
	
	If ! Empty(cEmailDP)
		If ! Empty(cMsgErr1) .OR. ! Empty(cMsgErr2)  .OR. ! Empty(cMsgErr2)
			cSubject	:= STR0201 //"Erros ocorridos durante o envio dos demonstrativos de pagamento"	
			cMsg := STR0193+"," + chr(13) + chr(10)	//"Sr.(a)"  
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			cMsg += STR0197 + chr(13) + chr(10) //"Ocorreram alguns erros durante o envio de demonstrativo de pagamento por email, veja a rela��o abaixo:
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			If ! Empty(cMsgErr1)
				cMsg += "- "+ STR0198 +chr(13)+chr(10)	//- Erro durante o envio da mensagem				
				cMsg += cMsgErr1 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr2)
				cMsg += "- "+ STR0199 +chr(13)+chr(10)	//- Falta de endere�o de email cadastrado para o envio:
				cMsg += cMsgErr2 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr3)
				cMsg += "- "+ STR0200 +chr(13)+chr(10)	//- Marcado a op��o de n�o receber email no caastro do funcion�rio:
				cMsg += cMsgErr3 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			cMsg += STR0195+chr(13)+chr(10)  //"Atenciosamente,"
			
			GPEMail(cSubject,cMsg,cEmailDP)
		EndIf
	EndIf 
Return Nil 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � Scheddef    � Autor � Emerson Campos     � Data �08/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descricao � Trazer o grupo de perguntas GPER030 quando houver schedule ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function SchedDef() 
	Local aParam
	Local aOrd     := {OemToAnsi(" Matr�cula         ")}
	aParam := { "R",;      // Tipo R para relatorio P para processo   
				"GPER030",;	// Pergunte do relatorio, caso nao use passar ParamDef            
				"",;  	// Alias            
   				aOrd,;   	// Array de ordens   
				""}	
				  
Return aParam  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � limpArqPdf  � Autor � Emerson Campos     � Data �08/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descricao � Limpar os arquivos PDF que s�o gerados pelo schedule       ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function limpArqPdf()
Local cPath	:= supergetmv("MV_RELT",,"\spool\")
	AEVAL(DIRECTORY(cPath+"*RecPag.pdf"), { |aFile| FERASE(cPath+aFile[1]) })	
Return

/*/
�������������������������������������������������������������������������
�����������������������������������������������������������������������Ŀ
�Fun��o    �fCabecZDom� Autor � Jonathan Gonzalez     � Data �21.07.2016�
�����������������������������������������������������������������������Ĵ
�Descri��o � IMRESSAO Cabe�alho Form ZEBRADO                            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   � fCabecZDom()                                               �
�����������������������������������������������������������������������Ĵ
� Uso      � Generico                                                   �
�������������������������������������������������������������������������
�������������������������������������������������������������������������
/*/
Static Function fCabecZDom()   // Cabecalho do Recibo Zebrado
	Local aArea     := GetArea()
	Local cCodFunc  := "" //-- codigo da Funcao do funcionario
	Local cDescFunc := "" //-- Descricao da Funcao do Funcionario
	Local cCargo    := "" //-- Codigo Cargo
	Local cDescCar  := "" //-- Descripcion Cargo.
	Local cFechaPer := DTOC(Posicione("RCH", 1 , xfilial("RCH")+cProcesso+cPeriodo+cSemana+cRoteiro , "RCH_DTINI")) +;
	                    " - " + DTOC(Posicione("RCH", 1 , xfilial("RCH")+cProcesso+cPeriodo+cSemana+cRoteiro , "RCH_DTFIM"))

		/* � Carrega Funcao do Funcion. de acordo com a Dt Referencia     � */
		fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
		@ Li,00 PSAY Avalimp(Limite)
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

		LI ++
		@ LI,00  PSAY  "|"
		@ LI,46  PSAY STR0017		//"RECIBO DE PAGAMENTO  "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

		LI ++
		@ LI,00  PSAY STR0018 +  DESC_Fil		//"| Empresa   : "
		@ LI,92  PSAY STR0019 + SRA->RA_FILIAL	//" Local : "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY STR0117 +" "+ cProcesso + SPACE(5) + STR0118 + cRoteiro +; //"| Proceso  :" ###  "Proced.: " ####
		             SPACE(5) + STR0119 + cPeriodo + SPACE(5) + STR0120 + Semana + SPACE(5) + STR0204 + cFechaPer //"Periodo: " ### "No Pago:  " ## "Fecha de pago del "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00  PSAY STR0020 + ALLTRIM(SRA->RA_CC) + " - " + ALLTRIM(DescCc(SRA->RA_CC,SRA->RA_FILIAL)) //"| C Custo   : "
		@ LI,60  PSAY STR0132 + IIF(!Empty(SRA->RA_DEPTO),ALLTRIM(SRA->RA_DEPTO) + " - " + ALLTRIM(fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')),UPPER(STR0206)) 	//"DPTO.: "
		@ LI,131 PSAY "|"

		LI ++
		ORDEMZ ++
		@ LI,00  PSAY STR0023 + SRA->RA_MAT		//"| Matricula : "
		@ LI,30  PSAY STR0024 + If( !Empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME ) + "  " + STR0025 + StrZero(ORDEMZ,4)	//"Nome  : "  ### "Ordem : "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00  PSAY STR0026+cCodFunc+" - "+cDescFunc											//"| Funcao    : "
		cCargo := fGetCargo(SRA->RA_MAT)
		cDescCar := Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,10)
		@ LI,60  PSAY STR0123 + " " + IIF(!Empty(cCargo),ALLTRIM(cCargo) + " - " + ALLTRIM( cDescCar ),UPPER(STR0206))  //"Cargo:"
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

		LI ++
		@ LI,000 PSAY STR0027		//"| P R O V E N T O S "
		@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
		@ LI,088 PSAY STR0029		//"  B A S E S"
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI++

	RestArea( aArea )
Return Nil
