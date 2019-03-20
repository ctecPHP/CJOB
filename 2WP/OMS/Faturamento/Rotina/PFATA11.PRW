#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA11   ºAutor  ³Carlos R. Moreira   º Data ³  05/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra os romaneio que estao em aberto liberar para         º±±
±±º          ³faturamento                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PFATA11()

	aIndexZZQ  := {}

	PRIVATE bFiltraBrw := {|| Nil}

	Private cCadastro := OemToAnsi("Libera romaneio para Faturamento")

	aRotina := { { "Pesquisar" ,"AxPesqui" , 0 , 4},;
	{ "Consultar","U_POMSA04C" , 0 , 1},;
	{"Liberar","U_PFATA11L", 0 , 2 , 0 , NIL},;	//
	{"Legenda","U_PFATA10Legenda", 0 , 0 , 0 , .F.}}		//

	//Ira checar se o usuario tem permissao para digitacao do Inventario
	Private cCodUsu := __cuserid

	aCores := { { " ZZQ_STATUS = 'L' "  , 'ENABLE' },;
	{ " ZZQ_STATUS = 'F'  " , 'DISABLE'  },;
	{ " ZZQ_STATUS = ' '" , 'BR_AZUL_CLARO'  },;
	{ " ZZQ_STATUS = 'O'" , 'BR_CINZA'  }}

 
	cFiltraZZQ := "ZZQ_STATUS = ' ' "

	bFiltraBrw 	:= {|| FilBrowse("ZZQ",@aIndexZZQ,@cFiltraZZQ) }
	Eval(bFiltraBrw)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"ZZQ",,,,,,aCores)//,,"C5_LIBEROK"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw("ZZQ",aIndexZZQ)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a condicao de Entrada                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZZQ")
	dbSetOrder(1)
	dbClearFilter()

Return

/*/

Muda o status do romaneio para que fique liberado 

/*/
User Function PFATA11L()

If ! MsgYesno("Confirma a liberacao do Romaneio")
   Return 
EndIF 

DbSelectArea("ZZQ")
RecLock("ZZQ",.F.)
ZZQ->ZZQ_STATUS := "L"
MsUnlock()   
   
MsgInfo("Romaneio: "+ZZQ->ZZQ_ROMANE+" Liberado com sucesso..")
      
Return 