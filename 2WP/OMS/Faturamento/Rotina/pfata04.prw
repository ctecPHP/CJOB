#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA04   ºAutor  ³Carlos R. Moreira   º Data ³  08/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera os campos no Pedido de Venda                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA04()

	aIndexSC5  := {}

	PRIVATE bFiltraBrw := {|| Nil}

	Private cCadastro := OemToAnsi("Liberação Adm Ped Venda")

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Visualizar","A410Visual" , 0 , 1},;
	{"Atu. Agenda","u_PFATA04A", 0 , 2 , 0 , NIL},;	//
	{"Legenda","A410Legend", 0 , 0 , 0 , .F.}}		//

	aRegs := {}
	cPerg := "PFATA04"

	aAdd(aRegs,{cPerg,"01","Filtrar somentes      ?","","","mv_ch1","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR01","Sem Agendamento"  ,"","","","","Agendados","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"02","Filtrar faturados     ?","","","mv_ch2","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR02","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
	
	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.T.)

	//Ira checar se o usuario tem permissao para digitacao do Inventario
	Private cCodUsu := __cuserid

	Private cCadastro := OemToAnsi("Acerta a Data de Agendamento")

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

	If MV_PAR01 == 1 
		cFiltraSC5 := "C5_REQAGEN = 'S' .And. EMPTY(C5_DTAGEN) .And. C5_STAPED $ 'A' .AND. C5_ZZTIPO $ 'N,F'" 
	Else
	    If MV_PAR02 == 1 
   		   cFiltraSC5 := "C5_REQAGEN = 'S' .And. !EMPTY(C5_DTAGEN) .And. C5_STAPED $ 'L,D,T'.AND. C5_ZZTIPO $ 'N,F'"
	    Else
		   cFiltraSC5 := "C5_REQAGEN = 'S' .And. !EMPTY(C5_DTAGEN) .And. C5_STAPED $ 'L,D,T,F'.AND. C5_ZZTIPO $ 'N,F'"
		EndIf 
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

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA04A  ºAutor  ³Microsiga           º Data ³  02/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA04A(cAlias,nReg,nOpcx)
	LOCAL nCnt,nSavRec
	Local oDlg

	nSavRec := SC5->(Recno())

	If SC5->C5_STAPED $ "F"
		If ! MsgYesNo("Pedido ja possui faturamento. deseja realmente reagendar..")
			Return
		EndIf     
	EndIf

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	If SA1->A1_REQAGEN # "S" .And. SC5->C5_TPFRETE # "F"
		MsgStop("Cliente não necessita de agendamento.")
		Return 
	EndIf 

    nRecno := SC5->(Recno())
    If !Empty(Alltrim(SC5->C5_PEDBON))
    
       cPedBon := Alltrim(SC5->C5_PEDBON)
       
       DbSelectArea("SC5")
       DbSetOrder(1)
       If DbSeek(xFilial('SC5')+cPedBon )
          If SC5->C5_STAPED == "S"
             MsgStop("Pedido de Venda com bonificacao bloqueada comercialmente.")
             SC5->(DbGoto(nRecno))
             Return 
          EndIf 
       EndIf 
         
    EndIf 
    
    SC5->(DbGoto(nRecno))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a entrada de dados do arquivo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMenNota    := SC5->C5_MENNOTA
	dDtAgen     := SC5->C5_DTAGEN
	dDtAgen1    := SC5->C5_DTAGEN1
	dDtAgen2    := SC5->C5_DTAGEN2
	lPriAgen    := Empty(SC5->C5_DTAGEN)
	lSegAgen    := !Empty(SC5->C5_DTAGEN) .And. Empty(SC5->C5_DTAGEN1)
	lTerAgen    := !Empty(SC5->C5_DTAGEN1) .And. Empty(SC5->C5_DTAGEN2)
	cHrAgen     := SC5->C5_HRAGEN
	cHrAgen2    := SC5->C5_HRAGEN2
	cHrAgen3    := SC5->C5_HRAGEN3
	cMotAgen2   := Space(2)
	cMotAgen3   := Space(2)

	cCliente     := SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+"-"+Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")

	nOpca:=0
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Acerta o Pedido "+SC5->C5_NUM) From 9,0 To 35,80 OF oMainWnd

	oGrp1 := TGROUP():Create(oDlg)
	oGrp1:cName := "oGrp1"
	oGrp1:cCaption := "Cliente "
	oGrp1:nLeft := 19
	oGrp1:nTop := 80
	oGrp1:nWidth := 588
	oGrp1:nHeight := 47
	oGrp1:lShowHint := .F.
	oGrp1:lReadOnly := .F.
	oGrp1:Align := 0
	oGrp1:lVisibleControl := .T.


	oGrp3 := TGROUP():Create(oDlg)
	oGrp3:cName := "oGrp3"
	oGrp3:cCaption := "Data/Hora Agendamento 1 "
	oGrp3:nLeft := 19
	oGrp3:nTop := 130
	oGrp3:nWidth := 588
	oGrp3:nHeight := 47
	oGrp3:lShowHint := .F.
	oGrp3:lReadOnly := .F.
	oGrp3:Align := 0
	oGrp3:lVisibleControl := .T.

	oGrp4 := TGROUP():Create(oDlg)
	oGrp4:cName := "oGrp4"
	oGrp4:cCaption := "Data/Hora/Motivo Agendamento 2 "
	oGrp4:nLeft := 19
	oGrp4:nTop := 180
	oGrp4:nWidth := 588
	oGrp4:nHeight := 47
	oGrp4:lShowHint := .F.
	oGrp4:lReadOnly := .F.
	oGrp4:Align := 0
	oGrp4:lVisibleControl := .T.


	oGrp5 := TGROUP():Create(oDlg)
	oGrp5:cName := "oGrp5"
	oGrp5:cCaption := "Data/Hora/Motivo Agendamento 3 "
	oGrp5:nLeft := 19
	oGrp5:nTop := 230
	oGrp5:nWidth := 588
	oGrp5:nHeight := 47
	oGrp5:lShowHint := .F.
	oGrp5:lReadOnly := .F.
	oGrp5:Align := 0
	oGrp5:lVisibleControl := .T.

	oGrp2 := TGROUP():Create(oDlg)
	oGrp2:cName := "oGrp2"
	oGrp2:cCaption := "Mensagem"
	oGrp2:nLeft := 19
	oGrp2:nTop := 280
	oGrp2:nWidth := 588
	oGrp2:nHeight := 47
	oGrp2:lShowHint := .F.
	oGrp2:lReadOnly := .F.
	oGrp2:Align := 0
	oGrp2:lVisibleControl := .T.


	@  48 ,  40  MSGET cCliente WHEN .F. SIZE 225,08 Pixel of odlg

	@  74 ,  40  MSGET dDtAgen    SIZE 065,08 Valid ChkData(@dDtAgen) When lPriAgen Pixel of odlg

	@  74 ,  170  MSGET cHrAgen  Picture "@R 99:99"  Valid ChkHora(@cHrAgen) SIZE 045,08 When lPriAgen Pixel of odlg

	@  100 ,  40  MSGET dDtAgen1    SIZE 065,08 Valid ChkData(@dDtAgen1) When lSegAgen Pixel of odlg

	@  100 ,  130  MSGET cHrAgen2  Picture "@R 99:99" Valid ChkHora(@cHrAgen2) SIZE 045,08 When lSegAgen Pixel of odlg

	@  100 ,  210  MSGET cMotAgen2  F3 "Z7"  Valid !Empty(cMotAgen2) SIZE 045,08 When lSegAgen Pixel of odlg

	@  126 ,  40  MSGET dDtAgen2   SIZE 065,08 Valid ChkData(@dDtAgen2) When lTerAgen Pixel of odlg

	@  126 ,  130  MSGET cHrAgen3  Picture "@R 99:99"  Valid ChkHora(@cHrAgen3) SIZE 045,08 When lTerAgen Pixel of odlg

	@  126 ,  210  MSGET cMotAgen3  F3 "Z7" Valid !Empty(cMotAgen3)  SIZE 045,08 When lTerAgen Pixel of odlg

	@  150 ,  40  MSGET cMenNota   SIZE 225,08 Pixel of odlg	

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED
	IF nOpca == 1
		Begin Transaction
			PFATA04Grava(cAlias)
			EvalTrigger( )
		End Transaction
	Else
		MsUnlockAll( )
	End

	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da janela                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	Go nSavRec

Return nOpca

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PFATA01Grava³ Autor ³ Carlos R. Moreira     ³ Data ³ 05.06.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava as informacoes do Pedido de Venda                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PFATA04Grava(cAlias)

	dbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_MENNOTA := cMenNota

	If !Empty(dDtAgen) .Or. !Empty(dDtAgen1) .Or. !Empty(dDtAgen2)
		If Empty(SC5->C5_DTAGEN)
			SC5->C5_DTAGEN  := dDtAgen
			SC5->C5_FECENT  := dDtAgen
			SC5->C5_HRAGEN  := cHrAgen
			SC5->C5_STAPED  := "L" 

			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6")+SC5->C5_NUM )

			While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

				Reclock("SC6",.F.)
				SC6->C6_ENTREG := dDtAgen 
				MsUnlock()
				DbSkip()

			End

		EndIf
		If Empty(SC5->C5_DTAGEN1) .And. !Empty(dDtAgen1)
			SC5->C5_DTAGEN1  := dDtAgen1
			SC5->C5_FECENT   := dDtAgen1
			SC5->C5_HRAGEN2  := cHrAgen2
			//SC5->C5_STAPED  := "L"

			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6")+SC5->C5_NUM )

			While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

				Reclock("SC6",.F.)
				SC6->C6_ENTREG := dDtAgen1 
				MsUnlock()
				DbSkip()

			End

		EndIf

		If Empty(SC5->C5_DTAGEN2) .And. !Empty(dDtAgen2)
			SC5->C5_DTAGEN2  := dDtAgen2
			SC5->C5_FECENT   := dDtAgen2
			SC5->C5_HRAGEN3  := cHrAgen3
			//SC5->C5_STAPED  := "L"

			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6")+SC5->C5_NUM )

			While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

				Reclock("SC6",.F.)
				SC6->C6_ENTREG := dDtAgen2 
				MsUnlock()
				DbSkip()

			End

		EndIf


	EndIf
	MsUnlock()

	If !Empty(Alltrim(SC5->C5_PEDBON) )

		cPedBon := Alltrim(SC5->C5_PEDBON)
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial('SC5')+cPedBon )

		If SC5->C5_STAPED # "S"

			RecLock("SC5",.F.)
			SC5->C5_MENNOTA := cMenNota

			If !Empty(dDtAgen) .Or. !Empty(dDtAgen1) .Or. !Empty(dDtAgen2)
				If Empty(SC5->C5_DTAGEN)
					SC5->C5_DTAGEN  := dDtAgen
					SC5->C5_FECENT  := dDtAgen
					SC5->C5_HRAGEN  := cHrAgen
					SC5->C5_STAPED  := "L" 

					DbSelectArea("SC6")
					DbSetOrder(1)
					DbSeek(xFilial("SC6")+SC5->C5_NUM )

					While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

						Reclock("SC6",.F.)
						SC6->C6_ENTREG := dDtAgen 
						MsUnlock()
						DbSkip()

					End

				EndIf
				If Empty(SC5->C5_DTAGEN1) .And. !Empty(dDtAgen1)
					SC5->C5_DTAGEN1  := dDtAgen1
					SC5->C5_FECENT   := dDtAgen1
					SC5->C5_HRAGEN2  := cHrAgen2
					//SC5->C5_STAPED  := "L"

					DbSelectArea("SC6")
					DbSetOrder(1)
					DbSeek(xFilial("SC6")+SC5->C5_NUM )

					While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

						Reclock("SC6",.F.)
						SC6->C6_ENTREG := dDtAgen1 
						MsUnlock()
						DbSkip()

					End

				EndIf

				If Empty(SC5->C5_DTAGEN2) .And. !Empty(dDtAgen2)
					SC5->C5_DTAGEN2  := dDtAgen2
					SC5->C5_FECENT   := dDtAgen2
					SC5->C5_HRAGEN3  := cHrAgen3
					//SC5->C5_STAPED  := "L"

					DbSelectArea("SC6")
					DbSetOrder(1)
					DbSeek(xFilial("SC6")+SC5->C5_NUM )

					While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

						Reclock("SC6",.F.)
						SC6->C6_ENTREG := dDtAgen2 
						MsUnlock()
						DbSkip()

					End

				EndIf


			EndIf
			MsUnlock()

		EndIf  


	EndIf 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA04   ºAutor  ³Carlos R. Moreira   º Data ³  10/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a data de Agenda                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkData(dDataAgen)
	Local lRet := .T.

	If SC5->C5_TPFRETE = "F"
		nDias := 0
	Else
		nDias := DiasMeso()
	EndIf

	If dDataAgen < Date()
		MsgStop("Data nao pode ser menor que a Data Atual..")
		Return .F.
	EndIf

	If dDataAgen < ( Date() + nDias )
		MsgAlert("Data de Entrega não pode ser menor que o Lead Time")
		If !MsgYesNo("Tem certeza que deseja alterar a data")
			dDataAgen  := Date() + nDias
			lRet := .F.
		EndIf

	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA440COR  ºAutor  ³Microsiga           º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function DiasMeso()
	Local nDias := 0

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	nDiasLead := SA1->A1_LEADTIM

Return nDias

/*/

Checa hora do agendamento

/*/
Static Function ChkHora(cHrAgen)
	Local lRet := .T. 

	If Val(Substr(cHrAgen,1,2)) < 0 .Or. Val(Substr(cHrAgen,1,2)) > 24
		MsgStop("Hora invalida..")
		Return .F.
	EndIf 

	If Val(Substr(cHrAgen,1,2)) < 0 .Or. Val(Substr(cHrAgen,1,2)) > 24
		MsgStop("Hora invalida..")
		Return .F.   
	EndIf 

Return lRet 