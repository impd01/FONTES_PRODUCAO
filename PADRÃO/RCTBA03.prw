#include "dbtree.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "protheus.ch"
#DEFINE GD_INSERT	1
#DEFINE GD_DELETE	4	
#DEFINE GD_UPDATE	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA03   ºAutor  ³Montes - Oficina1   º Data ³ 13/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de Rateio                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VALORA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBA03()
                  
Local aCores  := 	{{	"SZ2->Z2_TIPREG == '1'", "BR_VERDE"		},;		// Origem
					{	"SZ2->Z2_TIPREG == '3'", "BR_AZUL" 	}}          // Destino

Private aRotina := MenuDef()
					
Private cCadastro := "Rateio Contabil - Especifico Valora"
Private aTelas    := {}
Private lAlterDis := .F.                    

//If !SM0->M0_CODIGO $ "99/"  
//   MsgStop("Empresa não autorizada a utilizar esta rotina!")
//   Return()
//EndIf

mBrowse( 6, 1,22,75,"SZ2",,,,,,aCores )

Return Nil                              

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTBA03Man ³ Autor ³ Montes - Oficina1     ³ Data ³ 13/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±            
±±³Descri‡„o ³ Esta rotina permite a manutencao de Visualizacao, Inclusao,³±±
±±³          ³ Alteracao e Exclusao de Rateios Especificos Valora         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_CTBA03MAN(cAlias,nReg,nOpc,lDup)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias= Alias do arquivo                                   ³±±
±±³          ³ nReg  = Numero do registro                                 ³±±
±±³          ³ nOpc  = Opcao selecionada                                  ³±±
±±³          ³ lDup  = Determina que esta rotina foi chamada pela rotina  ³±±
±±³          ³         "Duplicar" quando .T.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ U_RCTBA03                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03Man(cAlias,nReg,nOpc,lDup)
Local oDlg                        		// Janela de dados
Local aBotoes      := {}               	// Botoes especificos da Enchoice
Local aUser        := {}				// Vetor com as informacoes do usuario do sistema 
Local cCodCur      := ""               	// Codigo auxiliar usado na opcao Duplicar   
Local cCampo       := ""               	// Auxiliar para criacao das colunas do aCols
Local nSavRec      := SZ2->(RecNo())   	// Guarda posicao da linha da MBrowse      
Local aLinGD       := 0  				// Array contendo linha auxiliar para geracao do aCols
Local nInd         := 0  				// Contador de laco For/Next
Local cCpoVar      := ""				// Campos para criacao de variaveis de memoria
Local cUserID      := ""				// Codigo do usuario do sistema
Local nOpca        := 0  				// Recebe o valor de saida da DIALOG - Quando "1" operacao foi confirmada
Local nElem        := 0
Local nPosPer
Local nPosPerLet
Local nPosHabili
Local nPosDesLet
Local nPosCarga
Local nPosCriava
Local nPosEqvCon
Local nPosECDesc
Local cCriava
Local cEqvCon
Local cECDesc
Local i
Local nStyle		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com os campos que deve ter o conteudo alterado na Duplicacao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCpoZero := { }
Local aPages	  := {}
Local aTitles     := {}
Local aExibe  := {"Z2_NUMRATE","Z2_PERINIC","Z2_PERFINA"}	// Campos exibidos na Enchoice()
Local aAltera := {"Z2_PERINIC","Z2_PERFINA"}   // Campo editavel da Enchoice()

Private aSize	  := MsAdvSize(,.F.,430)
Private aObjects  := {} 
Private aPosObj   := {} 
Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

AAdd( aObjects, { 100, 30, .T., .T. } ) //AAdd( aObjects, { 315,  70, .T., .t. } )
AAdd( aObjects, { 100, 100, .T., .T. } ) //AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 0, 0 } //aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects, .T. ) //aPosObj := MsObjSize( aInfo, aObjects ) 

lDup   := If(ValType(lDup)=="L",lDup,.f.) 		// Parametro recebido pela funcao

Private nUsado := 0
Private aTela[0,0]
Private aGets[0]
Private aHeader[0] 
Private aHeader2[0]
Private oGetd 
Private nSaveSX8SZ2 := GetSX8Len()
Private cFilOri	:= if( lDup, SZ2->Z2_FILIAL, xFilial("SZ2") )  //Variavel armazema a filial de origem quando for replicacao

If nOpc = 9
   nOpc := 3
EndIf

if nOpc == 4 .Or. nOpc == 5 
	if !SoftLock("SZ2") // bloqueia o registro nas rotinas de alteracao e exclusao
		Return
	endif
endif	

If nOpc == 3 .or. nOpc == 4 //.or. nOpc == 9            
	nStyle := GD_INSERT+GD_DELETE+GD_UPDATE
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Muda caracteristica da manutencao quando opcao Duplicar registro para ³
//³inicializacao de variaveis como sendo alteracao						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDup
   INCLUI := .F.
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis de memoria e gera o aHeader do arquivo SZ2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory(cAlias,INCLUI)
            
cKeySZ2 := cFilOri+M->Z2_NUMRATE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incrementa codigo quando opcao Duplicar registro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDup	
	cCodSZ2 := SZ2->Z2_NUMRATE
	M->Z2_NUMRATE := CriaVar("Z2_NUMRATE") 
    AADD(aAltera,"Z2_NUMRATE")
EndIf                         

If Inclui
   AADD(aAltera,"Z2_NUMRATE")
EndIf
	
dbSelectArea("SZ2")		
dbSetOrder(1)   		
	
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZ2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o aHeader para os campos da GetDados - SZ2  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof() .And. (X3_ARQUIVO == "SZ2")
	
	If Alltrim(X3_CAMPO) $ "Z2_CONTA;Z2_CC;Z2_ITEM;Z2_CLVL;Z2_PERCENT;" .Or. ;
  	  ( X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. !Alltrim(X3_CAMPO) $ "Z2_FILIAL;Z2_NUMRATE;Z2_PERINIC;Z2_PERFINA;Z2_TIPREG;" )
	                                             
	  If	!Alltrim(X3_CAMPO) == "Z2_PERCENT"
		 Aadd(aHeader,{ alltrim( X3Titulo() )	,;
						     X3_CAMPO	,; 
						     X3_PICTURE	,;
							 X3_TAMANHO	,;
							 X3_DECIMAL	,;
							 X3_VALID	,;
						 	 X3_USADO	,;
						 	 X3_TIPO	,;
						 	 X3_F3	    ,;  //X3_ARQUIVO
						 	 X3_CONTEXT } )	
	  EndIf	
	  If	!Alltrim(X3_CAMPO) == "Z2_CONTA"   // Marcio --> Alterado para retirar a coluna CONTA CONTABIL do DESTINO			 	 
	     Aadd(aHeader2,{ alltrim( X3Titulo() )	,;
						     X3_CAMPO	,; 
						     X3_PICTURE	,;
							 X3_TAMANHO	,;
							 X3_DECIMAL	,;
							 X3_VALID	,;
						 	 X3_USADO	,;
						 	 X3_TIPO	,;
						 	 X3_F3	    ,;  //X3_ARQUIVO
						 	 X3_CONTEXT } )	
	  Endif

	EndIf

	dbSkip()
	
EndDo          

ADHeadRec("SZ2",aHeader)
ADHeadRec("SZ2",aHeader2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o aCols e aCols2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols  := {} //Array( 1, Len(aHeader) +  1 )
aCols2 := {} //Array( 1, Len(aHeader2) +  1 )

nSoma := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aCols                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ2")                                                                                                             
SZ2->(DbSetOrder(1))
If SZ2->(dbSeek(cKeySZ2 )) 
	While SZ2->(!EOF()) .And. SZ2->(Z2_FILIAL+Z2_NUMRATE) == cKeySZ2

	    If SZ2->Z2_TIPREG == "1" //Origem
		   AADD(aCols,Array(Len(aHeader)+1))
           nCont := LEN(aCols)
           
           For nX := 1 To Len(aHeader)-2
			   aCols[nCont,nX] := &("SZ2->"+aHeader[nX,2])
		   Next nX                        
		
		   aCols[nCont,Len(aHeader)-1] := "SZ2"
		   aCols[nCont,Len(aHeader)]   := SZ2->(Recno())
		   aCols[nCont,Len(aHeader)+1] := .F.  
		
	    Else
		   AADD(aCols2,Array(Len(aHeader2)+1))
           nCont := LEN(aCols2)

           For nX := 1 To Len(aHeader2)-2
			   aCols2[nCont,nX] := &("SZ2->"+aHeader2[nX,2])
			   If AllTrim(aHeader2[nX,2]) == "Z2_PERCENT"
				  nSoma += SZ2->Z2_PERCENT
			   EndIf
		   Next nX                        
		
		   aCols2[nCont,Len(aHeader2)-1] := "SZ2"
		   aCols2[nCont,Len(aHeader2)]	 := SZ2->(Recno())
		   aCols2[nCont,Len(aHeader2)+1] := .F.  

	    EndIf
			
		SZ2->(dbSkip())
	Enddo  
EndIf

If LEN(aCols) == 0     
   aAdd(aCols,Array(Len(aHeader)+1))

   For nX := 1 to Len(aHeader)-2
   		aCols[1,nX] := CriaVar(aHeader[nX,2])
   Next nX
   
   aCols[1,Len(aHeader)-1] := "SZ2"
   aCols[1,Len(aHeader)]   := 0
   aCols[1,Len(aHeader)+1] := .F.  
EndIf
       
If LEN(aCols2) == 0
   aAdd(aCols2,Array(Len(aHeader2)+1))

   For nX := 1 to Len(aHeader2)-2
   		aCols2[1,nX] := CriaVar(aHeader2[nX,2])
   Next nX
   
   aCols2[1,Len(aHeader2)-1] := "SZ2"
   aCols2[1,Len(aHeader2)]	 := 0
   aCols2[1,Len(aHeader2)+1] := .F.  
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura variaveis do Objeto Folder.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aTitles,"Origem - Dados para Rateio") 
Aadd(aTitles,"Destino") 
		
Aadd(aPages,"HEADER")
Aadd(aPages,"HEADER")

If Len(aPosObj) == 0
	aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
EndIf
aPosGetD := { 5, 5, (aPosObj[ 2, 3 ]-aPosObj[ 2, 1 ]) - 18, aPosObj[ 2, 4 ] - 8 }
		

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( cAlias, nReg, nOpc,,,,aExibe, aPosObj[1], aAltera, , , , , , ,.T. )

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Objeto Folder.                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],aTitles,aPages,oDlg,,,,.T.,.T.,aPosObj[2,4],aPosObj[2,3])
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consistencia a cada mudanca de pasta do Objeto Folder                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oFolder:bSetOption := { |nAtu| xxxxxxMuda(nAtu, oFolder:nOption, @oDlg, @oFolder)}
		
	For nCntFor := 1 To Len(oFolder:aDialogs)
	    oFolder:aDialogs[nCntFor]:oFont := oDlg:oFont
	Next nCntFor

	oGetd  := MsNewGetDados():New(aPosGetD[1],aPosGetD[2],aPosGetD[3],aPosGetD[4],nStyle,"U_CTBA03LOk(1)"  ,"Allwaystrue",,,,,,Len(aCols) ,,oFolder:aDialogs[1],aHeader                  ,aCols )

	oGetd2 := MsNewGetDados():New(aPosGetD[1],aPosGetD[2],aPosGetD[3],aPosGetD[4],nStyle,"U_CTBA03LOk(2)"  ,"Allwaystrue",,,,,,Len(aCols2),,oFolder:aDialogs[2],aHeader2                ,aCols2 )

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .And. U_CTBA03TOk(0) /*oGetd:TudoOk()*/,(nOpca:=1,oDlg:End()),nOpca := 0)},{||oDlg:End()},,aBotoes)

IF nOpcA == 1 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua gravacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc == 3 .or. nOpc == 4 .or. nOpc == 5
		msAguarde({|| CTBA03Grv(nOpc)},"Atualizando Registros...")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incrementa codigo quando opcao Duplicar registro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lDup
		While (GetSX8Len() > nSaveSX8SZ2)
			ConfirmSX8()
		End
	Endif	
		
Else
	RollBackSX8()
Endif

SZ2->( msUnlock() )

dbSelectArea(cAlias)

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTBA03LOK ³ Autor ³ Montes                ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para validação da linha na getdados                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Valora                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03LOK(nGetDados)
Local lRetorno := .T.

If nGetDados = 1
   //aCols[n]
ElseIf nGetDados = 2
   //aCols2[n]
                         
   /*
   Chama a função de validação do tudook para validar os preechimentos
   */             
   lRetorno := U_CTBA03TOK(nGetDados)                           
    
EndIf

Return( .T. )         


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTBA03TOK ³ Autor ³ Montes                ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para validação do Botao Tudo Ok                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Valora                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03TOK(nGetDados)

Local lRetorno := .T.
Local nPercent := 0
Local nPPercent := Ascan( aHeader2, {|x| AllTrim(x[2])  == "Z2_PERCENT"})

nPercent := 0
For nL := 1 To Len(oGetd2:aCols)
    If !oGetd2:aCols[nL][Len(aHeader2)+1]
       nPercent += oGetd2:aCols[nL][nPPercent]
    EndIf
Next
   
If nPercent > 100
   Msgstop("Soma dos percentuais para o destino não pode ser superior a 100%")
   lRetorno := .F.   
ElseIf nGetDados == 0 .And. nPercent < 100 //Somente na confirmação do tudo ok
   If !MsgYesNo("Soma dos percentuais para o destino inferior a 100%! Deseja continuar ?")
      lRetorno := .F.
   EndIf      
EndIf

Return( lRetorno )         

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTBA03Leg ³ Autor ³ Montes                ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Valora                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03Leg()

BrwLegenda( "Cadastro de Rateio", "Legenda",{ {'BR_VERDE'     	, "Registro de Origem"},;  							
							                  {'BR_VERMELHO' 	, "Registro de Destino"}}) 							
Return( .T. )         

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTBA03Dup ³ Autor ³ Montes - Oficina1     ³ Data ³ 13/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±            
±±³Descri‡„o ³ Possibilita a inclusao de um novo Rateio a partir de um ja ³±±
±±³          ³ existente                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBA03Dup(cAlias,nReg,nOpc)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias= Alias do arquivo                                   ³±±
±±³          ³ nReg  = Numero do registro                                 ³±±
±±³          ³ nOpc  = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA03                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03Dup(cAlias,nReg,nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a chamada da rotina de inclusao de Cursos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_CTBA03Man(cAlias,nReg,9,.T.)

Return(Nil)

                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Montes - Oficina1   º Data ³13/09/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aRotina 	:= 	{}

aAdd( aRotina, { "Pesquisar", "AxPesqui" , 0, 1} )		//
aAdd( aRotina, { "Visualizar", "U_CTBA03Man", 0, 2} )	//
aAdd( aRotina, { "Incluir", "U_CTBA03Man", 0, 3, 81} )//
aAdd( aRotina, { "Alterar", "U_CTBA03Man", 0, 4, 82} )//
aAdd( aRotina, { "Excluir", "U_CTBA03Man", 0, 5, 3} )	//
aAdd( aRotina, { "Duplicar", "U_CTBA03Dup", 0, 9} )	//
aAdd( aRotina, { "Gerar Lançamento", "U_CTBA03Ger", 0, 6} )	//
aAdd( aRotina, { "Legenda", "U_CTBA03Leg", 0, 2} )	//

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA03Grv ºAutor  ³Montes - Oficina1   º Data ³ 23/11/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³ Função de gravação                                         ³±±
±±³          ³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VALORA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                              
Static Function CTBA03Grv(nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local lGrava 	:= If(nOpc == 3,.T.,.F.)  
Local nX,nX2	:= 0                   


Local nPosRec	  := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_REC_WT"})
Local nPosConta	  := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_CONTA"})
Local nPosCC	  := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_CC"})
Local nPosItem	  := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_ITEM"})
Local nPosClVl	  := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_CLVL"})
Local nPosPercent := Ascan(oGetD:aHeader,{|x| Alltrim(x[2]) == "Z2_PERCENT"})

Local nPs2Rec  	  := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_REC_WT"})
Local nPs2Conta	  := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_CONTA"})
Local nPs2CC	  := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_CC"})
Local nPs2Item	  := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_ITEM"})
Local nPs2ClVl	  := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_CLVL"})
Local nPs2Percent := Ascan(oGetD2:aHeader,{|x| Alltrim(x[2]) == "Z2_PERCENT"})
                                                                           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a manutencao nos registros de Origem                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
For nX := 1 To Len(oGetD:aCols)

	If nOpc == 5     //EXCLUI

		SZ2->(dbGoTo(oGetD:aCols[nX,nPosRec]))
	
		RecLock("SZ2",.F.)
		SZ2->(dbDelete())
		SZ2->(msUnlock())
	
	ElseIf nOpc == 3  //INCLUI                                     
	
		If !oGetD:aCols[nX,Len(oGetD:aHeader)+1]   
			RecLock("SZ2",lGrava)
			SZ2->Z2_FILIAL	:= xFilial("SZ3")
			SZ2->Z2_NUMRATE	:= M->Z2_NUMRATE  
			SZ2->Z2_PERINIC := M->Z2_PERINIC
			SZ2->Z2_PERFINA := M->Z2_PERFINA
            SZ2->Z2_TIPREG  := "1" //Origem
            SZ2->Z2_CONTA   := oGetD:aCols[nX,nPosConta]
            SZ2->Z2_CC      := oGetD:aCols[nX,nPosCC]
            SZ2->Z2_ITEM    := oGetD:aCols[nX,nPosItem]
            SZ2->Z2_CLVL    := oGetD:aCols[nX,nPosCLVL]
            SZ2->Z2_PERCENT := 100 
		    SZ2->(msUnlock())
		EndIf
		
	ElseIf nOpc == 4   //ALTERA                             
		
		If oGetD:aCols[nX,Len(oGetD:aHeader)+1]   
		    If !EMPTY(oGetD:aCols[nX,nPosRec]) 
			   SZ2->(dbGoTo(oGetD:aCols[nX,nPosRec]))         
			   RecLock("SZ2",.F.)
			   SZ2->(dbDelete())
			   SZ2->(msUnlock())
		    EndIf
			Loop
		ElseIf EMPTY(oGetD:aCols[nX,nPosRec]) 
			lGrava := .T.
		Else            
			SZ2->(dbGoTo(oGetD:aCols[nX,nPosRec]))         
			lGrava := .F.
		EndIf	
		
		RecLock("SZ2",lGrava)
		SZ2->Z2_FILIAL	:= xFilial("SZ3")
		SZ2->Z2_NUMRATE	:= M->Z2_NUMRATE  
		SZ2->Z2_PERINIC := M->Z2_PERINIC
		SZ2->Z2_PERFINA := M->Z2_PERFINA
        SZ2->Z2_TIPREG  := "1" //Origem
        SZ2->Z2_CONTA   := oGetD:aCols[nX,nPosConta]
        SZ2->Z2_CC      := oGetD:aCols[nX,nPosCC]
        SZ2->Z2_ITEM    := oGetD:aCols[nX,nPosItem]
        SZ2->Z2_CLVL    := oGetD:aCols[nX,nPosCLVL]
        SZ2->Z2_PERCENT := 100 
		SZ2->(msUnlock())
	EndIf
	
Next nX // Marcio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a manutencao nos registros de Destino                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	nX2 := 1
	For nX2 := 1 To Len(oGetD2:aCols)
	
		If nOpc == 5 //EXCLUI
		
			SZ2->(dbGoTo(oGetD2:aCols[nX2,nPs2Rec]))
		
			RecLock("SZ2",.F.)
			SZ2->(dbDelete())
			SZ2->(msUnlock())
	
		ElseIf nOpc == 3  //INCLUI                                     
	
			If !oGetD2:aCols[nX2,Len(oGetD2:aHeader)+1]   
				RecLock("SZ2",lGrava)
				SZ2->Z2_FILIAL	:= xFilial("SZ3")
				SZ2->Z2_NUMRATE	:= M->Z2_NUMRATE  
				SZ2->Z2_PERINIC := M->Z2_PERINIC
				SZ2->Z2_PERFINA := M->Z2_PERFINA
    	        SZ2->Z2_TIPREG  := "2" //Destino
    	        SZ2->Z2_CONTA   := ""//oGetD:aCols[nX,nPosConta] //oGetD2:aCols[nX2,nPs2Conta] //Marcio
    	        SZ2->Z2_CC      := oGetD2:aCols[nX2,nPs2CC]
    	        SZ2->Z2_ITEM    := oGetD2:aCols[nX2,nPs2Item]
    	        SZ2->Z2_CLVL    := oGetD2:aCols[nX2,nPs2CLVL]
    	        SZ2->Z2_PERCENT := oGetD2:aCols[nX2,nPs2Percent]
			    SZ2->(msUnlock())
			EndIf
		
		ElseIf nOpc == 4 //ALTERA                               
		
			If oGetD2:aCols[nX2,Len(oGetD2:aHeader)+1]   
			    If !EMPTY(oGetD2:aCols[nX2,nPs2Rec]) 
				   SZ2->(dbGoTo(oGetD2:aCols[nX2,nPs2Rec]))
				   RecLock("SZ2",.F.)
				   SZ2->(dbDelete())
				   SZ2->(msUnlock())
			    EndIf
				Loop
			ElseIf EMPTY(oGetD2:aCols[nX2,nPs2Rec]) 
				lGrava := .T.
			Else            
				SZ2->(dbGoTo(oGetD2:aCols[nX2,nPs2Rec]))         
				lGrava := .F.
			EndIf	
		
			RecLock("SZ2",lGrava)
			SZ2->Z2_FILIAL	:= xFilial("SZ3")
			SZ2->Z2_NUMRATE	:= M->Z2_NUMRATE
			SZ2->Z2_PERINIC := M->Z2_PERINIC
			SZ2->Z2_PERFINA := M->Z2_PERFINA
	        SZ2->Z2_TIPREG  := "2" //Destino
	        SZ2->Z2_CONTA   := ""//oGetD:aCols[nX,nPosConta] //oGetD2:aCols[nX2,nPs2Conta] //Marcio
	        SZ2->Z2_CC      := oGetD2:aCols[nX2,nPs2CC]
	        SZ2->Z2_ITEM    := oGetD2:aCols[nX2,nPs2Item]
	        SZ2->Z2_CLVL    := oGetD2:aCols[nX2,nPs2CLVL]
	        SZ2->Z2_PERCENT := oGetD2:aCols[nX2,nPs2PERCENT]
			SZ2->(msUnlock())
		EndIf
	
	Next nX2
//Next nX //Marcio
Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTBA03CTB ³ Autor ³ Montes                ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Contabilização de Rateio SZ2                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Valora                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBA03GER()
local cAlias  := GetNextAlias()
Local cCodSZ2 := SZ2->Z2_NUMRATE                                   
Local cKeySZ2 := xFilial("SZ2")+cCodSZ2    
local nY := 0
Local cQuery	:= ""          

Private aCT5IMP     := {}
Private nHdlPrv
Private nTotal      := 0
Private lDigita     := .T. //.F.
Private lAglutina   := .F.
Private cArquivo    := ""
                                      
PRIVATE dDatMov0 := SZ2->Z2_PERINIC //dDataBase
PRIVATE dDatMov  := SZ2->Z2_PERFINA //dDataBase
PRIVATE cMoeda   := "01"                                                      
PRIVATE cTpSaldo := "1"            
PRIVATE cLoteRate := "G00000" //GERENCIAL
PRIVATE cPadrao  := "EXC" //"RAT"
PRIVATE nSaldo := nValor := 0
                
If !MsgYesNo("Deseja realmente gerar lancamento em "+DTOC(dDatMov)+" referente ao rateio "+cCodSZ2+" ?")
   Return Nil
EndIf                


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa processamento da Contabilidade                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nValRate := 0
  If nHdlPrv = NIL
	   nHdlPrv := HeadProva(cLoteRate,"RCTBA03",Pad(Subs(cUsuario,7,6),6),@cArquivo)
   EndIf
   
   	cQuery	:= "SELECT *																	" + CRLF
	cQuery	+= "FROM " + RetSQLName("SZ2") + " SZ2											" + CRLF
	cQuery	+= "WHERE SZ2.D_E_L_E_T_ = ' '													" + CRLF
	cQuery	+= "AND Z2_NUMRATE = '" + cCodSZ2 +			 "'									" + CRLF
	cQuery	+= "AND Z2_PERINIC = '" + dtos(dDatMov0)+ "'									" + CRLF
	cQuery	+= "AND Z2_PERFINA = '" + dtos(dDatMov)+ "'										" + CRLF
//	cQuery	+= "AND Z2_CONTA   = '" + SZ2->Z2_CONTA + "'									" + CRLF	
	cQuery	+= "AND Z2_TIPREG  = '1'														" + CRLF	
	
	TCQUERY cQuery NEW ALIAS (cAlias)
	
	(cAlias)->(DbGoTop())
 	
     while !(cAlias)->(Eof())
    
      cConta := (cAlias)->Z2_CONTA
      cCusto := (cAlias)->Z2_CC
      cItem  := (cAlias)->Z2_ITEM
      cCLVL  := (cAlias)->Z2_CLVL
            
      cCusto2:= (cAlias)->Z2_CC
	  cItem2 := (cAlias)->Z2_ITEM
	  cCLVL2 := (cAlias)->Z2_CLVL  
	    
      nSaldo := 0
      
         If !EMPTY(cConta) .And. !EMPTY(cCusto) .And. !EMPTY(cItem) .And. !EMPTY(cCLVL)
          
	        aSaldo := SaldoCTI(cConta,cCusto,cItem,cClVL,dDatMov,cMoeda,cTpSaldo)  //aSaldo := SaldTotCTI(cClVL,cClVL,cItem,cItem,cCusto,cCusto,cConta,cConta,dDatMov,cMoeda,cTpSaldo)
	        aSaldoAnt := SaldoCTI(cConta,cCusto,cItem,cClVL,dDatMov0,cMoeda,cTpSaldo)
	        nSaldo := ( aSaldo[5] - aSaldo[4] ) -  ( aSaldoAnt[8] - aSaldoAnt[7] ) 
	        nValRate := (   aSaldo[4] - aSaldo[5] )  - ( aSaldoAnt[7] - ·aSaldoAnt[8] )  
	     
	     ElseIf !EMPTY(cConta) .And. !EMPTY(cCusto) .And. !EMPTY(cItem) .And. EMPTY(cCLVL)
          
            aSaldo := SaldoCT4(cConta,cCusto,cItem,dDatMov,cMoeda,cTpSaldo) //aSaldo := SaldTotCT4(cItem,cItem,cCusto,cCusto,cConta,cConta,dDatMov,cMoeda,cTpSaldo)
	        aSaldoAnt := SaldoCT4(cConta,cCusto,cItem,dDatMov0,cMoeda,cTpSaldo)
	        nSaldo :=  ( aSaldo[5] - aSaldo[4] ) -  ( aSaldoAnt[8] - aSaldoAnt[7] ) 
	        nValRate := (   aSaldo[4] - aSaldo[5] )  - ( aSaldoAnt[7] - aSaldoAnt[8] )
	        
	     ElseIf !EMPTY(cConta) .And. !EMPTY(cCusto) .And. EMPTY(cItem) .And. EMPTY(cCLVL)
		        
		    aSaldo := SaldoCT3(cConta,cCusto,dDatMov,cMoeda,cTpSaldo)		//aSaldo := SaldTotCT3(cCusto,cCusto,cConta,cConta,dDatMov,cMoeda,cTpSaldo)
	        aSaldoAnt := SaldoCT3(cConta,cCusto,dDatMov0,cMoeda,cTpSaldo)
	        nSaldo := ( aSaldo[5] - aSaldo[4] ) -  ( aSaldoAnt[8] - aSaldoAnt[7] )
	        nValRate := (   aSaldo[4] - aSaldo[5] )  - ( aSaldoAnt[7] - aSaldoAnt[8] ) 
		    
	     ElseIf !EMPTY(cConta) .And. EMPTY(cCusto) .And. EMPTY(cItem) .And. EMPTY(cCLVL)
		        
		    aSaldo := SaldoCT7(cConta,dDatMov,cMoeda,cTpSaldo)     //aSaldo := SaldTotCT7(cConta,cConta,dDatMov,cMoeda,cTpSaldo)
	        aSaldoAnt := SaldoCT7(cConta,dDatMov0,cMoeda,cTpSaldo)
	        nSaldo := ( aSaldo[5] - aSaldo[4] ) -  ( aSaldoAnt[8] - aSaldoAnt[7] )
	        nValRate := (   aSaldo[4] - aSaldo[5] )  - ( aSaldoAnt[7] - aSaldoAnt[8] ) 

	     EndIf
         
         //nValRate := 0 //Marcio 
         //nValRate += abs(nSaldo)          
         nValor := ABS(nSaldo)
         nValor2 := ABS(nSaldo) 

               //+--------------------------------------------------------------+
	         //¦ Inicializa o array de otimizacao dos lancamentos padronizados¦
	         //+--------------------------------------------------------------+
	         aCT5LANC := {}
	         aadd(aCT5LANC,{cPadrao,{}})
	         nX := Len(aCT5LANC)
	         nZ := 1
	         
	         dbSelectArea("CT5")
	         aadd(aCT5LANC[nX][2],{})
	         For nY := 1 To CT5->(FCount())
	             
	             cFieldName := CT5->(FieldName(nY))
				     xFieldGet  := CRIAVAR(cFieldName) 
				     If cFieldName = "CT5_LANPAD"
				        xFieldGet := cPadrao
				     ElseIf cFieldName = "CT5_SEQUEN"
				        xFieldGet := "002"
				     ElseIf cFieldName = "CT5_DEBITO"
				       xFieldGet := IIF(nSaldo<0,"M->cConta","")
				     ElseIf cFieldName = "CT5_CREDIT"
				       xFieldGet := IIF(nSaldo>0,"M->cConta","")
				     ElseIf cFieldName = "CT5_CCD"
				        xFieldGet := IIF(nSaldo<0,"M->cCusto2","")
				     ElseIf cFieldName = "CT5_CCC"
				        xFieldGet := IIF(nSaldo>0,"M->cCusto2","")
				     ElseIf cFieldName = "CT5_ITEMD"
				        xFieldGet := IIF(nSaldo<0,"M->cItem2","")
				     ElseIf cFieldName = "CT5_ITEMC"
				        xFieldGet := IIF(nSaldo>0,"M->cItem2","")
				     ElseIf cFieldName = "CT5_CLVLDB"
				        xFieldGet := IIF(nSaldo<0,"000001","")
				     ElseIf cFieldName = "CT5_CLVLCR"
				        xFieldGet := IIF(nSaldo>0,"000001","")
				     ElseIf cFieldName = "CT5_HIST"
				        xFieldGet := '"RATEIO DESTINO  '+cCodSZ2+'"'
				     ElseIf cFieldName = "CT5_ORIGEM"
				        xFieldGet := '"RATEIO DESTINO X- RCTBA03"'
				     ElseIf cFieldName = "CT5_VLR01"
				        xFieldGet := "M->nValor2"
				     ElseIf cFieldName = "CT5_DC"
				        If nSaldo < 0
				           xFieldGet := "1"  //Debito
				        ElseIf nSaldo > 0
				           xFieldGet := "2"  //Credito 
				        Else
				           xFieldGet := "3"  //Partida Dobrada		     			           
				        EndIf			             
				     EndIf
	                 aadd(aCT5LANC[nX][2][nZ],{cFieldName,xFieldGet})
	         Next nY          
	     
		     If nValor2 > 0
		    	nTotal += DETPROVA(nHdlPrv,cPadrao,"RCTBA03",cLoteRate,,,,,,aCT5LANC,.F.)                                                         
	      	 EndIf         
      	
         //+--------------------------------------------------------------+
         //¦ Inicializa o array de otimizacao dos lancamentos padronizados¦
         //+--------------------------------------------------------------+                          
/*         aCT5LANC := {}
         aadd(aCT5LANC,{cPadrao,{}})
         nX := Len(aCT5LANC)
         nZ := 1
        
         dbSelectArea("CT5")                                                               
         aadd(aCT5LANC[nX][2],{})
         For nY := 1 To CT5->(FCount())
              cFieldName := CT5->(FieldName(nY))
			     xFieldGet  := CRIAVAR(cFieldName) 
			     If cFieldName = "CT5_LANPAD"
			        xFieldGet := cPadrao
			     ElseIf cFieldName = "CT5_SEQUEN"
			        xFieldGet := "001"
			     ElseIf cFieldName = "CT5_DEBITO"
			        xFieldGet :=  IIF(nSaldo>0,"M->cConta","")
			     ElseIf cFieldName = "CT5_CREDIT"
			        xFieldGet := IIF(nSaldo<0,"M->cConta","")
			     ElseIf cFieldName = "CT5_CCD"
			        xFieldGet := IIF(nSaldo>0,"M->cCusto","")
			     ElseIf cFieldName = "CT5_CCC"
			        xFieldGet := IIF(nSaldo<0,"M->cCusto","")
			     ElseIf cFieldName = "CT5_ITEMD"
			        xFieldGet := IIF(nSaldo>0,"M->cItem","")
			     ElseIf cFieldName = "CT5_ITEMC"
			        xFieldGet := IIF(nSaldo<0,"M->cItem","")
			     ElseIf cFieldName = "CT5_CLVLDB"
			        xFieldGet := IIF(nSaldo>0,"000001","")
			     ElseIf cFieldName = "CT5_CLVLCR"
			        xFieldGet := IIF(nSaldo<0,"000001","")
			     ElseIf cFieldName = "CT5_HIST"
			        xFieldGet := '"RATEIO ORIGEM  '+cCodSZ2+'"'
			     ElseIf cFieldName = "CT5_ORIGEM"
			        xFieldGet := '"RATEIO  ORIGEM - RCTBA03"'
			     ElseIf cFieldName = "CT5_VLR01"
			        xFieldGet := "M->nValor" 
			     ElseIf cFieldName = "CT5_DC"
			       If nSaldo > 0
			           xFieldGet := "1"  //Debito
			       ElseIf nSaldo < 0
			          xFieldGet := "2"  //Credito                                                                                            
			       Else
			          xFieldGet := "3"  //Partida Dobrada		     			           
			       EndIf			             
			     EndIf
  				  aadd(aCT5LANC[nX][2][nZ],{cFieldName,xFieldGet})
         Next nY

	     If nValor > 0 
	    	nTotal += DETPROVA(nHdlPrv,cPadrao,"RCTBA03",cLoteRate,,,,,,aCT5LANC,.F.)
      	 EndIf         
     */
    	 _cConta :=(cAlias)->Z2_CONTA//Marcio
	
		 _cQRYSZ2 := "SELECT * FROM "+RETSQLNAME("SZ2")+" SZ2 " +CRLF
		 _cQRYSZ2 += "WHERE " + CRLF
		 _cQRYSZ2 += "SZ2.Z2_NUMRATE = '"+SZ2->Z2_NUMRATE+"'" +CRLF
		 _cQRYSZ2 += "AND SZ2.Z2_TIPREG = '2'  " +CRLF
		 _cQRYSZ2 += "AND SZ2.D_E_L_E_T_ = ''" +CRLF
		 _cQRYSZ2 += "AND SZ2.Z2_FILIAL = '"+ xFilial("SZ2")+"'"+CRLF
	  
	     If (Select("QRYSZ2") > 0 )
		       
   		     QRYSZ2->(dbCloseArea())
	     Endif   
		 
		 dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQRYSZ2),"QRYSZ2",.F.,.T.)
		 
		 Do while !QRYSZ2->(Eof())
		 
	         cCusto2:= QRYSZ2->Z2_CC
	         cItem2 := QRYSZ2->Z2_ITEM
	         cCLVL2 := QRYSZ2->Z2_CLVL  
	         //_cConta:= QRYSZ2->Z2_CONTA
	         
		     nSaldo := ROUND(( nValRate *  QRYSZ2->Z2_PERCENT ) / 100,2)//nSaldo := ROUND(( nValRate * SZ2->Z2_PERCENT ) / 100,2)
	         nValor  := nValor2
	         nValor2 := nSaldo           
          
	         //+--------------------------------------------------------------+
	         //¦ Inicializa o array de otimizacao dos lancamentos padronizados¦
	         //+--------------------------------------------------------------+
	         aCT5LANC := {}
	         aadd(aCT5LANC,{cPadrao,{}})
	         nX := Len(aCT5LANC)
	         nZ := 1
	         
	         dbSelectArea("CT5")
	         aadd(aCT5LANC[nX][2],{})
	         For nY := 1 To CT5->(FCount())
	             
	             cFieldName := CT5->(FieldName(nY))
				     xFieldGet  := CRIAVAR(cFieldName) 
				     If cFieldName = "CT5_LANPAD"
				        xFieldGet := cPadrao
				     ElseIf cFieldName = "CT5_SEQUEN"
				        xFieldGet := "002"
				    ElseIf cFieldName = "CT5_DEBITO"
				       xFieldGet := IIF(nSaldo<0,"M->cConta","")
				     ElseIf cFieldName = "CT5_CREDIT"
				       xFieldGet := IIF(nSaldo>0,"M->cConta","")
				     ElseIf cFieldName = "CT5_CCD"
				        xFieldGet := IIF(nSaldo<0,"M->cCusto2","")
				     ElseIf cFieldName = "CT5_CCC"
				        xFieldGet := IIF(nSaldo>0,"M->cCusto2","")
				     ElseIf cFieldName = "CT5_ITEMD"
				        xFieldGet := IIF(nSaldo<0,"M->cItem2","")
				     ElseIf cFieldName = "CT5_ITEMC"
				        xFieldGet := IIF(nSaldo>0,"M->cItem2","")
				     ElseIf cFieldName = "CT5_CLVLDB"
				        xFieldGet := IIF(nSaldo<0,"000001","")
				     ElseIf cFieldName = "CT5_CLVLCR"
				        xFieldGet := IIF(nSaldo>0,"000001","")
				     ElseIf cFieldName = "CT5_HIST"
				        xFieldGet := '"RATEIO DESTINO  '+cCodSZ2+'"'
				     ElseIf cFieldName = "CT5_ORIGEM"
				        xFieldGet := '"RATEIO DESTINO X- RCTBA03"'
				     ElseIf cFieldName = "CT5_VLR01"
				        xFieldGet := "M->nValor2"
				     ElseIf cFieldName = "CT5_DC"
				        If nSaldo < 0
				           xFieldGet := "1"  //Debito
				        ElseIf nSaldo > 0
				           xFieldGet := "2"  //Credito 
				        Else
				           xFieldGet := "3"  //Partida Dobrada		     			           
				        EndIf			             
				     EndIf
	                 aadd(aCT5LANC[nX][2][nZ],{cFieldName,xFieldGet})
	         Next nY          
	     
		     //If nValor2 > 0
		    	nTotal += DETPROVA(nHdlPrv,cPadrao,"RCTBA03",cLoteRate,,,,,,aCT5LANC,.F.)                                                         
	      	 //EndIf         
      	 
	      	 QRYSZ2->(DbSkip())
         EndDo
        // dbSelectAre("SZ2")
          
//	  EndIf
      
      /*If nValor > 0
         nTotal += DETPROVA(nHdlPrv,cPadrao,"RCTBA03",cLoteRate,,,,,,aCT5LANC,.F.)
      EndIf*/
      nValor2:= nValor
	  (cAlias)->(dbSkip())
   EndDo
   
   If nHdlPrv != NIL
      //+--------------------------------------------------------------+
      //¦ Se ele criou o arquivo de prova ele deve gravar o rodape'    ¦
      //+--------------------------------------------------------------+
      RodaProva(nHdlPrv,nTotal)
      If nTotal > 0
         cA100Incl(cArquivo,nHdlPrv,3,cLoteRate,lDigita,lAglutina,,dDatMov,dDatMov)
      EndIf
   EndIf

//Else
  // Aviso("Contabilização Rateio","Codigo de rateio não encontrado!",{"OK"})
//EndIf

Return( .T. )