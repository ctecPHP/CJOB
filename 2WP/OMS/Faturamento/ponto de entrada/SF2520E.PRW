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

User Function SF2520E()
Local aArea := GetArea()
Local cPedido := Space(6)

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA ))

DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE )

While SD2->(!Eof()) .And. SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_DOC+SD2->D2_SERIE
	
	cPedido := SD2->D2_PEDIDO
	
	DbSelectArea("SD2")
	DbSkip()
	
End

//Volta o Status do Pedido para Bloqueio Logistico

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cPedido )

   //Verifico se possui os dados do Romaneio no momento da exclusao da nota
   DbSelectArea("SC9")
   DbSetOrder(1)
   If DbSeek(xFilial("SC9")+cPedido )
   
      nOrdCarg := 1 
      While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido 
      
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
            SC9->C9_ORDCARG := StrZero(nOrdCarg,3)
            MsUnlock()
            
            nOrdCarg++
            
         EndIf 
         
         
         DbSelectArea("SC9")
         DbSkip()
         
      End
       
   EndIf 

    DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_STAPED := "T"
	MsUnlock()

EndIf

RestArea(aArea)

Return
