#Include 'Protheus.ch'

User Function MDGPE02()



Local _cTitulo		:= "Cadastro de Entrevista"
Local _lRetMod2Ok	:= .F.
Local _nx			:= 0
Local _lAchou		:= .F.
Local _aCpoCab		:= {}
Local _aCpoRod		:= {}
Local _aCoord		:= {}
Local _aTamWnd		:= {}
Local _nRecno		:= 0
Local _nOrder		:= SZ2->( IndexOrd() )
Local _cAlias       :="SZ2"
Local _nOpcX        :=3
Local _cLinhaOk       	:= .t.    // Funcao executada para validar o contexto da linha atual do aCols
Local _cTudoOk      	:= .t.    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Private aCpoGDa       	:= {"Z2_DTINC","Z2_APROVA","Z2_OBS","Z2_ENTREVI"}

Private _cMat	    :=  SRA->RA_MAT
Private _cDesc   	:=  SRA->RA_NOME
Private _bWhile		:= { || xFilial("SZ2") == SZ2->Z2_FILIAL .and. _cMat == SZ2->Z2_MAT   }


Private aHeader 	:= {}
Private aCols   	:= {}
Private _cCpoExc	:= Padr( "Z2_MAT",10) 	/*	Campo que nao devera aparecer na Getdados mesmo estando marcado como 'browse' no SX3 sempre com tamanho 10 */

dbSelectArea( "SZ2" )
dbSetOrder( 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registros para getdados                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dbSeek( xFilial( "SZ2" ) + _cMat)
	_nRecno:= SZ2->( Recno())
	_nOpcX:=4
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega aHeader do Alias a ser usado na Getdados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := CargaHeader( _cAlias, _cCpoExc )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nOpcX 3 = Inclusao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nOpcX == 3

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega aCols com dados iniciais para a inclusao de linha na ³
	//³ Getdados.                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols := CarIncCols( _cAlias, aHeader, "Z2_ITEM", 3, _cCpoExc )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Demais valores para _nOpcX                                   ³
//³ 1=Pesquisar                                                  ³
//³ 2=Visualizar                                                 ³
//³ 4=Alterar                                                    ³
//³ 5=Excluir                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega aCols com dados de Enderecos selecionada no Browse   ³
	//³ principal ( no caso de alteracao, exclusao ou visualizacao ) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols := CargaCols( aHeader, _cAlias, 1, xFilial( "SZ2" ) + _cMat, _bWhile, _cCpoExc )

Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Array para get no cabecalho da Tela estilo modelo2. Parametros:                      ³
³                                                                                      ³
³ aC[n,1] =  Nome da Variavel Ex.:"cCliente"                                           ³
³ aC[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL             ³
³ aC[n,3] =  Titulo do Campo                                                           ³
³ aC[n,4] =  Picture                                                                   ³
³ aC[n,5] =  Nome da funcao para validacao do campo                                    ³
³ aC[n,6] =  F3                                                                        ³
³ aC[n,7] =  Se campo e' editavel .t. se nao .f.                                       ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

AADD( _aCpoCab,{ "_cMat"   	    ,{ C(15), C(010) } , OemToAnsi("Matricula")	, "@!"    , "",""	,.F.})


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Array para get no rodape da Tela estilo modelo2. Parametros:                         ³
³                                                                                      ³
³ aR[n,1] =  Nome da Variavel Ex.:"cCliente"                                           ³
³ aR[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL             ³
³ aR[n,3] =  Titulo do Campo                                                           ³
³ aR[n,4] =  Picture                                                                   ³
³ aR[n,5] =  Nome da funcao para validacao do campo                                    ³
³ aR[n,6] =  F3                                                                        ³
³ aR[n,7] =  Se campo e' editavel .t. se nao .f.                                       ³
³                                                                                      ³
³ Ex: AADD(aR,{"nTotal",{120,10},OemToAnsi("Total"),"@E 999,999,999.99",,,.F.})        ³
³                                                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Array com as coordenadas para a Getdados na tela             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
_aCoord := { C(053), C(005), C(118), C(315) }
_aTamWnd:= { C(100), C(100), C(400), C(750) }

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Exibe tela estilo modelo2. Parametros:                                                        ³
³                                                                                               ³
³ cTitulo  = Titulo da Janela                                                                   ³
³ aC       =  Array com campos do Cabecalho                                                     ³
³ aR       =  Array com campos do Rodape                                                        ³
³ aCGD     =  Array com coordenadas da Getdados                                                 ³
³ nOpcx    =  Modo de Operacao                                                                  ³
³ cLineOk  =  Validacao da linha do Getdados                                                    ³
³ cAllOk   =  Validacao de toda Getdados                                                        ³
³ aGetSD   =  Array com gets editaveis                                                          ³
³ bF4      =  Bloco de codigo para tecla F4                                                     ³
³ cIniCpos =  String com nome dos campos que devem ser inicializados ao teclar seta para baixo  ³
³ lDelGetD =  Determina se as linhas da Getdados podem ser deletadas ou nao.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

_lRetMod2Ok := Modelo2( _cTitulo, _aCpoCab , _aCpoRod, _aCoord, _nOpcx, "AllwaysTrue()","U_VLDGPE2()",aCpoGDa,, "+Z2_ITEM",999,_aTamWnd,,.T. )

// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Operacao confirmada. Efetuando gravacao dos registros        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lRetMod2Ok

	Begin Transaction

		dbSelectArea( "SZ2" )
		dbSetOrder( 2 )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua gravacao de todos os itens da Getdados                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nx := 1 to Len( aCols )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata primeira linha do getdados quando ao ha inclusao       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ITEM" } ) ] )
				alert("entrou no loop")
				Loop
			Endif

			_lAchou := SZ2->( dbSeek( xFilial( "SZ2" ) +  aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ITEM" } ) ] + _cMat   ) )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz tratamento para exclusao                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( ( aCols[ _nx, Len( aHeader ) +1 ] .and. _nOpcX == 4 ) .or. _nOpcX == 5 ) .and. _lAchou

				RecLock( "SZ2", .F. )
				dbDelete()
				MsUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz tratamento para inclusao ou alteracao                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			elseif !aCols[ _nx, Len( aHeader ) +1 ]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Somente em caso de inclusao gravar a chave do registro       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !_lAchou
					RecLock( "SZ2", .T. )
					SZ2->Z2_FILIAL	:= xFilial("SZ2")
					SZ2->Z2_MAT 	:= SRA->RA_MAT

					//Z21->Z21_ITEM	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z21_ITEM" } ) ]
					MsUnLock()

				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a gravacao dos demais campos tanto para inclusao quanto  ³
				//³ para alteracao.                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock( "SZ2", .F. )
				SZ2->Z2_ITEM	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ITEM" } ) ]
				SZ2->Z2_ENTREVI	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ENTREVI" } ) ]
			  	SZ2->Z2_DTINIC	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_DTINIC" } ) ]
			  	SZ2->Z2_APROVA	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_APROVA" } ) ]
			  	SZ2->Z2_OBS  	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_OBS" } ) ]
				MsUnLock()

			Endif

		Next

	End Transaction

	dbSelectArea( "SZ2" )
	dbGoto( _nRecno )

Endif

SZ2->( dbSetOrder( _nOrder ) )

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ CargaHeader     ºAutor³ Antonio Marcos Andriani    º Data ³ 01/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina para carregar variavel array aHeader baseada no SX3 do Alias    º±±
±±º         ³ passado no parametro.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpC1 = Alias do arquivo a ser usado na getdados.                      º±±
±±º         ³ ExpC2 = String com os campos que nao deverao aparecer na Getdados      º±±
±±º         ³         mesmo estando marcados como 'browse' no arquivo SX3.           º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Exclusivo Evora                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CargaHeader( _cAlias, _cCpoExc )
Local _aHeader 	:= {}
Local _nUsado	:= 0

dbSelectArea( "SX3" )
SX3->(dbSetOrder(1))
dbSeek("SZ2")

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ CarIncCols      ºAutor³ Antonio Marcos Andriani    º Data ³ 01/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina que carrega a variavel array aCols com valores iniciais na      º±±
±±º         ³ inclusao do registro.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr.³ ExpC1 = Alias do arquivo a ser usado na Getdados                       º±±
±±º         ³ ExpC2 = Variavel array com o Header do Alias a ser usado               º±±
±±º         ³ ExpC3 = Variavel opcional. Caso existe um campo que precise ser nume-  º±±
±±º         ³         radi sequencialmente, informar nessa variavel o nome.          º±±
±±º         ³ ExpC4 = Tamanho do campo sequencial item ( ExpC3 ). O Default e 2.     º±±
±±º         ³ ExpC5 = String com os campos que nao deverao aparecer na Getdados      º±±
±±º         ³         mesmo estando marcados como 'browse' no arquivo SX3.           º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Exclusivo Evora                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CarIncCols( _cAlias, _aHeader, _cCpoItem, _nTamCpoItem, _cCpoExc )
Local _aArea			:= GetArea()
Local _nUsado			:= 0
Local _aCols			:= {}

Default _cCpoItem		:= ""
Default _nTamCpoItem	:= 3

dbSelectArea( "SX3" )
dbSeek( "SZ2" )
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ CargaCols       ºAutor³ Antonio Marcos Andriani    º Data ³ 01/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina para carregar os dados de um determinado alias ( baseado no     º±±
±±º         ³ Header ) para a Getdados usada ( alteracao, exclusao, visual ).        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr.³ ExpA1 = Variavel array com o Header do Alias a ser usado               º±±
±±º         ³ ExpC2 = Alias do arquivo a ser usado na Getdados                       º±±
±±º         ³ ExpN3 = Indice chave do alias                                          º±±
±±º         ³ ExpC4 = Chave a ser pesquisado ( dbSeek inicial )                      º±±
±±º         ³ ExpB5 = Code Block a ser usado no Do while para carregar os dados      º±±
±±º         ³ ExpC6 = String com os campos que nao deverao aparecer na Getdados      º±±
±±º         ³         mesmo estando marcados como 'browse' no arquivo SX3.           º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Exclusivo Evora                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


User  Function VLDGPE2()
Local nQtdAp  := 0
Local lRet    :=.T.


FOR _ny:=1 to len(aCols)

IF aCols[_ny,aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_APROVA" } ) ]=="1"
nQtdAp+=1

ENDIF

Next _ny


IF nQtdAp >1
MSGALERT("Somente uma entrevista pode ter aprovação!!!")
lRet:=.F.
ENDIF

IF nQtdAp == 1

RecLock( "SRA", .F. )

SRA->RA_XSTATUS := "1"
SRA->RA_MSBLQL  := "2"
SRA->(MsUnLock())

ENDIF

Return(lRet)
