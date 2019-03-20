#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA02   ºAutor  ³Carlos R. Moreira   º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os Pedidos com Bloqueio Comercial                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA02()

	aIndexSC5  := {}

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Visualizar","A410Visual" , 0 , 1},;
	{ "Liberar"   ,"U_PFATA02A" , 0 , 2} }

	PRIVATE bFiltraBrw := {|| Nil}


	If !ExisteSX6("MV_LIBCOM")
		CriarSX6("MV_LIBCOM","C","Guarda os usuarios que possuem autorizaçaõ de liberacao comercial","000000")
	EndIf

	cUserLib := Alltrim(GetMV("MV_LIBCOM"))

	If ! __cUserID $ cUserLib
		MsgStop("Usuario nao autorizado a liberar comercialmente pedidos de vendas.")
		Return 
	EndIf  

	Private cPerg := "PFATA02"

	Private aCores := { { " C5_STAPED = 'L' "  , 'ENABLE' },;
	{ " C5_STAPED = 'F'" , 'DISABLE'  },;
	{ " C5_STAPED = 'C'" , 'BR_PINK'  },;
	{ " C5_STAPED = 'E'" , 'BR_AZUL'  },;
	{ " C5_STAPED = 'P'" , 'BR_LARANJA'  },;
	{ " C5_STAPED = 'A'" , 'BR_BRANCO'  },;
	{ " C5_STAPED = 'S'" , 'BR_MARRON'  },;
	{ " C5_STAPED = 'R'" , 'BR_VIOLETA'  },;
	{ " C5_STAPED = 'D'" , 'BR_AMARELO'  },;
	{ " C5_STAPED = 'M'" , 'BR_CINZA'  }}


	Private  aRegs := {}

	aAdd(aRegs,{cPerg,"01","Seleciona Pedidos somente Bloq  ?","","","mv_ch1","N"  , 01   ,0     ,1   ,"C","" ,"mv_par01","Comercial"  ,"","","","","Rej. Creditoo","","","","","Todos","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T. )


	If MV_PAR01 == 3
	   Private cCadastro := OemToAnsi("Liberação Comercial - Todos ")
		cFiltraSC5 := "( C5_STAPED = 'S' .Or. C5_STAPED = 'R' )"  //.And. C5_OPER # '04'"
	ElseIf MV_PAR01 == 1
	Private cCadastro := OemToAnsi("Liberação Comercial - Bloqueio Comercial")	
		cFiltraSC5 := "C5_STAPED = 'S'" // .And. C5_OPER # '04'"
	Else
		Private cCadastro := OemToAnsi("Rejeicao de credito")
		cFiltraSC5 := "C5_STAPED = 'R'" // .And. C5_OPER # '04'"
	EndIf

	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)//,,"C5_LIBEROK"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw("SC5",aIndexSC5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a condicao de Entrada                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbClearFilter()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³Microsiga           º Data ³  12/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA02A()
	Local oDlg2
	Private nRadio := 1
	Private oRadio
	Private cMotivo := Space(40)

	cUser := RetCodUsr()

	nOpca := 0

	While .T.

		DEFINE MSDIALOG oDlg2 TITLE "Liberacao Comercial" From 9,0 To 22,60 OF oMainWnd

		@ 05,05 TO 70, 80 TITLE "Liberar"
		@ 20,30 RADIO oRadio Var nRadio Items "Sim","Nao" 3D SIZE 60,10 of oDlg2 Pixel

		@ 05,85 TO 70,235 TITLE "Motivo"
		@ 23,90 MSGet cMotivo  Size 100 ,10  of oDlg2 Pixel //Valid !Empty(cMotivo)

		@ 082,110 BUTTON "&Ok"   SIZE 50,15 ACTION {||nOpca:=1,Close(oDlg2)} of oDlg2 Pixel
		@ 082,180 BUTTON "&Sair" SIZE 50,15 ACTION {||nOpca:=3,Close(oDlg2)} of oDlg2 Pixel

		ACTIVATE DIALOG oDlg2 CENTER


		If Empty(cMotivo) .And. nRadio == 2
			Loop
		ElseIf nOpca == 1 .Or. nOpca == 3       
			Exit
		EndIf

	End

	If nOpca == 1

		If nRadio == 1

			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := "L"
			SC5->C5_USLIBC := cUser
			SC5->C5_NOLIBC := Substr(cUsuario,7,15)
			SC5->C5_DTLIBC   := Date()
			SC5->C5_HRLIBC   := Time()
			MsUnlock()

//			CalcMargem()

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

			If SC5->C5_STAPED # "M"

				//			If SA1->A1_RISCO # "A" 
				U_LibPed(SC5->C5_NUM)
				//			EndIf

			EndIf


			/*	
			If !SC5->C5_STAPED $ "M/C"

			//			If !Empty(SC5->C5_PEDBON)

			//				cPedVen := SC5->C5_PEDBON

			// Atualiza o Status do pedido de Bonificacao
			//-------------------------------------------------------------------------------------
			cQuery := " UPDATE " + retsqlname("SC5") + " SET C5_STAPED='L' , C5_USLIBC = '"+cUser+"',  "
			cQuery += " C5_NOLIBC = '"+Substr(cUsuario,7,15)+"'  " //, C5_HRLIBC = '"+Time()+"' "  //C5_DTLIBC = '"+Dtos(Date())+"', C
			cQuery += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedVen  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

			If (TCSQLExec(cQuery) < 0)
			Return MsgStop("Falha na atualizacao do Status do Pedido "+ cPedVen + ".  TCSQLError:"+ TCSQLError())
			EndIf


			EndIf

			EndIf

			*/
		ElseIf nRadio == 2 
		
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := "B"
			SC5->C5_MOTIVO := cMotivo
			SC5->C5_USLIBC := cUser
			SC5->C5_NOLIBC := Substr(cUsuario,7,15)
			SC5->C5_DTLIBC   := Date()
			SC5->C5_HRLIBC   := Time()
			MsUnlock()

		EndIf

	EndIf 

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

