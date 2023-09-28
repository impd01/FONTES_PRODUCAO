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
    cOpcoes += "A=JURIDICO RESIDENCIAL;"
    cOpcoes += "B=JURIDICO COMERCIAL;"
    cOpcoes += "C=ACORDO COMERCIAL;"
    cOpcoes += "D=ACORDO RESIDENCIAL;"
    cOpcoes += "E=PREST. SERVICO;"


RestArea(aArea)
Return cOpcoes
