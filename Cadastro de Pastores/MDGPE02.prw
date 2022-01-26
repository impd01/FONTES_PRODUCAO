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

//��������������������������������������������������������������Ŀ
//� Posiciona registros para getdados                            �
//����������������������������������������������������������������
If dbSeek( xFilial( "SZ2" ) + _cMat)
	_nRecno:= SZ2->( Recno())
	_nOpcX:=4
Endif

//��������������������������������������������������������������Ŀ
//� Carrega aHeader do Alias a ser usado na Getdados             �
//����������������������������������������������������������������
aHeader := CargaHeader( _cAlias, _cCpoExc )

//��������������������������������������������������������������Ŀ
//� nOpcX 3 = Inclusao                                           �
//����������������������������������������������������������������
If _nOpcX == 3

	//��������������������������������������������������������������Ŀ
	//� Carrega aCols com dados iniciais para a inclusao de linha na �
	//� Getdados.                                                    �
	//����������������������������������������������������������������
	aCols := CarIncCols( _cAlias, aHeader, "Z2_ITEM", 3, _cCpoExc )


//��������������������������������������������������������������Ŀ
//� Demais valores para _nOpcX                                   �
//� 1=Pesquisar                                                  �
//� 2=Visualizar                                                 �
//� 4=Alterar                                                    �
//� 5=Excluir                                                    �
//����������������������������������������������������������������
else

	//��������������������������������������������������������������Ŀ
	//� Carrega aCols com dados de Enderecos selecionada no Browse   �
	//� principal ( no caso de alteracao, exclusao ou visualizacao ) �
	//����������������������������������������������������������������
	aCols := CargaCols( aHeader, _cAlias, 1, xFilial( "SZ2" ) + _cMat, _bWhile, _cCpoExc )

Endif

/*
��������������������������������������������������������������������������������������Ŀ
� Array para get no cabecalho da Tela estilo modelo2. Parametros:                      �
�                                                                                      �
� aC[n,1] =  Nome da Variavel Ex.:"cCliente"                                           �
� aC[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL             �
� aC[n,3] =  Titulo do Campo                                                           �
� aC[n,4] =  Picture                                                                   �
� aC[n,5] =  Nome da funcao para validacao do campo                                    �
� aC[n,6] =  F3                                                                        �
� aC[n,7] =  Se campo e' editavel .t. se nao .f.                                       �
����������������������������������������������������������������������������������������
*/

AADD( _aCpoCab,{ "_cMat"   	    ,{ C(15), C(010) } , OemToAnsi("Matricula")	, "@!"    , "",""	,.F.})


/*
��������������������������������������������������������������������������������������Ŀ
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
����������������������������������������������������������������������������������������
*/

/*
��������������������������������������������������������������Ŀ
� Array com as coordenadas para a Getdados na tela             �
����������������������������������������������������������������
*/
_aCoord := { C(053), C(005), C(118), C(315) }
_aTamWnd:= { C(100), C(100), C(400), C(750) }

/*
�����������������������������������������������������������������������������������������������Ŀ
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
�������������������������������������������������������������������������������������������������
*/

_lRetMod2Ok := Modelo2( _cTitulo, _aCpoCab , _aCpoRod, _aCoord, _nOpcx, "AllwaysTrue()","U_VLDGPE2()",aCpoGDa,, "+Z2_ITEM",999,_aTamWnd,,.T. )

// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

//��������������������������������������������������������������Ŀ
//� Operacao confirmada. Efetuando gravacao dos registros        �
//����������������������������������������������������������������
If _lRetMod2Ok

	Begin Transaction

		dbSelectArea( "SZ2" )
		dbSetOrder( 2 )

			//��������������������������������������������������������������Ŀ
		//� Efetua gravacao de todos os itens da Getdados                �
		//����������������������������������������������������������������
		For _nx := 1 to Len( aCols )

			//��������������������������������������������������������������Ŀ
			//� Trata primeira linha do getdados quando ao ha inclusao       �
			//����������������������������������������������������������������
			If Empty( aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ITEM" } ) ] )
				alert("entrou no loop")
				Loop
			Endif

			_lAchou := SZ2->( dbSeek( xFilial( "SZ2" ) +  aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z2_ITEM" } ) ] + _cMat   ) )

			//��������������������������������������������������������������Ŀ
			//� Faz tratamento para exclusao                                 �
			//����������������������������������������������������������������
			If ( ( aCols[ _nx, Len( aHeader ) +1 ] .and. _nOpcX == 4 ) .or. _nOpcX == 5 ) .and. _lAchou

				RecLock( "SZ2", .F. )
				dbDelete()
				MsUnLock()

			//��������������������������������������������������������������Ŀ
			//� Faz tratamento para inclusao ou alteracao                    �
			//����������������������������������������������������������������
			elseif !aCols[ _nx, Len( aHeader ) +1 ]

				//��������������������������������������������������������������Ŀ
				//� Somente em caso de inclusao gravar a chave do registro       �
				//����������������������������������������������������������������
				If !_lAchou
					RecLock( "SZ2", .T. )
					SZ2->Z2_FILIAL	:= xFilial("SZ2")
					SZ2->Z2_MAT 	:= SRA->RA_MAT

					//Z21->Z21_ITEM	:= aCols[ _nx, aScan( aHeader, { |x| alltrim( x[2] ) == "Z21_ITEM" } ) ]
					MsUnLock()

				Endif

				//��������������������������������������������������������������Ŀ
				//� Faz a gravacao dos demais campos tanto para inclusao quanto  �
				//� para alteracao.                                              �
				//����������������������������������������������������������������
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
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������ͻ��
���Programa � CargaHeader     �Autor� Antonio Marcos Andriani    � Data � 01/08/2013 ���
������������������������������������������������������������������������������������͹��
���Desc.    � Rotina para carregar variavel array aHeader baseada no SX3 do Alias    ���
���         � passado no parametro.                                                  ���
������������������������������������������������������������������������������������͹��
���Parametr � ExpC1 = Alias do arquivo a ser usado na getdados.                      ���
���         � ExpC2 = String com os campos que nao deverao aparecer na Getdados      ���
���         �         mesmo estando marcados como 'browse' no arquivo SX3.           ���
������������������������������������������������������������������������������������͹��
���Uso      � Exclusivo Evora                                                        ���
������������������������������������������������������������������������������������͹��
���                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ���
������������������������������������������������������������������������������������͹��
���  Programador  �  Data   � Motivo da Alteracao                                    ���
������������������������������������������������������������������������������������͹��
���               �         �                                                        ���
������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
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
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������ͻ��
���Programa � CarIncCols      �Autor� Antonio Marcos Andriani    � Data � 01/08/2013 ���
������������������������������������������������������������������������������������͹��
���Desc.    � Rotina que carrega a variavel array aCols com valores iniciais na      ���
���         � inclusao do registro.                                                  ���
������������������������������������������������������������������������������������͹��
���Parametr.� ExpC1 = Alias do arquivo a ser usado na Getdados                       ���
���         � ExpC2 = Variavel array com o Header do Alias a ser usado               ���
���         � ExpC3 = Variavel opcional. Caso existe um campo que precise ser nume-  ���
���         �         radi sequencialmente, informar nessa variavel o nome.          ���
���         � ExpC4 = Tamanho do campo sequencial item ( ExpC3 ). O Default e 2.     ���
���         � ExpC5 = String com os campos que nao deverao aparecer na Getdados      ���
���         �         mesmo estando marcados como 'browse' no arquivo SX3.           ���
���         �                                                                        ���
������������������������������������������������������������������������������������͹��
���Uso      � Exclusivo Evora                                                        ���
������������������������������������������������������������������������������������͹��
���                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ���
������������������������������������������������������������������������������������͹��
���  Programador  �  Data   � Motivo da Alteracao                                    ���
������������������������������������������������������������������������������������͹��
���               �         �                                                        ���
������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
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
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������ͻ��
���Programa � CargaCols       �Autor� Antonio Marcos Andriani    � Data � 01/08/2013 ���
������������������������������������������������������������������������������������͹��
���Desc.    � Rotina para carregar os dados de um determinado alias ( baseado no     ���
���         � Header ) para a Getdados usada ( alteracao, exclusao, visual ).        ���
������������������������������������������������������������������������������������͹��
���Parametr.� ExpA1 = Variavel array com o Header do Alias a ser usado               ���
���         � ExpC2 = Alias do arquivo a ser usado na Getdados                       ���
���         � ExpN3 = Indice chave do alias                                          ���
���         � ExpC4 = Chave a ser pesquisado ( dbSeek inicial )                      ���
���         � ExpB5 = Code Block a ser usado no Do while para carregar os dados      ���
���         � ExpC6 = String com os campos que nao deverao aparecer na Getdados      ���
���         �         mesmo estando marcados como 'browse' no arquivo SX3.           ���
���         �                                                                        ���
������������������������������������������������������������������������������������͹��
���Uso      � Exclusivo Evora                                                        ���
������������������������������������������������������������������������������������͹��
���                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ���
������������������������������������������������������������������������������������͹��
���  Programador  �  Data   � Motivo da Alteracao                                    ���
������������������������������������������������������������������������������������͹��
���               �         �                                                        ���
������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
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
MSGALERT("Somente uma entrevista pode ter aprova��o!!!")
lRet:=.F.
ENDIF

IF nQtdAp == 1

RecLock( "SRA", .F. )

SRA->RA_XSTATUS := "1"
SRA->RA_MSBLQL  := "2"
SRA->(MsUnLock())

ENDIF

Return(lRet)
