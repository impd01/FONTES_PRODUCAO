#include 'protheus.ch'
#include 'parmtype.ch'

User Function IM69A02()
 
PRIVATE cAlias   := 'SZ5'
 
PRIVATE cCadastro 	:= "Alterações de Contratos"
PRIVATE aRotina     := {{"Pesquisar" , "AxPesqui"         , 0, 1 },;
                                       {"Visualizar" , "AxVisual"   , 0, 2 },;
                                       {"Incluir"       , "AxInclui"   , 0, 3 },;
                                       {"Alterar"      , "AxAltera"   , 0, 4 },;
                                       {"Excluir"      , "AxDeleta"   , 0, 5 }}

mBrowse( ,,,,cAlias,,,,,,,,,,,,,,)
	
Return