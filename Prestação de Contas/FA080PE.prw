//======================================
// PE PARA GRAVAR INFORMAÇOES NA SE5
//=====================================
user function FA080PE()   

RECLOCK("SE5",.F.)
SE5->E5_XNOME   := SE2->E2_XNOME    
SE5->E5_XFUNC  := SE2->E2_XFUNC
SE5->(MSUNLOCK())

Return nil	                                 

User Function F70GRSE1()

RECLOCK("SE5",.F.)
SE5->E5_XNOME   := SE1->E1_XNOME    
SE5->E5_XFUNC  := SE1->E1_XFUNC
SE5->(MSUNLOCK())

Return