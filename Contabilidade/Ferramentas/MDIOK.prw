/*/Program U_MDIOK.PRG/*/
#INCLUDE "PROTHEUS.CH"

/*/
������������������������������������������������������������������������Ŀ
�Fun+"o    �U_MdiOk           �Autor �Marinaldo de Jesus   � Data �12/06/2007�
������������������������������������������������������������������������Ĵ
�Descri+"o �Funcao de Validacao do Acesso MDI                                     �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>                                              �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>                                              �
������������������������������������������������������������������������Ĵ
�Retorno   �lMdiOk                                                            �
������������������������������������������������������������������������Ĵ
�Observa+"o�                                                        �
������������������������������������������������������������������������Ĵ
�Uso       �Validar o Acesso ao Interface MDI                                     �
��������������������������������������������������������������������������/*/
User Function MdiOk()

Local lMdiOk

Begin Sequence

    //Permite o Acesso ao SIGAMDI apenas para o Administrador do Sistema
    IF !( lMdiOk := ( __cUserId == "000000" .Or. __cUserId == "000054" ) ) //Administrador ou Roseli Lopes
        Break
    EndIF

End Sequence

Return( lMdiOk )
