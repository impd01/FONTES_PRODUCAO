#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#define CMD_OPENWORKBOOK		1
#define CMD_CLOSEWORKBOOK		2   
#define CMD_ACTIVEWORKSHEET		3    
#define CMD_READCELL			4
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � SendMail � Fun��o para envio de e-mail                                  ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 25.08.18 �Murilo Santos                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: e-mail do destinat�rio                                           ���
���             � ExpC2: e-mail da c�pia                                                  ���
���             � ExpC3: assunto do e-mail                                                ���
���             � ExpC4: texto do e-mail                                                  ���
���             � ExpC5: anexos do e-mail                                                 ���
���             � ExpL1: exibe mensagem de envio                                          ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL2: .T. - envio realizado                                            ���
���             �        .F. - n�o enviado                                                ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function ZSendMail(cMailDestino,cMailCopia,cAssunto,cTexto,cAnexos,lMensagem)

Local lRet	:= .T.

Private cMailServer		:= GetMv("MV_RElSERV")
Private cMailConta		:= GetMv("MV_RELACNT")
Private cMailSenha		:= GetMv("MV_RELPSW")
Private cMailDestino	:= If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
Private lMensagem		:= If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

// Efetua valida��es 
If Empty(cMailDestino)
	If lMensagem
		Aviso(	cCadastro,;
				"Conta(s) de e-mail de destino(s) n�o informada. Envio n�o ser� realizado.",;
				{"&Ok"},,;
				"Conta de e-mail" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cAssunto)
	If lMensagem
		Aviso(	cCadastro,;
				"Assunto do e-mail n�o informado. Envio n�o ser� realizado.",;                                       	
				{"&Ok"},,;
				"Assunto de e-mail" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cTexto)
	If lMensagem
		Aviso(	cCadastro,;
				"Texto do e-mail n�o informado. Envio n�o ser� realizado.",;
				{"&Ok"},,;
				"Texto de e-mail" )
	EndIf
	lRet	:= .F.
EndIf

If lRet
	If lMensagem
		Processa({|| lRet := SendMail2(cMailDestino,cMailCopia,cAssunto,cTexto,cAnexos,lMensagem)}, "Envio de E-Mail", "Preparando e-mail para envio")
	Else
		lRet := SendMail2(cMailDestino,cMailCopia,cAssunto,cTexto,cAnexos,lMensagem)
	EndIf
EndIf

Return(lRet)
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � SendMail2� Fun��o complementar para envio do e-mail                     ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 25.08.18 �Murilo Santos                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: e-mail do destinat�rio                                           ���
���             � ExpC2: e-mail da copia                                                  ���
���             � ExpC3: assunto do e-mail                                                ���
���             � ExpC4: texto do e-mail                                                  ���
���             � ExpC5: anexos do e-mail                                                 ���
���             � ExpL1: exibe mensagem de envio                                          ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL2: .T. - envio realizado                                            ���
���             �        .F. - n�o enviado                                                ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function SendMail2(cMailDestino,cMailCopia,cAssunto,cTexto,cAnexos,lMensagem)

Local lConexao			:= .F.
Local lEnvio			:= .F.
Local lDesconexao		:= .F.
Local lRet				:= .F.
Local cAssunto			:= If( ValType(cAssunto) != "U" , cAssunto , "" )
Local cTexto			:= If( ValType(cTexto)   != "U" , cTexto   , "" )
Local cAnexos			:= If( ValType(cAnexos)  != "U" , cAnexos  , "" )
Local cErro_Conexao		:= ""
Local cErro_Envio		:= ""
Local cErro_Desconexao	:= ""
Local cCadastro			:= "Envio de e-mail"
Local lSmtpAuth			:= GetMv("MV_RELAUTH",,.F.)

If lMensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//������������������������������������������������������Ŀ
//� Executa conexao ao servidor mencionado no parametro. �
//��������������������������������������������������������
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT 60 RESULT lConexao

//����������������������������������������������������������������������������������Ŀ
//| Se configurado, efetua a autenticacao                                            |
//������������������������������������������������������������������������������������
If ( lSmtpAuth ) 
	lAutOk := MailAuth(Alltrim(GetMv("MV_RELACNT")),Alltrim(GetMv("MV_RELAPSW")))
Else
	lAutOk := .T.
EndIf 

If !lConexao
	GET MAIL ERROR cErro_Conexao
	If lMensagem
 		Aviso(	cCadastro,;
 				"Nao foi poss�vel estabelecer conex�o com o servidor - "+cErro_Conexao,;
 				{"&Ok"},,;
 				"Sem Conex�o" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
	IncProc("Enviando e-mail, Aguarde...")
EndIf

//����������������������������Ŀ
//� Executa envio da mensagem. �
//������������������������������
If !Empty(cAnexos)
	If !Empty(cMailCopia)
		Send Mail From cMAILCONTA to cMAILDESTINO CC cMailCopia SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO
	Else
		Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO
	EndIf
Else
	If !Empty(cMailCopia)
		Send Mail From cMAILCONTA to cMAILDESTINO CC cMailCopia SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO
	Else
		Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO
	EndIf
EndIf

If !lEnvio
	Get Mail Error cErro_Envio
	If lMensagem
		Aviso(	cCadastro,;
				"N�o foi poss�vel enviar a mensagem - "+cErro_Envio,;
				{"&Ok"},,;
				"Falha no envio" )
	EndIf
	lRet := .F.
Else
	If lMensagem
		Aviso(	cCadastro,;
				"O e-mail foi enviado com sucesso.",;
				{"&Ok"},,;
				"Envio com Sucesso" )
	EndIf
	lRet := lEnvio	//#MM20130819.n
EndIf

If lMensagem
   IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//��������������������������������������Ŀ
//� Executa disconexao ao servidor SMTP. �
//����������������������������������������
DisConnect Smtp Server Result lDesconexao

If !lDesconexao
	Get Mail Error cErro_Desconexao
	If lMensagem
		Aviso(	cCadastro,;
				"N�o foi poss�vel desconectar-se do servidor - "+cErro_Desconexao,;
				{"&Ok"},,;
				"Descone��o" )
	EndIf
	lRet := .F.
EndIf

Return(lRet)