#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410ACE   ºAutor  ³Carlos R. Moreira   º Data ³  08/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se pode alterar o pedido                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT410ACE()
	Local lRet := .T.

	If IsBlind()
		Return lRet
	EndIf 

	nOpc := Paramixb[1]

	If nOpc == 2 .Or. nOpc == 3  
		Return lRet 
	EndIf 

	//Quando se tratar de pedido de pallet e nao estiver faturado o sistema deixara excluir, pois existe cliente que trazem os paletes
	If Substr(SC5->C5_NUM,1,1) == "9" .And. SC5->C5_STAPED # "F"
		Return lRet
	EndIf    

	If SC5->C5_STAPED $ "T,F" .Or. SC5->C5_ZZLIBFI == "B"  
	    If nOpc == 4 
	       If SC5->C5_ZZLIBFI == "B"
	          MsgStop("Cliente bloqueado por pendencia financeira. Pedido não pode ser alterado." )
	       Else
		    MsgStop("Pedido não pode ser alterado." )
		   EndIf  
		ElseIf nOpc == 1 
		    MsgStop("Pedido não pode ser excluido." )		
		EndIf     
		lRet := .F. 
		Return lRet 
	EndIf 

	If nOpc == 1 

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+SC5->C5_NUM )

		While SC6->(!Eof()) .And. SC5->C5_NUM == SC6->C6_NUM 

			RecLock("SC6",.F.)
			SC6->C6_QTDEMP := 0 
			MsUnlock() 
			DbSkip()

		End 

		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SC5->C5_NUM )

			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM 

				If SC9->C9_BLEST == "02"
					RecLock("SC9",.F.)
					SC9->(DbDelete())
					MsUnlock()
				EndIf 

				DbSelectArea("SC9")
				DbSkip()
			End

		EndIf  

	EndIf 

Return lRet 