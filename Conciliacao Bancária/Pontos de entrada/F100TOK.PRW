#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'ParmType.ch'

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯屯屯槐�
北篜rograma  矲100TOK   篈utor  矲elipe Barros     � Data �26/12/2019		    罕�
北掏屯屯屯屯拓屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯贡�
北篋escricao 矲100TOK - Ponto de entrada para validar a movimenta玢o banc醨ia 	罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篜arametros�                                                                  罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篟etorno   � .T.-> para passar na valida玢o / .F.-> Para entrar na condi玢o   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       矷greja Mundial do Poder de Deus                                   罕�
北掏屯屯屯屯拓屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯屯屯贡�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/

User Function F100TOK()
	
	Local lRet := .F.
	Local cConteudo := AllTrim(M->E5_HISTOR)
	
	if cConteudo <> ''
		lRet := .T.
	else
		MsgAlert("O campo <b>Hist髍ico</b> deve ser preenchido!")
	 	lRet := .F.
	endif
	
Return(lRet)