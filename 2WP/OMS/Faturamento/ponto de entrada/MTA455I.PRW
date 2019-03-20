#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA455I   ºAutor  ³Microsiga           º Data ³  01/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA455I()
Local aArea := GetArea()
Local cPedido := SC5->C5_NUM

nSitPed := SitPed()

DbSelectArea("SC5")
RecLock("SC5",.F.)
Do Case
	Case nSitPed == 0
		SC5->C5_STAPED := "L"
	Case nSitPed == 3
		SC5->C5_STAPED := "E"
	Case nSitPed == 5
		SC5->C5_STAPED := "D"
	Case nSitPed == 6
		SC5->C5_STAPED := "P"
EndCase
MsUnlock()

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA455I   ºAutor  ³Microsiga           º Data ³  12/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SitPed()
Local nSitPed := 0
Local cPedido := SC5->C5_NUM

lFatParc := .F.

DbSelectArea("SC6")
DbSetOrder(1)
If DbSeek(xfilial("SC6")+SC5->C5_NUM )
	
	While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
		
		If ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) == 0 .Or. SC6->C6_QTDENT > 0
			lFatParc := .T.
			DbSkip()
			Loop
		EndIf
		
		DbSkip()
		
	End
	
EndIf

If lFatParc
	nSitPed := 6
	Return nSitPed
EndIf

//Verifica o bloqueio de Estoque
lEst  := .F.

BeginSql alias "QRY"
	
	Select * From %Table:SC9%
	Where D_E_L_E_T_ <> '*' AND C9_PEDIDO = %exp:cPedido%
	
EndSql

DbSelectArea("QRY")
DbGoTop()

While QRY->(!Eof())
	
	If QRY->C9_BLEST # "10" .And. !Empty(QRY->C9_BLEST)
		lEst := .T.
		Exit
	EndIf
	
	DbSelectArea("QRY")
	QRY->(DbSkip())
	
End

QRY->(DbCloseArea())

If lEst
	nSitPed := 3
EndIf

BeginSql Alias "QRY"
	
	SELECT     SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC9.C9_QTDLIB, ISNULL(SC9.C9_BLEST,'XX') C9_BLEST, ISNULL(SC9.C9_BLCRED,'XX') C9_BLCRED
	FROM       %table:SC6% SC6 LEFT OUTER  JOIN
	%table:SC9% SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ <> '*'
	WHERE SC6.D_E_L_E_T_ <> '*'  AND SC6.C6_NUM = %exp:cPedido%
	
EndSql

lLibTot := .T.

DbSelectArea("QRY")
DbGoTop()

While QRY->(!Eof())
	
	If QRY->C9_BLEST == "XX"
		lLibTot := .F.
		Exit
	EndIf
	
	DbSelectArea("QRY")
	QRY->(DbSkip())
	
End

QRY->(DbCloseArea())

If !lLibTot
	nSitPed := 5
Else
	nSitPed := 5
EndIf

Return nSitPed