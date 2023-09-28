#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE 'TbiConn.ch'
 
/*/{Protheus.doc} User Function IMRELANC
    Relatório em excel de controle de lançamentos.
     @author Felipe Barros
     @since 16/09/2021
     @version 1.0
     @type function
/*/

 User Function IMRELANC()

    Local cPerg	    := "IMRELANC"
    
        If ! Pergunte(cPerg,.T.)
                Return
            Endif
        
        pesquisa()
Return

/*/{Protheus.doc} Pesquisa
    (long_description)
    @type  Static Function
    @author Felipe Barros
    @since 24/09/2021
    @version version
    /*/
Static Function pesquisa()

    local dtSE5     := dtos(MV_PAR01)
    local dtSD1     := dtos(MV_PAR03)
    local dtSE5ate  := dtos(MV_PAR02)
    local dtSD1ate  := dtos(MV_PAR04)
    local nTipo     := MV_PAR05          // TIPO 1 = SE5 Lancs, TIPO 2 = SD1 e TIPO 3 =  SD1 e SE5 Lancs.     
    local cTipo     := ''                // Desc do tipo do Rel.
    local cUsu      := rTrim(MV_PAR06)
    local aCols     := {}
    local aCols2    := {}

    local cQuery    := ""
    local cAlias    := GetNextAlias()

   DO CASE
    CASE nTipo = 1

        dbSelectArea("SE5")
        SE5->(dbSetOrder())

                    cQuery := "    SELECT substring(E5_USERLGI, 3, 1) + substring(E5_USERLGI, 7, 1)+                            " + CRLF
                    cQuery += "            substring(E5_USERLGI, 11, 1) + substring(E5_USERLGI, 15, 1) +                        " + CRLF
                    cQuery += "            substring(E5_USERLGI, 2, 1) + substring(E5_USERLGI, 6, 1) +                          " + CRLF
                    cQuery += "            substring(E5_USERLGI, 10, 1) + substring(E5_USERLGI, 14, 1) +                        " + CRLF
                    cQuery += "            substring(E5_USERLGI, 1, 1) + substring(E5_USERLGI, 5, 1) +                          " + CRLF
                    cQuery += "            substring(E5_USERLGI, 9, 1) + substring(E5_USERLGI, 13, 1) +                         " + CRLF
                    cQuery += "            substring(E5_USERLGI, 17, 1) + substring(E5_USERLGI, 4, 1) +                         " + CRLF
                    cQuery += "            substring(E5_USERLGI, 8, 1) Usuario ,                                                " + CRLF
                    cQuery += "            CONVERT(VARCHAR,                                                                     " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(E5_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(E5_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') ,                                                                                " + CRLF
                    cQuery += "    112) DATA_INCLUSAO, E5_ORIGEM, E5_VALOR                                                      " + CRLF
                    cQuery += "    FROM SE5010                                                                                  " + CRLF        

                    cQuery += "    WHERE E5_USERLGI > '' and                                                                    " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(E5_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(E5_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') >= '"+dtSE5+"'                                                                     " + CRLF
                    cQuery += "    ORDER BY E5_USERLGI;                                                                         " + CRLF

        MEMOWRITE("IMRELANC1.SQL",cQuery)
        TCQUERY cQuery NEW ALIAS (cAlias)
		
        (cAlias)->(DbGoTop())

                Do While !(cAlias)->(Eof())

                    aAdd(aCols,{(cAlias)->Usuario       ,;			
                                (cAlias)->DATA_INCLUSAO ,;
                                (cAlias)->E5_ORIGEM     ,;
                                (cAlias)->E5_VALOR      })

                    (cAlias)->(dbSkip())
                                
                EndDo
        
        cTipo := 'Inclusoes - '

        fwMsgRun(,{|oSay| processaArq( aCols, aCols2, dtSE5, dtSD1, dtSE5ate, dtSD1ate, cTipo, nTipo, cUsu) },"Gerando relatório","Aguarde..." )            

    CASE nTipo = 2

        dbSelectArea("SD1")
        SE5->(dbSetOrder())

                    cQuery := "     SELECT substring(D1_USERLGI, 3, 1) + substring(D1_USERLGI, 7, 1)+                           " + CRLF
                    cQuery += "            substring(D1_USERLGI, 11, 1) + substring(D1_USERLGI, 15, 1) +                        " + CRLF
                    cQuery += "            substring(D1_USERLGI, 2, 1) + substring(D1_USERLGI, 6, 1) +                          " + CRLF
                    cQuery += "            substring(D1_USERLGI, 10, 1) + substring(D1_USERLGI, 14, 1) +                        " + CRLF
                    cQuery += "            substring(D1_USERLGI, 1, 1) + substring(D1_USERLGI, 5, 1) +                          " + CRLF
                    cQuery += "            substring(D1_USERLGI, 9, 1) + substring(D1_USERLGI, 13, 1) +                         " + CRLF
                    cQuery += "            substring(D1_USERLGI, 17, 1) + substring(D1_USERLGI, 4, 1) +                         " + CRLF                
                    cQuery += "            substring(D1_USERLGI, 8, 1) Usuario ,                                                " + CRLF
                    cQuery += "            CONVERT(VARCHAR,                                                                     " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(D1_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(D1_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') ,                                                                                " + CRLF
                    cQuery += "    112) DATA_INCLUSAO, D1_DOC                                                                   " + CRLF
                    cQuery += "    FROM SD1010                                                                                  " + CRLF

                    cQuery += "    WHERE D1_USERLGI > '' and                                                                    " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(D1_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(D1_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') >= '"+dtSD1+"'                                                                     " + CRLF
                    cQuery += "    ORDER BY D1_USERLGI                                                                          " + CRLF
            
        MEMOWRITE("IMRELANC2.SQL",cQuery)
        TCQUERY cQuery NEW ALIAS (cAlias)

        (cAlias)->(DbGoTop())

                Do While !(cAlias)->(Eof())

                    aAdd(aCols2,{(cAlias)->Usuario      ,;			
                                 (cAlias)->DATA_INCLUSAO,;
                                 (cAlias)->D1_DOC       })

                    (cAlias)->(dbSkip())
                                
                EndDo
        
        cTipo := 'Inclusoes - '
    
        fwMsgRun(,{|oSay| processaArq( aCols, aCols2, dtSE5, dtSD1, dtSE5ate, dtSD1ate, cTipo, nTipo, cUsu ) },"Gerando relatório","Aguarde..." )

    CASE nTipo = 3

        dbSelectArea("SE5")
        SE5->(dbSetOrder())

                    cQuery := "    SELECT substring(E5_USERLGI, 3, 1) + substring(E5_USERLGI, 7, 1)+                            " + CRLF
                    cQuery += "            substring(E5_USERLGI, 11, 1) + substring(E5_USERLGI, 15, 1) +                        " + CRLF
                    cQuery += "            substring(E5_USERLGI, 2, 1) + substring(E5_USERLGI, 6, 1) +                          " + CRLF
                    cQuery += "            substring(E5_USERLGI, 10, 1) + substring(E5_USERLGI, 14, 1) +                        " + CRLF
                    cQuery += "            substring(E5_USERLGI, 1, 1) + substring(E5_USERLGI, 5, 1) +                          " + CRLF
                    cQuery += "            substring(E5_USERLGI, 9, 1) + substring(E5_USERLGI, 13, 1) +                         " + CRLF
                    cQuery += "            substring(E5_USERLGI, 17, 1) + substring(E5_USERLGI, 4, 1) +                         " + CRLF
                    cQuery += "            substring(E5_USERLGI, 8, 1) Usuario ,                                                " + CRLF
                    cQuery += "            CONVERT(VARCHAR,                                                                     " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(E5_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(E5_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') ,                                                                                " + CRLF
                    cQuery += "    112) DATA_INCLUSAO, E5_ORIGEM, E5_VALOR                                                      " + CRLF
                    cQuery += "    FROM SE5010                                                                                  " + CRLF        

                    cQuery += "    WHERE E5_USERLGI > '' and                                                                    " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(E5_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(E5_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') >= '"+dtSE5+"'                                                                  " + CRLF
                    cQuery += "    ORDER BY E5_USERLGI;                                                                         " + CRLF

        MEMOWRITE("IMRELANC1.SQL",cQuery)
        TCQUERY cQuery NEW ALIAS (cAlias)
		
        (cAlias)->(DbGoTop())

                Do While !(cAlias)->(Eof())

                    aAdd(aCols,{(cAlias)->Usuario    ,;			
                                (cAlias)->DATA_INCLUSAO ,;
                                (cAlias)->E5_ORIGEM     ,;
                                (cAlias)->E5_VALOR      })

                    (cAlias)->(dbSkip())
                                
                EndDo

        dbCloseArea()

        cAlias    := GetNextAlias()

        dbSelectArea("SD1")
        SE5->(dbSetOrder())

                    cQuery := "     SELECT substring(D1_USERLGI, 3, 1) + substring(D1_USERLGI, 7, 1)+                           " + CRLF
                    cQuery += "            substring(D1_USERLGI, 11, 1) + substring(D1_USERLGI, 15, 1) +                        " + CRLF
                    cQuery += "            substring(D1_USERLGI, 2, 1) + substring(D1_USERLGI, 6, 1) +                          " + CRLF
                    cQuery += "            substring(D1_USERLGI, 10, 1) + substring(D1_USERLGI, 14, 1) +                        " + CRLF
                    cQuery += "            substring(D1_USERLGI, 1, 1) + substring(D1_USERLGI, 5, 1) +                          " + CRLF
                    cQuery += "            substring(D1_USERLGI, 9, 1) + substring(D1_USERLGI, 13, 1) +                         " + CRLF
                    cQuery += "            substring(D1_USERLGI, 17, 1) + substring(D1_USERLGI, 4, 1) +                         " + CRLF                
                    cQuery += "            substring(D1_USERLGI, 8, 1) Usuario ,                                                " + CRLF
                    cQuery += "            CONVERT(VARCHAR,                                                                     " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(D1_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(D1_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') ,                                                                                " + CRLF
                    cQuery += "    112) DATA_INCLUSAO, D1_DOC                                                                   " + CRLF
                    cQuery += "    FROM SD1010                                                                                  " + CRLF

                    cQuery += "    WHERE D1_USERLGI > '' and                                                                    " + CRLF
                    cQuery += "    DATEADD(DAY,                                                                                 " + CRLF
                    cQuery += "    ((ASCII(SUBSTRING(D1_USERLGI,12,1)) - 50) * 100 + (ASCII(SUBSTRING(D1_USERLGI,16,1)) - 50)), " + CRLF
                    cQuery += "    '19960101') >= '"+dtSD1+"'                                                                     " + CRLF
                    cQuery += "    ORDER BY D1_USERLGI                                                                          " + CRLF
            
        MEMOWRITE("IMRELANC2.SQL",cQuery)
        TCQUERY cQuery NEW ALIAS (cAlias)

        (cAlias)->(DbGoTop())

                Do While !(cAlias)->(Eof())

                    aAdd(aCols2,{(cAlias)->Usuario   ,;			
                                 (cAlias)->DATA_INCLUSAO,;
                                 (cAlias)->D1_DOC     })

                    (cAlias)->(dbSkip())
                                
                EndDo

        cTipo := 'Inclusoes - '

        fwMsgRun(,{|oSay| processaArq( aCols, aCols2, dtSE5, dtSD1, dtSE5ate, dtSD1ate, cTipo, nTipo, cUsu ) },"Gerando relatório","Aguarde..." )

    OTHERWISE
        MsgAlert("Erro durante a geração do relatório.")
    ENDCASE 

Return

/*/{Protheus.doc} processaArq
    (long_description)
    @type    Static Function
    @author  Felipe Barros
    @since   23/09/2021
    @version 1.0
/*/
Static Function processaArq(aCols, aCols2, dtSE5, dtSD1, dtSE5ate, dtSD1ate, cTipo, nTipo, cUsu)

    Local aArea        := GetArea()
	Local oFWMsExcel
	Local oExcel
	Local cArquivo     := GetTempPath()+'IMLANC.xml'
	Local nx		   := 0
    Local nAt          := 0
		
		//Criando o objeto que irÃ¡ gerar o conteÃºdo do Excel
		oFWMsExcel := FWMSExcel():New()  

    if nTipo == 1
		//Aba 01 - Pedidos de Venda
		oFWMsExcel:AddworkSheet(cTipo+"SE5")
		//Criando a Tabela
		oFWMsExcel:AddTable(cTipo+"SE5","")
				oFWMsExcel:AddColumn(cTipo+"SE5","","Usuario"      ,1)
				oFWMsExcel:AddColumn(cTipo+"SE5","","Data Inclusao",1)
				oFWMsExcel:AddColumn(cTipo+"SE5","","Origem"       ,1)
                oFWMsExcel:AddColumn(cTipo+"SE5","","Valor"        ,1)		
			
            for nAt := 1 to Len(aCols)
			    if stod(rTrim(aCols[nAt][2])) >= stod(dtSE5)
                    If stod(rTrim(aCols[nAt][2])) <= stod(dtSE5ate)
                        if cUsu == StrTran(rTrim(aCols[nAt][1]),"#@","")
                            oFWMsExcel:AddRow(cTipo+"SE5","",{"" + UsrRetName(StrTran(aCols[nAt][1],"#@","")), stod(aCols[nAt][2]), aCols[nAt][3], aCols[nAt][4]})
                        endif
                    endIF
                endIF
            Next
    elseif nTipo == 2
			oFWMsExcel:AddworkSheet(cTipo+"SD1")
			oFWMsExcel:AddTable(cTipo+"SD1","")
				oFWMsExcel:AddColumn(cTipo+"SD1","","Usuario"         ,1)
				oFWMsExcel:AddColumn(cTipo+"SD1","","Data de Inclusao",1)
				oFWMsExcel:AddColumn(cTipo+"SD1","","Num. Doc."       ,1)

            For nx := 1 to Len(aCols2)
                If stod(rTrim(aCols2[nx][2])) >= stod(dtSD1)
                    if stod(rTrim(aCols2[nx][2])) <= stod(dtSD1ate)
                        if cUsu == StrTran(rTrim(aCols2[nx][1]),"#@","")
                            oFWMsExcel:AddRow(cTipo+"SD1","", {"" + UsrRetName(StrTran(aCols2[nx,1],"#@","")),stod(aCols2[nx,2]),aCols2[nx,3]})
                        endif
                    endIF
                endif
            Next
	else
		oFWMsExcel:AddworkSheet(cTipo+"SE5")
		oFWMsExcel:AddTable(cTipo+"SE5","")
				oFWMsExcel:AddColumn(cTipo+"SE5","","Usuario"      ,1)
				oFWMsExcel:AddColumn(cTipo+"SE5","","Data Inclusao",1)
				oFWMsExcel:AddColumn(cTipo+"SE5","","Origem"       ,1)
                oFWMsExcel:AddColumn(cTipo+"SE5","","Valor"        ,1)		
			
            for nAt := 1 to Len(aCols)
			    if stod(rTrim(aCols[nAt][2])) >= stod(dtSE5)
                    If stod(rTrim(aCols[nAt][2])) <= stod(dtSE5ate)
                        if cUsu == StrTran(rTrim(aCols[nAt][1]),"#@","")
                            oFWMsExcel:AddRow(cTipo+"SE5","",{"" + UsrRetName(StrTran(aCols[nAt][1],"#@","")), stod(aCols[nAt][2]), aCols[nAt][3], aCols[nAt][4]})
                        endif
                    endIF
                endIF
            Next

			oFWMsExcel:AddworkSheet(cTipo+"SD1")
			oFWMsExcel:AddTable(cTipo+"SD1","")
				oFWMsExcel:AddColumn(cTipo+"SD1","","Usuario"         ,1)
				oFWMsExcel:AddColumn(cTipo+"SD1","","Data de Inclusao",1)
				oFWMsExcel:AddColumn(cTipo+"SD1","","Num. Doc."       ,1)

            For nx := 1 to Len(aCols2)
                If stod(rTrim(aCols2[nx][2])) >= stod(dtSD1)
                    if stod(rTrim(aCols2[nx][2])) <= stod(dtSD1ate)
                        if cUsu == StrTran(rTrim(aCols2[nx][1]),"#@","")
                            oFWMsExcel:AddRow(cTipo+"SD1","", {"" + UsrRetName(StrTran(aCols2[nx,1],"#@","")),stod(aCols2[nx,2]),aCols2[nx,3]})
                        endif
                    endIF
                endif
            Next
    endif	

		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)
			
		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()               //Abre uma nova conexÃ£o com Excel
		oExcel:WorkBooks:Open(cArquivo)         //Abre uma planilha
		oExcel:SetVisible(.T.)                  //Visualiza a planilha
		oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
		
		RestArea(aArea)
Return 
