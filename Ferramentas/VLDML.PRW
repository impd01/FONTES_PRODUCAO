#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

/*/{Protheus.doc} User Function VLDML
    (Verifica��o de de Centro de Custo se bloqueado ou n�o)
    @type  Function
    @author Felipe Barros   
    @since 23/11/2021
    @version 1.0
    @see (links_or_references)
/*/
User Function VLDML(cCusto)
    
    Local cDesc

    DbSelectArea("CTT")
    DbSetOrder(1)

    cDesc := Alltrim(CTT->CTT_DESC01)

		If CTT->(DbSeek(xFilial("CTT") + cCusto))
           If "(*)" $ cDesc .OR. CTT->CTT_BLOQ == '1'
                MsgAlert("Centro de Custo selecionado est� com 'aster�sco' ou bloqueado, verificar com a Contabilidade a veracidade do item selecionado!","Aten��o")
		    	Return .F.
            Endif           
       Endif

    DbCloseArea()

Return 
