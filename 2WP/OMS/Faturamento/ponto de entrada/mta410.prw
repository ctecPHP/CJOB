#include "rwmake.ch"
#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA410    บAutor  ณCarlos R. Moreira   บ Data ณ  03/26/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra checar as opcoes de TES dos itens                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA410()
	Local aArea   := GetArea()
	Local lRet    := .T.
	Local nProd   := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
	Local nCF     := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_CF" } )
	Local nTes    := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_TES" } )
	Local nEntreg := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_FECENT" } )
	Local nCst     := Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_CLASFIS" } )
	Local nQtd     := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_QTDVEN"})
	Local nPesoLiq := nPesoBru := 0
	Local nPrcVen  := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_VALOR"})
	Local 	lNMnuVis	:= Isblind()


	If lNMnuVis 
		Return .T. 
	EndIf 

	nPercBon := 0

	SE4->(DbSetOrder(1))

	If !SE4->(DbSeek(xFilial("SE4")+M->C5_CONDPAG ))
		MsgStop("Condicao de Pagamento nao cadastrada...")
		Return .F.
	EndIf

	//Bonificacao
	If M->C5_ZZTIPO == "F"

		If INCLUI .Or. (ALTERA .And. Empty(M->C5_PEDBON))

			cPedBon := SelPedVen()

			If Empty(cPedBon)
				MsgAlert("Na operacao de Bonificacao e necessario o cliente possua um pedido de Venda em Aberto")
				lRet := .F.
			Else
				M->C5_PEDBON  := cPedBon
				M->C5_PERCBON := nPercBon 
			EndIf

		ElseIf Altera

			If Empty(M->C5_PEDBON) 

				cPedBon := SelPedVen()

				If Empty(cPedBon)
					MsgAlert("Na operacao de Bonificacao e necessario o cliente possua um pedido de Venda em Aberto")
					lRet := .F.
				Else
					M->C5_PEDBON := cPedBon
				EndIf

				DbSelectArea("SC5")
				DbSetOrder(1)
				DbSeek(xFilial("SC5")+M->C5_NUM )

			EndIf

		EndIf

	EndIf

	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelPedVen บAutor  ณCarlos R. Moreira   บ Data ณ  19/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona o Pedido de Venda relacionado ao de Bonificacao   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SelPedVen()
	Local cPedido := Space(6)
	Local nPrcVen  := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_VALOR"})

	Local aCampos  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define array para arquivo de trabalho                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(aCampos,{ "OK"       ,"C",  2,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",  6,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C",  6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C",  2,0 } )
	AADD(aCampos,{ "NOME"     ,"C", 30,0 } )			
	AADD(aCampos,{ "VLRPED"   ,"N", 11,2 } )	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta arquivo de trabalho ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cTrab:= CriaTrab(aCampos)
	DbUseArea(.T.,,cTrab,"TRB",,.F. )

	IndRegua("TRB",cTrab,"PEDIDO",,,"Selecionando Registros...")

	cCodRede := Space(3)
	If !Empty(SA1->A1_CODREDE) 

		cCodRede := SA1->A1_CODREDE  

		cQuery := 	"SELECT        SC5.C5_NUM, SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_VLRPED, SC5.C5_QTDPED, SC5.C5_ZZTIPO,SA1.A1_NOME " 
		cQuery += 	"FROM "+RetSqlName("SC5")+" SC5 INNER JOIN " 
		cQuery += 	RetSqlName("SA1")+ " SA1 ON SC5.C5_LOJACLI = SA1.A1_LOJA AND SC5.C5_CLIENTE = SA1.A1_COD "
		cQuery +=  " AND SA1.D_E_L_E_T_ <> '*' AND SA1.A1_CODREDE = '"+cCodRede+"' " 
		cQuery += 	"WHERE SC5.D_E_L_E_T_ <> '*' AND SC5.C5_STAPED <> 'F' AND SC5.C5_ZZTIPO = 'N' AND SC5.C5_PEDBON = ' ' "  

	Else

		cQuery := 	"SELECT        SC5.C5_NUM, SC5.C5_VLRPED, SC5.C5_QTDPED, SC5.C5_ZZTIPO " 
		cQuery += 	"FROM "+RetSqlName("SC5")+" SC5 INNER JOIN " 
		cQuery += 	RetSqlName("SA1")+ " SA1 ON SC5.C5_LOJACLI = SA1.A1_LOJA AND SC5.C5_CLIENTE = SA1.A1_COD "
		cQuery +=  " AND SA1.D_E_L_E_T_ <> '*' " //AND SA1.A1_CODREDE = '"+cCodRede+"' " 
		cQuery += 	"WHERE SC5.D_E_L_E_T_ <> '*' AND SC5.C5_STAPED <> 'F' AND SC5.C5_ZZTIPO = 'N' AND SC5.C5_PEDBON = ' ' "
		cQuery +=   " AND SC5.C5_CLIENTE ='"+M->C5_CLIENTE+"' AND SC5.C5_LOJACLI = '"+M->C5_LOJACLI+"'"  

	EndIf 

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRY", .F., .T. )

	QRY->(DbGoTop())

	ProcRegua(QRY->(RecCount()))

	While QRY->(!Eof())

		IncProc( "Selecionando Pedido.." )

		/*		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+QRY->C6_NUM )
		If !Empty(SC9->C9_ROMANEI)
		DbSelectArea("QRY")
		DbSkip()
		Loop
		EndIf
		EndIf
		*/ 
		DbSelectArea("TRB")

		RecLock("TRB",.T.)
		TRB->PEDIDO  := QRY->C5_NUM
		TRB->VLRPED  := QRY->C5_VLRPED
		If !Empty(cCodRede)
			TRB->CLIENTE := QRY->C5_CLIENTE
			TRB->LOJA    := QRY->C5_LOJACLI
			TRB->NOME    := QRY->A1_NOME
		EndIf  
		MsUnlock()

		QRY->(DbSkip())

	End

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"Pedido","","Pedido"})
	If !Empty(cCodRede)
		AaDD(aBrowse,{"CLIENTE","","Cliente"})
		AaDD(aBrowse,{"LOJA","","Loja"})
		AaDD(aBrowse,{"NOME","","Nome"})			
	EndIf 
	AaDD(aBrowse,{"VLRPED","","Vlr Pedido","@E 999,999,999.99"})

	TRB->(DbGoTop())

	If TRB->(Eof())
		TRB->(DbCloseArea())
		QRY->(DbCloseArea())
		Return cPedido
	EndIf

	Private oDesc, oRede, oTotPed, oPercBon, oVlrPed  

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()
	cTit     := "Selecao de Pedido"

	nPercBon := 0
	nTotPed  := 0


	nVlrPed  := 0

	For nX := 1 to Len(aCols)

		If !aCols[nX,Len(aHeader)+1]

			nVlrPed  += aCols[nX,nPrcVen]

		EndIf

	Next

	cDescRede := Posicione("SX5",1,xFilial("SX5")+"Z1"+cCodRede,"X5_DESCRI")

	DEFINE MSDIALOG oDlg1 TITLE cTit From 9,0 To 35,90 OF oMainWnd

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(cCodRede)

		@ 20, 05 Say OemToAnsi("Rede: ") Size 70,8  OF odlg1 PIXEL
		@ 18, 43  MsGet oRede Var cCodRede  Size 55,10   When .F. OF odlg1 PIXEL 

		@ 20, 100 Say OemToAnsi("Descricao: ") Size 50,8  OF odlg1 PIXEL
		@ 18, 133  MsGet oDesc Var cDescRede Size 105,10   When .F. OF odlg1 PIXEL

		@ 20, 240 Say OemToAnsi("Vlr Ped: ") Size 50,8  OF odlg1 PIXEL
		@ 18, 285  MsGet oVlrPed Var nVlrPed Picture "@E 999,999.99" Size 65,10   When .F. OF odlg1 PIXEL

		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{33,3,163,355})

		oMark:bMark := {| | fa060disp(cMarca,lInverte)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,1) }


	Else

		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{15,3,163,355})

		oMark:bMark := {| | fa060disp(cMarca,lInverte)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,1) }

	EndIf 

	@ 173, 110 Say OemToAnsi("Tot Ped: ") Size 30,8  OF odlg1 PIXEL
	@ 170, 145  MsGet oTotPed Var nTotPed Picture "@e 999,999,999.99" Size 65,10   When .F. OF odlg1 PIXEL

	@ 173, 210 Say OemToAnsi("% Bonif: ") Size 30,8  OF odlg1 PIXEL
	@ 170, 245  MsGet oPercBon Var nPercBon Picture "@e 999,999.99" Size 45,10   When .F. OF odlg1 PIXEL

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},1) centered

	If nOpca == 1

		If !Empty(cCodRede)

			lTemPed := .F.

			DbSelectArea("TRB")
			DbGoTop()
			lTemPed := .F.  
			While TRB->(!Eof())
				If !Empty(TRB->OK)
					If TRB->CLIENTE+TRB->LOJA == M->C5_CLIENTE+M->C5_LOJACLI
						lTemPed := .T.   
					EndIf 

				EndIf

				DbSkip()

			End

			If lTemPed 

				DbSelectArea("TRB")
				DbGoTop()

				lPri := .T.
				While TRB->(!Eof())
					If !Empty(TRB->OK)
						If lPri 
							cPedido := TRB->PEDIDO
							lPri := .F.
						Else
							cPedido += ","+TRB->PEDIDO
						EndIf 

					EndIf

					DbSkip()

				End
			EndIf 
		Else 

			lTemPed := .F.

			DbSelectArea("TRB")
			DbGoTop()
			lTemPed := .F.  
			While TRB->(!Eof())
				If !Empty(TRB->OK)
					lTemPed := .T.   
				EndIf

				DbSkip()

			End

			If lTemPed 

				DbSelectArea("TRB")
				DbGoTop()

				lPri := .T.
				While TRB->(!Eof())
					If !Empty(TRB->OK)
						If lPri 
							cPedido := TRB->PEDIDO
							lPri := .F.
						Else
							cPedido += ","+TRB->PEDIDO
						EndIf 

					EndIf

					DbSkip()

				End
			EndIf 

		EndIf 

	EndIf

	QRY->(DbCloseArea())
	TRB->(DbCloseArea())

Return cPedido

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณFA060Disp ณ Autor ณ Carlos R. Moreira     ณ Data ณ 09/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exibe Valores na tela									  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)

		nRecno := TRB->(Recno())

		DbSelectArea("TRB")
		DbGoTop()

		nTotPed := 0
		While TRB->(!Eof())
			If !Empty(TRB->OK)
				nTotPed += TRB->VLRPED
			EndIf

			DbSkip()

		End

		TRB->(DbGoTo(nRecno))

		nPercBon := Round((nVlrPed / nTotPed) * 100,2)
		If nPercBon  > 100
		   nPercBon := 3
		EndIf    

		oTotPed:Refresh(.T.)
		oPercBon:Refresh(.T.)
		oMark:oBrowse:Refresh(.t.)

	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFa060Inve บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณinverte a Selecao dos Itens                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := TRB->(Recno())
	Local cAlias := Alias()

	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		RecLock("TRB")
		TRB->OK := IIF(TRB->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	TRB->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณLchoiceBarณ Autor ณ Pilar S Albaladejo    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Mostra a EnchoiceBar na tela                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,nOpcao)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcPed() TOOLTIP OemToAnsi("Procura Pedido..")
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "FINAL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}

	//DEFINE BUTTON oBtOk RESOURCE "FINAL" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	//SetKEY(15,oBtOk:bAction)
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcPedidoบAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLocaliza o Pedido                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcPed()
	Local cPedido := Space(6)
	Local oDlgProc


	DEFINE MSDIALOG oDlgProc TITLE "Procura Pedido" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite Pedido :" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cPedido   Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosCliFor(@cPedido,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return


Static Function PosCliFor(cCliFor,oDlgProc)

	TRB->(DbSeek(Alltrim(cCliFor),.T.))

	Close(oDlgProc)

Return

