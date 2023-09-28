#Include 'Totvs.ch'

User Function zVldCep()

    Local aArea := FWGetArea()
    Local lOk   := .T.
     
    If .not. empty(ALLTRIM(M->ZS9_CEP))

        If len( ALLTRIM(M->ZS9_CEP) ) == 8
        
            //Busca o CEP conforme o campo informado
            oJson := u_zViaCep(M->ZS9_CEP)
            
            //Se não veio erro, atualiza os outros campos
            If Type("jJson[erro]") == "U"
                M->ZS9_END  := UPPER(DecodeUTF8(oJson['logradouro']))
                M->ZS9_EST  := UPPER(DecodeUTF8(oJson['uf']))
                M->ZS9_CMUN := UPPER(DecodeUTF8(oJson['ibge']))
                M->ZS9_DMUN := UPPER(DecodeUTF8(oJson['localidade']))
                M->ZS9_BAIRRO := UPPER(DecodeUTF8(oJson['bairro']))
                //... Se for MVC, utilizar FWFldPut ou SetValue no Model
            EndIf
        else
            MSGALERT('CEP informado é inválido, favor verificar.')
            lOk := .F.
        Endif
    
    Endif

    FWRestArea(aArea)

Return lOk
