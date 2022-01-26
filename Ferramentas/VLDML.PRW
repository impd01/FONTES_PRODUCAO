#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'Rwmake.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#include 'TbiConn.ch'

/*/{Protheus.doc} User Function VLDML
    (Verificação de de Centro de Custo se bloqueado ou não)
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
                MsgAlert("Centro de Custo selecionado está com 'asterísco' ou bloqueado, verificar com a Contabilidade a veracidade do item selecionado!","Atenção")
		    	Return .F.
            Endif           
       Endif

    DbCloseArea()

Return 
