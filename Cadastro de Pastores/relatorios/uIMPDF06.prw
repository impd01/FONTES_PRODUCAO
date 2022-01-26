#include "TOTVS.ch"
#INCLUDE 'FWPRINTSETUP.ch'
#INCLUDE "RPTDEF.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.ch"
static lEmpty:=.F.
static aFilhos:=array(0)
static aConjuge:=array(3)

/*/{Protheus.doc} uIMPDF06

@author carlos.xavier
@since 22/03/2017
@version undefined
@type function

/*/
user function uIMPDF06()

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
	oFont15:=TFont():New("Times New Roman",16,16,,.F.,,,,.T.,.F.)
	oFont15B:=TFont():New("Times New Roman",18,18,,.F.,,,,.T.,.F.)
	oFont14B:=TFont():New("Andale Mono",14,14,,.T.,,,,.T.,.F.)
	oFont15B:=TFont():New("Times New Roman",18,18,,.T.,,,,.T.,.F.)
	oFont15:=TFont():New("Times New Roman",25,25,,.F.,,,,.T.,.F.)
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
	cFilePrint:="uIMPDF06"+dtos(ddatabase)+".pdf"

/*	DbSelectArea("SRA")
	SRA->(dbSetorder(1))
	// SRA->(DbSeek("010020001000027"))
	SRA->(DbSeek("010010001000016"))*/

	BEGIN SEQUENCE


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
	local nome:=IIF(lEmpty," ",SRA->RA_NOME)
	local funcao:=Alltrim(IIF(lEmpty," ",u_getDesc(SRA->RA_XTIPO)))
	local cpf:=Transform(IIF(lEmpty," ",SRA->RA_CIC),getsx3cache("RA_CIC","X3_PICTURE"))
	local rg:=IIF(lEmpty," ",SRA->RA_RG)
	local tel:=""//IIF(lEmpty," ","TEL: "+SRA->("( "+RA_DDDFONE+" ) "+RA_TELEFON))
	local cel:=""//IIF(lEmpty," ","CEL: "+SRA->("( "+RA_DDDCELU+" ) "+RA_NUMCELU))
	local atual:=allTrim(posicione("CTT",1,SRA->(RA_FILIAL+RA_CC),"CTT_DESC01")) 
	local tipo:=U_getDesc(SRA->RA_XHRQ,"RA_XHRQ")
	
	tipo:=IIF(empty(tipo),"",uPper(tipo))
	tel:="TEL: "+SRA->("( "+RA_DDDFONE+" ) ")+transForm(SRA->RA_TELEFON,getSx3Cache("RA_TELEFON","X3_PICTURE"))
	cel:="CEL: "+SRA->("( "+RA_DDDCELU+" ) ")+transForm(SRA->RA_NUMCELU,getSx3Cache("RA_TELEFON","X3_PICTURE"))
    	
	oprint:SayBitmap(200,100,cBMP,900,200)

	If RepExtract(SRA->RA_XBITMAP,SRA->RA_XBITMAP,.T.,.T.)
		oprint:SayBitmap(500,500,rTrim(SRA->RA_XBITMAP)+".BMP",600,650)
	Else
		//oprint:Box( 500, 600, 750 ,1750, "-4")
	Endif

	If RepExtract(SRA->RA_BITMAP,SRA->RA_BITMAP,.T.,.T.)
		oprint:SayBitmap(500,1300,rTrim(SRA->RA_BITMAP)+".BMP",600,650)
	Else
		//oprint:Box( 200, 1860, 620 ,2210, "-4")
	Endif  
	aConjuge:=Array(3)
	aConjuge[1]:=""
	aConjuge[2]:=""
	aConjuge[3]:=""
    createQuery(SRA->RA_FILIAL,SRA->RA_MAT)
	nRow:=1400
	//oprint:say(nRow,1000,atual,oFont15)
	oprint:SayAlign(nRow,100,Alltrim(upper(atual)),oFont15,2300,100,,2,0)
	nRow+=200
	//oprint:say(nRow,700,upper(funcao +":"+ nome),oFont15)
	//SayAlign  ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] ) 
	oprint:SayAlign(nRow,100,Alltrim(upper(funcao +": "+ nome)),oFont15,2300,100,,2,0)
	nRow+=200
	//oprint:say(nRow,1100,"TITULAR"/*upper(U_getDesc(alltrim(SRA->RA_XHRQ),"RA_XHRQ"))*/,oFont15)
	//oprint:SayAlign(nRow,1100,"TITULAR",oFont15,300,100,,2,0)
	oprint:SayAlign(nRow,100,Alltrim(tipo),oFont15,2300,100,,2,0)
	nRow+=200
	//oprint:say(nRow,700,"CÔNJUGE: "+aConjuge[2],oFont15)
	oprint:SayAlign(nRow,100,Alltrim("CÔNJUGE: "+aConjuge[2]),oFont15,2300,100,,2,0)
	nRow+=200
	//oprint:SayAlign(nRow,1100,"ENTRADA NA OBRA: " + dtoc(SRA->RA_ADMISSA),oFont15,300,100,,2,0)
	//oprint:say(nRow,800,"ENTRADA NA OBRA: " + dtoc(SRA->RA_ADMISSA),oFont15)
	oprint:SayAlign(nRow,100,alltrim("ENTRADA NA OBRA: " + dtoc(SRA->RA_ADMISSA)),oFont15,2300,100,,2,0)
	nRow+=200
	//oprint:SayAlign(nRow,1100,tel,oFont15,300,100,,2,0)
	oprint:SayAlign(nRow,100,alltrim(tel),oFont15,2300,100,,2,0)
	nRow+=200
	oprint:SayAlign(nRow,100,alltrim(cel),oFont15,2300,100,,2,0)
//	oprint:say(nRow,1000,tel,oFont15)
	nRow+=300

    aSize(aFilhos,0)
    aSize(aConjuge,0)
    
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
