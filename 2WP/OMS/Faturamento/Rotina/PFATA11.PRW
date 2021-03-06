#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFATA11   �Autor  �Carlos R. Moreira   � Data �  05/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtra os romaneio que estao em aberto liberar para         ���
���          �faturamento                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//����������������������������������������������������������Ŀ
	//� Endereca a funcao de BROWSE                              �
	//������������������������������������������������������������
	mBrowse( 6, 1,22,75,"ZZQ",,,,,,aCores)//,,"C5_LIBEROK"
	//������������������������������������������������������������������������Ŀ
	//� Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       �
	//��������������������������������������������������������������������������
	EndFilBrw("ZZQ",aIndexZZQ)
	//������������������������������������������������������������������������Ŀ
	//�Restaura a condicao de Entrada                                          �
	//��������������������������������������������������������������������������
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