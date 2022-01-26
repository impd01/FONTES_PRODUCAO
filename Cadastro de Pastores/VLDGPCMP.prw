#Include 'Protheus.ch'

User Function VLDGPCMP()
	Local cGrupoMv := GETMV("FS_GRUPO")
	Local lRet     := .T.

	PswOrder(2)
	lAchou       := PSWSeek(Substr(cUsuario,7,15))
	aUserFl      := PswRet(1)
	GrupoUsuario := aUserFl[1][10][1]


	IF ALLTRIM(cGrupoMv) <> ALLTRIM(GrupoUsuario) .AND. ALLTRIM(FUNNAME())=="GPEA265"
		MSGALERT("Usuario sem permissão para alterar o campo")
		lRet:=.F.
	ENDIF

Return(lRet)

