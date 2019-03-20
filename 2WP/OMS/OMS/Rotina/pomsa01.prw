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
ฑฑณFun…o    ณ POMSA01  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 22.02.10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processa os Pedidos em aberto para formacao de cargas      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function POMSA01()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Vari veis 										     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Processa os Pedidos para Montagem de cargas")
	Private aPedidos := {}
	Private aEmp := {}
	Private nPesoPed := 0
	Private cTpFrete := " "
	Private nTotFreNeg := 0
	Private aOrdCarg  := {}
	Private lFiltraGru := .F.
	Private dDtCarre   := dDataBase

	cEmpOri := cEmpAnt
	cFilOri := cFilAnt

	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",10.5,10,,.T.,,,,,.F.)

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.",If(SM0->M0_CODIGO="01","02",""))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf   

	aRegs := {}
	cPerg := "POSMA01"

	aAdd(aRegs,{cPerg,"01","Do pedido          ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	aAdd(aRegs,{cPerg,"02","Ate Pedido         ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	aAdd(aRegs,{cPerg,"03","Data Entrega de    ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Data Entrega Ate   ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"05","Zona de            ?","","","mv_ch5","C"   ,06    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","DA5",""})
	aAdd(aRegs,{cPerg,"06","Zona ate           ?","","","mv_ch6","C"   ,06    ,00      ,0   ,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","DA5",""})

	aAdd(aRegs,{cPerg,"07","Ordenar por        ?","","","mv_ch7","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR07","Pedido"  ,"","","","","Data Entrega","","","","","Zona","","","","","Transportadora","","","","","Cep","","","","",""})

	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"11","Filtra Tipo Frete     ?","","","mv_chB","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR11","CIF"  ,"","","","","FOB","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	While .T.

		If Pergunte(cPerg,.T.)

			If MV_PAR10 <  dDataBase
				MsgStop("Data de Carregamento nao pode ser menor que a data atual ")
			Else
				Exit      
			EndIf 
		Else 
			Return   
		EndIf 

	End

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo selecionar os pedidos de vendas " ) ) //
	AADD(aSays,OemToAnsi( " para a geracao de cargas que serao enviadas as transportadora " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||POSMA01PROC()},"Processando o arquivo..")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOMSA01   บAutor  ณCarlos R. Moreira   บ Data ณ  23/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra selecionar os pedidos de Vendas                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function POSMA01PROC()
	Local aCampos := {}
	Local aArq := {{"SC9"," "},{"SC5"," "},{"SA1"," "},{"SB1"," "},{"DA5"," "}}

	aEmp := {}

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
	AADD(aCampos,{ "PEDIDO"  ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE" ,"C",06,0 } )
	AADD(aCampos,{ "LOJA"    ,"C",03,0 } )
	AADD(aCampos,{ "NOME"    ,"C",25,0 } )
	AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
	AADD(aCampos,{ "DTENT"   ,"D", 8,0 } )
	AADD(aCampos,{ "DTAGEN"  ,"D", 8,0 } )
	AADD(aCampos,{ "HRAGEN"  ,"C", 5,0 } )	
	AADD(aCampos,{ "PESO"    ,"N",11,0 } )
	AADD(aCampos,{ "QTDCX"   ,"N",11,0 } )
	AADD(aCampos,{ "REGIAO"  ,"C",06,0 } )
	AADD(aCampos,{ "DESCREG" ,"C",20,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,4 } )
	AADD(aCampos,{ "TOTPED"  ,"N",17,2 } )
	AADD(aCampos,{ "TRANSP"  ,"C",06,0 } )
	AADD(aCampos,{ "DESCTRA" ,"C",30,0 } )
	AADD(aCampos,{ "EMPRESA" ,"C", 2,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",10,0 } )	
	AADD(aCampos,{ "PALLET"  ,"C", 1,0 } )
	AADD(aCampos,{ "FATANT"  ,"C", 1,0 } )
	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )
	AADD(aCampos,{ "OBS"     ,"C",40,0 } )
	AADD(aCampos,{ "EST"     ,"C", 2,0 } )
	AADD(aCampos,{ "MUN"     ,"C",25,0 } )
	AADD(aCampos,{ "CODMUN"  ,"C", 6,0 } )
	AADD(aCampos,{ "PEDCLI"  ,"C",15,0 } )
	AADD(aCampos,{ "TPFRETE" ,"C", 1,0 } )
	AADD(aCampos,{ "BAIRRO"  ,"C",20,0 } )
	AADD(aCampos,{ "OPER"    ,"C", 2,0 } )
	AADD(aCampos,{ "PEDBON"  ,"C", 6,0 } )
	AADD(aCampos,{ "CEP"     ,"C", 9,0 } )
	AADD(aCampos,{ "LIBPED"  ,"C", 1,0 } )
	AADD(aCampos,{ "QTDPALL" ,"N", 4,0 } )
	AADD(aCampos,{ "MENS"    ,"C",60,0 } )
	AADD(aCampos,{ "PREVFAT" ,"D", 8,0 } )
	AADD(aCampos,{ "LEADTIM" ,"N", 4,0 } )
	AADD(aCampos,{ "PESOPED" ,"N",11,0 } )
	AADD(aCampos,{ "NUMCARG" ,"C", 6,0 } )
	AADD(aCampos,{ "REDESP"  ,"C", 1,0 } )
	AADD(aCampos,{ "TRARED"  ,"C",06,0 } )
	AADD(aCampos,{ "DESTRAR" ,"C",20,0 } )
	AADD(aCampos,{ "ORDCARG" ,"C", 3,0 } )
	AADD(aCampos,{ "OBSINT" ,"C", 120,0 } )
	AADD(aCampos,{ "OBSEXT" ,"C", 120,0 } )
	AADD(aCampos,{ "TPPED"  ,"C", 1,0 } )
	AADD(aCampos,{ "GRUEMB" ,"C", 2,0 } )	

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	aCampos := {} 

	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "GRUEMB"   ,"C", 2,0 } )
	AADD(aCampos,{ "QUANT"    ,"N",11,4 } )
	AADD(aCampos,{ "QTDPALL"  ,"N",11,4 } )	
	AADD(aCampos,{ "TOTPALL"  ,"N",17,2 } )

	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB1", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB1",cNomArq,"PEDIDO+GRUEMB",,,OemToAnsi("Selecionando Registros..."))	//

	aCampos := {} 

	AADD(aCampos,{ "EMPRESA"  ,"C",02,0 } )
	AADD(aCampos,{ "ROMANEI"  ,"C", 6,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C", 6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C", 2,0 } )	
	AADD(aCampos,{ "TOTPALL"  ,"N",17,2 } )
	AADD(aCampos,{ "TRANSP"   ,"C", 6,0 } )	

	If Select("PAL") > 0
		PAL->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"PAL", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("PAL",cNomArq,"EMPRESA+ROMANEI",,,OemToAnsi("Selecionando Registros..."))	//

	If MV_PAR08 == 1

		Processa({||U_SelGrupo()},"Selecionando grupo de produtos....")

		lFitraGru := .T.

	EndIf

	//nova query

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

		cQuery += " SELECT     '"+aEmp[nEmp]+"' EMPRESA, SC9.C9_PEDIDO, SC9.C9_ITEM, SC9.C9_PRODUTO, SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_QTDLIB, SC9.C9_BLEST, SC9.C9_PRCVEN, "
		cQuery += "    		    SC9.C9_BLCRED, SC5.C5_ZZTIPO, SC5.C5_STAPED,SC5.C5_TRANSP, "
		cQuery += "             SC5.C5_TIPO, SA1.A1_COD_MUN, SA1.A1_BAIRRO, SA1.A1_CEP, SA1.A1_NOME, SA1.A1_EST, SA1.A1_MUN, SA1.A1_NREDUZ, SA1.A1_FATANT, " 
		cQuery += " 			SC5.C5_TPFRETE,SC5.C5_PEDBON,  "
		cQuery += "             SC5.C5_DTAGEN1, SC5.C5_HRAGEN2,SC5.C5_DTAGEN2, SC5.C5_HRAGEN3, "
		cQuery += "             SC5.C5_EMISSAO, SC5.C5_DTAGEN, SC5.C5_HRAGEN,SC5.C5_MENNOTA,  "
		cQuery += "             SC5.C5_FECENT, SC5.C5_LEADTIM, SB1.B1_PESBRU,SB1.B1_GRUEMB,SB1.B1_QTDPALL " 
		cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9 INNER "
		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5  ON "
		cQuery += " SC5.D_E_L_E_T_ <> '*' AND SC9.C9_PEDIDO = SC5.C5_NUM "
//		cQuery += " AND SC5.C5_STAPED = 'D' "

		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1  ON "
		cQuery += "      SA1.D_E_L_E_T_ <> '*' AND "
		cQuery += "      SC9.C9_CLIENTE = SA1.A1_COD AND SC9.C9_LOJA = SA1.A1_LOJA "
		cQuery += "      AND SA1.A1_COD <> '002268' "

		If MV_PAR09 == 1 
			cQuery += "      AND SA1.A1_ZZPALET <>  '1' "		
		Else
			cQuery += "      AND SA1.A1_ZZPALET = '1' "		
		EndIf 

		cQuery += "JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1  ON "
		cQuery += "      SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "      SC9.C9_PRODUTO = SB1.B1_COD "

		cQuery += "   WHERE SC9.D_E_L_E_T_ <> '*' "

		cQuery += " AND SC9.C9_BLCRED = ' ' " //"AND SC9.C9_BLEST =  ' ' "
		cQuery += "   AND SC9.C9_PEDIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "  AND SC9.C9_ROMANEI = ' ' "

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C5_EMISSAO","D")
	TCSetField("QRY","C5_FECENT","D")
	TCSetField("QRY","C5_DTAGEN","D")
	TCSetField("QRY","C5_DTAGEN1","D")	
	TCSetField("QRY","C5_DTAGEN2","D")
	/*
	If Len(aEmp) > 1

	For nEmp := 1 to Len(aEmp)

	aArqDest := { "SC6","SB2","SC9","SC5" }

	If aEmp[nEmp] # SM0->M0_CODIGO

	cEmp := aEmp[nEmp]

	For nX := 1 to Len(aArqDest)

	//Abro os Arquivos nas respectivas empresas
	cArqVar := aArqDest[nX]+aEmp[nEmp]+"0"

	DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

	If Select( cArqVar ) > 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek(aArqDest[nX]))
	While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
	DbSetIndex(cArqVar+SIX->ORDEM)
	SIX->(DbSkip())
	End
	DbSetOrder(1)

	EndIf

	Next

	//Crio a Variavel para selecionar o arquivo correspondente

	cArqSC6 := "SC6"+cEmp+"0"
	cArqSB2 := "SB2"+cEmp+"0"
	cArqSC9 := "SC9"+cEmp+"0"
	cArqSC5 := "SC5"+cEmp+"0"

	EndIf

	Next

	EndIf
	*/ 
	nEscolha := 3 //Escolha()

	aPedidos := {}

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
		If SA7->(DbSeek(xFilial("SA7")+QRY->C9_CLIENTE+QRY->C9_LOJA+QRY->C9_PRODUTO ))
			nCxPalle := SA7->A7_QTDPALE
		Else
			nCxPalle := QRY->B1_QTDPALL
		EndIf


		DbSelectArea("TRB1")
		If ! DbSeek(QRY->C9_PEDIDO+QRY->B1_GRUEMB )
			RecLock("TRB1",.T.)
			TRB1->PEDIDO := QRY->C9_PEDIDO 
			TRB1->GRUEMB := QRY->B1_GRUEMB 
			TRB1->QTDPALL:= QRY->B1_QTDPALL 
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
		TRB1->TOTPALL := Int(( TRB1->QUANT  / TRB1->QTDPALL  )) 

		nResto        :=  ( TRB1->QUANT  / TRB1->QTDPALL ) - Int( TRB1->QUANT  / TRB1->QTDPALL  )

		If nResto  > 0.00
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

		If QRY->C5_TIPO # "N" .Or. ! QRY->C5_ZZTIPO $ "N/F/X/R"
			DbSelectArea("QRY")
			DbSkip()
			Loop
		EndIf

		If QRY->A1_FATANT # "S"

			If ! QRY->C5_STAPED $ "D"
				DbSelectArea("QRY")
				DbSkip()
				Loop
			ElseIf 	QRY->C9_BLCRED == '10' .AND.  QRY->C9_BLEST == '10'
				DbSelectArea("QRY")
				DbSkip()
				Loop

			EndIf

		EndIf

		If MV_PAR11 == 1 

			If QRY->C5_TPFRETE # "C"
				DbSelectArea("QRY")
				DbSkip()
				Loop
			EndIf    
		Else
			If QRY->C5_TPFRETE # "F"
				DbSelectArea("QRY")
				DbSkip()
				Loop
			EndIf    

		EndIf

		cZona     := Space(6)
		cDescZona := Space(20)

		If QRY->A1_EST == "SP"

			DbSelectArea("DA7")
			DbSetOrder(1)
			DbSeek(xFilial("DA7")+QRY->A1_EST  )

			While DA7->(!Eof()) .And. Substr(DA7->DA7_PERCUR,1,2) == QRY->A1_EST  

				If QRY->A1_CEP >= DA7->DA7_CEPDE .And. QRY->A1_CEP <= DA7->DA7_CEPATE 
					cZona := DA7->DA7_PERCUR
					cDescZona := Posicione("DA5",1,xFilial("DA5")+cZona,"DA5->DA5_DESC")
					Exit  
				EndIf 

				DbSkip()

			End  

		Else

			DbSelectArea("DA7")
			DbSetOrder(4)
			DbSeek(xFilial("DA7")+QRY->A1_COD_MUN )

			While DA7->(!Eof()) .And. DA7->DA7_CODMUN == QRY->A1_COD_MUN 

				If QRY->A1_EST == Substr(DA7->DA7_PERCUR,1,2 )
					cZona := DA7->DA7_PERCUR 
					cDescZona := Posicione("DA5",1,xFilial("DA5")+cZona,"DA5->DA5_DESC")					
					Exit  
				EndIf 

				DbSkip()

			End  

		EndIf 

		If MV_PAR08 == 1 

			DbSelectArea("ZONA")

			If DbSeek(cZona)
				If Empty(ZONA->OK)
					DbSelectArea("QRY")
					DbSkip()
					Loop

				EndIf 
			Else
				DbSelectArea("QRY")
				DbSkip()
				Loop

			EndIf            
		Else
			If  cZona < MV_PAR05 .Or. cZona > MV_PAR06
				DbSelectArea("QRY")
				DbSkip()
				Loop
			EndIf
		EndIf 

		//		If QRY->C5_OPER # "04"
		If nEscolha # 3
			If nEscolha == 1

				If cFatTot # "T"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf

			Else
				//			lFatTot := VerPedFat()
				If cFatTot # "P"
					DbSelectArea("QRY")
					DbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		//		EndIf

		nTotPalle := 0

		DbSelectArea("TRB1")

		If DbSeek(QRY->C9_PEDIDO)

			While TRB1->(!Eof()) .And. TRB1->PEDIDO == QRY->C9_PEDIDO 

				nTotPalle += TRB1->TOTPALL 

				DbSkip()     	       
			End

		EndIf 

		If ( QRY->C5_FECENT - QRY->C5_LEADTIM )   < MV_PAR03 .Or. ( QRY->C5_FECENT - QRY->C5_LEADTIM )  > MV_PAR04
			DbSelectArea("QRY")
			DbSkip()
			Loop
		EndIf

		cPedBon := Alltrim(QRY->C5_PEDBON )  

		If !Empty(cPedBon) 

			If Len(cPedBon) > 6

				cPedVen := cPedBon 

				cPedBon := Space(6)

				nColuna := 1 

				For  nPed := 1 to Len(cPedVen)   

					If Substr(cPedVen,nPed,1) == ","

						If SM0->M0_CODIGO == QRY->EMPRESA 

							DbSelectArea("SC5")
							DbSetOrder(1)
							If DbSeek(xFilial("SC5")+Substr(cPedVen,nColuna,6 ) )

								If SC5->C5_CLIENTE+SC5->C5_LOJACLI == QRY->C9_CLIENTE+QRY->C9_LOJA  

									cPedBon := SC5->C5_NUM 

								EndIf 

							EndIf 

						Else

							cArqPed  := "SC5"+QRY->EMPRESA+"0" 

							cQuery := " SELECT * From "+cArqPed+" WHERE D_E_L_E_T_ <> '*' AND C5_NUM = '"+Substr(cPedVen,nColuna,6 )+"' "

							cQuery := ChangeQuery( cQuery )
							dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRYBON", .F., .T. )

							DbSelectArea("QRYBON")
							DbGoTop()

							While QRYBON->(!Eof())

								If QRYBON->C5_CLIENTE+QRYBON->C5_LOJACLI == QRY->C9_CLIENTE+QRY->C9_LOJA 

									//								If QRY->C9_PEDIDO = QRYBON->C5_NUM  
									cPedBon := QRYBON->C5_NUM
									//								EndIf  

								EndIf 

								DbSkip()

							End 

							QRYBON->(DbCloseArea())

						EndIf

						nColuna := nPed  + 1 

					EndIf

				Next  


			Else 

				cPedVen := cPedBon 

				cPedBon := Space(6)

				If SM0->M0_CODIGO == QRY->EMPRESA 

					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+cPedVen )

						If SC5->C5_CLIENTE+SC5->C5_LOJACLI == QRY->C9_CLIENTE+QRY->C9_LOJA

							cPedBon := SC5->C5_NUM 

						EndIf 

					EndIf 

				Else

					cArqPed  := "SC5"+QRY->EMPRESA+"0" 

					cQuery := " SELECT * From "+cArqPed+" WHERE D_E_L_E_T_ <> '*' AND C5_NUM = '"+cPedVen+"' "

					cQuery := ChangeQuery( cQuery )
					dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRYBON", .F., .T. )


					DbSelectArea("QRYBON")
					DbGoTop()

					While QRYBON->(!Eof())

						If QRYBON->C5_CLIENTE+QRYBON->C5_LOJACLI == QRY->C9_CLIENTE+QRY->C9_LOJA

							//						If QRY->C9_PEDIDO = QRYBON->C5_NUM

							cPedBon := QRYBON->C5_NUM 

							//						EndIf 

						EndIf 

						DbSkip()

					End 

					QRYBON->(DbCloseArea())

				EndIf 

			EndIf 

		EndIf 

		DbSelectArea("TRB")
		If !DbSeek(QRY->C9_PEDIDO )
			RecLock("TRB",.T.)
			TRB->PROD    := QRY->C9_PRODUTO
			TRB->PEDIDO  := QRY->C9_PEDIDO
			TRB->CLIENTE := QRY->C9_CLIENTE
			TRB->LOJA    := QRY->C9_LOJA
			TRB->NOME    := QRY->A1_NOME
			TRB->EMISSAO := QRY->C5_EMISSAO
			TRB->DTENT   := QRY->C5_FECENT
			TRB->FATANT  := QRY->A1_FATANT 
			TRB->QUANT   := QRY->C9_QTDLIB 
			TRB->PESO    := TRB->QUANT * QRY->B1_PESBRU
			TRB->REGIAO  := cZona 
			TRB->DESCREG := cDescZona 
			TRB->EMPRESA := QRY->EMPRESA
			nNomEmp := Ascan(aEmp,QRY->EMPRESA)
			TRB->NOMEMP  := aNomEmp[nNomEmp] 
			TRB->EST     := QRY->A1_EST
			TRB->MUN     := QRY->A1_MUN
			//			TRB->PEDCLI  := QRY->C5_PEDCLI
			TRB->TPFRETE := QRY->C5_TPFRETE
			TRB->BAIRRO  := QRY->A1_BAIRRO
			TRB->CEP     := QRY->A1_CEP
			TRB->LIBPED  := "T" //cFatTot
			TRB->MENS    := QRY->C5_MENNOTA
			TRB->LEADTIM := QRY->C5_LEADTIM
			TRB->PESOPED := nPesoPed
			//			TRB->TRANSP  := cTransp
			TRB->TOTPED  := QRY->C9_PRCVEN * QRY->C9_QTDLIB
			TRB->CODMUN  := QRY->A1_COD_MUN
			TRB->TPPED   := QRY->C5_ZZTIPO
			TRB->QTDPALL := nTotPalle			
			TRB->GRUEMB  := QRY->B1_GRUEMB 
			TRB->PEDBON  := cPedBon  

			If !Empty(QRY->C5_DTAGEN2)
				TRB->DTAGEN  := QRY->C5_DTAGEN2
				TRB->HRAGEN  := QRY->C5_HRAGEN3
			ElseIf !Empty(QRY->C5_DTAGEN1)
				TRB->DTAGEN  := QRY->C5_DTAGEN1
				TRB->HRAGEN  := QRY->C5_HRAGEN2
			Else
				TRB->DTAGEN  := QRY->C5_DTAGEN 
				TRB->HRAGEN  := QRY->C5_HRAGEN 

			EndIf  
			MsUnlock()
		Else
			Reclock("TRB",.F.)
			TRB->PESO    += QRY->C9_QTDLIB * QRY->B1_PESBRU
			TRB->QUANT   += QRY->C9_QTDLIB
			TRB->TOTPED  += QRY->C9_PRCVEN * QRY->C9_QTDLIB
			MsUnlock()
		EndIf

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

	DbSelectArea("TRB")
	If MV_PAR07 == 2
		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"Dtos(DTENT)+Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd2  := Left(CriaTrab(Nil,.F.),7)+"A" 
		IndRegua("TRB",cInd2,"Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd3  := Left(CriaTrab(Nil,.F.),7)+"B"
		IndRegua("TRB",cInd3,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd4  := Left(CriaTrab(Nil,.F.),7)+"C"
		IndRegua("TRB",cInd4,"ROMANEI+EMPRESA+CLIENTE+LOJA",,,OemToAnsi("Selecionando Registros..."))	//

		DbClearIndex()
		DbSetIndex(cIndice + OrdBagExt())
		DbSetIndex(cInd2 + OrdBagExt())
		DbSetIndex(cInd3 + OrdBagExt())
		DbSetIndex(cInd4 + OrdBagExt())

	ElseIf MV_PAR07 == 3
		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"REGIAO+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd2  := Left(CriaTrab(Nil,.F.),7)+"A" 
		IndRegua("TRB",cInd2,"Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd3  := Left(CriaTrab(Nil,.F.),7)+"B"
		IndRegua("TRB",cInd3,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd4  := Left(CriaTrab(Nil,.F.),7)+"C"
		IndRegua("TRB",cInd4,"ROMANEI+EMPRESA+CLIENTE+LOJA",,,OemToAnsi("Selecionando Registros..."))	//

		DbClearIndex()
		DbSetIndex(cIndice + OrdBagExt())
		DbSetIndex(cInd2 + OrdBagExt())
		DbSetIndex(cInd3 + OrdBagExt())
		DbSetIndex(cInd4 + OrdBagExt())		

	ElseIf MV_PAR07 == 4
		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"TRANSP+Dtos(DTENT)",,,OemToAnsi("Selecionando Registros..."))	//
		cInd2  := Left(CriaTrab(Nil,.F.),7)+"A" 
		IndRegua("TRB",cInd2,"Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd3  := Left(CriaTrab(Nil,.F.),7)+"B"
		IndRegua("TRB",cInd3,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd4  := Left(CriaTrab(Nil,.F.),7)+"C"
		IndRegua("TRB",cInd4,"ROMANEI+EMPRESA+CLIENTE+LOJA",,,OemToAnsi("Selecionando Registros..."))	//

		DbClearIndex()
		DbSetIndex(cIndice + OrdBagExt())
		DbSetIndex(cInd2 + OrdBagExt())
		DbSetIndex(cInd3 + OrdBagExt())
		DbSetIndex(cInd4 + OrdBagExt())		

	ElseIf MV_PAR07 == 5
		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"CEP+TRANSP+Dtos(DTENT)",,,OemToAnsi("Selecionando Registros..."))	//
		cInd2  := Left(CriaTrab(Nil,.F.),7)+"A" 
		IndRegua("TRB",cInd2,"Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd3  := Left(CriaTrab(Nil,.F.),7)+"B"
		IndRegua("TRB",cInd3,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd4  := Left(CriaTrab(Nil,.F.),7)+"C"
		IndRegua("TRB",cInd4,"ROMANEI+EMPRESA+CLIENTE+LOJA",,,OemToAnsi("Selecionando Registros..."))	//

		DbClearIndex()
		DbSetIndex(cIndice + OrdBagExt())
		DbSetIndex(cInd2 + OrdBagExt())
		DbSetIndex(cInd3 + OrdBagExt())
		DbSetIndex(cInd4 + OrdBagExt())		

	ElseIf MV_PAR07 == 1

		cIndice  := CriaTrab(Nil,.F.)
		IndRegua("TRB",cIndice,"Pedido+Dtos(DTENT)",,,OemToAnsi("Selecionando Registros..."))	//
		cInd2  := Left(CriaTrab(Nil,.F.),7)+"A" 
		IndRegua("TRB",cInd2,"Pedido",,,OemToAnsi("Selecionando Registros..."))	//
		cInd3  := Left(CriaTrab(Nil,.F.),7)+"B"
		IndRegua("TRB",cInd3,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//
		cInd4  := Left(CriaTrab(Nil,.F.),7)+"C"
		IndRegua("TRB",cInd4,"ROMANEI+EMPRESA+CLIENTE+LOJA",,,OemToAnsi("Selecionando Registros..."))	//

		DbClearIndex()
		DbSetIndex(cIndice + OrdBagExt())
		DbSetIndex(cInd2 + OrdBagExt())
		DbSetIndex(cInd3 + OrdBagExt())
		DbSetIndex(cInd4 + OrdBagExt())		

	EndIf

	Processa({||GeraCargas()},"Gerando as Cargas..")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  02/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraCargas()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	DbSelectArea("TRB")

	cMarca  := GetMark()

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	If !Empty(cEmpCons)
		AaDD(aBrowse,{"NOMEMP","","Empresa"})
	EndIf

	//	AaDD(aBrowse,{"ORDCARG","","Ord Carga"})
	AaDD(aBrowse,{"DTENT","","Entrega"})
	AaDD(aBrowse,{"DTAGEN","","Dt.Agenda"})
	AaDD(aBrowse,{"HRAGEN","","Hr.Agenda"})	
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"TPPED"  ,"","Tp Ped"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"FATANT","","Fat Antec"})	
	AaDD(aBrowse,{"PESO","","Peso Lib.","@E 999999"})
	AaDD(aBrowse,{"QTDPALL","","Paletes","@E 999999"})
	AaDD(aBrowse,{"QUANT","","Qtde Cxs","@E 999999"})
	AaDD(aBrowse,{"TOTPED","","Vlr Total","@E 999,999,999.99"})
	AaDD(aBrowse,{"TPFRETE","","Tp Frete"})
	AaDD(aBrowse,{"REGIAO","","Zona"})
	AaDD(aBrowse,{"DESCREG","","Desc. Zona"})
	AaDD(aBrowse,{"MUN","","Municipio"})
	AaDD(aBrowse,{"BAIRRO","","Bairro"})
	AaDD(aBrowse,{"EST","","Estado"})
	AaDD(aBrowse,{"CEP","","CEP","@R 99999-999"})
	AaDD(aBrowse,{"TRANSP","","Transportadora"})
	AaDD(aBrowse,{"DESCTRA","","Nome Transportadora"})
	AaDD(aBrowse,{"EMISSAO","","Emissao"})
	AaDD(aBrowse,{"PREVFAT","","Prev.Fat."})
	AaDD(aBrowse,{"LEADTIM","","Lead Time"})

	AaDD(aBrowse,{"PEDBON","","Ped Bonif"})
	AaDD(aBrowse,{"MENS","","Mens Nota"})

	TRB->(DbGoTop())

	Private oPeso, oQuant, oTotal, oVeiculo, oDescVeic, oCapacidade,oQtdPall, oTotPall,oTransp, oDescTra, oDtCarre 
	nPeso := nQuant := nTotal := nCapacidade := nQtdPall := nTotPall := 0

	cTpVeicRom := Space(2)
	cDescVeic  := Space(40)
	cTransp    := Space(6)
	cDescTra   := Space(40)
	cOrdCarg   := Space(3)
	dDtCarre   := MV_PAR10 

	TRB->(DbGoTop())

	//	AADD(aObjects,{ 10,015,.T.,.T.})
	AADD(aObjects,{ 10,05,.T.,.T.})

	aCores := {}

	//	Aadd(aCores, { 'OPER = "08"', "BR_PRETO" } )
	Aadd(aCores, { 'LIBPED = "T" .And. OPER <> "08"', "BR_AMARELO" } )
	Aadd(aCores, { 'LIBPED = "P" .And. OPER <> "08"', "BR_LARANJA" } )
	Aadd(aCores, { 'LIBPED = "E" .And. OPER <> "08"', "BR_AZUL" } )
	//	Aadd(aCores, { '!Empty(OBSINT) .Or. !Empty(OBSEXT)', "BR_VIOLETA" } )	

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	While .T.

		DEFINE MSDIALOG oDlg1 TITLE "Prepara as Cargas" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 20, 20 Say OemToAnsi("Transportadora : ") Size 70,8  OF odlg1 PIXEL
		@ 18, 63  MsGet oTransp  Var cTransp  Valid ChkTransp() F3 "SA4" Size 45,10   When .T. OF odlg1 PIXEL 

		@ 20, 120 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
		@ 18, 153  MsGet oDescTra   Var cDescTra   Size 145,10   When .F. OF odlg1 PIXEL

		@ 20, 450 Say OemToAnsi("Data Carregamento: ") Size 50,8  OF odlg1 PIXEL COLOR CLR_HBLUE 
		@ 18, 503  MsGet oDtCarre Var dDtCarre  Valid dDtCarre >= dDataBase Size 70,12   When .T. OF odlg1 PIXEL FONT ofont2 COLOR CLR_HBLUE

		@ 38, 20 Say OemToAnsi("Veiculo : ") Size 70,8  OF odlg1 PIXEL
		@ 36, 63  MsGet oVeiculo Var cTpVeicRom   Valid ChkTpVeic() F3 "DUT" Size 45,10   When .T. OF odlg1 PIXEL 

		@ 38, 120 Say OemToAnsi("Descricao: ") Size 50,8  OF odlg1 PIXEL
		@ 36, 153  MsGet oDescVeic Var cDescVeic Size 145,10   When .F. OF odlg1 PIXEL

		@ 38, 350 Say OemToAnsi("Capacidade: ") Size 50,8  OF odlg1 PIXEL
		@ 36, 403  MsGet oCapacidade Var nCapacidade Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		@ 38, 470 Say OemToAnsi("Qtd Palete: ") Size 50,8  OF odlg1 PIXEL
		@ 36, 503  MsGet oQtdPall Var nQtdPall Picture "@e 999999" Size 45,10   When .F. OF odlg1 PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
		//ณ arquivo de trabalho "TRB".                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+20 ,aPosObj[1,2]+1 ,aPosObj[1,3]-35,aPosObj[1,4]-1}) //,,,,,aCores)
		oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

		@ aPosObj[1,3]-20, 20 Say OemToAnsi("Tot Pal: ") Size 70,8  OF odlg1 PIXEL
		@ aPosObj[1,3]-22, 63  MsGet oTotPall Var nTotPall  Size 45,10  Picture "@E 999,999.99"  When .F. OF odlg1 PIXEL

		@ aPosObj[1,3]-20, 200 Say OemToAnsi("Qtde : ") Size 70,8  OF odlg1 PIXEL
		@ aPosObj[1,3]-22, 243  MsGet oQuant Var nQuant  Size 45,10  Picture "@E 9,999,999.99"  When .F. OF odlg1 PIXEL

		@ aPosObj[1,3]-20, 303 Say OemToAnsi("Peso Total: ") Size 70,8  OF odlg1 PIXEL
		@ aPosObj[1,3]-22, 363  MsGet oPeso Var nPeso  Size 45,10  Picture "@E 9,999,999.99"  When .F. OF odlg1 PIXEL

		//		@ aPosObj[1,3]-22, 503 Button "&Estorna Ped."     Size  75,20 Action {||EstorPed()} of oDlg1 Pixel FONT ofont2  //COLOR CLR_HBLUE  

		@ aPosObj[1,3]-22, 503 Button "&Ver Programacao"     Size  75,20 Action {||VerProg()} of oDlg1 Pixel FONT ofont2  //COLOR CLR_HBLUE

		ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

		If nOpca == 1

			lFirst  := .T.
			aTransp := {}
			aMeso   := {}

			lContinua := .T.
			//Checo os pedido que geraram Romaneio e Apago
			DbSelectArea("TRB")
			DbGoTop()
			While TRB->(!Eof())

				//				If Empty(TRB->ORDCARG) .And. !Empty(TRB->OK)
				//					lContinua := .F.
				//				EndIf

				If !Empty(TRB->OK)
					nPesq := Ascan(aTransp,TRB->TRANSP)
					If nPesq == 0
						Aadd(aTransp,TRB->TRANSP)
					EndIF     
				EndIf 
				DbSkip()

			End

			If Len(aTransp) > 1 
				MsgStop("Existe mais de um transportadora selecionada.")
				TRB->(DbGoTop())
				Loop 
			EndIf 

			If lContinua

				MsAguarde({||Gera_Romaneio()},"Preparando o Romaneio.." )

				//Checo os pedido que geraram Romaneio e Apago
				DbSelectArea("TRB")
				DbGoTop()
				While TRB->(!Eof())

					If !Empty(TRB->ROMANEI)
						RecLock("TRB",.F.)
						TRB->(DbDelete())
						MsUnlock()
					EndIf
					DbSkip()

				End

				aOrdCarg := {}
				cOrdCarg := Space(3) 
				TRB->(DbGoTop())

				If TRB->(Eof())
					MsgAlert("Ja foram gerados todos os romaneios..")
					Exit
				EndIf

			Else

				MsgStop("Falta informar ordem de carregamento..")
				TRB->(DbGotop())

			EndIf

		ElseIf nOpca == 2

			Exit

		EndIf

	End

	TRB->(DbCloseArea())

	If MV_PAR08 == 1 .And. Select("ZONA") > 0
		ZONA->(DbCloseArea())
	EndIf

	//Quando se tratar de carga paletizada ira gerar o pedido de pallet automaticamente 
	If MV_PAR09 == 2 

		//Vetor para guardar os pedidos de paletes a serem gerado
		aPedPalEmp := {} 
		aPedPalOut := {}

		DbSelectArea("PAL")
		DbGoTop()

		While PAL->(!Eof())

			If PAL->EMPRESA == SM0->M0_CODIGO
				AaDD(aPedPalEmp,{PAL->EMPRESA,PAL->ROMANEI,PAL->CLIENTE,PAL->LOJA,PAL->TOTPALL,PAL->TRANSP})
			Else
				AaDD(aPedPalOut,{PAL->EMPRESA,PAL->ROMANEI,PAL->CLIENTE,PAL->LOJA,PAL->TOTPALL,PAL->TRANSP})			
			EndIF  

			DbSelectArea("PAL")
			DbSkip()

		End

		PAL->(DbCloseArea())


		If Len(aPedPalEmp) > 0

			cEmpTrans := aPedPalEmp[1,1]
			cFiltrans := "01"

			U_ProcPedPal(cEmpTrans,cFilTrans,aPedPalEmp,.F. )

		EndIf 

		If Len(aPedPalOut) > 0

			cEmpTrans := aPedPalOut[1,1]
			cFiltrans := "01"

			U_ProcPedPal(cEmpTrans,cFilTrans,aPedPalOut,.T. )
			//STARTJOB("U_ProcPedPal",getenvserver(),.t.,cEmpTrans,cFilTrans,aPedPalOut,.T. )

		EndIf 

	EndIf 


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
	If nTipo == 1
		DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcPedido() TOOLTIP OemToAnsi("Procura Pedido...")
		DEFINE BUTTON RESOURCE "SDUPROP"  OF oBar GROUP ACTION SelTransp() TOOLTIP OemToAnsi("Seleciona Transportadora...")
		//		DEFINE BUTTON RESOURCE "BMPINCLUIR" OF oBar GROUP ACTION PegaRom() TOOLTIP OemToAnsi("Adiciona pedido ao Romaneio...")
		//		DEFINE BUTTON RESOURCE "EDIT" OF oBar GROUP ACTION EditOrd() TOOLTIP OemToAnsi("Ordena o carregamento...")
		//		DEFINE BUTTON RESOURCE "S4WB009N" OF oBar GROUP ACTION EstorPed() TOOLTIP OemToAnsi("Estorna o pedido ...")
		//		DEFINE BUTTON RESOURCE "UP_MDI" OF oBar GROUP ACTION EditObs(1) TOOLTIP OemToAnsi("Edita a Observacao Interna...")
		//		DEFINE BUTTON RESOURCE "UP_MDI" OF oBar GROUP ACTION EditObs(2) TOOLTIP OemToAnsi("Edita a Observacao Externa...")
		//		DEFINE BUTTON RESOURCE "S4WB009N" OF oBar GROUP ACTION MostraPed() TOOLTIP OemToAnsi("Visualiza o Pedido de Venda...")
	Else
		DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcGrupo() TOOLTIP OemToAnsi("Procura o Grupo...")
	EndIf
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณFA060Disp ณ Autor ณ Carlos R. Moreira     ณ Data ณ 09/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exibe Valores na tela									  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Especifico Escola Graduada                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Fa060Disp(cMarca,lInverte,nModo)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf

	If nModo == 2  

		Return   

	EndIf 

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))

	If !Empty(SA1->A1_TPVEICU) .And. cTpVeicRom # "99" .And. cTpVeicRom # "98" 

		If SA1->A1_TPVEICU < cTpVeicRom

			MsgStop("Tipo de veiculo nใo aceito pelo Cliente ")

			DbSelectArea("TRB")
			RecLock("TRB",.F.) 
			TRB->OK := Space(2)
			MsUnlock()

			oMark:oBrowse:Refresh(.t.)
			Return

		EndIf 

	EndIf 

	If nModo == 1

		nPeso :=  nQuant := nTotPall := 0

		nRecTRB := TRB->(Recno())

		DbSelectArea("TRB")
		DbGoTop()

		While TRB->(!Eof())

			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf

			nPeso    += TRB->PESO
			nQuant   += TRB->QUANT
			nTotPall += TRB->QTDPALL

			DbSkip()

		End

		TRB->(DbGoTo(nRecTRB))
		If MV_PAR09 == 1 //Carga Batida   

			If nPeso > nCapacidade 

				MsgStop("Peso ultrapassa a capacidade do veiculo.")

				DbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->OK := Space(2)
				MsUnlock()

				nPeso :=  nQuant := nTotPall := 0

				DbSelectArea("TRB")
				DbGoTop()

				While TRB->(!Eof())

					If Empty(TRB->OK)
						DbSkip()
						Loop
					EndIf

					nPeso  += TRB->PESO
					nQuant += TRB->QUANT
					nTotPall += TRB->QTDPALL 

					DbSkip()

				End

				TRB->(DbGoTo(nRecTRB))

				oPeso:Refresh()
				oQuant:Refresh()
				oTotPall:Refresh()				

				oMark:oBrowse:Refresh(.t.)
				DlgRefresh(oDlg1)

				Return

			EndIf 

		Else

			If nTotPall > nQtdPall 

				MsgStop("Qtd de Palete ultrapassa a capacidade do veiculo.")

				DbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->OK := Space(2)
				MsUnlock()

				nPeso :=  nQuant := nTotPall := 0

				DbSelectArea("TRB")
				DbGoTop()

				While TRB->(!Eof())

					If Empty(TRB->OK)
						DbSkip()
						Loop
					EndIf

					nPeso  += TRB->PESO
					nQuant += TRB->QUANT
					nTotPall += TRB->QTDPALL 

					DbSkip()

				End

				TRB->(DbGoTo(nRecTRB))

				oPeso:Refresh()
				oQuant:Refresh()
				oTotPall:Refresh()			

				oMark:oBrowse:Refresh(.t.)
				DlgRefresh(oDlg1)

				Return

			EndIf 

		EndIf   

		TRB->(DbGoTo(nRecTRB))

		If Empty(TRB->TRANSP)

			//		MsgStop("Transportadora em branco. Selecione a transportadora.")

			DbSelectArea("TRB")
			RecLock("TRB",.F.) 
			TRB->TRANSP := cTransp 
			MsUnlock()

			oMark:oBrowse:Refresh(.t.)
			//		Return

		EndIf  


		/*
		If Empty(TRB->ORDCARG)

		cOrdCarg := StrZero(Val(cOrdCarg) + 1,3)

		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->ORDCARG := cOrdCarg
		MsUnlock()

		oMark:oBrowse:Refresh(.t.)
		//	Return

		EndIf 
		*/
		oPeso:Refresh()
		oTotPall:Refresh()		
		//oTotal:Refresh()
		oQuant:Refresh()

	EndIf

	If !Empty(TRB->PEDBON)
		TRB->(DbSetOrder(2))
		cPedBon := TRB->PEDBON
		nRecTrb := TRB->(Recno())
		If !TRB->(DbSeek(cPedBon))
			MsgStop("Pedido Correspondente nao Liberado..")
			TRB->(DbGoTo(nRecTrb))
			DbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->OK := Space(2)
			MsUnlock()
		Else
			DbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->OK     := If(Empty(TRB->OK),cMarca,Space(2))
			TRB->TRANSP := cTransp 
			cMarTrb := TRB->OK
			MsUnlock()
			TRB->(DbGoTo(nRecTrb))
			DbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->OK := cMarTrb
			TRB->TRANSP := cTransp			
			MsUnlock()
		EndIF
		TRB->(DbSetOrder(1))
	EndIf

	oMark:oBrowse:Refresh(.t.)
	DlgRefresh(oDlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEGF003    บAutor  ณMicrosiga           บ Data ณ  02/19/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fa060Inverte(cMarca,nModo)
	Local nReg := TRB->(Recno())
	Local cAlias := Alias()
	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		RecLock("TRB")
		TRB->OK := IIF(TRB->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	TRB->(dbGoto(nReg))

	If nModo == 1
		nPeso :=  nQuant := nTotal := 0

		nRecTRB := TRB->(Recno())

		DbSelectArea("TRB")
		DbGoTop()

		While TRB->(!Eof())

			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf

			nPeso  += TRB->PESO
			nQuant += TRB->QUANT
			nTotal += TRB->TOTPED

			DbSkip()

		End

		TRB->(DbGoTo(nRecTRB))

		oPeso:Refresh()
		//oTotal:Refresh()
		oQuant:Refresh()
	EndIf

	oMark:oBrowse:Refresh(.t.)
	DlgRefresh(oDlg1)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcTranspบAutor  ณCarlos R. Moreira   บ Data ณ  03/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona a transportadora para a montagem da Carga         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function ProcPedido()
	Local cPedido := Space(06)
	Local oDlgProc

	cTitProc := "Procura Pedido"

	DEFINE MSDIALOG oDlgProc TITLE cTitProc From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite Pedido: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cPedido Size 60,10 of oDlgProc Pixel


	@ 50, 90 BMPBUTTON TYPE 1 Action PosPed(@cPedido,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosPed(cPedido,oDlgProc)

	TRB->(DbSetOrder(2))
	TRB->(DbSeek(Alltrim(cPedido),.T.))

	TRB->(DbSetOrder(1))
	Close(oDlgProc)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelTransp บAutor  ณCarlos R. Moreira   บ Data ณ  12/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as Transportadoras para a Regiao                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SelTransp()
	Local aTransp := {}
	Local oDlgProc
	Local oCbx
	Local aArea := GetArea()

	Private cTransp := Space(6)

	/*	If TRB->TPFRETE == "F"
	MsgStop("Pedido FOB nao pode ser alterada a Transportadora..")
	Return
	EndIf */ 

	DbSelectArea("SA4")
	DbSetOrder(1)
	DbGoTop()

	//DbSeek(xFilial("SA4")+TRB->REGIAO )

	While SA4->(!Eof())

		AaDd(aTransp, SA4->A4_COD+'-'+SA4->A4_NOME )

		SA4->(DbSkip())

	End

	lRedespacho := .F.

	DEFINE MSDIALOG oDlgProc TITLE "Seleciona Transportadora" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15, 10 COMBOBOX oCbx VAR cTransp ITEMS aTransp SIZE 140, 27 OF oDlgProc PIXEL

	//@ 50, 60 BMPBUTTON TYPE 5 Action GravTransp(@cTransp,oDlgProc,.T.)
	@ 50, 90 BMPBUTTON TYPE 1 Action GravTransp(@cTransp,oDlgProc,.F.,lRedespacho)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  05/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravTransp(cTransp,oDlgProc,lTodos)

	If !lTodos
		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->TRARED  := If(lRedespacho,cTransp,"")
		TRB->DESCTRA := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")
		TRB->REDESP  := If(lRedespacho,"S","N")
		TRB->TRANSP  := cTransp
		TRB->DESTRAR := If(lRedespacho,Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")," ")

		MsUnlock()
	Else
		DbSelectArea("TRB")
		DbGoTop()

		While (!Eof())

			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf
			RecLock("TRB",.F.)
			TRB->TRARED  := cTransp
			TRB->DESCTRA := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")
			TRB->REDESP  := If(lRedespacho,"S","N")
			MsUnlock()
			DbSkip()
		End
	EndIf
	Close(oDlgProc)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  12/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ira gerar o romaneio                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gera_Romaneio()

	If !ExisteSX6("MV_ROMANE")
		CriarSX6("MV_ROMANE","C","Numero sequencial do Romaneio.","")
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra checar se existe valor de frete para o Romaneio ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cRedespacho := "N"

	nQtdCxs   := 0
	nQtdPalle := 0
	nPalleRom := 0
	cTransp   := Space(6)
	nPesoRom  := 0
	nVlrRom   := 0

	lTemSel := .F.

	DbSelectArea("TRB")
	DbGoTop()

	While TRB->(!Eof())

		If Empty(TRB->OK)
			TRB->(DbSkip())
			Loop
		EndIf

		lTemSel := .T.

		nPesoRom += TRB->PESO

		cTransp := TRB->TRANSP

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+TRB->PEDIDO )

		While SC9->(!Eof()) .And. TRB->PEDIDO == SC9->C9_PEDIDO

			If !Empty(SC9->C9_ROMANEI)
				SC9->(DbSkip())
				Loop
			EndIf

			If  !Empty(SC9->C9_BLCRED)
				SC9->(DbSkip())
				Loop
			EndIf

			nQtdCxs  := SC9->C9_QTDLIB
			nQtdPalle := 0

			DbSelectArea("SC9")
			DbSkip()

		End

		DbSelectArea("TRB")
		DbSkip()

	End

	// Verifica se existe algum pedido para gerar Romaneio
	If !lTemSel
		MsgStop("Nao houve selecao de nenhum pedido")
		Return
	EndIf

	If ! MsgYesNo("Deseja realmente gerar o romaneio..")
		Return
	EndIf

	cVeiculo := Space(8)

	/*
	If cTransp == "000001" //Transporte proprio

	cVeiculo   := GetVeiculo()

	//    cMotorista := GetMotoris()

	EndIf
	*/ 
	aRomaneios := {}
	nQtdCxs    := 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//	cNomArq  := CriaTrab(nil,.f.)
	//	IndRegua("TRB",cNomArq,"TRANSP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("TRB")
	DbSetOrder(3)
	DbGoTop()

	While TRB->(!Eof())

		If Empty(TRB->OK)
			TRB->(DbSkip())
			Loop
		EndIf

		If !Empty(TRB->ROMANEI)
			cRomaneio := TRB->ROMANEI
			lGravNumRom := .F.
		Else
			cRomaneio := StrZero(Val(GetMv("MV_ROMANE"))+1,6)
			lGravNumRom := .T.
		EndIf

		nPesq := Ascan(aRomaneios,cRomaneio)
		If nPesq == 0
			AAdd(aRomaneios,cRomaneio)
		EndIf

		cTransp   := TRB->TRANSP
		nPesoRom  := 0
		nPalleRom := 0
		lGerou    := .F.
		nOrdCarg  := 1 

		//cTpFrete := " "
		//	cMesoRom := TRB->REGIAO

		While TRB->(!Eof()) .And. cTransp == TRB->TRANSP

			If Empty(TRB->OK)
				TRB->(DbSkip())
				Loop
			EndIf

			lGerou := .T.

			nPesoRom += TRB->PESO
			nVlrRom  += TRB->TOTPED
			cOrdCarg := StrZero(nOrdCarg,3) 

			cPedido := TRB->PEDIDO
			cArq := "SC5"+TRB->EMPRESA+"0"

			If TRB->FATANT == "S"

				// Atualiza dados do pedido de venda 
				//-------------------------------------------------------------------------------------
				cQuery2 := " UPDATE " + cArq + " SET C5_TRANSP = '"+cTransp+"', C5_ROMANEI ='"+cRomaneio+"' "
				cQuery2 += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedido  +"' and C5_FILIAL='" + xFilial("SC5") + "' "


			Else 
				// Atualiza dados do pedido de venda 
				//-------------------------------------------------------------------------------------
				cQuery2 := " UPDATE " + cArq + " SET C5_TRANSP = '"+cTransp+"',C5_STAPED = 'T', C5_ROMANEI ='"+cRomaneio+"' "
				cQuery2 += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedido  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

			EndIf   

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Status Financeiro do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
			EndIf

			nQtdCxs  += TRB->QUANT 

			cArq := "SC9"+TRB->EMPRESA+"0"
			// Atualiza dados do pedido de venda 
			//-------------------------------------------------------------------------------------
			cQuery2 := " UPDATE " + cArq + " SET C9_ROMANEI = '"+cRomaneio+"', C9_TRAROM = '"+cTransp+"', C9_EMIROM ='"+Dtos(dDataBase)+"', "
			cQuery2 += "                    C9_ORDCARG = '"+cORDCARG+"' , C9_TIPOVEI ='"+cTpVeicRom+"', C9_DTCARRE = '"+Dtos(dDtCarre)+"', "
			cQuery2 += "                    C9_TPCARRO='"+STR(MV_PAR09,1)+"' "
			cQuery2 += " Where D_E_L_E_T_='' and C9_PEDIDO='"+ cPedido  +"' and C9_FILIAL='" + xFilial("SC9") + "' "

			If (TCSQLExec(cQuery2) < 0)
				Return MsgStop("Falha na atualizacao do Status Financeiro do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
			EndIf

			//Gravo os itens do Romaneio 
			DbSelectArea("ZZR")
			RecLock("ZZR",.T.)
			ZZR->ZZR_FILIAL  := xFilial("ZZR")
			ZZR->ZZR_EMP     := TRB->EMPRESA
			ZZR->ZZR_ROMANE  := cRomaneio
			ZZR->ZZR_PEDIDO  := cPedido 
			ZZR->ZZR_CLIENTE := TRB->CLIENTE
			ZZR->ZZR_LOJA    := TRB->LOJA
			ZZR->ZZR_NOME    := TRB->NOME
			ZZR->ZZR_ORDCAR  := TRB->ORDCARG
			ZZR->ZZR_ZONA    := TRB->REGIAO
			ZZR->ZZR_DESZONA := TRB->DESCREG
			ZZR->ZZR_PESO    := TRB->PESO
			ZZR->ZZR_QTDPED  := TRB->QUANT
			ZZR->ZZR_DTAGEN  := TRB->DTAGEN 
			ZZR->ZZR_ENTREG  := TRB->DTENT
			ZZR->ZZR_VLRPED  := TRB->TOTPED 
			ZZR->ZZR_QTDPAL  := TRB->QTDPALL
			ZZR->ZZR_FATANT  := TRB->FATANT
			ZZR->ZZR_TPPED   := TRB->TPPED 
			ZZR->ZZR_MUN     := TRB->MUN
			ZZR->ZZR_EST     := TRB->EST
			ZZR->ZZR_HRAGEN  := TRB->HRAGEN
			MsUnlock()

			nOrdCarg++

			DbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->ROMANEI := cRomaneio
			MsUnlock()
			DbSkip()

		End

		//Atualiza a numeracao do romaneio
		If lGerou

			DbSelectArea("ZZQ")
			RecLock("ZZQ",.T.)
			ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
			ZZQ->ZZQ_ROMANE := cRomaneio
			ZZQ->ZZQ_EMIROM := dDataBase 
			ZZQ->ZZQ_TRANSP := cTransp 
			ZZQ->ZZQ_DESTRA := cDescTra
			ZZQ->ZZQ_DTCARR := dDtCarre
			ZZQ->ZZQ_ENTREG := dDtCarre 
			ZZQ->ZZQ_TPVEIC := cTpVeicRom
			ZZQ->ZZQ_DESVEI := cDescVeic
			ZZQ->ZZQ_TPCARG := STR(MV_PAR09,1)
			ZZQ->ZZQ_PESO   := nPesoRom
			ZZQ->ZZQ_QTDCXS := nQtdCxs
			ZZQ->ZZQ_VLRROM := nVlrRom 
			ZZQ->ZZQ_STATUS := "B"
			MsUnlock()  

			If lGravNumRom
				DbSelectArea("SX6")
				DbSeek("  MV_ROMANE")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := cRomaneio
				MsUnlock()
			EndIf


		EndIf

	End

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//	cNomArq  := CriaTrab(nil,.f.)
	//	IndRegua("TRB",cNomArq,"ROMANEI+CLIENTE+LOJA+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	//Quando for carga peletizada sera criado o pedido de venda automaticamente
	If MV_PAR09 == 2 

		Processa({||GeraPedPal()},"Gerando o pedido de Pallets.." )

	EndIf 

	cRomIni := Space(6)
	DbSelectArea("TRB")
	DbGotop()
	lPri := .T.

	While TRB->(!Eof())

		If Empty(TRB->ROMANEI)
			DbSkip()
			Loop
		EndIf

		If lPri
			cRomIni := TRB->ROMANEI
			lPri := .F.
		EndIf

		DbSkip()

	End
	DbGobottom()
	cRomfim := TRB->ROMANEI
	dDataIni := dDatabase
	dDataFim := dDataBase
	DDtCarIn := dDtCarre   
	dDtCarFi := dDtCarre 


	If MV_PAR09 == 1 

		If MsgYesNo("Deseja imprimir agora o Romaneio")

			Processa({||U_GeraTrab()},"Gerando o Arquivo...")

		Else

			For nRom := 1 to Len(aRomaneios)

				MsgInfo( "Romaneio n "+StrZero(Val(aRomaneios[nRom]),6) )

			Next

		EndIf

	Else

		MsgInfo("Por se tratar de uma carga paletizada. o Romaneio: "+cRomIni+" Deve ser impresso pela rotina de impressao de romaneio")

	EndIf 

	//    EndIf 

	//	Processa({||u_Imp_Roman()},"Imprimindo romaneio....")


	TRB->(DbSetOrder(1))
	TRB->(DbGotop())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditObs   บAutor  ณCarlos R Moreira    บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtribui uma observacao ao Romaneio                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EditOrd()
	Local cOrdCarg := Space(3)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Ordem de Carregamento" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,295 of oDlgProc PIXEL

	@ 15,5 Say "Ordem: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cOrdCarg Picture "@E 999" Valid ChkOrd(@cOrdCarg) Size 20 ,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action GrvOrd(@cOrdCarg,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvOrd(cOrdCarg,oDlgProc)

	DbSelectArea("TRB")
	RecLock("TRB",.F.)
	//	TRB->OK      := cMarca
	TRB->ORDCARG := cOrdCarg
	MsUnlock()

	Close(oDlgProc)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณCarlos R. Moreira   บ Data ณ  23/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra selecionar os pedidos de Vendas                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraTrb1()
	Local aCampos := {}
	Local aArq := {{"SC9"," "},{"SC5"," "},{"SA1"," "},{"SB1"," "},{"SA4"," "},{"SC6"," "},{"SF4"," "}}

	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )
	AADD(aCampos,{ "PROD"    ,"C",15,0 } )  // Normal seria 30 porem irei utilizar somente 15 posicoes
	AADD(aCampos,{ "PEDIDO"  ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE" ,"C",06,0 } )
	AADD(aCampos,{ "LOJA"    ,"C",03,0 } )
	AADD(aCampos,{ "NOME"    ,"C",20,0 } )
	AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
	AADD(aCampos,{ "DTENT"   ,"D", 8,0 } )
	AADD(aCampos,{ "DTAGEN"  ,"D", 8,0 } )
	AADD(aCampos,{ "PESO"    ,"N",11,0 } )
	AADD(aCampos,{ "QTDCX"   ,"N",11,0 } )
	AADD(aCampos,{ "REGIAO"  ,"C",04,0 } )
	AADD(aCampos,{ "DESCREG" ,"C",20,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,4 } )
	AADD(aCampos,{ "TRANSP"  ,"C",06,0 } )
	AADD(aCampos,{ "DESCTRA" ,"C",20,0 } )
	AADD(aCampos,{ "EMPRESA" ,"C", 2,0 } )
	AADD(aCampos,{ "PALLET"  ,"C", 1,0 } )
	AADD(aCampos,{ "ANTENTR" ,"C", 1,0 } )
	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )
	AADD(aCampos,{ "OBS"     ,"C",40,0 } )
	AADD(aCampos,{ "EST"     ,"C", 2,0 } )
	AADD(aCampos,{ "MUN"     ,"C",30,0 } )
	AADD(aCampos,{ "PEDCLI"  ,"C",15,0 } )
	AADD(aCampos,{ "TPFRERO" ,"C", 1,0 } )
	AADD(aCampos,{ "PRCFRE"  ,"N",15,2 } )
	AADD(aCampos,{ "TRAROM"  ,"C",06,0 } )
	AADD(aCampos,{ "VLRROM"  ,"N",15,2 } )
	AADD(aCampos,{ "REDESP"  ,"C", 1,0 } )
	AADD(aCampos,{ "ORDCARG"  ,"C", 1,0 } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB1", if(.T. .OR. .F., !.F., NIL), .F. )

	DbSelectArea("TRB1")
	IndRegua("TRB1",cNomArq,"ROMANEI+ORDCARG+PEDIDO+PROD",,,OemToAnsi("Selecionando Registros..."))	//

	aCampos := {}
	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )
	AADD(aCampos,{ "PROD"    ,"C",30,0 } )
	AADD(aCampos,{ "DESC"    ,"C",30,0 } )
	AADD(aCampos,{ "PESO"    ,"N",11,0 } )
	AADD(aCampos,{ "QTDCX"   ,"N",11,0 } )
	AADD(aCampos,{ "PALLET"  ,"N",11,0 } )
	AADD(aCampos,{ "CXAVUL"  ,"N",11,0 } )
	AADD(aCampos,{ "CLIENTE" ,"C", 6,0 } )

	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB2", if(.T. .OR. .F., !.F., NIL), .F. )

	DbSelectArea("TRB2")
	IndRegua("TRB2",cNomArq,"ROMANEI+PROD",,,OemToAnsi("Selecionando Registros..."))	//

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

		cQuery += " SELECT	'"+aEmp[nEmp]+"' EMPRESA, SC9.C9_PEDIDO, SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_ITEM, SC9.C9_TRAROM, SC9.C9_ROMANEI, "
		cQuery += " 		SC9.C9_TPFRERO, SC9.C9_PRCFRET,SC9.C9_QTDLIB, SC9.C9_PRODUTO,SC9.C9_PRCVEN, SC9.C9_BLCRED, SC9.C9_BLEST, "
		cQuery += "     SC9.C9_ORDCARG, "
		cQuery += " 		SC5.C5_EMISSAO, SC5.C5_DTAGEN, SC5.C5_FECENT, SC5.C5_TIPO, " //SC5.C5_PEDCLI,
		cQuery += "         SC6.C6_TES, SF4.F4_IPI, "
		cQuery += "         SA1.A1_NOME, SA1.A1_EST, SA1.A1_MUN, SA1.A1_TIPO, SA1.A1_GRPTRIB,SA1.A1_FATANT, 
		cQuery += "         SB1.B1_PESBRU,SB1.B1_GRTRIB, SB1.B1_IPI, SB1.B1_DESC "
		//		cQuery += "         SZN.ZN_REGIAO, SZN.ZN_DESREG "
		cQuery += " FROM   "+aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9  "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5 ON   "
		cQuery += "                       SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "                       SC9.C9_PEDIDO = SC5.C5_NUM "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON   "
		cQuery += "                       SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "                       SB1.B1_COD = SC9.C9_PRODUTO "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SC6" }),2]+" SC6 ON "
		cQuery += "                       SC6.D_E_L_E_T_ <> '*' AND "
		cQuery += "                       SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_PEDIDO = SC6.C6_NUM "
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
		cQuery += "                       SA1.D_E_L_E_T_ <> '*' AND  "
		cQuery += "                       SC9.C9_CLIENTE = SA1.A1_COD AND SC9.C9_LOJA = SA1.A1_LOJA "
		//		cQuery += "                       JOIN  "+aArq[Ascan(aArq,{|x|x[1] = "SZN" }),2]+" SZN ON "
		//		cQuery += "                       SZN.D_E_L_E_T_ <> '*' AND "
		//		cQuery += "                       SA1.A1_COD_MUN = SZN.ZN_CODMUN AND SA1.A1_EST = SZN.ZN_EST "
		//	cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SA4" }),2]+" SA4 ON "
		//	cQuery += "                       SC9.C9_TRAROM = SA4.A4_COD AND SA4.D_E_L_E_T_ <> '*'"
		cQuery += "                       JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SF4" }),2]+" SF4 ON "
		cQuery += "                       SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ <> '*'  AND SF4.F4_FILIAL = SC6.C6_FILIAL "

		cQuery += "                       WHERE SC9.D_E_L_E_T_ <> '*'  "
		cQuery += " 					        AND SC9.C9_ROMANEI BETWEEN  '"+cRomIni+"' AND '"+cRomFim+"' "

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C5_EMISSAO","D")
	TCSetField("QRY","C5_FECENT","D")
	TCSetField("QRY","C5_DTAGEN","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Gerando as selecao de Pedido de vendas...")

		DbSelectArea("TRB1")
		If !DbSeek(QRY->C9_ROMANEI+QRY->C9_PEDIDO) //+QRY->C9_PRODUTO )
			RecLock("TRB1",.T.)
			//TRB1->PROD    := QRY->C9_PRODUTO
			TRB1->PEDIDO  := QRY->C9_PEDIDO
			TRB1->CLIENTE := QRY->C9_CLIENTE
			TRB1->LOJA    := QRY->C9_LOJA
			TRB1->NOME    := QRY->A1_NOME
			TRB1->EMISSAO := QRY->C5_EMISSAO
			TRB1->DTENT   := QRY->C5_ENTREG
			TRB1->DTAGEN  := QRY->C5_DTAGEN
			TRB1->QUANT   := QRY->C9_QTDLIB
			TRB1->QTDCX   := QRY->C9_QTDLIB
			TRB1->PESO    := QRY->C9_QTDLIB * QRY->B1_PESBRU
			//			TRB1->REGIAO  := QRY->ZN_REGIAO
			//			TRB1->DESCREG := QRY->ZN_DESREG
			TRB1->TRANSP  := QRY->C9_TRAROM
			TRB1->EMPRESA := QRY->EMPRESA
			TRB1->EST     := QRY->A1_EST
			TRB1->MUN     := QRY->A1_MUN
			TRB1->ROMANEI := QRY->C9_ROMANEI
			//TRB1->PEDCLI  := QRY->C5_PEDCLI
			//TRB1->TPFRERO := QRY->C9_TPFRERO
			//TRB1->PRCFRE  := QRY->C9_PRCFRET
			TRB1->TRAROM  := QRY->C9_TRAROM
			TRB1->REDESP  := "N"
			TRB1->ORDCARG := QRY->C9_ORDCARG
			MsUnlock()
		Else
			Reclock("TRB1",.F.)
			TRB1->PESO   += QRY->C9_QTDLIB * QRY->B1_PESBRU
			TRB1->QTDCX  += QRY->C9_QTDLIB
			//TRB1->PRCFRE += QRY->C9_PRCFRET
			MsUnlock()
		EndIf

		DbSelectArea("TRB2")
		If !DbSeek(	QRY->C9_ROMANEI+QRY->C9_PRODUTO)
			RecLock("TRB2",.T.)
			TRB2->ROMANEI := QRY->C9_ROMANEI
			TRB2->PROD    := QRY->C9_PRODUTO
			TRB2->DESC    := QRY->B1_DESC
			TRB2->CLIENTE := QRY->C9_CLIENTE
			TRB2->PESO    := QRY->C9_QTDLIB * QRY->B1_PESBRU
			TRB2->QTDCX   := QRY->C9_QTDLIB
			MsUnlock()
		Else
			RecLock("TRB2",.F.)
			TRB2->PESO   += QRY->C9_QTDLIB * QRY->B1_PESBRU
			TRB2->QTDCX  += QRY->C9_QTDLIB
			MsUnlock()
		EndIf

		DbSelectArea("QRY")
		DbSkip()

	End

	QRY->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  12/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PegaTpFre(cTpFrete)
	Local oDlg2
	Private nRadio := 1
	Private oRadio
	Private cNomTrans := cTransp+"-"+Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	DEFINE MSDIALOG oDlg2 TITLE "Sel.Tipo Frete " From 9,0 To 27,60 OF oMainWnd

	@ 05,05 TO 115, 80 TITLE "Tipo Frete"
	@ 45,20 RADIO oRadio Var nRadio Items "Fracionado","Lotacao","Cubagem" 3D SIZE 60,10 of oDlg2 Pixel

	@ 05,85 TO 35,235 TITLE "Tranportadora"
	@ 15,90 MSGet cNomTrans  Size 140 ,10 When .F. of oDlg2 Pixel

	@ 40,85 TO 70,235 TITLE "Peso Carga"
	@ 52,90 MSGet nPesoRom Picture "@E 99,999,999.99" Size  120 ,10 When .F. of oDlg2 Pixel COLOR CLR_HBLUE FONT oFonte RIGHT

	@ 75,85 TO 115,235 TITLE "Qtd Pallets"
	@ 87,90 MSGet nPalleRom Picture "@E 99,999,999.99" Size 120 ,10 When .F. of oDlg2 Pixel COLOR CLR_HBLUE FONT oFonte RIGHT

	@ 122,200 BMPBUTTON TYPE 1 ACTION Close(oDlg2)


	ACTIVATE DIALOG oDlg2 CENTER

	cTpFrete := If(nRadio==1,"F",If(nRadio==2,"L","C") )

Return cTpFrete

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  12/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GraFreRom()

	If cTpFrete == "C"

		// Tratamento para quantidade, especie e Peso C๚bico automแtica para levar para o Danfe.
		nQtdTot := 0
		nQtdCub := 0

		DbSelectArea("SC9")
		DbSetOrder(9)
		DbSeek(xFilial("SC9")+cRomaneio )

		While SC9->(!Eof()) .And. cRomaneio == SC9->C9_ROMANEI

			nPesCub := POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_PESCUB")
			If nPesCub > 0
				nQtdCub += SC9->C9_QTDLIB  // PARA DEPOIS FORMAR O F2_PESOCUB
			EndIf

			nQtdTot += SC9->C9_QTDLIB

			DbSelectarea("SC9")
			DbSkip()

		End

		nPeso_BrtNF := nPesoRom  // PESO BRUTO SOMENTE DESTA NF PARA DEPOIS CALCULAR PESO CUBICO
		nTPESO_CUB := 0
		If nQtdCub > 0
			nTPESO_CUB := ((nPeso_BrtNF - ( 10 * nQtdCub)) + ( nQtdCub * 24.63))     // PESO CUBICO DA NOTA ATUAL
		Else
			nTPESO_CUB := nPeso_BrtNF
		EndIf

	ElseIf cTpFrete == "F"

		aPedidos := {}

		DbSelectArea("SC9")
		DbSetOrder(9)
		DbSeek(xFilial("SC9")+cRomaneio )

		While SC9->(!Eof()) .And. cRomaneio == SC9->C9_ROMANEI

			nVlrItem :=  CalcItem("SC9")

			nPesq := Ascan(aPedidos,{|x|x[1]=SC9->C9_PEDIDO})
			If nPesq == 0
				AaDd(aPedidos,{SC9->C9_PEDIDO,nVlrItem})
			Else
				aPedidos[nPesq,2] += nVlrItem
			EndIf

			DbSelectarea("SC9")
			DbSkip()

		End

		//	nTotMunicip := Len(aMunicip)

	Else

		nPalleRom := 0
		lMercPalle := .F.

		DbSelectArea("SC9")
		DbSetOrder(9)
		DbSeek(xFilial("SC9")+cRomaneio )

		While SC9->(!Eof()) .And. cRomaneio == SC9->C9_ROMANEI

			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO ))

			SA1->(DbSetorder(1))
			SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

			nQtdCxs  := SC9->C9_QTDLIB
			nQtdPalle := 0
			SA7->(DbSetOrder(1))
			If SA7->(DbSeek(xFilial("SA7")+SC9->C9_CLIENTE+SC9->C9_LOJA+SC9->C9_PRODUTO))
				nQtdPalle := SA7->A7_CXPALLE
			EndIf

			If nQtdPalle == 0
				nQtdPalle := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_QTPALLE")
			EndIf

			If nQtdPalle > 0
				nPalleRom += Int(( nQtdCxs / nQtdPalle )) + If(Mod(nQtdCxs , nQtdPalle) > 0 , 1 , 0 )
			Else
				nPalleRom += 0
			EndIf

			DbSelectarea("SC9")
			DbSkip()

		End

	EndIf

	nTotFre    := 0
	nVlrFreLot := 0

	DbSelectArea("SC9")
	DbSetOrder(9)
	DbSeek(xFilial("SC9")+cRomaneio )

	While SC9->(!Eof()) .And. cRomaneio == SC9->C9_ROMANEI

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO ))

		nPreFre := 0
		nPreFreNeg := 0

		If SC9->C9_TRAROM == "000000"
			SC9->(DbSkip())
			Loop
		EndIf


		DbSelectArea("SZ2")
		DbSetOrder(2)
		If DbSeek(xFilial("SZ2")+SC9->C9_TRAROM+cMesoRom)
			If cTpFrete == "F"
				nPrefre := Round(( SC9->C9_QTDLIB * SB1->B1_PESBRU ),0) * ( If(nTotFreNeg == 0,SZ2->Z2_VLFREFR,nTotFreNeg) / 1000 )
				nPerc   := Round(( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0)/ Round(nPesoRom,0) ),2)
				If SZ2->Z2_TXCTRC > 0

					nPesq := Ascan(aPedidos,{|x|x[1]=SC9->C9_PEDIDO})

					nVlrItem := CalcItem("SC9")

					nPercCTRC := Round( nVlrItem / aPedidos[nPesq,2], 2 )

					nPreFre += Round( SZ2->Z2_TXCTRC  * nPercCTRC ,2)

				EndIf

				If SZ2->Z2_PEDAGIO > 0
					nFraPedagio := Int( nPesoRom / 100 ) + If(Mod(nPesoRom,100) > 0 , 1 , 0 )
					nVlrPedag := Round(( (SZ2->Z2_PEDAGIO / 1000 ) * 100 ) * nFraPedagio,2)

					nPreFre += Round(nVlrPedag * nPerc,2)

				EndIf

				If SZ2->Z2_ADVALOR > 0
					nAdValor := CalcAdValor()

					nPreFre += nAdValor
				EndIf

				If SZ2->Z2_GRIS > 0
					nGRIS := CalcGRIS()

					nPreFre += nGRIS
				EndIf


				If SZ2->Z2_ICMS > 0
					nPreFre := Round(nPreFre / ( 1 - ( SZ2->Z2_ICMS / 100 )),2)
				EndIf

				If SZ2->Z2_ISS > 0
					nPreFre := Round(nPreFre / ( 1 - ( SZ2->Z2_ISS / 100 )),2)
				EndIf

			ElseIf cTpFrete == "C"


				nPrefre := nTPESO_CUB * SZ2->Z2_VLCUBAG

			Else

				If lMercPalle

					nQtdPalle := 0
					nQtdCxs   := SC9->C9_QTDLIB
					SA7->(DbSetOrder(1))
					If SA7->(DbSeek(xFilial("SA7")+SC9->C9_CLIENTE+SC9->C9_LOJA+SC9->C9_PRODUTO))
						nQtdPalle := SA7->A7_CXPALLE
					EndIf

					If nQtdPalle == 0
						nQtdPalle := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_QTPALLE")
					EndIf

					If nQtdPalle > 0
						nTotPalle := Int(( nQtdCxs / nQtdPalle )) + If(Mod(nQtdCxs , nQtdPalle) > 0 , 1 , 0 )
					Else
						nTotPalle := 0
					EndIf

					If nTotPalle == 0
						Alert("Produto com Pallets zerado.."+Alltrim(SC9->C9_PRODUTO) )
					EndIf

					If nPalleRom <= SZ2->Z2_PALTOCO
						nPrefre    := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FRETOCO,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRETOCO,nTotFreNeg)
					ElseIf nPalleRom > SZ2->Z2_PALTOCO .And. nPalleRom <= SZ2->Z2_PALTRUC
						nPrefre := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FRETRUC,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRETRUC,nTotFreNeg)
					ElseIf nPalleRom > SZ2->Z2_PALTRUC  .And. nPalleRom <= SZ2->Z2_PALCARR
						nPrefre := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FRECARR ,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRECARR,nTotFreNeg)
					ElseIf nPalleRom > SZ2->Z2_PALCARR .And. nPalleRom <= SZ2->Z2_PALCAR2
						nPrefre := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FRECAR2 ,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRECAR2,nTotFreNeg)
					ElseIf nPalleRom > SZ2->Z2_PALCAR2 .And. nPalleRom <= SZ2->Z2_PALBITR
						nPrefre := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FREBITR ,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FREBITR,nTotFreNeg)
					Else
						nPrefre := Round(( nTotPalle / nPalleRom ) * SZ2->Z2_FRERODO ,2)
						nPreFreNeg := Round(( nTotPalle / nPalleRom ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRERODO,nTotFreNeg)
					EndIf

				Else

					If nPesoRom < SZ2->Z2_LIMVAN
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FREVAN ,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FREVAN,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIMVAN .And. nPesoRom < SZ2->Z2_LIM_3_4
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRE_3_4,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRE_3_4,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIM_3_4 .And. nPesoRom < SZ2->Z2_LIMTOCO
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRETOCO,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRETOCO,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIMTOCO .And. nPesoRom < SZ2->Z2_LIMTRUC
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRETRUC,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRETRUC,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIMTRUC .And. nPesoRom < SZ2->Z2_LIMCARR
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRECARR,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRECARR,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIMCARR .And. nPesoRom < SZ2->Z2_LIMCAR2
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRECAR2,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRECAR2,nTotFreNeg)
					ElseIf nPesoRom > SZ2->Z2_LIMCAR2 .And. nPesoRom < SZ2->Z2_LIMBITR
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FREBITR,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FREBITR,nTotFreNeg)
					Else
						nPrefre := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * SZ2->Z2_FRERODO,2)
						nPrefreNeg := Round((( Round(SC9->C9_QTDLIB * SB1->B1_PESBRU,0) ) / Round(nPesoRom,0) ) * nTotFreNeg,2)
						nVlrFreLot := If(nTotFreNeg == 0,SZ2->Z2_FRERODO,nTotFreNeg)

					EndIf

				EndIf
			EndIf

		Else
			nPreFre := 0
			MsgStop("Nao existe frete cadastrado para a Transportadora..")
		EndIf

		//Totalizo o Frete
		nTotFre += nPreFre

		DbSelectArea("SC9" )
		RecLock("SC9",.F.)
		SC9->C9_TPFRERO := cTpFrete
		SC9->C9_PRCFRET := nPrefre
		SC9->C9_FRETNEG := If(nTotfreNeg > 0,"S"," ")
		SC9->C9_VLFRNEG := nPreFreNeg
		MsUnlock()
		DbSkip()

	End

	//Ajusta o valor do arredondamento
	If cTpFrete == "L"
		nDif := ( nVlrFreLot - nTotFre )
		If nDif # 0
			DbSelectArea("SC9")
			DbSetOrder(9)
			DbSeek(xFilial("SC9")+cRomaneio )
			RecLock("SC9",.F.)
			SC9->C9_PRCFRET := If(nDif > 0, SC9->C9_PRCFRET + Abs(nDif), SC9->C9_PRCFRET - Abs(nDif) )
			MsUnlock()
		EndIf

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcAdValor()
	Local nValor := 0

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO ))

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA ))

	nIcms := AliqIcms("N","S",SA1->A1_TIPO,"I")

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM ))

	SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO ))

	SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ))

	aExcecao := ExcecFis(SB1->B1_GRTRIB,IF(SC5->C5_TIPO$"DB",,SA1->A1_GRPTRIB))

	nVlrItem := SC9->C9_QTDLIB * SC9->C9_PRCVEN

	nVlrIPI  := If(SF4->F4_IPI=="S",NoRound(nVlrItem * ( SB1->B1_IPI / 100 ),2),0)

	If SA1->A1_TIPO == "S"

		nMargem   := ( nVlrItem + nVlrIPI ) * ( aExcecao[3] / 100 )

		nBrIcms   := ( nVlrItem + nVlrIPI ) + nMargem

		nVlrIcmRet := ( NoRound(nBrIcms * ( aExcecao[1] / 100 ),2) ) - NoRound( nVlrItem * (nIcms / 100 ),2)

		nValor := Round(( nVlrItem + nVlrIPI + nVlrIcmRet ) * (SZ2->Z2_ADVALOR / 100 ),2)

	Else

		nValor := Round(( nVlrItem + nVlrIPI  ) * (SZ2->Z2_ADVALOR / 100 ),2)

	EndIf

Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcGRis  บAutor  ณMicrosiga           บ Data ณ  01/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcGRIS()
	Local nValor := 0

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO ))

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA ))

	nIcms := AliqIcms("N","S",SA1->A1_TIPO,"I")

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM ))

	SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO ))

	SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ))

	aExcecao := ExcecFis(SB1->B1_GRTRIB,IF(SC5->C5_TIPO$"DB",,SA1->A1_GRPTRIB))

	nVlrItem := SC9->C9_QTDLIB * SC9->C9_PRCVEN

	nVlrIPI  := If(SF4->F4_IPI=="S",NoRound(nVlrItem * ( SB1->B1_IPI / 100 ),2),0)

	If SA1->A1_TIPO == "S"

		nMargem   := ( nVlrItem + nVlrIPI ) * ( aExcecao[3] / 100 )

		nBrIcms   := ( nVlrItem + nVlrIPI ) + nMargem

		nVlrIcmRet := ( NoRound(nBrIcms * ( nIcms / 100 ),2) ) - NoRound( nVlrItem * (nIcms / 100 ),2)

		nValor := Round(( nVlrItem + nVlrIPI + nVlrIcmRet ) * (SZ2->Z2_GRIS / 100 ),2)

	Else

		nValor := Round(( nVlrItem + nVlrIPI  ) * (SZ2->Z2_GRIS / 100 ),2)

	EndIf

Return nValor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA13   บAutor  ณMicrosiga           บ Data ณ  01/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcItem(cAlias)
	Local nValor := 0

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+(cAlias)->C9_PEDIDO ))

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	nIcms := AliqIcms("N","S",SA1->A1_TIPO,"I")

	SB1->(DbSeek(xFilial("SB1")+(cAlias)->C9_PRODUTO ))

	SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ))

	aExcecao := ExcecFis(SB1->B1_GRTRIB,IF(SC5->C5_TIPO$"DB",,SA1->A1_GRPTRIB))

	nVlrItem := (cAlias)->C9_QTDLIB * (cAlias)->C9_PRCVEN

	nVlrIPI  := If(SF4->F4_IPI=="S",NoRound(nVlrItem * ( SB1->B1_IPI / 100 ),2),0)

	If SA1->A1_TIPO == "S"

		nMargem   := ( nVlrItem + nVlrIPI ) * ( aExcecao[3] / 100 )

		nBrIcms   := ( nVlrItem + nVlrIPI ) + nMargem

		If nMargem > 0
			nVlrIcmRet := ( NoRound(nBrIcms * ( aExcecao[1] / 100 ),2) ) - NoRound( nVlrItem * (nIcms / 100 ),2)
		Else
			nVlrIcmRet := 0
		EndIf

		nValor := Round(( nVlrItem + nVlrIPI + nVlrIcmRet ) ,2)

	Else

		nValor := Round( nVlrItem + nVlrIPI, 2)

	EndIf

Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERACALEN บAutor  ณMicrosiga           บ Data ณ  09/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Escolha()
	Local oDlg2
	Private nRadio := 1
	Private oRadio

	@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Tipo Liberacao"
	@ 05,05 TO 67,120 TITLE "Liberacao Pedido"
	@ 23,30 RADIO oRadio Var nRadio Items "Total","Parcial","Ambos" 3D SIZE 60,10 of oDlg2 Pixel
	@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerPedFat บAutor  ณCarlos R. Moreira	 บ Data ณ  01/25/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerPedFat()
	Local lRet := .T.
	Local lCred := .F.
	Local lEst  := .F.
	Local lGrupo := .F.

	nPesoPed := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+QRY->C9_PEDIDO )

	While SC6->(!Eof()) .And. SC6->C6_NUM == QRY->C9_PEDIDO

		If ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) == 0 .Or. Alltrim(SC6->C6_BLQ) == "R"
			SC6->(DbSkip())
			Loop
		EndIf

		/*
		cGrupo := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_GRUPO")

		If MV_PAR08 == 1

		DbSelectArea("ZONA")
		DbSeek( cGrupo )

		If Empty(GRU->OK)
		lGrupo := .T.
		Exit
		EndIf

		EndIf

		*/ 

		nPesoPed += SC6->C6_QTDVEN * Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESBRU")

		DbSelectArea("SC9")
		DbSetOrder(1)
		If !DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM )
			DbSelectArea("SC6")
			DbSkip()
			Loop
		EndIf

		If !Empty(SC9->C9_BLCRED)
			lRet := .F.
			If SC9->C9_BLCRED # "10"
				lCred := .T.
				Exit
			EndIf
		EndIf

		If !Empty(SC9->C9_BLEST)
			If SC9->C9_BLEST # "10" .And. cConEst == "S"
				lRet := .F.
			Else
				lEst := .T.
			EndIf
		EndIf

		While SC9->(!Eof()) .And. SC6->C6_NUM+SC6->C6_ITEM == SC9->C9_PEDIDO+SC9->C9_ITEM

			If !Empty(SC9->C9_BLCRED)
				DbSkip()
				Loop
			EndIf
			/*
			If cConEst == "S"
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL ))

			DbSelectArea("SC9")
			If SC9->C9_QTDLIB > SB2->B2_QATU
			RecLock("SC9",.F.)
			SC9->C9_BLEST := "02"
			MsUnlock()
			lRet := .F.
			EndIf

			EndIf */

			SC9->(DbSkip())

		End

		DbSelectArea("SC6")
		DbSkip()

	End


	If lCred
		cRetorno := "C"
	ElseIf lEst
		cRetorno := "E"
	ElseIf lGrupo
		cRetorno := "G"
	ElseIf lRet
		cRetorno := "T"
	Else
		cRetorno := "P"
	EndIf

Return cRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  05/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PegaRom()
	Local cNumRom := TRB->ROMANEI
	Local oDlgProc, oNumRom
	Local aArea := GetArea()

	nOpca := 0

	While .T.

		DEFINE MSDIALOG oDlgProc TITLE "Romaneio " From 9,0 To 18,40 OF oMainWnd

		@ 5,3 to 41,145 of oDlgProc PIXEL

		@ 15,5 Say "Num Rom: " Size 50,10  of oDlgProc Pixel
		@ 13,45 MSGet oNumRom Var cNumRom f3 "SC9ROM" Size 40 ,10 of oDlgProc Pixel

		@ 50, 90 BUTTON "OK"     Size 20,10  Action {||nOpca := 1,oDlgProc:End()} of oDlgProc Pixel
		@ 50,120 BUTTON "Cancel" Size 20,10  Action {||nOpca := 2,oDlgProc:End()} of oDlgProc Pixel

		ACTIVATE MSDIALOG oDlgProc Centered

		If nOpca == 1

			If !Empty(cNumRom)

				cNumRom := StrZero(Val(cNumRom),6 )

				DbSelectArea("SC9")
				DbSetOrder(11)
				If ! DbSeek(xFilial("SC9")+cNumRom )
					MsgStop("Romaneio nao cadastrado..")
				Else

					lTem := .F.
					cNumCar := Space(6)

					While SC9->(!Eof()) .And. cNumRom == SC9->C9_ROMANEI

						If Empty(SC9->C9_NFISCAL)
							SC9->(DbSkip())
							Loop
						EndIf

						DbSelectArea("SF2")
						DbSetOrder(1)
						DbSeek(xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF )

						If !Empty(SF2->F2_DTSAI)
							lTem := .T.
						EndIf

						cNumCar := SC9->C9_NUMCARG

						DbSelectArea("SC9")
						DbSkip()

					End

					If lTem
						MsgStop("Romaneio possui nota com data de saida..")
					Else
						DbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->ROMANEI  := cNumRom
						TRB->NUMCARG  := cNumCar
						MsUnlock()
						Exit
					EndIf

				EndIf

			EndIf

		Else
			Exit
		EndIf
	End

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03_1 บAutor  ณMicrosiga           บ Data ณ  08/20/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SomaRom()
	Local nPesoLiq := 0
	Local nPesoBru := 0
	Local oDlg
	Local oPesoLiq, oPesoBru, oQtde, oTotPalle
	Local nPesoLiq := nPesoBru := 0
	Local nQtde := 0
	Local aArea := GetArea()

	nTotPalle := 0

	oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

	DbSelectArea("TRB")
	DbGotop()

	While TRB->(!Eof())

		If Empty(TRB->OK)
			TRB->(DbSkip())
			Loop
		EndIf

		nPesoLiq  += TRB->PESO
		nPesoBru  += TRB->PESO
		nQtde     += TRB->QTDCX
		nTotPalle += TRB->QTDPALL

		DbSelectArea("TRB")
		DbSkip()

	End


	DEFINE MSDIALOG oDlg TITLE "Peso do Romaneio" From 9,0 To 35,80 OF oMainWnd

	@ 15, 04 TO 171,315  OF oDlg	PIXEL

	@  25, 10 SAY oSay PROMPT "Peso Bruto : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  23, 137 MSGET oPesoBru VAR nPesoBru  PICTURE "@e 999,999.9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   78, 10 SAY oSay PROMPT "Qtde Cxs : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@   75, 137 MSGET oQtde VAR nQtde  PICTURE "@e 999,9999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@   150, 10 SAY oSay PROMPT "Tot.Pallets : " PIXEL OF oDlg SIZE 80,14;
	COLOR CLR_HBLUE FONT oFonte

	@  150, 137 MSGET oTotPalle VAR nTotPalle PICTURE "@e 999,999" SIZE 120,14 FONT oFonte PIXEL;
	OF oDlg  When .F.  COLOR CLR_HBLUE FONT oFonte RIGHT

	@ 175,10 Button "&Fechar"     Size 50,15 Action {||nOpca:=2,oDlg:End()} of oDlg Pixel //Localiza o Dia

	ACTIVATE MSDIALOG oDlg Centered //ON INIT LchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||nOpca := 2,oDlg:End()},.T.) CENTERED

	RestArea( aArea )

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                              ณ
//ณDefine a impressao do Romaneioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpr_Ped  บAutor  ณCarlos R. Moreira   บ Data ณ  09/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime os Novos precos dos produtos                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imp_Roman()
	Local oPrn
	Private oFont, cCode

	oFont  :=  TFont():New( "Arial",,15,,.T.,,,,,.F. )
	oFont3 :=  TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont12:=  TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont5 :=  TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont9 :=  TFont():New( "Arial",, 8,,.T.,,,,,.f. )
	oArialNeg06 :=  TFont():New( "Arial",, 6,,.T.,,,,,.f. )

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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice para Gerar o Romaneio                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cNomArq  := CriaTrab(nil,.f.)
	//IndRegua("TRB",cNomArq,"ROMANEI+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	oPrn := TMSPrinter():New()
	//oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:SetLandscape()

	oPrn:Setup()

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	DbSelectArea("TRB1")
	DbGotop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB1->(!EOF())

		IncProc("Imprimindo Romaneio...")

		If Empty(TRB1->ROMANEI)
			DbSkip()
			Loop
		EndIf

		cRomaneio := TRB1->ROMANEI
		nTotPeso := nTotCxs := 0
		nTotFre  := 0
		cTraRom  := TRB1->TRAROM
		cRedespacho := TRB1->REDESP
		nVlrRom  := 0

		//Cada Romaneio devera ter paginas  separadas
		lPri := .T.

		While TRB1->(!Eof()) .And. cRomaneio == TRB1->ROMANEI

			cPedido := TRB1->PEDIDO

			While TRB1->(!Eof()) .And. cPedido == TRB1->PEDIDO

				If lFirst
					oPrn:StartPage()
					cTitulo := "Romaneio N. "+TRB1->ROMANEI
					cRod    := ""
					cNomEmp := SM0->M0_NOMECOM
					aTit    := {cTitulo,cNomEmp,cRod}
					nPag++
					U_CabRel(aTit,1,oPrn,nPag,"")
					CabCons(oPrn,1)

					lFirst = .F.

				EndIf

				oPrn:Box(nLin,100,nLin+60,3300)

				oPrn:line(nLin, 250,nLin+60, 250)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1300,nLin+60,1300)
				oPrn:line(nLin,1500,nLin+60,1500)
				oPrn:line(nLin,1900,nLin+60,1900)
				oPrn:line(nLin,2200,nLin+60,2200)
				oPrn:line(nLin,2300,nLin+60,2300)
				oPrn:line(nLin,2500,nLin+60,2500)
				oPrn:line(nLin,2700,nLin+60,2700)
				oPrn:line(nLin,3000,nLin+60,3000)


				SA1->(DbSeek(xFilial("SA1")+TRB1->CLIENTE+TRB1->LOJA))

				oPrn:Say(nLin+15,  110,TRB1->PEDIDO  ,oFont5,100)
				oPrn:Say(nLin+15,  260,TRB1->NOME    ,oFont5,100)
				oPrn:Say(nLin+15, 1320,TRB1->LOJA    ,oFont5,100)
				oPrn:Say(nLin+15, 1430,TRB1->EST     ,oFont5,100)
				oPrn:Say(nLin+15, 1520,TRB1->MUN     ,oFont5,100)


				oPrn:Say(nLin+15, 1910,TRB1->PEDCLI         ,oFont9,100)
				oPrn:Say(nLin+15, 2230,TRB1->ANTENTR     ,oFont5,100)
				oPrn:Say(nLin+15, 2310,Dtoc(TRB1->DTENT)     ,oFont5,100)
				oPrn:Say(nLin+15, 2510,Dtoc(TRB1->DTAGEN)     ,oFont5,100)

				oPrn:Say(nLin+15, 2760,Transform(TRB1->QTDCX   ,"@e 99,999,999") ,oFont5,100)
				oPrn:Say(nLin+15, 3120,Transform(TRB1->PESO   ,"@e 99,999,999") ,oFont5,100)

				nTotPeso  += TRB1->PESO
				nTotCxs   += TRB1->QTDCX
				nTotFre   += TRB1->PRCFRE

				nVlrRom   += TRB1->VLRROM

				nLin += 60

				If nLin > 2200
					oPrn:EndPage()
					lFirst := .T.
				EndIf


				DbSelectArea("TRB1")
				DbSkip()

			End


		End

		If nTotPeso > 0

			oPrn:Box(nLin,100,nLin+60,3300)

			//oPrn:line(nLin,1750,nLin+60,1750)
			oPrn:line(nLin,2700,nLin+60,2700)
			oPrn:line(nLin,3000,nLin+60,3000)

			oPrn:Say(nLin+15, 180,"Total Geral ... ....: " ,oFont5,100)

			oPrn:Say(nLin+15, 2760,Transform(nTotCxs   ,"@e 99,999,999") ,oFont5,100)
			oPrn:Say(nLin+15, 3120,Transform(nTotPeso ,"@e 99,999,999") ,oFont5,100)


		EndIf

		If nLin > 2100

			oPrn:EndPage()

			oPrn:StartPage()
			cTitulo := "Romaneio N. "+cRomaneio
			cRod    := ""
			aTit    := {cTitulo,SM0->M0_NOMECOM,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			CabCons(oPrn)

		EndIf

		Processa({||ImpSepCarga(oPrn)},"Imprimindo a Separacao de Carga")

		oPrn:EndPage()
		lFirst := .T.

	End

	oPrn:Preview()
	oPrn:End()

	TRB1->(DbCloseArea())
	TRB2->(DbCloseArea())

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

	If nModo == 1

		nLin := 320

		oPrn:Box(nLin,100,nLin+120,3300)
		oPrn:Say(nLin+10,  110,"Transportadora : "+cTraRom+" - "+Posicione("SA4",1,xFilial("SA4")+cTraRom,"A4_NOME")   ,oFont ,100)

		nLin += 140

		oPrn:FillRect({nLin,100,nLin+60,3300},oBrush)

		oPrn:Box(nLin,100,nLin+60,3300)

		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1900,nLin+60,1900)
		oPrn:line(nLin,2200,nLin+60,2200)
		oPrn:line(nLin,2300,nLin+60,2300)
		oPrn:line(nLin,2500,nLin+60,2500)
		oPrn:line(nLin,2700,nLin+60,2700)
		oPrn:line(nLin,3000,nLin+60,3000)

		oPrn:Say(nLin+10,  110,"Pedido"       ,oFont5 ,100)
		oPrn:Say(nLin+10,  260,"Nome Cliente" ,oFont5 ,100)
		oPrn:Say(nLin+10, 1320,"Loja"         ,oFont5 ,100)
		oPrn:Say(nLin+10, 1430,"UF"           ,oFont5 ,100)
		oPrn:Say(nLin+10, 1560,"Cidade"       ,oFont5 ,100)
		oPrn:Say(nLin+10, 1910,"Ped.Cliente"  ,oFont5 ,100)
		oPrn:Say(nLin+10, 2210,"Ant.Entr"     ,oFont9 ,100)
		oPrn:Say(nLin+10, 2310,"Entrega"      ,oFont5 ,100)
		oPrn:Say(nLin+10, 2510,"Dt. Agen."    ,oFont5 ,100)
		oPrn:Say(nLin+10, 2780,"Qtde Cxs"     ,oFont5 ,100)
		oPrn:Say(nLin+10, 3080,"Peso Bruto"   ,oFont5 ,100)

		nLin += 60

	Else

		nLin += 80

		oPrn:FillRect({nLin,100,nLin+80,3300},oBrush)

		oPrn:Box(nLin,100,nLin+80,3300)

		oPrn:line(nLin, 550,nLin+80, 550)
		oPrn:line(nLin,1250,nLin+80,1250)
		oPrn:line(nLin,1600,nLin+80,1600)
		oPrn:line(nLin,2000,nLin+80,2000)
		oPrn:line(nLin,2500,nLin+80,2500)
		oPrn:line(nLin,2900,nLin+80,2900)

		oPrn:Say(nLin+15,  110,"Produto"      ,oFont3 ,100)
		oPrn:Say(nLin+15,  560,"Descricao"    ,oFont3 ,100)
		oPrn:Say(nLin+15, 1380,"Pallets"     ,oFont3 ,100)
		oPrn:Say(nLin+15, 1730,"Cxs Avulsas"  ,oFont3 ,100)
		oPrn:Say(nLin+15, 2110,"Qtde Cxs"     ,oFont3 ,100)
		oPrn:Say(nLin+15, 2580,"Peso"         ,oFont3 ,100)
		oPrn:Say(nLin+15, 2980,"Lote "        ,oFont3 ,100)

		nLin += 80

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03_1 บAutor  ณMicrosiga           บ Data ณ  09/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkRedesp()
	Local lRet := .T.

	DbSelectArea("TRB")
	DbGoTop()

	While TRB->(!Eof())

		If Empty(TRB->OK)
			DbSkip()
			Loop
		EndIf

		cTrecho := "F"

		DbSelectArea("SZ2")
		DbSetOrder(2)
		If !DbSeek(xFilial("SZ2")+TRB->TRANSP+TRB->REGIAO+cTrecho )
			MsgStop("Nao existe frete cadas. para a Transportadora..")
			lRet := .F.
			Exit
		EndIf

		DbSelectArea("TRB")
		DbSkip()

	End

Return lRet

/*

Checa se a Ordem ้ validada para a ordenacao da Carga

*/

Static Function ChkOrd(cOrdCarg)
	Local lRet := .T.

	If !Empty(cOrdCarg)

		cOrdCarg := StrZero(Val(cOrdCarg),3)

		nPesq := Ascan(aOrdCarg,cOrdCarg)
		If nPesq == 0
			AaDD(aOrdCarg,cOrdCarg)
		Else
			MsgStop("Ordem da carga ja foi informada.")
			lRet := .F.
		EndIf

	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditObs   บAutor  ณCarlos R Moreira    บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtribui uma observacao ao Romaneio                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetVeiculo(cVeiculo)

	Local cVeiculo := Space(8)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Veiculo" From 9,0 To 18,80 OF oMainWnd

	@ 5,3 to 41,295 of oDlgProc PIXEL

	@ 15,5 Say "Veiculo: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cVeiculo  F3 "DA3" Valid ChkVeiculo(@cVeiculo) Size 40 ,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action Close(oDlgProc) //GrvOrd(@cOrdCarg,oDlgProc)
	//	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered


Return cVeiculo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkVeiculo()
	Local lRet := .F.
	If !Empty(cVeicRom)

		//		cVeiculo := StrZero(Val(cVeiculo),4)

		DbSelectArea("DA3")
		DbSetOrder(1)
		If DbSeek( xFilial("DA3")+cVeicRom )
			cDescVeic   := DA3->DA3_DESC
			nCapacidade := DA3->DA3_CAPACM
			lRet := .T.
		Else
			MsgStop("Veiculo nao cadastrado .. ")
		EndIf
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkTpVeic()
	Local lRet := .T.
	If !Empty(cTpVeicRom)

		//		cVeiculo := StrZero(Val(cVeiculo),4)

		DbSelectArea("DUT")
		DbSetOrder(1)
		If DbSeek( xFilial("DUT")+cTpVeicRom )
			cDescVeic   := DUT->DUT_DESCRI
			nCapacidade := DUT->DUT_CAPACM
			nQtdPall    := DUT->DUT_PALLET 
			lRet := .T.
		Else
			MsgStop("Tipo de Veiculo nao cadastrado .. ")
		EndIf
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditObs   บAutor  ณCarlos R Moreira    บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtribui uma observacao ao Romaneio                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetMotorista()

	Local cMotoris := Space(6)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Motorista" From 9,0 To 18,80 OF oMainWnd

	@ 5,3 to 41,295 of oDlgProc PIXEL

	@ 15,5 Say "Motorista: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cMotoris Picture "@E 999999" F3 "DA4" Valid ChkMotoris(@cMotoris) Size 20 ,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action Close(oDlgProc) //GrvOrd(@cOrdCarg,oDlgProc)
	//	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered


Return cMotoris


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkMotoris(cMotoris)
	Local lRet := .F.
	If !Empty(cMotoris)

		cMotoris := StrZero(Val(cMotoris),6)

		DbSelectArea("DA4")
		DbSetOrder(1)
		If DbSeek( xFilial("DA4")+cMotoris )
			lRet := .T.
		Else
			MsgStop("Motorista nao cadastrado .. ")
		EndIf
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelGrupo  บAutor  ณCarlos R. Moreira   บ Data ณ  16/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona o grupo de produto                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Espeficico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SelGrupo()

	Local aCampos := {}

	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )
	AADD(aCampos,{ "ZONA"    ,"C",06,0 } )
	AADD(aCampos,{ "DESC"    ,"C",20,0 } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"ZONA", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("ZONA",cNomArq,"ZONA",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("DA5")
	DbGoTop()

	ProcRegua(RecCount())

	While DA5->(!Eof())

		DbSelectArea("ZONA")
		RecLock("ZONA",.T.)
		ZONA->ZONA := DA5->DA5_COD 
		ZONA->DESC := DA5->DA5_DESC
		MsUnlock()

		DbSelectArea("DA5")
		DbSkip()
	End

	Processa({||Proc_Sel1()},"Selecionando Zona...")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  03/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Proc_Sel1()

	ZONA->(DbGoTop())

	cMarca   := GetMark()
	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"ZONA","","Zona"})
	AaDD(aBrowse,{"DESC","","Descricao"})

	nOpca    :=0
	lInverte := .F.
	DEFINE MSDIALOG oDlg1 TITLE "Seleciona Zona" From 9,0 To 37,60 OF oMainWnd

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("ZONA","OK","",aBrowse,@lInverte,@cMarca,{15,3,203,235})

	oMark:bMark := {| | fa060disp(cMarca,lInverte,2)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,2) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.F.,2) centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCGRUPO บAutor  ณCarlos R Moreira    บ Data ณ  12/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Procura um grupo especifico                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcGrupo()
	Local cZona := Space(6)
	Local oDlgProc

	cTitProc := "Procura Zona"

	DEFINE MSDIALOG oDlgProc TITLE cTitProc From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite Zona:" Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cZona Size 60,10 of oDlgProc Pixel


	@ 50, 90 BMPBUTTON TYPE 1 Action PosZona(@cZona,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosZona(cZona,oDlgProc)
	Local nRecno := ZONA->(RECNO())

	ZONA->(DbGoTop())

	While ZONA->(!Eof())

		IF TRB->ZONA == cZona
			Exit
		EndIf

		DbSkip()

	End

	If ZONA->(Eof())
		ZONA->(DbGotop())
	EndIf

	Close(oDlgProc)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditObs   บAutor  ณCarlos R Moreira    บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtribui uma observacao ao Romaneio                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EditObs(nModo)
	Local cObs := Space(60)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Observacao do Romaneio" From 9,0 To 18,100 OF oMainWnd

	@ 5,3 to 41,395 of oDlgProc PIXEL

	@ 15,5 Say "Observacao: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cObs  Picture "@S50"  Size 320 ,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLOGA03   บAutor  ณMicrosiga           บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvObs(cObs,oDlgProc,nModo)

	DbSelectArea("TRB")
	RecLock("TRB",.F.)
	If nModo == 1
		TRB->OBSINT  := cObs
	Else
		TRB->OBSEXT  := cObs
	EndIf
	MsUnlock()

	Close(oDlgProc)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraPed บAutor  ณCarlos Moreira      บ Data ณ  01/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra o Pedido de Venda                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MostraPed()
	Local aArea := GetArea()

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 1,0 },;
	{ "Visualizar","A410Visual" , 0 , 2, 0},;
	{ "Liberar"   ,"U_PFATA02A" , 0 , 4, 0} }

	Altera := .F.

	If SM0->M0_CODIGO == TRB->EMPRESA 
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek( xFilial("SC5")+TRB->PEDIDO )

		cAlias := "SC5"
		nReg := SC5->(Recno())
		nOpc := 2

		A410Visual(cAlias,nReg,nOpc)

	Else

		cEmpOri := cEmpAnt
		cFilOri := cFilAnt

		cEmpDest   := TRB->EMPRESA 
		cFilDest := "01"
		cPedido  := TRB->PEDIDO

		WfPrepEnv(cEmpDest,cFilDest)

		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek( xFilial("SC5")+cPedido )

		cAlias := "SC5"
		nReg := SC5->(Recno())
		nOpc := 2

		A410Visual(cAlias,nReg,nOpc)

		WfPrepEnv(cEmpOri,cFilOri ) 

	EndIf  

	RestArea(aArea)

Return


Static Function GeraPedPal()

	DbSelectArea("TRB")
	DbSetOrder(4)
	DbGoTop()

	ProcRegua(RecCount())

	While TRB->(!Eof())

		If(Empty(TRB->ROMANEI))
			DbSkip()
			Loop
		EndIf 

		cEmpresa  := TRB->EMPRESA
		cRomaneio := TRB->ROMANEI
		cCliente  := TRB->CLIENTE
		cLoja     := TRB->LOJA 

		nTotPall  := 0

		While TRB->(!Eof()) .And. cRomaneio == TRB->ROMANEI .And. TRB->CLIENTE == cCliente .And. TRB->LOJA == cLoja .And. ;
		cEmpresa == TRB->EMPRESA 

			nTotPall  += TRB->QTDPALL  

			DbSelectArea("TRB")
			DbSkip()

		End    

		If nTotPall > 0 

			DbSelectArea("PAL")
			RecLock("PAL",.T.)
			PAL->EMPRESA := cEmpresa
			PAL->ROMANEI := cRomaneio
			PAL->CLIENTE := cCliente
			PAL->LOJA    := cLoja
			PAL->TOTPALL := nTotPall 
			MsUnlock()

		EndIf 

	End

	TRB->(DbSetOrder(1))

Return

/*/

Gera o pedido de Pallets 

/*/
User Function ProcPedPal(cEmpTrans,cFilTrans,aPedPal,lAuto )
	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local nX     := 0
	Local nY     := 0
	Local cDoc   := ""
	Local lOk    := .T.
	Local cUser  := __cUserID 

	Private _condpg
	Private _cMunIbge
	Private _cTpclisc
	Private _cArea
	Private _cRedesca
	Public cPedido
	Public lprogauto := .T.

	If ! lAuto

		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+"9")

			While SC5->(!Eof()) .And.  Substr(SC5->C5_NUM,1,1) == "9"
				cNumPed := SC5->C5_NUM 
				DbSkip()
			End 
			cNumPed := StrZero(Val(cNumPed)+1,6)      
		Else 
			cNumPed := "900001"
		EndIf 

		For nPed := 1 to Len(aPedPal)

			cCliente  := aPedPal[nPed,3]
			cLoja     := aPedPal[nPed,4]
			cRomaneio := aPedPal[nPed,2]
			cTransp   := aPedPal[nPed,6]

			Conout("Cliente : "+cCliente+" Loja: "+cLoja  )
			Conout("Romaneio: "+cRomaneio )

			DbSelectArea("SA1")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SA1")+cCliente+cLoja )

				Conout("Cliente nao cadastrado")

			EndIf

			_CondPG := SA1->A1_COND

			DbSelectArea("SC5")
			RecLock("SC5",.T.)
			SC5->C5_FILIAL  := xFilial("SC5")
			SC5->C5_NUM     := cNumPed 
			SC5->C5_TIPO    := "N"
			SC5->C5_ZZTIPO  := "L"
			SC5->C5_CLIENTE := SA1->A1_COD
			SC5->C5_LOJACLI := SA1->A1_LOJA
			SC5->C5_CLIENT  := SA1->A1_COD
			SC5->C5_LOJAENT := SA1->A1_LOJA
			SC5->C5_TIPOCLI := SA1->A1_TIPO
			SC5->C5_TRANSP  := cTransp
			SC5->C5_CONDPAG := SA1->A1_COND
			SC5->C5_TPFRETE := "F"
			SC5->C5_VEND1   := SA1->A1_VEND
			SC5->C5_FECENT  := dDatabase
			SC5->C5_VOLUME1 := aPedPal[nPed,5]
			SC5->C5_ESPECI1 := "CAIXAS"
			SC5->C5_ZZPEDCL := "..."
			SC5->C5_ZZUSER  := cUser  
			SC5->C5_STAPED  := "T"
			SC5->C5_ROMANEI := cRomaneio
			SC5->C5_EMISSAO := dDataBase
			SC5->C5_MOEDA   := 1
			SC5->C5_LIBEROK := "S"
			SC5->C5_TXMOEDA := 1
			SC5->C5_TIPLIB  := "1"
			SC5->C5_TPCARGA := "2"
			SC5->C5_ZZHORA  := TIME()
			MsUnlock()

			cProduto :="9010.01.01X01U " //Pallet 
			nQtd     := aPedPal[nPed,5] 

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+cProduto)

			cTes := SB1->B1_TS 

			nPrc := If(SB1->B1_PRV1==0,9,SB1->B1_PRV1) 

			nTot := Round(nQtd * nPrc,2)

			DbSelectArea("SC6")
			RecLock("SC6",.T.)
			SC6->C6_FILIAL  := xFilial("SC6")
			SC6->C6_NUM     := cNumPed 
			SC6->C6_ITEM    := "01" 
			SC6->C6_PRODUTO := cProduto
			SC6->C6_DESCRI  := SB1->B1_DESC 
			SC6->C6_UM      := SB1->B1_UM
			SC6->C6_LOCAL   := SB1->B1_LOCPAD 
			SC6->C6_QTDVEN  := nQtd
			SC6->C6_PRCVEN  := nPrc
			SC6->C6_PRUNIT  := nPrc
			SC6->C6_VALOR   := nTot
			SC6->C6_TES     := cTes
			SC6->C6_CF      := If(SA1->A1_EST=GETMV("MV_ESTADO"),"5","6")+Substr(Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF"),2)
			SC6->C6_CLI     := cCliente
			SC6->C6_LOJA    := cLoja
			SC6->C6_ENTREG  := dDataBase
			SC6->C6_CLASFIS := SB1->B1_ORIGEM+Posicione("SF4",1,xFilial("SF4")+cTes,"F4_SITTRIB")
			SC6->C6_TPOP    := "F"
			SC6->C6_SUGENTR := dDataBase
			SC6->C6_RATEIO  := "2"
			SC6->C6_QTDEMP  := nQtd 
			MsUnlock()

			DbSelectArea("SC9")
			DbSetOrder(11)
			DbSeek(xFilial("SC9")+SC5->C5_ROMANEI )

			cOrdem := Space(3)
			cTpVeic := Space(2)
			dDtCarre := dDataBase 
			cTpCarro := Space(1)

			While SC9->(!Eof()) .And. SC9->C9_ROMANEI == SC5->C5_ROMANEI 

				If SC9->C9_CLIENTE+SC9->C9_LOJA == SC5->C5_CLIENTE+SC5->C5_LOJACLI
					cOrdem   := SC9->C9_ORDCARG
					cTpVeic  := SC9->C9_TIPOVEI
					dDtCarre := SC9->C9_DTCARRE
					cTpCarRo := SC9->C9_TPCARRO
					Exit
				EndIf
				DbSkip()

			End 

			DbSelectArea("SC9")
			RecLock("SC9",.T.)
			SC9->C9_FILIAL  := xFilial("SC9")
			SC9->C9_PEDIDO  := cNumPed
			SC9->C9_ITEM    := "01"
			SC9->C9_CLIENTE := cCliente
			SC9->C9_LOJA    := cLoja
			SC9->C9_PRODUTO := cProduto
			SC9->C9_QTDLIB  := nQtd 
			SC9->C9_DATALIB := dDataBase
			SC9->C9_SEQUEN  := "01"
			SC9->C9_GRUPO   := SB1->B1_GRUPO 
			SC9->C9_PRCVEN  := nPrc
			SC9->C9_LOCAL   := SB1->B1_LOCPAD
			SC9->C9_TPCARGA := "2"
			SC9->C9_RETOPER := "2"	
			SC9->C9_BLEST   := " "
			SC9->C9_ROMANEI := SC5->C5_ROMANEI
			SC9->C9_EMIROM  := dDataBase
			SC9->C9_TRAROM  := cTransp 
			SC9->C9_ORDCARG := cOrdem 
			SC9->C9_EMIROM  := dDataBase
			SC9->C9_TIPOVEI := cTpVeic
			SC9->C9_DTCARRE := dDtCarre
			SC9->C9_TPCARRO := cTpCarRo 
			MsUnlock()

			Alert("Pedido de Palete incluido com sucesso: "+cNumPed)

			cNumPed := StrZero(Val(cNumPed)+1,6)
			//ConOut("Incluido com sucesso! "+cPedido)

		Next 


	Else


		cEmp := cEmpTrans

		aArqDest := { "SC6","SB1","SC9","SC5","SA1","SF4" }

		For nX := 1 to Len(aArqDest)

			//Abro os Arquivos nas respectivas empresas
			cArqVar := aArqDest[nX]+cEmp+"0"

			DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

			If Select( cArqVar ) > 0

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณIra fazer a abertura do Indice da Tabela ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SIX->(DbSeek(aArqDest[nX]))
				While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
					DbSetIndex(cArqVar+SIX->ORDEM)
					SIX->(DbSkip())
				End
				DbSetOrder(1)

				//Crio a Variavel para selecionar o arquivo correspondente

				cArqSC6 := "SC6"+cEmp+"0"
				cArqSB1 := "SB1"+cEmp+"0"
				cArqSC9 := "SC9"+cEmp+"0"
				cArqSC5 := "SC5"+cEmp+"0"
				cArqSA1 := "SA1"+cEmp+"0"
				cArqSF4 := "SF4"+cEmp+"0"

			EndIf

		Next

		DbSelectArea(cArqSC5)
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+"9")

			While (cArqSC5)->(!Eof()) .And.  Substr((cArqSC5)->C5_NUM,1,1) == "9"
				cNumPed := (cArqSC5)->C5_NUM 
				DbSkip()
			End 
			cNumPed := StrZero(Val(cNumPed)+1,6)      
		Else 
			cNumPed := "900001"
		EndIf 

		For nPed := 1 to Len(aPedPal)

			cCliente  := aPedPal[nPed,3]
			cLoja     := aPedPal[nPed,4]
			cRomaneio := aPedPal[nPed,2]
			cTransp   := aPedPal[nPed,6]

			Conout("Cliente : "+cCliente+" Loja: "+cLoja  )
			Conout("Romaneio: "+cRomaneio )

			DbSelectArea(cArqSA1)
			DbSetOrder(1)
			If ! DbSeek(xFilial("SA1")+cCliente+cLoja )

				Conout("Cliente nao cadastrado")

			EndIf

			_CondPG := (cArqSA1)->A1_COND

			DbSelectArea(cArqSC5)
			RecLock(cArqSC5,.T.)
			(cArqSC5)->C5_FILIAL  := xFilial("SC5")
			(cArqSC5)->C5_NUM     := cNumPed 
			(cArqSC5)->C5_TIPO    := "N"
			(cArqSC5)->C5_ZZTIPO  := "L"
			(cArqSC5)->C5_CLIENTE := (cArqSA1)->A1_COD
			(cArqSC5)->C5_LOJACLI := (cArqSA1)->A1_LOJA
			(cArqSC5)->C5_CLIENT  := (cArqSA1)->A1_COD
			(cArqSC5)->C5_LOJAENT := (cArqSA1)->A1_LOJA
			(cArqSC5)->C5_TIPOCLI := (cArqSA1)->A1_TIPO
			(cArqSC5)->C5_TRANSP  := cTransp
			(cArqSC5)->C5_CONDPAG := (cArqSA1)->A1_COND
			(cArqSC5)->C5_TPFRETE := "C"
			(cArqSC5)->C5_VEND1   := (cArqSA1)->A1_VEND
			(cArqSC5)->C5_FECENT  := dDatabase
			(cArqSC5)->C5_VOLUME1 := aPedPal[nPed,5]
			(cArqSC5)->C5_ESPECI1 := "CAIXAS"
			(cArqSC5)->C5_ZZPEDCL := "..."
			(cArqSC5)->C5_ZZUSER  := cUser  
			(cArqSC5)->C5_STAPED  := "T"
			(cArqSC5)->C5_ROMANEI := cRomaneio
			(cArqSC5)->C5_EMISSAO := dDataBase
			(cArqSC5)->C5_MOEDA   := 1
			(cArqSC5)->C5_LIBEROK := "S"
			(cArqSC5)->C5_TXMOEDA := 1
			(cArqSC5)->C5_TIPLIB  := "1"
			(cArqSC5)->C5_TPCARGA := "2"
			MsUnlock()

			cProduto :="9010.01.01X01U " //Pallet 
			nQtd     := aPedPal[nPed,5] 

			DbSelectArea(cArqSB1)
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+cProduto)

			cTes := (cArqSB1)->B1_TS 



			nPrc := If((cArqSB1)->B1_PRV1==0,9,(cArqSB1)->B1_PRV1) 

			nTot := Round(nQtd * nPrc,2)

			DbSelectArea(cArqSC6)
			RecLock(cArqSC6,.T.)
			(cArqSC6)->C6_FILIAL  := xFilial("SC6")
			(cArqSC6)->C6_NUM     := cNumPed 
			(cArqSC6)->C6_ITEM    := "01" 
			(cArqSC6)->C6_PRODUTO := cProduto
			(cArqSC6)->C6_DESCRI  := (cArqSB1)->B1_DESC 
			(cArqSC6)->C6_UM      := (cArqSB1)->B1_UM
			(cArqSC6)->C6_LOCAL   := (cArqSB1)->B1_LOCPAD 
			(cArqSC6)->C6_QTDVEN  := nQtd
			(cArqSC6)->C6_PRCVEN  := nPrc
			(cArqSC6)->C6_PRUNIT  := nPrc
			(cArqSC6)->C6_VALOR   := nTot
			(cArqSC6)->C6_TES     := cTes
			(cArqSC6)->C6_CF      := If((cArqSA1)->A1_EST=GETMV("MV_ESTADO"),"5","6")+Substr(Posicione(cArqSF4,1,xFilial("SF4")+cTes,"F4_CF"),2)
			(cArqSC6)->C6_CLI     := cCliente
			(cArqSC6)->C6_LOJA    := cLoja
			(cArqSC6)->C6_ENTREG  := dDataBase
			(cArqSC6)->C6_CLASFIS := (cArqSB1)->B1_ORIGEM+Posicione(cArqSF4,1,xFilial("SF4")+cTes,"F4_SITTRIB")
			(cArqSC6)->C6_TPOP    := "F"
			(cArqSC6)->C6_SUGENTR := dDataBase
			(cArqSC6)->C6_RATEIO  := "2"
			(cArqSC6)->C6_QTDEMP    := nQtd 
			MsUnlock()

			DbSelectArea(cArqSC9)
			DbSetOrder(11)
			DbSeek(xFilial("SC9")+(cArqSC5)->C5_ROMANEI )

			cOrdem   := Space(3)
			cTpVeic  := Space(2)
			cTpCarro := Space(1)
			dDtCarre := dDataBase

			While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_ROMANEI == (cArqSC5)->C5_ROMANEI 

				If (cArqSC9)->C9_CLIENTE+(cArqSC9)->C9_LOJA == (cArqSC5)->C5_CLIENTE+(cArqSC5)->C5_LOJACLI
					cOrdem   := (cArqSC9)->C9_ORDCARG
					cTpVeic  := (cArqSC9)->C9_TIPOVEI
					cTpCarRo := (cArqSC9)->C9_TPCARRO 
					dDtCarre := (cArqSC9)->C9_DTCARRE
					cTransp  := (cArqSC9)->C9_TRAROM 
					Exit
				EndIf
				DbSkip()

			End 

			DbSelectArea(cArqSC9)
			RecLock(cArqSC9,.T.)
			(cArqSC9)->C9_FILIAL  := xFilial("SC9")
			(cArqSC9)->C9_PEDIDO  := cNumPed
			(cArqSC9)->C9_ITEM    := "01"
			(cArqSC9)->C9_CLIENTE := cCliente
			(cArqSC9)->C9_LOJA    := cLoja
			(cArqSC9)->C9_PRODUTO := cProduto
			(cArqSC9)->C9_QTDLIB  := nQtd 
			(cArqSC9)->C9_DATALIB := dDataBase
			(cArqSC9)->C9_SEQUEN  := "01"
			(cArqSC9)->C9_GRUPO   := (cArqSB1)->B1_GRUPO 
			(cArqSC9)->C9_PRCVEN  := nPrc
			(cArqSC9)->C9_LOCAL   := (cArqSB1)->B1_LOCPAD 
			(cArqSC9)->C9_TPCARGA := "2"
			(cArqSC9)->C9_RETOPER := "2"	
			(cArqSC9)->C9_BLEST   := " "
			(cArqSC9)->C9_ROMANEI := (cArqSC5)->C5_ROMANEI
			(cArqSC9)->C9_EMIROM  := dDataBase
			(cArqSC9)->C9_TRAROM  := cTransp
			(cArqSC9)->C9_ORDCARG := cOrdem 
			(cArqSC9)->C9_EMIROM  := dDataBase
			(cArqSC9)->C9_TIPOVEI := cTpVeic
			(cArqSC9)->C9_TPCARRO := cTpCarRo 			
			(cArqSC9)->C9_DTCARRE := dDtCarre

			MsUnlock()

			Alert("Pedido de Palete incluido com sucesso: "+cNumPed)

			cNumPed := StrZero(Val(cNumPed)+1,6)
			//ConOut("Incluido com sucesso! "+cPedido)

		Next 

		(cArqSC6)->(DbCloseArea())
		(cArqSB1)->(DbCloseArea())
		(cArqSC9)->(DbCloseArea())
		(cArqSC5)->(DbCloseArea())
		(cArqSA1)->(DbCloseArea())
		(cArqSF4)->(DbCloseArea())


	EndIf 

Return  

/*/ 

Checa a transportadora 

/*/

Static Function ChkTransp()
	Local lRet := .T.
	If !Empty(cTransp)

		cTransp := StrZero(Val(cTransp),6)

		DbSelectArea("SA4")
		DbSetOrder(1)
		If DbSeek(xFilial('SA4')+cTransp )
			cDescTra := SA4->A4_NOME
		Else 
			MsgStop("Transportadora nao cadastrada")
			lRet := .F.   

		EndIf

	EndIf 

Return lRet 

/*/

Funcao para estornar o pedido de venda

/*/
Static Function EstorPed()

	If ! MsgYesno("Deseja realmente estornar os pedidos marcados")
		Return 
	EndIf     

	//Abro o Arquivo de Estoque da empresa principal 

	cEmpEst := GetMv("MV_XEMPEST")

	aArqDest := { "SB2" }

	For nX := 1 to Len(aArqDest)

		//Abro os Arquivos nas respectivas empresas
		cArqVar := aArqDest[nX]+cEmpEst+"0"

		DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

		If Select( cArqVar ) > 0

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณIra fazer a abertura do Indice da Tabela ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SIX->(DbSeek(aArqDest[nX]))
			While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
				DbSetIndex(cArqVar+SIX->ORDEM)
				SIX->(DbSkip())
			End
			DbSetOrder(1)

		EndIf

	Next

	//Crio a Variavel para selecionar o arquivo correspondente

	cArqSB2 := "SB2"+cEmpEst+"0"

	DbSelectArea("TRB")
	Dbgotop()

	While TRB->(!Eof())

		If Empty(TRB->OK)
			DbSkip()
			Loop
		EndIf 

		cPedido := TRB->PEDIDO 

		cArq := "SC9"+TRB->EMPRESA+"0"

		// Atualiza dados do pedido de venda 
		//-------------------------------------------------------------------------------------
		cQuery2 := " UPDATE " + cArq + " SET C9_BLEST = '02' " 
		cQuery2 += " Where D_E_L_E_T_='' and C9_PEDIDO='"+ cPedido  +"' and C9_FILIAL='" + xFilial("SC9") + "' "
		//					cQuery2 += "       AND C9_ITEM = '"+TRB->ITEM+"' "

		If (TCSQLExec(cQuery2) < 0)
			Return MsgStop("Falha na atualizacao do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
		EndIf

		cArq := "SC5"+TRB->EMPRESA+"0"

		// Atualiza dados do pedido de venda 
		//-------------------------------------------------------------------------------------
		cQuery2 := " UPDATE " + cArq + " SET C5_STAPED = 'L' " 
		cQuery2 += " Where D_E_L_E_T_='' and C5_NUM ='"+ cPedido  +"' and C5_FILIAL='" + xFilial("SC5") + "' "

		If (TCSQLExec(cQuery2) < 0)
			Return MsgStop("Falha na atualizacao do Pedido "+ cPedido + ".  TCSQLError:"+ TCSQLError())
		EndIf

		cArq := "SC9"+TRB->EMPRESA+"0"

		cQuery2 := " SELECT C9_PEDIDO,C9_PRODUTO,C9_QTDLIB,C9_LOCAL FROM "+cArq 
		cQuery2 += "  Where D_E_L_E_T_ <> '*'  AND C9_PEDIDO = '"+cPedido+"' "      

		TCSQLExec(cQuery2)

		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRYPED",.T.,.T.)},"Aguarde gerando o arquivo..")

		DbSelectArea("QRYPED")
		DbGoTop()

		While QRYPED->(!Eof()) 

			DbSelectArea(cArqSB2)
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+QRYPED->C9_PRODUTO+QRYPED->C9_LOCAL )

				RecLock(cArqSB2,.F.)
				(cArqSB2)->B2_RESERVA -= QRYPED->C9_QTDLIB  
				MsUnlock()

			EndIf 

			DbSelectArea("QRYPED") 
			DbSkip()
		End 

		QRYPED->(DbCloseArea())


		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->(DbDelete())
		MsUnlock()
		DbSkip()

	End 

	(cArqSB2)->(DbCloseArea())

Return 


/*/

Verifica o que ja consta em programacao 

/*/
Static Function VerProg()

	Local aArea := GetArea()
	Local oDlg 

	Local nTotLib := 0 

	Local oTotLib

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	DbSelectArea("ZZQ")
	DbGoTop()

	While ZZQ->(!Eof())

		If ZZQ->ZZQ_DTCARR # dDtCarre 
			DbSkip()
			Loop
		EndIf 

		nTotLib += ZZQ->ZZQ_QTDCXS 

		DbSkip()
	End

	DEFINE MSDIALOG oDlg FROM  47,130 TO 250,400 TITLE OemToAnsi("Total Programado") PIXEL

	@ 05, 04 TO 41,130 LABEL "Quantidade" OF oDlg	PIXEL //

	@ 18, 17 MSGET oTotLib  VAR nTotlib   PICTURE "@e 99,999,999" When .f. SIZE 70,14 FONT oFonte PIXEL;
	OF oDlg  COLOR CLR_HBLUE FONT oFonte RIGHT

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Botoes para confirmacao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	DEFINE SBUTTON FROM 77, 101 oButton2 TYPE 1 ENABLE OF oDlg ;
	ACTION (oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	RestArea(aArea)
Return 