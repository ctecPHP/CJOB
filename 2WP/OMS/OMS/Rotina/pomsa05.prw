#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³POMSA05   ºAutor  ³Carlos R. Moreira   º Data ³  23/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra os romaneio que estao em aberto liberar para         º±±
±±º          ³a programacao de carga                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function POMSA05()

	aIndexZZQ  := {}

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf   

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.",If(SM0->M0_CODIGO="01","02","01"))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	PRIVATE bFiltraBrw := {|| Nil}

	Private cPerg := "POMSA05"
	Private  aRegs := {}


	aAdd(aRegs,{cPerg,"01","Dt Carregamento de ?","","","mv_ch1","D"   ,08    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Dt Carregamento Ate ?","","","mv_ch2","D"   ,08    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T. )


	Private cCadastro := OemToAnsi("Libera romaneio para Programacao")

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Consultar","U_POMSA04C" , 0 , 1},;
	{"Liberar","U_POMSA05L", 0 , 2 , 0 , NIL},;	//
	{"Somar","U_POMSA05S", 0 , 0 , 1 , NIL},;	//	
	{"Legenda","U_PFATA10Legenda", 0 , 0 , 0 , .F.}}		//

	//Ira checar se o usuario tem permissao para acessar a rotina
	Private cCodUsu := __cuserid

	aCores := { { " ZZQ_STATUS = 'L' "  , 'ENABLE' },;
	{ " ZZQ_STATUS = 'F'  " , 'DISABLE'  },;
	{ " ZZQ_STATUS = 'B'  " , 'BR_AMARELO'  },;	
	{ " ZZQ_STATUS = ' '" , 'BR_AZUL_CLARO'  },;
	{ " ZZQ_STATUS = 'O'" , 'BR_CINZA'  }}

	cFiltraZZQ := "ZZQ_STATUS = 'B' .AND. DTOS(ZZQ_DTCARR) >= '"+Dtos(MV_PAR01)+"' .And. DTOS(ZZQ_DTCARR) <= '"+Dtos(MV_PAR02)+"' "

	bFiltraBrw 	:= {|| FilBrowse("ZZQ",@aIndexZZQ,@cFiltraZZQ) }
	Eval(bFiltraBrw)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"ZZQ",,,,,,aCores)//,,"C5_LIBEROK"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw("ZZQ",aIndexZZQ)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a condicao de Entrada                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZZQ")
	dbSetOrder(1)
	dbClearFilter()

Return

/*/

Muda o status do romaneio para que fique liberado 

/*/
User Function POMSA05L()

	If ! MsgYesno("Confirma a liberacao do Romaneio")
		Return 
	EndIF 

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	lLibRom := .F.

	If !ExisteSX6("MV_XEMPEST")
		CriarSX6("MV_XEMPEST","C","Empresa que ira administrar o estoque.",If(SM0->M0_CODIGO="02","01","01"))
	EndIf

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

	//Crio os vetores para armazenar os produtos faltantes e com reserva 
	aProdEst := {} 

	//Crio a Variavel para selecionar o arquivo correspondente

	cArqSB2 := "SB2"+cEmpEst+"0"

	//Verifico a falta de estoque para todos os pedidos do dentro do romaneio 

	DbSelectArea("ZZR" )
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

		If ZZR->ZZR_FATANT == "S"
			DbSkip()
			Loop
		EndIf 

		If ZZR->ZZR_EMP == SM0->M0_CODIGO 

			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

				While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

					If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
						SC9->(DbSkip())
						Loop
					EndIf 

					DbSelectArea(cArqSB2)
					DbSetOrder(1)
					DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

					If (cArqSB2)->B2_QATU < SC9->C9_QTDLIB

						cDesc := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")
						lLibRom := .F.
						Aadd(aProdEst,{.F.,SC9->C9_PRODUTO,cDesc,SC9->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- SC9->C9_QTDLIB  })

					EndIf  

					DbSelectArea("SC9")
					DbSkip()

				End

			EndIf 

		Else

			aArqDest := { "SC9" }
			cEmpLib  := ZZR->ZZR_EMP

			For nX := 1 to Len(aArqDest)

				//Abro os Arquivos nas respectivas empresas
				cArqVar := aArqDest[nX]+cEmpLib+"0"

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

			cArqSC9 := "SC9"+cEmpLib+"0"

			DbSelectArea(cArqSC9)
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

				While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

					If Empty((cArqSC9)->C9_BLEST) .And. Empty((cArqSC9)->C9_BLCRED)
						(cArqSC9)->(DbSkip())
						Loop
					EndIf 

					DbSelectArea(cArqSB2)
					DbSetOrder(1)
					DbSeek(xFilial("SB2")+(cArqSC9)->C9_PRODUTO+(cArqSC9)->C9_LOCAL )

					If (cArqSB2)->B2_QATU < (cArqSC9)->C9_QTDLIB

						cDesc := Posicione("SB1",1,xFilial("SB1")+(cArqSC9)->C9_PRODUTO,"B1_DESC")
						lLibRom := .F.
						Aadd(aProdEst,{.F.,(cArqSC9)->C9_PRODUTO,cDesc,(cArqSC9)->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- (cArqSC9)->C9_QTDLIB  })

					EndIf  

					DbSelectArea(cArqSC9)
					DbSkip()

				End

			EndIf 

			(cArqSC9)->(DbCloseArea())

		EndIf    

		DbSelectArea("ZZR")
		DbSkip()

	End 

	If Len(aProdEst) > 0 
		//Ira mostrar os produtos com falta de estoque
		MostFalEst()
		(cArqSB2)->(DbCloseArea())		
		Return      
	EndIf 

	//Verifico a reserva de estoque para todos os pedidos do dentro do romaneio 

	aProdRes := {}

	DbSelectArea("ZZR" )
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

		If ZZR->ZZR_FATANT == "S"
			DbSkip()
			Loop
		EndIf 

		If ZZR->ZZR_EMP == SM0->M0_CODIGO 

			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

				While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

					If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
						SC9->(DbSkip())
						Loop
					EndIf 

					DbSelectArea(cArqSB2)
					DbSetOrder(1)
					DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

					If ( (cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA )  < SC9->C9_QTDLIB

						cDesc := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")
						lLibRom := .F.
						Aadd(aProdRes,{.F.,SC9->C9_PRODUTO,cDesc,SC9->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- SC9->C9_QTDLIB ,SC9->(Recno()),ZZR->ZZR_EMP })

					EndIf  

					DbSelectArea("SC9")
					DbSkip()

				End

			EndIf 

		Else

			aArqDest := { "SC9" }
			cEmpLib  := ZZR->ZZR_EMP

			For nX := 1 to Len(aArqDest)

				//Abro os Arquivos nas respectivas empresas
				cArqVar := aArqDest[nX]+cEmpLib+"0"

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

			cArqSC9 := "SC9"+cEmpLib+"0"

			DbSelectArea(cArqSC9)
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

				While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

					If Empty((cArqSC9)->C9_BLEST) .And. Empty((cArqSC9)->C9_BLCRED)
						(cArqSC9)->(DbSkip())
						Loop
					EndIf 

					DbSelectArea(cArqSB2)
					DbSetOrder(1)
					DbSeek(xFilial("SB2")+(cArqSC9)->C9_PRODUTO+(cArqSC9)->C9_LOCAL )

					If ( (cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA )  < (cArqSC9)->C9_QTDLIB

						cDesc := Posicione("SB1",1,xFilial("SB1")+(cArqSC9)->C9_PRODUTO,"B1_DESC")
						lLibRom := .F.

						Aadd(aProdRes,{.F.,(cArqSC9)->C9_PRODUTO,cDesc,(cArqSC9)->C9_QTDLIB,(cArqSB2)->B2_QATU,(cArqSB2)->B2_RESERVA,((cArqSB2)->B2_QATU - (cArqSB2)->B2_RESERVA)- (cArqSC9)->C9_QTDLIB ,(cArqSC9)->(Recno()),ZZR->ZZR_EMP })

					EndIf  

					DbSelectArea(cArqSC9)
					DbSkip()

				End

			EndIf 

			(cArqSC9)->(DbCloseArea())

		EndIf    

		DbSelectArea("ZZR")
		DbSkip()

	End 

	If Len(aProdRes) > 0

		//Ira mostrar os produtos com falta de estoque, mas que possui reserva 
		If MostFalRes()
			lLibRom := .T.
		Else
			lLibRom := .F.
		EndIf 

	Else
		lLibRom := .T.  
	EndIf

	If lLibRom 


		DbSelectArea("ZZR" )
		DbSetOrder(1)
		DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

			If ZZR->ZZR_FATANT == "S"
				DbSkip()
				Loop
			EndIf 

			If ZZR->ZZR_EMP == SM0->M0_CODIGO 

				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
							SC9->(DbSkip())
							Loop
						EndIf 

						DbSelectArea(cArqSB2)
						DbSetOrder(1)
						DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

						RecLock(cArqSB2,.F.)
						(cArqSB2)->B2_RESERVA += SC9->C9_QTDLIB 
						MsUnlock()

						DbSelectArea("SC9")
						RecLock('SC9',,.F.)
						SC9->C9_BLEST := " "
						MsUnlock()
						DbSkip()

					End

				EndIf 

			Else

				aArqDest := { "SC9" }
				cEmpLib  := ZZR->ZZR_EMP

				For nX := 1 to Len(aArqDest)

					//Abro os Arquivos nas respectivas empresas
					cArqVar := aArqDest[nX]+cEmpLib+"0"

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

				cArqSC9 := "SC9"+cEmpLib+"0"

				DbSelectArea(cArqSC9)
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						If Empty((cArqSC9)->C9_BLEST) .And. Empty((cArqSC9)->C9_BLCRED)
							(cArqSC9)->(DbSkip())
							Loop
						EndIf 

						DbSelectArea(cArqSB2)
						DbSetOrder(1)
						DbSeek(xFilial("SB2")+(cArqSC9)->C9_PRODUTO+(cArqSC9)->C9_LOCAL )

						RecLock(cArqSB2,.F.)
						(cArqSB2)->B2_RESERVA += (cArqSC9)->C9_QTDLIB 
						MsUnlock()

						DbSelectArea(cArqSC9)
						RecLock(cArqSC9,.F.)
						(cArqSC9)->C9_BLEST := " " 
						MsUnlock()
						DbSkip()

					End

				EndIf 

				(cArqSC9)->(DbCloseArea())

			EndIf    

			DbSelectArea("ZZR")
			DbSkip()

		End 

		DbSelectArea("ZZQ")
		RecLock("ZZQ",.F.)
		ZZQ->ZZQ_STATUS := " "
		MsUnlock() 

		MsgInfo("Romaneio: "+ZZQ->ZZQ_ROMANE+" Liberado com sucesso..")

	EndIf   

	(cArqSB2)->(DbCloseArea())

Return 

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

		If aProdRes[nX,9] == SM0->M0_CODIGO 
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

		Else

			aArqDest := { "SC9" }
			cEmpLib  := aProdRes[nX,9]

			For nArq := 1 to Len(aArqDest)

				//Abro os Arquivos nas respectivas empresas
				cArqVar := aArqDest[nArq]+cEmpLib+"0"

				DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

				If Select( cArqVar ) > 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ira fazer a abertura do Indice da Tabela ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SIX->(DbSeek(aArqDest[nArq]))
					While SIX->INDICE == aArqDest[nArq] .And. SIX->(!Eof())
						DbSetIndex(cArqVar+SIX->ORDEM)
						SIX->(DbSkip())
					End
					DbSetOrder(1)

				EndIf

			Next

			//Crio a Variavel para selecionar o arquivo correspondente

			cArqSC9 := "SC9"+cEmpLib+"0"

			DbSelectArea(cArqSC9)
			DbSetOrder(1)
			DbGoTo(aProdRes[nX,8] )

			If VerPedReserva((cArqSC9)->C9_PRODUTO,(cArqSC9)->C9_QTDLIB)
				lRet := .T. 
				DbSelectArea(cArqSC9)
				RecLock(cArqSC9,.F.)
				(cArqSC9)->C9_BLEST  := " "
				(cArqSC9)->C9_BLCRED := " "
				MsUnlock()

				//Gero a reserva do pedido de venda
				DbSelectArea(cArqSB2)
				RecLock(cArqSB2,.F.)
				(cArqSB2)->B2_RESERVA += (cArqSC9)->C9_QTDLIB 
				MsUnlock()

			Else
				lRet := .F. 
			EndIf 

			(cArqSC9)->(DbCloseArea())

		EndIf 

	Next 

Return lRet 


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

    If Select("TRB") > 0
       TRB->(DbCloseArea())
    EndIf 
     
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

	cLocPad   := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_LOCPAD")
	DbSelectArea(cArqSB2)
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+cProduto+cLocPad )

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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
		//³ arquivo de trabalho "TRB".                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

					If MsgYesNo("Quantidade nao é suficiente para liberar o item do pedido. Selecionar novos pedidos")
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Escola Graduada                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EGF003    ºAutor  ³Microsiga           º Data ³  02/19/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LchoiceBar³ Autor ³ Pilar S Albaladejo    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra a EnchoiceBar na tela                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

Funcao para somar a quantidade que esta sendo liberada 

/*/
User Function POMSA05S()
	Local aArea := GetArea()
	Local oDlg 

	Local nTotLib := 0 

	Local oTotLib

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	cFiltraZZQ := "ZZQ_STATUS = 'B' .AND. DTOS(ZZQ_DTCARR) >= '"+Dtos(MV_PAR01)+"' .And. DTOS(ZZQ_DTCARR) <= '"+Dtos(MV_PAR02)+"' "

	bFiltraBrw 	:= {|| FilBrowse("ZZQ",@aIndexZZQ,@cFiltraZZQ) }
	Eval(bFiltraBrw)

	DbSelectArea("ZZQ")
	DbGoTop()

	While ZZQ->(!Eof())

		nTotLib += ZZQ->ZZQ_QTDCXS 

		DbSkip()
	End

	DEFINE MSDIALOG oDlg FROM  47,130 TO 250,400 TITLE OemToAnsi("Total a Liberar") PIXEL

	@ 05, 04 TO 41,130 LABEL "Quantidade" OF oDlg	PIXEL //

	@ 18, 17 MSGET oTotLib  VAR nTotlib   PICTURE "@e 99,999,999" When .f. SIZE 70,14 FONT oFonte PIXEL;
	OF oDlg  COLOR CLR_HBLUE FONT oFonte RIGHT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botoes para confirmacao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	DEFINE SBUTTON FROM 77, 101 oButton2 TYPE 1 ENABLE OF oDlg ;
	ACTION (oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	RestArea(aArea)

Return 