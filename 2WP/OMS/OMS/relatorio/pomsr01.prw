#Include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³POMSR01   ºAutor  ³Carlos R. Moreira   º Data ³  08/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Solicita o Numero do Romaneio para Impressao da Carga       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function POMSR01()

	Local lRet := .F.
	Local oFonte
	Local oDlg
	Local oButton2
	Local oButton1
	Local oPedido
	Local oSay
	Local oSay_2
	Local uRet
	nOpca := 0

	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

	oBrush  := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)


	Private cStartPath 	:= GetSrvProfString("Startpath","")
	Private lFiltraGru := .F.

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.","02")
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf 

	//cStartPath += "Romaneio\"

	Private cRomaneio
	Private oMotorista,oVeiculo,oPlaca,oDataIni,oDataFim
	Private cMotorista,cVeiculo,cPlaca,dDtCarre,cTpCarRo 

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	aRegs := {}
	cPerg := "POSMR01"

	aAdd(aRegs,{cPerg,"01","Romaneio de        ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Romaneio Ate       ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"03","Emissao de         ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Emissao Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})


	aAdd(aRegs,{cPerg,"05","Imprimir somente   ?","","","mv_ch5","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR05","Espelho Cego"  ,"","","","","Romaneio","","","","","Resumo","","","","","Todas","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"06","Carregamento de    ?","","","mv_ch6","D"   ,08    ,00      ,0   ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Carregamento Ate   ?","","","mv_ch7","D"   ,08    ,00      ,0   ,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T.)

	aSays    := {}
	aButtons := {}
	cCadastro := "Impressao de Romaneio"

	If Empty(MV_PAR01)
		cRomIni  := "000001"
	Else
		cRomIni := StrZero(Val(MV_PAR01),6)
	EndIf 

	If Empty(MV_PAR02) .Or. "Z" $ MV_PAR02 
		cRomFim  := "999999"
	Else 
		cRomFim  := StrZero(Val(MV_PAR02),6)
	EndIf    
	dDataIni := MV_PAR03
	dDataFim := MV_PAR04
	dDtCarIn := MV_PAR06
	dDtCarFi := MV_PAR07

	nTipoRel := MV_PAR05

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo gerar o relatorio de  " ) ) //
	AADD(aSays,OemToAnsi( " acordo com os parametros selecionados pelo usuario. " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||U_GeraTrab()},"Processando o arquivo..")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Impr_Ped  ºAutor  ³Carlos R. Moreira   º Data ³  09/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime os Novos precos dos produtos                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpRoma()
	Local oPrn

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )
	oArialNeg07 :=  TFont():New( "Arial",, 7,,.T.,,,,,.f. )

	oFont1:= TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
	oFont2:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont4:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont7:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	oFont11:=TFont():New( "Times New Roman",,10,,.t.,,,,,.t. )

	oFont6:= TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

	oFont8:=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )

	oBrush  := TBrush():New(,CLR_HGRAY,,)
	oBrush1 := TBrush():New(,CLR_BLUE,,)
	oBrush2 := TBrush():New(,CLR_WHITE,,)

	oPrn := TMSPrinter():New()
	oPrn:SetPortrait()
	//oPrn:SetLandscape()
	oPrn:SetPaperSize(9)

	If Type("NTIPOREL") == "U"
		nTipoRel:= 4
	EndIf 

	lEmail := .F.
	lFirst := .T.  

	If lEmail
		cJPEG := CriaTrab(,.F.)
	EndIf

	oPrn:Setup()

	If nTipoRel  # 3

		DbSelectArea("ROM")
		DbGotop()

		ProcRegua(RecCount())        // Total de Elementos da regua

		While ROM->(!EOF())

			IncProc("Imprimindo Romaneio...")

			lFirst := .T.
			nTotPeso := nTotCxs := 0
			nTotFre  := 0
			nVlrRom := 0
			nTotPall := 0
			cTraRom   := ROM->TRANSP
			cRomaneio := ROM->ROMANEI
			cTransp   := ROM->TRANSP
			cMotoris  := ROM->MOTORIS
			cTipoVei  := ROM->TPVEIC
			cTpCarro  := ROM->TPCARRO
			dDtCarre  := ROM->DTCARRE
			dDtEmi    := ROM->EMIROM

			/*
			If nTipoRel  == 1  .Or. nTipoRel == 4

			lFirst := .T.
			nPag   := 0
			nLin   := 490

			While ROM->(!Eof()) .And. ROM->ROMANEI == cRomaneio


			cPedido := ROM->PEDIDO
			lPriPed := .T.
			lImpCompl := .T.
			cObsInt   := ROM->OBSINT
			cObsExt   := ROM->OBSEXT

			nVolPed := nPesoPed := nPallPed  := 0
			//Cada Romaneio devera ter paginas  separadas

			While ROM->(!Eof()) .And. cPedido == ROM->PEDIDO .And. ROM->ROMANEI == cRomaneio

			If lFirst
			oPrn:StartPage()
			cTitulo := "Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(dDtEmi) 
			cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")   
			aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"")
			CabCons(oPrn,1)

			lFirst = .F.

			EndIf

			SA1->(DbSeek(xFilial("SA1")+ROM->CLIENTE+ROM->LOJA))

			If lPriPed

			oPrn:Box(nLin,100,nLin+120,2300)

			oPrn:Say(nLin+15,  110,ROM->ORDCARG  ,oFont,100)
			oPrn:Say(nLin+15,  310,"Empresa: "+ROM->NOMEMP  ,oFont9,100)						
			oPrn:Say(nLin+15,  550,"Pedido: "+ROM->PEDIDO  ,oFont9,100)
			oPrn:Say(nLin+15,  870,"Cliente: "+ROM->CLIENTE+ROM->LOJA+"-"+SA1->A1_NOME   ,oFont5,100)

			oPrn:Say(nLin+15, 1700, "Tp Frete: "+If(ROM->TPFRERO=="F","Fob","CIF" )    ,oFont9,100)
			oPrn:Say(nLin+15, 1900, "Dt Entrega: "+Dtoc(ROM->DTENT)     ,oFont5,100)
			lPriPed := .F.

			oPrn:Say(nLin+75,  510,"End.Entrega: "+Alltrim(ROM->ENDENT)+"-"+Alltrim(ROM->BAIENT)+"-"+Alltrim(ROM->MUNENT)+"-"+Alltrim(ROM->ESTENT)+"-"+Transform(ROM->CEPENT,"@R 99999-999")  ,oFont9,100)

			nLin += 140

			EndIf

			oPrn:Box(nLin,100,nLin+60,2300)

			oPrn:line(nLin, 350,nLin+60, 350)

			oPrn:line(nLin,1600,nLin+60,1600)

			oPrn:line(nLin,1800,nLin+60,1800)

			oPrn:line(nLin,2000,nLin+60,2000)

			oPrn:line(nLin,2250,nLin+60,2250)

			oPrn:Say(nLin+15,  110,ROM->PROD    ,oArialNeg07,100)
			oPrn:Say(nLin+15,  360,ROM->DESC       ,oFont9,100)

			nLin += 60

			If nLin > 3100
			oPrn:EndPage()
			lFirst := .T.
			EndIf

			DbSelectArea("ROM")
			DbSkip()

			End

			nLin += 20

			If nLin > 3100 .Or. lFirst 

			If !lFirst 
			oPrn:EndPage()
			EndIf   

			oPrn:StartPage()
			cTitulo := "Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(dDtEmi)
			cRod    := "Data de Carregamento : "+Dtoc(ROM->DTCARRE)+" Carga: "+If(ROM->TPCARRO=="1" ,"Batida","Paletizada")
			aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"")
			CabCons(oPrn,1)
			lFirst := .F. 

			EndIf

			If nVolPed > 0

			oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

			oPrn:Box(nLin,100,nLin+60,2300)

			oPrn:line(nLin,1600,nLin+60,1600)
			oPrn:line(nLin,1800,nLin+60,1800)
			oPrn:line(nLin,2000,nLin+60,2000)
			oPrn:line(nLin,2250,nLin+60,2250)

			oPrn:Say(nLin+15, 110,"Total Pedido: " ,oFont5,100)

			nLin += 80

			If !Empty(cObsInt)
			oPrn:Box(nLin,100,nLin+60,2300)
			oPrn:Say(nLin+15, 120, "Obs.: "+cObsInt ,oFont5,100)
			nLin += 80
			EndIf

			EndIf


			End 

			If nTotCxs > 0

			oPrn:Box(nLin,100,nLin+60,2300)

			//		oPrn:line(nLin,1400,nLin+60,1400)
			oPrn:line(nLin,1600,nLin+60,1600)
			oPrn:line(nLin,1800,nLin+60,1800)				
			oPrn:line(nLin,2000,nLin+60,2000)

			oPrn:Say(nLin+15, 180,"Total Geral ... ....: " ,oFont5,100)

			EndIf

			cAjudante := Space(6)

			nLin := 3100
			oPrn:Box(nLin,100,nLin+200,2300)

			oPrn:Line(nLin,1150,nLin+200,1150)

			oPrn:Say( nLin+5,  120, "Motorista" ,oFont9,100 )

			oPrn:Say( nLin+5,  1170, "Conferente / Data / Hora" ,oFont9,100 )
			oPrn:Say( 3320,  120, "Via Interna" ,oFont9,100 )


			oPrn:EndPage()
			lFirst := .T.

			EndIf  
			*/
			If nTipoRel  ==  2 .Or. nTipoRel == 4 

				ROM->(DbSeek(cRomaneio))

				lFirst := .T.
				nPag   := 0
				nLin   := 490

				While ROM->(!Eof()) .And. ROM->ROMANEI == cRomaneio

					cPedido := ROM->PEDIDO
					lPriPed := .T.
					lImpCompl := .T.
					cObsInt   := ROM->OBSINT
					cObsExt   := ROM->OBSEXT

					nVolPed := nPesoPed := nPallPed  := 0
					//Cada Romaneio devera ter paginas  separadas

					While ROM->(!Eof()) .And. cPedido == ROM->PEDIDO .And. ROM->ROMANEI == cRomaneio

						If lFirst
							oPrn:StartPage()
							cTitulo := "Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(dDtEmi) 
							cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")   
							aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
							nPag++
							U_CabRel(aTit,2,oPrn,nPag,"")
							CabCons(oPrn,1)

							lFirst = .F.

						EndIf

						SA1->(DbSeek(xFilial("SA1")+ROM->CLIENTE+ROM->LOJA))

						If lPriPed

							oPrn:Box(nLin,100,nLin+120,2300)

							oPrn:Say(nLin+5 ,  110,"Pedido"  ,oFont9,100)							
							oPrn:Say(nLin+35 ,  110,ROM->PEDIDO  ,oFont,100)


							oPrn:Say(nLin+15,  310,"Empresa: "+ROM->NOMEMP  ,oFont9,100)						
							//oPrn:Say(nLin+15,  550,"Pedido: "+ROM->PEDIDO  ,oFont9,100)
							oPrn:Say(nLin+15,  670,"Cliente: "+ROM->CLIENTE+"-"+ROM->LOJA+"-"+ROM->NOME    ,oFont9,100)

							oPrn:Say(nLin+15, 1700, "Tp Frete: "+If(ROM->TPFRERO=="F","Fob","CIF" )    ,oFont9,100)
							oPrn:Say(nLin+15, 1900, "Dt Entrega: "+Dtoc(ROM->DTENT)     ,oFont5,100)
							lPriPed := .F.

							oPrn:Say(nLin+75,  310,"End.Entrega: "+Alltrim(ROM->ENDENT)+"-"+Alltrim(ROM->BAIENT)+"-"+Alltrim(ROM->MUNENT)+"-"+Alltrim(ROM->ESTENT)+"-"+Transform(ROM->CEPENT,"@R 99999-999")  ,oFont9,100)

							oPrn:Say(nLin+75, 2000, "Tp Ped: "+ROM->TPPED     ,oFont9,100)

							nLin += 120

							oPrn:Box(nLin,100,nLin+60,2300)
							oPrn:line(nLin, 700,nLin+60, 700)
							oPrn:line(nLin, 1500,nLin+60, 1500)


							oPrn:Say(nLin+10 ,  110,"Emissao: "+Dtoc(ROM->EMISSAO)  ,oFont3,100)
							oPrn:Say(nLin+10 ,  710,"Dt Entrega: "+Dtoc(ROM->DTENT)  ,oFont3,100)														
							oPrn:Say(nLin+10 ,  1510,"Dt Agenda: "+Dtoc(ROM->DTAGEN)  ,oFont3,100)
							oPrn:Say(nLin+10 ,  1900,"Hr Agenda:  "+ROM->HRAGEN  ,oFont3,100)							

							nLin += 80 

						EndIf

						oPrn:Box(nLin,100,nLin+60,2300)

						oPrn:line(nLin, 350,nLin+60, 350)

						oPrn:line(nLin,1600,nLin+60,1600)

						oPrn:line(nLin,1800,nLin+60,1800)

						oPrn:line(nLin,2000,nLin+60,2000)

						oPrn:line(nLin,2250,nLin+60,2250)

						oPrn:Say(nLin+15,  110,ROM->PROD    ,oArialNeg07,100)
						oPrn:Say(nLin+15,  360,ROM->DESC       ,oFont9,100)

						If cTpCarro == "2" 
							oPrn:Say(nLin+15, 1610,Transform(ROM->QTDPALL  ,"@e 99,999,99") ,oFont5,100)
						EndIf 
						oPrn:Say(nLin+15, 1810,Transform(ROM->QTDCX   ,"@e 99,999,999") ,oFont5,100)
						oPrn:Say(nLin+15, 2070,Transform(ROM->PESO    ,"@e 99,999,999") ,oFont5,100)


						nTotPeso  += ROM->PESO
						nPesoPed  += ROM->PESO
						nTotPall  += ROM->QTDPALL
						nPallPed  += ROM->QTDPALL 
						nTotCxs   += ROM->QTDCX
						nVolPed   += ROM->QTDCX
						nLin += 60

						If nLin > 3100
							oPrn:EndPage()
							lFirst := .T.
						EndIf

						DbSelectArea("ROM")
						DbSkip()

					End

					nLin += 20

					If nLin > 3100 .Or. lFirst 

						If !lFirst 
							oPrn:EndPage()
						EndIf   

						oPrn:StartPage()
						cTitulo := "Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(dDtEmi)
						cRod    := "Data de Carregamento : "+Dtoc(ROM->DTCARRE)+" Carga: "+If(ROM->TPCARRO=="1" ,"Batida","Paletizada")
						aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
						nPag++
						U_CabRel(aTit,2,oPrn,nPag,"")
						CabCons(oPrn,1)
						lFirst := .F. 

					EndIf

					If nVolPed > 0

						oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

						oPrn:Box(nLin,100,nLin+60,2300)

						oPrn:line(nLin,1600,nLin+60,1600)
						oPrn:line(nLin,1800,nLin+60,1800)
						oPrn:line(nLin,2000,nLin+60,2000)
						oPrn:line(nLin,2250,nLin+60,2250)

						oPrn:Say(nLin+15, 110,"Total Pedido: " ,oFont5,100)

						If cTpCarro == "2"   
							oPrn:Say(nLin+15, 1610,Transform(nPallPed ,"@e 99,999,999") ,oFont5,100)
						EndIf 
						oPrn:Say(nLin+15, 1810,Transform(nVolPed  ,"@e 99,999,999") ,oFont5,100)
						oPrn:Say(nLin+15, 2070,Transform(nPesoPed ,"@e 99,999,999") ,oFont5,100)


						nLin += 80
						If !Empty(cObsExt)
							oPrn:Box(nLin,100,nLin+60,2300)
							oPrn:Say(nLin+15, 120, "Obs.: "+cObsExt ,oFont5,100)
							nLin += 80
						EndIf

						If !Empty(cObsInt)
							oPrn:Box(nLin,100,nLin+60,2300)
							oPrn:Say(nLin+15, 120, "Agendamento .: "+cObsInt ,oFont5,100)
							nLin += 80
						EndIf

					EndIf

				End 

				If nTotCxs > 0

					oPrn:Box(nLin,100,nLin+60,2300)

					//		oPrn:line(nLin,1400,nLin+60,1400)
					oPrn:line(nLin,1600,nLin+60,1600)
					oPrn:line(nLin,1800,nLin+60,1800)				
					oPrn:line(nLin,2000,nLin+60,2000)

					oPrn:Say(nLin+15, 180,"Total Geral ... ....: " ,oFont5,100)


					If cTpCarro == "2"  
						oPrn:Say(nLin+15, 1610,Transform(nTotPall   ,"@e 99,999,999") ,oFont5,100)
					EndIf 
					oPrn:Say(nLin+15, 1810,Transform(nTotCxs   ,"@e 99,999,999") ,oFont5,100)
					oPrn:Say(nLin+15, 2120,Transform(nTotPeso ,"@e 99,999,999") ,oFont5,100)


				EndIf

				cAjudante := Space(6)

				nLin := 3100
				oPrn:Box(nLin,100,nLin+200,2300)

				oPrn:Line(nLin,1150,nLin+200,1150)

				oPrn:Say( nLin+5,  120, "Motorista" ,oFont9,100 )

				oPrn:EndPage()
				lFirst := .T.

			EndIf                

			If  nTipoRel == 4 

				Processa({||U_ImpResRom(oPrn,cRomaneio,dDtCarre,cTpCarRo)},"Imprimindo o Resumo de Romaneio...")

			EndIf

			DbSelectArea("ROM")

		End  

	EndIf 

	If !lFirst
		oPrn:EndPage()
	EndIf

	If nTipoRel  == 3  

		Processa({||U_ImpResRom(oPrn,cRomaneio,dDtCarre,cTpCarRo)},"Imprimindo o Resumo de Romaneio...")

	EndIf

	oPrn:Preview()

	If lEmail .and. !Empty(cJPEG)

		_nLagArq	:= 1270 //870
		_nAltArq	:= 870 //1270
		_nZooArq	:= 140

		oPrn:SaveAllAsJPEG(cStartPath+cJPEG,_nLagArq,_nAltArq,_nZooArq)

	EndIf

	oPrn:End()

	If lEmail .and. !Empty(cJPEG)
		U_QNCXRMAIL({{cStartPath,cJPEG,"Romaneios de Carga "}})
	EndIF

	If lEmail
		//	Deleta arquivos JPEG gerados pelos relatorios.
		FErase( cStartPath+cJPEG )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabCons   ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³monta o cabecalho da consulta                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabCons(oPrn,nModo)

	nLin := 320

	oPrn:Box(nLin,100,nLin+120,2300)
	//oPrn:Line(nLin,1050,nLin+120,1050 )
	oPrn:Say(nLin+10,  110,"Transportadora : "+cTraRom+" - "+Posicione("SA4",1,xFilial("SA4")+cTraRom,"A4_NOME")   ,oFont12 ,100)

	oPrn:Say(nLin+65,  110,"Veiculo: "+cTipoVei+" - "+Posicione("DUT",1,xFilial("DUT")+cTipoVei,"DUT_DESCRI")   ,oFont12 ,100)

	//	oPrn:Say( nLin+65, 1060, "Motorista: "+Posicione("DA4",1,xFilial("DA4")+cMotoris,"DA4_NOME") ,oFont12,100 )

	nLin += 140

	oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

	oPrn:Box(nLin,100,nLin+60,2300)

	oPrn:line(nLin, 350,nLin+60, 350)

	oPrn:line(nLin,1600,nLin+60,1600)
	oPrn:line(nLin,1800,nLin+60,1800)	
	oPrn:line(nLin,2000,nLin+60,2000)
	oPrn:line(nLin,2250,nLin+60,2250)

	oPrn:Say(nLin+10,  110,"Produto"     ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Descricao"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1610,"Pallet"      ,oFont5 ,100)	
	oPrn:Say(nLin+10, 1810,"Qtde"        ,oFont5 ,100)
	oPrn:Say(nLin+10, 2030,"Peso Bruto"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 2250,"Ok"          ,oFont9 ,100)
	nLin += 80


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLOGA03   ºAutor  ³Carlos R. Moreira   º Data ³  23/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira selecionar os pedidos de Vendas                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Scarlat                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GeraTrab(cRomaneio)
	Local aCampos := {}
	Local aArq := {{"SC9"," "},{"SC5"," "},{"SA1"," "},{"SB1"," "},{"SA4"," "},{"SC6"," "},{"SF4"," "}}

	aEmp := {}
	aNomeEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

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

	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )
	AADD(aCampos,{ "PROD"    ,"C",15,0 } )
	AADD(aCampos,{ "DESC"    ,"C",65,0 } )
	AADD(aCampos,{ "PEDIDO"  ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE" ,"C",06,0 } )
	AADD(aCampos,{ "LOJA"    ,"C",03,0 } )
	AADD(aCampos,{ "NOME"    ,"C",33,0 } )
	AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
	AADD(aCampos,{ "DTENT"   ,"D", 8,0 } )
	AADD(aCampos,{ "DTAGEN"  ,"D", 8,0 } )
	AADD(aCampos,{ "HRAGEN"  ,"C", 5,0 } )	
	AADD(aCampos,{ "TPPED"   ,"C",10,0 } )	
	AADD(aCampos,{ "PESO"    ,"N",11,0 } )
	AADD(aCampos,{ "QTDCX"   ,"N",11,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,4 } )
	AADD(aCampos,{ "PALLET"  ,"N", 3,0 } )	
	AADD(aCampos,{ "TRANSP"  ,"C",06,0 } )
	AADD(aCampos,{ "DESCTRA" ,"C",20,0 } )

	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )

	AADD(aCampos,{ "EST"     ,"C", 2,0 } )
	AADD(aCampos,{ "MUN"     ,"C",30,0 } )
	AADD(aCampos,{ "TPFRERO" ,"C", 1,0 } )
	AADD(aCampos,{ "TPCARRO" ,"C", 1,0 } )	
	AADD(aCampos,{ "ORDCARG" ,"C", 3,0 } )
	AADD(aCampos,{ "ITEM"    ,"C", 2,0 } )

	AADD(aCampos,{ "ESTENT"  ,"C", 2,0 } )
	AADD(aCampos,{ "MUNENT"  ,"C",30,0 } )
	AADD(aCampos,{ "BAIENT"  ,"C", 25,0 } )
	AADD(aCampos,{ "ENDENT"  ,"C",50,0 } )
	AADD(aCampos,{ "CEPENT"  ,"C", 8,0 } )

	AADD(aCampos,{ "MOTORIS" ,"C", 6,0 } )
	AADD(aCampos,{ "VEICULO" ,"C", 4,0 } )

	AADD(aCampos,{ "OBSINT"  ,"C", 60,0 } )
	AADD(aCampos,{ "OBSEXT"  ,"C", 160,0 } )

	AADD(aCampos,{ "DTCARRE" ,"D", 8,0 } )	
	AADD(aCampos,{ "GRUPO"   ,"C", 4,0 } )	
	AADD(aCampos,{ "PEDCLI"  ,"C", 15,0 } )
	AADD(aCampos,{ "EMPRESA" ,"C", 2,0 } )
	AADD(aCampos,{ "NOMEMP"  ,"C",10,0 } )
	AADD(aCampos,{ "TPVEIC"  ,"C", 2,0 } )
	AADD(aCampos,{ "QTDPALL" ,"N",11,4 } )
	AADD(aCampos,{ "EMIROM"  ,"D", 8,0 } )				

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"ROM", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("ROM",cNomArq,"ROMANEI+ORDCARG+PEDIDO+ITEM",,,OemToAnsi("Selecionando Registros..."))	//

	aCampos := {} 

	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "GRUEMB"   ,"C", 2,0 } )
	AADD(aCampos,{ "PROD"     ,"C",15,0 } )	
	AADD(aCampos,{ "QUANT"    ,"N",11,4 } )
	AADD(aCampos,{ "QTDPALL"  ,"N",11,4 } )	
	AADD(aCampos,{ "TOTPALL"  ,"N",17,2 } )

	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB1", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB1",cNomArq,"PEDIDO+GRUEMB+PROD",,,OemToAnsi("Selecionando Registros..."))	//

	aCampos := {} 

	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )
	AADD(aCampos,{ "PROD"    ,"C",15,0 } )
	AADD(aCampos,{ "DESC"    ,"C",50,0 } )	
	AADD(aCampos,{ "DTCARRE" ,"D", 8,0 } )
	AADD(aCampos,{ "EMIROM"  ,"D", 8,0 } )	
	AADD(aCampos,{ "TPCARRO" ,"C", 1,0 } )
	AADD(aCampos,{ "TIPOVEI" ,"C", 2,0 } )	
	AADD(aCampos,{ "TRANSP"  ,"C", 6,0 } )			
	AADD(aCampos,{ "GRUEMB"  ,"C", 2,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,4 } )
	AADD(aCampos,{ "PESO"    ,"N",11,4 } )	
	AADD(aCampos,{ "QTDPALL" ,"N",11,4 } )	
	AADD(aCampos,{ "TOTPALL" ,"N",17,2 } )

	If Select("RES") > 0
		RES->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"RES", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("RES",cNomArq,"ROMANEI+PROD+GRUEMB",,,OemToAnsi("Selecionando Registros..."))	//


	For nEmp := 1 to Len(aEmp)

		cArq   := "sx2"+aEmp[nEmp]+"0"
		cAliasROM := "sx2ROM"

		cPath := GetSrvProfString("Startpath","")
		cArq := cPath+cArq

		//Faco a abertura do SX2 da empresa que ira gerar o arquivo de trabalho
		Use  &(cArq ) alias &(cAliasROM) New

		If Select( cAliasROM ) == 0
			MsgAlert("Arquivo nao foi aberto..."+cArq)
			Return
		Else
			DbSetIndex( cArq )
		EndIf

		For nArq := 1 to Len(aArq)

			DbSelectArea( cAliasROM )
			DbSeek( aArq[nArq,1] )

			aArq[nArq,2] := (cAliasROM)->x2_arquivo

		Next

		If nEmp >  1
			cQuery += " Union All "
		Else
			cQuery := " "
		EndIf

		/*
		cQuery += " SELECT	'"+aEmp[nEmp]+"' EMPRESA, SC9.C9_PEDIDO,  SC9.C9_ITEM, SC9.C9_TRAROM, SC9.C9_ROMANEI,SC9.C9_VEICULO, "
		cQuery += " 		SC9.C9_QTDLIB, SC9.C9_PRODUTO,SC9.C9_PRCVEN, SC9.C9_TIPOVEI,  "
		cQuery += "         SC9.C9_ORDCARG,SC9.C9_DTCARRE,SC9.C9_TPCARRO, SC9.C9_EMIROM, " 
		cQuery += " 		SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_FECENT,  SC5.C5_ZZTIPO, SC5.C5_ZZPEDCL, SC5.C5_TPFRETE, " 

		cQuery += "         SA1.A1_NOME, SA1.A1_EST, SA1.A1_MUN, SA1.A1_TIPO, SA1.A1_END,SA1.A1_NREDUZ,SA1.A1_BAIRRO,SA1.A1_ZZOBSER, "
		cQuery += "         SB1.B1_PESBRU, SB1.B1_DESC,SB1.B1_GRUEMB,SB1.B1_QTDPALL "

		cQuery += " FROM   "+aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9  "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5 ON   "
		cQuery += "                       SC5.D_E_L_E_T_ <> '*' AND SC5.C5_ROMANEI <> ' ' "
		cQuery += "                       AND SC9.C9_PEDIDO  = SC5.C5_NUM "
		cQuery += " 			        AND SC5.C5_ROMANEI BETWEEN  '"+cRomIni+"' AND '"+cRomFim+"' "

		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON   "
		cQuery += "                       SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "                       SB1.B1_COD = SC9.C9_PRODUTO "

		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
		cQuery += "                       SA1.D_E_L_E_T_ <> '*' AND  "
		cQuery += "                       SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "

		cQuery += "                       WHERE SC9.D_E_L_E_T_ <> '*' AND  "
		cQuery += " 					  SC9.C9_EMIROM BETWEEN  '"+Dtos(dDataIni)+"' AND '"+Dtos(dDataFim)+"' "
		cQuery += " 					  AND SC9.C9_DTCARRE BETWEEN  '"+Dtos(dDtCarIn)+"' AND '"+Dtos(dDtCarFi)+"' "		

		//		cQuery += " 			        AND SC5.C5_ROMANEI BETWEEN  '"+cRomIni+"' AND '"+cRomFim+"' "

		/*/

		cQuery += " SELECT	'"+aEmp[nEmp]+"' EMPRESA, SC9.C9_PEDIDO,  SC9.C9_ITEM, SC9.C9_TRAROM, SC9.C9_ROMANEI,SC9.C9_VEICULO, "
		cQuery += " 		SC9.C9_QTDLIB, SC9.C9_PRODUTO,SC9.C9_PRCVEN, SC9.C9_TIPOVEI,  "
		cQuery += "         SC9.C9_ORDCARG,SC9.C9_DTCARRE,SC9.C9_TPCARRO, SC9.C9_EMIROM, " 
		cQuery += " 		SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_FECENT,  SC5.C5_ZZTIPO, SC5.C5_ZZPEDCL, SC5.C5_TPFRETE, " 
		cQuery += " 		SC5.C5_DTAGEN, SC5.C5_HRAGEN,SC5.C5_DTAGEN1, SC5.C5_HRAGEN2,SC5.C5_DTAGEN2, SC5.C5_HRAGEN3,SC5.C5_MENNOTA,  "		

		cQuery += "         SA1.A1_NOME, SA1.A1_EST, SA1.A1_MUN, SA1.A1_TIPO, SA1.A1_END,SA1.A1_NREDUZ,SA1.A1_BAIRRO,SA1.A1_ZZOBSER, "
		cQuery += "         SB1.B1_PESBRU, SB1.B1_DESC,SB1.B1_GRUEMB,SB1.B1_QTDPALL "

		cQuery += " FROM   "+aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5  "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9 ON   "
		cQuery += "                       SC9.D_E_L_E_T_ <> '*' AND SC5.C5_ROMANEI <> ' ' "
		cQuery += "                       AND SC9.C9_PEDIDO  = SC5.C5_NUM AND SC5.C5_ROMANEI = SC9.C9_ROMANEI "
		cQuery += " 					  AND SC9.C9_EMIROM BETWEEN  '"+Dtos(dDataIni)+"' AND '"+Dtos(dDataFim)+"' "
		cQuery += " 					  AND SC9.C9_DTCARRE BETWEEN  '"+Dtos(dDtCarIn)+"' AND '"+Dtos(dDtCarFi)+"' "		

		//		cQuery += " 			        AND SC5.C5_ROMANEI BETWEEN  '"+cRomIni+"' AND '"+cRomFim+"' "

		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON   "
		cQuery += "                       SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "                       SB1.B1_COD = SC9.C9_PRODUTO "

		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
		cQuery += "                       SA1.D_E_L_E_T_ <> '*' AND  "
		cQuery += "                       SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "

		cQuery += "                       WHERE SC5.D_E_L_E_T_ <> '*' AND  "
		cQuery += " 			          SC5.C5_ROMANEI BETWEEN  '"+cRomIni+"' AND '"+cRomFim+"' "


		(cAliasROM)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C5_EMISSAO","D")
	TCSetField("QRY","C5_FECENT","D")
	TCSetField("QRY","C5_DTAGEN","D")
	TCSetField("QRY","C5_DTAGEN1","D")
	TCSetField("QRY","C5_DTAGEN2","D")		
	TCSetField("QRY","C9_DTCARRE","D")
	TCSetField("QRY","C9_EMIROM","D")		

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGoTop()

	While QRY->(!Eof()) 

		If Empty(QRY->B1_GRUEMB)
			QRY->(DbSkip())
			Loop
		EndIf 

		SA7->(DbSetOrder(1))
		If SA7->(DbSeek(xFilial("SA7")+QRY->C5_CLIENTE+QRY->C5_LOJACLI+QRY->C9_PRODUTO ))
			nCxPalle := SA7->A7_QTDPALE
		Else
			nCxPalle := QRY->B1_QTDPALL
		EndIf

		DbSelectArea("TRB1")
		If ! DbSeek(QRY->C9_PEDIDO+QRY->B1_GRUEMB )
			RecLock("TRB1",.T.)
			TRB1->PEDIDO := QRY->C9_PEDIDO 
			TRB1->GRUEMB := QRY->B1_GRUEMB
			TRB1->PROD   := QRY->C9_PRODUTO 
			TRB1->QTDPALL:= nCxPalle //QRY->B1_QTDPALL 
			TRB1->QUANT  := QRY->C9_QTDLIB 
			MsUnlock()
		Else
			RecLock("TRB1",.F.)
			TRB1->QUANT  += QRY->C9_QTDLIB 
			MsUnlock()

		EndIf  
		DbSelectArea("QRY")
		DbSkip()

	End

	DbSelectArea("TRB1")
	DbGoTop()

	While TRB1->(!Eof()) 

		RecLock("TRB1",.F.)
		TRB1->TOTPALL := Int( TRB1->QUANT  / TRB1->QTDPALL  )

		nResto := ( TRB1->QUANT  / TRB1->QTDPALL  ) - Int( TRB1->QUANT  / TRB1->QTDPALL  )

		If nResto > 0.00
			TRB1->TOTPALL += 1		
		EndIf  		  
		MsUnlock()

		DbSkip()

	End

	DbSelectArea("QRY")
	DbGoTop()

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Gerando as selecao de Pedido de vendas...")

		nTotPalle := 0

		DbSelectArea("TRB1")

		If DbSeek(QRY->C9_PEDIDO+QRY->B1_GRUEMB+QRY->C9_PRODUTO)

			nTotPalle := TRB1->TOTPALL 

		EndIf 

		cTpPed := " "
		If QRY->C5_ZZTIPO == "N"
			cTpPed := "Normal"
		ElseIf QRY->C5_ZZTIPO == "F"
			cTpPed := "Bonificacao"		
		ElseIf QRY->C5_ZZTIPO == "X"
			cTpPed := "Bonif. Tabl"
		ElseIf QRY->C5_ZZTIPO == "R"
			cTpPed := "Troca"
		ElseIf QRY->C5_ZZTIPO == "L"
			cTpPed := "Pallet"
		EndIf    		

		DbSelectArea("ZZQ")
		DbSetOrder(1)
		DbSeek(xFilial("ZZQ")+QRY->C9_ROMANEI)

		/*        If ZZQ->ZZQ_STATUS $ "B"
		DbSelectArea("QRY")
		DbSkip()
		Loop 
		EndIf  */ 

		DbSelectArea("ROM")
		If !DbSeek(QRY->C9_ROMANEI+QRY->C9_ORDCARG+QRY->C9_PEDIDO+QRY->C9_ITEM )
			RecLock("ROM",.T.)
			ROM->PROD    := QRY->C9_PRODUTO
			ROM->DESC    := Alltrim(QRY->B1_DESC)
			ROM->PEDIDO  := QRY->C9_PEDIDO
			ROM->CLIENTE := QRY->C5_CLIENTE
			ROM->LOJA    := QRY->C5_LOJACLI
			ROM->NOME    := QRY->A1_NOME 
			ROM->EMISSAO := QRY->C5_EMISSAO
			ROM->DTENT   := QRY->C5_FECENT
			ROM->QUANT   := QRY->C9_QTDLIB
			ROM->QTDCX   := QRY->C9_QTDLIB
			ROM->PESO    := ROM->QUANT * QRY->B1_PESBRU
			ROM->TRANSP  := QRY->C9_TRAROM
			ROM->EST     := QRY->A1_EST
			ROM->MUN     := QRY->A1_MUN
			ROM->ROMANEI := QRY->C9_ROMANEI
			ROM->TPFRERO := QRY->C5_TPFRETE 
			ROM->ORDCARG := QRY->C9_ORDCARG
			ROM->ESTENT  := QRY->A1_EST
			ROM->MUNENT  := QRY->A1_MUN   
			ROM->BAIENT  := QRY->A1_BAIRRO
			ROM->ENDENT  := QRY->A1_END   
			ROM->ITEM    := QRY->C9_ITEM
			ROM->OBSEXT  := Alltrim(QRY->A1_ZZOBSER)+" "+Alltrim(QRY->C5_MENNOTA) 
			ROM->DTCARRE := QRY->C9_DTCARRE
			ROM->PEDCLI  := QRY->C5_ZZPEDCL 
			nNomEmp  :=  Ascan(aEmp,QRY->EMPRESA)
			ROM->NOMEMP  := aNomEmp[nNomEmp]  
			ROM->TPCARRO := QRY->C9_TPCARRO
			ROM->TPVEIC  := QRY->C9_TIPOVEI
			ROM->PALLET  := QRY->B1_QTDPALL
			ROM->QTDPALL := nTotPalle  
			ROM->EMIROM  := QRY->C9_EMIROM
			ROM->DTAGEN  := QRY->C5_DTAGEN 
			ROM->HRAGEN  := QRY->C5_HRAGEN

			cDtHrAgen    := Space(10)
			If !Empty(QRY->C5_DTAGEN2)

				ROM->DTAGEN  := QRY->C5_DTAGEN2 
				ROM->HRAGEN  := QRY->C5_HRAGEN3
				cDtHrAgen := " "+Dtoc(QRY->C5_DTAGEN2)+" Hora: "+QRY->C5_HRAGEN3
			ElseIf !Empty(QRY->C5_DTAGEN1)   

				cDtHrAgen := " "+Dtoc(QRY->C5_DTAGEN1)+" Hora: "+QRY->C5_HRAGEN2
				ROM->DTAGEN  := QRY->C5_DTAGEN1 
				ROM->HRAGEN  := QRY->C5_HRAGEN2

			ElseIf !Empty(QRY->C5_DTAGEN) 
				ROM->DTAGEN  := QRY->C5_DTAGEN 
				ROM->HRAGEN  := QRY->C5_HRAGEN

				cDtHrAgen := " "+Dtoc(QRY->C5_DTAGEN)+" Hora: "+QRY->C5_HRAGEN
			EndIf    
			ROM->OBSINT  := cDtHrAgen
			ROM->TPPED   := cTpPed 
			MsUnlock()

		EndIf 
		//Faz o resumo dos produtos

		If QRY->C5_ZZTIPO # "L"        
			DbSelectArea("RES")
			If !DbSeek(QRY->C9_ROMANEI+QRY->C9_PRODUTO+QRY->B1_GRUEMB)
				RecLock("RES",.T.)
				RES->ROMANEI := QRY->C9_ROMANEI
				RES->PROD    := QRY->C9_PRODUTO
				RES->DESC    := QRY->B1_DESC 
				RES->GRUEMB  := QRY->B1_GRUEMB 
				RES->DTCARRE := QRY->C9_DTCARRE
				RES->EMIROM  := QRY->C9_EMIROM
				RES->TPCARRO := QRY->C9_TPCARRO
				RES->TIPOVEI := QRY->C9_TIPOVEI			
				RES->TRANSP  := QRY->C9_TRAROM
				RES->QUANT  := QRY->C9_QTDLIB
				RES->PESO   := QRY->C9_QTDLIB  * QRY->B1_PESBRU
				RES->QTDPALL:= QRY->B1_QTDPALL
				RES->TOTPALL:= nTotPalle 
				MsUnlock()
			Else
				RecLock("RES",.F.)
				RES->QUANT   += QRY->C9_QTDLIB
				RES->PESO    += QRY->C9_QTDLIB * QRY->B1_PESBRU
				RES->TOTPALL += nTotPalle 
				MsUnlock()

			EndIf
		EndIf 

		DbSelectArea("QRY")
		DbSkip()

	End

	/*
	DbSelectArea("RES")
	DbGoTop()

	While RES->(!Eof())

	RecLock("RES",.F.)
	RES->TOTPALL := Int( RES->QUANT  / RES->QTDPALL ) 

	nResto := (RES->QUANT /RES->QTDPALL) - Int( RES->QUANT  / RES->QTDPALL )
	If nResto > 0.00
	RES->TOTPALL += 1 
	EndIf 

	MsUnlock()
	DbSkip()

	End
	*/ 
	QRY->(DbCloseArea())

	Processa({||U_ImpRoma()},"Imprimindo o Romaneio...")

	ROM->(DbCloseArea())
	RES->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³Microsiga           º Data ³  10/29/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Checa o intervalo de romaneio                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkRomaneio(cRomaneio,oSay)
	Local lRet := .t.

	If !Empty(cRomaneio)

		cRomaneio := StrZero(Val(cRomaneio),6)


	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpResRom ºAutor  ³Carlos R Moreira	 º Data ³  11/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira imprimir o Resumo do romaneio                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpResRom(oPrn,cRomaneio,dDtCarre,cTpCarRo)

	nTotPeso  := nPesoPed := nTotCxs := nVolPed := nTotPall := 0

	DbSelectArea("RES")

	If Empty(cRomaneio)

		For nRom := 1 to 2 

			DbGotop()

			ProcRegua(RecCount())        // Total de Elementos da regua

			While RES->(!EOF())

				lFirst := .T.
				nPag   := 0
				nLin   := 490

				cRomaneio := RES->ROMANEI 

				dDtCarre  := RES->DTCARRE
				cTpCarRo  := RES->TPCARRO
				cTraRom   := RES->TRANSP
				cTIpOVei  := RES->TIPOVEI 
				dDtEmi    := RES->EMIROM

				If nRom == 2 
					nTotPeso  := nPesoPed := nTotCxs := nVolPed := nTotPall := 0
				EndIf 

				While RES->(!Eof()) .And. cRomaneio == RES->ROMANEI

					IncProc("Imprimindo o resumo Romaneio...")

					If lFirst
						oPrn:StartPage()
						cTitulo := "Resumo Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(dDtEmi)+If(nRom==1," Espelho Cego"," ")
						cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")   
						aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
						nPag++
						U_CabRel(aTit,2,oPrn,nPag,"")
						CabCons(oPrn,1)

						lFirst = .F.

					EndIf

					oPrn:Box(nLin,100,nLin+60,2300)

					oPrn:line(nLin, 350,nLin+60, 350)

					oPrn:line(nLin,1600,nLin+60,1600)

					oPrn:line(nLin,1800,nLin+60,1800)

					oPrn:line(nLin,2000,nLin+60,2000)

					oPrn:line(nLin,2250,nLin+60,2250)

					oPrn:Say(nLin+15,  110,RES->PROD    ,oArialNeg07,100)
					oPrn:Say(nLin+15,  360,RES->DESC    ,oFont9,100)

					If nRom == 2 
						If cTpCarro == "2"  
							oPrn:Say(nLin+15, 1610,Transform(RES->TOTPALL  ,"@e 99,999,999") ,oFont5,100)
						EndIf 
						oPrn:Say(nLin+15, 1810,Transform(RES->QUANT   ,"@e 99,999,999") ,oFont5,100)
						oPrn:Say(nLin+15, 2070,Transform(RES->PESO    ,"@e 99,999,999") ,oFont5,100)
					EndIf 

					If nRom == 2 
						nTotPeso  += RES->PESO
						nPesoPed  += RES->PESO
						nTotCxs   += RES->QUANT 
						nVolPed   += RES->QUANT
						nTotPall  += RES->TOTPALL 
					EndIf 
					nLin += 60

					If nLin > 3100
						oPrn:EndPage()
						lFirst := .T.
					EndIf

					DbSelectArea("RES")
					DbSkip()

				End 

				nLin += 20

				If nLin > 3100 //.Or. lFirst 

					If !lFirst 
						oPrn:EndPage()
					EndIf   

					oPrn:StartPage()
					cTitulo := "Romaneio N. "+cRomaneio+" - Dt. Geração: "+Dtoc(ROM->EMISSAO)+If(nRom==1," Espelho Cego"," ")
					cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")
					aTit    := {cTitulo,SM0->M0_NOMECOM,cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"")
					CabCons(oPrn,1)
					lFirst := .F. 

				EndIf

				If nTotCxs > 0

					oPrn:Box(nLin,100,nLin+60,2300)

					oPrn:line(nLin,1600,nLin+60,1600)
					oPrn:line(nLin,1800,nLin+60,1800)				
					oPrn:line(nLin,2000,nLin+60,2000)

					oPrn:Say(nLin+15, 180,"Total Geral ... ....: " ,oFont5,100)

					If nRom == 2 
						If cTpCarro == "2"
							oPrn:Say(nLin+15, 1610,Transform(nTotPall ,"@e 99,999,999") ,oFont5,100)
						EndIf 
						oPrn:Say(nLin+15, 1810,Transform(nTotCxs  ,"@e 99,999,999") ,oFont5,100)
						oPrn:Say(nLin+15, 2120,Transform(nTotPeso ,"@e 99,999,999") ,oFont5,100)
					EndIf 
				EndIf

				cAjudante := Space(6)

				nLin := 3100
				oPrn:Box(nLin,100,nLin+200,2300)

				oPrn:Line(nLin,1150,nLin+200,1150)

				oPrn:Say( nLin+5,  120, "Motorista" ,oFont9,100 )

				oPrn:Say( nLin+5,  1170, "Conferente / Data / Hora" ,oFont9,100 )
				oPrn:Say( 3320,  120, "Via Interna" ,oFont9,100 )


				oPrn:EndPage()

			End

		Next 

	Else

		DbSelectArea("RES")

		For nRom := 1 to 2 

			DbSeek(cRomaneio)

			ProcRegua(RecCount())        // Total de Elementos da regua

			lFirst := .T.
			nPag   := 0
			nLin   := 490

			While RES->(!EOF()) .And. RES->ROMANEI == cRomaneio 

				IncProc("Imprimindo o resumo Romaneio...")

				If lFirst
					oPrn:StartPage()
					cTitulo := "Resumo Romaneio N. "+cRomaneio+If(nRom==1," Espelho Cego"," ")
					cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")   
					aTit    := {cTitulo,Substr(SM0->M0_NOMECOM,1,30),cRod}
					nPag++
					U_CabRel(aTit,2,oPrn,nPag,"")
					CabCons(oPrn,1)

					lFirst = .F.

				EndIf

				oPrn:Box(nLin,100,nLin+60,2300)

				oPrn:line(nLin, 350,nLin+60, 350)

				oPrn:line(nLin,1600,nLin+60,1600)

				oPrn:line(nLin,1800,nLin+60,1800)

				oPrn:line(nLin,2000,nLin+60,2000)

				oPrn:line(nLin,2250,nLin+60,2250)

				oPrn:Say(nLin+15,  110,RES->PROD    ,oArialNeg07,100)
				oPrn:Say(nLin+15,  360,RES->DESC    ,oFont9,100)

				If nRom == 2  
					If cTpCarro == "2"  
						oPrn:Say(nLin+15, 1610,Transform(RES->TOTPALL  ,"@e 99,999,999") ,oFont5,100)
					EndIf 
					oPrn:Say(nLin+15, 1810,Transform(RES->QUANT   ,"@e 99,999,999") ,oFont5,100)
					oPrn:Say(nLin+15, 2070,Transform(RES->PESO    ,"@e 99,999,999") ,oFont5,100)
				EndIf 

				If nRom == 2 
					nTotPeso  += RES->PESO
					nPesoPed  += RES->PESO
					nTotCxs   += RES->QUANT 
					nVolPed   += RES->QUANT
					nTotPall  += RES->TOTPALL 
				EndIf 
				nLin += 60

				If nLin > 3100
					oPrn:EndPage()
					lFirst := .T.
				EndIf

				DbSelectArea("RES")
				DbSkip()

			End

			nLin += 20

			If nLin > 3100 //.Or. lFirst 

				If !lFirst 
					oPrn:EndPage()
				EndIf   

				oPrn:StartPage()
				cTitulo := "Romaneio N. "+cRomaneio
				cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")
				aTit    := {cTitulo,SM0->M0_NOMECOM,cRod}
				nPag++
				U_CabRel(aTit,2,oPrn,nPag,"")
				CabCons(oPrn,1)
				lFirst := .F. 

			EndIf

			If nTotCxs > 0

				oPrn:Box(nLin,100,nLin+60,2300)

				oPrn:line(nLin,1600,nLin+60,1600)
				oPrn:line(nLin,1800,nLin+60,1800)				
				oPrn:line(nLin,2000,nLin+60,2000)

				oPrn:Say(nLin+15, 180,"Total Geral ... ....: " ,oFont5,100)

				If nRom == 2 
					If cTpCarro == "2"
						oPrn:Say(nLin+15, 1610,Transform(nTotPall ,"@e 99,999,999") ,oFont5,100)
					EndIf 
					oPrn:Say(nLin+15, 1810,Transform(nTotCxs  ,"@e 99,999,999") ,oFont5,100)
					oPrn:Say(nLin+15, 2120,Transform(nTotPeso ,"@e 99,999,999") ,oFont5,100)
				EndIf 

			EndIf

			cAjudante := Space(6)

			nLin := 3100
			oPrn:Box(nLin,100,nLin+200,2300)

			oPrn:Line(nLin,1150,nLin+200,1150)

			oPrn:Say( nLin+5,  120, "Motorista" ,oFont9,100 )

			oPrn:Say( nLin+5,  1170, "Conferente / Data / Hora" ,oFont9,100 )
			oPrn:Say( 3320,  120, "Via Interna" ,oFont9,100 )


			oPrn:EndPage()

		Next 

	EndIf 


Return 