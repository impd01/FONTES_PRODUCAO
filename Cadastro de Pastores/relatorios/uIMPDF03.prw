#include "TOTVS.ch"
#INCLUDE 'FWPRINTSETUP.ch'
#INCLUDE "RPTDEF.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"

static lEmpty:=IIF(funname()$ "GPEA265|GPEA010",.F.,.F.)


/*/{Protheus.doc} uIMPDF03

	@author carlos.xavier
	@since 20/03/2017
	@version undefined
	@type function

/*/
user function uIMPDF03()

   local   aReturn		   	
   local   aPerg			

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
   clocal:=""
   
   lAdjustToLegacy:=.T.
   lDisableSetup:=.T.
   cFilePrint:="uIMPDF03"+dtos(ddatabase)+".pdf"
   /*
  DbSelectArea("SRA")
   SRA->(dbSetorder(1))
  // SRA->(DbSeek("010020001000027"))
     SRA->(DbSeek("010010001000016"))*/
   
   BEGIN SEQUENCE
   		
   		aAdd( aPerg ,{1,"Bispo  Estadual"	,Space(nTNome),'','','','',60,.F.})
   		aAdd( aPerg ,{1,"Testemunha"	      ,Space(nTNome),'','','','',60,.F.})
         
         aAdd( aPerg ,{1,"Igreja"	         ,Space(20),'','','','',60,.F.})
         aAdd( aPerg ,{1,"Superior" 	      ,Space(20),'','','','',60,.F.})
	   		
		IF .not.(ParamBox(aPerg,"Parametros",aReturn))
		   apMsgInfo("Abortado pelo usuario.")
		   BREAK   
		Endif
		
		MV_PAR01:=""
		MV_PAR02:=uPper(rTrim(aReturn[1]))
		MV_PAR03:=uPper(rTrim(aReturn[2]))
		MV_PAR05:=rTrim(IIF(empty(SRA->RA_XMOTDES),"POR MOTIVOS PESSOAIS.",SRA->RA_XMOTDES))

      MV_PAR06:=uPper(rTrim(aReturn[3]))
      MV_PAR07:=uPper(rTrim(aReturn[4]))
		
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
  oprint:say(750,750,"CONTROLE INTERNO DE DESLIGAMENTO ",oFont15B)
  
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
	//local rg:=IIF(lEmpty," ",SRA->RA_RG)
	//local tel:=IIF(lEmpty," ",SRA->("( "+RA_DDDFONE+" ) "+RA_TELEFON))
	//local atual:=rTrim(posicione("CTT",1,SRA->(RA_FILIAL+RA_CC),"CTT_DESC01")) 
	local body:=''
	local cMat:=SRA->RA_MAT
	
	local nD:=0

    body:="Informamos o desligamento do "+rTrim(funcao)+": "+rTrim(nome)+", portador do CPF nº: " +rTrim(cpf)+", sob Matrícula Nº "+allTrim(cMat)+;
        " que estava na igreja "+rTrim(MV_PAR06)+" pertencente à Sede "+rTrim(MV_PAR07)+", na seguinte data: "+ dToc(ddatabase)+", pelo motivo descrito abaixo: "
               
    nRow:=800
    nCol:=200
    printMemo(body,80)
    nCol+=100
    
    /*IF ( .not.(empty(Alltrim(MV_PAR05)))) 
     
       printMemo(MV_PAR05,80)
   
    Else*/
       
        for nD := 1 To 8
        
         nRow+=80
          oprint:say(nRow,nCol,replicate("_",85),oFont12)
    
        next nD
    
    //Endif
  
    MV_PAR01:=Alltrim(funcao + ": "+ rTRim(nome) )
    nRow+=100
  
return  nil



/*/{Protheus.doc} printInfo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printInfo()

   nRow+=200
   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,rTrim(MV_PAR02),oFont12b,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,"Nome completo e assinatura do informante.",oFont12b,2300,100,,2,0)
   nRow+=200
   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,rTrim(MV_PAR03),oFont12b,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,"Nome completo e assinatura da testemunha.",oFont12b,2300,100,,2,0)
   nRow+=50

   oprint:say(2850,1000,"SEDE ESTADUAL",oFont12B)
   oprint:say(2900,820,"Rua: Carneiro Leão, 439 - Bairro Brás",oFont12B)
   oprint:say(2950,900,"São Paulo-SP CEP:03040-000",oFont12B)

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
