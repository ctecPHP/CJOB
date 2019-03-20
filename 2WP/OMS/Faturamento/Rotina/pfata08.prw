#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ PFATA08  ณ Autor ณ Carlos R. Moreira     ณ Data ณ19.09.2018ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Registra os Codigos das Redes                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PFATA08()
Local oDlg

Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
Private oFont2  := TFont():New( "ARIAL",12.5,12,,.T.,,,,,.F.)
Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)
Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

Private oCod ,oDesRede  
cCod      := Space(3)
cDesRede  := Space(30)

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial("SX5")+"Z1" )

While SX5->(!Eof()) .And. SX5->X5_TABELA = "Z1" 

   cCod := Alltrim(SX5->X5_CHAVE)
   
   DbSkip()
   
End

cCod := StrZero(Val(cCod)+1,3)

nOpca:=0

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Codigos das Redes ") From 9,0 To 28,80 OF oMainWnd

@ 10, 10 SAY oSay PROMPT "Codigo :"  PIXEL OF oDlg SIZE 60,14 COLOR CLR_HBLUE FONT oFont2

@  7, 57 MSGET oCod VAR cCod  Valid ChkRede(@cCod ) When .T. SIZE 30,14 FONT oFont2 PIXEL OF oDlg  COLOR CLR_HBLUE FONT oFonte CENTER

@ 35, 10 SAY oSay PROMPT "Descricao: "  PIXEL OF oDlg SIZE 60,14 COLOR CLR_HBLUE FONT oFont2

@ 32, 57 MSGET oDesRede    VAR cDesRede      When .T. SIZE 160,14 FONT oFont2 PIXEL OF oDlg  COLOR CLR_HBLUE FONT oFonte CENTER

@ 110,170 Button "&Encerrar"      Size 60,15 Action {nOpca := 1,oDlg:End()} of oDlg Pixel  //FONT oFonte

@ 110,100 Button "&Confirmar"     Size 60,15 Action {nOpca := 2,oDlg:End()} of oDlg Pixel  //FONT oFonte

ACTIVATE MSDIALOG oDlg Centered //ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED

IF nOpca == 2
	
	PFATA08Grava()
	
Else
	MsUnlockAll( )
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATA08   บAutor  ณCarlos R Moreira    บ Data ณ  19/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especiifico                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFATA08Grava()

DbSelectArea("SM0")
aAreaSM0 := GetArea()

aEmp := U_SelEmp1("V")

RestArea( aAreaSM0 )

For nX := 1 to Len(aEmp)
	
	cArquivo := "SX5"+aEmp[nX]+"0"
	
	DbUseArea(.T.,"TOPCONN",cArquivo,cArquivo,.T.,.F.)
	
	If Select( cArquivo ) > 0
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณIra fazer a abertura do Indice da Tabela ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SIX->(DbSeek("SX5"))
		While SIX->INDICE == "SX5" .And. SIX->(!Eof())
			DbSetIndex(cArquivo+SIX->ORDEM)
			SIX->(DbSkip())
		End
		DbSetOrder(1)
		
	EndIf
	
	DbSelectArea(cArquivo)
	DbSetOrder(1)
	If !DbSeek(xFilial("SX5")+"Z1"+cCod )
		
		RecLock(cArquivo,.T.)
		
		(cArquivo)->X5_FILIAL   := xFilial("SX5")
		(cArquivo)->X5_TABELA   := "Z1"
		(cArquivo)->X5_CHAVE    := cCod
		(cArquivo)->X5_DESCRI   := cDesRede   
		MsUnlock()
	Else
		RecLock(cArquivo,.F.)
		(cArquivo)->X5_DESCRI   := cDesRede   
		MsUnlock()
	EndIf
	
	(cArquivo)->(DbCloseArea())
	
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATA11   บAutor  ณCarlos R. Moreira   บ Data ณ  05/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o codigo de rede do cliente                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkRede(cCod)
Local lRet := .T.

If !Empty(cCod)
	
	cDesRede := Posicione("SX5",1,xFilial("SX5")+"Z1"+cCod,"X5_DESCRI")
	
EndIf

Return  lRet 
