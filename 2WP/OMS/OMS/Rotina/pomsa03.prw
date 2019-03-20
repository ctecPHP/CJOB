#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPomsa03   บAutor  ณCarlos R. Moreira   บ Data ณ  06/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSolicita o Numero do Romaneio para Separacao da Carga       บฑฑ
ฑฑบ          ณpara efetuar a Exclusao do Romaneio                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Sobel                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function POMSA03()

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
	cTransp := Space(6)

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

		DEFINE MSDIALOG oDlg FROM  47,130 TO 250,400 TITLE OemToAnsi("Troca a Transportadora Romaneio") PIXEL

		@ 05, 04 TO 41,130 LABEL "Numero Romaneio " OF oDlg	PIXEL //

		@ 18, 17 MSGET oRomaneio VAR cRomaneio PICTURE "999999"  SIZE 70,14 FONT oFonte PIXEL;
		OF oDlg  VALID ChkRomaneio(@cRomaneio,oSay) COLOR CLR_HBLUE FONT oFonte RIGHT

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Botoes para confirmacao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


		DEFINE SBUTTON FROM 77,  71 oButton1 TYPE 1 ENABLE OF oDlg ;
		ACTION {|| nOpca := 1, AltTraRom(cRomaneio),oDlg:End()} PIXEL

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
						lFat := .T.
					EndIf
					cTransp := SC9->C9_TRAROM    
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
Static Function AltTraRom(cRomaneio)
	Local aPedidos := {}
	Local aTransp := {}
	Local oDlgProc
	Local oCbx
	Local aArea := GetArea()

	If !MsgYesNo("Tem certeza que deseja alterar a transportadora do "+cRomaneio )
		Return
	EndIf

    Private oTransp
//    cTransp := Space(6)
    

	DbSelectArea("SA4")
	DbSetOrder(1)
	DbGoTop()

	While SA4->(!Eof())

 /*       If SA4->A4_MSBLQL == '1'
           DbSkip()
           Loop
        EndIf */ 
           
		AaDd(aTransp, SA4->A4_COD+'-'+SA4->A4_NOME )

		SA4->(DbSkip())

	End

	DEFINE MSDIALOG oDlgProc TITLE "Seleciona Transportadora" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL Label "Transportadora"
	
	@ 15, 10 MSGET oTransp VAR cTransp F3 "SA4" Valid ChkTransp(@cTransp ) SIZE 80, 10 OF oDlgProc PIXEL
	
//	@ 15, 10 COMBOBOX oCbx VAR cTransp ITEMS aTransp SIZE 140, 27 OF oDlgProc PIXEL

	@ 50, 90 BMPBUTTON TYPE 1 Action Processa({||GravTraRom(cTransp,oDlgProc)},"Alterando a transportadora" )
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	RestArea(aArea)
   

Return 

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

Static Function GravTraRom(cTransp,oDlgProc)

ProcRegua(Len(aEmp))

	//Altero a transportadora do Romaneio 
       cTransp := Substr(cTransp,1,6 )   

		For nX := 1 to Len(aEmp)

            IncProc("Atualizando a empresa: "+aEmp[nX] )
            
			cArq := "SC5"+aEmp[nX]+"0"

			// Atualiza dados do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " UPDATE " + cArq + " SET C5_TRANSP = '"+cTransp+"' "
			cQuery2 += " Where D_E_L_E_T_='' and C5_ROMANEI='"+ cRomaneio +"' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Romaneio "+ cRomaneio + ".  TCSQLError:"+ TCSQLError())
			EndIf


			cArq := "SC9"+aEmp[nX]+"0"

			cQuery2 := " UPDATE " + cArq + " SET C9_TRAROM = '"+cTransp+" ' "
			cQuery2 += " Where D_E_L_E_T_='' and C9_ROMANEI='"+ cRomaneio  +"' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Romaneio "+ cRomaneio + ".  TCSQLError:"+ TCSQLError())
			EndIf
            
		Next 

	DbSelectArea("ZZQ")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZQ")+cRomaneio )

		RecLock("ZZQ",.F.)
		ZZQ->ZZQ_TRANSP := cTransp 
		ZZQ->ZZQ_DESTRA := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")   
		MsUnlock()

	EndIf

	MsgInfo("Transportadora alterada com sucesso...")
	
	Close(oDlgProc)
	
Return


Static Functio ChkTransp(cTransp)
Local lRet := .T.

If !Empty(cTransp)

    cTransp := StrZero(Val(cTransp),6)
    
    DbSelectArea("SA4")
    DbSetOrder(1)
    If ! DbSeek(xFilial("SA4")+cTransp)
       MsgStop("Transportadora nao cadastrada..")
       Return .F. 
    EndIf 
    
EndIf 

Return lRet 