/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto Entr³ SF2460I  ³ Siga                          ³ Data ³ 01/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada da preparacao da nota fiscal para gravar  ³±±
±±³          ³ o Banco no E1_ZZPORT                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sobel                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function SF2460I()

	Private cPerg:= "ZSF2460I  "

	_aArea := GetArea()

	//	ValidPerg()

	If Pergunte(cPerg,.F.) 

		If RecLock("SF2",.F.)
			SF2->F2_ZZDTSAI := dDatabase //mv_par01
			SF2->F2_VEICUL2 := " " //mv_par02
			MsUnlock()
		Endif

	EndIf 
	/*
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)

	While !Eof() .and. SE1->E1_NUM == SF2->F2_DOC .and. SE1->E1_PREFIXO == SF2->F2_SERIE

	If RecLock("SE1",.F.)
	SE1->E1_ZZPORT := mv_par01
	SE1->E1_ZZAGE  := mv_par02
	SE1->E1_ZZCONT := mv_par03
	MsUnlock()
	Endif
	DbSkip()

	Enddo
	Endif
	*/
	//Ira alimentar o campo F2_ZZTIPO - feito 2wptech 

	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE ))

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))
	RecLock("SC5",.F.)
	SC5->C5_STAPED  := "F"
	MsUnlock()

	cEmpFat := SM0->M0_CODIGO 

	cRomaneio := SC5->C5_ROMANEI 

	If !Empty(cRomaneio)

		DbSelectArea("ZZR")
		DbSetOrder(2)
		If DbSeek(xFilial("ZZR")+cEmpFat+SD2->D2_PEDIDO )

			RecLock("ZZR",.F.)
			ZZR->ZZR_STAFAT  := "F"
			ZZR->ZZR_NOTA    := SF2->F2_DOC 
			ZZR->ZZR_EMISNF  := SF2->F2_EMISSAO 
			MsUnlock()

		EndIf 

		//Verifica se o romaneio ja finalizou o faturamento

		DbSelectArea("ZZR")
		DbSetOrder(1)
		DbSeek(xFilial("ZZR")+cRomaneio )

		ProcRegua(RecCount())

		While ZZR->(!Eof()) .And. cRomaneio == ZZR->ZZR_ROMANE 

			If ZZR->ZZR_STAFAT # "F"
				lFatRom := .F. 
				Exit 
			EndIf 

			lFatRom := .T. 

			DbSkip() 
		End

		If lFatRom 
			DbSelectArea("ZZQ")
			DbSetOrder(1)
			If DbSeek(xFilial("ZZQ")+cRomaneio)
			   RecLock("ZZQ",.F.)
			   ZZQ->ZZQ_STATUS := "F"
			   MsUnlock()    
			EndIf 
		EndIf 

	EndIf 

	DbSelectArea("SC9")
	DbSetOrder(1)
	SC9->(DbSeek(xFilial("SC9")+SD2->D2_PEDIDO ))

	DbSelectArea("SF2")
	RecLock("SF2",.F.)
	SF2->F2_ZZTIPO  := SC5->C5_ZZTIPO
	SF2->F2_ROMANEI := SC9->C9_ROMANEI
	SF2->(MsUnLock())

	RestArea(_aArea)

Return

//
Static Function ValidPerg

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Banco              ?","","","mv_ch1","C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","Z61",""})
	aAdd(aRegs,{cPerg,"02","Agencia            ?","","","mv_ch2","C", 5,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Conta Corrente     ?","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Data Saida NF      ?","","","mv_ch4","D", 8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Num. Conhecimento  ?","","","mv_ch5","C",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)
Return
