#include "rwmake.ch"
#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF  ºAutor  ³Carlos R Moreira    º Data ³  21/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o Pedido possui item a ser faturado e que      º±±
±±º          ³ possui Romaneio                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410PVNF()
	Local lRet := .T.

	Local aArea := GetArea()

	If SC5->C5_TIPO $ "D/B/I/P"
		Return .T.
	EndIf

	If !ExisteSX6("MV_XHABFAT")
		CriarSX6("MV_XHABFAT","C","Define se a empresa esta habilitada para Faturar",If(SM0->M0_CODIGO="02","N",""))
	EndIf

    cHabFat := GetMV("MV_XHABFAT")
    
    If cHabFat == "N"
       MsgStop("Empresa esta com o faturamento bloqueado")
       Return 
    EndIf 
    
	cPedido := SC5->C5_NUM
	//Quando se tratar de pedido de Contrato, Verba e Pallet´s deve faturar direto sem as validações dos pedido de venda
	If SC5->C5_ZZTIPO $ "V,T,L,S,O"

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

			If !Empty(SC9->C9_BLEST)
				RecLock("SC9",.F.)
				SC9->C9_BLEST := " "
				MsUnlock()
			EndIf 

			DbSkip()

		End

		Return .T.

	EndIf 

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	If SA1->A1_COD $ "002268,015699"
	   Return .T.
	EndIf 
	
	//Verifica se o pedido possui todos os itens liberados quando se tratar de faturamento antecipado 
/*	If SA1->A1_FATANT == "S"


		//Abro o arquivo de estoque da empresa principal 
		cEmpEst := GetMv("MV_XEMPEST")

		aArqDest := { "SB2" }

		For nX := 1 to Len(aArqDest)

			//Abro os Arquivos nas respectivas empresas
			cArqVar := aArqDest[nX]+cEmpEst+"0"

			DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

			If Select( cArqVar ) > 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ira fazer a abertura do Indice da Tabela ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SIX->(DbSeek(aArqDest[nX]))
				While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
					DbSetIndex(cArqVar+SIX->ORDEM)
					SIX->(DbSkip())
				End
				DbSetOrder(1)

			EndIf

		Next

		//Crio a Variavel para selecionar o arquivo correspondente

		cArqSB2 := "SB2"+cEmpEst+"0"

		lPedBlEst := .F. 
		aProdEst  := {}

		DbSelectArea("SC9")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SC9")+cPedido )

			U_LIBPED(cPedido)

		EndIf

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

			DbSelectArea(cArqSB2)
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

			If ( (cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA )  < SC9->C9_QTDLIB

				cDesc := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")
				lPedBlEst := .T.
				Aadd(aProdEst,{.F.,SC9->C9_PRODUTO,cDesc,SC9->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- SC9->C9_QTDLIB ,SC9->(Recno()) })

			EndIf  

			DbSelectArea('SC9')
			DbSkip()


		End

		If lPedBlEst

			MsgStop("Pedido possui itens com bloqueio de estoque. nao será faturado")

			MostFalEst()

			lRet := .F.  

		Else 

			DbSelectArea("SC9")
			DbSetOrder(1)
			DbSeek(xFilial("SC9")+cPedido )

			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

				DbSelectArea(cArqSB2)
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

				RecLock(cArqSB2,.F.)
				(cArqSB2)->B2_RESERVA += SC9->C9_QTDLIB 
				MsUnlock()

				lRet := .T.

				DbSelectArea("SC9")
				RecLock('SC9',,.F.)
				SC9->C9_BLEST := " "
				MsUnlock()
				DbSkip()

			End

		EndIf  

		(cArqSB2)->(DbCloseArea())

		Return lRet

	Else  */ 

		If ! SC5->C5_STAPED $ "T/D" 
			MsgStop("O Pedido não esta apto para faturamento.." )
			RestArea( aArea )
			Return .F.
		Else
			If !SC5->C5_STAPED $ "T" 
				If SA1->A1_FATANT # "S"	
					MsgStop("O Pedido não esta apto para faturamento.." )
					RestArea( aArea )
					Return .F.
				EndIf 
			EndIf 
		EndIf

//	EndIf 

	If SC5->C5_ZZLIBFI # "S"

		If SA1->A1_RISCO #  "A"

			cQuery := " SELECT  E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO " 
			cQuery += " FROM  "+RetSqlName("SE1")  
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND E1_VENCREA < '"+Dtos(dDataBase)+"' "
			cQuery +=  " AND E1_CLIENTE ='"+SC5->C5_CLIENTE+"' AND E1_LOJA ='"+SC5->C5_LOJACLI+"' "
			cQuery +=  " AND E1_TIPO <> 'NCC' "

			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRY", .F., .T. )

			DbSelectArea("QRY")
			DbGoTop()

			lPendFin := .F.
			If QRY->(!Eof())

				MsgStop("Cliente possui pendencia financeira.")

				lPendFin := .T. 

			EndIf 

			QRY->(DbCloseArea())

			If lPendFin 

				cPedido := SC5->C5_NUM 

				/*
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

				DbSelectArea("ZZR")
				DbSetOrder(2)
				If DbSeek(xFilial("ZZR")+SM0->M0_CODIGO+SC5->C5_NUM )
				RecLock("ZZR",.F.)
				ZZR->(DbDelete())
				MsUnlock()

				EndIf 

				*/

				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED  := "C"
				SC5->C5_ZZLIBFI := "B"
				//				SC5->C5_ROMANEI := " "
				MsUnlock()

				lRet := .F. 
				Return lRet  

			EndIf 

		EndIf 

	EndIf 

	If ! SA1->A1_COD $ "002268,015699"
		DbSelectArea("ZZQ")
		DbSetOrder(1)
		If DbSeek(xFilial("ZZQ")+SC5->C5_ROMANEI )
			If ZZQ->ZZQ_STATUS # "L"
				MsgStop("Romaneio nao liberado para faturamento")
				Return .F. 
			EndIf
		EndIf 

	EndIf 

	cPedido := SC5->C5_NUM

	lPedBlEst := .F. 

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If !Empty(SC9->C9_BLEST)
			lPedBlEst := .T.
			Exit
		EndIf 

		DbSkip()

	End

	If lPedBlEst
		MsgStop("Pedido possui itens com bloqueio de estoque. nao será faturado")
		lRet := .F.  
	EndIf  

	RestArea(aArea)

Return lRet


/*/

Mostra os produto com falta de estoque para o Pedido

/*/
Static Function MostFalEst()
	Local oOK := LoadBitmap(GetResources(),'br_verde')
	Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	Local aList := {}
	Local oDlg 

	DEFINE DIALOG oDlg TITLE "Produto sem Estoque" FROM 180,180 TO 550,1000 PIXEL

	// Cria Browse
	oBrowse := TCBrowse():New( 01 , 01, 410, 156,, {'','Produto','Descricao','Qtd Lib','Est Atu','Reserva','Falta'},{20,50,50,56}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	// Seta vetor para a browse
	oBrowse:SetArray(aProdEst)

	// Monta a linha a ser exibina no Browse
	oBrowse:bLine := {||{ If(aProdEst[oBrowse:nAt,01],oOK,oNO),;
	aProdEst[oBrowse:nAt,02],;
	aProdEst[oBrowse:nAt,03],;
	Transform(aProdEst[oBrowse:nAT,04],'@E 99,999,999,999.99'),;
	Transform(aProdEst[oBrowse:nAT,05],'@E 99,999,999,999.99'),;
	Transform(aProdEst[oBrowse:nAT,06],'@E 99,999,999,999.99'),;	                                    
	Transform(aProdEst[oBrowse:nAT,07],'@E 99,999,999,999.99') } }

	ACTIVATE DIALOG oDlg CENTERED

Return 
