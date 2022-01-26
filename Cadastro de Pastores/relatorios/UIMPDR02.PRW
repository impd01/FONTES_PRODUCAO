#include "TOTVS.ch"
#include 'FWPRINTSETUP.ch'
#include "RPTDEF.ch"
#include "TBICONN.ch"
#include "TOPCONN.ch"
#include "FILEIO.ch"
#include "COLORS.ch"

static aFilhos:=array(0)
static aConjuge:=array(3)
static lEmpty:=IIF(funname()$ "GPEA265|GPEA010",.F.,.F.)

user function starenvs()//u_starenv()

  PREPARE ENVIRONMENT EMPRESA '02' FILIAL '01' USER 'Administrador' PASSWORD '123'
  
   //U_uIMPDR01()
   //U_uIMPDF03()
 	//U_uIMPDF04()
   //U_uIMPDF02()
	U_uIMPDF05()
  
  RESET ENVIRONMENT
return


/*/{Protheus.doc} uIMPDR01

	@author carlos.xavier
	@since 21/03/2017
	@version undefined
	@type function
/*/
user function uIMPDR02()
   local   aReturn		   	
   local   aPerg			

   local    clocal			
   local 	cFilePrint		
	
   local 	lAdjustToLegacy	
   local	lDisableSetup	
   
   local nTNome
   local nFunc
   local nRG

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
   nFunc:=getSx3Cache("RJ_DESC","X3_TAMANHO")
   nRg:=getSx3Cache("RA_RG","X3_TAMANHO")
   
   lAdjustToLegacy:=.T.
   lDisableSetup:=.T.
   clocal:=getTempPath()
   cFilePrint:="uIMPDR01"+dtos(ddatabase)+".pdf"

  /* DbSelectArea("SRA")
   SRA->(dbSetorder(1))
  // SRA->(DbSeek("010020001000027"))
     SRA->(DbSeek("010010001000016"))*/
 
   
   BEGIN SEQUENCE
   		
   		aAdd( aPerg ,{1,"Testemunha I"	,Space(nTNome),'','','','',60,.F.})
   		aAdd( aPerg ,{1,"Cargo"	         ,Space(nFunc) ,'','','','',60,.F.})
   		aAdd( aPerg ,{1,"RG"	            ,Space(nRg)   ,'','','','',60,.F.})
	      aAdd( aPerg ,{1,"Testemunha II"	,Space(nTNome),'','','','',60,.F.})
	      aAdd( aPerg ,{1,"Cargo"	         ,Space(nFunc) ,'','','','',60,.F.})
   		aAdd( aPerg ,{1,"RG"	            ,Space(nRg)   ,'','','','',60,.F.})
	      aAdd( aPerg ,{1,"Bispo Estadual" ,Space(nTNome),'','','','',60,.F.})
	      aAdd( aPerg ,{1,"Estado"	      ,Space(20)    ,'','','','',60,.F.})
         
         aAdd( aPerg ,{1,"Igreja"	      ,Space(20)    ,'','','','',60,.F.})
         aAdd( aPerg ,{1,"Superior"	      ,Space(20)    ,'','','','',60,.F.})
		
		IF .not.(ParamBox(aPerg,"Parametros",aReturn))
		   apMsgInfo("Abortado pelo usuario")
		   BREAK   
		Endif
		
		MV_PAR01:=""
		
		MV_PAR02:=uPper(rTrim(aReturn[1]))
		MV_PAR06:=Transform(uPper(rTrim(aReturn[2])),getsx3cache("RA_RG","X3_PICTURE"))  
		MV_PAR07:=uPper(rTrim(aReturn[3]))
		MV_PAR03:=uPper(rTrim(aReturn[4]))
		MV_PAR08:=uPper(rTrim(aReturn[5]))
		MV_PAR09:=Transform(uPper(rTrim(aReturn[6])),getsx3cache("RA_RG","X3_PICTURE"))  
		MV_PAR04:=uPper(rTrim(aReturn[7]))
		MV_PAR05:=rTrim("POR MOTIVOS PESSOAIS.")
		MV_PAR10:=aReturn[8]

      MV_PAR11:=aReturn[9]
      MV_PAR12:=aReturn[10]

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
  //local cTipo

  oprint:SayBitmap(200,100,cBMP,900,200)
  oprint:say(700,900,"FICHA DE DESLIGAMENTO ",oFont15B)
    
   If RepExtract(SRA->RA_XBITMAP,SRA->RA_XBITMAP,.T.,.T.)
     oprint:SayBitmap(200,1860,rTrim(SRA->RA_XBITMAP)+".BMP",400,450)
  Else
     oprint:Box( 200, 1860, 620 ,2210, "-4")
  Endif 

 
  If RepExtract(SRA->RA_BITMAP,SRA->RA_BITMAP,.T.,.T.)
       oprint:SayBitmap(200,1400,rTrim(SRA->RA_BITMAP)+".BMP",400,450)
  Else
    oprint:Box( 200, 1400, 620 ,1750, "-4")
  Endif

return


/*/{Protheus.doc} printBody

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function
/*/
static function printBody()

   local cQuery   := ''
   local cAlias	:= GetNextAlias()
   local aCols   

	local nome
	local cpf
	local rg
   local body

   local filial   := SUBSTR(SRA->RA_FILIAL,1,9) 
   local nMat     := SRA->RA_MAT
   local cfunc     := ''

   If SRA->RA_XTIPO =  '1'
      cfunc := 'Missionária'
   else
      cfunc:= 'Pastora'
   endIF

   dbSelectArea("SRB")
   SRB->(dbSetOrder())
   
   		cQuery	:= "SELECT * FROM SRB020										         " + CRLF
			cQuery	+= "WHERE D_E_L_E_T_ = ' '	AND RB_FILIAL = '"+ filial +"'      " + CRLF
         cQuery   += "AND RB_MAT ='"+ cValToChar(nMat) +"'	                     " + CRLF

			MEMOWRITE("UIMPDR02.SQL",cQuery)
			TCQUERY cQuery NEW ALIAS (cAlias)

   aCols   := {}

         Do While !(cAlias)->(Eof()) 

				aAdd(aCols,{(cAlias)->RB_MAT,;		// Matricula Pastor
				            (cAlias)->RB_NOME,;		// Nome (Conjuge)
				            (cAlias)->RB_CIC ,;     // CPF (Conjuge)
                        (cAlias)->RB_NUMAT})	   // RG (Conjuge)

				(cAlias)->(DbSkip())

			EndDo

   nome  :=IIF(lEmpty," ",aCols[1][2])
	cpf   :=Transform(IIF(lEmpty," ",aCols[1][3]),getsx3cache("RA_CIC","X3_PICTURE"))               
   rg    :=IIF(lEmpty," ",aCols[1][4])
   body  :=''

    body :="Eu, "+rTrim(nome)+", portador (a) da cédula de identidade RG Nº "+rTrim(Rg)+ ", inscrito (a) no CPF/MF sob Nº "+rTrim(cpf)+", sob Matrícula Nº "+allTrim(cvaltochar(nMat))+" declaro que prestava serviços voluntários "+;
           "como Missionária na Igreja Mundial do Poder de Deus "+rTrim(MV_PAR11)+". Pertencente a sede "+rTrim(MV_PAR12)+". Declaro ainda que nesta data "+dtoc(ddatabase)+" estou me desligando deste Ministério Igreja Mundial do Poder de Deus, "+;
           "em razão do motivo exposto abaixo: "+ CRLF
               
    nRow:=900
    nCol:=200
    printMemo(body,90)
    nCol+=100
  
    printMemo(MV_PAR05,80)
    MV_PAR01:= cfunc + "(o): "+ rTrim(nome) +"."
    nRow+=100
    oprint:say(nRow,1400,rTrim(MV_PAR10)+", ____/____/______",oFont12B)
    
return  nil



/*/{Protheus.doc} printInfo

	@author carlos.xavier
	@since 16/03/2017
	@version undefined
	@type function
/*/

static function printInfo()
   
    local nTNome:=getSx3Cache("RA_NOME","X3_TAMANHO")-20
   nRow+=200
   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,MV_PAR01,oFont15,2300,100,,2,0)
   nRow+=150

   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,rTrim(MV_PAR02),oFont15,2300,100,,2,0)
   nRow+=60
   oprint:SayAlign(nRow,100,"Cargo: "+MV_PAR06+".",oFont15,2300,100,,2,0)
   nRow+=40
   oprint:SayAlign(nRow,100,"RG: "+MV_PAR07+".",oFont15,2300,100,,2,0)
   nRow+=40
   oprint:SayAlign(nRow,100,"Testemunha I.",oFont15,2300,100,,2,0)
   nRow+=100
     

   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,MV_PAR03,oFont15,2300,100,,2,0)
   nRow+=60
   oprint:SayAlign(nRow,100,"Cargo: "+MV_PAR08+".",oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,"RG: "+MV_PAR09+".",oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,"Testemunha II.",oFont15,2300,100,,2,0)
   nRow+=150
 
   oprint:SayAlign(nRow,100,Replicate("_",40),oFont15,2300,100,,2,0)
   nRow+=50
   oprint:SayAlign(nRow,100,MV_PAR04,oFont15,2300,100,,2,0)
   nRow+=100
   oprint:say(nRow,1050,"SEDE ESTADUAL",oFont12B)
   nRow+=50
   oprint:say(nRow,870,"Rua: Carneiro Leão, 439 - Bairro Brás",oFont12B)
   nRow+=50
   oprint:say(nRow,950,"São Paulo-SP CEP:03040-000",oFont12B)
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
	     
	      if nT > 10
	         BREAK
	      Endif    
	      
	      nRow+=80
	      oprint:say(nRow,nCol,memoline(string,limit,nT),oFont12B)
	    
	    next nT
	    
    END SEQUENCE
return  "" 
