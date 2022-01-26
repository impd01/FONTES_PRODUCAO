#INCLUDE "TOTVS.ch"
#INCLUDE 'FWPRINTSETUP.ch'
#INCLUDE "RPTDEF.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"

static lEmpty:=IIF(funname()$ "GPEA265|GPEA010",.F.,.F.)

/*/{Protheus.doc} uIMPDF04

	@author carlos.xavier
	@since 20/03/2017
	@version undefined
	@type function

/*/

user function uIMPDF04()

   local   aReturn		   
   local   aPerg			
   local   aArea:=SRA->(getArea())
   local 	clocal			
   local 	cFilePrint		
	
   local 	lAdjustToLegacy	
   local	lDisableSetup	
   
   local nTNome

   private nRow 
   private nCol 	
   private oPrint
   
   oFont10:=TFont():New("Andale Mono",10,10,,.F.,,,,.T.,.F.)
   oFont10B:=TFont():New("Andale Mono",10,10,,.T.,,,,.T.,.F.)
   oFont11:=TFont():New("Andale Mono",11,11,,.F.,,,,.T.,.F.) 
   oFont11B:=TFont():New("Andale Mono",11,11,,.T.,,,,.T.,.F.)
   oFont12:=TFont():New("Times New Roman",18,18,,.T.,,,,.T.,.F.)
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
   
   lAdjustToLegacy:=.T.
   lDisableSetup:=.T.
   clocal:=""
   cFilePrint:="uIMPDF04"+dtos(ddatabase)+".pdf"
/*
   DbSelectArea("SRA")
   SRA->(dbSetorder(1))
  // SRA->(DbSeek("010020001000027"))
   SRA->(DbSeek("010010001000016"))*/
  
   
   BEGIN SEQUENCE
   		
   		
   		aAdd( aPerg ,{1,"Bispo  Estadual"	,Space(nTNome),'','','XSRA','',60,.F.})
   		aAdd( aPerg ,{1,"Testemunha"	,Space(nTNome),'','','','',60,.F.})
   		aAdd( aPerg ,{1,"Estado"	,Space(20),'','','','',60,.F.})
	    aAdd( aPerg ,{11,"Motivo do Reingresso",'','','',.F.})
		
		IF .not.(ParamBox(aPerg,"Parametros",aReturn))
		   apMsgInfo("Abortado pelo usuario")
		   BREAK   
		Endif
		
		MV_PAR01:=uPper(rTrim(aReturn[3]))
		MV_PAR02:=uPper(rTrim(aReturn[1]))
		MV_PAR03:=uPper(rTrim(aReturn[2]))
		MV_PAR05:=rTrim(IIF(empty(SRA->RA_XMOTDES),"POR MOTIVOS PESSOAIS",SRA->RA_XMOTDES))
		MV_PAR06:=rTrim(aReturn[4])
		restArea(aArea)
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
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function runReport()
  
   _box()
   printHeader()
   printBody()
   printInfo()

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
  
  oprint:SayBitmap(200,100,cBMP,900,200)
  oprint:say(750,700,"AUTORIZAÇÃO PARA REATIVAR PASTORES ",oFont15B)
  
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
	local atual:=rTrim(posicione("CTT",1,SRA->(RA_FILIAL+RA_CC),"CTT_DESC01")) 
	local regiaoBispo:=atual
	local demissao:=IIF(lEmpty,CTOD(" /  /  "),SRA->RA_DEMISSA)
	local body:=''
	
	local nD:=0

   // MV_PAR01:=Alltrim(funcao + " : "+ nome )
    
    body:="Eu, Bispo: "+MV_PAR02+ " , Responsável pela Região " + regiaoBispo+ ". Venho Através deste, reingressar o " ;
           +funcao+" : "+ alltrim(nome)+ " CPF nº "+cpf+" que saiu da obra em "+ dToc(demissao) + " na Igreja Mundial do Poder de Deus  " +atual+ " no Estado "+MV_PAR01+"."         
    
    nRow:=800
    nCol:=200
    printMemo(body,80)
    
    nRow+=100
    oprint:say(nRow,nCol,"MOTIVO DO DESLIGAMENTO: ",oFont12)
    nCol+=100
    
    IF (.not.( empty(Alltrim(MV_PAR05)))) 
     
       printMemo(MV_PAR05,80)
   
    Else
       
        for nD := 1 To 6
        
         nRow+=50
          oprint:say(nRow,nCol,replicate("_",800),oFont12)
    
        next nD
    
    Endif
  
    nCol:=200
    nRow+=100
    oprint:say(nRow,nCol,"MOTIVO DO REINGRESSO: ",oFont12)
    nCol+=100
      
    IF (.not.( empty(Alltrim(MV_PAR06)))) 
     
       printMemo(MV_PAR06,80)
   
    Else
       
        for nD := 1 To 6
        
         nRow+=50
          oprint:say(nRow,nCol,replicate("_",80),oFont12)
    
        next nD
    
    Endif
    
   nRow+=150 
   oprint:say(nRow,1600,MV_PAR01+" , " +dToc(dDatabase),oFont12B)
   
return  nil

/*/{Protheus.doc} printInfo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printInfo()
  
   local nTnome:=getSx3Cache("RA_NOME","X3_TAMANHO")-20
  
   nRow+=200
   //oprint:say(nRow,750,Replicate("_",nTnome),oFont12B)
   //oprint:line(nRow,750,nRow,750+(len(allTrim(MV_PAR02))*38))
   oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,2300,100,,2,0)
   nRow+=40
  // oprint:say(nRow,800,MV_PAR02,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR02,oFont12b,2300,100,,2,0)
   nRow+=200
   
  // oprint:say(nRow,750,Replicate("_",nTnome),oFont12B)
   //oprint:line(nRow,750,nRow,750+(len(allTrim(MV_PAR03))*38))
   oprint:SayAlign(nRow,100,replicate("_",40),oFont12b,2300,100,,2,0)
  
   nRow+=40
  
   //oprint:say(nRow,800,MV_PAR03,oFont12B)
   oprint:SayAlign(nRow,100,MV_PAR03,oFont12b,2300,100,,2,0)
   nRow+=40
   
   oprint:say(2800,1000,"SEDE ESTADUAL",oFont12B)
   oprint:say(2840,820,"Rua: Carneiro Leão, 439 - Bairro Brás",oFont12B)
   oprint:say(2880,900,"São Paulo-SP CEP:03040-000",oFont12B)

return 

/*/{Protheus.doc} printMemo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@param string, , descricao
	@type function

/*/

static function printMemo(string,limit)

    local nT:=0
    local qtdRow:=mlCount(string,limit,8,.f.)
    
    BEGIN SEQUENCE  

	    nRow+=20
	    
	    for nT := 1 to qtdRow
	     
	      if nT > 8

	         BREAK

	      Endif    
	      
	      nRow+=80
	      oprint:say(nRow,nCol,memoline(string,limit,nT),oFont12B)
	    
	    next nT
	    
    END SEQUENCE

return 

/*/{Protheus.doc} getDesc

	@author carlos.xavier
	@since 20/03/2017
	@version undefined
	@param xPar, , descricao
	@type function

/*/

user Function getDesc(xPar,campo)
	
	Local aCombo
	local nX
	local xCombo
	local cArea := GetArea()
	local cRet

	DEFAULT campo:='RA_XTIPO'
	dbSelectArea('SX3')
	SX3->( dbSetOrder(2) )
	SX3->( dbSeek( campo ) )
                
	cValor:=X3CBox()	
	xCombo:=StrTokArr2( cValor, ";" )

	for nX := 1 to len(xCombo)
		
		If Substr(xCombo[nX] ,1,1) == xPar
			cRet := substr(xCombo[nX],3)
		
		Endif
	
	Next nX

RestArea(cArea)

Return cRet