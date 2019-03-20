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
ฑฑณFun…o    ณ PACDA02  ณ Autor ณ Carlos R. Moreira     ณ Data ณ 11.04.18 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processa as etiquetas geradas no apontamento               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PACDA02()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Vari veis 										     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Processa as etiquetas geradas")

	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)

	aRegs := {}
	cPerg := "PACDA02"

	aAdd(aRegs,{cPerg,"01","Emissao de         ?","","","mv_ch1","D"   ,08    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Emissao Ate        ?","","","mv_ch2","D"   ,08    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"03","Filtra as etiquetas  ?","","","mv_ch3","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR03","Em Aberto"  ,"","","","","Apontadas","","","","","Todas","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi( " Este programa tem como objetivo selecionar as etiquetas emitidas" ) ) //
	AADD(aSays,OemToAnsi( " no periodo e checa a sua valida็ใo no armazem  " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||PACDA02PROC()},"Processando o arquivo..")

		Processa( {||MOSTRACONS()},"Mostrando a consulta..")

		TRB->(DbCloseArea())

	EndIf

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

Static Function PACDA02PROC()
	Local aCampos := {}
	Local aArq := {{"SD3"," "},{"ZZL"," "},{"SB1"," "}}

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	//Array com os campos do Arquivo temporario
	AADD(aCampos,{ "OK"      ,"C",02,0 } )
	AADD(aCampos,{ "EMPRESA" ,"C",10,0 } )
	AADD(aCampos,{ "ETIQ"    ,"C",10,0 } )
	AADD(aCampos,{ "EMISSAO" ,"D", 8,0 } )
	AADD(aCampos,{ "HORA"    ,"C", 8,0 } )	
	AADD(aCampos,{ "PROD"    ,"C",15,0 } )
	AADD(aCampos,{ "DESC"    ,"C",50,0 } )
	AADD(aCampos,{ "QUANT"   ,"N",11,0 } )
	AADD(aCampos,{ "DTAPON"  ,"D", 8,0 } )
	AADD(aCampos,{ "HRAPON"   ,"C", 8,0 } )	
	AADD(aCampos,{ "STATUS"  ,"C",01,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"ETIQ+PROD",,,OemToAnsi("Selecionando Registros..."))	//

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

		cQuery += " SELECT     '"+aEmp[nEmp]+"' EMPRESA, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_QUANT, SD3.D3_ZZETCB0 ,SD3.D3_ZZHORA,  "
		cQuery += "             ISNULL(ZZL.ZZL_ETIQUE,' ' ) ZZL_ETIQUE, ISNULL(ZZL.ZZL_EMISSA,' ' ) ZZL_EMISSA,ISNULL(ZZL.ZZL_HRAPON,' ' ) ZZL_HRAPON,  "
		cQuery += "             SB1.B1_DESC  " //, ISNULL(SZY.ZY_CODTRA,' ' ) ZY_CODTRA, ISNULL(SZY.ZY_DESTRA,' ' ) ZY_DESTRA "

		cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SD3" }),2]+" SD3 LEFT OUTER "
		cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "ZZL" }),2]+" ZZL ON "
		cQuery += " ZZL.D_E_L_E_T_ <> '*' AND SD3.D3_ZZETCB0 = ZZL.ZZL_ETIQUE "

		cQuery += "JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1  ON "
		cQuery += "      SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "      SD3.D3_COD = SB1.B1_COD AND SB1.B1_TIPO = 'PA' "

		cQuery += "   WHERE SD3.D_E_L_E_T_ <> '*' AND D3_CF = 'PR0' AND SD3.D3_ESTORNO <> 'S' "

		cQuery += "   AND SD3.D3_EMISSAO  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "

		(cAliasTrb)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","D3_EMISSAO","D")
	TCSetField("QRY","ZZL_EMISSA","D")


	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Gerando as selecao de apontamentos ...")

		If MV_PAR03 # 3 
			If MV_PAR03 == 1
				If !Empty(QRY->ZZL_ETIQUE)  
					DbSkip()
					Loop
				EndIf 
			Else
				If Empty(QRY->ZZL_ETIQUE)  
					DbSkip()
					Loop
				EndIf 

			EndIf 
		EndIf 

		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->EMPRESA := QRY->EMPRESA 
		TRB->ETIQ    := QRY->D3_ZZETCB0
		TRB->EMISSAO := QRY->D3_EMISSAO
		TRB->HORA    := QRY->D3_ZZHORA	
		TRB->PROD    := QRY->D3_COD
		TRB->DESC    := QRY->B1_DESC
		TRB->QUANT   := QRY->D3_QUANT
		TRB->DTAPON := QRY->ZZL_EMISSA
		TRB->HRAPON := QRY->ZZL_HRAPON	
		TRB->STATUS := IF( EMPTY(QRY->ZZL_ETIQUE)," ","A")
		MsUnlock()

		DbSelectArea('QRY')
		DbSkip()

	End

	QRY->(DbCloseArea())

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

Static Function MostraCons()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	DbSelectArea("TRB")

	cMarca  := GetMark()

	aBrowse := {}
	//	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"ETIQ","","Num Etiq"})
	AaDD(aBrowse,{"EMISSAO","","Emissao"})
	AaDD(aBrowse,{"PROD","","Produto"})
	AaDD(aBrowse,{"DESC","","Descricao"})

	AaDD(aBrowse,{"EMISSAO","","Dt Apontamento"})
	AaDD(aBrowse,{"HORA","","Hora Apontamento"})

	AaDD(aBrowse,{"QUANT","","Qtde Total","@E 999999"})

	AaDD(aBrowse,{"DTAPON","","Dt Conferencia"})
	AaDD(aBrowse,{"HRAPON","","Hora Conferencia"})

	//	AaDD(aBrowse,{"OBSEXT","","Obser Externa"})

	TRB->(DbGoTop())

	AADD(aObjects,{ 80,015,.T.,.T.})

	aCores := {}

	Aadd(aCores, { 'STATUS = " "', "ENABLE" } )
	Aadd(aCores, { 'STATUS = "A"', "DISABLE" } )

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Mostra a situacao das etiquetas" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
	//ณ arquivo de trabalho "TRB".                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+12,aPosObj[1,2]+10,aPosObj[1,3]-35,aPosObj[1,4]-10},,,,,aCores)
	oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

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
	DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcEtiq() TOOLTIP OemToAnsi("Procura a Etiqueta...")
	DEFINE BUTTON RESOURCE "S4WB010N" OF oBar GROUP ACTION ImprEtiq() TOOLTIP OemToAnsi("Imprimir consulta...")

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcTranspบAutor  ณCarlos R. Moreira   บ Data ณ  03/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona a transportadora para a montagem da Carga         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Scarlat                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function ProcEtiq()
	Local cEtiqueta := Space(10)
	Local oDlgProc

	cTitProc := "Procura Etiqueta"

	DEFINE MSDIALOG oDlgProc TITLE cTitProc From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite Etiq.: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cEtiqueta Size 60,10 of oDlgProc Pixel


	@ 50, 90 BMPBUTTON TYPE 1 Action PosEtiq(@cEtiqueta,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosEtiq(cEtiqueta,oDlgProc)

	TRB->(DbSeek(Alltrim(cEtiqueta),.T.))

	Close(oDlgProc)

Return


Static Function ImprEtiq()
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
			cTitulo := "Relatorio de Conferencia "
			cRod    := " " 
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,2,oPrn,nPag,"PACDA02")

			CabCons(oPrn)

			lFirst = .F.

		EndIf

		oPrn:Box(nLin,100,nLin+60,2300)

		oPrn:line(nLin, 350,nLin+60, 350)
		oPrn:line(nLin, 600,nLin+60, 600)
		oPrn:line(nLin,1300,nLin+60,1300)
		oPrn:line(nLin,1500,nLin+60,1500)
		oPrn:line(nLin,1700,nLin+60,1700)
		oPrn:line(nLin,1900,nLin+60,1900)	
		oPrn:line(nLin,2100,nLin+60,2100)

		oPrn:Say(nLin+10,  110,TRB->ETIQ  ,oFont9 ,100)
		oPrn:Say(nLin+10,  360,TRB->PROD  ,oFont9 ,100)
		oPrn:Say(nLin+10,  610,TRB->DESC    ,oFont9 ,100)
		oPrn:Say(nLin+10, 1310,Dtoc(TRB->EMISSAO) ,oFont9 ,100)
		oPrn:Say(nLin+10, 1510,TRB->HORA     ,oFont9 ,100)
		oPrn:Say(nLin+10, 1710,Dtoc(TRB->DTAPON)  ,oFont9 ,100)
		oPrn:Say(nLin+10, 1910,TRB->HRAPON ,oFont9 ,100)
		oPrn:Say(nLin+10, 2110,Transform(TRB->QUANT,"@E 99999" ) ,oFont5 ,100)

		nLin += 60

		If nLin > 3200

			oPrn:EndPage()

			oPrn:StartPage()
			cTitulo := "Relatorio de Conferencia "
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
	oPrn:line(nLin, 600,nLin+60, 600)
	oPrn:line(nLin,1300,nLin+60,1300)
	oPrn:line(nLin,1500,nLin+60,1500)
	oPrn:line(nLin,1700,nLin+60,1700)
	oPrn:line(nLin,1900,nLin+60,1900)	
	oPrn:line(nLin,2100,nLin+60,2100)

	oPrn:Say(nLin+10,  110,"Etiqueta" ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Produto"  ,oFont5 ,100)
	oPrn:Say(nLin+10,  610,"Descricao"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 1310,"Dt Emis"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1510,"Hora"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1710,"Dt Conf"   ,oFont5 ,100)
	oPrn:Say(nLin+10, 1910,"Hr.Conf." ,oFont5 ,100)
	oPrn:Say(nLin+10, 2110,"Quantidade" ,oFont5 ,100)

	nLin += 60

Return
