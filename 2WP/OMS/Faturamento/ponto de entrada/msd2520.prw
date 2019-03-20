#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   º Autor ³ Jonas L. Souza Jr  º Data ³  09/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE antes da exclusao da NF, para chamada de rotina de      º±±
±±º          ³ estorno e exclusao de NCCs                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MSD2520()
	Local aArea := GetArea()
	Local cPedido := Space(6)

	//Volta o Status do Pedido para Bloqueio Logistico

	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+SD2->D2_PEDIDO )

		//Verifico se possui os dados do Romaneio no momento da exclusao da nota
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV  )

			DbSelectArea("ZZQ")
			DbSetOrder(1)
			If DbSeek(xFilial('ZZQ')+SC5->C5_ROMANEI )
				DbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_ROMANEI := SC5->C5_ROMANEI
				SC9->C9_EMIROM  := ZZQ->ZZQ_EMIROM
				SC9->C9_TRAROM  := ZZQ->ZZQ_TRANSP
				SC9->C9_DTCARRE := ZZQ->ZZQ_DTCARR
				SC9->C9_TIPOVEI := ZZQ->ZZQ_TPVEIC
				SC9->C9_TPCARRO := ZZQ->ZZQ_TPCARG
				//            SC9->C9_ORDCARG := StrZero(nOrdCarg,3)
				MsUnlock()

				//          nOrdCarg++

			EndIf 

		EndIf 

	EndIf

	RestArea(aArea)

Return
