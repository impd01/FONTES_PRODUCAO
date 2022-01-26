#include 'protheus.ch'
#include 'parmtype.ch'

/*/ 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDFTP  ³ Autor ³ Vinicius Henrique     ³ Data ³22/02/2019  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conecta no FTP da IMPD.                  	                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IMPDFTP()					                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GALDERMA                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPDFTP()

Local _cSrvFTP		:= SuperGetMV("IM_SRVFTP")                                                  // Servidor FTP
Local _nPrtFTP		:= SuperGetMV("IM_PRTFTP")								// Porta FTP
Local _cUsrFTP		:= SuperGetMV("IM_USRFTP")								// Usuario FTP
Local _cPswFTP		:= SuperGetMV("IM_PSWFTP")								// Senha FTP
Local _lRet			:= .T.
/*
	_cSrvFTP := "ftpboleta2.impd.org.br"
	_nPrtFTP := 21
	_cUsrFTP := "protheus-sftp"
	_cPswFTP := "Impd@Protheus!8352"
*/

FTPDISCONNECT()

If	FTPConnect( _cSrvFTP, _nPrtFTP, _cUsrFTP, _cPswFTP )
	Conout("<<GDEDICONFTP>>..Conexão FTP realizada com sucesso!...")
Else
	Conout("<<GDEDICONFTP>>..Falha de conexao com FTP...")
	_lRet:=.F.
Endif

Return _lRet
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GdEDICpyFTP  ³ Autor ³ Leandro Drumond   ³ Data ³22/10/2010  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia TXT para o FTP.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GdEDICpyFTP(cFile)			                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GALDERMA                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpdCpyFTP(_cFile, cTpFTP)

Local _cDirFTP		:= ""													// diretorio FTP para UPLOAD
Local _cDirFTPUPL	:= ""													// diretorio no FTP para receber arquivo UPLOAD
Local _cDirPath		:= ""													// diretorio para copia e posterior upload
Local _cDirAux		:= ""
Local _cDirBKP		:= ""
Local _lRet			:= .T.													// retorno da funcao
Local cAmbFTP		:= SuperGetMV("IM_AMBFTP")
	
	IF cAmbFTP == 'PRODUCAO'

		If cTpFTP == 'PASTORES'
			_cDirPath := "\Arquivos Boleta\Pastores\"
			_cDirFTPUPL := "/Protheus/Recebidos/Pastores/"
		Elseif cTpFTP == 'IGREJAS'
			_cDirPath := "\Arquivos Boleta\Igrejas\"
			_cDirFTPUPL := "/Protheus/Recebidos/Igrejas/"
		Endif

	Else
	
		If cTpFTP == 'PASTORES'
			_cDirPath := "\Arquivos Boleta\Pastores\"
			_cDirFTPUPL := "/Homologacao/Recebidos/Pastores/"
		Elseif cTpFTP == 'IGREJAS'
			_cDirPath := "\Arquivos Boleta\Igrejas\"
			_cDirFTPUPL := "/Homologacao/Recebidos/Igrejas/"
		Endif
	
	Endif

If _lRet := FTPDirChange(_cDirFTPUPL)
	_cDirFTP:=FTPGetCurDir()
	If _lRet := FTPUpLoad( _cDirPath + _cFile, _cFile  )
		Conout('<<GDEDICPYFTP>>...UpLoad do arquivo ' + _cFile + ' no FTP realizado com sucesso! ')
		If !ExistDir(_cDirBkp)
			MAKEDIR(_cDirBkp)
		EndIf
		__CopyFile(_cFile,_cDirBkp +_cFile) //Copia backup
		Ferase(_cDirPath + _cFile)
		Ferase(_cFile)
	Else
		Conout('<<GDEDICPYFTP>>...UpLoad FTP falha de execução! ')
	Endif
Else
	Conout("<<GDEDICPYFTP>>...Falha no acesso a pasta " + _cDirFTPUPL + "...")
Endif

Return _lRet
