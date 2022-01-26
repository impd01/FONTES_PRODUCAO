#include 'protheus.ch'
#include 'parmtype.ch'

user function BRWCLI()
	
PRIVATE cCadastro := "Cadastro de Réu" 

PRIVATE aRotina   := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }
        
        
Private cDelFunc := ".T."
Private cString := "ZZ6"
	dbSelectArea("ZZ6")
	dbSetOrder(1)
			dbSelectArea(cString)
			mBrowse( 6,1,22,75,cString)

return