#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATA06   บAutor  ณCarlos R. Moreira   บ Data ณ  26/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra os Pedidos com Liberacao de Adm Pedidos de venda    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFATA06()

	aIndexSC5  := {}

	Private aRotina := {	{	OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0 ,.F.},;		//
	{ OemToAnsi("Visualizar"),"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
	{ OemToAnsi("Liberar"),"U_PFATA06A"	,0,4,20,NIL},;		//"Alterar"
	{ OemToAnsi("Legenda"),"A410Legend"	,0,1,0 ,.F.} }		//"Legenda"

	PRIVATE bFiltraBrw := {|| Nil}

	Private cCadastro := OemToAnsi("Libera็ใo Adm Ped Venda")
	Private cPerg := "PFATA06"

	aCores := { { " C5_STAPED = 'L' "  , 'ENABLE' },;
	{ " C5_STAPED = 'F'  " , 'DISABLE'  },;
	{ " C5_STAPED = 'C'" , 'BR_PINK'  },;
	{ " C5_STAPED = 'T'" , 'BR_LARANJA'  },;
	{ " C5_STAPED = 'P'" , 'BR_BRANCO'  },;
	{ " C5_STAPED = 'S'" , 'BR_MARRON_OCEAN'  },;
	{ " C5_STAPED = 'R'" , 'BR_VIOLETA'  },;	
	{ " C5_STAPED = 'D'" , 'BR_AMARELO'  },;
	{ " C5_STAPED = 'O'" , 'BR_AZUL_CLARO'  },;
	{ " C5_STAPED = 'A'" , 'BR_VERDE_ESCURO' } ,; 		
	{ " C5_STAPED = 'M'" , 'BR_CINZA'  }}

	If !ExisteSX6("MV_XEMPEST")
		CriarSX6("MV_XEMPEST","C","Empresa que ira administrar o estoque.",If(SM0->M0_CODIGO="02","01","01"))
	EndIf

	cEmpEst := GetMv("MV_XEMPEST")

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.",If(SM0->M0_CODIGO="01","02","01"))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	Private  aRegs := {}

	aAdd(aRegs,{cPerg,"01","Entrega    de     ?","","","mv_ch1","D"   ,08    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Entrega    Ate    ?","","","mv_ch2","D"   ,08    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T. )

	cFiltraSC5 := "C5_STAPED = 'L' .And. C5_ZZTIPO $ 'N,F,X,R' .And.DTOS(C5_FECENT) >= '"+Dtos(MV_PAR01)+"' .And. DTOS(C5_FECENT) <= '"+Dtos(MV_PAR02)+"' " 

	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SC5")

	mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)//,,"C5_LIBEROK"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	EndFilBrw("SC5",aIndexSC5)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRestaura a condicao de Entrada                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbClearFilter()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO8     บAutor  ณMicrosiga           บ Data ณ  12/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFATA06A()
	Local oDlg2

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	cUser := RetCodUsr()

	If !MsgYesNo( "Confirma a liberado do Pedido" )
		Return 
	EndIf 

	//Verifico se o pedido de venda da Bonfica็ใo encontra-se liberado 
	If SC5->C5_ZZTIPO == "F"

		cPedBon := SC5->C5_NUM 

		cPedVen := AllTrim(SC5->C5_PEDBON)

		If Empty(cPedVen)

			MsgStop("Pedido de bonificacao nao possui o pedido de venda correspondente.")

			Return

		EndIf 

		nRecSC5 := SC5->(Recno())

		If Len(cPedVen) == 6

			DbSelectArea("SC5")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SC5")+cPedVen )

				MsgStop("Pedido de venda nใo Liberado e a  Bonifica็ใo nใo serแ liberada.")

				SC5->(DbGoTo(nRecSC5))

				Return  

			EndIf 

		Else 

			nColuna := 1 
			For  nPed := 1 to Len(cPedVen)   

				If Substr(cPedVen,nPed,1) == ","

					DbSelectArea("SC5")
					DbSetOrder(1)
					If ! DbSeek(xFilial("SC5")+Substr(cPedVen,nColuna,6 ) )

						MsgStop("Pedido de venda nใo Liberado e a  Bonifica็ใo nใo serแ liberada.")

						SC5->(DbGoTo(nRecSC5))

						Return 

					EndIf 

					nColuna := nPed  + 1 

				EndIf

			Next  

		EndIf 

		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+cPedBon )

	
	EndIf  

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	If SA1->A1_REQAGEN == "S" .Or. SC5->C5_TPFRETE == "F"

		If Empty(SC5->C5_DTAGEN )

			MsgStop("Pedido necessita de agendamento")

			Return 
		EndIf

	EndIf 

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

				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED := "C"
				MsUnlock()

				DbSelectArea("SC9")
				DbSetOrder(1)
				DbSeek(xFilial("SC9")+SC5->C5_NUM)

				While SC9->(!Eof()) .And. SC5->C5_NUM == SC9->C9_PEDIDO 

					RecLock("SC9",.F.)
					SC9->C9_BLCRED := "01"
					MsUnlock()
					DbSkip()

				End 

				Return

			EndIf 

		EndIf 

	EndIf 


	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SC5->C5_NUM )

	While SC6->(!Eof()) .And. SC5->C5_NUM == SC6->C6_NUM 

		DbSelectArea("SC9")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM )

            SB1->(DbSetOrder(1))
            SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO ))
            
			DbSelectArea("SC9")
			RecLock("SC9",.T.)
			SC9->C9_FILIAL  := xFilial("SC9")
			SC9->C9_PEDIDO  := SC6->C6_NUM 
			SC9->C9_ITEM    := SC6->C6_ITEM 
			SC9->C9_CLIENTE := SC5->C5_CLIENTE
			SC9->C9_LOJA    := SC5->C5_LOJACLI
			SC9->C9_PRODUTO := SC6->C6_PRODUTO
			SC9->C9_QTDLIB  := SC6->C6_QTDVEN 
			SC9->C9_DATALIB := dDataBase
			SC9->C9_SEQUEN  := "01"
			SC9->C9_GRUPO   := SB1->B1_GRUPO 
			SC9->C9_PRCVEN  := SC6->C6_PRCVEN 
			SC9->C9_LOCAL   := SC6->C6_LOCAL 
			SC9->C9_TPCARGA := "2"
			SC9->C9_RETOPER := "2"	
			SC9->C9_BLEST   := "02"
			MsUnlock()

		EndIf 				

		DbSelectArea("SC6")
		DbSkip()

	End 

	//Libero o pedido para Gerar Romaneio 

	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_STAPED    := "D"
	SC5->C5_USCUS     := cUser
	SC5->C5_NOMCUST   := Substr(cUsuario,7,15)
	SC5->C5_DTLBCUS   := Date()
	SC5->C5_HRLIBCU   := Time()
	MsUnlock()

	If !Empty(Alltrim(SC5->C5_PEDBON))

		cPedbon := Alltrim(SC5->C5_PEDBON)
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+cPedBon )
			RecLock("SC5",.F.)
			SC5->C5_STAPED    := "D"
			SC5->C5_USCUS     := cUser
			SC5->C5_NOMCUST   := Substr(cUsuario,7,15)
			SC5->C5_DTLBCUS   := Date()
			SC5->C5_HRLIBCU   := Time()
			MsUnlock()
		EndIf 

	EndIf

  	MsgInfo("Pedido liberado com sucesso")

	//Gero filtro novamente
	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)

	Return


	//Inibido pois a libera็ใo sera feita pelo romaneio  
	//Abro o Arquivo de Estoque da empresa principal 

	aArqDest := { "SB2" }

	For nX := 1 to Len(aArqDest)

		//Abro os Arquivos nas respectivas empresas
		cArqVar := aArqDest[nX]+cEmpEst+"0"

		DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

		If Select( cArqVar ) > 0

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณIra fazer a abertura do Indice da Tabela ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM )

		lLibPed := .T.

	Else

		U_LIBPED(SC5->C5_NUM )

		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SC5->C5_NUM )

			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
				RecLock("SC9",.F.)
				SC9->C9_BLCRED := " "
				MsUnlock()
				DbSkip()
			End 
		EndIF 	   
		lLibPed := .T. 
	EndIf     

	aProdEst := {} 
	aProdRes := {}

	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM 

			If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
				SC9->(DbSkip())
				Loop
			EndIf 

			DbSelectArea(cArqSB2)
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

			If (cArqSB2)->B2_QATU < SC9->C9_QTDLIB

				cDesc := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")
				lLibPed := .F.
				Aadd(aProdEst,{.F.,SC9->C9_PRODUTO,cDesc,SC9->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- SC9->C9_QTDLIB  })
				DbSelectArea("SC9")
				DbSkip()
				Loop 
			EndIf  

			DbSelectArea("SC9")
			DbSkip()

		End

	EndIf 

	If Len(aProdEst) == 0 

		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SC5->C5_NUM )

			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM 

				If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
					SC9->(DbSkip())
					Loop
				EndIf 

				DbSelectArea(cArqSB2)
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

				If  ( (cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA )  >= SC9->C9_QTDLIB 

				Else

					cDesc := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")

					Aadd(aProdRes,{.F.,SC9->C9_PRODUTO,cDesc,SC9->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- SC9->C9_QTDLIB ,SC9->(Recno())})

				EndIf 

				DbSelectArea("SC9")
				DbSkip()

			End

			If Len(aProdRes) > 0

				//Ira mostrar os produtos com falta de estoque, mas que possui reserva 
				If MostFalRes()
					lLibPed := .T.
				Else
					lLibPed := .F.
				EndIf 

			Else

				lLibPed := .T. 

			EndIf

		EndIf 

	EndIf 

	If lLibPed 

		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SC5->C5_NUM )

			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM 

				If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
					SC9->(DbSkip())
					Loop
				EndIf 

				DbSelectArea(cArqSB2)
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

				If  ( (cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA )  >= SC9->C9_QTDLIB 

					//Gero a reserva do pedido de venda
					DbSelectArea(cArqSB2)
					RecLock(cArqSB2,.F.)
					(cArqSB2)->B2_RESERVA += SC9->C9_QTDLIB 
					MsUnlock()

					DbSelectArea("SC9")
					RecLock('SC9',.F.)
					SC9->C9_BLEST  := " "
					SC9->C9_BLCRED := " "
					MsUnlock()


				EndIf 

				DbSelectArea("SC9")
				DbSkip()

			End

		EndIf 

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED    := "D"
		SC5->C5_USCUS     := cUser
		SC5->C5_NOMCUST   := Substr(cUsuario,7,15)
		SC5->C5_DTLBCUS   := Date()
		SC5->C5_HRLIBCU   := Time()
		MsUnlock()

		MsgInfo("Pedido liberado com sucesso")

	ElseIf Len(aProdEst) > 0 

		//Ira mostrar os produtos com falta de estoque
		MostFalEst()

	EndIf

	//Fecho o arquivo de Estoque
	(cArqSB2)->(DbCloseArea())

	//Gero filtro novamente
	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)

Return

/*/

Funcao para buscar os pedidos que possuem item reservados 

/*/ 

Static Function VerPedReserva(cProduto,nQtd)
	Local aArea := GetArea()
	Local aCampos := {} 

	AADD(aCampos,{"OK","C",2,0 })
	AADD(aCampos,{"EMP","C",2,0 })
	AADD(aCampos,{"NOMEMP","C",10,0 })
	AADD(aCampos,{"PEDIDO","C",6,0 })
	AADD(aCampos,{"ITEM","C",2,0 })	
	AADD(aCampos,{"QUANT","N",11,0 })
	AADD(aCampos,{"QTDPED","N",11,0 })	
	AADD(aCampos,{"CLIENTE","C",6,0 })
	AADD(aCampos,{"LOJA","C",2,0 })
	AADD(aCampos,{"NOMCLI","C",30,0 })
	AADD(aCampos,{"DTENT","D",8,0 })
	AADD(aCampos,{"ROMANEI","C",6,0 })
	AADD(aCampos,{"C9LOCAL","C",2,0 })	

	cArqTrab := CriaTrab(aCampos,.T.)
	dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
	IndRegua("TRB",cArqTrab,"Dtoc(DTENT)+PEDIDO",,,"Selecionando Registros..." )

	aNomEmp := Array(Len(aEmp))

	DbSelectArea("SM0")

	aAreaSM0 := GetArea()

	DbGotop()
	ProcRegua( RecCount())

	While SM0->(!Eof())

		If SM0->M0_CODFIL # "01"
			SM0->(DbSkip())
			Loop
		EndIf

		If Ascan(aEmp,SM0->M0_CODIGO) > 0
			aNomEmp[Ascan(aEmp,SM0->M0_CODIGO)] := SM0->M0_NOME
		EndIf

		DbSelectArea("SM0")
		SM0->(DbSkip())

	End

	RestArea( aAreaSM0 )

	For nEmp := 1  to Len(aEmp )

		cArqSC9 := "SC9"+aEmp[nEmp]+"0"
		cArqSA1 := "SA1"+aEmp[nEmp]+"0"
		cArqSC5 := "SC5"+aEmp[nEmp]+"0"

		cQuery := "SELECT        SC9.C9_PEDIDO, SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_QTDLIB,SC5.C5_FECENT,SA1.A1_NOME , SC9.C9_ITEM,SC5.C5_QTDPED,SC9.C9_ROMANEI,SC9.C9_LOCAL " 
		cQuery += "FROM " +cArqSC9+" SC9 INNER JOIN " 
		cQuery += cArqSC5+" SC5 ON SC9.C9_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ <> '*' "  
		cQuery += "JOIN "+cArqSA1+" SA1 ON SA1.A1_COD = SC9.C9_CLIENTE AND SA1.A1_LOJA = SC9.C9_LOJA AND SA1.D_E_L_E_T_ <>'*' "    
		cQuery += "	WHERE SC9.D_E_L_E_T_ <> '*' AND SC9.C9_BLEST = ' ' AND SC9.C9_PRODUTO = '"+cProduto+"' " 

		TCSQLExec(cQuery)

		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

		TCSetField("QRY","C5_FECENT","D")
		//		TCSetField("QRY","C5_DTAGEN","D")
		//		TCSetField("QRY","C9_DTCARRE","D")	


		QRY->(DbGotop())

		While QRY->(!Eof())

			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->EMP     := aEmp[nEmp]
			TRB->NOMEMP  := aNomEmp[nEmp] 
			TRB->PEDIDO  := QRY->C9_PEDIDO 
			TRB->ITEM    := QRY->C9_ITEM		
			TRB->CLIENTE := QRY->C9_CLIENTE
			TRB->LOJA    := QRY->C9_LOJA
			TRB->NOMCLI  := QRY->A1_NOME 
			TRB->QUANT   := QRY->C9_QTDLIB
			TRB->QTDPED  := QRY->C5_QTDPED
			TRB->DTENT   := QRY->C5_FECENT
			TRB->ROMANEI := QRY->C9_ROMANEI
			TRB->C9LOCAL := QRY->C9_LOCAL
			MsUnlock()

			DbSelectArea("QRY")
			DbSkip()

		End 

		QRY->(DbCloseArea())

	Next 

	TRB->(DbGoTop())

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"NOMEMP","","Nome Emp"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"QTDPED","","Qtde Ped","@E 9999999"})	
	AaDD(aBrowse,{"ITEM","","Item"})	
	AaDD(aBrowse,{"DTENT","","Entrega"})
	AaDD(aBrowse,{"QUANT","","Qtde","@E 999999"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOMCLI","","Nome Cli"})	
	AaDD(aBrowse,{"ROMANEI","","Romaneio"})					

	Private oProd,oDesc,oQtd, oQtdSel,oQtdEst,oQtdRes,oCliente 

	aCores := {}

	Aadd(aCores, { 'Empty(ROMANEI)' , "ENABLE" } )
	Aadd(aCores, { '!Empty(ROMANEI)', "BR_PRETO" } )


	DbSelectArea(cArqSB2)
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

	cDesc   := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
	cCliente := SC9->C9_CLIENTE+"-"+SC9->C9_LOJA+ " "+Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NREDUZ")
	nQtdSel := 0
	nQtdEst := (cArqSB2)->B2_QATU
	nQtdRes := (cArqSB2)->B2_RESERVA
	nQtdDis := 	(cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA 
	cMarca   := GetMark()
	nOpca    :=0
	lInverte := .F.

	While .T.

		DEFINE MSDIALOG oDlg1 TITLE "Seleciona Pedido" From 9,0 To 37,105 OF oMainWnd

		@ 20, 05 Say OemToAnsi("Produto: ") Size 70,8  OF odlg1 PIXEL
		@ 18, 43  MsGet oProd Var cProduto  Size 55,10   When .F. OF odlg1 PIXEL 

		@ 20, 100 Say OemToAnsi("Descricao: ") Size 50,8  OF odlg1 PIXEL
		@ 18, 133  MsGet oDesc Var cDesc Size 145,10   When .F. OF odlg1 PIXEL

		@ 20, 305 Say OemToAnsi("Qtd: ") Size 30,8  OF odlg1 PIXEL
		@ 18, 335  MsGet oQtd Var nQtd Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		@ 40, 100 Say OemToAnsi("Cliente: ") Size 50,8  OF odlg1 PIXEL
		@ 38, 133  MsGet oCliente Var cCliente Size 145,10   When .F. OF odlg1 PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
		//ณ arquivo de trabalho "TRB".                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{55,3,183,415},,,,,aCores)

		oMark:bMark := {| | fa060disp(cMarca,lInverte)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

		@ 193, 05 Say OemToAnsi("Estoque: ") Size 30,8  OF odlg1 PIXEL
		@ 190, 35  MsGet oQtdEst Var nQtdEst Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		@ 193, 90 Say OemToAnsi("Reserva: ") Size 30,8  OF odlg1 PIXEL
		@ 190,125  MsGet oQtdRes Var nQtdRes Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		@ 193,190 Say OemToAnsi("Qtd Disp.: ") Size 30,8  OF odlg1 PIXEL
		@ 190,225  MsGet oQtdDis Var nQtdDis Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		@ 193, 305 Say OemToAnsi("Qtd Sel: ") Size 30,8  OF odlg1 PIXEL
		@ 190, 335  MsGet oQtdSel Var nQtdSel Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.F.) centered

		If nOpca == 1

			nVez := 0
			TRB->(DbGoTop())

			While TRB->(!Eof())
				If Empty(TRB->OK)
					DbSkip()
					Loop
				EndIf
				nVez++
				TRB->(DbSkip())
			End

			If nVez == 0
				If MsgYesNo("Nao houve selecao de nenhum pedido. Deseja sair ")
					lRet := .F.
					Exit
				Else   
					Loop
				EndIf 

			Else

				nQuant := 0
				TRB->(DbGoTop())

				While TRB->(!Eof())
					If Empty(TRB->OK)
						DbSkip()
						Loop
					EndIf
					nQuant += TRB->QUANT 
					TRB->(DbSkip())
				End

				If ( nQuant+nQtdDis ) < SC9->C9_QTDLIB 

					If MsgYesNo("Quantidade nao ้ suficiente para liberar o item do pedido. Selecionar novos pedidos")
						lRet := .F. 
						Loop
					Else
						lRet := .F.
						Exit 
					EndIf 

				EndIf 

				DbSelectArea("TRB")
				DbGoTop()

				While TRB->(!Eof())

					If Empty(TRB->OK)
						DbSkip()
						Loop
					EndIf

					cPedido := TRB->PEDIDO 

					cArq := "SC9"+TRB->EMP+"0"

					// Atualiza dados do pedido de venda 
					//-------------------------------------------------------------------------------------
					cQuery2 := " UPDATE " + cArq + " SET C9_BLEST = '02' " 
					cQuery2 += " Where D_E_L_E_T_='' and C9_PEDIDO='"+ cPedido  +"' and C9_FILIAL='" + xFilial("SC9") + "' "
					//					cQuery2 += "       AND C9_ITEM = '"+TRB->ITEM+"' "

					If (TCSQLExec(cQuery2) < 0)
						Return MsgStop("Falha na atualizacao do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
					EndIf

					cArq := "SC5"+TRB->EMP+"0"

					// Atualiza dados do pedido de venda 
					//-------------------------------------------------------------------------------------
					cQuery2 := " UPDATE " + cArq + " SET C5_STAPED = 'L' " 
					cQuery2 += " Where D_E_L_E_T_='' and C5_NUM ='"+ cPedido  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

					If (TCSQLExec(cQuery2) < 0)
						Return MsgStop("Falha na atualizacao do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
					EndIf

					cArq := "SC9"+TRB->EMP+"0"

					cQuery2 := " SELECT C9_PEDIDO,C9_PRODUTO,C9_QTDLIB,C9_LOCAL FROM "+cArq 
					cQuery2 += "  Where D_E_L_E_T_ <> '*'  AND C9_PEDIDO = '"+cPedido+"' "      

					TCSQLExec(cQuery2)

					MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRYPED",.T.,.T.)},"Aguarde gerando o arquivo..")

					DbSelectArea("QRYPED")
					DbGoTop()

					While QRYPED->(!Eof()) 

						DbSelectArea(cArqSB2)
						DbSetOrder(1)
						If DbSeek(xFilial("SB2")+QRYPED->C9_PRODUTO+QRYPED->C9_LOCAL )

							RecLock(cArqSB2,.F.)
							(cArqSB2)->B2_RESERVA -= QRYPED->C9_QTDLIB  
							MsUnlock()
						EndIf 

						DbSelectArea("QRYPED") 
						DbSkip()
					End 

					QRYPED->(DbCloseArea())

					DbSelectArea("TRB")
					TRB->(DbSkip())

				End 

			EndIf

			lRet := .T.

			Exit

		Else
			lRet := .F. 
			Exit 
		EndIf

	End

	TRB->(DbCloseArea())

	RestArea(aArea)

Return lRet 

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณFA060Disp ณ Autor ณ Carlos R. Moreira     ณ Data ณ 09/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exibe Valores na tela									  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Especifico Escola Graduada                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)

		If !Empty(TRB->ROMANEI)
			MsgStop("Pedido ja se encontra em Romaneio")
			RecLock("TRB",.F.)
			TRB->OK := Space(2)
			MsUnlock()        
		EndIf 

		nRecTRB := TRB->(Recno())
		nQtdSel:= 0

		DbSelectArea("TRB")
		DbGoTop()

		While TRB->(!Eof())

			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf

			nQtdSel += TRB->QUANT

			DbSkip()

		End

		TRB->(DbGoTo(nRecTRB))

		oQtdSel:Refresh()

	Endif

	oMark:oBrowse:Refresh(.t.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEGF003    บAutor  ณMicrosiga           บ Data ณ  02/19/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
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
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	// 	DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcUsr() TOOLTIP OemToAnsi("Procura Pedido...")    //
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}

Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

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

	/*
	// Evento de clique no cabe็alho da browse
	oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }

	// Evento de duplo click na celula
	oBrowse:bLDblClick := {|| alert('bLDblClick') }

	// Cria Botoes com metodos bแsicos
	TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)

	/*/
	ACTIVATE DIALOG oDlg CENTERED

Return 

/*/

Mostra os produtos que possuem reserva 

/*/
Static Function MostFalRes()

	Local oOK := LoadBitmap(GetResources(),'br_verde')
	Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	Local aList := {}
	Local oDlg, nOpca := 0 

	DEFINE DIALOG oDlg TITLE "Produto Reservados" FROM 180,180 TO 550,1000 PIXEL

	// Cria Browse
	oBrowse := TCBrowse():New( 01 , 01, 410, 156,, {'','Produto','Descricao','Qtd Lib','Est Atu','Reserva','Falta'},{20,50,50,56}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )


	// Seta vetor para a browse
	oBrowse:SetArray(aProdRes)

	// Monta a linha a ser exibina no Browse
	oBrowse:bLine := {||{ If(aProdRes[oBrowse:nAt,01],oNO,oOK),;
	aProdRes[oBrowse:nAt,02],;
	aProdRes[oBrowse:nAt,03],;
	Transform(aProdRes[oBrowse:nAT,04],'@E 99,999,999,999.99'),;
	Transform(aProdRes[oBrowse:nAT,05],'@E 99,999,999,999.99'),;
	Transform(aProdRes[oBrowse:nAT,06],'@E 99,999,999,999.99'),;	                                    
	Transform(aProdRes[oBrowse:nAT,07],'@E 99,999,999,999.99') } }

	/*
	// Evento de clique no cabe็alho da browse
	oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }

	// Evento de duplo click na celula
	oBrowse:bLDblClick := {|| alert('bLDblClick') }

	// Cria Botoes com metodos bแsicos
	TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)

	/*/

	TButton():New( 160, 002, "Liberar", oDlg,{|| nOpca := 1,oDlg:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 160, 062, "Cancelar", oDlg,{|| nOpca := 2,oDlg:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	If nOpca == 1 

		If LibResPed() 
			lRet := .T.
		Else
			lRet := .F.
		EndIf 

	EndIf 

Return lRet

/*/

Ira liberar todos os itens do pedido

/*/

Static Function LibResPed()
	Local lRet := .T. 

	For nX:= 1 to Len(aProdRes)

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbGoTo(aProdRes[nX,8] )

		If VerPedReserva(SC9->C9_PRODUTO,SC9->C9_QTDLIB)
			lRet := .T. 
			DbSelectArea("SC9")
			RecLock('SC9',.F.)
			SC9->C9_BLEST  := " "
			SC9->C9_BLCRED := " "
			MsUnlock()

			//Gero a reserva do pedido de venda
			DbSelectArea(cArqSB2)
			RecLock(cArqSB2,.F.)
			(cArqSB2)->B2_RESERVA += SC9->C9_QTDLIB 
			MsUnlock()

		Else
			lRet := .F. 
		EndIf 

	Next 

Return lRet 

