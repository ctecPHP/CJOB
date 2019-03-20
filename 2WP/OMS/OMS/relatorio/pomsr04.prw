#Include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ POMSR04  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 11.09.18 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera o relatorio dos Romaneio a serem enviado as transp    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function POMSR04()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Vari veis 										     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Relatorio de envio de Romaneio a transp")
	Private aPedidos := {}
	Private aEmp := {}
	Private nPesoPed := 0
	Private cTpFrete := " "
	Private nTotFreNeg := 0
	Private aOrdCarg  := {}
	Private lFiltraGru := .F.

	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)

	Private cEmpCons := " "

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf 

	aRegs := {}
	cPerg := "POSMR04"

	aAdd(aRegs,{cPerg,"01","Da Transportadora  ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
	aAdd(aRegs,{cPerg,"02","Ate Transportadora ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
	aAdd(aRegs,{cPerg,"03","Emissao de         ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Emissao Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"05","Romaneio de        ?","","","mv_ch5","C"   ,06    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Romaneio Ate       ?","","","mv_ch6","C"   ,06    ,00      ,0   ,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"07","Filtrar notas      ?","","","mv_ch7","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR07","Em Aberto"  ,"","","","","Entregue","","","","","Todas","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo gerar o relatorio de  " ) ) //
	AADD(aSays,OemToAnsi( " acordo com os parametros selecionados pelo usuario. " ) )
	AADD(aSays,OemToAnsi( " controla os romaneios enviados a transportadora. " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||POSMR04PROC()},"Processando o arquivo..")

		Processa( {||MOSTRACONS()},"Mostrando a consulta..")

		TRB->(DbCloseArea())

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOMSR02PRO Autor  ณCarlos R. Moreira   บ Data ณ  23/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra selecionar os pedidos de Vendas                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function POSMR04PROC()
	Local aCampos := {}
	Local aArq := {{"ZZQ"," "},{"SF2"," "},{"SA1"," "},{"SA4"," "}}

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	Processa({||VerProc()}, "Gerando o Arquivo de trabalho.." )

	aNomeEmp := Array(Len(aEmp))

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
			aNomeEmp[Ascan(aEmp,SM0->M0_CODIGO)] := SM0->M0_NOME
		EndIf

		DbSelectArea("SM0")
		SM0->(DbSkip())

	End

	RestArea( aAreaSM0 )


	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )

	AADD(aCampos,{ "EMPRESA"  ,"C", 2,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",10,0 } )	
	AADD(aCampos,{ "TRANSP"   ,"C",06,0 } )
	AADD(aCampos,{ "DESCTRA"  ,"C",40,0 } )
	AADD(aCampos,{ "ROMANEIO" ,"C",06,0 } )
	AADD(aCampos,{ "EMISSAO"  ,"D", 8,0 } )
	AADD(aCampos,{ "DTCARRE"  ,"D", 8,0 } )
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )	
	AADD(aCampos,{ "LEADTIME" ,"N", 4,0 } )
	AADD(aCampos,{ "TPVEIC"   ,"C",02,0 } )
	AADD(aCampos,{ "DESVEI"   ,"C",20,0 } )
	AADD(aCampos,{ "TPCARG"   ,"C",01,0 } )
	AADD(aCampos,{ "PESO"     ,"N",11,0 } )				
	AADD(aCampos,{ "QTDCXS"   ,"N", 8,0 } )
	AADD(aCampos,{ "NUMPED"   ,"N", 3,0 } )	
	AADD(aCampos,{ "VLRROM"   ,"N",17,2 } )	
	AADD(aCampos,{ "MUN"      ,"C",30,0 } )				
	AADD(aCampos,{ "EST"      ,"C", 2,0 } )
	AADD(aCampos,{ "HRAGEN"   ,"C", 5,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"TRANSP+ROMANEIO",,,OemToAnsi("Selecionando Registros..."))	//

	For nEmp := 1 to Len(aEmp)

		cArq   := "sx2"+aEmp[nEmp]+"0"
		cAliasTrb := "sx2trb"

		cPath := GetSrvProfString("Startpath","")
		cArq := cPath+cArq

		//Faco a abertura do SX2 da empresa que ira gerar o arquivo de trabalho
		Use  &(cArq ) alias &(cAliasTrb) New

		If Select( cAliasTRB ) == 0
			MsgAlert("Arquivo nao foi aberto..."+cArq)
			Return
		Else
			DbSetIndex( cArq )
		EndIf

		For nArq := 1 to Len(aArq)

			DbSelectArea( cAliasTrb )
			DbSeek( aArq[nArq,1] )

			aArq[nArq,2] := (cAliasTrb)->x2_arquivo

		Next

		If nEmp >  1
			cQuery += " Union All "
		Else
			cQuery := " "
		EndIf

		cQuery += " SELECT     '"+aNomeEmp[nEmp]+"' NOMEMP, '"+aEmp[nEmp]+"' EMPRESA, "  
		cQuery += "             ZZQ.ZZQ_EMIROM, ZZQ.ZZQ_ROMANE, ZZQ.ZZQ_TRANSP,ZZQ.ZZQ_DESTRA,ZZQ.ZZQ_DTCARR,ZZQ.ZZQ_VLRROM,  "
		cQuery += "             ZZQ.ZZQ_ENTREG, ZZQ.ZZQ_TPVEIC, ZZQ.ZZQ_DESVEI, ZZQ.ZZQ_TPCARG, ZZQ.ZZQ_PESO, ZZQ.ZZQ_QTDCXS  " 

		cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "ZZQ" }),2]+" ZZQ "

		cQuery += "  WHERE ZZQ.D_E_L_E_T_ <> '*' "
		cQuery += "  AND ZZQ.ZZQ_TRANSP BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "  AND ZZQ.ZZQ_EMIROM BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += "  AND ZZQ.ZZQ_ROMANE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "		

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","ZZQ_EMIROM","D")
	TCSetField("QRY","ZZQ_DTCARR","D")
	TCSetField("QRY","ZZQ_ENTREG","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGoTop()

	While QRY->(!Eof()) 

		nNumPed := 0

		DbSelectArea("ZZR")
		DbSetOrder(1)
		DbSeek(xFilial("ZZR")+QRY->ZZQ_ROMANE )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == QRY->ZZQ_ROMANE  

			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->EMPRESA  := QRY->EMPRESA
			TRB->NOMEMP   := QRY->NOMEMP 
			TRB->TRANSP   := QRY->ZZQ_TRANSP 
			TRB->DESCTRA  := QRY->ZZQ_DESTRA
			TRB->ROMANEIO := QRY->ZZQ_ROMANE
			TRB->EMISSAO  := QRY->ZZQ_EMIROM
			TRB->DTCARRE  := QRY->ZZQ_DTCARR
			TRB->ENTREG   := QRY->ZZQ_ENTREG	
			TRB->TPVEIC   := QRY->ZZQ_TPVEIC
			TRB->DESVEI   := QRY->ZZQ_DESVEI
			TRB->TPCARG   := QRY->ZZQ_TPCARG
			TRB->PESO     := QRY->ZZQ_PESO				
			TRB->QTDCXS   := QRY->ZZQ_QTDCXS			
			TRB->VLRROM   := QRY->ZZQ_VLRROM
			TRB->MUN      := ZZR->ZZR_MUN
			TRB->EST      := ZZR->ZZR_EST
			TRB->HRAGEN   := ZZR->ZZR_HRAGEN
			TRB->DTAGEN   := ZZR->ZZR_DTAGEN 
			MsUnlock()

			nNumPed++

			DbSelectArea("ZZR") 
			DbSkip()

		End 

		DbSelectArea("TRB")
		DbSeek(cTransp+cRomaneio )
		RecLock("TRB",.F.)
		TRB->NUMPED   := nNumPed 
		MsUnlock()

		DbSelectArea("QRY")
		DbSkip()

	End 

	QRY->(DbCloseArea())

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOMSR02MosบAutor  ณMicrosiga           บ Data ณ  02/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MostraCons()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	DbSelectArea("TRB")

	cMarca  := GetMark()

	aBrowse := {}

	//	AaDD(aBrowse,{"OK","",""})
	//	AaDD(aBrowse,{"EMPRESA" ,"","Empresa"})
	AaDD(aBrowse,{"TRANSP","","Transp"})
	AaDD(aBrowse,{"DESCTRA","","Nomeo"})
	AaDD(aBrowse,{"ROMANEIO","","Romaneio"})
	AaDD(aBrowse,{"NUMPED","","Qtde Pedidos","@E 999"})
	AaDD(aBrowse,{"EMISSAO","","Dt Emissao"})
	AaDD(aBrowse,{"DTCARRE","","Dt Carregam"})

	AaDD(aBrowse,{"ENTREG","","Entrega"})

	AaDD(aBrowse,{"TPVEIC" ,"","Tp Veiculo"})
	AaDD(aBrowse,{"DESVEI","","Descricao"})

	AaDD(aBrowse,{"TPCARG","","Tp Carga"})
	AaDD(aBrowse,{"QTDCXS","","Qtd Caixas","@E 999999"})
	AaDD(aBrowse,{"VLRROM","","Valor Rom","@E 99,999,999.999"})		
	AaDD(aBrowse,{"PESO","","Peso","@E 99,999,999"})


	TRB->(DbGoTop())

	AADD(aObjects,{ 80,015,.T.,.T.})

	aCores := {}

	Aadd(aCores, { 'STATUS = " "', "ENABLE" } )
	Aadd(aCores, { 'STATUS = "A"', "DISABLE" } )

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Mostra o resultado da consulta" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+1 ,aPosObj[1,2]   ,aPosObj[1,3]-35,aPosObj[1,4]-5 }) //,,,,,aCores)
	oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	@ aPosObj[1,3]-20,aPosObj[1,4]-355 Button "&Sair"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel

	@ aPosObj[1,3]-20,aPosObj[1,4]-420 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel

	@ aPosObj[1,3]-20,aPosObj[1,4]-485 Button "&Imprimir"    Size 60,15 Action ImprRel() of oDlg1 Pixel

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

	//	TRB->(DbCloseArea())

Return

/*/
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณLchoiceBarณ Autor ณ Pilar S Albaladejo    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Mostra a EnchoiceBar na tela                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq,nTipo)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg

	DEFINE BUTTON RESOURCE "S4WB010N" OF oBar GROUP ACTION ImprRel() TOOLTIP OemToAnsi("Imprimir consulta...")

	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.


/*/
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณLchoiceBarณ Autor ณ Pilar S Albaladejo    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Mostra a EnchoiceBar na tela                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImprRel()

	oFont   :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3  :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12 :=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5  :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9  :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oFont14 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

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

	oPrn:Setup()

	oPrn:Setlandscape()

	oPrn:SetPaperSize(9)

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())

	While TRB->(!Eof())

		IncProc("Gerando a impressao...")

		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de envio de Romaneio a transp"
			cRod    := " " 
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"POMSR04")

			CabCons(oPrn)

			lFirst = .F.

		EndIf

		oPrn:Box(nLin,100,nLin+60,3300)

		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin,1000,nLin+60,1000)
		oPrn:line(nLin,1200,nLin+60,1200)
		oPrn:line(nLin,1400,nLin+60,1400)	
		oPrn:line(nLin,1600,nLin+60,1600)		
		oPrn:line(nLin,1800,nLin+60,1800)
		oPrn:line(nLin,2000,nLin+60,2000)
		oPrn:line(nLin,2800,nLin+60,2800)
		oPrn:line(nLin,3000,nLin+60,3000)		
		oPrn:line(nLin,3150,nLin+60,3150)

		oPrn:Say(nLin+10,  110,TRB->TRANSP        ,oFont5 ,100)
		oPrn:Say(nLin+10,  260,TRB->DESCTRA       ,oFont5 ,100)
		oPrn:Say(nLin+10, 1010,TRB->ROMANEIO      ,oFont5 ,100)
		oPrn:Say(nLin+10, 1210,Dtoc(TRB->EMISSAO) ,oFont5 ,100)
		oPrn:Say(nLin+10, 1410,Dtoc(TRB->DTCARRE) ,oFont5 ,100)		
		oPrn:Say(nLin+10, 1610,Dtoc(TRB->DTCARRE)  ,oFont5 ,100)
		oPrn:Say(nLin+10, 1810,TRB->TPVEIC        ,oFont5 ,100)
		oPrn:Say(nLin+10, 2010,TRB->DESVEI        ,oFont5  ,100)
		oPrn:Say(nLin+10, 2810,TRB->TPCARG        ,oFont5  ,100)   
		oPrn:Say(nLin+10, 3010,Transform(TRB->QTDCXS,"@e 99999" )  ,oFont5  ,100)
		oPrn:Say(nLin+10, 3160,Transform(TRB->PESO  ,"@e 99999" ) ,oFont5  ,100)		
		nLin += 60

		If nLin > 2200

			oPrn:EndPage()

			oPrn:StartPage()
			cTitulo := "Relatorio de envio de Romaneio a transp"
			cRod    := " "
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")

			CabCons(oPrn)

		EndIf

		DbSelectArea("TRB")
		DbSkip()

	End 

	oPrn:Preview()

	oPrn:End()

	MS_FLUSH()

	TRB->(DbGoTop())

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabCons   บAutor  ณCarlos R. Moreira   บ Data ณ  19/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณmonta o cabecalho da consulta                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabCons(oPrn,nModo)

	nLin := 320

	oPrn:FillRect({nLin,100,nLin+60,3300},oBrush)

	oPrn:Box(nLin,100,nLin+60,3300)

	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin,1000,nLin+60,1000)
	oPrn:line(nLin,1200,nLin+60,1200)
	oPrn:line(nLin,1400,nLin+60,1400)	
	oPrn:line(nLin,1600,nLin+60,1600)		
	oPrn:line(nLin,1800,nLin+60,1800)
	oPrn:line(nLin,2000,nLin+60,2000)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3000,nLin+60,3000)		
	oPrn:line(nLin,3150,nLin+60,3150)

	//Prn:Say(nLin+10,  110,"Empresa" ,oFont5 ,100)
	oPrn:Say(nLin+10,  110,"Transp."  ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Nome"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 1010,"Romaneio"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1210,"Emissao"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1410,"Dt Carreg"   ,oFont5 ,100)	
	oPrn:Say(nLin+10, 1610,"Entrega"   ,oFont5 ,100)		
	oPrn:Say(nLin+10, 1810,"Tp Veic"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 2010,"Descricao" ,oFont9 ,100)
	oPrn:Say(nLin+10, 2810,"Tp Carga" ,oFont5 ,100)
	oPrn:Say(nLin+10, 3010,"Qtd Cxs" ,oFont5 ,100)	
	oPrn:Say(nLin+10, 3160,"Peso" ,oFont5 ,100)	

	nLin += 60

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONSCART2 บAutor  ณMicrosiga           บ Data ณ  07/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerProc()
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONS_NF   บAutor  ณMicrosiga           บ Data ณ  05/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExpCons()
	Private aDadosExcel := {}

	AaDd(aDadosExcel,{ 	"Periodo de : ",;
	Dtoc(MV_PAR03) ,;
	" A ",;
	Dtoc(MV_PAR04)," " ," "," "," "," " ," "," "," "," " })

	AaDD( aDadosExcel, { " " ," "," "," "," " ," "," "," "," " ," "," "," "," " })

	AaDd(aDadosExcel,{ 	"Transp."  ,;
	"Nome"       ,;
	"Romaneio"   ,;
	"Qtde Ped"  ,;
	"Emissao"   ,;	
	"Dt Carregamento"   ,;
	"Dt Entrega" ,;
	"Tipo Veiculo" ,;
	"Descricao" ,;
	"Tipo Carga" ,;
	"Qtde Cxs" ,;			
	"Peso" ,;
	"Vlr Romaneio"})

	nCol := Len(aDadosExcel[1])

	nTotQtd := 0
	nTotVlr := 0

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->TRANSP,;
		TRB->DESCTRA,;
		TRB->ROMANEIO,;
		Transform(TRB->NUMPED,"@E 999"),;		
		Dtoc(TRB->EMISSAO),;
		Dtoc(TRB->DTCARRE),;
		Dtoc(TRB->ENTREG),;				
		TRB->TPVEIC,; 
		TRB->DESVEI,;
		TRB->TPCARG ,;
		Transform(TRB->QTDCXS,"@E 99999"),;
		Transform(TRB->PESO,"@E 99999"),;				
		Transform(TRB->VLRROM,"@E 999999")})

		DbSelectArea("TRB")
		DbSkip()

	End

	Processa({||Run_Excel(aDadosExcel,nCol)},"Gerando a Integra็ใo com o Excel...")

	MsgInfo("Exportacao efetuada com sucesso..")

	TRB->(DbGotop())

Return

Static Function Run_Excel(aDadosExcel,nCol)
	LOCAL cDirDocs   := MsDocPath()
	Local aStru		:= {}
	Local cArquivo := CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX,nY

	ProcRegua(Len(aDaDosExcel))

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0


		For nX := 1 to Len(aDadosExcel)

			IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") //
			cBuffer := ""
			For nY := 1 to nCol  //Numero de Colunas do Vetor

				cBuffer += aDadosExcel[nX,nY] + ";"

			Next
			fWrite(nHandle, cBuffer+cCrLf ) // Pula linha

		Next

		IncProc("Aguarde! Abrindo o arquivo...") //

		fClose(nHandle)

		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' ) //
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert( "Falha na cria็ใo do arquivo" ) //
	Endif

Return
