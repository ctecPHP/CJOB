#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFATR01   บAutor  ณCarlos R. Moreira   บ Data ณ  26/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo para Exportar para Planilha de Excel        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFATR01()

Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local cCadastro := OemToAnsi("Gera o consulta de Itens Nota Saida")
Private  cArqTxt
Private cPerg := "PFATR01"

PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"03","Cliente De                 ?","","","mv_ch3","C",  6,0,0,"G","","","SA1","","mv_par03","","","","","","","","","","","","","","","","",{{"Cliente Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"04","Cliente Ate                ?","","","mv_ch4","C",  6,0,0,"G","","","SA1","","mv_par04","","","","","","","","","","","","","","","","",{{"Cliente Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"05","Loja  De                   ?","","","mv_ch5","C",  3,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Loja    Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"06","Loja  Ate                  ?","","","mv_1ch6","C", 3,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Loja    Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"07","Produto de                 ?","","","mv_ch9","C", 15,0,0,"G","","","SB1","","mv_par09","","","","","","","","","","","","","","","","",{{"Produto Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"08","Produto Ate                ?","","","mv_cha","C", 15,0,0,"G","","","SB1","","mv_par10","","","","","","","","","","","","","","","","",{{"Produto Final  "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"09","Vendedor de                ?","","","mv_chd","C",  6,0,0,"G","","","SA3","","mv_par13","","","","","","","","","","","","","","","","",{{"Vendedor Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"10","Vendedor Ate               ?","","","mv_che","C",  6,0,0,"G","","","SA3","","mv_par14","","","","","","","","","","","","","","","","",{{"Vendedor Final  "}},{{" "}},{{" "}},"")

aHelpPor :=	{"Define se a exportacao de dados sera consolidada entre empresas"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"11","Consolidas as Empresas  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
"mv_par11","Nao","","","","Sim","","",;
"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{"Define se a exportacao de dados ira demonstrar a eliminacao de Residuo"}
aHelpEsp :=	{}
aHelpEng :=	{}

PutSx1( cPerg, 	"12","Relatorio Completo  ?","Consolidas as Empresas ?","Consolidas as Empresas ?","mv_chf","N",1,0,1,"C","","","","",;
"mv_par12","Sim","","","","Faturamento","","",;
"","","Residuo","","","Bonificacao","","","",aHelpPor,aHelpEng,aHelpEsp)

PutSx1(cPerg,"13","Supervisor de              ?","","","mv_chd","C",  6,0,0,"G","","","SA3","","mv_par13","","","","","","","","","","","","","","","","",{{"Supervisor Inicial "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"14","Supervisor Ate             ?","","","mv_che","C",  6,0,0,"G","","","SA3","","mv_par14","","","","","","","","","","","","","","","","",{{"Supervisor Final  "}},{{" "}},{{" "}},"")

Pergunte(cPerg,.F.)

Aadd(aSays, OemToAnsi(" Este programa ira gerar um consulta com os itens   "))
Aadd(aSays, OemToAnsi(" da nota fiscal de acordo com parametros selecionados."))

Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
Aadd(aButtons, { 2, .T., { || FechaBatch() }})
Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})

FormBatch(cCadastro, aSays, aButtons)

If nOpca == 1
	
	If MV_PAR11 == 2
		
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
ฑฑบPrograma  ณProc_Arq  บAutor  ณCarlos R Moreira    บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o arquivo para gerar o arquivo de trabalho        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Proc_Arq(cEmp)
Local aNomArq := {}
Local aArq := {{"SD2"," "},{"SA1"," "},{"SF2"," "},{"SC5"," "},{"SA3"," "},{"SB1"," "},{"SBM"," "},{"SE4"," "}} //

If MV_PAR12 == 1 .Or. MV_PAR12 == 2 .Or. MV_PAR12 == 4
	
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
	
	cQuery := " SELECT    SF2.F2_VEND1, SF2.F2_DOC, SF2.F2_SERIE,SF2.F2_HORA,SF2.F2_EMISSAO,SF2.F2_CLIENTE, SF2.F2_LOJA,SF2.F2_VALMERC, "
	cQuery += "           ISNULL(SA3.A3_NOME,'') A3_NOME, ISNULL(SA3.A3_TIPO,'') A3_TIPO ,ISNULL(SA3.A3_COMIS,0) A3_COMIS, ISNULL(SA3.A3_SUPER,'') A3_SUPER, ISNULL(SA3SUP.A3_NOME,'') A3_NOMSUP, "
	cQuery += "           SA1.A1_NOME,SA1.A1_CGC,SA1.A1_MUN,SA1.A1_EST,SA1.A1_ZZCONTR, "
	cQuery += "           SE4.E4_DESCRI, "
	cQuery += "           SC5.C5_CONDPAG, SC5.C5_EMISSAO, SC5.C5_TPFRETE, "
	cQuery += "           SD2.D2_COD, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, "
	cQuery += "           SD2.D2_VALIPI, SD2.D2_VALICM, SD2.D2_PEDIDO, SD2.D2_IPI, SD2.D2_PICM, "
	cQuery += "           SD2.D2_ITEM, SD2.D2_TES, SD2.D2_TP, SD2.D2_EST, SD2.D2_TIPO, "
	cQuery += "           SD2.D2_ICMSRET, SD2.D2_COMIS1,  " 
	cQuery += "           SD2.D2_CF, SD2.D2_GRUPO, SD2.D2_ITEMPV, "
	cQuery += "           SB1.B1_PESBRU, SB1.B1_DESC "
	
	cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SD2" }),2]+" SD2 "
	
	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SF2" }),2]+" SF2 ON "
	cQuery += "             SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.F2_TIPO = 'N' "
	cQuery += "	            And SF2.F2_CLIENTE BETWEEN '"+MV_PAR03+"' And '"+mv_par04+"'"
	cQuery += "	            And SF2.F2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
    cQuery += "             And SF2.F2_SERIE IN ('1','P99', 'P01' ) AND SF2.F2_CLIENTE <> '002268' "
	cQuery += "             And SF2.D_E_L_E_T_ <> '*' "
	
	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5 ON "
	cQuery += "     SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ <> '*' AND SC5.C5_ZZTIPO = 'N'  "
	
	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
	cQuery += "     SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND "
	cQuery += "     SA1.D_E_L_E_T_ <> '*' "
	
	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA3" }),2]+" SA3 ON  "
	cQuery += "     SF2.F2_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ <> '*' "
	
	cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA3" }),2]+" SA3SUP ON  "
	cQuery += "     SA3.A3_SUPER = SA3SUP.A3_COD  AND SA3SUP.D_E_L_E_T_ <> '*' "

	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON  "
	cQuery += "     SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "
	
	cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SE4" }),2]+" SE4 ON  "
	cQuery += "     SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
	cQuery += "	And SD2.D2_DOC = SF2.F2_DOC And SD2.D2_SERIE = SF2.F2_SERIE "
	
	cQuery += "	And SD2.D2_COD  BETWEEN '"+MV_PAR07+"' And '"+mv_par08+"'"
	
	cQuery := ChangeQuery(cQuery)
	
	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
	TCSetField("QRY","C5_EMISSAO","D")
	TCSetField("QRY","F2_EMISSAO","D")
	
	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())
	
	DbSelectArea("QRY")
	DbGotop()
	
	ProcRegua(nTotReg)
	
	While QRY->(!Eof())
		
		IncProc("Processando o Arquivo de trabalho..Emp: "+cEmp)
		
        If QRY->A3_SUPER < MV_PAR13 .Or. QRY->A3_SUPER > MV_PAR14
           DbSkip()
           Loop
        EndIf 
            
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->DOC      := QRY->F2_DOC
		TRB->SERIE    := QRY->F2_SERIE
		TRB->DTEMI    := QRY->F2_EMISSAO
		TRB->ITEM     := QRY->D2_ITEM 
		TRB->PRODUTO  := QRY->D2_COD
		TRB->DESC     := QRY->B1_DESC
		TRB->QUANT    := QRY->D2_QUANT
		TRB->PRCVEN   := QRY->D2_PRCVEN
		TRB->VALMERC  := QRY->D2_TOTAL 
		TRB->VALIPI   := QRY->D2_VALIPI
		TRB->VALICM   := QRY->D2_VALICM
		TRB->TOTAL    := QRY->D2_TOTAL - ( QRY->D2_TOTAL * ((QRY->A1_ZZCONTR / 100 )) - {QRY->D2_ICMSRET} ) //+ QRY->D2_VALIPI
		TRB->IPI      := QRY->D2_IPI
		TRB->PICM     := QRY->D2_PICM
		TRB->COMIS    := QRY->D2_COMIS1
		TRB->CGC      := QRY->A1_CGC
		TRB->NOME     := QRY->A1_NOME
		TRB->MUN      := QRY->A1_MUN
		TRB->EST      := QRY->D2_EST
		TRB->VEND     := QRY->F2_VEND1
		TRB->NOMVEND  := QRY->A3_NOME
		TRB->CLIENTE  := QRY->F2_CLIENTE
		TRB->LOJA     := QRY->F2_LOJA
		
		TRB->CF       := QRY->D2_CF
		
		TRB->COND     := QRY->C5_CONDPAG
		TRB->DESCOND  := QRY->E4_DESCRI 
		
		TRB->PEDIDO   := QRY->D2_PEDIDO
		TRB->ITEMPV   := QRY->D2_ITEMPV
		
		TRB->DTEMIPV  := QRY->C5_EMISSAO
		TRB->TPFRETE  := QRY->C5_TPFRETE
		
		TRB->EMPRESA  := cEmp
		
		TRB->PESO     := QRY->B1_PESBRU * QRY->D2_QUANT
		
		TRB->SUPER    := QRY->A3_SUPER 
//		TRB->NOMSUPER := QRY->A3_NOME

		MsUnlock()
		
		DbSelectArea("QRY")
		DbSkip()
		
	End
	
	QRY->(DbCloseArea())
	
	(cAliasTrb)->(DbCloseArea())
	
EndIf

//Ira Verificar se o usuario quer um relatorio completo inclusive com os residuos de pedido
If MV_PAR12 == 1 .Or. MV_PAR12 == 3
	
//	LjMsgRun("Processando o arquivo de Residuo Eliminado..","Aguarde.",{||ProcResPed(cEmp)} )
	
EndIf

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
AaDD(aBrowse,{"PRODUTO"   ,"","Produto",""})
AaDD(aBrowse,{"DESC"   ,"","Descricao",""})
AaDD(aBrowse,{"QUANT"   ,"","Qtde","@e 999999999.99"})
AaDD(aBrowse,{"PESO"    ,"","Peso" ,"@e 99,999,999.99"})
AaDD(aBrowse,{"PRCVEN"   ,"","Prc. Venda","@e 999,999.99"})
AaDD(aBrowse,{"VALMERC"   ,"","Vlr. Mercadoria","@e 999,999.99"})
AaDD(aBrowse,{"VALIPI"   ,"","Vlr. IPI","@e 999,999.99"})
AaDD(aBrowse,{"VALICM"   ,"","Vlr.Icm","@e 999,999.99"})
AaDD(aBrowse,{"TOTAL"   ,"","Vlr. Total","@e 99,999,999.99"})
AaDD(aBrowse,{"IPI"   ,"","% IPI","@e 999.99"})
AaDD(aBrowse,{"PICM"   ,"","% ICMS","@e 999.99"})
AaDD(aBrowse,{"COMIS"   ,"","% Comissao","@e 999.99"})
AaDD(aBrowse,{"CGC"   ,"","Cnpj","@R 99.999.999/9999-99"})

AaDD(aBrowse,{"MUN","","Municipio",""})
AaDD(aBrowse,{"EST","","Estado",""})
AaDD(aBrowse,{"VEND","","Vendedor",""})
AaDD(aBrowse,{"NOMVEND","","Nome Vendedor",""})
AaDD(aBrowse,{"SUPER","","Supervisor",""})
AaDD(aBrowse,{"NOMSUPER","","Nome Supervisor",""})

AaDD(aBrowse,{"CLIENTE","","Cliente",""})
AaDD(aBrowse,{"LOJA","","Loja",""})
AaDD(aBrowse,{"NOME","","Razao Social",""})
AaDD(aBrowse,{"CF","","CFOP",""})
//AaDD(aBrowse,{"OPER"     ,"","Operacao" ,""})
AaDD(aBrowse,{"Pedido" ,"","Ped. Venda" ,""})
AaDD(aBrowse,{"DTEMIPV" ,"","Emis.Ped" ,""})
AaDD(aBrowse,{"COND" ,"","Cond.Pag" ,""})
AaDD(aBrowse,{"DESCOND" ,"","Descr Cond.Pag" ,""})
AaDD(aBrowse,{"TPFRETE" ,"","Tipo de Frete" ,""})
//AaDD(aBrowse,{"USERINC" ,"","Usuario Ped" ,""})

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

DEFINE MSDIALOG oDlg1 TITLE "Consulta NF - Periodo" From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Passagem do parametro aCampos para emular tambm a markbrowse para o ณ
//ณ arquivo de trabalho "TRB".                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})  //35,3,213,385

oMark:bMark := {| | fa060disp(cMarca,lInverte)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

//@ aPosObj[1,1]+10,aPosObj[1,2]+30 Button "&Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel //Localiza o Dia
@ aPosObj[3,1]+10,aPosObj[3,2]+455 Button "&Sair"    Size 60,15 Action {||oDlg1:End()} of oDlg1 Pixel

@ aPosObj[3,1]+10,aPosObj[3,2]+520 Button "&Exp Excel"    Size 60,15 Action ExpCons() of oDlg1 Pixel

@ aPosObj[3,1]+10,aPosObj[3,2]+585 Button "&Imprimir"    Size 60,15 Action ImpCons() of oDlg1 Pixel

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

AaDd(aDadosExcel,{ "Empresa","NF",;
"Serie",;
"Tp Produto",;
"Emissao",;
"Produto",;
"Descricao",;
"Qtde",;
"Peso",;
"Prc. Venda",;
"Vlr. Mercadoria",;
"Vlr. IPI",;
"Vlr.Icm",;
"Vlr. Total",;
"% IPI",;
"% ICMS",;
"% Comissao",;
"Cnpj",;
"Razao Social",;
"Municipio",;
"Estado",;
"Vendedor",;
"Nome Vendedor",;
"Supervisor" ,;
"Nome Super",;
"Cliente",;
"Loja",;
"Filial",;
"CFOP",;
"Vlr. Frete",;
"Vlr. Cofins",;
"Vlr. Pis",;
"Dt.Vencto" ,;
"Ped. Venda",;
"Emissao Ped. Venda",;
"Cond.Pag" ,;
"Desc Cond Pag" ,;
"Tipo de Frete" })

nCol := Len(aDadosExcel[1])

DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())        // Total de Elementos da regua

While TRB->(!EOF())
	
	SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA ))
	
	AaDD( aDadosExcel, { TRB->EMPRESA,TRB->DOC,;
	TRB->SERIE,;
	TRB->TP,;
	Dtoc(TRB->DTEMI) ,;
	TRB->PRODUTO,;
	TRB->DESC,;
	Transform(TRB->QUANT,"@e 999999999.99"),;
	Transform(TRB->PESO,"@e 999,999.99"),;
	Transform(TRB->PRCVEN,"@e 999,999.99"),;
	Transform(TRB->VALMERC,"@e 999,999.99"),;
	Transform(TRB->VALIPI,"@e 999,999.99"),;
	Transform(TRB->VALICM,"@e 999,999.99"),;
	Transform(TRB->TOTAL,"@e 99,999,999.99"),;
	Transform(TRB->IPI,"@e 999.99"),;
	Transform(TRB->PICM,"@e 999.99"),;
	Transform(TRB->COMIS,"@e 999.99"),;
	Transform(TRB->CGC,"@R 99.999.999/9999-99"),;
	TRB->NOME,;
	TRB->MUN,;
	TRB->EST,;
	TRB->VEND,;
	TRB->NOMVEND ,;
	TRB->SUPER,;
	TRB->NOMSUPER,;
	TRB->CLIENTE,;
	TRB->LOJA,;
	TRB->FILIAL,;
	TRB->CF,;
	Transform(TRB->VALFRE,"@e 99,999,999.99"),;
	Transform(TRB->COFINS,"@e 99,999,999.99"),;
	Transform(TRB->PIS ,"@e 99,999,999.99"),;
	Dtoc(TRB->DTVENCTO),;
	TRB->Pedido,;
	Dtoc(TRB->DTEMIPV),;
	TRB->COND ,;
	TRB->DESCOND,;
	TRB->TPFRETE })
	
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


Static Function CriaArqTmp()
Local aCampos := {}

AaDd(aCampos,{"OK"       ,"C",  2,0})
AaDd(aCampos,{"DOC"      ,"C",  9,0})
AaDd(aCampos,{"SERIE"    ,"C",  3,0})
AaDd(aCampos,{"TP"       ,"C",  2,0})
AaDd(aCampos,{"ITEM"     ,"C",  2,0})
AaDd(aCampos,{"DTEMI"    ,"D",  8,0})
AaDd(aCampos,{"PRODUTO"  ,"C", 15,0})
AaDd(aCampos,{"DESC"     ,"C", 30,0})
AaDd(aCampos,{"QUANT"    ,"N", 11,2})
AaDd(aCampos,{"PRCVEN"   ,"N", 17,2})
AaDd(aCampos,{"VALMERC"  ,"N", 17,2})
AaDd(aCampos,{"VALIPI"   ,"N", 11,2})
AaDd(aCampos,{"VALICM"   ,"N", 11,2})
AaDd(aCampos,{"ICMSRET"  ,"N", 11,2})
AaDd(aCampos,{"TOTAL"    ,"N", 17,2})
AaDd(aCampos,{"VALDEV"   ,"N", 17,2})
AaDd(aCampos,{"IPI"      ,"N",  6,2})
AaDd(aCampos,{"PICM"     ,"N",  6,2})
AaDd(aCampos,{"COMIS"     ,"N", 11,2})
AaDd(aCampos,{"CGC"       ,"C", 14,0})
AaDd(aCampos,{"NOME"      ,"C", 30,0})
AaDd(aCampos,{"MUN"       ,"C", 30,0})
AaDd(aCampos,{"EST"       ,"C",  2,0})
AaDd(aCampos,{"VEND"      ,"C",  6,0})
AaDd(aCampos,{"NOMVEND"   ,"C", 20 ,0})
AaDd(aCampos,{"CANAL"     ,"C",  2,0})
AaDd(aCampos,{"CLIENTE"   ,"C",  6,0})
AaDd(aCampos,{"LOJA"      ,"C",  3,0})
AaDd(aCampos,{"FILIAL"    ,"C",  2,0})
AaDd(aCampos,{"CF"        ,"C",  5,0})
AaDd(aCampos,{"VALFRE"    ,"N", 18,2})
AaDd(aCampos,{"VLRCON"    ,"N", 11,2})
AaDd(aCampos,{"PIS"       ,"N", 11,2})
AaDd(aCampos,{"COFINS"    ,"N", 11,2})
AaDd(aCampos,{"OPER"      ,"C", 2 ,0})
AaDd(aCampos,{"DTVENCTO"  ,"D", 8 ,0})
AaDd(aCampos,{"PEDIDO"    ,"C", 6 ,0})
AaDd(aCampos,{"ITEMPV"   ,"C",  2,0})
AaDd(aCampos,{"COND "     ,"C", 3 ,0})
AaDd(aCampos,{"DESCOND "  ,"C",20 ,0})
AaDd(aCampos,{"DTEMIPV"   ,"D", 8 ,0})
AaDd(aCampos,{"TPFRETE"   ,"C", 1 ,0})
AaDd(aCampos,{"USERINC"   ,"C", 15,0})
AaDd(aCampos,{"EMPRESA"   ,"C", 2 ,0})
AaDd(aCampos,{"CUSTO"     ,"N", 17,2})
AaDd(aCampos,{"SUPER"     ,"C",  6,0})
AaDd(aCampos,{"NOMSUPER"  ,"C", 20 ,0})

AaDd(aCampos,{"CUSDEV"     ,"N", 17,2})
AaDd(aCampos,{"PESO"     ,"N", 17,2})

cArqTmp := CriaTrab(aCampos,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de Trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbUseArea(.T.,,cArqTmp,"TRB",.F.,.F.)
IndRegua("TRB",cArqTmp,"EMPRESA+CLIENTE+LOJA+PRODUTO+DOC+SERIE",,,"Selecionando Registros..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCons   บAutor  ณCarlos R Moreira    บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณimprime o relatorio referente a consulta                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCons()
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

nVlrTot := 0

nTpRel := Escolha()

If nTpRel == 1
	
	DbSelectArea("TRB")
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Faturamento "
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,1)
			
			lFirst = .F.
			
		EndIf
		
		nVlrCli := 0
		lPri := .T.
		cCliente := TRB->CLIENTE
		
		While TRB->(!Eof()) .And. cCliente == TRB->CLIENTE
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 350,nLin+60, 350)
			oPrn:line(nLin, 900,nLin+60, 900)
			oPrn:line(nLin,1100,nLin+60,1100)
			oPrn:line(nLin,1800,nLin+60,1800)
			//oPrn:line(nLin,1950,nLin+60,1950)
			oPrn:line(nLin,2000,nLin+60,2000)
			oPrn:line(nLin,2100,nLin+60,2100)
			oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,TRB->CLIENTE  ,oFont9 ,100)
				oPrn:Say(nLin+10,  260,TRB->LOJA     ,oFont9 ,100)
				oPrn:Say(nLin+10,  360,TRB->NOME     ,oFont9 ,100)
				lPri := .F.
			EndIf
			oPrn:Say(nLin+10,  930,TRB->Produto    ,oFont9 ,100)
			oPrn:Say(nLin+10, 1120,TRB->DESC       ,oFont9 ,100)
			oPrn:Say(nLin+10, 1820,TRB->DOC        ,oFont9 ,100)
			oPrn:Say(nLin+10, 2030,TRB->SERIE      ,oFont9 ,100)
			oPrn:Say(nLin+10, 2120,Dtoc(TRB->DTEMI)   ,oFont9 ,100)
			oPrn:Say(nLin+10, 2380,Transform(TRB->PESO,"@e 999,999,999" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2580,Transform(TRB->QUANT,"@e 999,999,999" )  ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Transform(TRB->PRCVEN,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->TOTAL,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
				cTitulo := "Relatorio de Faturamento "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,1)
				
			EndIf
			
			nVlrTot += TRB->TOTAL
			nVlrCli += TRB->TOTAL
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		If nVlrCli > 0
			
			nLin += 20
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin,3050,nLin+60,3050)
			oPrn:Say(nLin+10, 120,"Total do Cliente " ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(nVlrCli ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 80
			
		EndIf
	End
	
	If nVlrTot > 0
		
		nLin += 20
		
		oPrn:Box(nLin,100,nLin+60,3300)
		
		oPrn:line(nLin,3050,nLin+60,3050)
		oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
		oPrn:Say(nLin+10, 3080,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
	EndIf
	
Else //Relatorio por data
	
	DbSelectArea("TRB")
	
	cIndex := CriaTrab(NIL,.F.)
	IndRegua("TRB",cIndex,"EMPRESA+Dtos(DTEMI)+CLIENTE+LOJA+PRODUTO+DOC+SERIE",,,"Selecionando Registros..." )
	
	DbGotop()
	
	ProcRegua(RecCount())        // Total de Elementos da regua
	
	While TRB->(!EOF())
		
		
		If lFirst
			oPrn:StartPage()
			cTitulo := "Relatorio de Faturamento "
			cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
			cNomEmp := SM0->M0_NOMECOM
			aTit    := {cTitulo,cNomEmp,cRod}
			nPag++
			U_CabRel(aTit,1,oPrn,nPag,"")
			
			CabCons(oPrn,2)
			
			lFirst = .F.
			
		EndIf
		
		nVlrCli := 0
		lPri := .T.
		
		dData  := TRB->DTEMI
		
		While TRB->(!Eof()) .And. dData == TRB->DTEMI
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin, 250,nLin+60, 250)
			oPrn:line(nLin, 400,nLin+60, 400)
			oPrn:line(nLin, 500,nLin+60, 500)
			oPrn:line(nLin,1050,nLin+60,1050)
			oPrn:line(nLin,1250,nLin+60,1250)
			oPrn:line(nLin,1950,nLin+60,1950)
			//oPrn:line(nLin,1950,nLin+60,1950)
			oPrn:line(nLin,2150,nLin+60,2150)
			oPrn:line(nLin,2250,nLin+60,2250)
			//oPrn:line(nLin,2300,nLin+60,2300)
			oPrn:line(nLin,2550,nLin+60,2550)
			oPrn:line(nLin,2800,nLin+60,2800)
			oPrn:line(nLin,3050,nLin+60,3050)
			
			If lPri
				oPrn:Say(nLin+10,  110,Dtoc(TRB->DTEMI)   ,oFont9 ,100)
				lPri := .F.
			EndIf
			
			oPrn:Say(nLin+10,  260,TRB->CLIENTE  ,oFont9 ,100)
			oPrn:Say(nLin+10,  410,TRB->LOJA     ,oFont9 ,100)
			oPrn:Say(nLin+10,  510,TRB->NOME     ,oFont9 ,100)
			oPrn:Say(nLin+10, 1080,TRB->Produto    ,oFont9 ,100)
			oPrn:Say(nLin+10, 1270,TRB->DESC       ,oFont9 ,100)
			oPrn:Say(nLin+10, 1970,TRB->DOC        ,oFont9 ,100)
			oPrn:Say(nLin+10, 2180,TRB->SERIE      ,oFont9 ,100)
			
			oPrn:Say(nLin+10, 2380,Transform(TRB->PESO,"@e 999,999,999" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 2580,Transform(TRB->QUANT,"@e 999,999,999" )  ,oFont9 ,100)
			oPrn:Say(nLin+10, 2880,Transform(TRB->PRCVEN,"@e 999,999,999.99" ) ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(TRB->TOTAL,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 60
			
			If nLin > 2200
				oPrn:EndPage()
				
				oPrn:StartPage()
				cTitulo := "Relatorio de Faturamento "
				cRod    := "Do periodo de "+Dtoc(MV_PAR01)+" a "+Dtoc(MV_PAR02)
				cNomEmp := SM0->M0_NOMECOM
				aTit    := {cTitulo,cNomEmp,cRod}
				nPag++
				U_CabRel(aTit,1,oPrn,nPag,"")
				
				CabCons(oPrn,2)
				
			EndIf
			
			nVlrTot += TRB->TOTAL
			nVlrCli += TRB->TOTAL
			
			DbSelectArea("TRB")
			DbSkip()
			
		End
		
		If nVlrCli > 0
			
			nLin += 20
			
			oPrn:Box(nLin,100,nLin+60,3300)
			
			oPrn:line(nLin,3050,nLin+60,3050)
			oPrn:Say(nLin+10, 120,"Total do Dia " ,oFont9 ,100)
			oPrn:Say(nLin+10, 3080,Transform(nVlrCli ,"@e 999,999,999.99" ) ,oFont9 ,100)
			
			nLin += 80
			
		EndIf
	End
	
	If nVlrTot > 0
		
		nLin += 20
		
		oPrn:Box(nLin,100,nLin+60,3300)
		
		oPrn:line(nLin,3050,nLin+60,3050)
		oPrn:Say(nLin+10, 120,"Total Geral " ,oFont9 ,100)
		oPrn:Say(nLin+10, 3080,Transform(nVlrTot ,"@e 999,999,999.99" ) ,oFont9 ,100)
		
	EndIf
	
	//Volto ao indice de origem
	cIndex := CriaTrab(NIL,.F.)
	IndRegua("TRB",cIndex,"EMPRESA+CLIENTE+LOJA+PRODUTO+DOC+SERIE",,,"Selecionando Registros..." )
	
EndIf

If !lFirst
	oPrn:EndPage()
EndIf

oPrn:Preview()
oPrn:End()

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

If nModo == 1
	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 350,nLin+60, 350)
	oPrn:line(nLin, 900,nLin+60, 900)
	oPrn:line(nLin,1100,nLin+60,1100)
	oPrn:line(nLin,1800,nLin+60,1800)
	//oPrn:line(nLin,1950,nLin+60,1950)
	oPrn:line(nLin,2000,nLin+60,2000)
	oPrn:line(nLin,2100,nLin+60,2100)
	oPrn:line(nLin,2300,nLin+60,2300)
	oPrn:line(nLin,2550,nLin+60,2550)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3050,nLin+60,3050)
	
	oPrn:Say(nLin+10,  110,"Cliente"       ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Loja"          ,oFont5 ,100)
	oPrn:Say(nLin+10,  360,"Nome Cliente"  ,oFont5 ,100)
	oPrn:Say(nLin+10,  930,"Produto"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 1120,"Descricao"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1820,"Documento"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 2030,"Serie"         ,oFont5 ,100)
	oPrn:Say(nLin+10, 2160,"Emissao"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 2380,"Peso "         ,oFont5 ,100)
	oPrn:Say(nLin+10, 2580,"Quantidade"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Vlr Unit"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Vlr Total"     ,oFont5 ,100)
	
Else
	
	oPrn:line(nLin, 250,nLin+60, 250)
	oPrn:line(nLin, 400,nLin+60, 400)
	oPrn:line(nLin, 500,nLin+60, 500)
	oPrn:line(nLin,1050,nLin+60,1050)
	oPrn:line(nLin,1250,nLin+60,1250)
	oPrn:line(nLin,1950,nLin+60,1950)
	//oPrn:line(nLin,1950,nLin+60,1950)
	oPrn:line(nLin,2150,nLin+60,2150)
	oPrn:line(nLin,2250,nLin+60,2250)
	//oPrn:line(nLin,2300,nLin+60,2300)
	oPrn:line(nLin,2550,nLin+60,2550)
	oPrn:line(nLin,2800,nLin+60,2800)
	oPrn:line(nLin,3050,nLin+60,3050)
	
	oPrn:Say(nLin+10,  110,"Emissao"       ,oFont5 ,100)
	oPrn:Say(nLin+10,  260,"Cliente"       ,oFont5 ,100)
	oPrn:Say(nLin+10,  410,"Loja"          ,oFont5 ,100)
	oPrn:Say(nLin+10,  510,"Nome Cliente"  ,oFont5 ,100)
	oPrn:Say(nLin+10, 1080,"Produto"       ,oFont5 ,100)
	oPrn:Say(nLin+10, 1270,"Descricao"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 1970,"Documento"     ,oFont5 ,100)
	oPrn:Say(nLin+10, 2180,"Serie"         ,oFont5 ,100)
	
	
	oPrn:Say(nLin+10, 2380,"Peso "         ,oFont5 ,100)
	oPrn:Say(nLin+10, 2580,"Quantidade"    ,oFont5 ,100)
	oPrn:Say(nLin+10, 2880,"Vlr Unit"      ,oFont5 ,100)
	oPrn:Say(nLin+10, 3080,"Vlr Total"     ,oFont5 ,100)
	
EndIf

nLin += 60

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcResPedบAutor  ณCarlos R Moreira    บ Data ณ  05/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ira processar o arquivo de pedido e demonstrar o Residuo   บฑฑ
ฑฑบ          ณ dos produtos                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcResPed(cEmp)
Local aNomArq := {}
Local aArq := {{"SC6"," "},{"SA1"," "},{"SC5"," "},{"SA3"," "},{"SB1"," "}} //

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

cQuery := " SELECT    SC5.C5_VEND1, SC5.C5_NUM,SC5.C5_CLIENTE, SC5.C5_LOJACLI,SC5.C5_PERCRES, "
cQuery += "           ISNULL(SA3.A3_NOME,'') A3_NOME, ISNULL(SA3.A3_TIPO,'') A3_TIPO ,ISNULL(SA3.A3_COMIS,0) A3_COMIS,  "
cQuery += "           SA1.A1_NOME,SA1.A1_CGC,SA1.A1_MUN,SA1.A1_EST, "
cQuery += "           SC5.C5_OPER, SC5.C5_CONDPAG, SC5.C5_EMISSAO, SC5.C5_TPFRETE, SC5.C5_INCNAME, "
cQuery += "           SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_DATFAT,SC6.C6_QTDENT,  "
cQuery += "           SC6.C6_ITEM, SC6.C6_TES,  "
cQuery += "           SC6.C6_CF, SC6.C6_DTELRES, "
cQuery += "           SB1.B1_PESBRU, SB1.B1_DESC "

cQuery += " FROM "+ aArq[Ascan(aArq,{|x|x[1] = "SC6" }),2]+" SC6 "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SC5" }),2]+" SC5 ON "
cQuery += "             SC6.C6_NUM = SC5.C5_NUM  AND SC5.C5_OPER = '01' AND SC5.C5_PERCRES = 100 "
cQuery += "	            And SC5.C5_CLIENTE BETWEEN '"+MV_PAR03+"' And '"+mv_par04+"'"

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA1" }),2]+" SA1 ON "
cQuery += "     SC6.C6_CLI = SA1.A1_COD AND SC6.C6_LOJA = SA1.A1_LOJA AND "
cQuery += "     SA1.D_E_L_E_T_ <> '*' "

cQuery += " LEFT OUTER JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SA3" }),2]+" SA3 ON  "
cQuery += "     SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ <> '*' "

cQuery += " JOIN "+ aArq[Ascan(aArq,{|x|x[1] = "SB1" }),2]+" SB1 ON  "
cQuery += "     SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SC6.D_E_L_E_T_ <> '*' "

cQuery += "	And SC6.C6_PRODUTO  BETWEEN '"+MV_PAR07+"' And '"+mv_par08+"'"
cQuery += "	            And SC6.C6_DTELRES BETWEEN '"+Dtos(MV_PAR01)+"' And '"+Dtos(mv_par02)+"'"
cQuery += "             And SC6.C6_QTDENT > 0 " // Somente o que foi faturado  
cQuery := ChangeQuery(cQuery)

MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Gerando o arquivo empresa : "+cEmp )
TCSetField("QRY","C6_DATFAT","D")
TCSetField("QRY","C5_EMISSAO","D")

nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho..: Residuos Totais")
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->DOC      := QRY->C5_NUM
	TRB->DTEMI    := QRY->C6_DTELRES
	TRB->PRODUTO  := QRY->C6_PRODUTO
	TRB->DESC     := QRY->B1_DESC
	TRB->QUANT    := If(QRY->C5_PERCRES == 100,QRY->C6_QTDENT,0)
	TRB->PRCVEN   := QRY->C6_PRCVEN * (QRY->C5_PERCRES / 100 ) 
	TRB->VALMERC  := ( QRY->C6_PRCVEN * (QRY->C5_PERCRES / 100 ) ) * QRY->C6_QTDENT
	TRB->TOTAL    := ( QRY->C6_PRCVEN * ( QRY->C5_PERCRES / 100 )) * QRY->C6_QTDENT
	TRB->COMIS    := QRY->A3_COMIS
	TRB->CGC      := QRY->A1_CGC
	TRB->NOME     := QRY->A1_NOME
	TRB->MUN      := QRY->A1_MUN
	TRB->EST      := QRY->A1_EST
	TRB->VEND     := QRY->C5_VEND1
	TRB->NOMVEND  := QRY->A3_NOME
	TRB->CLIENTE  := QRY->C5_CLIENTE
	TRB->LOJA     := QRY->C5_LOJACLI
	
	TRB->CF       := QRY->C6_CF
	
	TRB->OPER     := QRY->C5_OPER
	TRB->COND     := QRY->C5_CONDPAG
	
	TRB->TPFRETE  := QRY->C5_TPFRETE
	TRB->USERINC  := QRY->C5_INCNAME
	
	TRB->EMPRESA  := cEmp
	
	TRB->PESO     := QRY->B1_PESBRU * QRY->C6_QTDVEN 
	TRB->DTEMIPV  := QRY->C5_EMISSAO
	
	MsUnlock()
	
	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())

(cAliasTrb)->(DbCloseArea())

 Processa( {||ProcVenRes()},"Processando os Residuos ." )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEscolha   บAutor  ณCarlos R. Moreira   บ Data ณ  09/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona a Opcao desejada                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gtex                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Escolha()
Local oDlg2
Private nRadio := 1
Private oRadio

@ 0,0 TO 200,250 DIALOG oDlg2 TITLE "Modelo de Relatorio"

@ 05,05 TO 67,120 TITLE "Selecione o Tipo"
@ 23,30 RADIO oRadio Var nRadio Items "Cliente","Emissao" 3D SIZE 60,10 of oDlg2 Pixel

@ 080,075 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTER

Return nRadio

/*/

Processa o Residuo

/*/

Static Function ProcVenRes()
	Local cVend   := Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")
	Local aArq := {{"SA3"," "},{"SF2"," "},{"SC6"," "},{"SC5"," "},{"SE1"," "} }
	Local cTipoVend := Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_TPVEND")

//Fara o filtro quando se tratar de vendedor


/*
	If cTipoVend $ "SG"
	
		If cTipoVend == "S"
			cQuery := "SELECT A3.A3_COD, A3.A3_SUPER "
			cQuery += " FROM "+RetsqlName("SA3")+" A3 "
			cQuery += " WHERE  A3.D_E_L_E_T_<>'*' AND A3.A3_SUPER IN ( SELECT A3_COD FROM "+RETSQLNAME("SA3")+" WHERE A3_CODUSR = '"+__cUserId+"' and D_E_L_E_T_<>'*' ) "
		Else
			cQuery := "SELECT A3.A3_COD, A3.A3_GEREN "
			cQuery += " FROM "+RetsqlName("SA3")+" A3 "
			cQuery += " WHERE  A3.D_E_L_E_T_<>'*' AND A3.A3_GEREN IN ( SELECT A3_COD FROM "+RETSQLNAME("SA3")+" WHERE A3_CODUSR = '"+__cUserId+"' and D_E_L_E_T_<>'*' ) "
		EndIf
	
		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SELSUPER",.T.,.T.)},"Aguarde selecionando os vendedores..")
	//TCQUERY cQuery NEW ALIAS "SELSUPER"
	
		If SELSUPER->(!eof())
		
			cFilter := ""
			a:= 1
			While SELSUPER->(!eof())
			
				If a == 1
					cFilter += "'"+ALLTRIM(SELSUPER->A3_COD)+"'"
				else
					cFilter += ",'"+ALLTRIM(SELSUPER->A3_COD)+"'"
				endif
				a++
				SELSUPER->(Dbskip())
			
			End
		
			SELSUPER->(DbCloseArea())
		
		EndIf
	
	ElseIf !Empty(cVend)

		cQuery := "SELECT SA3.A3_COD "
		cQuery += " FROM "+RetsqlName("SA3")+" SA3 "
		cQuery += " WHERE  SA3.D_E_L_E_T_<>'*' AND SA3.A3_CODUSR = '"+__cUserId+"'"
	
		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPVEND",.T.,.T.)},"Aguarde selecionando os vendedores..")
	
		If TMPVEND->(!eof())
		
			cFilter := ""
			a:= 1
			While TMPVEND->(!eof())
			
				If a == 1
					cFilter += "'"+ALLTRIM(TMPVEND->A3_COD)+"'"
				else
					cFilter += ",'"+ALLTRIM(TMPVEND->A3_COD)+"'"
				endif
				a++
				TMPVEND->(Dbskip())
			
			End
		
			TMPVEND->(DbCloseArea())
		
		EndIf

	EndIf

*/
	cQuery := "SELECT  SD2.D2_COD, SD2.D2_UM, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_PEDIDO, "
	cQuery += "        SB1.B1_DESC, SA3.A3_NOME,SA3.A3_COD, SA3.A3_COMIS,SC5.C5_CLIENTE, SC5.C5_LOJACLI,SC5.C5_VEND1, "
	cQuery += "        SC5.C5_OPER,SC5.C5_UFCLI, SC5.C5_PERCRES,SD2.D2_ITEMPV,SD2.D2_EMISSAO,SC6.C6_VALOR, "
	cQuery += "        SD2.D2_CF,  SC5.C5_TPFRETE, SC5.C5_CNPJ,SC5.C5_INCNAME, SC5.C5_CONDPAG,SC5.C5_NOMCLI, "
	cQuery += "        SC5.C5_MUN, SB1.B1_PESBRU  " 	
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " JOIN "+RetSqlName("SC5")+" SC5 ON SD2.D2_PEDIDO = SC5.C5_NUM  AND SC5.D_E_L_E_T_ <> '*' "
	cQuery += "        AND SC5.C5_OPER = '01' AND ( SC5.C5_PERCRES > 0 AND SC5.C5_PERCRES < 100 ) "

/*	If !Empty(cVend)

		cQuery +=       " And SC5.C5_VEND1 IN ( " +cFilter + ")  "
	
	EndIf */ 
	
	cQuery += " JOIN "+RetSqlName("SC6")+" SC6 ON SD2.D2_PEDIDO = SC6.C6_NUM  AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += "        AND SC6.C6_ITEM = SD2.D2_ITEMPV "
	
	cQuery += " JOIN "+RetSqlName("SB1")+" SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*' "

	cQuery += " JOIN "+RetSqlName("SA3")+" SA3 ON SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND SD2.D_E_L_E_T_ <> '*' AND "
	cQuery += "       SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
	cQuery += "       SD2.D2_QTDEDEV = 0 "


	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
	TCSetField("QRY","D2_EMISSAO","D")
  
nTotReg := 0
QRY->(dbEval({||nTotREG++}))
QRY->(dbGoTop())

DbSelectArea("QRY")
DbGotop()

ProcRegua(nTotReg)

While QRY->(!Eof())
	
	IncProc("Processando o Arquivo de trabalho.: Residuos parciais")
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->DOC      := QRY->D2_PEDIDO 
	TRB->DTEMI    := QRY->D2_EMISSAO 
	TRB->PRODUTO  := QRY->D2_COD 
	TRB->DESC     := QRY->B1_DESC
	TRB->PRCVEN   := QRY->D2_PRCVEN * (QRY->C5_PERCRES / 100 ) 
	TRB->VALMERC  := ( QRY->D2_TOTAL * (QRY->C5_PERCRES / 100 ) ) //* QRY->C6_QTDENT
	TRB->TOTAL    := ( QRY->D2_TOTAL * ( QRY->C5_PERCRES / 100 )) // * QRY->C6_QTDENT
	TRB->COMIS    := QRY->A3_COMIS
	TRB->CGC      := QRY->C5_CNPJ
	TRB->NOME     := QRY->C5_NOMCLI
	TRB->MUN      := QRY->C5_MUN
	TRB->EST      := QRY->C5_UFCLI 
	TRB->VEND     := QRY->C5_VEND1
	TRB->NOMVEND  := QRY->A3_NOME
	TRB->CLIENTE  := QRY->C5_CLIENTE
	TRB->LOJA     := QRY->C5_LOJACLI
	
	TRB->CF       := QRY->D2_CF

	TRB->COND     := QRY->C5_CONDPAG
	
	TRB->TPFRETE  := QRY->C5_TPFRETE
	
	TRB->EMPRESA  := SM0->M0_CODIGO 
	
	TRB->PESO     := QRY->B1_PESBRU * QRY->D2_QUANT  
	TRB->DTEMIPV  := QRY->D2_EMISSAO
	
	MsUnlock()
	
	DbSelectArea("QRY")
	DbSkip()
	
End

QRY->(DbCloseArea())

 
Return
