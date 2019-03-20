#Include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     �Autor  �Microsiga           � Data �  08/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona os funcionarios do RH que recebem e-mail de      ���
���          � aviso                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UsrCtrLib()
	Local aCampos := {}
	Local oDlg1, oValor

	AADD(aCampos,{"OK","C",2,0 })
	AADD(aCampos,{"COD","C",6,0 })
	AADD(aCampos,{"NOME","C",30,2 })

	cArqTrab := CriaTrab(aCampos,.T.)
	dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTrab,"NOME",,,"Selecionando Registros..." )

	Private aAllUsers := {}

	nEscolha := Escolha()

	If nEscolha == 1
		If !ExisteSX6("MV_LIBCOM")
			CriarSX6("MV_LIBCOM","C","Guarda os usuarios que possuem autoriza�a� de liberacao comercial","000000")
		EndIf

		cUserLib := Alltrim(GetMV("MV_LIBCOM"))

	ElseIf nEscolha == 2

		If !ExisteSX6("MV_LIBMAR")
			CriarSX6("MV_LIBMAR","C","Guarda os usuarios que possuem autoriza�a� de liberacao Margem","000000")
		EndIf

		cUserLib := Alltrim(GetMV("MV_LIBMAR"))

	ElseIf nEscolha == 3

		If !ExisteSX6("MV_LIBFIN")
			CriarSX6("MV_LIBFIN","C","Guarda os usuarios que possuem autoriza�a� de liberacao Financeira","000000")
		EndIf

		cUserLib := Alltrim(GetMV("MV_LIBMAR"))

	ElseIf nEscolha == 4

		If !ExisteSX6("MV_IMPROM")
			CriarSX6("MV_IMPROM","C","Guarda os usuarios que possuem autoriza�a� de liberacao Financeira","000000")
		EndIf

		cUserLib := Alltrim(GetMV("MV_IMPROM"))

	ElseIf nEscolha == 5

		TRB->(DbCloseArea())

		Return 

	EndIf

	LjMsgRun("Selecionando os usuario..","Aguarde",{||BuscaUsr()} )

	DbSelectArea("TRB")

	cMarca   := GetMark()
	nOpca    :=0
	lInverte := .F.

	For nX := 1 to Len(aAllUsers)

		If ! aAllUsers[nX,1,17]
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->OK   := If(aAllUsers[nX,1,1] $ cUserlib,cMarca," ")
			TRB->COD  := aAllUsers[nX,1,1]
			TRB->NOME := aAllUsers[nX,1,2]
			MsUnlock()
		EndIf

	Next

	TRB->(DbGoTop())

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"COD","","Usuario"})

	//cMarca   := GetMark()
	nOpca    :=0
	lInverte := .F.

	While .T.

		DEFINE MSDIALOG oDlg1 TITLE "Seleciona Usuario" From 9,0 To 37,80 OF oMainWnd

		//����������������������������������������������������������������������Ŀ
		//� Passagem do parametro aCampos para emular tamb�m a markbrowse para o �
		//� arquivo de trabalho "TRB".                                           �
		//������������������������������������������������������������������������
		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{15,3,203,315})

		oMark:bMark := {| | fa060disp(cMarca,lInverte)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

		ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.F.) centered

		If nOpca == 1

			nVez := 0
			TRB->(DbGoTop())

			While TRB->(!Eof())
				If Empty(TRB->OK)
					DbSkip()
					Loop
				EndIf
				nVez++
				TRB->(DbSkip())
			End

			If nVez == 0
				MsgStop("Nao houve selecao de nenhum usuario")
				Loop
			ElseIf nVez > 10
				MsgStop("Selecao de usuarios excedido. Maximo de 5")
				Loop
			EndIf

			cNewUsers := ""
			lPri      := .T.
			TRB->(DbGoTop())

			While TRB->(!Eof())
				If Empty(TRB->OK)
					DbSkip()
					Loop
				EndIf

				If lPri
					cNewUsers := TRB->COD
					lPri := .F.
				Else
					cNewUsers += "#"+TRB->COD
				EndIf

				TRB->(DbSkip())

			End

			If nEscolha == 1

				PutMV( "MV_LIBCOM", cNewUsers )

			ElseIf nEscolha == 2

				PutMV( "MV_LIBMAR", cNewUsers )
				
			ElseIf nEscolha == 3

				PutMV( "MV_LIBFIN", cNewUsers )

			ElseIf nEscolha == 4

				PutMV( "MV_IMPROM", cNewUsers )

			EndIf

			MsgInfo("Usuarios selecionados com sucesso")

			Exit

		Else
			Exit 
		EndIf

	End

	TRB->(DbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     �Autor  �Microsiga           � Data �  08/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BuscaUsr()

	aAllUsers := AllUsers()

Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Escola Graduada                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)

	Else

	Endif
	oMark:oBrowse:Refresh(.t.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EGF003    �Autor  �Microsiga           � Data �  02/19/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := TRB->(Recno())
	Local cAlias := Alias()
	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		RecLock("TRB")
		TRB->OK := IIF(TRB->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	TRB->(dbGoto(nReg))

	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LchoiceBar� Autor � Pilar S Albaladejo    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra a EnchoiceBar na tela                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcUsr() TOOLTIP OemToAnsi("Procura Usuario...")    //
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcTransp�Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Localiza a Transportadora                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Scarlat                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcUsr()
	Local cUsr := Space(30)
	Local oDlgProc


	DEFINE MSDIALOG oDlgProc TITLE "Procura Usuario" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite o Usuario.:" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cUsr Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosUsr(@cUsr,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosUsr(cUsr,oDlgProc)

	TRB->(DbSeek(Alltrim(cUsr),.T.))

	Close(oDlgProc)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Escolha   �Autor  �Carlos R. Moreira   � Data �  09/18/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Seleciona a Opcao desejada                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Escolha()
	Local oDlg2
	Private nRadio := 1
	Private oRadio

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Selecione a Funcao"
	@ 05,05 TO 67,120 TITLE "Selecione"
	@ 10,30 RADIO oRadio Var nRadio Items "Lib Com","Lib Margem","Lib Financ","Imp Romaneio","Sair" 3D SIZE 60,10 of oDlg2 Pixel //,"Fil Compradores"
	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio
