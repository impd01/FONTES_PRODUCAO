#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'
#include 'FileIo.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºmt010inc  ºAutorºFelipe Barros         º Data º 07/10/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     º Efetua o disparo de email para os emails na variável __cTo º±±
±±º          º sempre  que for incluído um novo Produto.                  º±±
±±º          º                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       º MATA010                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT010INC()
    
   //Local lExecuta := .T.// Validações do usuário para inclusão de fornecedorReturn (lExecuta)
    
	Local _cString	:= ""
	Local _cAssunto := "Produto adicionado"
	Local _cTo		:= ""
	Local _cCopia	:= ""
	Local _lExibeMsg:= .T.	

	Local cDescProd 	
	Local cCodProd	
    Local cTipoProd      

	cDescProd := SB1->B1_DESC
	cCodProd  := SB1->B1_COD
    cTipoProd := SB1->B1_TIPO
   
	_cTo		:= "felipe.silva@impd.org.br, rafael.albuquerque@impd.org.br, endrew.nunes@impd.org.br, conciliacao@impd.org.br"	//Destinatários da notificação

    _cString	:= ""
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Você esta recebendo uma mensagem automática da rotina de inclusão de Produtos do sistema Protheus: </span> </p>"
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Cod: <b>" + cCodProd + "</b> 
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Descrição: <b>" + cDescProd + " </b>  </span> </p>"
    _cString 	+= "</br>"
    _cString 	+= "</br>"
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Obs.: Este email não deverá ser respondido.</p> "

	U_ZSendMail(_cTo ,_cCopia   ,_cAssunto,_cString  ,  ,_lExibeMsg)

Return()
