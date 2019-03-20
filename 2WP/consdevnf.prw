#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsNf    บAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConsDevNF()

Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local cCadastro := OemToAnsi("Gera o consulta de Itens Nota Saida")
Private  cArqTxt
Private cPerg := "CONSDEVNF"

PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"03","Cliente De                 ?","","","mv_ch3","C",  6,0,0,"G","","","SA1","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"04","Cliente Ate                ?","","","mv_ch4","C",  6,0,0,"G","","","SA1","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  3,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_1ch6","C",  3,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"07","Estado  De                 ?","","","mv_ch7","C",  2,0,0,"G","","","12","","mv_par07","","","","","","","","","","","","","","","","",{{"Estado  Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"08","Estado  Ate                ?","","","mv_ch8","C",  2,0,0,"G","","","12","","mv_par08","","","","","","","","","","","","","","","","",{{"Estado  Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"09","Produto de                 ?","","","mv_ch9","C", 15,0,0,"G","","","SB1","","mv_par09","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"10","Produto Ate                ?","","","mv_cha","C", 15,0,0,"G","","","SB1","","mv_par10","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"11","Supervisor de              ?","","","mv_chb","C",  6,0,0,"G","","","SA3SUP","","mv_par11","","","","","","","","","","","","","","","","",{{"tipo de Produto Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"12","Supervisor  Ate            ?","","","mv_chc","C",  6,0,0,"G","","","SA3SUP","","mv_par12","","","","","","","","","","","","","","","","",{{"tipo de Produto Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"13","Vendedor de                ?","","","mv_chd","C",  6,0,0,"G","","","SA3","","mv_par13","","","","","","","","","","","","","","","","",{{"Vendedor Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"14","Vendedor Ate               ?","","","mv_che","C",  6,0,0,"G","","","SA3","","mv_par14","","","","","","","","","","","","","","","","",{{"Vendedor Final  "}},{{" "}},{{" "}},"")

aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"15","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
"mv_par15","Nao","","","","Sim","","",;
"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

Pergunte(cPerg,.F.)

Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
Aadd(aButtons, { 2, .T., { || FechaBatch() }})
Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

FormBatch(cCadastro, aSays, aButtons)

If nOpca == 1
	
	If MV_PAR15 == 2
		
		DbSelectArea("SM0")
		aAreaSM0 := GetArea()
		
		aEmp := U_SelEmp("V")
		
		RestArea( aAreaSM0 )
		
		If Len(aEmp) == 0
			MsgStop("Nao houve selecao de nenhuma empresa")
		EndIf
	Else
	    aEmp := {}
		Aadd( aEmp, SM0->M0_CODIGO )
	Endif
	
	If Len(aEmp) > 0
		
		CriaArqTmp()
		
		For nX := 1 to Len(aEmp)
			Processa( { || Proc_Arq(aEmp[nX]) }, "Processando o arquivo de trabalho .")  //
		Next
		
		Processa({||MostraCons()},"Mostra a Consulta..")
		
		TRB->(DbCloseArea())
		
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R. Moreira   บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
Local aNomArq := {}
Local aArq := {{"SD1"," "},{"SA1"," "},{"SF1"," "}}

cArq   := "sx2"+cEmp+"0"
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

cArquivos := ""

For nArq := 1 to Len(aArq)
	cArquivos += aArq[nArq,2]+" "+aArq[nArq,1]
	If nArq # Len(aArq)
		cArquivos += ","
	EndIf
Next

cQuery := "Select SA1.A1_NOME,SA1.A1_CGC,SA1.A1_MUN,SA1.A1_EST,SA1.A1_VEND, "
cQuery += "	SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DTDIGIT,"
cQuery += "	SD1.D1_QUANT,SD1.D1_TOTAL,SD1.D1_VALIPI,SD1.D1_UM, SD1.D1_CUSTO, "
cQuery += "	SD1.D1_VALICM,SD1.D1_TES,SD1.D1_IPI,SD1.D1_VUNIT,SD1.D1_CF, "
cQuery += "	SD1.D1_PICM,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE, SD1.D1_EMISSAO,"
cQuery += "	SD1.D1_TIPO,SD1.D1_ICMSRET,SD1.D1_TP,SD1.D1_LOCAL,  "
cQuery += "	SD1.D1_VALIMP5,SD1.D1_VALIMP6, "
cQuery += " SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_ITEMORI, "
cQuery += " SD1.D1_DOC,SD1.D1_SERIE " //,SF1.F1_MOTIVO,SF1.F1_DESMOT,SF1.F1_OBSMOT   "
cQuery += "	From "+cArquivos
cQuery += "	Where SD1.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SF1.D_E_L_E_T_ <> '*'"
cQuery += "	And SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
cQuery += "	And SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
cQuery += "	And SD1.D1_FORNECE BETWEEN '"+MV_PAR03+"' And '"+mv_par04+"'"
cQuery += "	And SD1.D1_LOJA BETWEEN '"+MV_PAR05+"' And '"+mv_par06+"'"
cQuery += "	And SA1.A1_EST  BETWEEN '"+MV_PAR07+"' And '"+mv_par08+"'"
cQuery += " And SF1.F1_DOC = SD1.D1_DOC And SF1.F1_SERIE = SD1.D1_SERIE And SF1.F1_FORNECE = SD1.D1_FORNECE "
cQuery += "	And SD1.D1_COD BETWEEN '"+MV_PAR09+"' And '"+mv_par10+"'"
cQuery += " And SD1.D1_TIPO = 'D' And SD1.D1_TP = 'PA' "
cQuery += "	And SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
cQuery += "	And SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
TCSetField("QRY","D1_DTDIGIT","D")
TCSetField("QRY","D1_EMISSAO","D")

//Abro os Arquivos nas respectivas empresas
cArqSC5 := "SC5"+cEmp+"0"

DbUseArea(.T.,"TOPCONN",cArqSC5,cArqSC5,.T.,.F.)

If Select( cArqSC5 ) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek("SC5"))
	While SIX->INDICE == "SC5" .And. SIX->(!Eof())
		DbSetIndex(cArqSC5+SIX->ORDEM)
		SIX->(DbSkip())
	End
	DbSetOrder(1)
	
EndIf

cArqSC9 := "SC9"+cEmp+"0"

DbUseArea(.T.,"TOPCONN",cArqSC9,cArqSC9,.T.,.F.)

If Select( cArqSC9 ) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek("SC9"))
	While SIX->INDICE == "SC9" .And. SIX->(!Eof())
		DbSetIndex(cArqSC9+SIX->ORDEM)
		SIX->(DbSkip())
	End
	DbSetOrder(1)
	
EndIf

cArqSD2 := "SD2"+cEmp+"0"

DbUseArea(.T.,"TOPCONN",cArqSD2,cArqSD2,.T.,.F.)

If Select( cArqSD2 ) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek("SD2"))
	While SIX->INDICE == "SD2" .And. SIX->(!Eof())
		DbSetIndex(cArqSD2+SIX->ORDEM)
		SIX->(DbSkip())
	End
	DbSetOrder(1)
	
EndIf

cArqSF2 := "SF2"+cEmp+"0"

DbUseArea(.T.,"TOPCONN",cArqSF2,cArqSF2,.T.,.F.)

If Select( cArqSF2 ) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek("SF2"))
	While SIX->INDICE == "SF2" .And. SIX->(!Eof())
		DbSetIndex(cArqSF2+SIX->ORDEM)
		SIX->(DbSkip())
	End
	DbSetOrder(1)
	
EndIf

cArqSA3 := "SA3"+cEmp+"0"

DbUseArea(.T.,"TOPCONN",cArqSA3,cArqSA3,.T.,.F.)

If Select( cArqSA3 ) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIra fazer a abertura do Indice da Tabela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SIX->(DbSeek("SA3"))
	While SIX->INDICE == "SA3" .And. SIX->(!Eof())
		DbSetIndex(cArqSA3+SIX->ORDEM)
		SIX->(DbSkip())
	End
	DbSetOrder(1)
	
EndIf

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
	
	(cArqSD2)->(DbSetOrder(3))
	If !(cArqSD2)->(DbSeek(xFilial("SD2")+QRY->D1_NFORI+QRY->D1_SERIORI+QRY->D1_FORNECE+QRY->D1_LOJA+QRY->D1_COD+QRY->D1_ITEMORI ))
	   If !(cArqSD2)->(DbSeek(xFilial("SD2")+QRY->D1_NFORI+QRY->D1_SERIORI+QRY->D1_FORNECE+QRY->D1_LOJA+QRY->D1_COD ))
//			DbSelectArea("QRY")
//			DbSkip()
//			Loop
		EndIf
	EndIf
	
	(cArqSC5)->(DbSetOrder(1))
	(cArqSC5)->(DbSeek(xFilial("SC5")+(cArqSD2)->D2_PEDIDO ))
	
	If (cArqSC5)->C5_VEND1 < MV_PAR13 .Or. (cArqSC5)->C5_VEND1 > MV_PAR14
		QRY->(DbSkip())
		Loop
	EndIf


	(cArqSA3)->(DbSetOrder(1))
	(cArqSA3)->(DbSeek(xFilial("SA3")+ (cArqSC5)->C5_VEND1))

	If (cArqSA3)->A3_SUPER < MV_PAR11 .Or. (cArqSA3)->A3_SUPER > MV_PAR12
		QRY->(DbSkip())
		Loop
 	EndIf
 
	(cArqSF2)->(DbSetOrder(1))
	(cArqSF2)->(DbSeek(xFilial("SF2")+ QRY->D1_NFORI+QRY->D1_SERIORI))
	
	//Verifica o Frete Real se for Zerado pegara o calculado no Romaneio
	nVlrFre := 	0 //((cArqSD2)->D2_V_CTR_N+(cArqSD2)->D2_V_CTR_D+(cArqSD2)->D2_V_CTR_R+(cArqSD2)->D2_V_CTRDI)
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->DOC      := QRY->D1_DOC
	TRB->SERIE    := QRY->D1_SERIE
	TRB->PRODUTO  := QRY->D1_COD
	TRB->DESC     := Posicione("SB1",1,xFilial("SB1")+QRY->D1_COD,"B1_DESC")
	TRB->QUANT    := QRY->D1_QUANT
	TRB->UM       := QRY->D1_UM
    TRB->LOCDEV   := QRY->D1_LOCAL
	TRB->DTEMI    := QRY->D1_EMISSAO
	TRB->DTDIGIT  := QRY->D1_DTDIGIT
	TRB->PRUNIT   := QRY->D1_VUNIT
	TRB->VALIPI   := QRY->D1_VALIPI
	TRB->VALICM   := QRY->D1_VALICM
	TRB->ICMSRET  := QRY->D1_ICMSRET

	TRB->TOTAL    := QRY->D1_TOTAL + QRY->D1_VALIPI

	TRB->CUSTO    := QRY->D1_CUSTO
	TRB->IPI      := QRY->D1_IPI
	TRB->PICM     := QRY->D1_PICM
	
	TRB->COMIS    := (cArqSD2)->D2_COMIS1
	TRB->CLIENTE  := QRY->D1_FORNECE
	TRB->LOJA     := QRY->D1_LOJA
	TRB->CGC      := QRY->A1_CGC
	TRB->NOME     := QRY->A1_NOME
	TRB->MUN      := QRY->A1_MUN
	TRB->EST      := QRY->A1_EST

	TRB->VEND     := (cArqSC5)->C5_VEND1
	TRB->NOMVEND  := Posicione("SA3",1,xFilial("SA3")+TRB->VEND,"A3_NOME")
		
	TRB->NFORI    := QRY->D1_NFORI
	TRB->SERIORI  := QRY->D1_SERIORI
	TRB->ITEMORI  := QRY->D1_ITEMORI
	TRB->DTNF     := (cArqSD2)->D2_EMISSAO
	TRB->CF       := QRY->D1_CF
	TRB->VALFRE   := nVlrFre
	TRB->COFINS   := QRY->D1_VALIMP5
	TRB->PIS      := QRY->D1_VALIMP6

	TRB->COND     := (cArqSC5)->C5_CONDPAG
	
	TRB->PEDIDO   := (cArqSD2)->D2_PEDIDO
	TRB->DTPED    := (cArqSC5)->C5_EMISSAO
	TRB->TPFRETE  := (cArqSC5)->C5_TPFRETE
	
	TRB->PESO     := Posicione("SB1",1,xFilial("SB1")+QRY->D1_COD,"B1_PESBRU") * QRY->D1_QUANT

   TRB->TRANSP   := (cArqSF2)->F2_TRANSP
   TRB->DESCTRA  := Posicione("SA4",1,xFilial("SA4")+(cArqSF2)->F2_TRANSP,"A4_NOME")
      
	TRB->EMPRESA  := cEmp
	MsUnlock()
	
	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())

(cAliasTrb)->(DbCloseArea())
(cArqSC5)->(DbCloseArea())
(cArqSC9)->(DbCloseArea())
(cArqSD2)->(DbCloseArea())
(cArqSF2)->(DbCloseArea())
(cArqSA3)->(DbCloseArea())

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

Static Function MostraCons()
Local aSize     := MsAdvSize(.T.)
Local aObjects:={},aInfo:={},aPosObj:={}
Local aCampos := {}

Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aBrowse := {}

AaDD(aBrowse,{"EMPRESA","","Empresa"})
AaDD(aBrowse,{"DOC","","NF"})
AaDD(aBrowse,{"SERIE","","Serie"})
AaDD(aBrowse,{"DTEMI","","Emissao",""})
AaDD(aBrowse,{"DTDIGIT","","Dt.Digit.",""})
AaDD(aBrowse,{"PRODUTO"   ,"","Produto",""})
AaDD(aBrowse,{"DESC"   ,"","Descricao",""})
AaDD(aBrowse,{"UM","","Unid.Medida",""})
AaDD(aBrowse,{"TP","","Tp Produto",""})
AaDD(aBrowse,{"QUANT"   ,"","Qtde","@e 999999.99"})
AaDD(aBrowse,{"PRUNIT"   ,"","Prc. Venda","@e 999,999.99"})
AaDD(aBrowse,{"TOTAL"   ,"","Vlr. Total","@e 99,999,999.99"})
AaDD(aBrowse,{"IPI"   ,"","% IPI","@e 999.99"})
AaDD(aBrowse,{"VALIPI"   ,"","Vlr. IPI","@e 999,999.99"})
AaDD(aBrowse,{"PICM"   ,"","% ICMS","@e 999.99"})
AaDD(aBrowse,{"VALICM"   ,"","Vlr.Icm","@e 999,999.99"})
AaDD(aBrowse,{"ICMSRET"   ,"","Icms Subst","@e 999,999.99"})

AaDD(aBrowse,{"CLIENTE","","Cliente",""})
AaDD(aBrowse,{"LOJA","","Loja",""})
AaDD(aBrowse,{"NOME","","Razao Social",""})
AaDD(aBrowse,{"CGC"   ,"","Cnpj","@R 99.999.999/9999-99"})
AaDD(aBrowse,{"MUN","","Municipio",""})
AaDD(aBrowse,{"EST","","Estado",""})

AaDD(aBrowse,{"VEND","","Vendedor",""})
AaDD(aBrowse,{"NOMVEND","","Nome Vend.",""})

AaDD(aBrowse,{"CF","","CFOP",""})
AaDD(aBrowse,{"VALFRE"   ,"","Vlr. Frete","@e 99,999,999.99"})
AaDD(aBrowse,{"COFINS"   ,"","Vlr. Cofins","@e 99,999,999.99"})
AaDD(aBrowse,{"PIS"      ,"","Vlr. Pis" ,"@e 99,999,999.99"})
AaDD(aBrowse,{"OPER"     ,"","Operacao" ,""})

AaDD(aBrowse,{"Pedido" ,"","Ped. Venda" ,""})
AaDD(aBrowse,{"DTPED" ,"","Emis.Ped" ,""})
AaDD(aBrowse,{"COND" ,"","Cond.Pag" ,""})
AaDD(aBrowse,{"TPFRETE" ,"","Tipo de Frete" ,""})
AaDD(aBrowse,{"USERINC" ,"","Usuario Ped" ,""})

AaDD(aBrowse,{"NFORI" ,"","Nota Original" ,""})
AaDD(aBrowse,{"SERIORI" ,"","Ser.Orig.." ,""})
AaDD(aBrowse,{"ITEMORI" ,"","Item Orig.." ,""})
AaDD(aBrowse,{"DTNF" ,"","Dt Emissao Orig.." ,""})

AaDD(aBrowse,{"CATEG","","Categoria",""})
AaDD(aBrowse,{"MARCA","","MARCA",""})

AaDD(aBrowse,{"CUSTO"    ,"","Custo" ,"@e 99,999,999.99"})

AaDD(aBrowse,{"TRANSP","","Transportadora",""})

AaDD(aBrowse,{"DESCTRA","","Nome",""})


DbSelectArea("TRB")
DbGoTop()

cMarca   := GetMark()
nOpca    :=0
lInverte := .F.
oFonte  := TFont():New( "TIMES NEW ROMAN",14.5,22,,.T.,,,,,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a  tela com o tree da origem e com o tree do destino    ณ
//ณresultado da comparacao.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
//aAdd( aObjects, { 100, 100, .T., .T., .F. } )
//aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
//aPosObj:= MsObjSize( aInfo, aObjects, .T.,.T. )

AADD(aObjects,{100,025,.T.,.F.})
AADD(aObjects,{100,100,.T.,.T.})
AAdd( aObjects, { 0, 40, .T., .F. } )

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg1 TITLE "Consulta Dev de Vendas " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
//ณ arquivo de trabalho "TRB".                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

oMark:bMark := {| | fa060disp(cMarca,lInverte)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

@ aPosObj[1,1]+10,aPosObj[1,2]+30 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia


ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.T.) CENTERED

Return

/*/
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
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP OemtoAnsi("Calculadora...")
DEFINE BUTTON RESOURCE "SIMULACAO" OF oBar GROUP ACTION ExpCons() TOOLTIP OemToAnsi("Exporta para Planilha Excel...")    //


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

AaDd(aDadosExcel,{ "Empresa",;
"Doc.Entrada",;
"Serie",;
"Emissao",;
"Dt.Digit.",;
"Produto",;
"Descricao",;
"Unid.Medida",;       
"Almoxarifado",;
"Tp Produto",;
"Qtde",;
"Prc. Venda",;
"Vlr. Total",;
"% IPI",;
"Vlr. IPI",;
"% ICMS",;
"Vlr.Icm",;
"Icms Subst",;
"Cliente",;
"Loja",;
"Razao Social",;
"Cnpj",;
"Municipio",;
"Estado",;
"Canal",;
"Vendedor",;
"Nome Vend.",;
"CFOP",;
"Vlr. Frete",;
"Vlr. Cofins",;
"Vlr. Pis" ,;
"Operacao" ,;
"Ped. Venda" ,;
"Emis.Ped" ,;
"Cond.Pag" ,;
"Tipo de Frete" ,;
"Usuario Ped" ,;
"Nota Original" ,;
"Ser.Orig.." ,;
"Item Orig.." ,;
"Emissao NF Ori",;
"Categoria",;
"MARCA",;
"Custo" ,;
"Motivo",;
"Desc Motivo",;
"Obs Motivo",;
"Transportadora",;
"Desc Transp"})

nCol := Len(aDadosExcel[1])

DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())        // Total de Elementos da regua

While TRB->(!EOF())
	
	AaDD( aDadosExcel, { TRB->EMPRESA,TRB->DOC,;
	TRB->SERIE,;
	Dtoc(TRB->DTEMI),;
	Dtoc(TRB->DTDIGIT),;
	TRB->PRODUTO   ,;
	TRB->DESC   ,; 
	TRB->UM,;
	TRB->LOCDEV,;
	TRB->TP,;
	Transform(TRB->QUANT ,"@e 999999.99") ,;
	Transform(TRB->PRUNIT,"@e 999,999.99"),;
	Transform(TRB->TOTAL,"@e 99,999,999.99"),;
	Transform(TRB->IPI,"@e 999.99"),;
	Transform(TRB->VALIPI,"@e 999,999.99") ,;
	Transform(TRB->PICM,"@e 999.99"),;
	Transform(TRB->VALICM,"@e 999,999.99"),;
	Transform(TRB->ICMSRET,"@e 999,999.99"),;
	TRB->CLIENTE,;
	TRB->LOJA,;
	TRB->NOME,;
	Transform(TRB->CGC ,"@R 99.999.999/9999-99"),;
	TRB->MUN,;
	TRB->EST,;
	TRB->CANAL,;
	TRB->VEND,;
	TRB->NOMVEND,;
	TRB->CF,;
	Transform(TRB->VALFRE,"@e 99,999,999.99"),;
	Transform(TRB->COFINS,"@e 99,999,999.99") ,;
	Transform(TRB->PIS,"@e 99,999,999.99"),;
	TRB->OPER,;
	TRB->Pedido ,;
	Dtoc(TRB->DTPED) ,;
	TRB->COND ,;
	TRB->TPFRETE ,;
	TRB->USERINC ,;
	TRB->NFORI  ,;
	TRB->SERIORI ,;
	TRB->ITEMORI ,;
	Dtoc(TRB->DTNF),;
	TRB->CATEG,;
	TRB->MARCA,;
	Transform(TRB->CUSTO,"@e 99,999,999.99"),;
	TRB->MOTIVO,;
	TRB->DESMOT ,;
	TRB->OBSMOT,;
	TRB->TRANSP,;
	TRB->DESCTRA })
	
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
Local nX

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
ฑฑบPrograma  ณCriaArqTmpบAutor  ณCarlos R. Moreira   บ Data ณ  03/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria a estrutura do arquivo de trabalho                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaArqTmp()
Local aCampos := {}

AaDd(aCampos,{"OK"       ,"C",  2,0})
AaDd(aCampos,{"DOC"      ,"C",  9,0})
AaDd(aCampos,{"SERIE"    ,"C",  3,0})
AaDd(aCampos,{"PRODUTO"  ,"C", 15,0})
AaDd(aCampos,{"DESC"     ,"C", 30,0})
AaDd(aCampos,{"QUANT"    ,"N", 11,2})
AaDd(aCampos,{"UM"       ,"C",  2,0}) 
AaDd(aCampos,{"LOCDEV"    ,"C",  2,0})
AaDd(aCampos,{"DTEMI"    ,"D",  8,0})
AaDd(aCampos,{"DTDIGIT"   ,"D",  8,0})
AaDd(aCampos,{"PRUNIT"   ,"N", 17,2})
AaDd(aCampos,{"IPI"      ,"N",  6,2})
AaDd(aCampos,{"PICM"     ,"N",  6,2})
AaDd(aCampos,{"TOTAL"    ,"N", 17,2})
AaDd(aCampos,{"VLRLIQ"   ,"N", 17,2})

AaDd(aCampos,{"CLIENTE"   ,"C",  6,0})
AaDd(aCampos,{"LOJA"      ,"C",  3,0})
AaDd(aCampos,{"NOME"     ,"C", 30,0})
AaDd(aCampos,{"CGC"       ,"C", 14,0})
AaDd(aCampos,{"MUN"       ,"C", 30,0})
AaDd(aCampos,{"EST"      ,"C",  2,0})

AaDd(aCampos,{"VALIPI"   ,"N", 17,2})
AaDd(aCampos,{"VALICM"   ,"N", 17,2})
AaDd(aCampos,{"ICMSRET"  ,"N", 17,2})
AaDd(aCampos,{"CUSTO"     ,"N", 17,2})

AaDd(aCampos,{"NFORI"     ,"C",  9,0})
AaDd(aCampos,{"SERIORI"   ,"C",  3,0})
AaDd(aCampos,{"ITEMORI"   ,"C",  2,0})
AaDd(aCampos,{"DTNF"      ,"D",  8,0})

AaDd(aCampos,{"PEDIDO"    ,"C", 6 ,0})
AaDd(aCampos,{"DTPED"      ,"D",  8,0})

AaDd(aCampos,{"COMIS"     ,"N", 11,2})
AaDd(aCampos,{"VEND"      ,"C",  6,0})
AaDd(aCampos,{"NOMVEND"   ,"C", 30,0})

AaDd(aCampos,{"SUPER"      ,"C",  6,0})
AaDd(aCampos,{"NOMSUPER"   ,"C", 30,0})

AaDd(aCampos,{"CANAL"     ,"C",  2,0})

AaDd(aCampos,{"CF"        ,"C",  5,0})
AaDd(aCampos,{"VALFRE"    ,"N", 11,2})
AaDd(aCampos,{"PIS"       ,"N", 11,2})
AaDd(aCampos,{"COFINS"    ,"N", 11,2})

AaDd(aCampos,{"COND "     ,"C", 3 ,0})

AaDd(aCampos,{"TPFRETE"   ,"C", 1 ,0})
AaDd(aCampos,{"USERINC"   ,"C", 15,0})
AaDd(aCampos,{"EMPRESA"   ,"C", 2 ,0})
AaDd(aCampos,{"OPER"      ,"C", 2 ,0})

AaDd(aCampos,{"CATEG"      ,"C", 20,0})
AaDd(aCampos,{"MARCA"      ,"C", 20,0})

AaDd(aCampos,{"PESO"      ,"N", 11,2})

AaDd(aCampos,{"TP"        ,"C",  2,0}) 
AaDd(aCampos,{"MOTIVO"    ,"C",  2,0})
AaDd(aCampos,{"DESMOT"    ,"C", 20,0})
AaDd(aCampos,{"OBSMOT"    ,"C", 40,0})

AaDd(aCampos,{"SUBMOT"    ,"C",  2,0})
AaDd(aCampos,{"DSUBMOT"   ,"C", 20,0})

AaDd(aCampos,{"TRANSP"    ,"C",  6,0})
AaDd(aCampos,{"DESCTRA"   ,"C", 20,0})

cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
IndRegua("TRB",cArqTmp,"EMPRESA+DOC+SERIE",,,"Selecionando Registros..." )

Return
