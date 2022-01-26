#INCLUDE "PROTHEUS.CH"   
#INCLUDE "TOTVS.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCN300PCMT  บ Autor ณMurilo Santos       บ Data ณ  25/08/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValida a a็ใo do usuario.								  	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico IMPD.		                                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR      ณ  DATA      ณ MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ   
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ   
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ   
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑณ                  ณ            ณ								          ณฑฑ    
ฑฑศออออออออออออออออออฯออออออออออออฯอออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CN300PCMT(oModel)

Local _lRet := .T.

IF PARAMIXB[1]:noperation == 3 // REAJUSTE
	_lRet := fEnvMail("Reajuste")
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEnvMail  บAutor  ณMurilo Santos - MRC บ Data ณ  14/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail com os produtos listados.           			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ZFISF12                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fEnvMail(cAssunto)

Local _lRet	:= .F.

Local _cString	:= ""
Local _cCor		:= ""
Local _cAssunto := cAssunto
Local _cTo		:= ""
Local _cCopia	:= ""
Local _lExibeMsg:= .T.

Private cAccount	:= GetMV("MV_EMCONTA")
Private cPassword 	:= GetMV("MV_EMSENHA")
Private cServer   	:= GetMV("MV_RELSERV")
Private cEmailde  	:= SuperGetMV("MV_RELFROM",.f.,"murilohsmrc@gmail.com")

_cString	:= ""
_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'>Senhores,</b></span></p>"
_cString 	+= "<p><span style='font-size:12.0pt;font-family:Arial'>Segue abaixo os dados do contrato " +CN9_NUMERO+ " que acabou de ser " + cAssunto + ". </b></span></p>"

_cTo		:= "murilo.santos@mrconsultoria.com.br; endrew.nunes@impd.org.br"//GetMV("IM_PAR999",,"murilo.santos@mrconsultoria.com.br")
	
_cString 	+= "<table border='0' cellpadding='2' cellspacing='1' width='100%'>"
_cString 	+= " <tr>"
_cString 	+= "   <td width='200' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>N๚mero do Contrato</b></font></p>"
_cString 	+= "   </td>"
_cString 	+= "   <td width='300' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Data Inํcio</b></font></p>"
_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Data Fim</b></font></p>"
_cString 	+= "   </td>"
_cString 	+= "   <td width='200' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Condi็ใo de Pagamento</b></font></p>"
_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Saldo inicial</b></font></p>"
_cString 	+= "   </td>" 
//_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Vig๊ncia</b></font></p>"
//_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>C๓digo Fornecedor</b></font></p>"
//_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Nome Fornecedor</b></font></p>"
//_cString 	+= "   </td>" 
//_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Tipo Fornecedor</b></font></p>"
//_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Regiใo</b></font></p>"
_cString 	+= "   </td>"  
_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Endere็o</b></font></p>"
_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#AAC8FF' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'><b>Revisใo</b></font></p>"
//_cString 	+= "   </td>"

_cCor		:=	"DFEFFF"    
    
_cString 	+= "   <td width='200' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_NUMERO+"</font></p>" //Produto
_cString 	+= "   </td>"
_cString 	+= "   <td width='300' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+DtoC(CN9_DTINIC)+"</font></p>" //Descricao
_cString 	+= "   </td>" 
_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+DtoC(CN9_DTFIM)+"</font></p>" //Origem anterior
_cString 	+= "   </td>"
_cString 	+= "   <td width='200' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_DESCPG+"</font></p>" //Parcela Importada
_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+cValToChar(CN9_VLINI)+"</font></p>" //Origem atualizada
_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+Dtoc(CN9_VIGI)+"</font></p>" //Origem atualizada
//_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+Dtoc(CNC_CODIGO)+"</font></p>" //Origem atualizada
//_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CNC_NOME+"</font></p>" //Origem atualizada
//_cString 	+= "   </td>" 
//_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_XTFOR+"</font></p>" //Origem atualizada
//_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_XRDESC+"</font></p>" //Origem atualizada
_cString 	+= "   </td>"
_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_XEND+"</font></p>" //Origem atualizada
_cString 	+= "   </td>"
//_cString 	+= "   <td width='100' bgcolor='#"+_cCor+"' height='19'>"
//_cString 	+= "     <p align='left'><font face='Arial' size='2'>"+CN9_REVISA+"</font></p>" //Origem atualizada
//_cString 	+= "   </td>"
_cString 	+= "   </td>" 
                             
//If _cCor == "DFEFFF" //Tratamento de cores nas linhas
	//_cCor := "FFFFFF"
	//Else
		//_cCor := "DFEFFF"
	//EndIf
*/		
_cString 	+= "</table>"
_cString	+= "<p><span style='font-size:12.0pt;font-family:Arial'><b>Favor nใo responder</b> - Mensagem automatica enviada pelo sistema (CN300PCMT).</span></p>"
_cString	+= "&nbsp"

U_ZSendMail(_cTo	     ,_cCopia   ,_cAssunto,_cString  ,  ,_lExibeMsg)
//TkSendMail( cAccount,cPassword,cServer,cEmailde,_cTo,_cAssunto,_cString, )

Return() 