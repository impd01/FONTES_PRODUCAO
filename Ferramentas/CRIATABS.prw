#include 'protheus.ch'
#include 'parmtype.ch'

Static nAltBot		:= 010
Static nDistPad		:= 002
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaTabs      �Autor�Vinicius Henrique	�Data�  03/08/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Leitura do arquivo txt TABELAS						      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CRIATABS()

	Private cFile	:= ""

	Private lVal	:= .F.

		cFile := cGetFile( "(*.TXT) |*.TXT|","Selecione o arquivo a importar ",,"S:\Outros",.T.,48,.F.)

		If !File(cFile)
			MsgInfo( "Opera��o cancelada ou arquivo inv�lido. Verifique.")
			Return(.F.)
		else			
			MsgRun("Lendo Arquivo" + cFile,"Aguarde",{ || LeArqs() })
		EndIf                                                                  

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LeArqs     �Autor�Vinicius Henrique     �Data�  03/08/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     �Leitura do arquivo txt. TABELAS			 	              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Rodrigo Goltara                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LeArqs() 

	Local nCont 	:= 1
	Local cLinha 	:= ""
	Local nHdI		:= 0
	Local nTamArq	:= 0
	Local nTamLinha := 0
	Local cTab		:= "" //VARIAVEL DAS TABELAS
	
	nHdI := FOpen(cFile,0)

	FSEEK(nHdI,0,0)
	nTamArq := FSEEK(nHdI,0,2)
	FSEEK(nHdI,0,0)
	FCLOSE(nHdI)

	FT_FUSE(cFile)	//Abre o Arquivo
	FT_FGOTOP() 	//Posiciona na primeira linha do arquivo
	nTamLinha := Len(FT_FREADLN()) //verifica tamanho linha
	FT_FGOTOP()
	nLinhas := FT_FLASTREC() //Quantidade de linhas no arquivo

	cLinha := Alltrim(FT_FREADLN())

	ProcRegua(nLinhas)

	While !FT_FEOF()
		If nCont > nLinhas
			Exit
		EndIF
		IncProc("Lendo arquivo texto... Linha "+Alltrim(str(nCont)))
		cLinha := Alltrim(FT_FREADLN())
		nRecno := FT_FRECNO() // Retorna a linha corrente

		If !Empty(cLinha)

				cTab := Substr(cLinha,1,3)

				DbSelectArea(cTab)

				DbCloseArea()

		EndIf	

		FT_FSKIP()
		nCont++

	EndDo

	FT_FUSE()
	fClose(nHdI)

	MsgAlert("Tabelas Criadas com Sucesso","Sucesso")

Return
