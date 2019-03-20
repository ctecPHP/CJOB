#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFINA02   ºAutor  ³Carlos R. Moreira   º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os Pedidos com Bloqueio de Credito                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFINA02()

	aIndexSC5  := {}

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Visualizar","A410Visual" , 0 , 1},;
	{ "Liberar"   ,"U_PFINA02A" , 0 , 2} }

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

	Private cCadastro := OemToAnsi("Bloqueio de credito")
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

User Function PFINA02A()
	Local oDlg2
	Private nRadio := 1
	Private oRadio
	Private cMotivo := Space(40)

	cUser := RetCodUsr()

    SA1->(DbSetOrder(1))
    SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ))
    
    nLimite  := SA1->A1_LC 
    dVencLim := SA1->A1_VENCLC 
    cRisco   := SA1->A1_RISCO 
    

    //Buscando o saldo tomado em titulos 
/*
    cQuery := "  SELECT SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1") 
    cQuery += "  WHERE DELET <> '*' AND E1_SALDO > 0 AND E1_TIPO # 'NCC' "   
    cQuery += "       AND E1_CLIENTE ='"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "  
        
	TCSQLExec(cQuery)

    MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")
 
   nLimTomado := 0
   
   While QRY->(!Eof())
   
      nLimTomado += QRY->SALDO 
       
      DbSkip()
      
   End 
   
   QRY->(DbCloseArea()) 
        
*/
	nOpca := 0

	While .T.

		DEFINE MSDIALOG oDlg2 TITLE "Liberacao Financeira" From 9,0 To 22,60 OF oMainWnd

		@ 05,05 TO 70, 80 TITLE "Liberar"
		@ 20,30 RADIO oRadio Var nRadio Items "Sim","Nao" 3D SIZE 60,10 of oDlg2 Pixel

		@ 05,85 TO 70,235 TITLE "Motivo"
		@ 23,90 MSGet cMotivo  Size 100 ,10  of oDlg2 Pixel 

		@ 082,110 BUTTON "&Ok"   SIZE 50,15 ACTION {||nOpca:=1,Close(oDlg2)} of oDlg2 Pixel
		@ 082,180 BUTTON "&Sair" SIZE 50,15 ACTION {||nOpca:=3,Close(oDlg2)} of oDlg2 Pixel

		ACTIVATE DIALOG oDlg2 CENTER

		If Empty(cMotivo) .And. nRadio == 1   
			MsgInfo("Deve ser informado o motivo")
            Loop 
		ElseIf nOpca == 3 .Or. !Empty(cMotivo)        
			Exit
		EndIf

	End

	If nOpca == 1

		If nRadio == 1

			cPedido := SC5->C5_NUM 

			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+cPedido  )
			
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

		EndIf

	EndIf 

Return

