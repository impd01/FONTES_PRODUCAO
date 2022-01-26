//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} xcombo
Função para retornar uma lista de opções em um campo combo
@author Felipe
@since 10/09/2020
@version 1.0
@type function
/*/
 
User Function xcombo()
    
    Local aArea   := GetArea()
    Local cOpcoes := ""
 
    //Montando as opções de retorno
    cOpcoes += "1=RH;"
    cOpcoes += "2=GPS;"
    cOpcoes += "3=CONSUMO;"
    cOpcoes += "4=ALUGUEL;"
    cOpcoes += "5=DARF;"
    cOpcoes += "6=RENDA;"
    cOpcoes += "7=CONDOMINIO;"
    cOpcoes += "8=IPTU;"
    cOpcoes += "9=JURIDICO;"
    cOpcoes += "10=JURIDICO RESIDENCIAL;"
    cOpcoes += "11=JURIDICO COMERCIAL;"
    cOpcoes += "12=ACORDO COMERCIAL;"
    cOpcoes += "13=ACORDO RESIDENCIAL;"
    cOpcoes += "14=PREST. SERVICO;"


RestArea(aArea)
Return cOpcoes
