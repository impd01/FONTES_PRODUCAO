#include "tbiconn.ch"
#include "protheus.ch"
#include 'parmtype.ch'

/*/{Protheus.doc} User Function CRIATAB
    (Função para recriar tabelas)
    @type  Function
    @author Felipe
    @since 08/11/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    ()
    @see (links_or_references)
    /*/
User Function CRIATAB()
    
    /*Local cPerg   := 'CRIATAB'

	If !Pergunte(cPerg,.T.)
		
	Endif*/

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER 'admin' PASSWORD 'Ref@2021' TABLES 'SRA'
    
    /*******COMANDOS *********/
    
    RESET ENVIRONMENT
Return 
