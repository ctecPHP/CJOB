#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410E   ºAutor  ³Carlos R Moreira    º Data ³  05/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Qdo for Ped Bonificacao volta o pedido de venda para nova   º±±
±±º          ³amarracao                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410E()
	Local aArea := GetArea()

	If SC5->C5_ZZTIPO == "F"

		If !Empty(M->C5_PEDBON)

			nRecnoSC5 := SC5->(Recno())
			cPedVen := Alltrim(M->C5_PEDBON)

			If Len(cPedVen) == 6    

				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+cPedVen )
					RecLock("SC5",.F.)
					SC5->C5_PEDBON := Space(6)
					MsUnlock()
				EndIf

			Else

				nColuna := 1 
				For  nPed := 1 to Len(cPedVen)   

					If Substr(cPedVen,nPed,1) == ","

						DbSelectArea("SC5")
						DbSetOrder(1)
						If DbSeek(xFilial("SC5")+Substr(cPedVen,nColuna,6 ) )

							RecLock("SC5",.F.)
							SC5->C5_PEDBON := Space(6)
							MsUnlock()

						EndIf 

						nColuna := nPed  + 1 

					EndIf

				Next  

			EndIf 

			SC5->(DbGoto(nRecnoSC5))

		EndIf

	EndIf

	RestArea(aArea)

Return

