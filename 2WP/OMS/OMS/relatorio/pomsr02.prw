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
ฑฑณFun…o    ณ POMSR02  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 11.09.18 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera o relatorio de controle de nota por transportadora    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function POMSR02()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Vari veis 										     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Relatorio de controle de entregas")
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
	cPerg := "POSMR02"

	aAdd(aRegs,{cPerg,"01","Da Transportadora  ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
	aAdd(aRegs,{cPerg,"02","Ate Transportadora ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA4",""})
	aAdd(aRegs,{cPerg,"03","Emissao de         ?","","","mv_ch3","D"   ,08    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Emissao Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"05","Romaneio de        ?","","","mv_ch5","C"   ,06    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Romaneio Ate       ?","","","mv_ch6","C"   ,06    ,00      ,0   ,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"07","Filtrar notas      ?","","","mv_ch7","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR07","Em Aberto"  ,"","","","","Entregue","","","","","Todas","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo gerar o relatorio de  " ) ) //
	AADD(aSays,OemToAnsi( " acordo com os parametros selecionados pelo usuario. " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||POSMR02PROC()},"Processando o arquivo..")

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

Static Function POSMR02PROC()
	Local aCampos := {}
	Local aArq := {{"SC9"," "},{"SF2"," "},{"SA1"," "},{"SA4"," "}}

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
	AADD(aCampos,{ "DESCTRA"  ,"C",20,0 } )
	AADD(aCampos,{ "ROMANEIO" ,"C",06,0 } )
	AADD(aCampos,{ "NOTA"     ,"C",09,0 } )
	AADD(aCampos,{ "EMISSAO"  ,"D", 8,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C",06,0 } )
	AADD(aCampos,{ "LOJA"     ,"C",03,0 } )
	AADD(aCampos,{ "NOME"     ,"C",30,0 } )
	AADD(aCampos,{ "DTCANHO"  ,"D", 8,0 } )
	AADD(aCampos,{ "LEADTIME" ,"N", 4,0 } )
	AADD(aCampos,{ "VOLUME"   ,"N", 8,0 } )
	AADD(aCampos,{ "VALBRUT"  ,"N",17,2 } )				
	AADD(aCampos,{ "PESO"     ,"N",11,2 } )
	AADD(aCampos,{ "VEND"     ,"C", 6,0 } )
	AADD(aCampos,{ "CIDADE"   ,"C",30,0 } )
	AADD(aCampos,{ "EST"      ,"C", 2,0 } )			
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )	
	// Peso ; Data de entrega (conforme LdTime ou agenda); vendedor; Cidade; Estado; Tipo de Nota  Fiscal (somente venda);

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"TRANSP+EMPRESA+NOTA",,,OemToAnsi("Selecionando Registros..."))	//

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
		cQuery += "             SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_TRANSP,SF2.F2_VOLUME1,SF2.F2_ROMANEI,  "
		cQuery += "             SF2.F2_PBRUTO, SF2.F2_VEND1,SF2.F2_VALBRUT, "
		cQuery += "             SF2.F2_DOC, SF2.F2_EMISSAO, SF2.F2_ZZDTREC, SA1.A1_NOME, SA4.A4_NOME,  " 
		cQuery += "             SA1.A1_EST,SA1.A1_MUN,SA1.A1_LEADTIM      "
		cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SF2" }),2]+" SF2 "

		//		cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]+" SC9  ON "
		//		cQuery += " SC9.D_E_L_E_T_ <> '*' AND SF2.F2_DOC = SC9.C9_NFISCAL "
		//		cQuery += "  AND SC9.C9_ROMANEI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "		

		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1  ON "
		cQuery += "      SA1.D_E_L_E_T_ <> '*' AND "
		cQuery += "      SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA "
		cQuery += "      AND SA1.A1_COD <> '002268' "

		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA4" }),2]+" SA4  ON "
		cQuery += " SA4.D_E_L_E_T_ <> '*' AND SA4.A4_COD = SF2.F2_TRANSP "

		cQuery += "  WHERE SF2.D_E_L_E_T_ <> '*' "
		cQuery += "  AND SF2.F2_TRANSP BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "  AND SF2.F2_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += "  AND SF2.F2_ROMANEI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		cQuery += "  AND SF2.F2_TIPO = 'N' AND SF2.F2_ZZTIPO IN('N','F') "		

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","F2_EMISSAO","D")
	TCSetField("QRY","F2_ZZDTREC","D")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")
	DbGoTop()

	While QRY->(!Eof()) 

		If MV_PAR07 # 3

			If MV_PAR07 == 1
				If !Empty(QRY->F2_ZZDTREC)
					QRY->(DbSkip())
					Loop
				EndIf  
			Else
				If Empty(QRY->F2_ZZDTREC)
					QRY->(DbSkip())
					Loop
				EndIf  
			EndIf  
		EndIf    

		DbSelectArea("TRB")
		If ! DbSeek(QRY->EMPRESA+QRY->F2_TRANSP+QRY->F2_DOC )
			RecLock("TRB",.T.)
			TRB->EMPRESA  := QRY->EMPRESA
			TRB->NOMEMP   := QRY->NOMEMP 
			TRB->TRANSP   := QRY->F2_TRANSP 
			TRB->DESCTRA  := QRY->A4_NOME
			TRB->ROMANEIO := QRY->F2_ROMANEI
			TRB->NOTA     := QRY->F2_DOC
			TRB->EMISSAO  := QRY->F2_EMISSAO
			TRB->CLIENTE  := QRY->F2_CLIENTE
			TRB->LOJA     := QRY->F2_LOJA
			TRB->NOME     := QRY->A1_NOME
			TRB->DTCANHO  := QRY->F2_ZZDTREC 	
			TRB->VOLUME   := QRY->F2_VOLUME1
			TRB->VALBRUT  := QRY->F2_VALBRUT				
			TRB->PESO     := QRY->F2_PBRUTO
			TRB->VEND     := QRY->F2_VEND1
			TRB->CIDADE   := QRY->A1_MUN
			TRB->EST      := QRY->A1_EST			
			TRB->ENTREG   := QRY->F2_EMISSAO + QRY->A1_LEADTIM 	

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

	DbSelectArea("TRB")

	cMarca  := GetMark()

	aBrowse := {}

	//	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"EMPRESA" ,"","Empresa"})
	AaDD(aBrowse,{"TRANSP","","Transp"})
	AaDD(aBrowse,{"DESCTRA","","Nomeo"})
	AaDD(aBrowse,{"ROMANEIO","","Romaneio"})

	AaDD(aBrowse,{"NOTA","","N.Fiscal"})
	AaDD(aBrowse,{"EMISSAO","","Dt Emissao"})

	AaDD(aBrowse,{"CLIENTE","","Cliente"})

	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Razao Social"})

	AaDD(aBrowse,{"CIDADE","","Cidade"})
	AaDD(aBrowse,{"EST","","Estado"})

	AaDD(aBrowse,{"DTCANHO","","Dt Canhoto"})
	AaDD(aBrowse,{"LEADTIME","","Lead Time","@E 9999"})	
	AaDD(aBrowse,{"VOLUME","","Volume","@E 999,999"})
	AaDD(aBrowse,{"PESO","","Peso","@E 999,999.999"})
	AaDD(aBrowse,{"VALBRUT","","Valor","@E 999,999.999"})
		
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
	/*	oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } */

	@ aPosObj[1,3]-20,aPosObj[1,4]-355 Button "&Sair"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel

	@ aPosObj[1,3]-20,aPosObj[1,4]-420 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel

//	@ aPosObj[1,3]-20,aPosObj[1,4]-485 Button "&Imprimir"    Size 60,15 Action ImprRel() of oDlg1 Pixel

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

//	DEFINE BUTTON RESOURCE "S4WB010N" OF oBar GROUP ACTION ImprRel() TOOLTIP OemToAnsi("Imprimir consulta...")

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

	oPrn:SetPortrait()

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
			cTitulo := "Relatorio de Entregas das transportadoras"
			cRod    := " " 
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"POMSR02")

			CabCons(oPrn)

			lFirst = .F.

		EndIf

		oPrn:Box(nLin,100,nLin+60,2300)

		oPrn:line(nLin, 250,nLin+60, 250)
		oPrn:line(nLin, 400,nLin+60, 400)
		oPrn:line(nLin,1000,nLin+60,1000)
		oPrn:line(nLin,1200,nLin+60,1200)	
		oPrn:line(nLin,1400,nLin+60,1400)
		oPrn:line(nLin,1600,nLin+60,1600)
		oPrn:line(nLin,1750,nLin+60,1750)
		oPrn:line(nLin,1800,nLin+60,1800)		
		oPrn:line(nLin,2150,nLin+60,2150)

		oPrn:Say(nLin+10,  110,TRB->EMPRESA       ,oFont9 ,100)
		oPrn:Say(nLin+10,  260,TRB->TRANSP        ,oFont9 ,100)
		oPrn:Say(nLin+10,  410,TRB->DESCTRA       ,oFont9 ,100)
		oPrn:Say(nLin+10, 1010,TRB->ROMANEIO      ,oFont9 ,100)
		oPrn:Say(nLin+10, 1210,TRB->NOTA          ,oFont9 ,100)				
		oPrn:Say(nLin+10, 1410,Dtoc(TRB->EMISSAO) ,oFont9 ,100)
		oPrn:Say(nLin+10, 1610,TRB->CLIENTE       ,oFont9 ,100)
		oPrn:Say(nLin+10, 1760,TRB->LOJA          ,oFont9 ,100)
		oPrn:Say(nLin+10, 1810,TRB->NOME          ,oFont14 ,100)
		oPrn:Say(nLin+10, 2160,Dtoc(TRB->DTCANHO) ,oFont9 ,100)  

		nLin += 60

		If nLin > 3200

			oPrn:EndPage()

			oPrn:StartPage()
			cTitulo := "Relatorio de Entregas das transportadoras "
			cRod    := " "
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"")

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

	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 400,nLin+60, 400)
	oPrn:line(nLin,1000,nLin+60,1000)
	oPrn:line(nLin,1200,nLin+60,1200)	
	oPrn:line(nLin,1400,nLin+60,1400)
	oPrn:line(nLin,1600,nLin+60,1600)
	oPrn:line(nLin,1750,nLin+60,1750)
	oPrn:line(nLin,1800,nLin+60,1800)		
	oPrn:line(nLin,2150,nLin+60,2150)

	oPrn:Say(nLin+10,  110,"Empresa" ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Transp."  ,oFont5 ,100)
	oPrn:Say(nLin+10,  410,"Nome"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 1010,"Romaneio"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1210,"Nota"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1410,"Emissao"   ,oFont5 ,100)	
	oPrn:Say(nLin+10, 1610,"Cliente"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1760,"Loja" ,oFont9 ,100)
	oPrn:Say(nLin+10, 1810,"Nome" ,oFont5 ,100)
	oPrn:Say(nLin+10, 2160,"Dt Canhoto" ,oFont5 ,100)	

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
	Dtoc(MV_PAR04)," " ," "," "," "," " ," "," " ," "," "," "," " ," " })

	AaDD( aDadosExcel, { " " ," "," "," "," " ," "," "," "," " ," "," " ," "," "," "," " ," " })

	AaDd(aDadosExcel,{ "Empresa" ,;
	"Transp."  ,;
	"Nome"       ,;
	"Romaneio"   ,;
	"Nota"     ,;
	"Emissao"   ,;	
	"Cliente"   ,;
	"Loja" ,;
	"Nome" ,;
	"Cidade",;
	"Estado",;
	"Dt Canhoto",;
	"Dt Entreg" ,;
	"Volume",;
	"Peso" ,;
	"Valor" })

	nCol := Len(aDadosExcel[1])

	nTotQtd := 0
	nTotVlr := 0

	DbSelectArea("TRB")
	DbGoTop()

	ProcRegua(RecCount())        // Total de Elementos da regua

	While TRB->(!EOF())

		AaDD( aDadosExcel, { TRB->EMPRESA,;
		TRB->TRANSP,;
		TRB->DESCTRA,;
		TRB->ROMANEIO,;
		TRB->NOTA,;
		Dtoc(TRB->EMISSAO),;
		TRB->CLIENTE,; 
		TRB->LOJA,;
		TRB->NOME,;	
		TRB->CIDADE,;
		TRB->EST,;	
		Dtoc(TRB->DTCANHO),;
		Dtoc(TRB->ENTREG) ,;
		Transform(TRB->VOLUME,"@E 999,999.99"),;
        Transform(TRB->PESO,"@E 9,999,999.99"),;		
		Transform(TRB->VALBRUT,"@E 9,999,999.99")})

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
