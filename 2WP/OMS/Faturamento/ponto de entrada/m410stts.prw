#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  ºAutor  ³Carlos Moreira      º Data ³  06/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410STTS()
	Local aArea := GetArea()

	Local 	lNMnuVis	:= Isblind()

	If lNMnuVis 
		_cEmail  := " " 
		_cUser   := " "
		//		Return .T. 
	EndIf 

	// Pesquisa e-Mail do Vendedor
	PswOrder(1)
	If PswSeek( __cUserID )
		aRetorno := PswRet(1)
		_cEmail  := Alltrim( aRetorno[1,14] )
		_cUser   := Alltrim( aRetorno[1,04] )
	Endif

	If !ExisteSX6("MV_ZZPBON")
		CriarSX6("MV_ZZPBON","N","Percentual de bonificação aceito no pedido de venda.","3")
	EndIf

	//Coloca a Informacao de quem Incluiu  o Pedido de Venda 
	If Inclui

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_USERINC := __cUserID
		SC5->C5_HRINC   := Time()
		SC5->C5_INCNAME := _cUser
		MsUnlock()

	EndIf

	//Quando for venda para JMT não necessita a liberacao do pedido

	If SC5->C5_CLIENTE == "002268"
		Return 
	Endif 

	If ! SC5->C5_ZZTIPO $ "N,F" 

		LibPed(SC5->C5_NUM)

		If SC5->C5_ZZTIPO $ "R,X"

			//Coloco o status do pedido de troca deixo na adm de pedido 
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := "L" 
			SC5->C5_PEDBON := " "
			MsUnlock()

		Else

			//Coloco o status do pedido de troca deixo na adm de pedido 
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := "O" 
			SC5->C5_PEDBON := " "
			MsUnlock()

		EndIf 

		Return 

	EndIf 

	If (Inclui .Or. Altera) 

		//CalcMargem()

		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

		If SC5->C5_STAPED # "M"

			LibPed(SC5->C5_NUM)

		EndIf 

		/*
		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "S"
		MsUnlock()
		*/
	EndIf 

	nVlrPed  := 0
	nQtdeCxs := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	If DbSeek(xFilial("SC6")+SC5->C5_NUM )

		While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM

			nVlrPed  += SC6->C6_VALOR
			nQtdeCxs += SC6->C6_QTDVEN

			SC6->(DbSkip())

		End

	EndIf

	If Inclui .Or. Altera 

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_VLRPED := nVlrPed
		SC5->C5_QTDPED := nQtdeCxs
		MsUnlock()

	EndIf 

	If SC5->C5_ZZTIPO == "F" //Bonificacao

		nRecSC5 := SC5->(Recno())

		cCliBon := SC5->C5_CLIENTE+SC5->C5_LOJACLI 

		cPedBon := SC5->C5_NUM

		cPedVen := Alltrim(SC5->C5_PEDBON)+"," 

		lAtrelou := .F. 
		nColuna := 1  
		//Busco o(s) Pedido(s) de venda para referenciar a Bonificacao
		For nX := 1 to Len(cPedVen)

			If Substr(cPedVen,nX,1) == ","

				DbSelectArea('SC5')
				DbSetOrder(1)

				If DbSeek(xFilial("SC5")+Substr(cPedVen,nColuna,6 ) )
					If SC5->C5_CLIENTE+SC5->C5_LOJACLI == cCliBon .And. !lAtrelou  
						RecLock("SC5",.F.)
						SC5->C5_PEDBON := cPedBon
						MsUnlock()
						lAtrelou := .T. 
					EndIf

					nColuna := (nX+1)

				EndIf 

			EndIf

		Next 

		nPercBon := GetMv("MV_ZZPBON")

		SC5->(DbGoTo(nRecSC5))

		//Coloco o status do pedido de bonificação de acordo com seu percentual
		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := IF(SC5->C5_PERCBON > nPercBon,"S","L" )
		MsUnlock()

	Else

		If SC5->C5_STAPED # "C"
		
			If SC5->C5_REQAGEN == 'S' .Or. SC5->C5_TPFRETE == "F" 	
				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED  := "A"
				SC5->C5_REQAGEN := IF(SC5->C5_TPFRETE == "F","S",SC5->C5_REQAGEN )
				SC5->C5_DTAGEN  := CTOD("")
				SC5->C5_HRAGEN  := " "			
				MsUnlock()
			EndIf 
		
		EndIf 

	EndIf 

	//Coloco a Zona no pedido de venda 

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	cZona     := Space(6)
	cDescZona := Space(20)

	If SA1->A1_EST == "SP"

		DbSelectArea("DA7")
		DbSetOrder(1)
		DbSeek(xFilial("DA7")+SA1->A1_EST  )

		While DA7->(!Eof()) .And. Substr(DA7->DA7_PERCUR,1,2) == SA1->A1_EST  

			If SA1->A1_CEP >= DA7->DA7_CEPDE .And. SA1->A1_CEP <= DA7->DA7_CEPATE 
				cZona := DA7->DA7_PERCUR
				cDescZona := Posicione("DA5",1,xFilial("DA5")+cZona,"DA5->DA5_DESC")
				Exit  
			EndIf 

			DbSkip()

		End  

	Else

		DbSelectArea("DA7")
		DbSetOrder(4)
		DbSeek(xFilial("DA7")+SA1->A1_COD_MUN )

		While DA7->(!Eof()) .And. DA7->DA7_CODMUN == SA1->A1_COD_MUN 

			If SA1->A1_EST == Substr(DA7->DA7_PERCUR,1,2 )
				cZona := DA7->DA7_PERCUR 
				cDescZona := Posicione("DA5",1,xFilial("DA5")+cZona,"DA5->DA5_DESC")					
				Exit  
			EndIf 

			DbSkip()

		End  

	EndIf 

	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_ZONA    := cZona
	SC5->C5_DESZONA := cDescZona 
	SC5->C5_REQAGEN := IF(SC5->C5_TPFRETE == "F","S",SC5->C5_REQAGEN )	
	MsUnlock()  

	RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcMargemºAutor  ³Carlos R Moreira    º Data ³  06/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz o calculo da Margem de contribuicao                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcMargem(cTipo)
	Local aArea := GetArea()

	nPerIcms := AliqIcms("N","S",SC5->C5_TIPOCLI)
	nPerPis  := GetMv("MV_TXPIS")
	nPerCof  := GetMv("MV_TXCOF")
	nPerContrato := 0 //Posicione("SZ1",1,xFilial("SZ1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"Z1_PERC")
	nTotCus  := nTotQtd := nTotPed := 0

	nVlrtot := 	nVlrIpi  :=	nVlrIcms := nVlrCont := nVlrPis := 	nVlrcof := 0

	nComissao := nFrete := nBonificacao := nDesconto := nVerbas := 0

	nVlrFrete := 0

	aMargens := Array(3)
	Afill(aMargens,0)
	aMargens[1] := 20
	aMargens[2] := 15
	aMargens[3] := 0

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	cMargens := " "

	//	SX5->(DbSetOrder(1))
	//	If SX5->(DbSeek(xFilial("SX5")+"Z5"+SA1->A1_CANAL ))
	//		cMargens := Alltrim(SX5->X5_DESCRI)
	//	EndIf

	aMargens := Array(3)
	Afill(aMargens,0)
	If !Empty(cMargens)
		aMargens[1] := Val(Substr(cMargens,1,3))
		aMargens[2] := Val(Substr(cMargens,4,3))
		aMargens[3] := Val(Substr(cMargens,7,3))
	Else
		aMargens[1] := 20
		aMargens[2] := 15
		aMargens[3] := 0

	EndIf

	nVlrFrete := 0

	/*			
	//Verifico a Meso Regiao do
	DbSelectArea("SZN")
	DbSetOrder(3)
	SZN->(DbSeek(xFilial("SZN")+SA1->A1_COD_MUN+SA1->A1_EST ))

	DbSelectArea("SZY")
	DbSetOrder(1)
	If DbSeek(xFilial("SZY")+SZN->ZN_REGIAO )

	cTransp := Space(6)

	While SZY->(!Eof()) .And. SZN->ZN_REGIAO == SZY->ZY_REGIAO

	//Seleciona a Transportadora principal
	If SZY->ZY_PRINCIP == "S"
	cTransp := SZY->ZY_CODTRA
	Exit
	EndIf

	DbSkip()

	End

	If Empty(cTransp)
	//Pego a primeira transportadora cadastrada
	DbSeek(xFilial("SZY")+SZN->ZN_REGIAO )
	cTransp := SZY->ZY_CODTRA
	EndIf

	Else
	cTransp := Space(6)
	EndIf

	If !Empty(cTransp)

	DbSelectArea("SZ2")
	DbSetOrder(2)
	If !DbSeek(xFilial("SZ2")+cTransp+SZN->ZN_REGIAO )
	nVlrFrete := 0
	Else
	nVlrFrete := SZ2->Z2_VLFREFR
	EndIf

	EndIf
	*/
	// Calcula a Comissao
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1 ))

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SC5->C5_NUM )

	While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM

		SB1->(DbSetorder(1))
		SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO ))

		cAno := StrZero(Year(SC5->C5_EMISSAO),4)

		nMes := Month(SC5->C5_EMISSAO)

		If nMes == 0
			cMes := "12"
			cAno := StrZero(Year(SC5->C5_EMISSAO)-1,4)
		Else
			cMes := StrZero(nMes,2)
		EndIf

		/*		DbSelectArea("SZA")
		SZA->(DbSetOrder(1))

		If SZA->(DbSeek(xFilial("SZA")+SC6->C6_PRODUTO+cAno ))

		cCampo := "ZA_MES"+cMes

		While .T.

		cCampo := "ZA_MES"+cMes

		If SZA->(FieldGet(FieldPos(cCampo))) > 0

		nTotCus += SC6->C6_QTDVEN * SZA->(FieldGet(FieldPos(cCampo)))
		Exit

		Else

		nMes := Val(cMes) - 1
		If nMes > 0
		cMes := StrZero(nMes,2)

		Else */

		SB2->(DbSetorder(1))
		SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))

		nTotCus += SC6->C6_QTDVEN * SB2->B2_CM1
		//						Exit

		//					EndIf
		//				EndIf
		//			End

		//		EndIf

		SF4->(DbSetorder(1))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ))

		nTotQtd   += SC6->C6_QTDVEN

		nVlrtot   += SC6->C6_VALOR
		nVlrIpi   += SC6->C6_VALOR * (SB1->B1_IPI / 100 )
		nVlrIcms  += SC6->C6_VALOR * (nPerIcms / 100 )

		nVlrCont  += SC6->C6_VALOR * (nPerContrato / 100 )

		nVlrPis   += SC6->C6_VALOR * (nPerPis / 100 )

		nVlrcof   += SC6->C6_VALOR * (nPercof  / 100 )

		nFreItem  := 0

		nTotPed   += SC6->C6_VALOR 

		DbSelectArea("SC6")
		DbSkip()

	End

	If SC5->C5_TPFRETE == "C" .And. nFrete == 0
		nFrete := nTotPed * 0.10  // Coloco 15% de frete
	EndIf

	nTotImp   := nVlrIpi + nVlrIcms + nVlrPis + nVlrCof

	nVlrVar   := nDesconto //( nVlrCont + nVerbas  + nBonificacao + nDesconto  )
	nVlrVar2  := nFrete + nComissao
	nVlrLiq   := nTotPed - ( nVlrVar + nTotImp ) // +nVlrVar2
	nPrcLiqCX := nVlrLiq / nTotQtd

	nMargem   := nVlrLiq - nTotCus

	nMargemBru := nTotPed - nVlrVar - nTotImp - nTotCus
	nMargemCon := nMargemBru - nFrete - nComissao

	If nMargemCon < 0 .And. nVlrLiq < 0
		nPerMarCon := ( ( nMargemCon / nVlrLiq ) * 100 ) * -1
	Else
		nPerMarCon := ( nMargemCon / nVlrLiq ) * 100
	EndIf

	If nPerMarCon < aMargens[2]

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "M"
		MsUnlock()

	EndIf

	RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPed    ºAutor  ³Carlos R. Moreira   º Data ³  10/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira liberar o pedido de venda se estiver ok com a lib de    º±±
±±º          ³MArgem                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LibPed(cPedido,lFat)

	wAreaAnt	 := GetArea()
	wAreaSC5	 := SC5->(GetArea())
	wAreaSC6	 := SC6->(GetArea())
	wAreaSC9	 := SC9->(GetArea())
	wAreaSB1	 := SB1->(GetArea())
	wAreaSB2	 := SB2->(GetArea())
	wAreaSF4	 := SF4->(GetArea())
	wAreaSA1	 := SA1->(GetArea())

	Conout("Função de Liberação de Pedido")

	nTipo   := Space(1)
	nStatus := Space(2)


	DbSelectarea("SC6")
	DbSetorder(1)
	DbSeek(xFilial("SC6")+cPedido)

	While !Eof() .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPedido

		DbSelectArea("SF4")
		DbSeek(xFilial("SF4")+SC6->C6_TES)

		DbSelectArea("SB2")
		dBSetOrder(1)
		If dBSeek(xfilial("SB2")+SC6->C6_PRODUTO+SC6->C6_Local) .and.;
		SF4->F4_ESTOQUE=="S"
		Endif

		SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA ))

		dbSelectArea("SC6")

		RecLock("SC6",.F.)
		SC6->C6_QTDLIB := SC6->C6_QTDVEN
		MsUnlock()

		/* MALIBDOFAT
		±±³Parametros³ExpN1: Registro do SC6                                      ³±±
		±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
		±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
		±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
		±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
		±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
		±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
		±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
		±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
		±±³          ³       apenas avalia ).                                     ³±±
		±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
		±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
		±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
		±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
		±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
		±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
		*/
		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.F.,.F.)

		If Substr(SA1->A1_ZZFORPA,1,1) == "D" //Cliente que tem que passar pelo credito 
			Reclock("SC9",.F.)
			SC9->C9_BLCRED := "01"
			MsUnlock()

		EndIf 

		ConOut("MALIBDOFAT Executada")

		dbSelectArea("SC6")
		DBSkip()

	End

	//Verifico se houve duplicidade
	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If SC9->C9_SEQUEN == "02"

			ConOut("Gerando a liberacao pelo M410STTS") 

			cEmp := SM0->M0_CODIGO 
			cArq := "SB2"+cEmp+"0"

			cProduto  := SC9->C9_PRODUTO 
			cLocal    := SC9->C9_LOCAL
			nQtdLib   := SC9->C9_QTDLIB 

			// Atualiza dados do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " UPDATE " + cArq + " SET B2_RESERVA = '"+Str(nQtdLib,11)+" ' "
			cQuery2 += " Where D_E_L_E_T_='' and B2_COD ='"+ cProduto +"' and B2_LOCAL='" + cLocal + "' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Pedido . TCSQLError:"+ TCSQLError())
			EndIf

			DbSelectArea("SC9")
			Reclock("SC9",.F.)
			SC9->(DbDelete())
			MsUnlock()
		EndIf

		SC9->(DbSkip())

	End

	lBlqCred := .F.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED # "10"
			lBlqCred := .T.
			Exit
		EndIf

		SC9->(DbSkip())

	End

	If ! SC5->C5_ZZTIPO $ "N,F"

		Return 

	EndIf 

	//Quando Houver bloqueio de Credito Flega o SC5 e Estorna os empenhos
	If lBlqCred

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

			If !Empty(SC9->C9_BLEST) .Or. SC9->C9_BLEST == "10"
				SC9->(DbSkip())
				Loop
			EndIf

			//Estorno a qtd que gera reserva..
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
				RecLock("SB2",.F.)
				SB2->B2_RESERVA -= SC9->C9_QTDLIB
				MsUnlock()
			Endif

			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
				RecLock("SC6",.F.)
				SC6->C6_QTDLIB := 0
				SC6->C6_QTDEMP := 0
				SC6->C6_QTDEMP2 := 0
				MsUnlock()
			EndIf

			DbSelectArea("SC9")
			RecLock("SC9",.F.)
			SC9->C9_BLEST := "02" 
			MsUnlock()
			SC9->(DbSkip())

		End

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "C"
		MsUnlock()

		// Retorna as areas originais colocado por Keller
		RestArea(wAreaSF4)
		RestArea(wAreaSB2)
		RestArea(wAreaSB1)
		RestArea(wAreaSC9)
		RestArea(wAreaSC6)
		RestArea(wAreaSC5)
		RestArea(wAreaAnt)

		Return 

	EndIf


	//Abro o Arquivo de Estoque da empresa principal 

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

	//Vou deixar com bloqueio de estoque 
	lBlqEst := .F.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If !Empty(SC9->C9_BLEST)
			lBlqEst := .T. 
			SC9->(DbSkip())
			Loop
		EndIf

		//Estorno a qtd que gera reserva..
		DbSelectArea(cArqSB2)
		If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
			RecLock(cArqSB2,.F.)
			(cArqSB2)->B2_RESERVA -= SC9->C9_QTDLIB
			MsUnlock()
		Endif

		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
			RecLock("SC6",.F.)
			SC6->C6_QTDLIB := 0
			SC6->C6_QTDEMP := 0
			SC6->C6_QTDEMP2 := 0
			MsUnlock()
		EndIf


		DbSelectArea("SC9")
		RecLock("SC9",.F.)
		SC9->C9_BLEST := "02" 
		MsUnlock()

		lBlqEst := .T. 

		SC9->(DbSkip())

	End

	(cArqSB2)->(DbCloseArea())

	If Empty(SC5->C5_STAPED) .Or. lBlqEst 

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "L"
		MsUnlock()

	EndIf

	// Retorna as areas originais colocado por Keller
	RestArea(wAreaSF4)
	RestArea(wAreaSB2)
	RestArea(wAreaSB1)
	RestArea(wAreaSC9)
	RestArea(wAreaSC6)
	RestArea(wAreaSC5)
	RestArea(wAreaAnt)

	MsUnlockAll()

Return
