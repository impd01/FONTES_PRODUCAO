#Include 'Protheus.ch'

User Function MDGPE01(cMat,cNome)

	Local _cTitulo		:= "Cadastro de Grupos"
	Local _lRetMod2Ok	:= .F.
	Local _nx			:= 0
	Local _lAchou		:= .F.
	Local _aCpoCab		:= {}
	Local _aCpoRod		:= {}
	Local _aCoord		:= {}
	Local _aTamWnd		:= {}
	Local _nRecno		:= 0
	Local _nOrder		:= SZ1->( IndexOrd() )
	Local _cAlias       :="SZ1"
	Local _nOpcX        :=3
	Local _cLinhaOk       	:= .t.    // Funcao executada para validar o contexto da linha atual do aCols
	Local _cTudoOk      	:= .t.    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Private aCpoGDa       	:= {"Z1_TIPO","Z1_DESC"}

	Private _cMat	    :=  SRA->RA_MAT
	Private _cDesc   	:=  SRA->RA_NOME
	Private _bWhile		:= { || xFilial("SZ1") == SZ1->Z1_FILIAL .and. _cMat == SZ1->Z1_MAT   }


	Private aHeader 	:= {}
	Private aCols   	:= {}
	Private _cCpoExc	:= Padr( "Z1_MAT",10) 	/*	Campo que nao devera aparecer na Getdados mesmo estando marcado como 'browse' no SX3 sempre com tamanho 10 */

	dbSelectArea( "SZ1" )
	dbSetOrder( 1 )

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Posiciona registros para getdados                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If dbSeek( xFilial( "SZ1" ) + _cMat)
		_nRecno:= SZ1->( Recno())
		_nOpcX:=4
	Endif

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Carrega aHeader do Alias a ser usado na Getdados             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	aHeader := CargaHeader( _cAlias, _cCpoExc )

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� nOpcX 3 = Inclusao                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If _nOpcX == 3

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Carrega aCols com dados iniciais para a inclusao de linha na �
		//� Getdados.                                                    �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		aCols := CarIncCols( _cAlias, aHeader, "Z1_ITEM", 3, _cCpoExc )


		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Demais valores para _nOpcX                                   �
		//� 1=Pesquisar                                                  �
		//� 2=Visualizar                                                 �
		//� 4=Alterar                                                    �
		//� 5=Excluir                                                    �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	else

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Carrega aCols com dados de Enderecos selecionada no Browse   �
		//� principal ( no caso de alteracao, exclusao ou visualizacao ) �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		aCols := CargaCols( aHeader, _cAlias, 1, xFilial( "SZ1" ) + _cMat, _bWhile, _cCpoExc )

	Endif

	/*
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Array para get no cabecalho da Tela estilo modelo2. Parametros:                      �
	�                                                                                      �
	� aC[n,1] =  Nome da Variavel Ex.:"cCliente"                                           �
	� aC[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL             �
	� aC[n,3] =  Titulo do Campo                                                           �
	� aC[n,4] =  Picture                                                                   �
	� aC[n,5] =  Nome da funcao para validacao do campo                                    �
	� aC[n,6] =  F3                                                                        �
	� aC[n,7] =  Se campo e' editavel .t. se nao .f.                                       �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	*/

	AADD( _aCpoCab,{ "_cMat"   	    ,{ C(15), C(010) } , OemToAnsi("Matricula")	, "@!"    , "",""	,.F.})


	/*
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Array para get no rodape da Tela estilo modelo2. Parametros:                         �
	�                                                                                      �
	� aR[n,1] =  Nome da Variavel Ex.:"cCliente"                                           �
	� aR[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL             �
	� aR[n,3] =  Titulo do Campo                                                           �
	� aR[n,4] =  Picture                                                                   �
	� aR[n,5] =  Nome da funcao para validacao do campo                                    �
	� aR[n,6] =  F3                                                                        �
	� aR[n,7] =  Se campo e' editavel .t. se nao .f.                                       �
	�                                                                                      �
	� Ex: AADD(aR,{"nTotal",{120,10},OemToAnsi("Total"),"@E 999,999,999.99",,,.F.})        �
	�                                                                                      �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	*/

	/*
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Array com as coordenadas para a Getdados na tela             �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	*/
	_aCoord := { C(053), C(005), C(118), C(315) }
	_aTamWnd:= { C(100), C(100), C(400), C(750) }

	/*
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	� Exibe tela estilo modelo2. Parametros:                                                        �
	�                                                                                               �
	� cTitulo  = Titulo da Janela                                                                   �
	� aC       =  Array com campos do Cabecalho                                                     �
	� aR       =  Array com campos do Rodape                                                        �
	� aCGD     =  Array com coordenadas da Getdados                                                 �
	� nOpcx    =  Modo de Operacao                                                                  �
	� cLineOk  =  Validacao da linha do Getdados                                                    �
	� cAllOk   =  Validacao de toda Getdados                                                        �
	� aGetSD   =  Array com gets editaveis                                                          �
	� bF4      =  Bloco de codigo para tecla F4                                                     �
	� cIniCpos =  String com nome dos campos que devem ser inicializados ao teclar seta para baixo  �
	� lDelGetD =  Determina se as linhas da Getdados podem ser deletadas ou nao.                    �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	*/

	_lRetMod2Ok := Modelo2( _cTitulo, _aCpoCab , _aCpoRod, _aCoord, _nOpcx, "AllwaysTrue()",  "AllwaysTrue()",aCpoGDa,, "+Z1_ITEM",999,_aTamWnd,,.T. )

	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Operacao confirmada. Efetuando gravacao dos registros        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If _lRetMod2Ok

		Begin Transaction

			dbSelectArea( "SZ1" )
			dbSetOrder( 2 )

			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� Efetua gravacao de todos os itens da Getdados                �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			For _nx := 1 to Len( aCols )

				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Trata primeira linha do getdados quando ao ha inclusao       �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				If Empty( aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z1_ITEM" } ) ] )
					Loop
				Endif



				_lAchou := SZ1->( dbSeek( xFilial( "SZ1" )+  ALLTRIM(aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z1_ITEM" } ) ]   )+ ALLTRIM(SRA->RA_MAT) ) )



				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Faz tratamento para exclusao                                 �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				If ( ( aCols[ _nx, Len( aHeader ) +1 ] .and. _nOpcX == 4 ) .or. _nOpcX == 5 ) .and. _lAchou

					RecLock( "SZ1", .F. )
					dbDelete()
					MsUnLock()

					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//� Faz tratamento para inclusao ou alteracao                    �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				elseif !aCols[ _nx, Len( aHeader ) +1 ]

					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//� Somente em caso de inclusao gravar a chave do registro       �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					If !_lAchou
						RecLock( "SZ1", .T. )
						SZ1->Z1_FILIAL	:= xFilial("SZ1")
						SZ1->Z1_MAT 	:= SRA->RA_MAT

						//Z21->Z21_ITEM	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z21_ITEM" } ) ]
						MsUnLock()

					Endif

					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//� Faz a gravacao dos demais campos tanto para inclusao quanto  �
					//� para alteracao.                                              �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					RecLock( "SZ1", .F. )
					SZ1->Z1_ITEM	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z1_ITEM" } ) ]
					SZ1->Z1_TIPO	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z1_TIPO" } ) ]
					SZ1->Z1_DESC	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z1_DESC" } ) ]
					MsUnLock()

				Endif

			Next

		End Transaction

		dbSelectArea( "SZ1" )
		dbGoto( _nRecno )

	Endif

	SZ1->( dbSetOrder( _nOrder ) )

Return( Nil )


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇�袴袴袴袴錮袴袴袴袴袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴뺑�
굇튡rograma � CargaHeader     튍utor� Antonio Marcos Andriani    � Data � 01/08/2013 볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴攷굇
굇튒esc.    � Rotina para carregar variavel array aHeader baseada no SX3 do Alias    볍�
굇�         � passado no parametro.                                                  볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튡arametr � ExpC1 = Alias do arquivo a ser usado na getdados.                      볍�
굇�         � ExpC2 = String com os campos que nao deverao aparecer na Getdados      볍�
굇�         �         mesmo estando marcados como 'browse' no arquivo SX3.           볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튧so      � Exclusivo Evora                                                        볍�
굇勁袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 볍�
굇勁袴袴袴袴袴袴袴佶袴袴袴袴佶袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�  Programador  �  Data   � Motivo da Alteracao                                    볍�
굇勁袴袴袴袴袴袴袴妄袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�               �         �                                                        볍�
굇훤袴袴袴袴袴袴袴鳩袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
*/
Static Function CargaHeader( _cAlias, _cCpoExc )
	Local _aHeader 	:= {}
	Local _nUsado	:= 0

	dbSelectArea( "SX3" )
	SX3->(dbSetOrder(1))
	dbSeek("SZ1")

	While !Eof() .and. X3_ARQUIVO == _cAlias

		If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )
			_nUsado++
			AADD( _aHeader, { 	Trim( X3Titulo() ),;
				X3_CAMPO    ,;
				X3_PICTURE  ,;
				X3_TAMANHO  ,;
				X3_DECIMAL  ,;
				X3_VALID    ,;
				X3_USADO    ,;
				X3_TIPO     ,;
				X3_ARQUIVO  ,;
				X3_CONTEXT  } )
		Endif

		dbSkip()

	Enddo

Return( _aHeader )


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇�袴袴袴袴錮袴袴袴袴袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴뺑�
굇튡rograma � CarIncCols      튍utor� Antonio Marcos Andriani    � Data � 01/08/2013 볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴攷굇
굇튒esc.    � Rotina que carrega a variavel array aCols com valores iniciais na      볍�
굇�         � inclusao do registro.                                                  볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튡arametr.� ExpC1 = Alias do arquivo a ser usado na Getdados                       볍�
굇�         � ExpC2 = Variavel array com o Header do Alias a ser usado               볍�
굇�         � ExpC3 = Variavel opcional. Caso existe um campo que precise ser nume-  볍�
굇�         �         radi sequencialmente, informar nessa variavel o nome.          볍�
굇�         � ExpC4 = Tamanho do campo sequencial item ( ExpC3 ). O Default e 2.     볍�
굇�         � ExpC5 = String com os campos que nao deverao aparecer na Getdados      볍�
굇�         �         mesmo estando marcados como 'browse' no arquivo SX3.           볍�
굇�         �                                                                        볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튧so      � Exclusivo Evora                                                        볍�
굇勁袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 볍�
굇勁袴袴袴袴袴袴袴佶袴袴袴袴佶袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�  Programador  �  Data   � Motivo da Alteracao                                    볍�
굇勁袴袴袴袴袴袴袴妄袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�               �         �                                                        볍�
굇훤袴袴袴袴袴袴袴鳩袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
*/
Static Function CarIncCols( _cAlias, _aHeader, _cCpoItem, _nTamCpoItem, _cCpoExc )
	Local _aArea			:= GetArea()
	Local _nUsado			:= 0
	Local _aCols			:= {}

	Default _cCpoItem		:= ""
	Default _nTamCpoItem	:= 3

	dbSelectArea( "SX3" )
	dbSeek( "SZ1" )
	aAdd( _aCols, Array( Len( _aHeader ) +1 ) )

	Do While !Eof() .and. X3_ARQUIVO == _cAlias

		If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )

			_nUsado++
			If X3_TIPO == "C"
				If Trim(aHeader[_nUsado][2]) == _cCpoItem
					_aCols[ 1, _nUsado ] := StrZero( 1, _nTamCpoItem )
				Else
					_aCols[ 1, _nUsado ] := Space( X3_TAMANHO )
				Endif
			Elseif X3_TIPO == "N"
				_aCols[ 1, _nUsado ] := 0
			Elseif X3_TIPO == "D"
				_aCols[ 1, _nUsado ] := dDataBase
			Elseif X3_TIPO == "M"
				_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
			Else
				_aCols[ 1, _nUsado ] := .F.
			Endif
			If X3_CONTEXT == "V"
				_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
			Endif

		Endif

		dbSkip()

	Enddo

	_aCols[ 1, _nUsado +1 ] := .F.

	RestArea( _aArea )

Return( _aCols )


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇�袴袴袴袴錮袴袴袴袴袴袴袴袴藁袴袴錮袴袴袴袴袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴뺑�
굇튡rograma � CargaCols       튍utor� Antonio Marcos Andriani    � Data � 01/08/2013 볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴姦袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴攷굇
굇튒esc.    � Rotina para carregar os dados de um determinado alias ( baseado no     볍�
굇�         � Header ) para a Getdados usada ( alteracao, exclusao, visual ).        볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튡arametr.� ExpA1 = Variavel array com o Header do Alias a ser usado               볍�
굇�         � ExpC2 = Alias do arquivo a ser usado na Getdados                       볍�
굇�         � ExpN3 = Indice chave do alias                                          볍�
굇�         � ExpC4 = Chave a ser pesquisado ( dbSeek inicial )                      볍�
굇�         � ExpB5 = Code Block a ser usado no Do while para carregar os dados      볍�
굇�         � ExpC6 = String com os campos que nao deverao aparecer na Getdados      볍�
굇�         �         mesmo estando marcados como 'browse' no arquivo SX3.           볍�
굇�         �                                                                        볍�
굇勁袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튧so      � Exclusivo Evora                                                        볍�
굇勁袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 볍�
굇勁袴袴袴袴袴袴袴佶袴袴袴袴佶袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�  Programador  �  Data   � Motivo da Alteracao                                    볍�
굇勁袴袴袴袴袴袴袴妄袴袴袴袴妄袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇�               �         �                                                        볍�
굇훤袴袴袴袴袴袴袴鳩袴袴袴袴鳩袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
*/
Static Function CargaCols( _aHeader, _cAlias, _nIndice, _cChave, _bWhile, _cCpoExc  )
	Local _aArea	:= GetArea()
	Local _nUsado	:= 0
	Local _nCnt		:= 0
	Local _aCols	:= {}

	dbSelectArea( _cAlias )
	dbSetOrder( _nIndice )
	dbSeek( _cChave )

	Do While Eval( _bWhile )

		aAdd( _aCols, Array( Len( _aHeader ) +1 ) )
		_nCnt++
		_nUsado := 0
		dbSelectArea( "SX3" )
		dbSeek( _cAlias )

		Do While !Eof() .and. X3_ARQUIVO == _cAlias


			If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( Alltrim(X3_CAMPO) $ _cCpoExc )
				_nUsado++
				_cVarTemp := _cAlias + "->" + ( X3_CAMPO )
				If X3_CONTEXT # "V"
					_aCols[ _nCnt, _nUsado ] := &_cVarTemp
				Elseif X3_CONTEXT == "V" .and. !Empty(SX3->X3_INIBRW)
					_aCols[ _nCnt, _nUsado ] := Eval( &( "{|| " + _cAlias + "->(" + SX3->X3_INIBRW + ") }" ) )
				Endif
			Endif



			DBSkip()

		Enddo


		_aCols[ _nCnt, _nUsado + 1 ] := .F.
		dbSelectArea( _cAlias )
		dbSkip()

	Enddo

	RestArea( _aArea )

Return( _aCols )
