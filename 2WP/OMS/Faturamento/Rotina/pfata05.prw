#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PFATA26  � Autor � Carlos R. Moreira     � Data �28.05.2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Registra os Motivos de Cortes                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Gtex                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PFATA05()
Local oDlg

Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
Private oFont2  := TFont():New( "ARIAL",12.5,12,,.T.,,,,,.F.)
Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)
Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

Private oCod ,oDesMotivo
cCod        := Space(2)
cDesMotivo  := Space(30)

nOpca:=0

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Motivo de Adiamento de Agenda ") From 9,0 To 28,80 OF oMainWnd

@ 10, 10 SAY oSay PROMPT "Codigo :"  PIXEL OF oDlg SIZE 60,14 COLOR CLR_HBLUE FONT oFont2

@  7, 57 MSGET oCod VAR cCod  Valid ChkMotivo(@cCod ) When .T. SIZE 30,14 FONT oFont2 PIXEL OF oDlg  COLOR CLR_HBLUE FONT oFonte CENTER

@ 35, 10 SAY oSay PROMPT "Motivo : "  PIXEL OF oDlg SIZE 60,14 COLOR CLR_HBLUE FONT oFont2

@ 32, 57 MSGET oDesHorario  VAR cDesMotivo    When .T. SIZE 160,14 FONT oFont2 PIXEL OF oDlg  COLOR CLR_HBLUE FONT oFonte CENTER

@ 110,170 Button "&Encerrar"      Size 60,15 Action {nOpca := 1,oDlg:End()} of oDlg Pixel  //FONT oFonte

@ 110,100 Button "&Confirmar"     Size 60,15 Action {nOpca := 2,oDlg:End()} of oDlg Pixel  //FONT oFonte

ACTIVATE MSDIALOG oDlg Centered //ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED

IF nOpca == 2
	
	PFATA05Grava()
	
Else
	MsUnlockAll( )
End

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFATA19   �Autor  �Microsiga           � Data �  05/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PFATA05Grava()

DbSelectArea("SM0")
aAreaSM0 := GetArea()

aEmp := U_SelEmp("V")

RestArea( aAreaSM0 )

For nX := 1 to Len(aEmp)
	
	cArquivo := "SX5"+aEmp[nX]+"0"
	
	DbUseArea(.T.,"TOPCONN",cArquivo,cArquivo,.T.,.F.)
	
	If Select( cArquivo ) > 0
		
		//�����������������������������������������Ŀ
		//�Ira fazer a abertura do Indice da Tabela �
		//�������������������������������������������
		SIX->(DbSeek("SX5"))
		While SIX->INDICE == "SX5" .And. SIX->(!Eof())
			DbSetIndex(cArquivo+SIX->ORDEM)
			SIX->(DbSkip())
		End
		DbSetOrder(1)
		
	EndIf
	
	DbSelectArea(cArquivo)
	DbSetOrder(1)
	If !DbSeek(xFilial("SX5")+"Z7"+cCod )
		
		RecLock(cArquivo,.T.)
		
		(cArquivo)->X5_FILIAL   := xFilial("SX5")
		(cArquivo)->X5_TABELA   := "Z7"
		(cArquivo)->X5_CHAVE    := cCod
		(cArquivo)->X5_DESCRI   := cDesMotivo
		MsUnlock()
	Else
		RecLock(cArquivo,.F.)
		(cArquivo)->X5_DESCRI   := cDesMotivo
		MsUnlock()
	EndIf
	
	(cArquivo)->(DbCloseArea())
	
Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFATA11   �Autor  �Carlos R. Moreira   � Data �  05/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o canal do cliente                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChkMotivo(cCod)
Local lRet := .T.

If !Empty(cCod)
	
	cDesMotivo := Posicione("SX5",1,xFilial("SX5")+"Z7"+cCod,"X5_DESCRI")
	
EndIf

Return  lRet 
