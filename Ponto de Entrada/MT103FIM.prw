#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT103FIM

@author carlos.xavier
@since 17/02/2017
@version 0.0.1
@type function

/*/
user function MT103FIM()

local cAlias:=GetNextAlias()
local cCTR:=""
local cFilCN9:=xFilial("CN9")

local nCTR:=aScan(aHeader,{|x| rTrim(x[2])=="D1_XCONTRA"} )
local nD:=0
local nT:=len(aCols)

local lCheck:=.f.
local lCtr:=.F.


	for nD:=1 to nT
	   
	   if .not.(empty(aCols[nD][nCTR])) 
	   		lCtr:=.t.
	   		cCTR:=aCols[nD][nCTR]
	   		exit 
	   endIF
	   
	next nD
	
	dbSelectArea("SE2")
   	lCheck:=(SF1->F1_DOC == SE2->E2_NUM .and. SF1->F1_SERIE == SE2->E2_PREFIXO)
	
	
   BEGIN TRANSACTION 
	 
	 BEGIN SEQUENCE
	 
	 	IF (.not.(lCheck .and. lCtr ))  
	 	    BREAK
	 	endIF
	 	
	 	beginSql Alias cAlias
	 	
	 		SELECT R_E_C_N_O_ AS REC 
	 		FROM   %TABLE:CN9% CN9 
			WHERE  CN9.%notDel%
			       AND CN9_REVISA = (SELECT Max(CN9_REVISA) 
			                         FROM   %TABLE:CN9% CN92 
			                         WHERE  CN92.%notDel% 
			                                AND CN92.CN9_NUMERO = CN9.CN9_NUMERO 
			                                AND CN92.CN9_FILIAL = CN9.CN9_FILIAL) 
			       AND CN9.CN9_FILIAL = %exp:cFilCN9%
			       AND CN9.CN9_NUMERO = %exp:cCTR%
	 	EndSql
	 	
	    If (cAlias)->(eof())
	       break 
	    endif
	 	
	 	
	 	CN9->(dbGoTo((cAlias)->REC))
	 		recLock("SE2",.f.)
	 		 	SE2->E2_XTPCTO:=CN9->CN9_TPCTO
				SE2->E2_XCONTRA:=CN9->CN9_NUMERO
				SE2->E2_XREG:=CN9->CN9_XREG
				SE2->E2_XRDESC:=CN9->CN9_XRDESC
				SE2->E2_XEND:=CN9->CN9_XEND
				SE2->E2_XBAIRRO:=CN9->CN9_XBAIRR
				SE2->E2_XMUN:=CN9->CN9_XMUN
			SE2->(msUnlock())
	 	(cAlias)->(dbCloseArea())
	 	
	 
	 END SEQUENCE
	 
   END TRANSACTION 

   
   dbSelectArea("SD1")
return