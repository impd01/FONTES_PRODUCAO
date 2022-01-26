#Include 'Protheus.ch'

User Function MDGPE03()

	Local cAlias		:= GetNextAlias()
	Local nOpca		:= 0
	Local oDlg		:= Nil
	Local aPosObj  	:= {}
	Local aObjects 	:= {}
	Local aSize    	:= {}
	Local aPosGet  	:= {}
	Local aInfo    	:= {}
	Local cTitulo := "Historico"
	Local nContador	:= 0
	Local aAlter    := {}
	Local aHeader	:= {}
	Local aCols	:= {}
	Local oFont13b  := TFont():New( "Times New Roman",,13,,.t.,,,,,.f. )
	Local oFont15b  := TFont():New( "Times New Roman",,15,,.t.,,,,,.f. )
	Private nUsado 	:= 0
	Private oGet	:= Nil



	//+----------------------------------------------------------------------------
	//| Dimensão da tela
	//+----------------------------------------------------------------------------
	aSize := MsAdvSize(.T.)
	aObjects := {}
	AAdd( aObjects, { 100, 030, .t., .F. } )
	AAdd( aObjects, { 100, 100, .t., .T. } )





	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6], aSize[5] OF oMainWnd PIXEL



	@ aPosObj[1,1]+1,aPosObj[1,2]+1 to aPosObj[1,3]-1 , aPosObj[1,4]-1 OF oDlg PIXEL

	@ aPosObj[1,1]+05,aPosObj[1,2]+010 SAY "Matricula: "+SRA->RA_MAT OF oDlg PIXEL FONT oFont15b
	@ aPosObj[1,1]+05,aPosObj[1,2]+100 SAY "Nome: "+SRA->RA_NOME  OF oDlg PIXEL FONT oFont15b


	//+----------------------------------------------------------------------------
	//| Gera cabeçalho
	//+----------------------------------------------------------------------------
	aHeader:= aHeader()

	cQuery := " SELECT * " + CRLF
	cQuery += " FROM  SRE020 SRE " + CRLF
	cQuery += " WHERE RE_MATP ='"+SRA->RA_MAT+"' AND SRE.D_E_L_E_T_=''  " + CRLF
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .F. )





	 While !(cAlias)->(Eof())

	aAdd(aCols,{ ALLTRIM(RetField('SM0',1,(cAlias)->RE_EMPD+(cAlias)->RE_FILIALD,'M0_FILIAL')),;
		       (cAlias)->RE_MATD,;
		       ALLTRIM(RetField('SM0',1,(cAlias)->RE_EMPP+(cAlias)->RE_FILIALP,'M0_FILIAL')),;
		       (cAlias)->RE_MATP,;
		       STOD((cAlias)->RE_DATA),;
		       .f.})
	(cAlias)->(dbSkip())
	EndDo
(cAlias)->(dbClosearea())





	//+----------------------------------------------------------------------------
	//| Monta GetDados do equimanetos e valores
	//+----------------------------------------------------------------------------
	oGet := MsNewGetDados():New(  aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4],GD_UPDATE, "AllwaysTrue()","AllwaysTrue()",,aAlter,,999, "AllwaysTrue()",            , "AllwaysTrue",    oDlg,        aHeader, aCols )

	For nx := 1 to Len( oGet:OBROWSE:ACOLSIZES )
		oGet:OBROWSE:ACOLSIZES[nx] := oGet:OBROWSE:ACOLSIZES[nx]-10
	Next


	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| oDlg:End()}, {|| nOpcA := 0, oDlg:End() },, ) CENTERED


Return( Nil )


Static Function aHeader()

	Private aHeader	:= {}

	dbSelectArea("SX3")
	dbSetOrder(2)

If dbSeek("A1_NOME")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			If Alltrim(x3_campo) == "A1_NOME"
				nUsado:=nUsado+1
				AADD(aHeader,{ "Filial de", x3_campo, x3_picture,x3_tamanho,x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
			Endif
		Endif
	Endif




	If dbSeek("RE_MATD")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			If Alltrim(x3_campo) == "RE_MATD"
				nUsado:=nUsado+1
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
			Endif
		Endif
	Endif


	If dbSeek("A1_NOME")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			If Alltrim(x3_campo) == "A1_NOME"
				nUsado:=nUsado+1
				AADD(aHeader,{ "Filial Para", x3_campo, x3_picture,x3_tamanho,x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
			Endif
		Endif
	Endif

	If dbSeek("RE_MATP")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			If Alltrim(x3_campo) == "RE_MATP"
				nUsado:=nUsado+1
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
			Endif
		Endif
	Endif


If dbSeek("RE_DATA")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			If Alltrim(x3_campo) == "RE_DATA"
				nUsado:=nUsado+1
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_f3, x3_context } )
			Endif
		Endif
	Endif




Return(aHeader)