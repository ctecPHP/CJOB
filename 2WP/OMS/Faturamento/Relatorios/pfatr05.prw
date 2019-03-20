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
ฑฑณFun…o    ณ PFATR05  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 11.09.18 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera o relatorio de  Romaneio a serem enviado as transp    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PFATR05()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Vari veis 										     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Conferencia de estoque de carteira")
	Private aPedidos := {}
	Private aEmp := {}
	Private nPesoPed := 0
	Private cTpFrete := " "
	Private nTotFreNeg := 0
	Private aOrdCarg  := {}
	Private lFiltraGru := .F.

	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar nos romaneios.",If(SM0->M0_CODIGO="01","02",""))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf 

	aRegs := {}
	cPerg := "PFATR05"

	aAdd(aRegs,{cPerg,"01","Da produto         ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	aAdd(aRegs,{cPerg,"02","Ate produto        ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	aAdd(aRegs,{cPerg,"03","Entrega de         ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Entrega Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Status do Pedido   ?","","","mv_ch5","C"   ,40    ,00      ,0   ,"G","U_FESTPED","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//	aHelpPor :=	{"Seleciona o Status dos Pedidos"}
//	aHelpEsp :=	{}
//	aHelpEng :=	{}

//	PutSx1( cPerg, 	"05","Status do Pedido        ?","Imprimir em ordem ?","Imprimir em ordem ?","mv_ch5","C",40,0,1,"G","U_FSTAPED()","","","",;
//	"mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

	//	aAdd(aRegs,{cPerg,"05","Romaneio de        ?","","","mv_ch5","C"   ,06    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//	aAdd(aRegs,{cPerg,"06","Romaneio Ate       ?","","","mv_ch6","C"   ,06    ,00      ,0   ,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"07","Filtrar notas      ?","","","mv_ch7","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR07","Em Aberto"  ,"","","","","Entregue","","","","","Todas","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo gerar o relatorio de  " ) ) //
	AADD(aSays,OemToAnsi( " acordo com os parametros selecionados pelo usuario. " ) )
	AADD(aSays,OemToAnsi( " demonstrando o estoque dos produtos no periodo de entrega. " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||PFATR05PROC()},"Processando o arquivo..")

		Processa( {||MOSTRACONS()},"Mostrando a consulta..")

		TRB->(DbCloseArea())

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATR05PRO Autor  ณCarlos R. Moreira   บ Data ณ  23/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra selecionar os pedidos de Vendas                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFATR05PROC()
	Local aCampos := {}
	Local aArq := {{"SC5"," "},{"SC6"," "}}

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
	AADD(aCampos,{ "PROD"     ,"C",15,0 } )
	AADD(aCampos,{ "DESC"     ,"C",40,0 } )
	AADD(aCampos,{ "LOCEST"   ,"C", 2,0 } )	
	AADD(aCampos,{ "QUANT"    ,"N",11,0 } )
	AADD(aCampos,{ "SLDATU"   ,"N",11,0 } )
	AADD(aCampos,{ "RESERVA"  ,"N",11,0 } )
	AADD(aCampos,{ "QTDDIS"   ,"N",11,0 } )
	AADD(aCampos,{ "QTDPRD"   ,"N", 11,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"PROD",,,OemToAnsi("Selecionando Registros..."))	//

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

		cQuery += " SELECT  SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_LOCAL  "
		cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5 "
		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SC6" }),2]+" SC6 ON "
		cQuery += "  SC6.D_E_L_E_T_ <> '*' AND SC6.C6_NUM = SC5.C5_NUM "
		cQuery += "  AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "  AND SC6.C6_ENTREG BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "

		cQuery += "  WHERE SC5.D_E_L_E_T_ <> '*' "
		cQuery += "  AND SC5.C5_STAPED = 'L'  "		

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C6_ENTREG","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGoTop()

	While QRY->(!Eof()) 

		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+QRY->C6_PRODUTO+QRY->C6_LOCAL )

		DbSelectArea("TRB")

		If ! DbSeek(QRY->C6_PRODUTO )
			RecLock("TRB",.T.)
			TRB->PROD    := QRY->C6_PRODUTO
			TRB->DESC    := QRY->C6_DESCRI
			TRB->LOCEST  := QRY->C6_LOCAL	
			TRB->QUANT   := QRY->C6_QTDVEN
			TRB->SLDATU  := SB2->B2_QATU
			TRB->RESERVA := SB2->B2_RESERVA 
			TRB->QTDDIS  := (SB2->B2_QATU - SB2->B2_RESERVA )
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			TRB->QUANT += QRY->C6_QTDVEN   
			MsUnlock()

		EndIF 

		DbSelectArea("QRY")
		DbSkip()

	End 

	QRY->(DbCloseArea())

	DbSelectArea("TRB")
	DbGoTop()

	While TRB->(!Eof())

		Reclock("TRB",.F.)
		TRB->QTDPRD := TRB->QTDDIS - TRB->QUANT 
		MsUnlock()

		DbSkip()

	End

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
	AaDD(aBrowse,{"PROD","","Produto"})
	AaDD(aBrowse,{"DESC","","Descricao"})
	AaDD(aBrowse,{"QUANT","","Qtde Cart","@E 9999999"})	
	AaDD(aBrowse,{"SLDATU","","Saldo Atu","@E 9999999"})	
	AaDD(aBrowse,{"RESERVA","","Qtd Reserva","@E 9999999"})
	AaDD(aBrowse,{"QTDDIS","","Qtd Disponivel","@E 9999999"})
	AaDD(aBrowse,{"QTDPRD","","Qtd a Produzir","@E 9999999"})

	TRB->(DbGoTop())

	AADD(aObjects,{ 80,015,.T.,.T.})

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Mostra o resultado da consulta" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+1 ,aPosObj[1,2]   ,aPosObj[1,3]-35,aPosObj[1,4]-5 }) //,,,,,aCores)
/*	oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } */

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

	oPrn:Setportrait()

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
			cTitulo := "Relatorio posicao de estoque da carteira"
			cRod    := " " 
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"PFATA05")

			CabCons(oPrn)

			lFirst = .F.

		EndIf

		oPrn:Box(nLin,100,nLin+60,2300)

		oPrn:line(nLin, 400,nLin+60, 400)
		oPrn:line(nLin,1000,nLin+60,1000)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1550,nLin+60,1550)	
		oPrn:line(nLin,1800,nLin+60,1800)		
		oPrn:line(nLin,2050,nLin+60,2050)

		oPrn:Say(nLin+10,  110,TRB->PROD          ,oFont9 ,100)
		oPrn:Say(nLin+10,  410,TRB->DESC          ,oFont9 ,100)
		oPrn:Say(nLin+10, 1060,Transform(TRB->QUANT,"@e 99999" )  ,oFont5 ,100)
		oPrn:Say(nLin+10, 1310,Transform(TRB->SLDATU,"@e 99999" ) ,oFont5 ,100)
		oPrn:Say(nLin+10, 1560,Transform(TRB->RESERVA,"@e 99999" ) ,oFont5 ,100)		
		oPrn:Say(nLin+10, 1810,Transform(TRB->QTDDIS,"@e 99999" )  ,oFont5 ,100)
		oPrn:Say(nLin+10, 2060,Transform(TRB->QTDPRD,"@e 99999" )  ,oFont5  ,100)

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

	oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

	oPrn:Box(nLin,100,nLin+60,2300)

	oPrn:line(nLin, 400,nLin+60, 400)
	oPrn:line(nLin,1000,nLin+60,1000)
	oPrn:line(nLin,1300,nLin+60,1300)	
	oPrn:line(nLin,1550,nLin+60,1550)		
	oPrn:line(nLin,1800,nLin+60,1800)
	oPrn:line(nLin,2050,nLin+60,2050)

	oPrn:Say(nLin+10,  110,"Produto"        ,oFont5 ,100)
	oPrn:Say(nLin+10,  410,"Descricao"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 1060,"Quantidade"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1310,"Saldo Atual"    ,oFont5 ,100)	
	oPrn:Say(nLin+10, 1560,"Qtde Reserva"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1810,"Qtd Disponivel" ,oFont5 ,100)	
	oPrn:Say(nLin+10, 2060,"Qtd a Prod"     ,oFont5 ,100)	

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
	Dtoc(MV_PAR04)," " ," "," " })

	AaDD( aDadosExcel, { " " ," "," "," "," " ," "," "})

	AaDd(aDadosExcel,{ 	"Produto"  ,;
	"Descricao"        ,;
	"Quantidade"   ,;
	"Saldo Atu"   ,;	
	"Qtde Reserva"   ,;
	"Qtde Disponivel" ,;			
	"Qtde Produzir" })

	nCol := Len(aDadosExcel[1])

	nTotQtd := 0
	nTotVlr := 0

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->PROD,;
		TRB->DESC,;
		Transform(TRB->QUANT,"@E 9999999"),;		
		Transform(TRB->SLDATU,"@E 9999999") ,;
		Transform(TRB->RESERVA,"@E 9999999"),;
		Transform(TRB->QTDDIS,"@E 9999999"),;		 
		Transform(TRB->QTDPRD,"@E 9999999")})				

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSTAPED   บAutor  ณCristiano           บ Data ณ  10/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona status do pedido qto LF-Liberado Faturamento;     บฑฑ
ฑฑบ          ณBF-Bloqueio Financeiro;BC-Bloqueio Comercial;FT-Faturado    บฑฑ
ฑฑบ          ณFP-Faturado Parcial                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSTAPED                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FSTAPED(l1Elem,lTipoRet)

	Local cTitulo:=""
	Local MvPar
	Local MvParDef:=""

	Private aCat:={}

	DEFAULT lTipoRet := .T.

	l1Elem := If (l1Elem = Nil , .F. , .T.)

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	aCat :={;
	"FP - Faturado Parcial",;
	"FT - Faturado",;
	"BC - Bloqueio Comercial",;
	"BF - Bloqueio Financeiro",;
	"BE - Bloqueio Estoque",;
	"LF - Liberado Faturamento",;
	"RL - Residuos Eliminados",;
	"BL - Bloqueio Customer",;
	"PE - Programada Entrega",;
	"BM - Bloqueio Margem" }

	MvParDef:="1234567890"
	cTitulo :="Status Pedido"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			mvpar := STRTRAN (mvpar,"1","'P'," )
			mvpar := STRTRAN (mvpar,"2","'F'," )
			mvpar := STRTRAN (mvpar,"3","'S'," )
			mvpar := STRTRAN (mvpar,"4","'C'," )
			mvpar := STRTRAN (mvpar,"5","'E'," )
			mvpar := STRTRAN (mvpar,"6","'D'," )
			mvpar := STRTRAN (mvpar,"7","'R'," )
			mvpar := STRTRAN (mvpar,"8","'L'," )
			mvpar := STRTRAN (mvpar,"9","'A'," )
			mvpar := STRTRAN (mvpar,"0","'M'" )		
			&MvRet := mvpar										 // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )
