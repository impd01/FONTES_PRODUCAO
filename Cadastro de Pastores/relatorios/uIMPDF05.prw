#include "TOTVS.ch"
#INCLUDE 'FWPRINTSETUP.ch'
#INCLUDE "RPTDEF.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"

user function uIMPDF05()

   local   aReturn		   	
   local   aPerg
   local  aImp			

   local 	clocal			
   local 	cFilePrint		
	
   local 	lAdjustToLegacy	
   local	lDisableSetup	
   
   local nTNome

   private nRow 
   private nCol 	
   private oPrint
   private nPag
   
   oFont10:=TFont():New("Andale Mono",10,10,,.F.,,,,.T.,.F.)
   oFont10B:=TFont():New("Andale Mono",10,10,,.T.,,,,.T.,.F.)
   oFont11:=TFont():New("Andale Mono",11,11,,.F.,,,,.T.,.F.) 
   oFont11B:=TFont():New("Andale Mono",11,11,,.T.,,,,.T.,.F.)
   oFont12:=TFont():New("Times New Roman",16,16,,.F.,,,,.T.,.F.)
   oFont12B:=TFont():New("Times New Roman",18,18,,.F.,,,,.T.,.F.)
   oFont14B:=TFont():New("Andale Mono",14,14,,.T.,,,,.T.,.F.)
   oFont15B:=TFont():New("Times New Roman",14,14,,.T.,,,,.T.,.F.)
   oFont15:=TFont():New("Times New Roman",16,16,,.F.,,,,.T.,.F.)
   oFont15A:=TFont():New("Times New Roman",20,20,,.F.,,,,.T.,.F.)
   
   
   aReturn:=array(0)
   aPerg:=array(0)
   
   nPag:=1
   nCol:=50
   nRow:=50
   
   nTNome:=getSx3Cache("RA_NOME","X3_TAMANHO")
   clocal:=""
   
   lAdjustToLegacy:=.T.
   lDisableSetup:=.T.
   cFilePrint:="uIMPDF05"+dtos(ddatabase)+".pdf"
   
   
   BEGIN SEQUENCE
   		
   		aImp:={"Todos","Bispo","Pastor","Pastora"}
   		aAdd( aPerg ,{1,"Transferência De"	,cTod(" /  /   "),'','','','',60,.F.})
   		aAdd( aPerg ,{1,"Transferência Ate"	,ddatabase,'','','','',60,.F.})
		aAdd( aPerg ,{2,"Função",Space(30),aImp,80,'',.T.})   		
		
		IF .not.(ParamBox(aPerg,"Parametros",aReturn))
		   apMsgInfo("Abortado pelo usuario")
		   BREAK   
		Endif
		
		MV_PAR01:=dTos(aReturn[1])
		MV_PAR02:=dTos(aReturn[2])
		MV_PAR03:=IIF(aReturn[3] == "Todos","1|2|3",IIF(aReturn[3] =="Bispo","2",IIF(aReturn[3] == "Pastor","2","3")))
		
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
   //Sheader()

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
  oprint:say(600,850,"HISTORICO DE TRANSFERÊNCIA",oFont15A)
  oprint:say(600,1800,"PAG:"+ alltrim(str(nPag)),oFont15A)
  nRow:=650
  oprint:line(nRow,50,nRow,2350)
 
 
return


static function Sheader()
    
    nRow:=600
    nCol:=100
    oprint:say(600,nCol,"NOME",oFont15B)
    nCol+=800    
    oprint:say(600,nCol,"DATA",oFont15B)
    nCol+=200
    oprint:say(600,nCol,"ORIGEM",oFont15B)
    nCol+=500
    oprint:say(600,nCol,"DESTINO",oFont15B)


return 
/*/{Protheus.doc} printBody

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function

/*/

static function printBody()
    local cInfo:=""
    local cIn:=rTrim(MV_PAR03)
	local cAlias:=getNextAlias()
	
	local nD:=0
	
	oBrush:=TBrush():New(,RGB(0,127,255)) 
	
    BEGIN SEQUENCE
    
    BeginSql Alias cAlias
    	   
    	 SELECT RE_DATA, 
        (SELECT CTT_DESC01
        FROM   CTT020 CTT 
        WHERE  CTT.CTT_FILIAL = RE_FILIALD 
               AND CTT_CUSTO = RE_CCD AND CTT.D_E_L_E_T_ = '')     AS CCD, 
       (SELECT CTT_DESC01 
        FROM   CTT020 CTT2 
        WHERE  CTT2.CTT_FILIAL = SRE.RE_FILIALP 
               AND CTT_CUSTO = SRE.RE_CCP AND CTT2.D_E_L_E_T_ = '') AS CCP ,
	   (SELECT RA_XTIPO 
	   FROM SRA020 SRA 
	   WHERE SRA.RA_FILIAL = SRE.RE_FILIALD 
	         AND SRA.RA_MAT = SRE.RE_MATD AND SRA.D_E_L_E_T_ = '' AND SRA.RA_XTIPO IN ('1','2','3')) AS TIPO,
	    (SELECT  RA_NOME AS NOME
	   FROM SRA020 SRA2 
	   WHERE SRA2.RA_FILIAL = SRE.RE_FILIALP 
	         AND SRA2.RA_MAT = SRE.RE_MATP AND SRA2.D_E_L_E_T_ = '' AND SRA2.RA_XTIPO IN ('1','2','3') ) AS NOMEP
	   FROM   SRE020 SRE 
	   WHERE SRE.D_E_L_E_T_ = ''
	         AND SRE.RE_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
       ORDER BY  RE_DATA            
    EndSql
    	    	
    	
        nRow+=80
    	while .not.((cAlias)->(eof()))
		    
		    If rTrim((cAlias)->TIPO) $ cIn 
		    		    
		    BreakPag()
			   //nCol:=100
			   //oprint:say(nRow,nCol,upper(u_getDesc((cAlias)->TIPO)+" "+(cAlias)->NOMEP),oFont15)
			   //oPrint:FillRect({nRow-5,52,nRow+45,2345},oBrush)
			    oprint:SayAlign(nRow,100,upper(u_getDesc((cAlias)->TIPO)+" "+(cAlias)->NOMEP),oFont15b,2300,100,,2,0)
			    nRow+=80
			    cInfo:="DATA: " + dToc(sTod((cAlias)->RE_DATA)) + "  ORIGEM: "+rTrim((cAlias)->CCD)+ "  DESTINO: "+rTrim((cAlias)->CCP)
			    nRow+=50
			    nCol:=100 
			    oprint:say(nRow,nCol,"DATA: ",oFont15b)
			    nCol+=130
			    oprint:say(nRow,nCol,dToc(sTod((cAlias)->RE_DATA)),oFont15)
			    nCol+=250 
			    oprint:say(nRow,nCol,"ORIGEM: ",oFont15b)
			    nCol+=170
			    oprint:say(nRow,nCol,substr(rTrim((cAlias)->CCD),1,30),oFont15)
			    nCol+=700
			    oprint:say(nRow,nCol,"DESTINO: ",oFont15b)
			    nCol+=170
			    oprint:say(nRow,nCol,substr(rTrim((cAlias)->CCP),1,30),oFont15)
			    
			    nRow+=40 
			    oprint:line(nRow,50,nRow,2350)
			    nRow+=80
	          
	         EndIF
	          (cAlias)->(dbSkip())
        Enddo
    
    
    END SEQUENCE
    
    
      
return  nil


static function BreakPag()

    IF nRow >= 2800
        nPag++
        oPrint:endPage()
        oPrint:startPage()
        _box()
        printHeader()
    //    Sheader()
        nRow+=80 
    
    Endif



Return 