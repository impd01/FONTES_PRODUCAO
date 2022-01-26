#Include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'
#include 'FileIo.ch'

/*/
�����������������������������������������������������������������������������
���Programa  �mt010inc  �Autor�Felipe Barros         � Data � 07/10/2020  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua o disparo de email para os emails na vari�vel __cTo ���
���          � sempre  que for inclu�do um novo Produto.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA010                                                    ���
�����������������������������������������������������������������������������
/*/

User Function MT010INC()
    
   //Local lExecuta := .T.// Valida��es do usu�rio para inclus�o de fornecedorReturn (lExecuta)
    
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
   
	_cTo		:= "felipe.silva@impd.org.br, rafael.albuquerque@impd.org.br, endrew.nunes@impd.org.br, conciliacao@impd.org.br"	//Destinat�rios da notifica��o

    _cString	:= ""
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Voc� esta recebendo uma mensagem autom�tica da rotina de inclus�o de Produtos do sistema Protheus: </span> </p>"
	_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Cod: <b>" + cCodProd + "</b> 
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Descri��o: <b>" + cDescProd + " </b>  </span> </p>"
    _cString 	+= "</br>"
    _cString 	+= "</br>"
    _cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'> Obs.: Este email n�o dever� ser respondido.</p> "

	U_ZSendMail(_cTo ,_cCopia   ,_cAssunto,_cString  ,  ,_lExibeMsg)

Return()
