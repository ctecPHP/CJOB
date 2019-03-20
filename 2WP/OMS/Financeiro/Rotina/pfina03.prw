#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFINA03   ºAutor  ³Carlos R. Moreira   º Data ³  07/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os Pedidos com Bloqueio de Credito                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFINA03()

	aIndexSC5  := {}

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Visualizar","A410Visual" , 0 , 1},;
	{ "Analisar"   ,"U_PFINA03A" , 0 , 2} }

	Private oFont1  := TFont():New( "TIMES NEW ROMAN",12.5,18,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "ARIAL",12.5,12,,.T.,,,,,.F.)
	Private oFont3  := TFont():New( "ARIAL",10.5,10,,.T.,,,,,.F.)
	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)

	PRIVATE bFiltraBrw := {|| Nil}

	If !ExisteSX6("MV_LIBFIN")
		CriarSX6("MV_LIBFIN","C","Guarda os usuarios que possuem autorização de liberacao Financeira","000000")
	EndIf

	cUserLib := Alltrim(GetMV("MV_LIBFIN"))

	If ! __cUserID $ cUserLib
		MsgStop("Usuario nao autorizado a liberar financeiramente o pedido de venda.")
		Return 
	EndIf  

	Private aCores := { { " C5_STAPED = 'L' "  , 'ENABLE' },;
	{ " C5_STAPED = 'F'" , 'DISABLE'  },;
	{ " C5_STAPED = 'C' .And. Empty(C5_ZZLIBFI)" , 'BR_PINK'  },;
	{ " C5_STAPED = 'E'" , 'BR_AZUL'  },;
	{ " C5_STAPED = 'P'" , 'BR_LARANJA'  },;
	{ " C5_STAPED = 'A'" , 'BR_BRANCO'  },;
	{ " C5_STAPED = 'S'" , 'BR_MARRON'  },;
	{ " C5_STAPED = 'R' .Or. C5_ZZLIBFI = 'B' " , 'BR_VIOLETA'  },;
	{ " C5_STAPED = 'D'" , 'BR_AMARELO'  },;
	{ " C5_STAPED = 'M'" , 'BR_CINZA'  }}

	Private cCadastro := OemToAnsi("Analise Financeira - (Cliente)")

	cFiltraSC5 := "C5_STAPED = 'C'" 


	bFiltraBrw 	:= {|| FilBrowse("SC5",@aIndexSC5,@cFiltraSC5) }
	Eval(bFiltraBrw)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw("SC5",aIndexSC5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a condicao de Entrada                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbClearFilter()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFINA02A  ºAutor  ³Microsiga           º Data ³  12/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua liberacao do pedido no creito para que não retorne  ±±
±±º          ³ Novamente                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFINA03A()
	Local oDlg2

	Local aSize     := MsAdvSize(.F.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local aCampos := {}

	AADD(aCampos,{ "OK"       ,"C",02,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "VLRPED"   ,"N",15,2 } )		
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )
	AADD(aCampos,{ "TPPED"    ,"C",01,0 } )
	AADD(aCampos,{ "STATUS"   ,"C",01,0 } )	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRBPED", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRBPED",cNomArq,"PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	Private nRadio := 1
	Private oRadio
	Private cMotivo := Space(40)

	cUser := RetCodUsr()

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))

	Private oLimite, oCliente, oNome, oVcLimite, oRisco, oLimTomado, oDisponivel, oForPgt  

	nLimite   := SA1->A1_LC 
	dVcLimite := SA1->A1_VENCLC 
	cRisco    := SA1->A1_RISCO 

	cCliente := SA1->A1_COD 
	cNome    := SA1->A1_NOME
	
	cForma := " "
	If Substr(SA1->A1_ZZFORPA,1,1)  == "D"
	    cForma := "Deposito" 
	ElseIf Substr(SA1->A1_ZZFORPA,1,1) == "C"
	    cForma := "Carteira" 
	ElseIf Substr(SA1->A1_ZZFORPA,1,1) == "H"
	    cForma  := "Cheque" 
	ElseIf Substr(SA1->A1_ZZFORPA,1,1) == "B"
	    cForma  := "Boleto" 
	Else
	    cForma := "Nao definida"     
    EndIf 	     

	//Buscando o saldo tomado em titulos 

	cQuery := "  SELECT SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1") 
	cQuery += "  WHERE D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND E1_TIPO <> 'NCC' "   
	cQuery += "       AND E1_CLIENTE ='"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "  

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	nLimTomado := 0

	While QRY->(!Eof())

		nLimTomado += QRY->SALDO 

		DbSkip()

	End 

	QRY->(DbCloseArea()) 

	aPedidos := {}

	//Buscando o saldo tomado em titulos 

	cQuery := "  SELECT SC5.C5_NUM, SC5.C5_FECENT,SC5.C5_VLRPED,SC5.C5_ZZTIPO,SC5.C5_STAPED  FROM "+RetSqlName("SC5")+" SC5 " 
	cQuery += "  WHERE SC5.D_E_L_E_T_ <> '*' AND SC5.C5_STAPED <> 'F'  "   
	cQuery += "       AND SC5.C5_CLIENTE ='"+SA1->A1_COD+"' AND SC5.C5_LOJACLI = '"+SA1->A1_LOJA+"' "  

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	TCSetField("QRY","C5_FECENT","D")

	nTotPed := nPedLibCre := 0 

	While QRY->(!Eof())

		DbSelectArea("TRBPED")
		RecLock("TRBPED",.T.)
		TRBPED->PEDIDO := QRY->C5_NUM
		TRBPED->VLRPED := QRY->C5_VLRPED
		TRBPED->ENTREG := QRY->C5_FECENT
		TRBPED->TPPED  := QRY->C5_ZZTIPO
		TRBPED->STATUS := QRY->C5_STAPED  
		MsUnlock() 

		If QRY->C5_STAPED $ "C,R"
			nPedLibCre += QRY->C5_VLRPED 
		EndIf 

		nTotPed  += QRY->C5_VLRPED  

		DbSelectArea("QRY")   
		DbSkip()

	End 

	QRY->(DbCloseArea()) 

	// Verificando se o Cliente possui saldo em aberto 
	cQuery := " SELECT  E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO " 
	cQuery += " FROM  "+RetSqlName("SE1")  
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND E1_VENCREA < '"+Dtos(dDataBase)+"' "
	cQuery +=  " AND E1_CLIENTE ='"+SC5->C5_CLIENTE+"' AND E1_LOJA ='"+SC5->C5_LOJACLI+"' "
	cQuery +=  " AND E1_TIPO <> 'NCC' "

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRY", .F., .T. )

	DbSelectArea("QRY")
	DbGoTop()

	nVlrAtraso := 0 

	While  QRY->(!Eof())

		nVlrAtraso += QRY->E1_SALDO  

		DbSkip()

	End

	QRY->(DbCloseArea())

	aBrowse := {}

	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{ "VLRPED" ,"","Vlr Pedido","@e 99,999,999.99"})		
	AaDD(aBrowse,{ "ENTREG" ,"","Dt Entrega"})
	AaDD(aBrowse,{ "TPPED" ,"","Tipo Pedido"})	
	AaDD(aBrowse,{ "STATUS" ,"","Status"})

	DbSelectArea("TRBPED")
	aCores := {}

	aCores := { { "STATUS = 'L' "  , 'ENABLE' },;
	{ "STATUS = 'F'  " , 'DISABLE'  },;
	{ "STATUS = 'C'" , 'BR_PINK'  },;
	{ "STATUS = 'T'" , 'BR_LARANJA'  },;
	{ "STATUS = 'P'" , 'BR_BRANCO'  },;
	{ "STATUS = 'S'" , 'BR_MARRON_OCEAN'  },;
	{ "STATUS = 'R'" , 'BR_VIOLETA'  },;	
	{ "STATUS = 'D'" , 'BR_AMARELO'  },;
	{ "STATUS = 'O'" , 'BR_AZUL_CLARO'  },;
	{ "STATUS = 'A'" , 'BR_VERDE_ESCURO' } ,; 		
	{ "STATUS = 'M'" , 'BR_CINZA'  }}

	cMarca  := GetMark()
	nOpca   :=0
	lInverte := .F.

	TRBPED->(DbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula as coordenadas da interface                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aObjects, { 100, 030, .T., .F.,.T. } )
	AAdd( aObjects, { 100, 090, .T., .T.,.T. } )
	AAdd( aObjects, { 100, 030, .T., .F.,.F. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	SetEnch(,.F.) //Retira o Texto do aRotina
	DEFINE MSDIALOG oDlg1 TITLE "Analise de Credito" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL //"Analise de Credito - ( CLIENTE )"
	oFolder := TFolder():New(aPosObj[2,1]+5,aPosObj[2,2]+2,{"Analise","Pedidos"},{"",""},oDlg1,,,,.T.,.F.,aPosObj[2,3]-1,aPosObj[2,4]-8) //"Analise"###"Pedidos"###"Condicoes"

	@ 05,05 TO 35,670 OF odlg1 PIXEL Label "Dados Cadastrais" 

	@ 18, 20 Say OemToAnsi("Cliente: ") Size 70,8  OF odlg1 PIXEL
	@ 15, 43  MsGet oCliente   Var cCliente    Size 45,10   When .F. OF odlg1 PIXEL 

	@ 18, 120 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
	@ 15, 143  MsGet oNome  Var cNome  Size 145,10   When .F. OF odlg1 PIXEL

	@ 18, 320 Say OemToAnsi("Risco : ") Size 70,8  OF odlg1 PIXEL
	@ 15, 353  MsGet oRisco   Var cRisco   Size 45,10   When .F. OF odlg1 PIXEL 

	@ 18, 420 Say OemToAnsi("Vc Limite: ") Size 50,8  OF odlg1 PIXEL
	@ 15, 453  MsGet oVcLimite Var dVcLimite  Size 55,10   When .F. OF odlg1 PIXEL

	@ 18, 520 Say OemToAnsi("Forma Pgt: ") Size 50,8  OF odlg1 PIXEL
	@ 15, 553  MsGet oForma Var cForma    Size 55,10   When .F. OF odlg1 PIXEL


	//Dados do folder um para analise 
	@ 20, 10 Say OemToAnsi("Limite: ") Size 90,8  oF oFolder:aDialogs[1]  PIXEL COLOR CLR_HBLUE FONT oFont1
	@ 18, 93  MsGet oLimite Var nLimite Picture "@E 999,999,999.99"  Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1 

	@ 40, 10 Say OemToAnsi("Limite Tomado:") Size 90,8  oF oFolder:aDialogs[1]  PIXEL COLOR CLR_HBLUE FONT oFont1
	@ 38, 93  MsGet oLimTomado  Var nLimTomado Picture "@E 999,999,999.99"  Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1 

	nDisponivel := nLimite - nLimTomado 

	@ 60, 10 Say OemToAnsi("Disponivel: ") Size 90,8  OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1
	@ 58, 93  MsGet oDisponivel  Var nDisponivel  Picture "@E 999,999,999.99" Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1 

	@ 80, 10 Say OemToAnsi("Ped lib Credito: ") Size 90,8  OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1
	@ 78, 93  MsGet oPedLibCre  Var nPedLibCre  Picture "@E 999,999,999.99" Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1 

	@ 100, 10 Say OemToAnsi("Total Ped : ") Size 90,8  OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1
	@ 98, 93  MsGet oTotPed  Var nTotPed  Picture "@E 999,999,999.99" Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_HBLUE FONT oFont1 

	If nVlrAtraso > 0 

		@ 120, 10 Say OemToAnsi("Vlr em Atraso: ") Size 90,8  OF oFolder:aDialogs[1] PIXEL COLOR CLR_RED FONT oFont1
		@ 118, 93  MsGet oVlrAtraso Var nVlrAtraso  Picture "@E 999,999,999.99" Size 85,10   When .F. OF oFolder:aDialogs[1] PIXEL COLOR CLR_RED FONT oFont1  

	EndIf 

	@ 200,10  BUTTON OemToAnsi("Acerta Cliente")  SIZE 70,15 FONT oDlg1:oFont ACTION (AceCliLim(oDlg1)) OF oFolder:aDialogs[1] PIXEL //

	/*	@ 40, 320 Say OemToAnsi("Peso: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 343  MsGet oPeso   Var nPeso Picture "@e 99999999"   Size 65,10   When .F. OF odlg1 PIXEL

	@ 40, 420 Say OemToAnsi("Tp Carga: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 453  MsGet oTpCarg  Var ctpCarg    Size 55,10   When .F. OF odlg1 PIXEL */ 

	//	@ aPosObj[1,1]+26 ,aPosObj[1,2]+0.5 TO aPosObj[1,3]-9.5,aPosObj[1,4]-1 OF odlg1 PIXEL Label "Pedidos"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "TRB".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRBPED"," ","",aBrowse,@lInverte,@cMarca,{05,05 ,190 ,670},,,oFolder:aDialogs[2],,aCores) // )  //,,,,,aCores)

	@ 200, 10 Say OemToAnsi("Total Pedidos : ") Size 90,15  OF oFolder:aDialogs[2] PIXEL Color CLR_HBLUE  FONT oFont1 
	@ 198, 113  MsGet oTotPed  Var nTotPed  Picture "@E 999,999.99" Size 95,15   When .F. OF oFolder:aDialogs[2] PIXEL COLOR CLR_HBLUE FONT oFont1

	@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg1 PIXEL
	@ aPosObj[3,1]+10,aPosObj[3,2]+010 BUTTON OemToAnsi("Consulta")  SIZE 40,12 FONT oDlg1:oFont ACTION (ConsultaPos(),nOpca:=0) OF oDlg1 PIXEL //
	@ aPosObj[3,1]+10,aPosObj[3,2]+055 BUTTON OemToAnsi("Cliente")  SIZE 40,12 FONT oDlg1:oFont ACTION (cCadastro:=OemToAnsi("Cliente"),A030Visual("SA1",SA1->(RecNo()),1),DbSelectArea("TRBPED"),nOpca := 0 ) OF oDlg1 PIXEL //"Cliente"

	@ aPosObj[3,1]+10,aPosObj[3,2]+145 BUTTON OemToAnsi("Libera")  SIZE 40,12 FONT oDlg1:oFont ACTION (nOpcA := 1,oDlg1:End() ) OF oDlg1 PIXEL //
	@ aPosObj[3,1]+10,aPosObj[3,2]+190 BUTTON OemToAnsi("Rejeita")  SIZE 40,12 FONT oDlg1:oFont ACTION (nOpcA := 3,oDlg1:End() ) OF oDlg1 PIXEL //

	@ aPosObj[3,1]+10,aPosObj[3,2]+255 BUTTON OemToAnsi("Sair")  SIZE 40,12 FONT oDlg1:oFont ACTION (oDlg1:End() ) OF oDlg1 PIXEL //

	@ aPosObj[3,1]+8,aPosObj[3,4]-105 BUTTON OemToAnsi("Lib.Bloq Especial")  SIZE 80,18 FONT oDlg1:oFont ACTION (nOpcA := 2,oDlg1:End() ) OF oDlg1 PIXEL //

	ACTIVATE DIALOG oDlg1 CENTERED 

	If nOpca == 1

		lFilPed := .F.
		lLibCre := .T. 
		If nDisponivel < nPedLibCre 
			If ! MsgYesNo("Limite disponivel menor que o total a liberar. Deseja filtrar pedido")
				lLibCre := .F. 

			Else
				lFilPed := .T.    
			EndIf 
		EndIf 

		If lLibCre  

			DbSelectArea("TRBPED")
			DbGoTop()

			While TRBPED->(!Eof())

				If ! TRBPED->STATUS $ "C,R"
					DbSkip()
					Loop
				EndIf  

				If lFilPed 

					If ! MsgYesNo("Pedido "+TRBPED->PEDIDO+" Valor: "+Transform(TRBPED->VLRPED,"@e 999,999.99")+" Liberar")
						DbSkip()
						Loop

					EndIf 

				EndIf 

				cPedido := TRBPED->PEDIDO  

				DbSelectArea("SC9")
				DbSetOrder(1)
				If ! DbSeek(xFilial("SC9")+cPedido  )

					U_libped(cPedido)

				EndIf 

				DbSelectArea("SC9")
				DbSetOrder(1)
				DbSeek(xFilial("SC9")+cPedido  )

				While SC9->(!Eof()) .And. SC9->C9_PEDIDO = cPedido 

					If !Empty(SC9->C9_BLCRED) //Item com Bloqueio de Estoque
						RecLock("SC9",.F.)
						SC9->C9_BLCRED := " "
						MsUnlock()

					EndIf

					DbSkip()
				End

				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED := IF(SC5->C5_ZZLIBFI=="B","T",If(SC5->C5_REQAGEN="S" .Or.SC5->C5_TPFRETE="F","A","L"))
				SC5->C5_USLIBC := cUser
				SC5->C5_NOLIBC := Substr(cUsuario,7,15)
				SC5->C5_DTLIBC   := Date()
				SC5->C5_HRLIBC   := Time()
				SC5->C5_ZZLIBFI  := " "
				SC5->C5_MOTIVO   := cMotivo 
				MsUnlock()

				DbSelectArea("TRBPED")
				DbSkip()

			End 

		EndIF
		nOpca := 0 
	ElseIf nOpca == 2 

		If MsgYesNo("Libera o pedido mesmo com o cliente em atraso" ) 

			DbSelectArea('TRBPED')
			DbGoTop()

			While TRBPED->(!Eof())

				If ! TRBPED->STATUS $ "C,R"
					DbSkip()
					Loop
				EndIf  

				cPedido := TRBPED->PEDIDO  

				DbSelectArea("SC9")
				DbSetOrder(1)
				If ! DbSeek(xFilial("SC9")+cPedido  )

					U_libped(cPedido)

				EndIf 

				DbSelectArea("SC9")
				DbSetOrder(1)
				DbSeek(xFilial("SC9")+cPedido  )

				While SC9->(!Eof()) .And. SC9->C9_PEDIDO = cPedido 

					If !Empty(SC9->C9_BLCRED) //Item com Bloqueio de Estoque
						RecLock("SC9",.F.)
						SC9->C9_BLCRED := " "
						MsUnlock()

					EndIf

					DbSkip()
				End

				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED := IF(SC5->C5_ZZLIBFI=="B","T","L")
				SC5->C5_USLIBC := cUser
				SC5->C5_NOLIBC := Substr(cUsuario,7,15)
				SC5->C5_DTLIBC   := Date()
				SC5->C5_HRLIBC   := Time()
				SC5->C5_ZZLIBFI  := "S"
				SC5->C5_MOTIVO   := cMotivo 
				MsUnlock()

				DbSelectArea("TRBPED")
				DbSkip()
			End

		EndIf 
		nOpca := 0

	ElseIf nOpca == 3    

		If MsgYesNo("Confirma a rejeição do Pedido ")

			DbSelectArea('TRBPED')
			DbGoTop()

			While TRBPED->(!Eof())

				If ! TRBPED->STATUS $ "C,R"
					DbSkip()
					Loop
				EndIf  

				cPedido := TRBPED->PEDIDO  

				DbSelectArea("SC9")
				DbSetOrder(1)
				If ! DbSeek(xFilial("SC9")+cPedido  )

					U_libped(cPedido)

				EndIf 

				DbSelectArea("SC9")
				DbSetOrder(1)
				DbSeek(xFilial("SC9")+cPedido  )

				While SC9->(!Eof()) .And. SC9->C9_PEDIDO = cPedido 

					If !Empty(SC9->C9_BLCRED) //Item com Bloqueio de Estoque
						RecLock("SC9",.F.)
						SC9->C9_BLCRED := "01" 
						MsUnlock()

					EndIf

					DbSkip()
				End

                cMotivo := GetMotivo()
                 
				DbSelectArea("SC5")
				RecLock("SC5",.F.)
				SC5->C5_STAPED := "R"
				SC5->C5_USLIBC := cUser
				SC5->C5_NOLIBC := Substr(cUsuario,7,15)
				SC5->C5_DTLIBC   := Date()
				SC5->C5_HRLIBC   := Time()
				SC5->C5_ZZLIBFI  := " "
				SC5->C5_MOTIVO   := cMotivo 
				MsUnlock()

				DbSelectArea("TRBPED")
				DbSkip()
			End

		EndIf 
		nOpca := 0

	EndIf 

	TRBPED->(DbCloseArea())

Return


/*/

Acerta o limite, vencimento do limite e Risco 

/*/

Static Function AceCliLim()
	Local nRadio := 3 
	Local nOpcCli := 0
	Local oDlg2

	nLimite   := SA1->A1_LC 
	dVcLimite := SA1->A1_VENCLC 
	cRisco    := SA1->A1_RISCO 

	If cRisco == "A"
		nRadio := 1
	ElseIf cRisco == "B"
		nRadio := 2 
	ElseIf cRisco == "C"
		nRadio := 3 
	ElseIf cRisco == "D"
		nRadio := 4 
	ElseIf cRisco == "E"
		nRadio := 5 
	EndIf 

	nOpcCli := 0

	While .T.

		DEFINE MSDIALOG oDlg2 TITLE "Acerta Cadastro Cliente" From 9,0 To 22,60 OF oMainWnd

		@ 05,05 TO 70, 80 TITLE "Risco"
		@ 10,30 RADIO oRadio Var nRadio Items "A","B","C","D","E" 3D SIZE 60,10 of oDlg2 Pixel

		@ 05,85 TO 35,235 TITLE "Limite"
		@ 13,140 MSGet nLimite  Picture "@E 999,999,999.99" Size 70 ,10  of oDlg2 Pixel 

		@ 40,85 TO 70,235 TITLE "Venc Limite"
		@ 48,140 MSGet dVcLimite   Size 70 ,10  of oDlg2 Pixel 

		@ 082,110 BUTTON "&Ok"   SIZE 50,15 ACTION {||nOpcCli:=1,Close(oDlg2)} of oDlg2 Pixel
		@ 082,180 BUTTON "&Sair" SIZE 50,15 ACTION {||nOpcCli:=3,Close(oDlg2)} of oDlg2 Pixel

		ACTIVATE DIALOG oDlg2 CENTER

		If  nOpcCli == 1   

			DbSelectArea("SA1")
			RecLock("SA1",.F.)
			SA1->A1_LC     := nLimite
			SA1->A1_VENCLC := dVcLimite
			Do Case 
				Case nRadio == 1 
				SA1->A1_RISCO  := "A"
				Case nRadio == 2 
				SA1->A1_RISCO  := "B"
				Case nRadio == 3 
				SA1->A1_RISCO  := "C"
				Case nRadio == 4 
				SA1->A1_RISCO  := "D"
				Case nRadio == 5 
				SA1->A1_RISCO  := "E"
			EndCase         
			MsUnlock()
			nDisponivel := nLimite - nLimtomado 
			cRisco:= SA1->A1_RISCO 
			oRisco:Refresh()
			oVcLimite:Refresh()
			DlgRefresh(oDlg1)
			Exit  
		ElseIf nOpcCli == 3         
			Exit
		EndIf

	End

Return 
/*/

Ira mostrar a consulta da posicao de clients

/*/
Static Function ConsultaPos()
	Local aArea := GetArea()

	a450F4con()

    DbSelectArea("TRBPED")
    
	RestArea(aArea)
Return 

/*/

Informa o motivo da rejeicao de credito

/*/
Static Function GetMotivo()
Local cMotivo := Space(60)

	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Motivo da Rejeição" From 9,0 To 18,100 OF oMainWnd

	@ 5,3 to 41,395 of oDlgProc PIXEL

	@ 15,5 Say "Motivo: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cMotivo  Picture "@S50"  Valid !Empty(cMotivo)Size 320 ,10 of oDlgProc Pixel

//	@ 50, 90 BMPBUTTON TYPE 1 Action GrvObs(@cObs,oDlgProc,nModo)
	@ 50,120 BMPBUTTON TYPE 1 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered


Return cMotivo 
