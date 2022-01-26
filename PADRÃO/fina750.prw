#INCLUDE "fina750.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINA750	� Autor � Claudio D. de Souza   � Data � 12/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela unica do contas a pagar, que permitira ao usuario     ���
���          � manipular as opcoes distribuidas nos menus de contas a Pag.���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function FinA750
PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := STR0012 //"Contas a Pagar"


//�����������������������������������������������������Ŀ
//� Ponto de entrada para pre-validar os dados a serem  �
//� exibidos.                                           �
//�������������������������������������������������������
IF ExistBlock("F750BROW")
	ExecBlock("F750BROW",.f.,.f.)
Endif

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE											  �
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"))

Return Nil


/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �28/11/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRot080 := {}            
Local aRot050 := {}
Local aRot090 := {}
Local aRot240 := {}  
Local aRot241 := {}
Local aRot290 := {}
Local aRot390 := {}
Local aRot580 := {}
Local aRot426 := {}
Local aRotina := {}
Local lAgrBot := GetNewPar("MV_BOTFUNP",.F.)	//Agrupa as Baixas e Borderos em sub-menus.
Local aRot080A:= {}
Local aRot240A:= {}

aRot080 :=	{	{ STR0014, "Fin750080" , 0 , 4},; //"Baixar"
					{ STR0015, "Fin750080" , 0 , 4},; //"Lote"
					{ STR0016, "Fin750080" , 0 , 5},; //"Canc Baixa"
					{ STR0017, "Fin750080" , 0 , 5,53}} //"Excluir Baixa"

//Passado como parametro a posicao da opcao dentro da arotina
aRot050 :=	{	{ STR0018, "Fin750050", 0 , 3},; //"Incluir"
					{ STR0019, "Fin750050", 0 , 4},;  //"Alterar"
					{ STR0020, "Fin750050", 0 , 5},; //"Excluir"
					{ STR0021, "Fin750050", 0 , 6} } //"Substituir"

If CtbInUse() .Or. MV_MULNATP
	Aadd(aRot050, { STR0022,"Fin750050", 0 , 2}) //"Vis Rateio"
Endif

aRot090 :=	{	{ STR0023, "Fin750090"   ,0,1},; //"Par�metros"
					{ STR0024, "Fin750090"   ,0,4} } //"Autom�tica"

If cPaisLoc != "BRA"
	Aadd(aRot090, { STR0025,"Fin750090", 0 , 2}) //"Cancela Chq"
EndIf

aRot240 :=	{	{ STR0026, "Fin750240",0,3},; //"Border�"
					{ STR0027, "Fin750240",0,3} } //"Cancelar"    
					
aRot241 :=	{	{ STR0039, "Fin750241",0,3},; //"Border� Imp."
					{ STR0027, "Fin750241",0,3} } //"Cancelar"					

aRot290 :=	{	{ STR0028, "Fin750290",0,3},; //"Selecionar"
					{ STR0027, "Fin750290",0,6} } //"Cancelar"

aRot340 :=	{	{ STR0028, "Fin750340",0,4},; //"Selecionar"
					{ STR0027, "Fin750340",0,6},; //"Cancelar"
					{ STR0037, "Fin750340",0,6} } //"Estornar"
					
aRot390 :=	{	{ STR0029, "Fin750390",0,2},; //"Chq s/Tit"
					{ STR0030, "Fin750390",0,2},; //"Avulsos"
					{ STR0031, "Fin750390",0,2},; //"Redeposito"
					{ STR0027, "Fin750390",0,3} } //"Cancelar"

aRot580 :=	{	{ STR0032, "Fin750580",0,2},; //"Manual"
					{ STR0033, "Fin750580",0,2},; //"Automatica"
					{ STR0027, "Fin750580",0,2} } //"Cancelar"

aRot426 :=	{	{ STR0034, "Fin750426",0,3},; //"Gerar Arquivo"
					{ STR0035, "Fin750426",0,0}	 } //"Receber Arquivo"

If lAgrBot
	//��������������������������������������������������������������Ŀ
	//� Agrupa as baixas em sub-menus.							     �
	//����������������������������������������������������������������
	aRot080A :=	{	{ STR0003,aRot080,0,4},;	//"Bai&xa Manual"
					{ STR0004,aRot090,0,4}}		//"Baixa &Autom."
	
	//��������������������������������������������������������������Ŀ
	//� Agrupa os borderos em sub-menus.							 �
	//����������������������������������������������������������������
	aRot240A :=	{	{ STR0026,aRot240,0,3},; 	//"Border�"
					{ STR0039,aRot241,0,1} } 	//"Border� Imp."
EndIf
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa 	  �
//� ----------- Elementos contidos por dimensao ------------	  �
//� 1. Nome a aparecer no cabecalho 									  �
//� 2. Nome da Rotina associada											  �
//� 3. Usado pela rotina													  �
//� 4. Tipo de Transa��o a ser efetuada								  �
//�	 1 -Pesquisa e Posiciona em um Banco de Dados				  �
//�	 2 -Simplesmente Mostra os Campos								  �
//�	 3 -Inclui registros no Bancos de Dados						  �
//�	 4 -Altera o registro corrente									  �
//�	 5 -Exclui um registro cadastrado								  �
//����������������������������������������������������������������
aAdd( aRotina,	{ STR0001, "AxPesqui" , 0 , 1,,.F.})  //"Pesquisar"
aAdd( aRotina,	{ STR0013,"Fa050Visua", 0 , 2})  //"Visualizar"
aAdd( aRotina,	{ STR0036,aRot050, 0 , 3}) //"Contas a Pagar"
If !lAgrBot
	aAdd( aRotina,	{ STR0003,aRot080, 0 , 5})  //"Baixa &Manual"
	aAdd( aRotina,	{ STR0004,aRot090, 0 , 4}) //"Baixa &Autom."
	aAdd( aRotina,	{ STR0005,aRot240, 0 , 5}) //"&Border�"   
	aAdd( aRotina,	{ STR0038,aRot241, 0 , 5}) //"Bo&rder� Imp."   
Else	
	aAdd( aRotina,	{ STR0040,aRot080A, 0 , 3}) //"Bai&xas"
	aAdd( aRotina,	{ STR0041,aRot240A, 0 , 5}) //"&Border�s"
EndIf
aAdd( aRotina,	{ STR0006,aRot290, 0 , 6}) //"&Faturas"
aAdd( aRotina,	{ STR0007,aRot340, 0 , 6}) //"Co&mpensa��o"
aAdd( aRotina,	{ STR0008,aRot390, 0 , 6}) //"Cheq s/&T�tulo"
aAdd( aRotina,	{ STR0009,aRot580, 0 , 6}) //"Lib p/Pagto"
aAdd( aRotina,	{ STR0010,aRot426, 0 , 6}) //"C&NAB"
aAdd( aRotina,	{ STR0011,"FA040Legenda", 0 , 6, ,.F.}) //"Le&genda"
               
//��������������������������������������������������������������Ŀ
//� P.E. utilizado para adicionar itens no Menu da mBrowse       �
//����������������������������������������������������������������
If ExistBlock("FA750BRW")
	aRotAdic := ExecBlock("FA750BRW",.F.,.F.,{aRotina})
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf


Return(aRotina)  

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750080	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de baixa.                                             ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750080(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())
	
	Do Case 
	Case nOpc == 1
		FINA080(,3,.T.)
	Case nOpc == 2
		FINA080(,4,.T.)	
	Case nOpc == 3
		FINA080(,5,.T.)
	Case nOpc == 4
		FINA080(,6,.T.)
	EndCase	
	
	Set Filter to &cFilter
	
SE2->(DbSetOrder(nOrd))
Return	

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750050	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de contas a pagar. Inclusao, alteracao e etc.         ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750050(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		FinA050(,, 3 )
	Case nOpc == 2
		FinA050(,, 4 )	
	Case nOpc == 3
		FinA050(,, 5 )
	Case nOpc == 4
		FinA050(,, 6 )
	Case nOpc == 5
		FinA050(,, 8 )		
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	      

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750090	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de baixas automaticas.                                ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750090(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		FinA090(2)
	Case nOpc == 2
		FinA090(3)	
	Case nOpc == 3
		FinA090(3)
	EndCase	

	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	     

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750240	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de bordero de pagamento.                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750240(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina240(2)
	Case nOpc == 2
		Fina240(3)
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750241	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de bordero de pagamento.                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750241(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina241(2)
	Case nOpc == 2
		Fina241(3)
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	         

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750290	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de fatura.                                            ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750290(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina290(3)
	Case nOpc == 2
		Fina290(4)
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	             

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750340	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de compensacao entre titulos.                         ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750340(cAlias, nReg, nOpc)

Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina340(3)
	Case nOpc == 2
		Fina340(4)
	Case nOpc == 3
		Fina340(5)		
	EndCase	
	
	Set Filter to &cFilter
	
Return	 

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750390	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de compensacao entre titulos.                         ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750390(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina390(2)
	Case nOpc == 2
		Fina390(3)
	Case nOpc == 3
		Fina390(4)		
	Case nOpc == 4
		Fina390(5)		
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	  

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750580	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de liberacao de titulos.                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750580(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina580(2)
	Case nOpc == 2
		Fina580(3)
	Case nOpc == 3
		Fina580(4)		
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���  Fun��o	 � FINA750426	� Autor � Pedro Pereira Lima    � Data � 28/12/07 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para manter a consistencia dos filtros utilizados nas  ���
���          � rotinas de sub-menu cnab.                                     ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
Function Fin750426(cAlias, nReg, nOpc)
Local nOrd := 	SE2->(IndexOrd())
Local cFilter := SE2->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina426(2)
	Case nOpc == 2
		Fina426(3)
	EndCase	
	
	Set Filter to &cFilter
SE2->(DbSetOrder(nOrd))
Return	
