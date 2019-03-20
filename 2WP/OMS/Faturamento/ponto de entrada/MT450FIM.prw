#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  01/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Informar qual a pessoa que esta      º±±
±±º          ³ Fazendo a liberacao financeira                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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