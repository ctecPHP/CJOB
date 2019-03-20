#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPomsa02   บAutor  ณCarlos R. Moreira   บ Data ณ  06/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSolicita o Numero do Romaneio para Separacao da Carga       บฑฑ
ฑฑบ          ณpara efetuar a Exclusao do Romaneio                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Sobel                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function POMSA02()

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

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.",If(SM0->M0_CODIGO="01","02",""))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf 

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	Private cRomaneio

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	While .T.

		cRomaneio := Space(06)

		DEFINE MSDIALOG oDlg FROM  47,130 TO 250,400 TITLE OemToAnsi("Cancelamento de Romaneio") PIXEL

		@ 05, 04 TO 41,130 LABEL "Numero Romaneio " OF oDlg	PIXEL //

		@ 18, 17 MSGET oRomaneio VAR cRomaneio PICTURE "999999"  SIZE 70,14 FONT oFonte PIXEL;
		OF oDlg  VALID ChkRomaneio(@cRomaneio,oSay) COLOR CLR_HBLUE FONT oFonte RIGHT

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Botoes para confirmacao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		DEFINE SBUTTON FROM 77,  71 oButton1 TYPE 1 ENABLE OF oDlg ;
		ACTION {|| nOpca := 1, ExcRom(cRomaneio),oDlg:End()} PIXEL

		DEFINE SBUTTON FROM 77, 101 oButton2 TYPE 2 ENABLE OF oDlg ;
		ACTION (nOpca := 2,oDlg:End()) PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 2
			Exit
		EndIf

	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO8     บAutor  ณMicrosiga           บ Data ณ  10/29/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkRomaneio(cRomaneio,oSay)
	Local lRet := .t.

	If !Empty(cRomaneio)

		cRomaneio := StrZero(Val(cRomaneio),6 )
		lFat := .F.
		lTEm := .F. 

		For nX := 1 to Len(aEmp)

			cArq := "SC9"+aEmp[nX]+"0"

			cQuery := " SELECT * From "+cArq+" WHERE D_E_L_E_T_ <> '*' AND C9_ROMANEI = '"+cRomaneio+"' "

			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRY", .F., .T. )

			DbSelectArea("QRY")
			DbGoTop()

			If QRY->(!Eof())

				lTem := .T.

				While QRY->(!Eof())

					If !Empty(QRY->C9_NFISCAL)
						MsgInfo("O Pedido "+QRY->C9_PEDIDO+" encontra-se faturado NF: "+QRY->C9_NFISCAL )
						lFat := .T.
					EndIf    
					QRY->(DbSkip())   

				End

			EndIf 	

			QRY->(DbCloseArea())

		Next 

		If !lTem
			MsgStop("Romaneio nao cadastrado.")
			lRet := .F. 
		EndIf 

		If lFat 
			MsgStop("Romaneio possui pedido faturado.")
			lRet := .F. 
		EndIf 

	Else
	    MsgStop("Numero do romaneio tem que ser informado.." )
	    lRet := .F. 
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณMicrosiga           บ Data ณ  03/17/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcRom(cRomaneio)
	Local aPedidos := {}

    If Empty(cRomaneio)
       MsgStop("Romaneio tem que ser informado..")
       Return  
    EndIf
     
	If !MsgYesNo("Tem certeza que deseja excluir o Romaneio "+cRomaneio )
		Return
	EndIf
    
	//Excluo o Romaneio 

	For nX := 1 to Len(aEmp)

		If Select("QRYPED") > 0
			QRYPED->(DbCloseArea())
		EndIf

		cArq := "SC5"+aEmp[nX]+"0"

		//Verifico se tem pedido de palete para ser excluido 
		cQryPed := "SELECT C5_NUM FROM "+cArq
		cQryPed += " WHERE D_E_L_E_T_='' and C5_ROMANEI='"+ cRomaneio +"' and C5_FILIAL='" + xFilial("SC5") + "' "
		cQryPed += " AND C5_ZZTIPO = 'L' "

		cQryPed := ChangeQuery( cQryPed )
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryPed), "QRYPED", .F., .T. )

		DbSelectArea("QRYPED")
		DbGoTop()

		While QRYPED->(!Eof())

			cArq := "SC5"+aEmp[nX]+"0"

			cPedido := QRYPED->C5_NUM 

			// Atualiza dados do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " DELETE FROM " + cArq 
			cQuery2 += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedido +"' and C5_FILIAL='" + xFilial("SC5") + "' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Pedido. TCSQLError:"+ TCSQLError())
			EndIf

			cArq := "SC6"+aEmp[nX]+"0"  
			// Deletando os itens do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " DELETE FROM " + cArq 
			cQuery2 += " Where D_E_L_E_T_='' and C6_NUM='"+ cPedido +"' and C6_FILIAL='" + xFilial("SC6") + "' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Pedido.  TCSQLError:"+ TCSQLError())
			EndIf

			cArq := "SC9"+aEmp[nX]+"0"  
			// Deletando os itens do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " DELETE FROM " + cArq 
			cQuery2 += " Where D_E_L_E_T_='' and C9_PEDIDO='"+ cPedido +"' and C9_FILIAL='" + xFilial("SC9") + "' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Pedido. TCSQLError:"+ TCSQLError())
			EndIf

			DbSelectArea("QRYPED")
			DbSkip()

		End

		QRYPED->(DbCloseArea())

		cArq := "SC5"+aEmp[nX]+"0"

		// Atualiza dados do pedido de venda 
		//-------------------------------------------------------------------------------------
		cQuery2 := " UPDATE " + cArq + " SET C5_TRANSP = ' ', C5_STAPED = 'D', C5_ROMANEI =' ' "
		cQuery2 += " Where D_E_L_E_T_='' and C5_ROMANEI='"+ cRomaneio +"' and C5_FILIAL='" + xFilial("SC5") + "' "

		If (TCSQLExec(cQuery2) < 0)
			Return MsgStop("Falha na atualizacao do Pedido . TCSQLError:"+ TCSQLError())
		EndIf

		cArq := "SC9"+aEmp[nX]+"0"

		cQuery2 := " UPDATE " + cArq + " SET C9_ROMANEI = ' ', C9_TRAROM = ' ', C9_EMIROM =' ', "
		cQuery2 += "                    C9_ORDCARG = ' ' " //", C9_TIPOVEI =' ', C9_DTCARRE = '', "
		//			cQuery2 += "                    C9_TPCARRO='' "
		cQuery2 += " Where D_E_L_E_T_='' and C9_ROMANEI='"+ cRomaneio  +"' and C9_FILIAL='" + xFilial("SC9") + "' "

		If (TCSQLExec(cQuery2) < 0)
			Return MsgStop("Falha na atualizacao da Exclusao do Romaneio "+ cRomaneio + ".  TCSQLError:"+ TCSQLError())
		EndIf

	Next 

	DbSelectArea("ZZQ")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZQ")+cRomaneio )

		RecLock("ZZQ",.F.)
		ZZQ->(DbDelete())   
		MsUnlock()

	EndIf

	DbSelectArea("ZZR")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZR")+cRomaneio )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == cRomaneio 

			RecLock("ZZR",.F.)
			ZZR->(DbDelete())   
			MsUnlock()

			DbSkip()
		End

	EndIf

	MsgInfo("Romaneio excluido com sucesso...")

Return
