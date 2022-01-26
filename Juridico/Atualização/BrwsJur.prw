#include 'protheus.ch'
#include 'parmtype.ch'

User Function BrowseZZ5()

	Private cAlias 		:= "ZZ5"
	Private cCadastro	:= "Cadastro de Autor"
	Private aRotina		:= {}	

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))

	aRotina := {	{"Pesquisar",			'AxPesqui',	0,1,0,.F.},;
					{"Visualizar",			'AxVisual',	0,2,0,Nil},;
					{"Incluir",				'AxInclui',	0,3,0,Nil},;
					{"Alterar",				'AxAltera',	0,6,0,Nil},;
					{"Excluir",     		'AxDeleta',	0,7,0,.F.} }

	mBrowse(,,,, cAlias)

Return .T.