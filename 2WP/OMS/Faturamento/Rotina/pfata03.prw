#include "rwmake.ch"
#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA03   ºAutor  ³Carlos R. Moreira   º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os Pedidos com Bloqueio de Margem                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA03()

	aIndexSC5  := {}

	If !ExisteSX6("MV_LIBMAR")
		CriarSX6("MV_LIBMAR","C","Guarda os usuarios que possuem autorizaçaõ de liberacao comercial","000000")
	EndIf

	cUserLib := Alltrim(GetMV("MV_LIBMAR"))

	If ! __cUserID $ cUserLib
		MsgStop("Usuario nao autorizado a liberar as Margens dos pedidos de vendas.")
		Return 
	EndIf  

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Visualizar","A410Visual" , 0 , 1},;
	{ "Liberar"   ,"U_PFATA03A" , 0 , 2} }

	PRIVATE bFiltraBrw := {|| Nil}

	Private cCadastro := OemToAnsi("Liberação de Margem")

	cFiltraSC5 := "C5_STAPED = 'M' " //.And. C5_OPER # '04'
	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SC5") //,,,,,,aCores)//,,"C5_LIBEROK"
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

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³Microsiga           º Data ³  12/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFATA03A()
	Local oDlg2
	Private nRadio := 1
	Private oRadio
	Private cMotivo := Space(40)

	cUser := RetCodUsr()

	nOpca := 0

	While .T.

		DEFINE MSDIALOG oDlg2 TITLE "Liberacao de Margem" From 9,0 To 22,60 OF oMainWnd

		@ 05,05 TO 70, 80 TITLE "Liberar"
		@ 20,30 RADIO oRadio Var nRadio Items "Sim","Nao" 3D SIZE 60,10 of oDlg2 Pixel

		@ 05,85 TO 70,235 TITLE "Motivo"
		@ 23,90 MSGet cMotivo  Size 100 ,10 Valid !Empty(cMotivo) of oDlg2 Pixel

		@ 082,200 BMPBUTTON TYPE 1 ACTION Close(oDlg2)

		ACTIVATE DIALOG oDlg2 CENTER


		If Empty(cMotivo) .And. nRadio == 2
			Loop
		Else
			nOpca := 1
			Exit
		EndIf

	End

	If nOpca == 1

		DbSelectArea("SC5")
		RecLock("SC5",.F.)

		SC5->C5_STAPED := If(nRadio==1,"L","S")

		SC5->C5_MOTIVO := cMotivo
		SC5->C5_USLIBM := cUser
		SC5->C5_NOLIBM := Substr(cUsuario,7,15)
		SC5->C5_DTLIBM   := Date()
		SC5->C5_HRLIBM   := Time()
		MsUnlock()

		If SC5->C5_STAPED # "S"

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

			If SA1->A1_RISCO # "A" //.Or. SC5->C5_CONDPAG == "001"
				U_LibPed(SC5->C5_NUM)
			EndIf

			If !SC5->C5_STAPED $ "C"

				If !Empty(SC5->C5_PEDBON)


					cPedVen := SC5->C5_PEDBON

					// Atualiza o Status do pedido de Bonificacao
					//-------------------------------------------------------------------------------------
					cQuery := " UPDATE " + retsqlname("SC5") + " SET C5_STAPED='L' , C5_USLIBM = '"+cUser+"',  "
					cQuery += " C5_NOLIBM = '"+Substr(cUsuario,7,15)+"'  " //, C5_HRLIBC = '"+Time()+"' "  //C5_DTLIBC = '"+Dtos(Date())+"', C
					cQuery += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedVen  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

					If (TCSQLExec(cQuery) < 0)
						Return MsgStop("Falha na atualizacao do Status do Pedido "+ cPedVen + ".  TCSQLError:"+ TCSQLError())
					EndIf

				EndIf
			EndIf
		EndIf

	EndIf
Return
