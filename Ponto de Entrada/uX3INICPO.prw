#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} uCNDMUN
	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1	
	@type function
/*/

static function uCNDMUN()

return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_XMUN,"")	

/*/{Protheus.doc} uCNDEND

	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1	
	@type function
/*/
static function uCNDEND()

return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_XEND,"")

/*/{Protheus.doc} uCNDBAIRRO

	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1	
	@type function
/*/
static function uCNDBAIRRO()
 
return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_XBAIRR,"")

/*/{Protheus.doc} uCNDTIPO

	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1
	@type function
/*/
static function uCNDTIPO()

return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_TPCTO,"")

/*/{Protheus.doc} uCNDNUMERO
	
	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1
	@type function
	
/*/
static function uCNDNUMERO()

return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_CN9_NUMERO,"")

/*/{Protheus.doc} uCNDXREG

	@author carlos.xavier
	@since 17/02/2017
	@version 0.0.1
	@type function
	
/*/
static function uCNDXREG()

return iif(funname() $ "CNTA120|CNTA260",CN9->CN9_XREG,"")

