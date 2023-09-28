USER FUNCTION  IMPDFG001( dDataDig)
	Local dDatRef:= SUPERGETMV("IM_DATFIN", .F. ,'20191231')
  Local lRet := .T.

  If dDataDig <= dDatRef
    MsgAlert('Data digitada invalida  tem que ser maior que: '+ Substr(dTos(dDatRef),7,2)+ '/'+Substr(dTos(dDatRef),5,2)+'/'+Substr(dTos(dDatRef),1,4)+' !!!', 'IMPD')
    lRet := .F.
  EndIf

Return lRet
