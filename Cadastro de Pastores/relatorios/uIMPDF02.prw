#include "TOTVS.ch"
#INCLUDE 'FWPRINTSETUP.ch'
#INCLUDE "RPTDEF.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "COLORS.ch"

static aFilhos:=array(0)
static aConjuge:=array(3)
static lEmpty:=IIF(funname()$ "GPEA265|GPEA010",.F.,.F.)


/*/{Protheus.doc} uIMPDF02 

@author carlos.xavier
@since 16/03/2017
@version undefined
@type function

/*/

user function uIMPDF02()//U_uIMPDF99()

   local   aReturn		   	
   local   aPerg			

   local 	clocal			
   local 	cFilePrint		
	
   local 	lAdjustToLegacy	
   local	lDisableSetup	
   
   local nTNome
   local nTCTT

   private nRow 
   private nCol 	
   private oPrint
   
   oFont10:=TFont():New("Andale Mono",10,10,,.F.,,,,.T.,.F.)
   oFont10B:=TFont():New("Andale Mono",10,10,,.T.,,,,.T.,.F.)
   oFont11:=TFont():New("Andale Mono",11,11,,.F.,,,,.T.,.F.) 
   oFont11B:=TFont():New("Andale Mono",11,11,,.T.,,,,.T.,.F.)
   oFont12:=TFont():New("Times New Roman",16,16,,.F.,,,,.T.,.F.)
   oFont12B:=TFont():New("Times New Roman",18,18,,.F.,,,,.T.,.F.)
   oFont14B:=TFont():New("Andale Mono",14,14,,.T.,,,,.T.,.F.)
   oFont15B:=TFont():New("Times New Roman",18,18,,.T.,,,,.T.,.F.)
   oFont15:=TFont():New("Times New Roman",18,18,,.F.,,,,.T.,.F.)
   oFontInv:=TFont():New("Comic Sans MS",,25,,.T.,,,,.T.,.F.)
   
   aReturn:=array(0)
   aPerg:=array(0)
   
   nPag:=1
   nCol:=50
   nRow:=50
   
   nTNome:=getSx3Cache("RA_NOME","X3_TAMANHO")
   nTCTT:=getSx3Cache("CTT_DESC01","X3_TAMANHO")
   
   lAdjustToLegacy:=.T.
   lDisableSetup:=.T.
   clocal:=""
   cFilePrint:="uIMPDF02"+dtos(ddatabase)+".pdf"
   aconjuge[1]:=""
   aconjuge[2]:=""
   aconjuge[3]:=""
   
 /*    DbSelectArea("SRA")
   SRA->(dbSetorder(1))
  // SRA->(DbSeek("010020001000027"))
     SRA->(DbSeek("010010001000016"))*/
   
   BEGIN SEQUENCE
   		
   		aAdd( aPerg ,{1,"1º Assinatura"	,Space(nTNome),'','','','',60,.F.})
	    aAdd( aPerg ,{1,"2º Assinatura"	,Space(nTNome),'','','','',60,.F.})
	    aAdd( aPerg ,{1,"3º Assinatura"	,Space(nTNome),'','','','',60,.F.})
	    aAdd( aPerg ,{1,"4º Assinatura"	,Space(nTNome),'','','','',60,.F.})
	    aAdd( aPerg ,{1,"5º Assinatura"	,Space(nTNome),'','','','',60,.F.})
	   	aAdd( aPerg ,{11,"Motivo da transfêrencia",'','','',.F.})
	    aAdd( aPerg ,{1,"Data da Transfêrencia",cTOd("/ / "),'','','','',60,.F.})
	    aAdd( aPerg ,{1,"Regiao a ser Transfêrido" ,space(nTCTT),'','','','',60,.F.	})
		
		IF .not.(ParamBox(aPerg,"Parametros",aReturn))
		   apMsgInfo("Abortado pelo usuario")
		   BREAK   
		Endif
		
		MV_PAR01:=uPper(rTrim(aReturn[1]))
		MV_PAR02:=uPper(rTrim(aReturn[2]))
		MV_PAR03:=uPper(rTrim(aReturn[3]))
		MV_PAR04:=uPper(rTrim(aReturn[4]))
		MV_PAR05:=uPper(rTrim(aReturn[5]))
		MV_PAR06:=rTrim(aReturn[6])
		MV_PAR07:=dtoc(aReturn[7])
		MV_PAR08:=rTrim(aReturn[8])
		
		oPrint:=FWMSPrinter():New(cFilePrint,IMP_PDF,lAdjustToLegacy,clocal,.T.,,,,.T.,,.F.,)
					
		oPrint:SetResolution(72)
		oPrint:SetPortrait(.T.)
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(10,60,60,60)
		oPrint:StartPage()
					
		RptStatus({||runReport()},"Imprimindo")
					
		cFilePrint:=clocal + "Rel_"
		File2Printer( cFilePrint, "PDF" )
		oPrint:cPathPDF:=clocal
		oPrint:EndPage()
		oPrint:Preview(.T.)
		FT_PFLUSH()
		FreeObj(oPrint)
   
   END SEQUENCE

return

/*/{Protheus.doc} runReport

	@author carlos.xavier
	@since 16/03/2017Adm
	@version undefined
	@type function

/*/

static function runReport()

  createQuery(SRA->RA_FILIAL,SRA->RA_MAT)
   _box()
   printHeader()
   printBody()
   printDep()
   printInfo()
   
   aSize(aFilhos,0)
   aSize(aConjuge,0)
   aFilhos:=array(0)
   aConjuge:=array(3)

return 

/*/{Protheus.doc} _box

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/
static function _box()

return oprint:Box( 100, 050, 3050 ,2350, "-4")

/*/{Protheus.doc} printHeader
	
	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printHeader()

  local cBMP:="LOGO_IMPD.BMP"
  local destino:=PADR(alltrim(MV_PAR08),getsx3cache("CTT_DESC01","X3_TAMANHO")," ")
  local atual:=PADR(rTrim(posicione("CTT",1,SRA->(RA_FILIAL+RA_CC),"CTT_DESC01")),getsx3cache("CTT_DESC01","X3_TAMANHO")-20," ")
  
  oprint:SayBitmap(200,100,cBMP,900,200) 
   
  If RepExtract(SRA->RA_XBITMAP,SRA->RA_XBITMAP,.T.,.T.)
       oprint:SayBitmap(200,1400,rTrim(SRA->RA_XBITMAP)+".BMP",400,450)
  Else
    oprint:Box( 200, 1400, 620 ,1750, "-4")
  Endif
 

  If RepExtract(SRA->RA_BITMAP,SRA->RA_BITMAP,.T.,.T.)
     oprint:SayBitmap(200,1860,rTrim(SRA->RA_BITMAP)+".BMP",400,450)
  Else
     oprint:Box( 200, 1860, 620 ,2210, "-4")
  Endif  
 
  oprint:SayAlign(750,100,"TRANSFERÊNCIA DE BISPO E PASTOR ",oFont15B,2300,100,,2,0)
  oprint:SayAlign(800,100,"SAINDO DE: "+atual+"/ PARA : "+destino,oFont15B,2300,100,,2,0)
  //oprint:say(750,750,"TRANSFERÊNCIA DE BISPO E PASTOR ",oFont15B)
  //oprint:say(800,650,"SAINDO DE: "+atual+"/ PARA : "+destino,oFont15)
  
return

/*/{Protheus.doc} printBody

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printBody()

	local nome:=IIF(lEmpty," ",SRA->RA_NOME)
	local funcao:=Alltrim(IIF(lEmpty," ",u_getDesc(SRA->RA_XTIPO)))
	local cpf:=Transform(IIF(lEmpty," ",SRA->RA_CIC),getsx3cache("RA_CIC","X3_PICTURE"))
	local rg:=IIF(lEmpty," ",SRA->RA_RG)
	local tel:=IIF(lEmpty," ",SRA->("( "+RA_DDDFONE+" ) "+RA_TELEFON))
	local conjuge:=IIF(lEmpty," ",aConjuge[2])
	local cpfconj:=Transform(IIF(lEmpty," ",aConjuge[3]),getsx3cache("RA_CIC","X3_PICTURE"))
	local cMat:=SRA->RA_MAT
   // MV_PAR01:=funcao+": "+nomr
    nRow:=1200
    nCol:=150
    oprint:say(nRow,nCol,"NOME: "+nome+"  FUNÇÃO: "+uPper(funcao),oFont12B)
    //nCol+=800
    //oprint:say(nRow,nCol,"FUNÇÃO: "+funcao,oFont12B)
    nRow+=60
    nCol:=150
    oprint:say(nRow,nCol,"CPF: "+cpf + " Matricula: "+cMat ,oFont12B)
    nRow+=60
    oprint:say(nRow,nCol,"RG: "+rg,oFont12B)
    nCol+=400
    oprint:say(nRow,nCol,"TEL: "+tel,oFont12B)
    
    nRow+=100
    nCol:=150
    oprint:say(nRow,nCol,"NOME DO CÔNJUGE: "+conjuge,oFont12B)
    nRow+=60
    oprint:say(nRow,nCol,"CPF: "+cpfconj,oFont12B)

return  nil

/*/{Protheus.doc} printDep

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printDep()

  local nT:=len(aFilhos)
  local nD:=0
  
  nRow+=100
  nCol:=150
  oprint:say(nRow,nCol,"DEPENDENTES:",oFont12B)
  
  If  nT > 0
     
     nCol0:=350
     for nD := 1 To nT
         nCol:=350
         nRow+=50
         oprint:say(nRow,nCol,"NOME: "+PADR(aFilhos[nD][1],getsx3cache("RA_NOME","X3_TAMANHO")," ") ,oFont12B)
         
         oprint:say(nRow,1600," IDADE: "+ Alltrim(str(round(aFilhos[nD][2],0))) ,oFont12B)
    
    next nD
    
  Else
   
     nCol:=350	
     for nD := 1 To 5
        
         nRow+=50
         oprint:say(nRow,nCol,"NOME: "+Replicate("_",60)+"   IDADE: "+Replicate("_",10),oFont12)
    
    next nD
    
  EndIF

return

/*/{Protheus.doc} printInfo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printInfo()
   local nT:=getSx3Cache("RA_NOME","X3_TAMANHO")-20
   nCol:=150
   nRow+=100
   oprint:say(nRow,nCol,"ENTRADA NA OBRA: " +dToc(SRA->RA_ADMISSA),oFont12B)
   nRow+=50
   oprint:say(nRow,nCol,"VALOR DA RENDA : " + allTrim(TransForm(SRA->RA_SALARIO,getSx3Cache("RA_SALARIO","X3_PICTURE"))),oFont12B)
   nRow+=50
   oprint:say(nRow,nCol,"REGIAO/ESTADO A SER TRANSFERIDO :  "+MV_PAR08,oFont12B)
   nRow+=50
   oprint:say(nRow,nCol,"DATA : "+MV_PAR07,oFont12B)
   nRow+=50
   oprint:say(nRow,nCol,"MOTIVO DA TRANSFERÊNCIA : ",oFont12B)
   
   printMemo(MV_PAR06)
   
   nRow+=200 
   If .not.(empty(Alltrim(MV_PAR01)))
    //oprint:say(nRow,850,Replicate("_",len(MV_PAR01)+2),oFont12B)
    //oprint:line(nRow,850,nRow,850+(len(allTrim(MV_PAR01))*38))
    oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,2300,100,,2,0)
   Endif
   nRow+=40
   //oprint:say(nRow,900,MV_PAR01,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR01,oFont12b,2300,100,,2,0)
   
   nRow+=150
   If .not.(empty(Alltrim(MV_PAR02)))
//    oprint:say(nRow,300,Replicate("_",len(MV_PAR01)+3),oFont12B)
		//oprint:line(nRow,300,nRow,300+(len(allTrim(MV_PAR02))*38))
		oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,1150,100,,2,0)
   Endif 
  
   If .not.(empty(Alltrim(MV_PAR03)))
    //oprint:say(nRow,1400,Replicate("_",len(MV_PAR01)+4),oFont12B)
    //oprint:line(nRow,1400,nRow,1400+(len(allTrim(MV_PAR03))*38))
    oprint:SayAlign(nRow,1200,replicate("_",40),oFont12b,1150,100,,2,0)
   Endif
  
   nRow+=40
   //oprint:say(nRow,350,MV_PAR02,oFont12B)
   //oprint:say(nRow,1450,MV_PAR03,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR02,oFont12b,1150,100,,2,0)
   oprint:SayAlign(nRow,1200,MV_PAR03,oFont12b,1150,100,,2,0)
   
   nRow+=150
   if .not.(empty(alltrim(MV_PAR04)))
   	//oprint:say(nRow,850,Replicate("_",len(MV_PAR04)+4),oFont12B)
   	//oprint:line(nRow,850,nRow,850+(len(allTrim(MV_PAR04))*38))
   	oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,2300,100,,2,0)
   endif 
   nRow+=40
   //oprint:say(nRow,900,MV_PAR04,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR04,oFont12b,2300,100,,2,0)
   
      nRow+=150
   If .not.(empty(Alltrim(MV_PAR05)))
//    oprint:say(nRow,300,Replicate("_",len(MV_PAR01)+3),oFont12B)
		//oprint:line(nRow,300,nRow,300+(len(allTrim(MV_PAR02))*38))
   	oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,2300,100,,2,0)
   Endif 
   
   nRow+=40
   //oprint:say(nRow,350,MV_PAR02,oFont12B)
   //oprint:say(nRow,1450,MV_PAR03,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR05,oFont12b,2300,100,,2,0)

return 

/*/{Protheus.doc} createQuery

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@param filial, , descricao
	@param matricula, , descricao
	@type function

/*/

static function createQuery(filial,matricula)
  
  local cAlias:=getNextAlias()
  
  BeginSql Alias cAlias
	  
	SELECT RB_NOME,
	       RB_DTNASC,
	       RB_COD,
	       RB_GRAUPAR,
	       RB_CIC
	FROM SRB020 SRB
	WHERE 
	    SRB.RB_FILIAL = %exp:filial%
	    AND SRB.RB_MAT = %exp:matricula%
	    AND SRB.D_E_L_E_T_ = ''
	ORDER BY 
	     RB_DTNASC
  
  EndSql
  
  TCSetField(  cAlias ,"RB_DTNASC","D",8,0)
 
  while .not.((cAlias)->(eof()))
  
 	  IF RTRIM((cAlias)->RB_GRAUPAR) == "C"
     
          aConjuge[1]:=(DateDiffMonth((cAlias)->RB_DTNASC, ddatabase)/12)
          aConjuge[2]:=(cAlias)->RB_NOME
          aConjuge[3]:=(cAlias)->RB_CIC
          
      ElseIf RTRIM((cAlias)->RB_GRAUPAR) $ "F|E"
      
          aadd(aFilhos,{(cAlias)->RB_NOME,(DateDiffMonth((cAlias)->RB_DTNASC, ddatabase)/12)})
      
      EndIF
  
     (cAlias)->(dbSkip())
 
  enddo
  
 (cAlias)->(dbCloseArea())
return 



/*/{Protheus.doc} printMemo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@param string, , descricao
	@type function

/*/
static function printMemo(string)

    local nT:=0
    local qtdRow:=mlCount(string,80,8,.f.)
    
    BEGIN SEQUENCE  
	    nRow+=20
	    
	    for nT := 1 to qtdRow
	     
	      if nT > 8
	         BREAK
	      Endif    
	      
	      nRow+=50
	      oprint:say(nRow,nCol,memoline(string,80,nT),oFont12B)
	    
	    next nT
	    
    END SEQUENCE

return   