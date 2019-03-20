#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA10   ºAutor  ³Carlos R. Moreira   º Data ³  05/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra os romaneio que estao em aberto para faturamento    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function POMSA04()

	Private cCadastro := OemToAnsi("Cadastro de Romaneio")

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Consultar","U_POMSA04C" , 0 , 2},;
	{ "Excluir","U_POMSA04E" , 0 , 1},;
	{ "Inc Ped Rom","U_POMSA04I" , 0 , 1},;		
	{ "Ret Ped Rom","U_POMSA04P" , 0 , 1},;
	{ "Encerra Rom","U_POMSA04F" , 0 , 1},;
	{ "Ac Dt Carregamento","U_POMSA04D" , 0 , 1},;		
	{"Legenda","U_PFATA10Legenda", 0 , 0 , 0 , .F.}}		//


	//Ira checar se o usuario tem permissao para digitacao do Inventario
	Private cCodUsu := __cuserid

	aCores := { { " ZZQ_STATUS = 'L' "  , 'ENABLE' },;
	{ " ZZQ_STATUS = 'B'" , 'BR_AMARELO'  },;
	{ " ZZQ_STATUS = 'F'  " , 'DISABLE'  },;
	{ " ZZQ_STATUS = ' '" , 'BR_AZUL_CLARO'  },;
	{ " ZZQ_STATUS = 'O'" , 'BR_CINZA'  }}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"ZZQ",,,,,,aCores)//,,"C5_LIBEROK"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PFATA10C   ³ Autor ³ Carlor R Moreira     ³ Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela com a consulta do Romaneio                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function POMSA04C()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Local aCampos := {}

	AADD(aCampos,{ "OK"       ,"C",02,0 } )
	AADD(aCampos,{ "EMP"      ,"C",02,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",20,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C", 6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C", 2,0 } )
	AADD(aCampos,{ "NOME"     ,"C",40,0 } )	
	AADD(aCampos,{ "NF"       ,"C", 6,0 } )
	AADD(aCampos,{ "SERIE"    ,"C", 3,0 } )
	AADD(aCampos,{ "STATUS"   ,"C", 1,0 } )	
	AADD(aCampos,{ "ZONA"     ,"C", 6,0 } )
	AADD(aCampos,{ "DESZONA"  ,"C",40,0 } )	
	AADD(aCampos,{ "PESO"     ,"N", 8,0 } )
	AADD(aCampos,{ "QTDPED"   ,"N", 8,0 } )
	AADD(aCampos,{ "VLRPED"   ,"N",15,2 } )		
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )
	AADD(aCampos,{ "QTDPAL"   ,"N", 3,0 } )
	AADD(aCampos,{ "DTAGEN"   ,"D", 8,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"EMP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		DbSelectArea('TRB')
		RecLock("TRB",.T.)
		TRB->EMP     := ZZR->ZZR_EMP   
		TRB->NOMEMP  := ""
		TRB->PEDIDO  := ZZR->ZZR_PEDIDO 
		TRB->CLIENTE := ZZR->ZZR_CLIENTE
		TRB->LOJA    := ZZR->ZZR_LOJA
		TRB->NOME    := ZZR->ZZR_NOME	
		TRB->NF      := ZZR->ZZR_NOTA
		TRB->SERIE   := ZZR->ZZR_SERIE
		TRB->ZONA    := ZZR->ZZR_ZONA
		TRB->DESZONA := ZZR->ZZR_DESZONA
		TRB->STATUS  := ZZR->ZZR_STAFAT 
		TRB->PESO    := ZZR->ZZR_PESO
		TRB->QTDPED  := ZZR->ZZR_QTDPED 
		TRB->VLRPED  := ZZR->ZZR_VLRPED
		TRB->DTAGEN  := ZZR->ZZR_DTAGEN
		TRB->QTDPAL  := ZZR->ZZR_QTDPAL
		TRB->ENTREG  := ZZR->ZZR_ENTREG 	
		MsUnlock()

		DbSelectArea("ZZR")
		DbSkip()
	End  

	Private oTransp,oDescTra,oRomaneio
	Private oTpCarg,oPeso,oTpVeic,	oDesVei,oDtCarre 


	cTransp   := ZZQ->ZZQ_TRANSP
	cDescTra  := ZZQ->ZZQ_DESTRA
	cRomaneio := ZZQ->ZZQ_ROMANE

	cTpCarg   := If( ZZQ->ZZQ_TPCARG=="1","Batida","Paletizada" ) 
	nPeso     := ZZQ->ZZQ_PESO 
	cTpVeic   := ZZQ->ZZQ_TPVEIC
	cDesVei   := ZZQ->ZZQ_DESVEI 

	dDtCarre  := ZZQ->ZZQ_DTCARR

	DbSelectArea("TRB")
	DbGoTop()

	cMarca  := GetMark()

	aBrowse := {}

	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"NF","","N.Fiscal"})
	AaDD(aBrowse,{"SERIE","","Serie"})
	AaDD(aBrowse,{"ZONA","","Zona"})
	AaDD(aBrowse,{"DESZONA","","Descricao"})
	AaDD(aBrowse,{ "PESO"   ,"","Peso","@e 99,999,999"})
	AaDD(aBrowse,{ "QTDPED" ,"","Qtd Cxs","@e 99,999,999"})
	AaDD(aBrowse,{ "VLRPED" ,"","Vlr Pedido","@e 99,999,999.99"})		
	AaDD(aBrowse,{ "ENTREG" ,"","Dt Entrega"})
	AaDD(aBrowse,{ "QTDPAL" ,"","Qtd Pallet","@e 9,999"})
	AaDD(aBrowse,{ "DTAGEN" ,"","Dt Agenda"})

	AADD(aObjects,{ 10,05,.T.,.T.})

	aCores := {}

	//	Aadd(aCores, { 'OPER = "08"', "BR_PRETO" } )
	Aadd(aCores, { 'STATUS = "F" ', "DISABLE" } )
	Aadd(aCores, { 'STATUS = " " ', "ENABLE" } )
	//	Aadd(aCores, { 'LIBPED = "O" ', "BR_CINZA" } )
	//	Aadd(aCores, { '!Empty(OBSINT) .Or. !Empty(OBSEXT)', "BR_VIOLETA" } )	

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Consulta Romaneio " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 15,05 TO 55,670 OF odlg1 PIXEL  

	@ 20, 20 Say OemToAnsi("Romaneio: ") Size 70,8  OF odlg1 PIXEL
	@ 18, 63  MsGet oRomaneio  Var cRomaneio   Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 120 Say OemToAnsi("Transportadora : ") Size 70,8  OF odlg1 PIXEL
	@ 18, 163  MsGet oTransp  Var cTransp  Valid ChkTransp() F3 "SA4" Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 220 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 253  MsGet oDescTra   Var cDescTra   Size 145,10   When .F. OF odlg1 PIXEL

	@ 20, 420 Say OemToAnsi("Dt Carreg: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 453  MsGet oDtCarre  Var dDtCarre   Size 55,10   When .F. OF odlg1 PIXEL

	@ 40, 20 Say OemToAnsi("Tp Veic.: ") Size 70,8  OF odlg1 PIXEL
	@ 38, 63  MsGet oTpVeic    Var cTpVeic     Size 45,10   When .F. OF odlg1 PIXEL 

	@ 40, 120 Say OemToAnsi("Descricao : ") Size 70,8  OF odlg1 PIXEL
	@ 38, 163  MsGet oDesVei  Var cDesVei   Size 145,10   When .F. OF odlg1 PIXEL 

	@ 40, 320 Say OemToAnsi("Peso: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 343  MsGet oPeso   Var nPeso Picture "@e 99999999"   Size 65,10   When .F. OF odlg1 PIXEL

	@ 40, 420 Say OemToAnsi("Tp Carga: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 453  MsGet oTpCarg  Var ctpCarg    Size 55,10   When .F. OF odlg1 PIXEL

	@ aPosObj[1,1]+26 ,aPosObj[1,2]+0.5 TO aPosObj[1,3]-9.5,aPosObj[1,4]-1 OF odlg1 PIXEL Label "Pedidos"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "TRB".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB"," ","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+35 ,aPosObj[1,2]+5 ,aPosObj[1,3]-11,aPosObj[1,4]-2},,,,,aCores)
	/*		oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } */

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

Return

/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LchoiceBar³ Autor ³ Pilar S Albaladejo    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra a EnchoiceBar na tela                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq,nTipo)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
	SetKEY(24,oBtCan:bAction)
	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction
	oBar:bRClicked := {|| AllwaysTrue()}
Return

/*/

Excluir Romaneio 

/*/ 
User Function POMSA04E()


	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}


	If ZZQ->ZZQ_STATUS $ "O/F"
		MsgStop("Romaneio ja faturando nao pode ser excluido")
		Return 
	EndIf

	Private aCampos := {}

	AADD(aCampos,{ "OK"       ,"C",02,0 } )
	AADD(aCampos,{ "EMP"      ,"C",02,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",20,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C", 6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C", 2,0 } )
	AADD(aCampos,{ "NOME"     ,"C",40,0 } )	
	AADD(aCampos,{ "NF"       ,"C", 6,0 } )
	AADD(aCampos,{ "SERIE"    ,"C", 3,0 } )
	AADD(aCampos,{ "STATUS"   ,"C", 1,0 } )	
	AADD(aCampos,{ "ZONA"     ,"C", 6,0 } )
	AADD(aCampos,{ "DESZONA"  ,"C",40,0 } )	
	AADD(aCampos,{ "PESO"     ,"N", 8,0 } )
	AADD(aCampos,{ "QTDPED"   ,"N", 8,0 } )
	AADD(aCampos,{ "VLRPED"   ,"N",15,2 } )		
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )
	AADD(aCampos,{ "QTDPAL"   ,"N", 3,0 } )
	AADD(aCampos,{ "DTAGEN"   ,"D", 8,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"EMP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		DbSelectArea('TRB')
		RecLock("TRB",.T.)
		TRB->EMP     := ZZR->ZZR_EMP   
		TRB->NOMEMP  := ""
		TRB->PEDIDO  := ZZR->ZZR_PEDIDO 
		TRB->CLIENTE := ZZR->ZZR_CLIENTE
		TRB->LOJA    := ZZR->ZZR_LOJA
		TRB->NOME    := ZZR->ZZR_NOME	
		TRB->NF      := ZZR->ZZR_NOTA
		TRB->SERIE   := ZZR->ZZR_SERIE
		TRB->ZONA    := ZZR->ZZR_ZONA
		TRB->DESZONA := ZZR->ZZR_DESZONA
		TRB->STATUS  := ZZR->ZZR_STAFAT 
		TRB->PESO    := ZZR->ZZR_PESO
		TRB->QTDPED  := ZZR->ZZR_QTDPED 
		TRB->VLRPED  := ZZR->ZZR_VLRPED
		TRB->DTAGEN  := ZZR->ZZR_DTAGEN
		TRB->QTDPAL  := ZZR->ZZR_QTDPAL
		TRB->ENTREG  := ZZR->ZZR_ENTREG 	

		MsUnlock()
		DbSelectArea("ZZR")
		DbSkip()
	End  

	Private oTransp,oDescTra,oRomaneio
	Private oTpCarg,oPeso,oTpVeic,	oDesVei,oDtCarre 


	cTransp   := ZZQ->ZZQ_TRANSP
	cDescTra  := ZZQ->ZZQ_DESTRA
	cRomaneio := ZZQ->ZZQ_ROMANE

	cTpCarg   := If( ZZQ->ZZQ_TPCARG=="1","Batida","Paletizada" ) 
	nPeso     := ZZQ->ZZQ_PESO 
	cTpVeic   := ZZQ->ZZQ_TPVEIC
	cDesVei   := ZZQ->ZZQ_DESVEI 

	dDtCarre  := ZZQ->ZZQ_DTCARR

	DbSelectArea("TRB")
	DbGoTop()

	cMarca  := GetMark()

	aBrowse := {}

	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"NF","","N.Fiscal"})
	AaDD(aBrowse,{"SERIE","","Serie"})
	AaDD(aBrowse,{"ZONA","","Zona"})
	AaDD(aBrowse,{"DESZONA","","Descricao"})
	AaDD(aBrowse,{ "PESO"   ,"","Peso","@e 99,999,999"})
	AaDD(aBrowse,{ "QTDPED" ,"","Qtd Cxs","@e 99,999,999"})
	AaDD(aBrowse,{ "VLRPED" ,"","Vlr Pedido","@e 99,999,999.99"})		
	AaDD(aBrowse,{ "ENTREG" ,"","Dt Entrega"})
	AaDD(aBrowse,{ "QTDPAL" ,"","Qtd Pallet","@e 9,999"})
	AaDD(aBrowse,{ "DTAGEN" ,"","Dt Agenda"})

	AADD(aObjects,{ 10,05,.T.,.T.})

	aCores := {}

	//	Aadd(aCores, { 'OPER = "08"', "BR_PRETO" } )
	Aadd(aCores, { 'STATUS = "F" ', "DISABLE" } )
	Aadd(aCores, { 'STATUS = " " ', "ENABLE" } )
	//	Aadd(aCores, { 'LIBPED = "O" ', "BR_CINZA" } )
	//	Aadd(aCores, { '!Empty(OBSINT) .Or. !Empty(OBSEXT)', "BR_VIOLETA" } )	

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Exclusao de Romaneio " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 15,05 TO 55,670 OF odlg1 PIXEL  

	@ 20, 20 Say OemToAnsi("Romaneio: ") Size 70,8  OF odlg1 PIXEL
	@ 18, 63  MsGet oRomaneio  Var cRomaneio   Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 120 Say OemToAnsi("Transportadora : ") Size 70,8  OF odlg1 PIXEL
	@ 18, 163  MsGet oTransp  Var cTransp  Valid ChkTransp() F3 "SA4" Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 220 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 253  MsGet oDescTra   Var cDescTra   Size 145,10   When .F. OF odlg1 PIXEL

	@ 20, 420 Say OemToAnsi("Dt Carreg: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 453  MsGet oDtCarre  Var dDtCarre   Size 55,10   When .F. OF odlg1 PIXEL

	@ 40, 20 Say OemToAnsi("Tp Veic.: ") Size 70,8  OF odlg1 PIXEL
	@ 38, 63  MsGet oTpVeic    Var cTpVeic     Size 45,10   When .F. OF odlg1 PIXEL 

	@ 40, 120 Say OemToAnsi("Descricao : ") Size 70,8  OF odlg1 PIXEL
	@ 38, 163  MsGet oDesVei  Var cDesVei   Size 145,10   When .F. OF odlg1 PIXEL 

	@ 40, 320 Say OemToAnsi("Peso: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 343  MsGet oPeso   Var nPeso Picture "@e 99999999"   Size 65,10   When .F. OF odlg1 PIXEL

	@ 40, 420 Say OemToAnsi("Tp Carga: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 453  MsGet oTpCarg  Var ctpCarg    Size 55,10   When .F. OF odlg1 PIXEL

	@ aPosObj[1,1]+26 ,aPosObj[1,2]+0.5 TO aPosObj[1,3]-9.5,aPosObj[1,4]-1 OF odlg1 PIXEL Label "Pedidos"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "TRB".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB"," ","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+35 ,aPosObj[1,2]+5 ,aPosObj[1,3]-11,aPosObj[1,4]-2},,,,,aCores)
	/*		oMark:bMark := {| | fa060disp(cMarca,lInverte,1)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } */

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

	If nOpca == 1

		lFatPed := .F. 
		DbSelectArea("ZZR" )
		DbSetOrder(1)
		DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

			If ZZR->ZZR_STAFAT == "F"
				lFatPed := .T. 
			EndIf    
			DbSkip()
		End

		If lFatPed
			MsgStop("Romaneio possui pedidos faturado")
			Return     
		EndIf

		cEmpEst := GetMv("MV_XEMPEST")

		aArqDest := { "SB2" }

		For nX := 1 to Len(aArqDest)

			//Abro os Arquivos nas respectivas empresas
			cArqVar := aArqDest[nX]+cEmpEst+"0"

			DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

			If Select( cArqVar ) > 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ira fazer a abertura do Indice da Tabela ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


		If ZZQ->ZZQ_STATUS == "B"

			DbSelectArea("ZZR" )
			DbSetOrder(1)
			DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

			While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

				If ZZR->ZZR_EMP == SM0->M0_CODIGO 

					DbSelectArea("SC9")
					DbSetOrder(1)
					If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

						While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

							DbSelectArea("SC5")
							DbSetOrder(1)
							DbSeek(xFilial('SC5')+SC9->C9_PEDIDO )
							RecLock('SC5',.F.)
							SC5->C5_STAPED  := "D"
							SC5->C5_ROMANEI := " "
							SC5->C5_TRANSP  := " "
							MsUnlock()

							DbSelectArea("SC9")
							RecLock('SC9',,.F.)
							SC9->C9_ROMANEI := ' '
							SC9->C9_TRAROM  := ' '
							SC9->C9_EMIROM  := Ctod(' ') 
							SC9->C9_ORDCARG := ' '  
							SC9->C9_TIPOVEI :=' '  
							SC9->C9_DTCARRE := Ctod(' ')
							MsUnlock()
							DbSkip()

						End

					EndIf 

				Else

					aArqDest := { "SC9","SC5","SC6" }
					cEmpLib  := ZZR->ZZR_EMP

					For nX := 1 to Len(aArqDest)

						//Abro os Arquivos nas respectivas empresas
						cArqVar := aArqDest[nX]+cEmpLib+"0"

						DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

						If Select( cArqVar ) > 0

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Ira fazer a abertura do Indice da Tabela ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SIX->(DbSeek(aArqDest[nX]))
							While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
								DbSetIndex(cArqVar+SIX->ORDEM)
								SIX->(DbSkip())
							End
							DbSetOrder(1)

						EndIf

					Next

					//Crio a Variavel para selecionar o arquivo correspondente

					cArqSC9 := "SC9"+cEmpLib+"0"
					cArqSC5 := "SC5"+cEmpLib+"0"
					cArqSC6 := "SC6"+cEmpLib+"0"

					DbSelectArea(cArqSC9)
					DbSetOrder(1)
					If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

						While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

							DbSelectArea(cArqSC5)
							DbSetOrder(1)
							DbSeek(xFilial('SC5')+(cArqSC9)->C9_PEDIDO )
							RecLock(cArqSC5,.F.)
							(cArqSC5)->C5_STAPED  := "D"
							(cArqSC5)->C5_ROMANEI := " "
							(cArqSC5)->C5_TRANSP  := " "
							MsUnlock()

							DbSelectArea(cArqSC9)
							RecLock(cArqSC9,,.F.)
							(cArqSC9)->C9_ROMANEI := ' '
							(cArqSC9)->C9_TRAROM  := ' '
							(cArqSC9)->C9_EMIROM  := Ctod(' ') 
							(cArqSC9)->C9_ORDCARG := ' '  
							(cArqSC9)->C9_TIPOVEI :=' '  
							(cArqSC9)->C9_DTCARRE := Ctod(' ')
							MsUnlock()
							DbSkip()


						End

					EndIf 

					(cArqSC9)->(DbCloseArea())
					(cArqSC5)->(DbCloseArea())
					(cArqSC6)->(DbCloseArea())

				EndIf    

				DbSelectArea("ZZR")
				DbSkip()

			End 

		Else

			DbSelectArea("ZZR" )
			DbSetOrder(1)
			DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

			While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == ZZQ->ZZQ_ROMANE 

				If ZZR->ZZR_EMP == SM0->M0_CODIGO 

					DbSelectArea("SC9")
					DbSetOrder(1)
					If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

						While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

							DbSelectArea("SC5")
							DbSetOrder(1)
							DbSeek(xFilial('SC5')+SC9->C9_PEDIDO )
							RecLock('SC5',.F.)
							SC5->C5_STAPED  := "D"
							SC5->C5_ROMANEI := " "
							SC5->C5_TRANSP  := " "
							MsUnlock()

							DbSelectArea("SC6")
							DbSetOrder(1)
							DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
							Reclock("SC6",.F.)
							SC6->C6_QTDLIB := 0
							SC6->C6_QTDEMP := 0
							SC6->C6_QTDEMP2 := 0
							MsUnlock()

							DbSelectArea(cArqSB2)
							DbSetOrder(1)
							DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

							RecLock(cArqSB2,.F.)
							(cArqSB2)->B2_RESERVA -= SC9->C9_QTDLIB 
							MsUnlock()

							DbSelectArea("SC9")
							RecLock('SC9',,.F.)
							SC9->C9_BLEST := "02"
							SC9->C9_ROMANEI := ' '
							SC9->C9_TRAROM  := ' '
							SC9->C9_EMIROM  := Ctod(' ') 
							SC9->C9_ORDCARG := ' '  
							SC9->C9_TIPOVEI :=' '  
							SC9->C9_DTCARRE := Ctod(' ')
							MsUnlock()
							DbSkip()

						End

					EndIf 

				Else

					aArqDest := { "SC9","SC5","SC6" }
					cEmpLib  := ZZR->ZZR_EMP

					For nX := 1 to Len(aArqDest)

						//Abro os Arquivos nas respectivas empresas
						cArqVar := aArqDest[nX]+cEmpLib+"0"

						DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

						If Select( cArqVar ) > 0

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Ira fazer a abertura do Indice da Tabela ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SIX->(DbSeek(aArqDest[nX]))
							While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
								DbSetIndex(cArqVar+SIX->ORDEM)
								SIX->(DbSkip())
							End
							DbSetOrder(1)

						EndIf

					Next

					//Crio a Variavel para selecionar o arquivo correspondente

					cArqSC9 := "SC9"+cEmpLib+"0"
					cArqSC5 := "SC5"+cEmpLib+"0"
					cArqSC6 := "SC6"+cEmpLib+"0"

					DbSelectArea(cArqSC9)
					DbSetOrder(1)
					If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

						While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

							DbSelectArea(cArqSC5)
							DbSetOrder(1)
							DbSeek(xFilial('SC5')+(cArqSC9)->C9_PEDIDO )
							RecLock(cArqSC5,.F.)
							(cArqSC5)->C5_STAPED  := "D"
							(cArqSC5)->C5_ROMANEI := " "
							(cArqSC5)->C5_TRANSP  := " "
							MsUnlock()

							DbSelectArea(cArqSC6)
							DbSetOrder(1)
							DbSeek(xFilial("SC6")+(cArqSC9)->C9_PEDIDO+(cArqSC9)->C9_ITEM )
							Reclock(cArqSC6,.F.)
							(cArqSC6)->C6_QTDLIB := 0
							(cArqSC6)->C6_QTDEMP := 0
							(cArqSC6)->C6_QTDEMP2 := 0
							MsUnlock()

							DbSelectArea(cArqSB2)
							DbSetOrder(1)
							DbSeek(xFilial("SB2")+(cArqSC9)->C9_PRODUTO+(cArqSC9)->C9_LOCAL )

							RecLock(cArqSB2,.F.)
							(cArqSB2)->B2_RESERVA -= (cArqSC9)->C9_QTDLIB 
							MsUnlock()

							DbSelectArea(cArqSC9)
							RecLock(cArqSC9,,.F.)
							(cArqSC9)->C9_BLEST := "02"
							(cArqSC9)->C9_ROMANEI := ' '
							(cArqSC9)->C9_TRAROM  := ' '
							(cArqSC9)->C9_EMIROM  := Ctod(' ') 
							(cArqSC9)->C9_ORDCARG := ' '  
							(cArqSC9)->C9_TIPOVEI :=' '  
							(cArqSC9)->C9_DTCARRE := Ctod(' ')
							MsUnlock()
							DbSkip()


						End

					EndIf 

					(cArqSC9)->(DbCloseArea())
					(cArqSC5)->(DbCloseArea())
					(cArqSC6)->(DbCloseArea())

				EndIf    

				DbSelectArea("ZZR")
				DbSkip()

			End 


		EndIf        

		aEmp := {}

		DbSelectArea("ZZR")
		DbSetOrder(1)
		If DbSeek(xFilial("ZZR")+cRomaneio )

			While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == cRomaneio 

				nPesq := Ascan(aEmp,ZZR->ZZR_EMP )
				If nPesq == 0 
					Aadd(aEmp,ZZR->ZZR_EMP )
				EndIf 

				RecLock("ZZR",.F.)
				ZZR->(DbDelete())   
				MsUnlock()

				DbSkip()
			End

		EndIf

		DbSelectArea("ZZQ")
		DbSetOrder(1)
		If DbSeek(xFilial("ZZQ")+cRomaneio )

			RecLock("ZZQ",.F.)
			ZZQ->(DbDelete())   
			MsUnlock()

		EndIf

		For nX := 1 to Len(aEmp)

			If Select("QRYPED") > 0
				QRYPED->(DbCloseArea())
			EndIf

			cArq := "SC5"+aEmp[nX]+"0"

			//Verifico se tem pedido de palete para ser excluido 
			cQryPed := "SELECT C5_NUM FROM "+cArq
			cQryPed += " WHERE D_E_L_E_T_='' and C5_ROMANEI='"+ cRomaneio +"' and C5_FILIAL='" + xFilial("SC5") + "' "
			cQryPed += " AND C5_ZZTIPO = 'L' "

			cQryPed := ChangeQuery( cQryPed )
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryPed), "QRYPED", .F., .T. )

			DbSelectArea("QRYPED")
			DbGoTop()

			While QRYPED->(!Eof())

				cArq := "SC5"+aEmp[nX]+"0"

				cPedido := QRYPED->C5_NUM 

				// Atualiza dados do pedido de venda 
				//-------------------------------------------------------------------------------------
				cQuery2 := " DELETE FROM " + cArq 
				cQuery2 += " Where D_E_L_E_T_='' and C5_NUM='"+ cPedido +"' and C5_FILIAL='" + xFilial("SC5") + "' "

				If (TCSQLExec(cQuery2) < 0)
					Return MsgStop("Falha na atualizacao do Pedido. TCSQLError:"+ TCSQLError())
				EndIf

				cArq := "SC6"+aEmp[nX]+"0"  
				// Deletando os itens do pedido de venda 
				//-------------------------------------------------------------------------------------
				cQuery2 := " DELETE FROM " + cArq 
				cQuery2 += " Where D_E_L_E_T_='' and C6_NUM='"+ cPedido +"' and C6_FILIAL='" + xFilial("SC6") + "' "

				If (TCSQLExec(cQuery2) < 0)
					Return MsgStop("Falha na atualizacao do Pedido.  TCSQLError:"+ TCSQLError())
				EndIf

				cArq := "SC9"+aEmp[nX]+"0"  
				// Deletando os itens do pedido de venda 
				//-------------------------------------------------------------------------------------
				cQuery2 := " DELETE FROM " + cArq 
				cQuery2 += " Where D_E_L_E_T_='' and C9_PEDIDO='"+ cPedido +"' and C9_FILIAL='" + xFilial("SC9") + "' "

				If (TCSQLExec(cQuery2) < 0)
					Return MsgStop("Falha na atualizacao do Pedido. TCSQLError:"+ TCSQLError())
				EndIf

				DbSelectArea("QRYPED")
				DbSkip()

			End

			QRYPED->(DbCloseArea())

		Next 

		(cArqSB2)->(DbCloseArea())		
		MsgInfo("Romaneio excluido com sucesso...")

	EndIf 

Return 

/*/

Inclui Pedido de venda no romaneio 

/*/
User Function POMSA04I()
	Local cNumPed := Space(6)
	Local oDlgProc, oNumPed
	Local aArea := GetArea()

	If ZZQ->ZZQ_STATUS == "F"
		MsgStop("Romaneio ja faturado.")
		Return
	EndIf 

	nOpca := 0

	While .T.


		DEFINE MSDIALOG oDlgProc TITLE "Pedido" From 9,0 To 18,40 OF oMainWnd

		@ 5,3 to 41,145 of oDlgProc PIXEL

		@ 15,5 Say "Num Ped: " Size 50,10  of oDlgProc Pixel
		@ 13,45 MSGet oNumPed Var cNumPed F3 "SC5" Size 40 ,10 of oDlgProc Pixel

		@ 50, 90 BUTTON "OK"     Size 20,10  Action {||nOpca := 1,oDlgProc:End()} of oDlgProc Pixel
		@ 50,120 BUTTON "Cancel" Size 20,10  Action {||nOpca := 2,oDlgProc:End()} of oDlgProc Pixel

		ACTIVATE MSDIALOG oDlgProc Centered

		If nOpca == 1

			If !Empty(cNumPed)

				cNumPed := StrZero(Val(cNumPed),6 )

				DbSelectArea("SC5")
				DbSetOrder(1)
				If ! DbSeek(xFilial("SC5")+cNumPed )
					MsgStop("Pedido nao cadastrado.Verifique se o pedido pertence a esta empresa.")
				Else
					If SC5->C5_STAPED $ "T"
						MsgStop("Pedido ja se encontra em Romaneio "+SC5->C5_ROMANEI )
					ElseIf SC5->C5_STAPED $ "F"   
						MsgStop("Pedido ja se encontra faturado " )
					ElseIf ! SC5->C5_STAPED $ "D"   
						MsgStop("Pedido nao pode ser incluido no romaneio " )
					Else 

						// Incluindo o pedido

						DbSelectArea("ZZR") 
						DbSetOrder(2)
						If DbSeek(xFilial("ZZR")+SM0->M0_CODIGO+SC5->C5_NUM ) 
							MsgStop("Pedido ja se encontra em Romaneio") 

						Else  

							IncPedRom( )

						EndIf  
					EndIf 

				EndIf 

			EndIf

			MsgInfo("Inclusao do Pedido efetuada com sucesso" )

			cNumPed := Space(6)

		Else
			Exit
		EndIf
	End

	RestArea(aArea)

Return 

/*/

Retira Pedido de venda no romaneio 

/*/
User Function POMSA04P()
	Local aSize     := MsAdvSize(.T.)
	Local aObjects:={},aInfo:={},aPosObj:={}

	Local aInfo   :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	If ZZQ->ZZQ_STATUS == "F"
		MsgStop("Romaneio ja faturado.")
		Return
	EndIf 

	Private aCampos := {}

	AADD(aCampos,{ "OK"       ,"C",02,0 } )
	AADD(aCampos,{ "EMP"      ,"C",02,0 } )
	AADD(aCampos,{ "NOMEMP"   ,"C",20,0 } )
	AADD(aCampos,{ "PEDIDO"   ,"C",06,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C", 6,0 } )
	AADD(aCampos,{ "LOJA"     ,"C", 2,0 } )
	AADD(aCampos,{ "NOME"     ,"C",40,0 } )	
	AADD(aCampos,{ "NF"       ,"C", 6,0 } )
	AADD(aCampos,{ "SERIE"    ,"C", 3,0 } )
	AADD(aCampos,{ "STATUS"   ,"C", 1,0 } )	
	AADD(aCampos,{ "ZONA"     ,"C", 6,0 } )
	AADD(aCampos,{ "DESZONA"  ,"C",40,0 } )	
	AADD(aCampos,{ "PESO"     ,"N", 8,0 } )
	AADD(aCampos,{ "QTDPED"   ,"N", 8,0 } )
	AADD(aCampos,{ "VLRPED"   ,"N",15,2 } )		
	AADD(aCampos,{ "ENTREG"   ,"D", 8,0 } )
	AADD(aCampos,{ "QTDPAL"   ,"N", 3,0 } )
	AADD(aCampos,{ "DTAGEN"   ,"D", 8,0 } )

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq  := CriaTrab(aCampos)
	dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"EMP+PEDIDO",,,OemToAnsi("Selecionando Registros..."))	//

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	ProcRegua(RecCount())

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		DbSelectArea('TRB')
		RecLock("TRB",.T.)
		TRB->EMP     := ZZR->ZZR_EMP   
		TRB->NOMEMP  := ""
		TRB->PEDIDO  := ZZR->ZZR_PEDIDO 
		TRB->CLIENTE := ZZR->ZZR_CLIENTE
		TRB->LOJA    := ZZR->ZZR_LOJA
		TRB->NOME    := ZZR->ZZR_NOME	
		TRB->NF      := ZZR->ZZR_NOTA
		TRB->SERIE   := ZZR->ZZR_SERIE
		TRB->ZONA    := ZZR->ZZR_ZONA
		TRB->DESZONA := ZZR->ZZR_DESZONA
		TRB->STATUS  := ZZR->ZZR_STAFAT 
		TRB->PESO    := ZZR->ZZR_PESO
		TRB->QTDPED  := ZZR->ZZR_QTDPED 
		TRB->VLRPED  := ZZR->ZZR_VLRPED
		TRB->DTAGEN  := ZZR->ZZR_DTAGEN
		TRB->QTDPAL  := ZZR->ZZR_QTDPAL
		TRB->ENTREG  := ZZR->ZZR_ENTREG 	
		MsUnlock()

		DbSelectArea("ZZR")
		DbSkip()

	End  

	Private oTransp,oDescTra,oRomaneio
	Private oTpCarg,oPeso,oTpVeic,	oDesVei,oDtCarre 

	cTransp   := ZZQ->ZZQ_TRANSP
	cDescTra  := ZZQ->ZZQ_DESTRA
	cRomaneio := ZZQ->ZZQ_ROMANE

	cTpCarg   := If( ZZQ->ZZQ_TPCARG=="1","Batida","Paletizada" ) 
	nPeso     := ZZQ->ZZQ_PESO 
	cTpVeic   := ZZQ->ZZQ_TPVEIC
	cDesVei   := ZZQ->ZZQ_DESVEI 

	dDtCarre  := ZZQ->ZZQ_DTCARR

	DbSelectArea("TRB")
	DbGoTop()

	cMarca  := GetMark()

	aBrowse := {}

	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"PEDIDO","","Pedido"})
	AaDD(aBrowse,{"CLIENTE","","Cliente"})
	AaDD(aBrowse,{"LOJA","","Loja"})
	AaDD(aBrowse,{"NOME","","Nome"})
	AaDD(aBrowse,{"NF","","N.Fiscal"})
	AaDD(aBrowse,{"SERIE","","Serie"})
	AaDD(aBrowse,{"ZONA","","Zona"})
	AaDD(aBrowse,{"DESZONA","","Descricao"})
	AaDD(aBrowse,{ "PESO"   ,"","Peso","@e 99,999,999"})
	AaDD(aBrowse,{ "QTDPED" ,"","Qtd Cxs","@e 99,999,999"})
	AaDD(aBrowse,{ "VLRPED" ,"","Vlr Pedido","@e 99,999,999.99"})		
	AaDD(aBrowse,{ "ENTREG" ,"","Dt Entrega"})
	AaDD(aBrowse,{ "QTDPAL" ,"","Qtd Pallet","@e 9,999"})
	AaDD(aBrowse,{ "DTAGEN" ,"","Dt Agenda"})

	AADD(aObjects,{ 10,05,.T.,.T.})

	aCores := {}

	//	Aadd(aCores, { 'OPER = "08"', "BR_PRETO" } )
	Aadd(aCores, { 'STATUS = "F" ', "DISABLE" } )
	Aadd(aCores, { 'STATUS = " " ', "ENABLE" } )
	//	Aadd(aCores, { 'LIBPED = "O" ', "BR_CINZA" } )
	//	Aadd(aCores, { '!Empty(OBSINT) .Or. !Empty(OBSEXT)', "BR_VIOLETA" } )	

	nOpca   :=0
	lInverte := .F.

	aPosObj:=MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Retira pedido do Romaneio " From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 15,05 TO 55,670 OF odlg1 PIXEL  

	@ 20, 20 Say OemToAnsi("Romaneio: ") Size 70,8  OF odlg1 PIXEL
	@ 18, 63  MsGet oRomaneio  Var cRomaneio   Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 120 Say OemToAnsi("Transportadora : ") Size 70,8  OF odlg1 PIXEL
	@ 18, 163  MsGet oTransp  Var cTransp  Valid ChkTransp() F3 "SA4" Size 45,10   When .F. OF odlg1 PIXEL 

	@ 20, 220 Say OemToAnsi("Nome: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 253  MsGet oDescTra   Var cDescTra   Size 145,10   When .F. OF odlg1 PIXEL

	@ 20, 420 Say OemToAnsi("Dt Carreg: ") Size 50,8  OF odlg1 PIXEL
	@ 18, 453  MsGet oDtCarre  Var dDtCarre   Size 55,10   When .F. OF odlg1 PIXEL

	@ 40, 20 Say OemToAnsi("Tp Veic.: ") Size 70,8  OF odlg1 PIXEL
	@ 38, 63  MsGet oTpVeic    Var cTpVeic     Size 45,10   When .F. OF odlg1 PIXEL 

	@ 40, 120 Say OemToAnsi("Descricao : ") Size 70,8  OF odlg1 PIXEL
	@ 38, 163  MsGet oDesVei  Var cDesVei   Size 145,10   When .F. OF odlg1 PIXEL 

	@ 40, 320 Say OemToAnsi("Peso: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 343  MsGet oPeso   Var nPeso Picture "@e 99999999"   Size 65,10   When .F. OF odlg1 PIXEL

	@ 40, 420 Say OemToAnsi("Tp Carga: ") Size 50,8  OF odlg1 PIXEL
	@ 38, 453  MsGet oTpCarg  Var ctpCarg    Size 55,10   When .F. OF odlg1 PIXEL

	@ aPosObj[1,1]+26 ,aPosObj[1,2]+0.5 TO aPosObj[1,3]-9.5,aPosObj[1,4]-1 OF odlg1 PIXEL Label "Pedidos"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "TRB".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB","OK","",aBrowse,@lInverte,@cMarca,{aPosObj[1,1]+35 ,aPosObj[1,2]+5 ,aPosObj[1,3]-11,aPosObj[1,4]-2},,,,,aCores)
	oMark:bMark := {| | fa060disp(cMarca,lInverte,2)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) } 

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||nOpca := 2,oDlg1:End()},.F.,1) centered

	If nOpca ==  1 

		DbSelectArea("TRB")
		DbGotop()

		While TRB->(!Eof())

			If Empty(TRB->OK)
				DbSkip()
				Loop
			EndIf 

			RetPedRom(TRB->PEDIDO,TRB->EMP )

			DbSelectArea("TRB")
			DbSkip()

		End 

	EndIf 

Return 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Escola Graduada                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Disp(cMarca,lInverte,nModo)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf

	If nModo == 2  

		If TRB->STATUS == "F"

			MsgStop("Pedido faturado nao pode ser retirado do Romaneio")

			DbSelectArea("TRB")
			RecLock("TRB",.F.) 
			TRB->OK := Space(2)
			MsUnlock()

			oMark:oBrowse:Refresh(.t.)
			DlgRefresh(oDlg1)
			Return

		EndIf

		Return   

	EndIf 

	oMark:oBrowse:Refresh(.t.)
	DlgRefresh(oDlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EGF003    ºAutor  ³Microsiga           º Data ³  02/19/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

/*/

Retira o pedido efetivamente do Romaneio

/*/

Static Function RetPedRom(cPedido,cEmp ) 		

	cEmpEst := GetMv("MV_XEMPEST")

	aArqDest := { "SB2" }

	For nX := 1 to Len(aArqDest)

		//Abro os Arquivos nas respectivas empresas
		cArqVar := aArqDest[nX]+cEmpEst+"0"

		DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

		If Select( cArqVar ) > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ira fazer a abertura do Indice da Tabela ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


	If ZZQ->ZZQ_STATUS == "B"

		DbSelectArea("ZZR" )
		DbSetOrder(2)
		DbSeek(xFilial("ZZR")+cEmp+cPedido )

		While ZZR->(!Eof()) .And. ZZR->ZZR_PEDIDO == cPedido .And. ZZR->ZZR_EMP == cEmp  

			If ZZR->ZZR_EMP == SM0->M0_CODIGO 

				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(xFilial('SC5')+SC9->C9_PEDIDO )
						RecLock('SC5',.F.)
						SC5->C5_STAPED  := "D"
						SC5->C5_ROMANEI := " "
						SC5->C5_TRANSP  := " "
						MsUnlock()

						DbSelectArea("SC9")
						RecLock('SC9',,.F.)
						SC9->C9_ROMANEI := ' '
						SC9->C9_TRAROM  := ' '
						SC9->C9_EMIROM  := Ctod(' ') 
						SC9->C9_ORDCARG := ' '  
						SC9->C9_TIPOVEI :=' '  
						SC9->C9_DTCARRE := Ctod(' ')
						MsUnlock()
						DbSkip()

					End

				EndIf 

			Else

				aArqDest := { "SC9","SC5","SC6" }
				cEmpLib  := ZZR->ZZR_EMP

				For nX := 1 to Len(aArqDest)

					//Abro os Arquivos nas respectivas empresas
					cArqVar := aArqDest[nX]+cEmpLib+"0"

					DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

					If Select( cArqVar ) > 0

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ira fazer a abertura do Indice da Tabela ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SIX->(DbSeek(aArqDest[nX]))
						While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
							DbSetIndex(cArqVar+SIX->ORDEM)
							SIX->(DbSkip())
						End
						DbSetOrder(1)

					EndIf

				Next

				//Crio a Variavel para selecionar o arquivo correspondente

				cArqSC9 := "SC9"+cEmpLib+"0"
				cArqSC5 := "SC5"+cEmpLib+"0"
				cArqSC6 := "SC6"+cEmpLib+"0"

				DbSelectArea(cArqSC9)
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						DbSelectArea(cArqSC5)
						DbSetOrder(1)
						DbSeek(xFilial('SC5')+(cArqSC9)->C9_PEDIDO )
						RecLock(cArqSC5,.F.)
						(cArqSC5)->C5_STAPED  := "D"
						(cArqSC5)->C5_ROMANEI := " "
						(cArqSC5)->C5_TRANSP  := " "
						MsUnlock()

						DbSelectArea(cArqSC9)
						RecLock(cArqSC9,,.F.)
						(cArqSC9)->C9_ROMANEI := ' '
						(cArqSC9)->C9_TRAROM  := ' '
						(cArqSC9)->C9_EMIROM  := Ctod(' ') 
						(cArqSC9)->C9_ORDCARG := ' '  
						(cArqSC9)->C9_TIPOVEI :=' '  
						(cArqSC9)->C9_DTCARRE := Ctod(' ')
						MsUnlock()
						DbSkip()


					End

				EndIf 

				(cArqSC9)->(DbCloseArea())
				(cArqSC5)->(DbCloseArea())
				(cArqSC6)->(DbCloseArea())

			EndIf    

			DbSelectArea("ZZR")
			RecLock("ZZR",.F.)
			ZZR->(DbDelete())
			MsUnLock()
			DbSkip()

		End 

	Else

		DbSelectArea("ZZR" )
		DbSetOrder(2)
		DbSeek(xFilial("ZZR")+cEmp+cPedido )

		While ZZR->(!Eof()) .And. ZZR->ZZR_PEDIDO == cPedido .And. ZZR->ZZR_EMP == cEmp  

			If ZZR->ZZR_EMP == SM0->M0_CODIGO 

				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While SC9->(!Eof()) .And. SC9->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(xFilial('SC5')+SC9->C9_PEDIDO )
						RecLock('SC5',.F.)
						SC5->C5_STAPED  := "D"
						SC5->C5_ROMANEI := " "
						SC5->C5_TRANSP  := " "
						MsUnlock()

						DbSelectArea("SC6")
						DbSetOrder(1)
						DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
						Reclock("SC6",.F.)
						SC6->C6_QTDLIB := 0
						SC6->C6_QTDEMP := 0
						SC6->C6_QTDEMP2 := 0
						MsUnlock()

						DbSelectArea(cArqSB2)
						DbSetOrder(1)
						DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )

						RecLock(cArqSB2,.F.)
						(cArqSB2)->B2_RESERVA -= SC9->C9_QTDLIB 
						MsUnlock()

						DbSelectArea("SC9")
						RecLock('SC9',,.F.)
						SC9->C9_BLEST := "02"
						SC9->C9_ROMANEI := ' '
						SC9->C9_TRAROM  := ' '
						SC9->C9_EMIROM  := Ctod(' ') 
						SC9->C9_ORDCARG := ' '  
						SC9->C9_TIPOVEI :=' '  
						SC9->C9_DTCARRE := Ctod(' ')
						MsUnlock()
						DbSkip()

					End

				EndIf 

			Else

				aArqDest := { "SC9","SC5","SC6" }
				cEmpLib  := ZZR->ZZR_EMP

				For nX := 1 to Len(aArqDest)

					//Abro os Arquivos nas respectivas empresas
					cArqVar := aArqDest[nX]+cEmpLib+"0"

					DbUseArea(.T.,"TOPCONN",cArqVar,cArqVar,.T.,.F.)

					If Select( cArqVar ) > 0

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ira fazer a abertura do Indice da Tabela ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SIX->(DbSeek(aArqDest[nX]))
						While SIX->INDICE == aArqDest[nX] .And. SIX->(!Eof())
							DbSetIndex(cArqVar+SIX->ORDEM)
							SIX->(DbSkip())
						End
						DbSetOrder(1)

					EndIf

				Next

				//Crio a Variavel para selecionar o arquivo correspondente

				cArqSC9 := "SC9"+cEmpLib+"0"
				cArqSC5 := "SC5"+cEmpLib+"0"
				cArqSC6 := "SC6"+cEmpLib+"0"

				DbSelectArea(cArqSC9)
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+ZZR->ZZR_PEDIDO )

					While (cArqSC9)->(!Eof()) .And. (cArqSC9)->C9_PEDIDO == ZZR->ZZR_PEDIDO  

						DbSelectArea(cArqSC5)
						DbSetOrder(1)
						DbSeek(xFilial('SC5')+(cArqSC9)->C9_PEDIDO )
						RecLock(cArqSC5,.F.)
						(cArqSC5)->C5_STAPED  := "D"
						(cArqSC5)->C5_ROMANEI := " "
						(cArqSC5)->C5_TRANSP  := " "
						MsUnlock()

						DbSelectArea(cArqSC6)
						DbSetOrder(1)
						DbSeek(xFilial("SC6")+(cArqSC9)->C9_PEDIDO+(cArqSC9)->C9_ITEM )
						Reclock(cArqSC6,.F.)
						(cArqSC6)->C6_QTDLIB := 0
						(cArqSC6)->C6_QTDEMP := 0
						(cArqSC6)->C6_QTDEMP2 := 0
						MsUnlock()

						DbSelectArea(cArqSB2)
						DbSetOrder(1)
						DbSeek(xFilial("SB2")+(cArqSC9)->C9_PRODUTO+(cArqSC9)->C9_LOCAL )

						RecLock(cArqSB2,.F.)
						(cArqSB2)->B2_RESERVA -= (cArqSC9)->C9_QTDLIB 
						MsUnlock()

						DbSelectArea(cArqSC9)
						RecLock(cArqSC9,,.F.)
						(cArqSC9)->C9_BLEST := "02"
						(cArqSC9)->C9_ROMANEI := ' '
						(cArqSC9)->C9_TRAROM  := ' '
						(cArqSC9)->C9_EMIROM  := Ctod(' ') 
						(cArqSC9)->C9_ORDCARG := ' '  
						(cArqSC9)->C9_TIPOVEI :=' '  
						(cArqSC9)->C9_DTCARRE := Ctod(' ')
						MsUnlock()
						DbSkip()


					End

				EndIf 

				(cArqSC9)->(DbCloseArea())
				(cArqSC5)->(DbCloseArea())
				(cArqSC6)->(DbCloseArea())

			EndIf    

			DbSelectArea("ZZR")
			RecLock("ZZR",.F.)
			ZZR->(DbDelete())
			MsUnlock()
			DbSkip()

		End 


	EndIf        

	nPeso := nTotCxs := nVlrRom := 0

	DbSelectArea("ZZR")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZR")+cRomaneio )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == cRomaneio 

			nPeso    += ZZR->ZZR_PESO 
			nTotCxs  += ZZR->ZZR_QTDPED
			nVlrRom  += ZZR->ZZR_VLRPED  

			DbSkip()
		End

	EndIf

	DbSelectArea("ZZQ")
	RecLock("ZZQ",.F.)
	ZZQ->ZZQ_PESO   := nPeso
	ZZQ->ZZQ_QTDCXS := nTotCxs 
	ZZQ->ZZQ_VLRROM := nVlrRom 
	MsUnlock()

	(cArqSB2)->(DbCloseArea())		

	MsgInfo("Pedido retirado com sucesso...")

Return 

/*/

Incluindo o pedido no Romaneio 

/*/
Static Function IncPedRom()
	Local nPesPed := 0
	Local nQtdPall := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SC5->C5_NUM )

	While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM 

		nCxsPal := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_QTDPALL" )

		nPesPrd := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESBRU" )

		nPesPed += SC6->C6_QTDVEN * nPesPrd 

		nQtdPall += Int(SC6->C6_QTDVEN / nCxsPal )

		DbSkip()

	End 

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial('SC9')+SC5->C5_NUM )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM 

		DbSelectArea("SC9")
		RecLock('SC9',,.F.)
		SC9->C9_BLEST   := " "
		SC9->C9_ROMANEI := ZZQ->ZZQ_ROMANE 
		SC9->C9_TRAROM  := ZZQ->ZZQ_TRANSP 
		SC9->C9_EMIROM  := ZZQ->ZZQ_EMIROM 
		SC9->C9_ORDCARG := ' '  
		SC9->C9_TIPOVEI := ZZQ->ZZQ_TPVEIC  
		SC9->C9_DTCARRE := ZZQ->ZZQ_DTCARR
		SC9->C9_TPCARRO := ZZQ->ZZQ_TPCARG
		MsUnlock()


		DbSelectArea("SC9")
		DbSkip()

	End 

	//Gravo os itens do Romaneio 
	DbSelectArea("ZZR")
	RecLock("ZZR",.T.)
	ZZR->ZZR_FILIAL  := xFilial("ZZR")
	ZZR->ZZR_EMP     := SM0->M0_CODIGO 
	ZZR->ZZR_ROMANE  := ZZQ->ZZQ_ROMANE 
	ZZR->ZZR_PEDIDO  := SC5->C5_NUM  
	ZZR->ZZR_CLIENTE := SC5->C5_CLIENTE
	ZZR->ZZR_LOJA    := SC5->C5_LOJACLI
	ZZR->ZZR_NOME    := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
	ZZR->ZZR_ZONA    := SC5->C5_ZONA 
	ZZR->ZZR_DESZONA := SC5->C5_DESZONA 
	ZZR->ZZR_PESO    := nPesPed 
	ZZR->ZZR_QTDPED  := SC5->C5_QTDPED
	ZZR->ZZR_DTAGEN  := SC5->C5_DTAGEN 
	ZZR->ZZR_ENTREG  := SC5->C5_FECENT 
	ZZR->ZZR_VLRPED  := SC5->C5_VLRPED  
	ZZR->ZZR_QTDPAL  := nQTDPALL
	MsUnlock()

	cRomaneio := ZZQ->ZZQ_ROMANE

	nPeso := nTotCxs := nVlrRom := 0

	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_STAPED  := "T"
	SC5->C5_ROMANEI := ZZQ->ZZQ_ROMANE 
	MsUnlock()

	DbSelectArea("ZZR")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZR")+cRomaneio )

		While ZZR->(!Eof()) .And. ZZR->ZZR_ROMANE == cRomaneio 

			nPeso    += ZZR->ZZR_PESO 
			nTotCxs  += ZZR->ZZR_QTDPED 
			nVlrRom  += ZZR->ZZR_VLRPED  

			DbSkip()
		End

	EndIf

	DbSelectArea("ZZQ")
	RecLock("ZZQ",.F.)
	ZZQ->ZZQ_PESO   := nPeso
	ZZQ->ZZQ_QTDCXS := nTotCxs 
	ZZQ->ZZQ_VLRROM := nVlrRom 
	MsUnlock()

Return 


/*/

Encerra romaneio 

/*/

User Function POMSA04F()

	If ZZQ->ZZQ_STATUS == "F"

		MsgStop("Romaneio ja encerrado")
		Return 

	EndIf

	If !MsgYesNo("Confirma o encerramento do Romaneio")
		Return
	EndIf 

	lFatPed := .T. 

	DbSelectArea("ZZR")
	DbSetOrder(1)
	DbSeek(xFilial("ZZR")+ZZQ->ZZQ_ROMANE )

	While ZZR->(!Eof()) .And. ZZQ->ZZQ_ROMANE == ZZR->ZZR_ROMANE 

		If ZZR->ZZR_STAFAT # "F"
			lFatPed := .F.
		EndIf   

		DbSkip()
	End 

	If lFatPed 

		DbSelectArea("ZZQ")
		RecLock("ZZQ",.F.)
		ZZQ->ZZQ_STATUS := "F"
		MsUnlock()

	Else

		MsgStop("Romaneio possui pedido em aberto. nao sera finalizado") 

	EndIf 

Return 


/*/

Acerta a data de carregamento no Romaneio

/*/
User Function POMSA04D()

	Local oDlgProc
	Local oCbx
	Local aArea := GetArea()

	cRomaneio := ZZQ->ZZQ_ROMANE

	If !MsgYesNo("Tem certeza que deseja alterar a Data de carregamento do romaneio "+cRomaneio )
		Return
	EndIf

	Private oDtCarre
	dDtCarre := ZZQ->ZZQ_DTCARR 

	DEFINE MSDIALOG oDlgProc TITLE "Data de Carregamento" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL Label "Data"

	@ 15, 40 MSGET oDtCarre VAR dDtCarre  Valid ChkDtCarre(@dDtCarre) SIZE 60, 10 OF oDlgProc PIXEL

	@ 50, 90 BMPBUTTON TYPE 1 Action Processa({||GravDtcarre(dDtCarre,oDlgProc)},"Alterando a Data de Carregamento" )
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	RestArea(aArea)


Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  03/17/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravDtCarre(dDtCarre,oDlgProc)

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

	ProcRegua(Len(aEmp))

	For nX := 1 to Len(aEmp)

		IncProc("Atualizando a empresa: "+aEmp[nX] )

		cArq := "SC9"+aEmp[nX]+"0"

		cQuery2 := " UPDATE " + cArq + " SET C9_DTCARRE = '"+Dtos(dDtCarre)+" ' "
		cQuery2 += " Where D_E_L_E_T_='' and C9_ROMANEI='"+ cRomaneio  +"' "

		If (TCSQLExec(cQuery2) < 0)
			Return MsgStop("Falha na atualizacao do Romaneio "+ cRomaneio + ".  TCSQLError:"+ TCSQLError())
		EndIf

	Next 

	DbSelectArea("ZZQ")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZQ")+cRomaneio )

		RecLock("ZZQ",.F.)
		ZZQ->ZZQ_DTCARR := dDtCarre 
		MsUnlock()

	EndIf

	MsgInfo("Data de carregamento alterada com sucesso...")

	Close(oDlgProc)

Return

/*/

Checa a data de carregamento 

/*/
Static Function ChkDtCarre(dDtCarre)

If dDtCarre < dDataBase 

   MsgStop("Data de Carregamento nao pode ser menor que a data Atual.")
   Return .F. 

EndIf 

Return .T. 