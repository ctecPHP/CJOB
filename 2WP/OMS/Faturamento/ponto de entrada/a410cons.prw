#include "protheus.ch"
#include "MSGRAPHI.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  ºAutor  ³Carlos R. Moreira   º Data ³  04/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona o Botao para consultar a Quantidade                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Scarlat                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A410CONS()
	Local aButtons := {}

//	Aadd(aButtons,{"UP_MDI",{|| U_SOMAQTD()},"Totaliza a quantidade","Quantidade"})

	Aadd(aButtons,{"SIMULACAO",{|| U_SimulaVen()},"Simulacao de venda","Simulação Margem"})

//	Aadd(aButtons,{"EDIT",{|| U_MostraPeso()},"Totaliza o peso","Peso"})

//	Aadd(aButtons,{"EDIT",{|| U_MosRomaneio()},"Mostra o Romaneio ","Romaneio"})

Return aButtons


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  04/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SomaQtd()
	Local nQtde := 0
	Local nQtd := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_QTDVEN"})
	For nX := 1 to Len(aCols)
		nQtde += aCols[nX,nQtd]
	Next

	MsgAlert("Total de Produtos. "+Transform(nQtde,"@E 999,999,999.9999") )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  ºAutor  ³Microsiga           º Data ³  06/29/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SimulaVen()
	Local aArea := GetArea()
	Local oDlg
	Local aCampos := {}
	Local aTitles    := {"Variaveis de Venda","Impostos","Resumo","Margem"}
	Local nColVlr    := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_VALOR"} )
	Local nColProd   := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_PRODUTO"} )
	Local nColTes    := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_TES"} )
	Local nColLoc    := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_LOCAL"} )
	Local nColQtd    := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_QTDVEN"})
	Local nColPrUnit := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_PRBASE"})
	Local nColPrcVen := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_PRCVEN"})
	Local nColDesc   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_VALDESC"})
	Local nColPDesc  := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_DESCPER"})
	Local nColPDif   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_DESCDIF"})
	Local nColItem   := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_ITEM"} )

	Private nVlrCont := 0
	Private nVerbas := 0
	Private nDesconto := 0
	Private nBonificacao := 0
	Private nComissao := 0
	Private nFrete   := nVlrTot := 0
	Private nVlrIpi  := nVlrIcms := nVlrPis := nVlrCof := 0
	Private nPerCont := nPerVerba := nPerbon := 0
	Private nTotPed  := nTotVarVen := nTotImp := nTotCus := nTotLiq := nTotCus := nTotQtd := 0

//	nPerFreSim := GetMV("MV_FRESIM")

	If M->C5_ZZTIPO # "N"
		MsgInfo("Este pedido não se trata de Venda. Não deve usar o simulador ")
		Return
	EndIf

/*
	lVend := U_RET_VENCLI(3)
	If !lVend
		aTitles   := {"Variaveis de Venda","Impostos","Resumo"}
 	EndIf */

	//Cria o Arquivo de Trabalho
	AADD(aCampos,{ "PROD"   ,"C",15,0 } )
	AADD(aCampos,{ "ITEM"   ,"C", 2,0 } )
	AADD(aCampos,{ "QTDE"   ,"N",11,4 } )
	AADD(aCampos,{ "TOTAL"  ,"N",11,2 } )
	AADD(aCampos,{ "VLRVAR" ,"N",11,2 } )
	AADD(aCampos,{ "VLRIMP" ,"N",11,2 } )
	AADD(aCampos,{ "VLRPCL" ,"N",11,2 } )
	AADD(aCampos,{ "PCL_CX" ,"N",11,2 } )
	AADD(aCampos,{ "DESC"   ,"C",30,0 } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"DET", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("DET",cNomArq,"PROD+ITEM",,,OemToAnsi("Selecionando Registros..."))	//

	nPerIcms := AliqIcms("N","S",M->C5_TIPOCLI)
	nPerPis  := GetMv("MV_TXPIS")
	nPerCof  := GetMv("MV_TXCOF")

	nPerContrato := SA1->A1_ZZCONTR  //Posicione("SZ1",1,xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI,"Z1_PERC")

//	nPerContrato += Posicione("SZ1",1,xFilial("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI,"Z1_PERPROV")

	nVlrFrete := 0

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ))

	cMargens := " "

/*	SX5->(DbSetOrder(1))
	If SX5->(DbSeek(xFilial("SX5")+"Z5"+SA1->A1_CANAL ))
		cMargens := Alltrim(SX5->X5_DESCRI)
	EndIf */

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

	// Calcula a Comissao
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1 ))

	For nX := 1 to Len(aCols)

		If !aCols[nX,Len(aHeader)+1] .And. !Empty(aCols[nX,nColProd])

			SB1->(DbSetorder(1))
			SB1->(DbSeek(xFilial("SB1")+aCols[nX,nColProd]))

			cAno := StrZero(Year(M->C5_EMISSAO),4)

			nMes := Month(M->C5_EMISSAO) - 1 

			If nMes == 0
				cMes := "12"
				cAno := StrZero(Year(M->C5_EMISSAO)-1,4)
			Else
				cMes := StrZero(nMes,2)
			EndIf

			dDtCus := LastDay(Ctod("01/"+cMes+"/"+cAno))

			SB9->(DbSetorder(1))
			If SB9->(DbSeek(xFilial("SB9")+aCols[nX,nColProd]+aCols[nX,nColLoc]+Dtos(dDtCus) ) )

				nTotCus += aCols[nX,nColQtd] * SB9->B9_CM1

			EndIf 

			SF4->(DbSetorder(1))
			SF4->(DbSeek(xFilial("SF4")+aCols[nX,nColTes]))

			nTotQtd   += aCols[nX,nColQtd]

			nVlrtot   += aCols[nX,nColVlr]
			nVlrIpi   += aCols[nX,nColVlr] * (SB1->B1_IPI / 100 )
			nVlrIcms  += aCols[nX,nColVlr] * (nPerIcms / 100 )

			nVlrCont  += aCols[nX,nColVlr] * (nPerContrato / 100 )
			nItemCont := aCols[nX,nColVlr] * (nPerContrato / 100 )

			nVlrPis   += aCols[nX,nColVlr] * (nPerPis / 100 )

			nVlrcof   += aCols[nX,nColVlr] * (nPercof  / 100 )

			nImpItem  := ( aCols[nX,nColVlr] * (SB1->B1_IPI / 100 )) + ( aCols[nX,nColVlr] * (nPerIcms / 100 ) ) + ;
			( aCols[nX,nColVlr] * (nPerPis / 100 ) ) + ( aCols[nX,nColVlr] * (nPercof  / 100 ))

//			SZ4->(DbSetOrder(1))
//			SZ4->(DbSeek(xFilial("SZ4")+M->C5_VEND1+aCols[nX,nColProd] ))

			nPercCom := 0
/*			If SA1->A1_CANAL == "V"
				nPercCom := SA3->A3_COMIS_V  
			ElseIf SA1->A1_CANAL == "A"
				nPercCom := SA3->A3_COMIS_A	  
			ElseIf SA1->A1_CANAL == "D"
				nPercCom := SA3->A3_COMIS_D	  
			EndIf */  

			nComissao += aCols[nX,nColVlr] * (nPercCom / 100 )
			nVarItem  := aCols[nX,nColVlr] * (nPercCom / 100 )

//			If ( aCols[nX,nColPrUnit] - (aCols[nX,nColPrcVen] ) ) > 0
//				nDesconto += ( aCols[nX,nColPrUnit] - (aCols[nX,nColPrcVen] ) ) * aCols[nX,nColQtd]
//				nDesItem  := ( aCols[nX,nColPrUnit] - (aCols[nX,nColPrcVen] ) ) * aCols[nX,nColQtd]
//			Else
				nDesItem := 0
//			EndIf

			If M->C5_TPFRETE == "C"
				If INCLUI
					nFrete    += ( nVlrfrete / 1000 ) * ( SB1->B1_PESBRU * aCols[nX,nColQtd] )
					nFreItem  := ( nVlrfrete / 1000 ) * ( SB1->B1_PESBRU * aCols[nX,nColQtd] )
				Else
					nFreItem := 0
/*					SC9->(DbSetOrder(1))
					If SC9->(DbSeek(xFilial("SC9")+M->C5_NUM+aCols[nX,nColItem] ))
						nFrete   += SC9->C9_PRCFRET
						nFreItem := SC9->C9_PRCFRET
					EndIf */

					If nFreItem == 0

						nFrete    += ( nVlrfrete / 1000 ) * ( SB1->B1_PESBRU * aCols[nX,nColQtd] )
						nFreItem  := ( nVlrfrete / 1000 ) * ( SB1->B1_PESBRU * aCols[nX,nColQtd] )

					EndIf

				EndIf
			Else
				nFreItem  := 0
			EndIf

			nVarItem  += nDesItem + nItemCont + nFreItem

//			If aCols[nX,nColPDesc] < 0
				nTotPed    +=  aCols[nX,nColVlr] 
//			Else
//				nTotPed   += aCols[nX,nColVlr]  //nColVlr]			
//				nTotPed   += If(aCols[nX,nColPrUnit]>0,aCols[nX,nColPrUnit] * aCols[nX,nColQtd],aCols[nX,nColVlr])  //nColVlr]
//			EndIf

			DbSelectArea("DET")
			 Reclock("DET",.T.)
			DET->PROD  := aCols[nX,nColProd]
			DET->ITEM  := StrZero(nX,2)
			DET->QTDE  := aCols[nX,nColQtd]
//			DET->TOTAL := If(aCols[nX,nColPrUnit]>0,aCols[nX,nColPrUnit] * aCols[nX,nColQtd],aCols[nX,nColVlr])
            DET->TOTAL := aCols[nX,nColVlr]
			DET->VLRVAR := nVarItem
			DET->VLRIMP := nImpItem
			DET->VLRPCL := DET->TOTAL - ( DET->VLRVAR + DET->VLRIMP )
			DET->PCL_CX := DET->VLRPCL / DET->QTDE
			MsUnlock()

		EndIf

	Next

	If M->C5_TPFRETE == "C"
		lFrete := .F.
	Else
		lFrete := .F.
	EndIf

	nPerBon := 3
	
	/*
	If !Empty(M->C5_PEDBON)



	nBonificacao := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+M->C5_PEDBON )

	While SC6->(!Eof()) .And. M->C5_PEDBON == SC6->C6_NUM

	nBonificacao += SC6->C6_VALOR

	DbSkip()

	End

	EndIf   */

	If M->C5_TPFRETE == "C" .And. nFrete == 0
	    nPerFreSim := 1
	    
		nFrete := nTotPed * ( nPerFreSim / 100 ) //0.10  // Coloco 15% de frete
	EndIf

	nTotImp := nVlrIpi + nVlrIcms + nVlrPis + nVlrCof

	nVlrVar   := nDesconto  //( nVlrCont + nVerbas  + nBonificacao + 

	nVlrVar2  := nFrete + nComissao

	nVlrLiq   := nTotPed - ( nVlrVar +  nTotImp ) //

	nPrcLiqCX := nVlrLiq / nTotQtd

	nMargem   := nVlrLiq - nTotCus

	nPerCont    := ( nVlrCont / nTotPed ) * 100
	nPerVlrVar  := ( nVlrVar  / nTotPed ) * 100
	nPerTotImp  := ( nTotImp  / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq  / nTotPed ) * 100

	aBrowse := {}

	AaDD(aBrowse,{"ITEM",,"Item",""})
	AaDD(aBrowse,{"PROD",,"Produto",""})
	AaDD(aBrowse,{"QTDE",,"Qtde","@e 999,999.9999"})
	AaDD(aBrowse,{"TOTAL",,"Valor","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRVAR",,"Variaveis","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRIMP",,"Impostos","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRPCL",,"Vlr PCL","@e 999,999,999.99"})
	AaDD(aBrowse,{"PCL_CX",,"Pcl / Cx","@e 9,999,999.99"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a tela de exibicao dos valores fiscais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Simulacao de Venda") FROM 09,00 TO 33,80 //"Planilha Financeira"
	oFolder := TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,175)

	@ 015,005 SAY "Contratos"		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 015,205 SAY "% Contratos"		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 030,005 SAY "Verbas"		    SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 030,205 SAY "%Verbas"		    SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 045,005 SAY "Descontos " 	    SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 060,005 SAY "Bonificacao "	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 060,205 SAY "% Bonificacao "	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 075,005 SAY "Comissao"  	    SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 090,005 SAY  "Frete "		    SIZE 40,10 PIXEL OF oFolder:aDialogs[1]

	@ 015,050 MSGET nVlrCont 	 PICTURE "@E 999,999,999.99"	Valid ChkCont(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 015,250 MSGET nPerCont 	 PICTURE "@E 999.99"	        Valid ChkPerCont(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 030,050 MSGET nVerbas    	 PICTURE "@E 999,999,999.99"	Valid ChkVerbas(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 030,250 MSGET nPerVerba    PICTURE "@E 999.99"	        Valid ChkPerVer(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 045,050 MSGET nDesconto  	 PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 060,050 MSGET nBonificacao PICTURE "@E 999,999,999.99" 	Valid ChkBonif(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 060,250 MSGET nPerBon      PICTURE "@E 999.99"		Valid ChkPerBon(oDlg ) SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 075,050 MSGET nComissao    PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 090,050 MSGET nFrete     	 PICTURE "@E 999,999,999.99"		Valid ChkFrete(oDlg ) SIZE 50,07 PIXEL WHEN lFrete OF oFolder:aDialogs[1]

	@ 003,001 TO 125,310 PIXEL OF oFolder:aDialogs[1] label "Variaveis"

	@ 110,005 SAY "Total  "     SIZE 40,10 PIXEL OF oFolder:aDialogs[1] //"Total da Nota"
	@ 110,050 MSGET nVlrVar     PICTURE  "@E 999,999,999.99"   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 110,270 BUTTON "&Sair"	SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL		//"Sair"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Folder 2                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 003,001 TO 125,310 PIXEL OF oFolder:aDialogs[2] label "Impostos"

	@ 015,005 SAY "Vlr IPI"		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
	@ 030,005 SAY "Vlr Icms"	SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
	@ 045,005 SAY "Vlr Pis " 	SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
	@ 060,005 SAY "Vlr Cofins "	SIZE 40,10 PIXEL OF oFolder:aDialogs[2]

	@ 015,050 MSGET nVlrIPI 	  PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
	@ 030,050 MSGET nVlrIcms      PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
	@ 045,050 MSGET nVlrPis       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
	@ 060,050 MSGET nVlrCof       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]

	@ 110,005 SAY "Total de Impostos "   SIZE 45,10 PIXEL OF oFolder:aDialogs[2] //"Total da Nota"
	@ 110,060 MSGET nTotImp    PICTURE  "@E 999,999,999.99"   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]

	@ 110,270 BUTTON "Sair"			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[2] PIXEL	//"Sair"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Folder 3                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 003,001 TO 125,310 PIXEL OF oFolder:aDialogs[3] Label "Totais "

	@ 015,005 SAY "Total Vendas"	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 030,005 SAY "-> Variaveis "	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 030,205 SAY "% Variaveis "	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 045,005 SAY "-> Impostos " 	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 045,205 SAY "% Impostos " 	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 060,005 SAY "P. C. L.  "	    SIZE 40,10 PIXEL OF oFolder:aDialogs[3]
	@ 060,205 SAY "% P. C. L.  "	SIZE 40,10 PIXEL OF oFolder:aDialogs[3]

	@ 090,005 SAY "P. C. L.  - Cx"	SIZE 45,10 PIXEL OF oFolder:aDialogs[3]

	@ 015,050 MSGET nTotPed 	  PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	@ 030,050 MSGET nVlrVar       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	@ 030,250 MSGET nPerVlrVar    PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	@ 045,050 MSGET nTotImp       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	nPerTotImp  := ( nTotImp / nTotPed ) * 100

	@ 045,250 MSGET nPerTotImp    PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	@ 060,050 MSGET nVlrLiq       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]
	@ 060,250 MSGET nPerVlrLiq    PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	@ 090,050 MSGET nPrcLiqCx     PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[3]

	nPerMargem := Round((nMargem / nVlrLiq ) * 100,2)

	//Variavveis utilizadas na pasta de Margem

	nPerVlrVar := ( nVlrVar / nTotPed ) * 100
	nPerTotImp  := ( nTotImp / nTotPed ) * 100
	nPerTotCus  := ( nTotCus / nTotPed ) * 100
	nMargemBru := nTotPed - nVlrVar - nTotImp - nTotCus
	If nVlrLiq < 0 .And. nMargemBru < 0
		nPerMarBru := ( ( nMargemBru / ( nTotPed - nVlrVar ) ) * 100 ) *  -1
	Else
		nPerMarBru := ( nMargemBru / ( nTotPed - nVlrVar ) ) * 100
	EndIf
	nPerFreMar := ( nFrete / nTotPed ) * 100

	nPerComMar := ( nComissao / ( nTotPed - nVlrVar ) ) * 100
	nMargemCon := nMargemBru - nFrete - nComissao
	If nVlrLiq < 0 .And. nMargemCon < 0
		nPerMarCon := ( ( nMargemCon / ( nTotPed - nVlrVar ) ) * 100 ) * -1
	Else
		nPerMarCon := ( nMargemCon / ( nTotPed - nVlrVar ) ) * 100
	EndIf


	oEspBmp := TBmpRep():New(85,132, 30, 28,;
	, .T.,oFolder:aDialogs[3], , , .F., .T., , , .F., , .T., , .F. )
	If nPerMarCon >= aMargens[1]
		oEspBmp:cbmpfile := "BOM.BMP" //"logo0101.jpg"
	ElseIf nPerMarCon < aMargens[1] .And. nPerMarCon >= aMargens[2]
		oEspBmp:cbmpfile := "REGULAR.BMP" //"logo0101.jpg"
	Else
		oEspBmp:cbmpfile := "RUIM.BMP" //"logo0101.jpg"
	EndIf

	@ 090,270 BUTTON "Prc Med"	SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION {||MediaPrc()}  OF oFolder:aDialogs[3] PIXEL	//"Sair"
	@ 110,270 BUTTON "Sair"	    SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION oDlg:End() OF oFolder:aDialogs[3] PIXEL		//"Sair"

//	If  lVend

		@ 003,001 TO 95,310 PIXEL OF oFolder:aDialogs[4] label "Margem Bruta"

		@ 015,005 SAY "Total Vendas"	  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 030,005 SAY "Desc. Variaveis "  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 030,205 SAY "% Variaveis "	  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 045,005 SAY "Impostos "         SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 045,205 SAY "% Impostos "	      SIZE 40,10 PIXEL OF oFolder:aDialogs[4]

		@ 060,005 SAY "Custos " 	  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 060,205 SAY "% Custos  " 	      SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 080,005 SAY "Margem Bruta "	  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 080,205 SAY "% Margem Bruta"	  SIZE 40,10 PIXEL OF oFolder:aDialogs[4]

		@ 015,050 MSGET nTotPed 	  PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 030,050 MSGET nVlrVar   PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 030,250 MSGET nPerVlrVar    PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 045,050 MSGET nTotImp       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 045,250 MSGET nPerTotImp      PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 060,050 MSGET nTotCus       PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 060,250 MSGET nPerTotCus      PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]


		@ 080,050 MSGET nMargemBru      PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]


		@ 080,250 MSGET nPerMarBru      PICTURE "@E 9999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 098,001 TO 160,210 PIXEL OF oFolder:aDialogs[4] label "Margem Contribuicao"

		@ 110,005 SAY "Frete     "	        SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 110,110 SAY "% Frete   "		    SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 125,005 SAY "Comissao  "      	SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 125,110 SAY "% Comissao "		    SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 145,005 SAY "Mar.Contribuicao"    SIZE 40,10 PIXEL OF oFolder:aDialogs[4]
		@ 145,110 SAY "% Margem "		    SIZE 40,10 PIXEL OF oFolder:aDialogs[4]

		@ 110,050 MSGET nFrete      PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 110,150 MSGET nPerFreMar       PICTURE "@E 999.99"	SIZE 40,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 125,050 MSGET nComissao   PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 125,150 MSGET nPerComMar       PICTURE "@E 999.99"	SIZE 40,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 145,050 MSGET nMargemCon  PICTURE "@E 999,999,999.99"	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		@ 145,150 MSGET nPerMarCon  PICTURE "@E 9999.99"	    SIZE 40,07 PIXEL WHEN .F. OF oFolder:aDialogs[4]

		oEspBmp := TBmpRep():New(115,222, 30, 28,;
		, .T.,oFolder:aDialogs[4], , , .F., .T., , , .F., , .T., , .F. )
		If nPerMarCon >= aMargens[1]
			oEspBmp:cbmpfile := "BOM.BMP" //"logo0101.jpg"
		ElseIf nPerMarCon < aMargens[1] .And. nPerMarCon >= aMargens[2]
			oEspBmp:cbmpfile := "REGULAR.BMP" //"logo0101.jpg"
		Else
			oEspBmp:cbmpfile := "RUIM.BMP" //"logo0101.jpg"
		EndIf

		@ 100,270 BUTTON "Grafico"	SIZE 040,11 FONT oFolder:aDialogs[4]:oFont ACTION {||Mostr_Graf()} OF oFolder:aDialogs[4] PIXEL   //"Sair"
		@ 120,270 BUTTON "Det. Sku"	SIZE 040,11 FONT oFolder:aDialogs[4]:oFont ACTION {||MostraDet()}  OF oFolder:aDialogs[4] PIXEL	//"Sair"
		@ 140,270 BUTTON "Sair"	    SIZE 040,11 FONT oFolder:aDialogs[4]:oFont ACTION oDlg:End()       OF oFolder:aDialogs[4] PIXEL	//"Sair"

//	EndIf

	ACTIVATE MSDIALOG oDlg CENTERED

	DET->(DbCloseArea())

	RestArea(aArea)

Return

Static Function ChkCont(oDlg )
	Local lRet := .T.

	If nVlrCont > nVlrTot
		MsgStop("Valor do Contrato não pode ser maior que o valor total do Pedido...")
		Return.F.
	EndIf

	If nVlrCont > 0
		nPerCont := ( nVlrCont / nVlrTot ) * 100
	Else
		nPerCont := 0
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

	oDlg:Refresh(.T.)

Return lRet

Static Function ChkPerCont(oDlg )
	Local lRet := .T.

	If nPercont > 100
		MsgStop("Percentual invalido para o calculo...")
		Return .F.
	EndIf

	If nPerCont > 0
		nVlrCont :=  nVlrTot  *  ( nPerCont / 100 )
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return lRet

Static Function ChkVerbas(oDlg )
	Local lRet := .T.

	If nVerbas > nVlrTot
		MsgStop("Valor da Verbas não pode ser maior que o valor total do Pedido...")
		Return.F.
	EndIf

	If nVerbas  > 0
		nPerVerba  := ( nVerbas / nVlrTot ) * 100
	Else
		nPerVerba := 0
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return lRet

Static Function ChkPerVer(oDlg )
	Local lRet := .T.

	If nPerVerba  > 100
		MsgStop("Percentual invalido para o calculo...")
		Return .F.
	EndIf

	If nPerVerba > 0
		nVerbas :=  nVlrTot  *  ( nPerVerba  / 100 )
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return lRet


Static Function ChkBonif(oDlg )
	Local lRet := .T.

	If nBonificacao > nVlrTot
		MsgStop("Valor da Bonificacao não pode ser maior que o valor total do Pedido...")
		Return.F.
	EndIf

	If nBonificacao  > 0
		nPerBon  := ( nBonificacao / nVlrTot ) * 100
	Else
		nPerBon := 0
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return lRet

Static Function ChkPerBon(oDlg )
	Local lRet := .T.

	If nPerBon  > 100
		MsgStop("Percentual invalido para o calculo...")
		Return .F.
	EndIf

	If nPerBon > 0
		nBonificacao :=  nVlrTot  *  ( nPerBon  / 100 )
	EndIf

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return lRet

Static Function ChkFrete(oDlg )

	nVlrVar := ( nVlrCont + nVerbas + nFrete + nBonificacao + nDesconto  + nComissao  )
	nVlrLiq := nTotPed - ( nVlrVar + nTotImp )
	nPrcLiqCX := nVlrLiq / nTotQtd
	nMargem := nVlrLiq - nTotCus

	nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
	nPerTotImp := ( nTotImp / nTotPed ) * 100
	nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

	Atu_Det(oDlg )

Return

Static Function Atu_Det(oDlg )

	//Alert("Estou....")

	DbSelectArea("DET")
	DbGoTop()

	While DET->(!Eof())

		RecLock("DET",.F.)
		DET->VLRVAR := nVlrVar * ( DET->TOTAL / nTotPed )
		DET->VLRPCL := DET->TOTAL - ( DET->VLRVAR + DET->VLRIMP )
		DET->PCL_CX := DET->VLRPCL / DET->QTDE
		MsUnlock()
		Det->(DbSkip())

	End

	DET->(DbGoTop())

	oFolder:Refresh()

Return


Static Function MostraDet()
	Local oDlg

	aBrowse := {}

	AaDD(aBrowse,{"ITEM",,"Item",""})
	AaDD(aBrowse,{"PROD",,"Produto",""})
	AaDD(aBrowse,{"QTDE",,"Qtde","@e 999,999.9999"})
	AaDD(aBrowse,{"TOTAL",,"Valor","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRVAR",,"Variaveis","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRIMP",,"Impostos","@e 999,999,999.99"})
	AaDD(aBrowse,{"VLRPCL",,"Vlr PCL","@e 999,999,999.99"})
	AaDD(aBrowse,{"PCL_CX",,"Pcl / Cx","@e 9,999,999.99"})


	DbSelectArea("DET")

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Detalhe por Sku") FROM 09,00 TO 28,80

	oMark := MsSelect():New("DET","",,aBrowse,Nil,Nil,{5,5,110,310})

	@ 115,270 BUTTON "Sair" SIZE 040,11 ACTION {||oDlg:End()} OF oDlg PIXEL		//"Sair"

	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function Mostr_Graf()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize		:= MsAdvSize(,.F.,430)
	aObjects	:= {{ 100, 157 , .T., .T. }}
	aInfo		:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
	aPosObj	:= MsObjSize( aInfo, aObjects )

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

	DEFINE MSDIALOG oDlg FROM 0,0 TO 300,500 PIXEL TITLE "Demonstração gráfica de Venda"

	//@ 020, 055 MSGRAPHIC oGraphic SIZE 285,158 OF oDlg PIXEL

	// Layout da janela
	//@ 000, 000 BITMAP oBmp RESNAME "ProjetoAP" oF oDlg SIZE 50, 250 NOBORDER WHEN .F. PIXEL
	//@ 003, 060 SAY STR0006 + SN1->N1_DESCRIC + STR0007 + Dtoc(mv_par01) + STR0008 + Dtoc(mv_par02) FONT oBold PIXEL //"Depreciação "###" no perído de "###" a "

	//@ 014, 050 TO 16 ,400 LABEL '' OF oDlg  PIXEL
	@ 140,170 BUTTON "Sair" SIZE 040,11 ACTION {||oDlg:End()} OF oDlg PIXEL		//"Sair"

	ACTIVATE MSDIALOG oDlg  ON INIT Graf_Ven(oDlg ) CENTERED

	//

Return


Static function Graf_Ven(oDlg)
	Local nSerie := 0
	Local oBold
	Local o3d
	Local oSerie
	Local oDlg
	Local nGrafico := 10


	//Default cCbx := aCbx[2]

	oGraphic:=TMSGraphic():New( 001, 001, , , , , 248, 128)

	oGraphic:SetMargins( 10, 0, 0, 0 )

	//oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	//oGraphic:SetTitle( ,"Meses", CLR_BLACK, A_RIGHTJUS , GRP_FOOT  ) //"Meses"
	//oGraphic:SetTitle( 	"Valores", "", CLR_BLACK, A_LEFTJUST , GRP_TITLE  ) //"Valores"

	oGraphic:SetLegenProp( GRP_SCRRIGHT, CLR_WHITE, GRP_SERIES, .T.)

	nSerie   := oGraphic:CreateSerie(nGrafico)

	oGraphic:l3D := .T.

	If nSerie != GRP_CREATE_ERR

		//   oGraphic:Add(nSerie, nVlrVar, "Variaveis",CLR_HGRAY)  //StrZero(nX, 2)
		//   oGraphic:Add(nSerie, nTotImp, "Impostos",CLR_HBLUE)  //StrZero(nX, 2)
		//   oGraphic:Add(nSerie, nVlrLiq, "P.C.L",CLR_GREEN)  //StrZero(nX, 2)
		//nPerVlrVar  := ( nVlrVar / nTotPed ) * 100
		//nPerTotImp := ( nTotImp / nTotPed ) * 100
		//nPerVlrLiq  := ( nVlrLiq / nTotPed  )  * 100

		oGraphic:Add(nSerie, Round(nPerVlrVar,2) , "Variaveis",CLR_HGRAY)  //StrZero(nX, 2)
		oGraphic:Add(nSerie, Round(nPerTotImp,2) , "Impostos",CLR_HBLUE)  //StrZero(nX, 2)
		oGraphic:Add(nSerie, Round(nPerVlrLiq,2) , "P.C.L",CLR_GREEN)  //StrZero(nX, 2)

	Else
		ApMsgAlert("Não foi possível criar a série") //
	Endif

	//cBmpName := CriaTrab(,.F.)+".BMP"

	//oGraphic:SaveToBMP( cBmpName, cRaizServer )

	//oGraphic:hide()

	nVlrMax := 100 //nTotPed

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  ºAutor  ³Microsiga           º Data ³  02/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MostraPeso()
	Local nPesoLiq := 0
	Local nPesoBru := 0
	Local nQtd  := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_QTDVEN"})
	Local nProd := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "C6_PRODUTO"})
	Local oDlg
	Local oPesoLiq, oPesoBru, oQtde, oTotPalle
	Local nPesoLiq := nPesoBru := 0
	Local nQtde := 0

	oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

	For nX := 1 to Len(aCols)

		If !aCols[nX,Len(aHeader)+1]
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aCols[nX,nProd] ))
			nPesoLiq += aCols[nX,nQtd] * SB1->B1_PESO
			nPesoBru += aCols[nX,nQtd] * SB1->B1_PESBRU
			nQtde    += aCols[nX,nQtd]
		EndIf

	Next

	nCxPalle := 0
	nTotPalle := 0

	For nX := 1 to Len(aCols)

		If !aCols[nX,Len(aHeader)+1]

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aCols[nX,nProd] ))

			SA7->(DbSetOrder(1))
			If SA7->(DbSeek(xFilial("SA7")+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX,nProd] ))
				nCxPalle := SA7->A7_CXPALLE
			Else
				nCxPalle := SB1->B1_QTPALLE
			EndIf

			If nCxPalle > 0
				nTotPalle += Int(( aCols[nX,nQtd] / nCxPalle )) + If(Mod(aCols[nX,nQtd],nCxPalle) > 0 , 1 , 0 )
			EndIf

		EndIf

	Next


	cPedido := M->C5_NUM

	DEFINE MSDIALOG oDlg TITLE "Peso do Pedido" From 9,0 To 35,80 OF oMainWnd

	@ 15, 04 TO 41,315 LABEL "Numero do Pedido" OF oDlg	PIXEL

	@ 25, 10 SAY oSay PROMPT "Pedido : "+cPedido  PIXEL OF oDlg SIZE 120,14;
	COLOR CLR_HBLUE FONT oFonte

	@ 45, 04 TO 171,315  OF oDlg	PIXEL

	@ 58, 10 SAY oSay PROMPT "Peso Liquido : "  PIXEL OF oDlg SIZE  90,14;
	COLOR CLR_HBLUE FONT oFonte


	@ 56, 137 MSGET oPesoLiq VAR nPesoLiq Picture "@E 999,999.9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .f. COLOR CLR_HBLUE FONT oFonte RIGHT


	@  78, 10 SAY oSay PROMPT "Peso Bruto : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  78, 137 MSGET oPesoBru VAR nPesoBru  PICTURE "@e 999,999.9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   120, 10 SAY oSay PROMPT "Qtde Cxs : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  120, 137 MSGET oQtde VAR nQtde  PICTURE "@e 999,9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   150, 10 SAY oSay PROMPT "Tot.Pallets : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  150, 137 MSGET oTotPalle VAR nTotPalle PICTURE "@e 999,999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@ 175,10 Button "&Fechar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg Centered //ON INIT LchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca := 2,oDlg:End()},.T.) CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  ºAutor  ³Microsiga           º Data ³  09/14/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MosRomaneio()
	Local oDlg
	Local oRomaneio, oNumCar

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	DbSelectArea("SC9")
	DbSetOrder(1)

	DbSeek(xFilial("SC9")+M->C5_NUM )

	aRomaneio := {}
	aCarga    := {}

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == M->C5_NUM

		If Empty(SC9->C9_ROMANEI)
			DbSkip()
			Loop
		EndIf

		nPesq := Ascan(aRomaneio,SC9->C9_ROMANEI)
		If nPesq == 0
			AaDd(aRomaneio,SC9->C9_ROMANEI)
		EndIf

		If !Empty(SC9->C9_NUMCARG)
			nPesq := Ascan(aCarga,SC9->C9_NUMCARG)
			If nPesq == 0
				AaDd(aCarga,SC9->C9_NUMCARG)
			EndIf
		EndIf

		DbSkip()

	End

	If Len(aRomaneio) > 0 .And. Len(aCarga) == 0
		aCarga := Array(Len(aRomaneio))
		Afill(aCarga," ")
	EndIf

	If Len(aRomaneio) > 0

		For nX := 1 to Len(aRomaneio)
			DEFINE MSDIALOG oDlg FROM  47,130 TO 250,400 TITLE OemToAnsi("Consulta Romaneio ") PIXEL

			@ 05, 04 TO 41,130 LABEL "Numero Romaneio "+StrZero(nX,2) OF oDlg	PIXEL //

			@ 18, 17 MSGET oRomaneio VAR aRomaneio[nX]  PICTURE "999999" When .f. SIZE 70,14 FONT oFonte PIXEL;
			OF oDlg  COLOR CLR_HBLUE FONT oFonte RIGHT


			@ 43, 04 TO 74,130 LABEL "Numero Carga "+StrZero(nX,2) OF oDlg	PIXEL //

			@ 56, 17 MSGET oNumCar VAR aCarga[nX]  PICTURE "999999" When .f. SIZE 70,14 FONT oFonte PIXEL;
			OF oDlg  COLOR CLR_HBLUE FONT oFonte RIGHT

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Botoes para confirmacao ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


			DEFINE SBUTTON FROM 77, 101 oButton2 TYPE 1 ENABLE OF oDlg ;
			ACTION (oDlg:End()) PIXEL

			ACTIVATE MSDIALOG oDlg CENTERED
		Next
	Else
		MsgAlert("Pedido nao possui Romaneio..")
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MediaPrc  ºAutor  ³Carlos R. Moreira   º Data ³  09/20/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preço  Medio de vendas de produtos                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MediaPrc()
	Local aCampos := {}
	Local nColProd   := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_PRODUTO"} )
	Local nColPrc    := Ascan(aHeader,{|x|Alltrim(x[2]) == "C6_PRCVEN"} )
	Local oDlg

	//Cria o Arquivo de Trabalho
	AADD(aCampos,{ "PROD"   ,"C",15,0 } )
	AADD(aCampos,{ "DESC"   ,"C",30,0 } )
	AADD(aCampos,{ "PRCVEN" ,"N",11,2 } )
	AADD(aCampos,{ "MED01"  ,"N",11,2 } )
	AADD(aCampos,{ "MED02"  ,"N",11,2 } )
	AADD(aCampos,{ "MED03"  ,"N",11,2 } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"MED", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("MED",cNomArq,"PROD",,,OemToAnsi("Selecionando Registros..."))	//

	nMesFim := Month(M->C5_EMISSAO) - 1
	nAnoFim := Year(M->C5_EMISSAO)
	If nMesFim == 0
		nMesFim := 12
		nAnoFim := Year(M->C5_EMISSAO) - 1
	EndIf

	nMesIni := Month(M->C5_EMISSAO) - 3
	nAnoIni := Year(M->C5_EMISSAO)

	If nMesIni == 0
		nMesIni := 12
		nAnoIni := Year(M->C5_EMISSAO) - 1
	ElseIf nMesIni < 0
		nMesIni := 12 + nMesIni
		nAnoIni := Year(M->C5_EMISSAO) - 1
	EndIf

	dDataIni := Ctod("01/"+StrZero(nMesIni,2)+"/"+StrZero(nAnoIni,4) )
	dDataFim := LastDay( Ctod("01/"+StrZero(nMesFim,2)+"/"+StrZero(nAnoFim,4) ) )

	aMes := {}
	aAno := {}
	For nMes := dDataIni to dDataFim
		cMes := StrZero(Month(nMes),2)
		cAno := StrZero(Year(nMes),4)
		nPesq := Ascan(aMes,cMes)
		If nPesq == 0
			AaDd(aMes,cMes)       
			AaDd(aAno,cAno)
		EndIf

	Next

	For nX:=1  to Len(aCols)

		BeginSql Alias "QRY"

			Column D2_EMISSAO AS DATE

			Select D2_EMISSAO,D2_PRCVEN From %Table:SD2%
			Where D_E_L_E_T_ <> '*' AND D2_EMISSAO BETWEEN %exp:dDataIni% AND %exp:dDataFim%
			And D2_COD = %exp:aCols[nX,nColProd]%  AND D2_CLIENTE = %exp:M->C5_CLIENTE% AND
			D2_LOJA = %exp:M->C5_LOJACLI%

			Order by D2_EMISSAO

		EndSql

		aMeses := {}

		For nMeses := dDataIni to dDataFim 

			nPesq := Ascan(aMeses, {|x| x[1] = Substr(Dtos(nMeses),1,6 ) } )
			If nPesq == 0
				AaDd(aMeses,{Substr(Dtos(nMeses),1,6 ),0,0} )
			EndIf

		Next

		DbSelectArea("QRY")
		DbGoTop()

		While QRY->(!Eof())

			nPesq := Ascan(aMeses, {|x| x[1] = Substr(Dtos(QRY->D2_EMISSAO),1,6 ) } )
			If nPesq == 0
				AaDd(aMeses,{Substr(Dtos(QRY->D2_EMISSAO),1,6 ),QRY->D2_PRCVEN,1} )
			Else
				aMeses[nPesq,2] += QRY->D2_PRCVEN
				aMeses[nPesq,3] ++

			EndIf

			DbSelectArea("QRY")
			DbSkip()

		End

		If Len(aMeses) > 0
			If Len(aMeses) < 3
				For nY := 1 to 3 - Len(aMeses)
					AaDd(aMeses,{" ",0,0 } )
				Next

			EndIf

			DbSelectArea("MED")
			RecLock("MED",.T.)
			MED->PROD  := aCols[nX,nColProd]
			MED->DESC  := Posicione("SB1",1,xFilial("SB1")+aCols[nX,nColProd] ,"B1_DESC")
			MED->PRCVEN:= aCols[nX,nColPrc]

			For nY := 1 to Len(aMeses)


				nPesq := Ascan(aMes,Substr(aMeses[nY,1],5,2)  )
				If nPesq > 0
					If nPesq == 1
						MED->MED01 := aMeses[nPesq,2] / aMeses[nPesq,3]
					ElseIf nPesq == 2
						MED->MED02 := aMeses[nPesq,2] / aMeses[nPesq,3]
					Else
						MED->MED03 := aMeses[nPesq,2] / aMeses[nPesq,3]
					EndIf
				EndIf

			Next

		EndIf

		QRY->(DbCloseArea())

	Next

	If Len(aMeses) > 0

		MED->(DbGoTop())

		aBrowse := {}

		AaDD(aBrowse,{"PROD",,"Produto",""})
		AaDD(aBrowse,{"DESC",,"Descricao",""})
		AaDD(aBrowse,{"MED01",,MesExtenso(Val(aMes[1]))+"/"+aAno[1] ,"@e 999,999.99"})
		AaDD(aBrowse,{"MED02",,MesExtenso(Val(aMes[2]))+"/"+aAno[2],"@e 999,999,999.99"})
		AaDD(aBrowse,{"MED03",,MesExtenso(Val(aMes[3]))+"/"+aAno[3],"@e 999,999,999.99"})
		AaDD(aBrowse,{"PRCVEN",,"Prc Ped" ,"@e 999,999.99"})

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Preco Medio de Venda") FROM 09,00 TO 28,100

		oMark := MsSelect():New("MED","",,aBrowse,Nil,Nil,{5,5,110,380})

		@ 115,270 BUTTON "Sair" SIZE 040,11 ACTION {||oDlg:End()} OF oDlg PIXEL		//"Sair"

		ACTIVATE MSDIALOG oDlg CENTERED

	Else
		MsgInfo("Cliente nao possui media de preco dos produtos.." )

	EndIf
	MED->(DbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MosResPed ºAutor  ³Carlos R. Moreira   º Data ³  11/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra o Resumo do filtro de Pedidos                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MosResPed()
	Local aArea := GetArea()

	lTodos := .T.
	If MsgYesNo("Somente itens em aberto")
		lTodos := .F.
	EndIf

	nTotal := 0
	nPeso  := 0
	nQtCxs := 0

	nVlrCif := 0
	nVlrFob := 0

	DbSelectArea("SC5")
	DbGoTop()

	While SC5->(!Eof()) 

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+SC5->C5_NUM  )

		While SC6->(!Eof()) .And. SC5->C5_NUM = SC6->C6_NUM 

			If !lTodos 

				If SC6->C6_QTDVEN - SC6->C6_QTDENT == 0  .Or. Alltrim(SC6->C6_BLQ) == "R"
					SC6->(DbSkip())
					Loop
				EndIf
			EndIf

			SB1->(DbSetOrder(1)) 
			SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO ))

			nTotal += SC6->C6_PRCVEN * ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
			nPeso  += SB1->B1_PESBRU * ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
			nQtCxs += ( SC6->C6_QTDVEN - SC6->C6_QTDENT )                                                               

			If SC5->C5_TPFRETE == "C"
				nVlrCif += SC6->C6_PRCVEN * ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
			Else                                                               
				nVlrFob += SC6->C6_PRCVEN * ( SC6->C6_QTDVEN - SC6->C6_QTDENT )     
			EndIf 

			DbSelectArea("SC6")
			DbSkip()

		End

		DbSelectArea("SC5")
		DbSkip()

	End

	nPerCif := Round( ( nVlrCif / nTotal) * 100 , 2 ) 
	nPerFob := Round( ( nVlrFob / nTotal) * 100 , 2 )

	Private oPeso, oValor, oQtde, oVlrCif, oPerCif, oVlrFob, oPerFob

	DEFINE MSDIALOG oDlg TITLE "Resumo" From 9,0 To 35,80 OF oMainWnd

	@ 15, 04 TO 41,315 LABEL "Valor Total" OF oDlg	PIXEL

	@ 25, 10 MsGet oValor var nTotal Picture "@e 999,999,999.99" When .F. PIXEL OF oDlg SIZE 120,14;
	COLOR CLR_HBLUE FONT oFonte

	@ 45, 04 TO 171,315  OF oDlg	PIXEL

	@ 58, 10 SAY oSay PROMPT "Peso Total : "  PIXEL OF oDlg SIZE  90,14;
	COLOR CLR_HBLUE FONT oFonte


	@ 56, 137 MSGET oPeso VAR nPeso Picture "@E 999,999.9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .f. COLOR CLR_HBLUE FONT oFonte RIGHT

	@   78, 10 SAY oSay PROMPT "Qtde Cxs : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@   78, 137 MSGET oQtde VAR nQtCxs  PICTURE "@e 999,9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   120, 10 SAY oSay PROMPT "Fob : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  120, 137 MSGET oPerFob VAR nPerFob PICTURE "@e 999.99" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   150, 10 SAY oSay PROMPT "Cif : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  150, 137 MSGET oPerCif VAR nPerCif PICTURE "@e 999.99" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@ 175,10 Button "&Fechar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg Centered 

	RestArea(aArea)
Return
