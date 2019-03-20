#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA07   ºAutor  ³Carlos R. Moreira   º Data ³  13/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira excluir a nota fiscal e seus respectivos vinculos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PFATA07()

	Local lRet := .F.
	Local oFonte
	Local oDlg
	Local oButton2
	Local oButton1
	Local oDoc
	Local oSay
	Local oSay_2
	Local uRet
	nOpca := 0

	//	If SM0->M0_CODIGO == "01"
	//		MsgStop("Rotina nao pode ser executada na empresa "+SM0->M0_CODIGO )
	//	EndIf 

	If !ExisteSX6("MV_XEMPTRA")
		CriarSX6("MV_XEMPTRA","C","Empresa que ira gerar a nota de transferencia.",If(SM0->M0_CODIGO="02","0101",""))
	EndIf

	If !ExisteSX6("MV_CLITRAN")
		CriarSX6("MV_CLITRAN","C","Cliente que ira gerar a nota de transferencia.","002268")
	EndIf

	If !ExisteSX6("MV_FORTRAN")
		CriarSX6("MV_FORTRAN","C","Fornecedor que ira gerar a nota de transferencia.","000147")
	EndIf

	cEmpTrans := Substr(Alltrim(GetMV("MV_XEMPTRA")),1,2)
	cFilTrans := Substr(Alltrim(GetMV("MV_XEMPTRA")),3,2)

	//	If Empty(cEmpTrans)

	//		Return

	//	EndIf 

	cCliTrans := Alltrim(GetMV("MV_CLITRAN"))

	cForTrans := Alltrim(GetMV("MV_FORTRAN"))

	Private cDoc

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	While .T.

		cDoc := Space(09)

		DEFINE MSDIALOG oDlg FROM  47,130 TO 300,500 TITLE OemToAnsi("Exclusao de Nota Especifica") PIXEL

		@ 05, 04 TO 41,180 LABEL "Num. Nota   " OF oDlg	PIXEL //

		@ 18, 17 MSGET oDoc   VAR cDoc    PICTURE "999999999" SIZE 70,14 FONT oFonte PIXEL;
		OF oDlg  COLOR CLR_HBLUE FONT oFonte RIGHT  //Valid ChkTitulo(@cTitulo,oSay)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botoes para confirmacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


		DEFINE SBUTTON FROM 77,  71 oButton1 TYPE 1 ENABLE OF oDlg ;
		ACTION {|| nOpca := 1, oDlg:End()} PIXEL

		DEFINE SBUTTON FROM 77, 101 oButton2 TYPE 2 ENABLE OF oDlg ;
		ACTION (nOpca := 2,oDlg:End()) PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 2
			Exit
		Else

			Processa({||ExcNota()},"Excluindo a nota.. ")	

		EndIf

	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcNota   ºAutor  ³Carlos R. Moreira   º Data ³  13/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira excluir a nota fiscal e seus respectivos vinculos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExcNota()

	aRegSd2   := {}
	aRegSe1   := {}
	aRegSe2   := {}

	aItens := {}

	cEmpOri := SM0->M0_CODIGO 
	cFilOri := SM0->M0_FILIAL 

	lMsErroAuto := .F. 

	DbSelectArea("SF2")
	DbSetOrder(1)
	If ! DbSeek(xFilial("SF2")+cDoc )

		MsgStop("Nota nao cadastrada.")

		Return 

	EndIf 

	If Empty(SF2->F2_DOC_INT)

		cPedido := Space(6)

		DbSelectArea("SD2")
		DbSetOrder(3)
		DbSeek(xFilial("SD2")+cDoc )

		While SD2->(!Eof()) .And. cDoc == SD2->D2_DOC

			cPedido := SD2->D2_PEDIDO

			DbSelectArea("SD2")
			DbSkip()

		End

		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+cDoc )

		If MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o documento de saida                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
			SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,.F.))

		EndIf

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
					RecLock("SC9",.F.)
					SC9->C9_BLEST := " "
					MsUnlock()
					DbSkip()

				End

			EndIf 

			//Volto o status do Romaneio 
			DbSelectArea("ZZR")
			DbSetOrder(2)
			If DbSeek(xFilial("ZZR")+SM0->M0_CODIGO+cPedido)
				RecLock("ZZR",.F.)
				ZZR->ZZR_STAFAT := " "
				ZZR->ZZR_NOTA   := " "
				MsUnlock()
			EndIf 

			DbSelectArea("ZZQ")
			DbSetOrder(1)
			If DbSeek(xFilial('ZZQ')+SC5->C5_ROMANEI) 
				RecLock('ZZQ',.F.)
				ZZQ->ZZQ_STATUS := "L"
				MsUnlock()

			EndIf 

			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := If(Empty(SC5->C5_ROMANEI),"D","T")
			MsUnlock()

		EndIf

	Else 

		cNota  := SF2->F2_DOC_INT
		cSerie := SF2->F2_SER_INT

		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+cForTrans)

		//Vou excluir a entrada da nota na empresa atual 
		DbSelectArea("SF1")
		DbSetOrder(1)
		If DbSeek(xFilial("SF1")+cNota+cSerie+cForTrans )

			aCabec := {}
			//ExpA1 - Array contendo os dados do cabeçalho da Nota Fiscal de Entrada.
			aadd(aCabec,{"F1_TIPO" , "N" , Nil})
			aadd(aCabec,{"F1_FORMUL" , "N" , Nil})
			aadd(aCabec,{"F1_DOC" , cNota , Nil})
			aadd(aCabec,{"F1_SERIE" , cSerie , Nil})
			aadd(aCabec,{"F1_EMISSAO" , dDataBase , Nil})
			aadd(aCabec,{"F1_DESPESA" , 0 , Nil})
			aadd(aCabec,{"F1_FORNECE" , SA2->A2_COD , Nil})
			aadd(aCabec,{"F1_LOJA" , SA2->A2_LOJA, Nil})
			aadd(aCabec,{"F1_ESPECIE" , "SPED" , Nil})
			aadd(aCabec,{"F1_COND" , SA2->A2_COND , Nil})
			aadd(aCabec,{"F1_DESCONT" , 0 , Nil})
			aadd(aCabec,{"F1_SEGURO" , 0 , Nil})
			aadd(aCabec,{"F1_FRETE" , 0 , Nil})
			aadd(aCabec,{"F1_VALMERC" , SF1->F1_VALMERC , Nil})
			aadd(aCabec,{"F1_VALBRUT" , SF1->F1_VALBRUT , Nil}) 
			aadd(aCabec,{"F1_MOEDA" , SF1->F1_MOEDA , Nil}) 

			aItens := {}
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )

			While SD1->(!Eof()) .And. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == ;
			SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
				aLinha := {}
				aadd(aLinha,{"D1_COD" , SD1->D1_ITEM  , Nil})
				aadd(aLinha,{"D1_QUANT" ,SD1->D1_QUANT , Nil})
				aadd(aLinha,{"D1_VUNIT" ,SD1->D1_VUNIT , Nil})
				aadd(aLinha,{"D1_TOTAL" ,SD1->D1_TOTAL, Nil})
				aadd(aLinha,{"D1_TES" , SD1->D1_TES  , Nil})
				aadd(aLinha,{"D1_SEGURO" , 0 , Nil})
				aadd(aLinha,{"D1_VALFRE" , 0 , Nil})
				aadd(aLinha,{"D1_DESPESA" , 0 , Nil})
				aadd(aLinha,{"AUTDELETA" , "N" , Nil}) // Incluir sempre no último elemento do array de cada item

				aadd(aItens,aLinha)

				DbSelectArea("SD1")
				DbSkip()

			End 

			MATA103(aCabec,aItens,5) //,,,,,aColsCC,,,aCodRet) //ExpN1 - Opção desejada: 3-Inclusão; 4-Alteração ; 5-Exclusão
			If !lMsErroAuto
				ConOut("Exclusao efetuada com sucesso! "+cNota)
			Else
				MostraErro()
				ConOut("Erro na exclusao! "+cNota )
			EndIf

		EndIf 

		cPedido := Space(6)

		DbSelectArea("SD2")
		DbSetOrder(3)
		DbSeek(xFilial("SD2")+cDoc )

		While SD2->(!Eof()) .And. cDoc == SD2->D2_DOC

			cPedido := SD2->D2_PEDIDO

			DbSelectArea("SD2")
			DbSkip()

		End

		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+cDoc )

		If MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o documento de saida                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
			SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,.F.))

		EndIf

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
					RecLock("SC9",.F.)
					SC9->C9_BLEST := " "
					MsUnlock()
					DbSkip()

				End

			EndIf 

			//Volto o status do Romaneio 
			DbSelectArea("ZZR")
			DbSetOrder(2)
			If DbSeek(xFilial("ZZR")+SM0->M0_CODIGO+cPedido)
				RecLock("ZZR",.F.)
				ZZR->ZZR_STAFAT := " "
				ZZR->ZZR_NOTA   := " "
				MsUnlock()
			EndIf 

			DbSelectArea("ZZQ")
			DbSetOrder(1)
			If DbSeek(xFilial('ZZQ')+SC5->C5_ROMANEI) 
				RecLock('ZZQ',.F.)
				ZZQ->ZZQ_STATUS := "L"
				MsUnlock()
			EndIf 

			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_STAPED := If(Empty(SC5->C5_ROMANEI),"D","T")
			MsUnlock()

		EndIf	

		STARTJOB("U_ExcNFTrans",getenvserver(),.t.,cEmpTrans,cFilTrans,aItens,cCliTrans,cSerie,cNota, cEmpOri, cFilOri )

	EndIf 

Return 


User Function ExcNFTrans(cEmpTrans,cFilTrans,aItens,cCliTrans,cSerie,cNota, cEmpOri, cFilOri)

	//Preparando o ambiente para exclusao para a nota de origem 
	WfPrepEnv(cEmpTrans,cFilTrans)

	ConOut("Entrando na empresa "+cEmpTrans+"para exclusao da nota! "+cNota)

	lMsErroAuto := .F.

	aRegSd2   := {}
	aRegSe1   := {}
	aRegSe2   := {}

	cPedido := Space(6)

	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+cNota+cSerie )

	While SD2->(!Eof()) .And. cNota+cSerie == SD2->D2_DOC+SD2->D2_SERIE

		cPedido := SD2->D2_PEDIDO

		DbSelectArea("SD2")
		DbSkip()

	End

	ConOut("Pedido : "+cPedido )

	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+cNota+cSerie )

		// Exlui a NF e alimenta a tabela SZE (Notas Fiscais Excluidas)
		cMarca := GetMark(,"SF2","F2_OK")
		RecLock("SF2",.F.)
		SF2->F2_OK := cMarca
		Msunlock()

		ConOut("Entrando na rotina de exclusao da nota "+cNota+cSerie  )

		If MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)

			ConOut("Agora vou mesmo deletar a  nota "+cNota+cSerie  )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o documento de saida                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
			SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,.F.))

		EndIf 

	EndIf 	

	ConOut("Excluindo o Pedido : "+cPedido )

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
		RecLock('SC6',.F.)
		SC6->C6_QTDENT := 0
		SC6->C6_QTDEMP := 0
		MsUnlock()

		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial('SB2')+SC9->C9_PRODUTO+SC9->C9_LOCAL )
		RecLock("SB2",.F.)
		SB2->B2_RESERVA -= SC9->C9_QTDLIB 
		MsUnlock()

		DbSelectArea("SC9")
		RecLock('SC9',.F.)
		SC9->(DbDelete())
		MsUnlock()
		DbSkip()
	End 

	aCabec := {}
	aItens := {}

	If !Empty(cPedido)

		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+cPedido )

		aadd(aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
		aadd(aCabec,{"C5_TIPO","N",Nil})
		aadd(aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
		aadd(aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
		aadd(aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
		aadd(aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial('SC6')+cPedido)

		While SC6->(!Eof()) .And. cPedido == SC6->C6_NUM  

			aLinha := {}
			aadd(aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM })
			aadd(aLinha,{"AUTDELETA","N",Nil})
			aadd(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO,Nil})
			aadd(aLinha,{"C6_QTDVEN",SC6->C6_QTDVEN,Nil})
			aadd(aLinha,{"C6_PRCVEN",SC6->C6_PRCVEN,Nil})
			aadd(aLinha,{"C6_PRUNIT",SC6->C6_PRUNIT,Nil})
			aadd(aLinha,{"C6_VALOR",SC6->C6_VALOR ,Nil})
			aadd(aLinha,{"C6_TES",SC6->C6_TES,Nil})
			aadd(aItens,aLinha)

			DbSelectArea("SC6")
			DbSkip()

		End  

		MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,5)
		If !lMsErroAuto
			ConOut("Exclusao com sucesso! "+cDoc)
		Else
			MostraErro()
			ConOut("Erro na exclusao!")
		EndIf

	EndIf 

	Conout("Retornando a empresa atual ")

	RpcClearEnv()

//	cEmpOri := "02"
//	cFilOri := "01"

	WfPrepEnv(cEmpOri,cFilOri)

	//	MsgInfo("Nota excluida com sucesso.." )

Return 