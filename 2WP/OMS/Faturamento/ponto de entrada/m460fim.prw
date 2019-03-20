#include "RWMAKE.CH"
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Carlos R Moreira    º Data ³  07/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para gerar a transferencia da empresa sobel para  º±±
±±º          ³ JMT                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()
	Local aArea  := GetArea()
	Local aItens := {}

	Private cEmpOri, cFilOri
	Private cNota  

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

	If Empty(cEmpTrans)

		Return

	EndIf 

	cCliTrans := Alltrim(GetMV("MV_CLITRAN"))

	cForTrans := Alltrim(GetMV("MV_FORTRAN"))

	cEmpOri := cEmpAnt
	cFilOri := cFilAnt

	cSerie  := SF2->F2_SERIE

	cPedido := Space(6) 

	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE ) 

	While SD2->(!Eof()) .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE

		Aadd(aItens,{SD2->D2_COD,SD2->D2_QUANT,SD2->D2_PRCVEN })

		cPedido := SD2->D2_PEDIDO 

		DbSelectArea("SD2") 
		DbSkip()

	End 

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cPedido))

	If ! SC5->C5_ZZTIPO $ "N,F"

		Return 

	EndIf

	//Busco o  numero da nota que sera gerada na empresa 01

	BeginSql alias "QRY"

		Select X5_DESCRI  From SX5010 WHERE X5_TABELA = '01' AND D_E_L_E_T_ <> '*' AND X5_CHAVE = '1' AND X5_FILIAL = '01'

	EndSql    

	cNota := Alltrim(QRY->X5_DESCRI) 

	ConOut( "Nota: "+cNota )

	QRY->(DbCloseArea())

	aArqDest := { "SA1","DA1" }

	cEmp := cEmpTrans 

	For nX := 1 to Len(aArqDest)

		//Abro os Arquivos nas respectivas empresas
		cArqVar := aArqDest[nX]+cEmp+"0"

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
	cArqSA1 := "SA1"+cEmp+"0"
	cArqDA1 := "DA1"+cEmp+"0"

	(cArqSA1)->(DbSeek(xFilial("SA1")+cCliTrans ))

	cTabela := (cArqSA1)->A1_TABELA 

	For nX := 1  to Len(aItens)

		DbSelectArea( cArqDA1)
		DbSetOrder(1)
		If DbSeek(xFilial("DA1")+cTabela+aItens[nX,1] )

			aItens[nX,3] := (cArqDA1)->DA1_PRCVEN

		Else

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aItens[nX,1]))

//			If SB1->B1_UPRC > 0 
//				aItens[nX,3] := SB1->B1_UPRC 
//			Else   
				If !IsBlind()   
					MsgStop("Produto "+aItens[nX,1]+" não possui de tabela de preço para venda intercompany")
					(cArqSA1)->(DbCloseArea())
					(cArqDA1)->(DbCloseArea())
				Else
					ConOut("Produto "+aItens[nX,1]+" não possui de tabela de preço para venda intercompany")
					(cArqSA1)->(DbCloseArea())
					(cArqDA1)->(DbCloseArea())

				EndIf

				Return
//			EndIf   
		EndIf     

	Next 

	U_GerIndCom(cNota,aItens,cForTrans,cSerie, cEmpOri, cFilOri)      

	//Gravo a nota de venda interna
	DbSelectARea("SF2")
	RecLock("SF2",.F.)
	SF2->F2_DOC_INT := cNota
	SF2->F2_SER_INT := cSerie 
	MsUnlock()

	(cArqSA1)->(DbCloseArea())
	(cArqDA1)->(DbCloseArea())

	STARTJOB("U_GeraTrans",getenvserver(),.t.,cEmpTrans,cFilTrans,aItens,cCliTrans,cSerie,@cNota, cEmpOri, cFilOri )

	RestArea(aArea)

Return 	

/*/

Funcao que ira gerar o pedido na empresa de transferencia
/*/ 
User Function GeraTrans(cEmpa,cFiliala,aItensI,cCliTrans,cSerie,cNota, cEmpOri, cFilOri)
	Local aCabec := {}
	Local aLinha := {}
	Local nX := 0
	Local nY := 0
	Local cDoc := ""
	Local lOk := .T.

	Private aItensNota := {}
	PRIVATE lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

//	RpcClearEnv()

	//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala modulo 'FAT'
	Conout("Estou processando a Geracao do pedido de venda Empresa: "+cEmpA+" Filial: "+cFilialA )

	WfPrepEnv(cEmpA,cFiliala)

	cNota := ProcPed(aItensI,cCliTrans,@cNota, cEmpOri, cFilOri)

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³PROCPED   º Autor ³ Carlos R Moreira    º Data ³ 08/08/18   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Programa para gerar pedido/nota saida/nota entrada         º±±
//±±º          |                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteracao ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ SIGAFAT - Especifico                                       º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function PROCPED(xCodProd,cCliTrans,cNota, cEmpOri, cFilOri)

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local nX     := 0
	Local nY     := 0
	Local cDoc   := ""
	Local lOk    := .T.

	Private _condpg
	Private _cMunIbge
	Private _cTpclisc
	Private _cArea
	Private _cRedesca
	Public cPedido
	Public lprogauto := .T.

	DbSelectArea("SA1")
	DbSetOrder(1)
	If ! DbSeek(xFilial("SA1")+cCliTrans )

		Conout("Cliente nao cadastrado")

	EndIf

	_CondPG := SA1->A1_COND

	aCabec := {}
	aItens := {}
	aAdd(aCabec,{"C5_FILIAL"	, xFilial("SC5") 	,Nil})
	aadd(aCabec,{"C5_TIPO" ,"N",Nil})
	aadd(aCabec,{"C5_ZZTIPO" ,"N",Nil})
	aadd(aCabec,{"C5_CLIENTE",SA1->A1_COD,Nil})
	aadd(aCabec,{"C5_LOJACLI",SA1->A1_LOJA,Nil})
	aAdd(aCabec,{"C5_CLIENT"	, SA1->A1_COD		,Nil})
	aAdd(aCabec,{"C5_LOJAENT"	, SA1->A1_LOJA		,Nil})
	aAdd(aCabec,{"C5_TIPOCLI"	, SA1->A1_TIPO		,Nil})
	aadd(aCabec,{"C5_TRANSP","000001",Nil})
	aadd(aCabec,{"C5_CONDPAG",SA1->A1_COND,Nil}) //_condpg,Nil})
	aadd(aCabec,{"C5_TPFRETE","F",Nil})
	aadd(aCabec,{"C5_VEND1",SA1->A1_VEND,Nil})
	aadd(aCabec,{"C5_FECENT" ,dDatabase,Nil})
	aadd(aCabec,{"C5_VOLUME1" ,1,Nil})
	aadd(aCabec,{"C5_ESPECI1" ,"CAIXAS",Nil})
	aadd(aCabec,{"C5_ZZPEDCL" ,"....",Nil})
	aadd(aCabec,{"C5_ZZUSER",__cUserID,Nil})  
	aadd(aCabec,{"C5_STAPED","D",Nil})
	//aadd(aCabec,{"C5_MERPALE","N",Nil})
	//aadd(aCabec,{"C5_CNPJ",SA1->A1_CGC,Nil})

	Private lMsErroAuto := .F.
	aItensi := {}
	For Item:= 1 To Len(xCodProd)

		cItem   := StrZero(Item,2)
		cProduto:= xCodProd[Item][1]
		nQtd	:= xCodProd[Item][2]

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+cProduto)

		If Substr(SB1->B1_GRUPO,1,2) $ "20"
			cTesSai := "50A" 
		ElseIf Substr(SB1->B1_GRUPO,1,2) $ "10,11,12"
			cTesSai := "506" 
		ElseIf Substr(SB1->B1_GRUPO,1,2) $ "13,22"
			cTesSai := "50B" 
		ElseIf Substr(SB1->B1_GRUPO,1,2) $ "14,15,16,17,18,19,65"
			cTesSai := "507" 
		Else	  
			cTesSai := "507" 
		EndIf 

		DbSelectArea("DA1")
		DbSetOrder(1)
		DbSeek(xFilial("DA1")+SA1->A1_TABELA+cProduto )

		nPrc := DA1->DA1_PRCVEN //B1_PRCOML xCodProd[Item][3] //

		nTot:=nqtd*nPrc

		aLinha := {}
		aadd(aLinha,{"C6_ITEM",cItem,Nil})
		aadd(aLinha,{"C6_PRODUTO",cProduto,Nil})
		aadd(aLinha,{"C6_QTDVEN",nQtd,Nil})
		aadd(aLinha,{"C6_PRCVEN",nPrc,Nil})
		aadd(aLinha,{"C6_PRUNIT",nPrc,Nil})
		aadd(aLinha,{"C6_VALOR",nTot,Nil})
		aadd(aLinha,{"C6_TES",cTesSai,Nil})

		aadd(aItensi,aLinha)

	Next Item

	MATA410(aCabec,aItensi,3)

	cPedido := SC5->C5_NUM

	If !lMsErroAuto
		ConOut("Incluido com sucesso! "+cPedido)
	Else
		ConOut("Erro na inclusao!")
		MOSTRAERRO()
		//	Alert("Pedido não foi gerado")
		Return
	EndIf

	cNota:= LIBPED(cpedido,aItensi,_condpg, cEmpOri, cFilOri)

	Conout("Gerada a nota: "+cNota )

Return cNota

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA13   ºAutor  ³Carlos R. Moreira   º Data ³  07/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a liberacao do pedido de venda                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LIBPED(cPedido,aItensi,_condpg, cEmpOri, cFilOri)

	wAreaAnt	 := GetArea()
	wAreaSC5	 := SC5->(GetArea())
	wAreaSC6	 := SC6->(GetArea())
	wAreaSC9	 := SC9->(GetArea())
	wAreaSB1	 := SB1->(GetArea())
	wAreaSB2	 := SB2->(GetArea())
	wAreaSF4	 := SF4->(GetArea())
	wAreaSA1	 := SA1->(GetArea())

	Conout("Função de Liberação de Pedido")

	DbSelectarea("SC5")
	DbSetOrder(1)
	If DBSeek(xFilial("SC5")+cPedido)

		nTipo := space(1)
		nStatus:= space(2)
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"
		MsUnlock()

		DbSelectarea("SC6")
		DbSetorder(1)
		DbSeek(xFilial("SC6")+cPedido)
		While !Eof() .AND. C6_FILIAL+C6_NUM == xFilial("SC6")+cPedido

			DbSelectArea("SF4")
			DbSeek(xFilial("SF4")+SC6->C6_TES)

			SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA ))

			dbSelectArea("SC6")

			RecLock("SC6",.F.)

			SC6->C6_QTDLIB := SC6->C6_QTDVEN
			SC6->C6_OP     := "02"
			SC6->C6_TPOP   := "F"
			SC6->C6_CF     := IF(SA1->A1_EST == "SP",SF4->F4_CF,"6"+Substr(SF4->F4_CF,2,3))
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
			RecLock("SC9",.F.)
			SC9->C9_BLEST  := " " 
			SC9->C9_BLCRED := " "		
			MsUnLock()
			ConOut("MALIBDOFAT Executada")

			dbSelectArea("SC6")
			DBSkip()

		Enddo

		//Verifico se houve duplicidade
		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido


			If SC9->C9_SEQUEN == "02"

				//Estorno a qtd que gera reserva..
				DbSelectArea("SB2")
				If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
					RecLock("SB2",.F.)
					SB2->B2_RESERVA -= SC9->C9_QTDLIB
					MsUnlock()
				Endif

				ConOut("Gerando a liberacao pelo M460FIM")
				DbSelectArea("SC9")
				Reclock("SC9",.F.)
				SC9->(DbDelete())
				MsUnlock()
			EndIf


			SC9->(DbSkip())

		End

	Endif

	// Retorna as areas originais
	RestArea(wAreaSF4)
	RestArea(wAreaSB2)
	RestArea(wAreaSB1)
	RestArea(wAreaSC9)
	RestArea(wAreaSC6)
	RestArea(wAreaSC5)
	RestArea(wAreaAnt)

	MsUnlockAll()

	ConOut("Fim da Liberação de Pedido")
	ConOut("Início Nota Fiscal")

	cNota := NotaSaida(3,cPedido,aItensi,_condpg)

Return(cNota)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROCPED   ºAutor  ³Microsiga           º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NotaSaida(nOpc,cNumPed,aItens,_condpg, cEmpOri, cFilOri)
	Local aPvlNfs := {}
	ConOut("Comeca Nota")

	nopc:=if(nopc==Nil,3,nopc)

	// Posicionar as Tabelas Necessarias

	If nOpc ==3

		For i:=1 to len(aItens)

			SC9->(DbSetOrder(1))
			SC9->(DbSeek(xFilial("SC9")+cNumPed+aItens[i][1][2]) )                    //FILIAL+NUMERO+ITEM
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(xFilial("SC6")+cNumPed+aItens[i][1][2]) )                    //FILIAL+NUMERO+ITEM
			SE4->(DbSetOrder(1))
			SE4->(DbSeek(xFilial("SE4")+"001") )                           //FILIAL+NUMERO+ITEM+PRODUTO
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aItens[i][2][2]) )               //FILIAL+PRODUTO
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+aItens[i][2][2]+"01") )          //FILIAL+PRODUTO+LOCAL
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+aItens[i][7][2]) )                            //FILIAL+CODIGO

			aAdd(aPvlNfs,{cNumPed,;
			aItens[i][1][2],;
			aItens[i][1][2],;
			aItens[i][3][2],;
			aItens[i][4][2],;
			aItens[i][2][2],;
			.f.,;
			SC9->(RecNo()),;
			SC5->(RecNo()),;
			SC6->(RecNo()),;
			SE4->(RecNo()),;
			SB1->(RecNo()),;
			SB2->(RecNo()),;
			SF4->(RecNo())})

		Next i

		cSerie := AllTrim(Posicione("SX5",1,xFilial("SX5")+"01","X5_CHAVE"))

		Pergunte("MT460A",.F.)

		cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .F., .F., 0, 0, .F., .F.)

		aPvlNfs:={}

		ConOut("Termina Nota")

		//    cSerie := "3  "
		cEmpAuto := SM0->M0_CODIGO
		cFilAuto := SM0->M0_FILIAL 
		cWait    := "30"
		cOpc     := "1"
		cNotaIni := cNota
		cNotaFim := cNota
		
		ConOut("Transmitindo a nota: "+cNota)

        AutoNfeEnv(cEmpAuto,cFilAuto,cWait,cOpc,cSerie,cNotaIni,cNotaFim)

		aItens := {} 

		DbSelectArea("SD2")
		DbSetOrder(3)
		DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE ) 

		While SD2->(!Eof()) .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE

			Aadd(aItens,{SD2->D2_COD,SD2->D2_QUANT,SD2->D2_PRCVEN })

			DbSelectArea("SD2") 
			DbSkip()

		End 

		cForTrans := Alltrim(GetMV("MV_FORTRAN"))

	EndIf

Return(cNota)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³GerIndCom º Autor ³ Carlos R Moreira    º Data ³ 07/08/18   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Programa para gerar nota entrada da Sobel para JMT         º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteracao ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ SIGAFAT - Especifico Sobel                                 º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

//User Function GerIndCom(cEmpOri,cfilOri,cNota,aItensi,cForTrans,cSerie)
User Function GerIndCom(cNota,aItensi,cForTrans,cSerie, cEmpOri, cFilOri)
	Local aCabec := {}
	Local aLinha := {}
	Local nX := 0
	Local nY := 0
	Local cDoc := ""
	Local lOk := .T.

	Private aItensNota := {}
	PRIVATE lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	DbSelectArea("SF1")
	DbSetOrder(1)
	If DbSeek(xFilial("SF1")+cNota+cSerie+cForTrans )
		Conout("Nota ja existente na base")
		Return 
	EndIf 

	//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala 
	Conout("Estou processando a Nota Fiscal de Entrada ")

	WfPrepEnv(cEmpOri,cFilOri)

	cForTrans := Alltrim(GetMV("MV_FORTRAN"))

	cDoc := cNota

	aCabec := {}
	If Empty(cDoc)
		Conout("Documento em branco")
		Return
	EndIf

	Conout("Empresa Atual Documento : "+cNota )

	DbSelectArea("SA2")
	DbSetOrder(1)
	If ! DbSeek(xFilial("SA2")+cForTrans )

		Conout("Fornecedor nao cadastrado "+cForTrans )

		Return 

	EndIf 

	aadd(aCabec,{"F1_TIPO" ,"N",NIL})
	aadd(aCabec,{"F1_FORMUL" ,"N",NIL})
	aadd(aCabec,{"F1_DOC" ,cDoc,NIL})
	aadd(aCabec,{"F1_SERIE" ,cSerie,NIL})
	//aadd(aCabec,{"F1_SERIE" ,"UNI"})
	aadd(aCabec,{"F1_EMISSAO",Date(),NIL})
	aadd(aCabec,{"F1_DESPESA",0,NIL}) 
	aadd(aCabec,{"F1_FORNECE",SA2->A2_COD,NIL })
	aadd(aCabec,{"F1_LOJA" ,SA2->A2_LOJA,NIL })
	aadd(aCabec,{"F1_ESPECIE","SPED",NIL})

	aadd(aCabec,{"F1_COND",SA2->A2_COND,NIL}) 
	aadd(aCabec,{"F1_DESCONT",0,NIL})
	aadd(aCabec,{"F1_SEGURO",0,NIL})
	aadd(aCabec,{"F1_FRETE",0,NIL})
	//aadd(aCabec,{"F1_VALMERC",312,NIL})
	//aadd(aCabec,{"F1_VALBRUT",312,NIL})

	DbSelectArea("SB1")
	DbSetOrder(1)

	For nX := 1 To Len(aItensi)

		DbSeek(xFilial("SB1")+aItensi[nx][1])

		If Substr(SB1->B1_GRUPO,1,2) $ "13,22"
			cTesEnt := "026" //If(Empty(SB1->B1_TE),"001",SB1->B1_TE )
		ElseIf Substr(SB1->B1_GRUPO,1,2) $ "20"  
			cTesEnt := "028" //If(Empty(SB1->B1_TE),"001",SB1->B1_TE )
		ElseIf Substr(SB1->B1_GRUPO,1,2) $ "10,11,12"  
			cTesEnt := "027" //If(Empty(SB1->B1_TE),"001",SB1->B1_TE )
		Else  
			cTesEnt := "025" //If(Empty(SB1->B1_TE),"001",SB1->B1_TE )
		EndIf 

		aLinha := {}
		//	aadd(aLinha,{"D1_ITEM" ,STRZERO(nx,2),Nil})
		aadd(aLinha,{"D1_COD" ,aItensi[nx][1],Nil})
		aadd(aLinha,{"D1_QUANT",aItensi[nx][2],Nil})
		aadd(aLinha,{"D1_VUNIT",aItensi[nx][3],Nil})
		aadd(aLinha,{"D1_TOTAL",(aItensi[nx][2])*(aItensi[nx][3]),Nil})
		aadd(aLinha,{"D1_TES",cTesEnt,Nil})
		aadd(aLinha,{"D1_SEGURO",0,NIL})
		aadd(aLinha,{"D1_VALFRE",0,NIL})
		aadd(aLinha,{"D1_DESPESA",0,NIL})
		aadd(aLinha,{"AUTDELETA" ,"N",Nil}) // Incluir sempre no último elemento do array de cada item

		aadd(aItensNota,aLinha)

	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Conout("Entrando na Empresa Atual - Mata103 "+SM0->M0_CODIGO )

	MATA103(aCabec,aItensNota,3)

	Conout("Saindo na Empresa Atual - Mata103 "+SM0->M0_CODIGO )

	If !lMsErroAuto
		Conout("Incluido Nota de entrada com sucesso! "+cDoc)
	Else            
		MOSTRAERRO()
		ConOut("Erro na inclusao da nota de entrada!")
	EndIf

Return (cDoc)
