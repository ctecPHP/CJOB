#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA450R   ºAutor  ³Carlos R. Moreira   º Data ³  05/28/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para tratar a rejeicao do pedido de venda  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Scarlat                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mta450r()
Local aArea   := GetArea()
Local aAreaC9 := GetArea("SC9")
Local i 	  := 1
Local cQuery1 := ""
Local cQuery2 := ""
Local cPedido := SC9->C9_PEDIDO

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek(xFilial("SC9")+cPedido )

While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido
	
	If SC9->C9_BLCRED == "10"
		DbSkip()
		Loop
	EndIf
	
	If Empty(SC9->C9_BLEST)
		//Estorno a qtd que gera reserva..
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
			RecLock("SB2",.F.)
			SB2->B2_RESERVA -= SC9->C9_QTDLIB
			MsUnlock()
		Endif
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
		Reclock("SC6",.F.)
		SC6->C6_QTDLIB := 0
		SC6->C6_QTDEMP := 0
		SC6->C6_QTDEMP2 := 0
		
		MsUnlock()
		
	EndIf
	
	DbSelectArea("SC9")
	RecLock("SC9",.F.)
	SC9->(DbDelete()) //C9_BLCRED := "09"
	MsUnlock()
	DbSkip()
	
End

cMotivo := GetMotivo()

// Atualiza o Status Financeiro do pedido 
//-------------------------------------------------------------------------------------
cQuery2 := " UPDATE " + retsqlname("SC5") + " SET C5_STAPED = 'R', C5_MOTIVO='"+cMotivo+"' "
cQuery2 += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedido  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

If (TCSQLExec(cQuery2) < 0)
	Return MsgStop("Falha na atualizacao do Status Financeiro do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
EndIf

RestArea( aAreaC9 )
RestArea( aArea )
Return

/*/

Informa o motivo da rejeicao de credito

/*/
Static Function GetMotivo()
Local cMotivo := Space(60)

	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Motivo da Rejeição" From 9,0 To 18,100 OF oMainWnd

	@ 5,3 to 41,395 of oDlgProc PIXEL

	@ 15,5 Say "Motivo: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cMotivo  Picture "@S50"  Valid !Empty(cMotivo)Size 320 ,10 of oDlgProc Pixel

//	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
	@ 50,120 BMPBUTTON TYPE 1 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered


Return cMotivo 

