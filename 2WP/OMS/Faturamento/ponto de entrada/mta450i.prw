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

User Function MTA450I()
Local aArea := GetArea()

/*
cUser := RetCodUsr()

lTotLibPed := .T.

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek(xFilial("SC9")+SC5->C5_NUM )

While SC9->(!Eof()) .And. SC9->C9_PEDIDO = SC5->C5_NUM
	
	If  SC9->C9_BLEST # "10" //Item com Bloqueio de Estoque
		RecLock("SC9",.F.)
		SC9->C9_BLCRED := " "
        MsUnlock()
	EndIf
	
	DbSkip()

End
*/
/*
DbSelectArea("SC5")
RecLock("SC5",.F.)
SC5->C5_STAPED  := "L" 
SC5->C5_USLIBF  := cUser
SC5->C5_NOLIBF  := Substr(cUsuario,7,15)
SC5->C5_DTLIBF  := Date()
SC5->C5_HRLIBF  := Time()
MsUnlock()
*/ 
RestArea(aArea)
Return
