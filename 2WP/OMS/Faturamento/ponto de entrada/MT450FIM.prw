#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     �Autor  �Microsiga           � Data �  01/25/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Informar qual a pessoa que esta      ���
���          � Fazendo a liberacao financeira                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT450FIM()
	Local aArea := GetArea()

	cPedido := ParamIXB[1]

	cUser := RetCodUsr()

	lTotLibPed := .T.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido  )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO = cPedido 

        If Empty(SC9->C9_BLEST)
        EndIf 
        
		If !Empty(SC9->C9_BLCRED) //Item com Bloqueio de Estoque
			RecLock("SC9",.F.)
			SC9->C9_BLCRED := " "
			MsUnlock()
		EndIf

		DbSkip()
	End

	If lTotLibPed

		DbSelectArea("SC5")
		DbSeek(xFilial("SC5")+cPedido)
		RecLock("SC5",.F.)
		SC5->C5_STAPED  := IF(SC5->C5_REQAGEN == "S","A","L" ) 
		SC5->C5_USLIBF  := cUser
		SC5->C5_NOLIBF  := Substr(cUsuario,7,15)
		SC5->C5_DTLIBF  := Date()
		SC5->C5_HRLIBF  := Time()
		MsUnlock()

	EndIf 
	RestArea(aArea)
Return