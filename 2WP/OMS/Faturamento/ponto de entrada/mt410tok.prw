#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "FOLDER.CH"

//---------------------------------------------------------
//
//  Preencher o nome do usuário na SC5010 ->  by TRS
//
//---------------------------------------------------------


User Function MT410TOK
Local aArea		:= GetArea()
Local aAreaSF4	:= SF4->(GetArea())
Local cRegiao	:= SA1->A1_XREGIAO
Local nValFre	:= 0 
Local nPosTES   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})  
Local lDupl		:= .F.
Local 	lNMnuVis	:= Isblind()

lRet := .T.
M->C5_ZZUSER := AllTrim(__CUSERID)

If lNMnuVis 
   Return .T. 
EndIf 
//
//Trata soma dos volumes
//
For nHeader := 1 To Len(aHeader)
	If Alltrim(aHeader[nHeader][2]) = "C6_QTDVEN"
		j:=nHeader
	Endif
Next nHeader

_nTotal := 0
For i:=1 to Len(aCols)     
	DbSelectArea("SF4")
	DbSetOrder(1)
	If SF4->(DbSeek(xFilial("SF4")+aCols[i,nPosTES]))
		If SF4->F4_DUPLIC == "S"
			lDupl	:= .T.
		EndIf	
	EndIf	  
	If aCols[i,Len(aHeader)+1] <> .T.
		_nTotal := _nTotal + aCols[i,j]
	Endif
Next

If MsgBox("Deseja sobrepor o VOLUME no cabeçalho do Pedido, com "+Alltrim(Str(_nTotal))+" "+Alltrim(M->C5_ESPECI1)+", de acordo com a soma dos Itens deste Pedido?", "Pergunta", "YESNO")
	M->C5_VOLUME1 := _nTotal
Endif
  

// Elvis - Tratamento para validação do valor do Frete no Pedido de Venda
If !Empty(cRegiao)
	DbSelectArea("ZZB")
	DbsetOrder(1) //ZZB_FILIAL+COD+ZZB_REGIAO
	If DbSeek(xFilial("ZZB")+cRegiao)
		nValFre := ZZB->ZZB_VLFRET
	EndIf
EndIf
      
If  nValFre <= 0 .and. cRegiao <> "999" .and. lDupl .and. M->C5_TPFRETE == "C" 
	MsgAlert("Atenção. O Pedido de Venda não tem Frete amarrado ao Cliente e não podera ser incluido!")
	lRet	:= .F.
EndIf	

RestArea(aArea)
RestArea(aAreaSF4)
Return lRet


