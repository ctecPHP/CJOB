#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOMSR03   บAutor  ณCarlos R. Moreira   บ Data ณ  08/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSolicita o Numero do Romaneio para Impressao da Carga       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function POMSR03()

	Local lRet := .F.
	Local oFonte
	Local oDlg
	Local oButton2
	Local oButton1
	Local oPedido
	Local oSay
	Local oSay_2
	Local uRet

	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	cCadastro := "Relatorio de Entregas por Romaneio"

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
	cPerg := "POSMR03"

	aAdd(aRegs,{cPerg,"01","Romaneio de        ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Romaneio Ate       ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"03","Emissao de         ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Emissao Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"05","Carregamento de    ?","","","mv_ch5","D"   ,08    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Carregamento Ate   ?","","","mv_ch6","D"   ,08    ,00      ,0   ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo gerar o relatorio de  " ) ) //
	AADD(aSays,OemToAnsi( " acordo com os parametros selecionados pelo usuario. " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||POMSR03PROC()},"Processando o arquivo..")

		Processa( {||MOSTRACONS()},"Mostrando a consulta..")

		ROM->(DbCloseArea())

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOMSR03PR บAutor  ณCarlos R. Moreira   บ Data ณ  21/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIra selecionar os romaneios                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function POMSR03PROC()
	Local aCampos := {}
	Local aArq := {{"SC9"," "},{"SC5"," "},{"SA1"," "},{"SB1"," "}}

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )
	AADD(aCampos,{ "PEDIDO"  ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE" ,"C",06,0 } )
	AADD(aCampos,{ "LOJA"    ,"C",03,0 } )
	AADD(aCampos,{ "NOME"    ,"C",33,0 } )
	AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
	AADD(aCampos,{ "DTENT"   ,"D", 8,0 } )
	AADD(aCampos,{ "DTAGEN"  ,"D", 8,0 } )
	AADD(aCampos,{ "PESO"    ,"N",11,0 } )
	AADD(aCampos,{ "QTDCX"   ,"N",11,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,4 } )

	AADD(aCampos,{ "TRANSP"  ,"C",06,0 } )
	AADD(aCampos,{ "DESCTRA" ,"C",20,0 } )

	AADD(aCampos,{ "ROMANEI" ,"C", 6,0 } )

	AADD(aCampos,{ "MOTORIS" ,"C", 6,0 } )
	AADD(aCampos,{ "VEICULO" ,"C", 4,0 } )

	AADD(aCampos,{ "DTCARRE" ,"D", 8,0 } )	
	AADD(aCampos,{ "EMPRESA" ,"C", 2,0 } )
	AADD(aCampos,{ "NOMEMP"  ,"C",10,0 } )
	AADD(aCampos,{ "TPVEIC"  ,"C", 2,0 } )
	AADD(aCampos,{ "TPCARRO" ,"C", 1,0 } )			

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"ROM", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("ROM",cNomArq,"ROMANEI+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

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

		cQuery += " SELECT	'"+aEmp[nEmp]+"' EMPRESA, SC9.C9_PEDIDO, SC9.C9_CLIENTE, SC9.C9_LOJA, SC9.C9_TRAROM, SC9.C9_ROMANEI,SC9.C9_VEICULO, "
		cQuery += " 		SC9.C9_TIPOVEI,  SC9.C9_DTCARRE,SC9.C9_TPCARRO, " 
		cQuery += " 		SA1.A1_NOME "

		cQuery += " FROM   "+aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9  "
		cQuery += " JOIN "+aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
		cQuery += "       SA1.D_E_L_E_T_ <> '*' AND  "
		cQuery += "    SC9.C9_CLIENTE = SA1.A1_COD AND SC9.C9_LOJA = SA1.A1_LOJA "

		cQuery += "  WHERE SC9.D_E_L_E_T_ <> '*'  "
		cQuery += "        AND SC9.C9_ROMANEI BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "        AND SC9.C9_EMIROM  BETWEEN  '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += "        AND SC9.C9_DTCARRE BETWEEN  '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
		
		(cAliasROM)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C9_EMIROM","D")
	TCSetField("QRY","C9_DTCARRE","D")	

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Gerando as selecao de Pedido de vendas...")

		DbSelectArea("ROM")

		If !DbSeek(QRY->C9_ROMANEI+QRY->C9_PEDIDO)

			RecLock("ROM",.T.)
			ROM->PEDIDO  := QRY->C9_PEDIDO
			ROM->CLIENTE := QRY->C9_CLIENTE
			ROM->LOJA    := QRY->C9_LOJA
			ROM->NOME    := QRY->A1_NOME 
			ROM->TRANSP  := QRY->C9_TRAROM
			ROM->ROMANEI := QRY->C9_ROMANEI
			ROM->DTCARRE := QRY->C9_DTCARRE
			ROM->NOMEMP  := If(QRY->EMPRESA=="01","Sobel","JMT" ) 
			ROM->TPCARRO := QRY->C9_TPCARRO
			ROM->TPVEIC  := QRY->C9_TIPOVEI
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

	DbSelectArea("ROM")

	cMarca  := GetMark()

	aBrowse := {}

	//	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"EMPRESA" ,"","Empresa"})
	AaDD(aBrowse,{"NOMEMP" ,"","Nome Empresa"})
	AaDD(aBrowse,{"ROMANEI","","Romaneio"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})

	AaDD(aBrowse,{"TRANSP","","Transp"})
	AaDD(aBrowse,{"DESCTRA","","Nome"})

	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Razao Social"})


	ROM->(DbGoTop())

	AADD(aObjects,{ 80,015,.T.,.T.})

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Mostra o resultado da consulta" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "ROM".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("ROM","","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+1 ,aPosObj[1,2]   ,aPosObj[1,3]-35,aPosObj[1,4]-5 }) //,,,,,aCores)
	oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	@ aPosObj[1,3]-20,aPosObj[1,4]-355 Button "&Sair"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel

	@ aPosObj[1,3]-20,aPosObj[1,4]-420 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel

	@ aPosObj[1,3]-20,aPosObj[1,4]-485 Button "&Imprimir"    Size 60,15 Action ImprRel() of oDlg1 Pixel

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

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
ฑฑณFun…o    ณImprRel  rณ Autor ณ Carlos R Moreira      ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Imprime o relatorio                                        ณฑฑ
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

	oPrn:SetPortrait()

	oPrn:SetPaperSize(9)

	lFirst := .t.
	lPri := .T.
	nPag := 0
	nLin := 490

	DbSelectArea("ROM")
	DbGoTop()

	ProcRegua(RecCount())

	While ROM->(!Eof())

		IncProc("Gerando a impressao...")

		cRomaneio := ROM->ROMANEI
		cTpCarro  := ROM->TPCARRO
		dDtCarre  := ROM->DTCARRE
		dDtEmi    := ROM->EMIROM

		lFirst := .T. 

		While ROM->(!Eof()) .And. cRomaneio == ROM->ROMANEI

			If lFirst
				oPrn:StartPage()
				cTitulo := "Entregas do Romaneio N. "+cRomaneio+" - Dt. Gera็ใo: "+Dtoc(dDtEmi)	
//				cTitulo := "Relatorio de Entregas por Romaneio"
//				cRod    := "Romaneio: "+cRomaneio 
				cRod    := "Data de Carregamento : "+Dtoc(dDTCARRE)+" Carga: "+If(cTPCARRO=="1" ,"Batida","Paletizada")
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,2,oPrn,nPag,"POMSR03")

	            nLin := 320
	            
				oPrn:Box(nLin,100,nLin+60,2300)
				oPrn:line(nLin, 1150,nLin+60, 1150)

				cTpVeic := ROM->TPVEIC+"- "+Posicione("DUT",1,xFilial("DUT")+ROM->TPVEIC,"DUT_DESCRI")

				oPrn:Say(nLin+10,  110,"Veiculo: "+cTpVeic    ,oFont5 ,100)
				oPrn:Say(nLin+10,  1160,"Tipo Carga: "+IF(ROM->TPCARRO=='1',"Batida","Paletizada")  ,oFont5 ,100)

				nLin += 80 

				CabCons(oPrn)

				lFirst = .F.


			EndIf

			oPrn:Box(nLin,100,nLin+60,2300)

			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 400,nLin+60, 400)
			oPrn:line(nLin, 550,nLin+60, 550)			
			oPrn:line(nLin, 650,nLin+60, 650)
			oPrn:line(nLin,1800,nLin+60,1800)		
			oPrn:line(nLin,2050,nLin+60,2050)

			oPrn:Say(nLin+10,  110,ROM->PEDIDO        ,oFont9 ,100)			
			oPrn:Say(nLin+10,  260,ROM->NOMEMP        ,oFont9 ,100)
			oPrn:Say(nLin+10,  410,ROM->CLIENTE       ,oFont9 ,100)
			oPrn:Say(nLin+10,  560,ROM->LOJA          ,oFont9 ,100)
			oPrn:Say(nLin+10,  660,ROM->NOME          ,oFont9 ,100)

			nLin += 60

			If nLin > 3200

				oPrn:EndPage()

				oPrn:StartPage()
				cTitulo := "Relatorio de Entregas por Romaneio "
				cRod    := "Romaneio: "+cRomaneio
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,2,oPrn,nPag,"")

				CabCons(oPrn)

			EndIf

			DbSelectArea("ROM")
			DbSkip()

		End 

		nLin := 3100
		oPrn:Box(nLin,100,nLin+200,2300)

		oPrn:Line(nLin,1150,nLin+200,1150)

		oPrn:Say( nLin+5,  120, "Motorista" ,oFont9,100 )
		oPrn:Say( nLin+5,  1170, "Conferente / Data / Hora" ,oFont9,100 )

		oPrn:EndPage()

	End 

	oPrn:Preview()

	oPrn:End()

	MS_FLUSH()

	ROM->(DbGoTop())

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

	oPrn:FillRect({nLin,100,nLin+60,2300},oBrush)

	oPrn:Box(nLin,100,nLin+60,2300)

	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 400,nLin+60, 400)
	oPrn:line(nLin, 550,nLin+60, 550)			
	oPrn:line(nLin, 650,nLin+60, 650)
	oPrn:line(nLin,1800,nLin+60,1800)		
	oPrn:line(nLin,2050,nLin+60,2050)

	oPrn:Say(nLin+10,  110,"Pedido" ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Empresa" ,oFont5 ,100)
	oPrn:Say(nLin+10,  410,"Cliente"   ,oFont5 ,100)
	oPrn:Say(nLin+10,  560,"Loja" ,oFont9 ,100)
	oPrn:Say(nLin+10,  660,"Nome" ,oFont5 ,100)
	oPrn:Say(nLin+10,  1860,"Chegada" ,oFont5 ,100)
	oPrn:Say(nLin+10,  2060,"Saida" ,oFont5 ,100)
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

	AaDD( aDadosExcel, { " " ," "," "," "," " ," "," " })

	AaDd(aDadosExcel,{ "Empresa" ,;
	"Transp."  ,;
	"Nome"       ,;
	"Romaneio"   ,;
	"Cliente"   ,;
	"Loja" ,;
	"Nome"  })

	nCol := Len(aDadosExcel[1])

	nTotQtd := 0
	nTotVlr := 0

	DbSelectArea("ROM")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While ROM->(!EOF())

		AaDD( aDadosExcel, { ROM->EMPRESA,;
		ROM->TRANSP,;
		ROM->DESCTRA,;
		ROM->ROMANEI,;
		ROM->CLIENTE,; 
		ROM->LOJA,;
		ROM->NOME })

		DbSelectArea("ROM")
		DbSkip()

	End

	Processa({||Run_Excel(aDadosExcel,nCol)},"Gerando a Integra็ใo com o Excel...")

	MsgInfo("Exportacao efetuada com sucesso..")

	ROM->(DbGotop())

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
