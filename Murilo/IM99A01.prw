#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#define CMD_OPENWORKBOOK		1
#define CMD_CLOSEWORKBOOK		2   
#define CMD_ACTIVEWORKSHEET		3    
#define CMD_READCELL			4
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ SendMail ณ Fun็ใo para envio de e-mail                                  บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 25.08.18 ณMurilo Santos                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1: e-mail do destinatแrio                                           บฑฑ
ฑฑบ             ณ ExpC2: e-mail da c๓pia                                                  บฑฑ
ฑฑบ             ณ ExpC3: assunto do e-mail                                                บฑฑ
ฑฑบ             ณ ExpC4: texto do e-mail                                                  บฑฑ
ฑฑบ             ณ ExpC5: anexos do e-mail                                                 บฑฑ
ฑฑบ             ณ ExpL1: exibe mensagem de envio                                          บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL2: .T. - envio realizado                                            บฑฑ
ฑฑบ             ณ        .F. - nใo enviado                                                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ZSendMail(cMailDestino,cMailCopia,cAssunto,cTexto,cAnexos,lMensagem)

Local lRet	:= .T.

Private cMailServer		:= GetMv("MV_RElSERV")
Private cMailConta		:= GetMv("MV_RELACNT")
Private cMailSenha		:= GetMv("MV_RELPSW")
Private cMailDestino	:= If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
Private lMensagem		:= If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

// Efetua valida็๕es 
If Empty(cMailDestino)
	If lMensagem
		Aviso(	cCadastro,;
				"Conta(s) de e-mail de destino(s) nใo informada. Envio nใo serแ realizado.",;
				{"&Ok"},,;
				"Conta de e-mail" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cAssunto)
	If lMensagem
		Aviso(	cCadastro,;
				"Assunto do e-mail nใo informado. Envio nใo serแ realizado.",;                                       	
				{"&Ok"},,;
				"Assunto de e-mail" )
	EndIf
	lRet	:= .F.
EndIf

If Empty(cTexto)
	If lMensagem
		Aviso(	cCadastro,;
				"Texto do e-mail nใo informado. Envio nใo serแ realizado.",;
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
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ SendMail2ณ Fun็ใo complementar para envio do e-mail                     บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 25.08.18 ณMurilo Santos                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ ??.??.?? ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1: e-mail do destinatแrio                                           บฑฑ
ฑฑบ             ณ ExpC2: e-mail da copia                                                  บฑฑ
ฑฑบ             ณ ExpC3: assunto do e-mail                                                บฑฑ
ฑฑบ             ณ ExpC4: texto do e-mail                                                  บฑฑ
ฑฑบ             ณ ExpC5: anexos do e-mail                                                 บฑฑ
ฑฑบ             ณ ExpL1: exibe mensagem de envio                                          บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL2: .T. - envio realizado                                            บฑฑ
ฑฑบ             ณ        .F. - nใo enviado                                                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa conexao ao servidor mencionado no parametro. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT 60 RESULT lConexao

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Se configurado, efetua a autenticacao                                            |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ( lSmtpAuth ) 
	lAutOk := MailAuth(Alltrim(GetMv("MV_RELACNT")),Alltrim(GetMv("MV_RELAPSW")))
Else
	lAutOk := .T.
EndIf 

If !lConexao
	GET MAIL ERROR cErro_Conexao
	If lMensagem
 		Aviso(	cCadastro,;
 				"Nao foi possํvel estabelecer conexใo com o servidor - "+cErro_Conexao,;
 				{"&Ok"},,;
 				"Sem Conexใo" )
	EndIf
	lRet := .F.
EndIf

If lMensagem
	IncProc("Enviando e-mail, Aguarde...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa envio da mensagem. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
				"Nใo foi possํvel enviar a mensagem - "+cErro_Envio,;
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa disconexao ao servidor SMTP. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result lDesconexao

If !lDesconexao
	Get Mail Error cErro_Desconexao
	If lMensagem
		Aviso(	cCadastro,;
				"Nใo foi possํvel desconectar-se do servidor - "+cErro_Desconexao,;
				{"&Ok"},,;
				"Descone็ใo" )
	EndIf
	lRet := .F.
EndIf

Return(lRet)