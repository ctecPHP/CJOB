#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA10   ºAutor  ³Carlos R. Moreira   º Data ³  05/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra os romaneio que estao em aberto para faturamento    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PFATA10()

	aIndexZZQ  := {}

	PRIVATE bFiltraBrw := {|| Nil}

	Private cCadastro := OemToAnsi("Faturamento por romaneio")

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Consultar","U_PFATA10C" , 0 , 1},;
	{"Faturar","u_PFATA10F", 0 , 2 , 0 , NIL},;	//
	{"Legenda","U_PFATA10Legenda", 0 , 0 , 0 , .F.}}		//

	aRegs := {}
	cPerg := "PFATA10"

	aAdd(aRegs,{cPerg,"01","Filtrar somentes      ?","","","mv_ch1","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR01","Liberados"  ,"","","","","Ocorrencia","","","","","Bloqueados","","","","","Faturados","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T.)

	//Ira checar se o usuario tem permissao para digitacao do Inventario
	Private cCodUsu := __cuserid

	aCores := { { " ZZQ_STATUS = 'L' "  , 'ENABLE' },;
	{ " ZZQ_STATUS = 'F'  " , 'DISABLE'  },;
	{ " ZZQ_STATUS = ' '" , 'BR_AZUL_CLARO'  },;
	{ " ZZQ_STATUS = 'O'" , 'BR_CINZA'  }}

	If MV_PAR01 == 1 
		cFiltraZZQ := "ZZQ_STATUS = 'L' " 
	ElseIf  MV_PAR01 == 2 
		cFiltraZZQ := "ZZQ_STATUS = 'O' "
	ElseIf MV_PAR01 == 3 
		cFiltraZZQ := "ZZQ_STATUS = ' ' "
	ElseIf MV_PAR01 == 4 
		cFiltraZZQ := "ZZQ_STATUS = 'F' "
	EndIf 

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA10F  ºAutor  ³Carlos R Moreira    º Data ³  10/29/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o faturamento do romaneio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA10F()

    Private lFatRom := .F. 
    
    If ! MsgYesNo("Confirma o faturamento do Romaneio "+ZZQ->ZZQ_ROMANE )
       Return 
    EndIf 
    
	If ZZQ->ZZQ_STATUS # "L"

		If Empty(ZZQ->ZZQ_STATUS) 
			MsgStop("Romaneio não liberado para faturamento")
			Return 
		ElseIf ZZQ->ZZQ_STATUS == "F"   
			MsgStop("Romaneio já faturado")
			Return 
		Else
			MsgStop("Romaneio possui ocorrencia")
			Return 
		EndIf 

	EndIf

	Processa({||ProcRom(), "Faturando o Romaneio: "+ZZQ->ZZQ_ROMANE })

	If lFatRom 
		DbSelectArea("ZZQ")
		RecLock("ZZQ",.F.)
		ZZQ->ZZQ_STATUS := "F"
		MsUnlock()    
	EndIf 

	MsgInfo("Faturamento efetuado com sucesso..")


Return 


Static Function ProcRom()

	cEmpOri := cEmpAnt
	cFilOri := cEmpAnt 

	lFatRom := .F. //Verifica se o faturamento irá ser concluido com sucesso

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		//	    IncProc("Gerando o faturamento.."+cEmp )

		cEmp     := ZZR->ZZR_EMP
		aPedidos := {}  

		While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE  .And. cEmp == ZZR->ZZR_EMP


			Aadd(aPedidos,ZZR->ZZR_PEDIDO )

			DbSelectArea("ZZR")
			DbSkip()

		End

		If cEmp == SM0->M0_CODIGO 

			U_FatRom(aPedidos,.F.,cEmpAnt,cFilAnt)    

		Else

			U_FatRom(aPedidos,.T.,cEmp,cFilAnt)

			//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala modulo 'FAT'
			Conout("Voltando a empresa de origem " )

			WfPrepEnv(cEmpOri,cFilOri )

		EndIf 

	End 


	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		If ZZR->ZZR_STAFAT # "F"
			lFatRom := .F. 
		EndIf 

		lFatRom := .T. 

		DbSkip() 
	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROCPED   ºAutor  ³Microsiga           º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ira processar o vetor de pedidos                                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FatRom(aPedidos,lAuto,cEmpFat,cFilFat)

	If lAuto 

		//PREPARE ENVIRONMENT EMPRESA _cEmpa Filial _cFiliala modulo 'FAT'
		Conout("Estou processando a Geracao do pedido de venda Empresa: "+cEmpFat+" Filial: "+cFilFat )

		WfPrepEnv(cEmpFat,cFilFat)


	EndIf 

	For nPed := 1 to Len(aPedidos)

		//		IncProc( "Faturamento pedido : "+aPedidos[nPed] )

		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek( xFilial("SC5")+aPedidos[nPed] )

		If SC5->C5_STAPED #  "F" 

			nReg := SC5->(Recno())
			nOpc := 2

			cPedido := aPedidos[nPed]

			cNota := NotaSaida(3,cPedido)

			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek( xFilial("SC5")+aPedidos[nPed] )

			DbSelectArea("ZZR")
			DbSetOrder(2)
			If DbSeek(xFilial("ZZR")+cEmpFat+cPedido )

				RecLock("ZZR",.F.)
				ZZR->ZZR_STAFAT  := If(SC5->C5_STAPED == "F","F","O" )
				ZZR->ZZR_NOTA    := cNota
				ZZR->ZZR_EMISNF  := dDataBase
				MsUnlock()

			EndIf 

		EndIf

	Next

Return  

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

Static Function NotaSaida(nOpc,cNumPed,aItens)
	Local aPvlNfs := {}
	ConOut( "Comeca Nota" )

	nOpc:=If(nOpc==Nil,3,nOpc)

	// Posicionar as Tabelas Necessarias
	If nOpc ==3

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+cPedido )

		While SC6->(!Eof()) .And. SC6->C6_NUM == cPedido

			SC9->(DbSetOrder(1))
			If ! SC9->(DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM  ))                    //FILIAL+NUMERO+ITEM
				DbSelectArea("SC6")
				DbSkip()
				Loop
			EndIf 

			If SC9->C9_SEQUEN == "02"
				DbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->(DbDelete())
				MsUnLock()
				DbSelectArea("SC6")
				DbSkip()
				Loop
			EndIf    

			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+cPedido) )                                    //FILIAL+NUMERO

			SE4->(DbSetOrder(1))
			SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO ) )               //FILIAL+PRODUTO

			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL ) )          //FILIAL+PRODUTO+LOCAL

			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ) )                            //FILIAL+CODIGO

			aAdd(aPvlNfs,{cPedido,;
			SC9->C9_ITEM,;
			SC9->C9_SEQUEN,;
			SC9->C9_QTDLIB,;
			SC9->C9_PRCVEN,;
			SC9->C9_PRODUTO,;
			.f.,;
			SC9->(RecNo()),;
			SC5->(RecNo()),;
			SC6->(RecNo()),;
			SE4->(RecNo()),;
			SB1->(RecNo()),;
			SB2->(RecNo()),;
			SF4->(RecNo())})

			DbSelectArea("SC6")
			DbSkip()

		End

		Pergunte("MT460A",.F.)

		MV_PAR16 := 1 //Somente para confirmar que esta sendo gerado o cupom fiscal
		cSerie   := "1  "
		lECF := .F.

		cNota := MaPvlNfs(aPvlNfs,cSerie,    .F.,      .F.,      .F.,        .F.,      .F.,     0,       0,          .F., lECF)

		aPvlNfs:={}

		ConOut("Termina Nota")

		//		If !SM0->M0_CODIGO $ "05#06"

		//Ira transmitir a nota fiscal para o Sped
		//			cSerie := "2  "
		//			cNotaIni := cNota
		//			cNotaFim := cNota

		//		EndIf

	EndIf

Return(cNota)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PFATA10Leg ³ Autor ³ Carlor R Moreira     ³ Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela contendo a legenda da mBrowse.              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFATA10Legenda()

	BrwLegenda("Posicão do Romaneio","Legenda",{	{"ENABLE",OemToAnsi("Liberado Faturamento")},;
	{"BR_AMARELO",OemToAnsi("Bloqueado")},;	
	{"BR_AZUL_CLARO",OemToAnsi("Aguardando Liberação")},;
	{"BR_CINZA",OemToAnsi("Com Ocorrencia")},;
	{"DISABLE",OemToAnsi("Faturado /Encerrado")}} ) //,;
	//	{"BR_AZUL",OemToAnsi("Devolucao")}} )
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PFATA10C   ³ Autor ³ Carlor R Moreira     ³ Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela com a consulta do Romaneio                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFATA10C()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Local aCampos := {}

	AADD(aCampos,{ "OK"       ,"C",02,0 } )
	AADD(aCampos,{ "EMP"      ,"C",02,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",20,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C", 6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C", 2,0 } )
	AADD(aCampos,{ "NOME"     ,"C",40,0 } )	
	AADD(aCampos,{ "NF"       ,"C", 6,0 } )
	AADD(aCampos,{ "SERIE"    ,"C", 3,0 } )
	AADD(aCampos,{ "STATUS"   ,"C", 1,0 } )	

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"EMP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		DbSelectArea('TRB')
		RecLock("TRB",.T.)
		TRB->EMP     := ZZR->ZZR_EMP   
		TRB->NOMEMP  := ""
		TRB->PEDIDO  := ZZR->ZZR_PEDIDO 
		TRB->CLIENTE := ZZR->ZZR_CLIENTE
		TRB->LOJA    := ZZR->ZZR_LOJA
		TRB->NOME    := ZZR->ZZR_NOME	
		TRB->NF      := ZZR->ZZR_NOTA
		TRB->SERIE   := ZZR->ZZR_SERIE
        TRB->STATUS  := ZZR->ZZR_STAFAT
		MsUnlock()
		DbSelectArea("ZZR")
		DbSkip()
	End  
	Private oTransp,oDescTra,oRomaneio
	cTransp   := ZZQ->ZZQ_TRANSP
	cDescTra  := ZZQ->ZZQ_DESTRA
	cRomaneio := ZZQ->ZZQ_ROMANE

	DbSelectArea("TRB")
	DbGoTop()

	cMarca  := GetMark()

	aBrowse := {}

	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"NF","","N.Fiscal"})
	AaDD(aBrowse,{"SERIE","","Serie"})

	AADD(aObjects,{ 10,05,.T.,.T.})

	aCores := {}

	//	Aadd(aCores, { 'OPER = "08"', "BR_PRETO" } )
	Aadd(aCores, { 'STATUS = "F" ', "DISABLE" } )
	Aadd(aCores, { 'STATUS = " " ', "ENABLE" } )
	Aadd(aCores, { 'STATUS = "O" ', "BR_CINZA" } )
	//	Aadd(aCores, { '!Empty(OBSINT) .Or. !Empty(OBSEXT)', "BR_VIOLETA" } )	

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Romaneio " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 30, 20 Say OemToAnsi("Romaneio: ") Size 70,8  OF odlg1 PIXEL
	@ 28, 63  MsGet oRomaneio  Var cRomaneio   Size 45,10   When .F. OF odlg1 PIXEL 

	@ 30, 120 Say OemToAnsi("Transportadora : ") Size 70,8  OF odlg1 PIXEL
	@ 28, 163  MsGet oTransp  Var cTransp  Valid ChkTransp() F3 "SA4" Size 45,10   When .F. OF odlg1 PIXEL 

	@ 30, 210 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
	@ 28, 253  MsGet oDescTra   Var cDescTra   Size 145,10   When .F. OF odlg1 PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "TRB".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB"," ","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+20 ,aPosObj[1,2]+1 ,aPosObj[1,3]-10,aPosObj[1,4]-1},,,,,aCores)
	/*		oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } */

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

Return

/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq,nTipo)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return
