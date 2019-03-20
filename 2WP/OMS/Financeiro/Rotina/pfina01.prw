#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFINA01   �Autor  �Microsiga           � Data �  10/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define a configuracao dos Banco em relacao a impressao    ���
���          � dos Boletos                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFINA01()

Local aCores :=	{{ ' EE_ZZBCDIA = " " ','ENABLE'    },;	//Bem sem Baixa
				 { ' EE_ZZBCDIA = "S"','DISABLE'   },;	//Baixa Legislacao
				 { ' EE_ZZBCDIA = "P"','BR_AZUL'	 }}		//Bem com baixa de Legislacao


Private cCadastro := "Selecao do Banco do Dia"

Private aRotina := MenuDef()

mBrowse( 6, 1,22,75,"SEE",,,,,,aCores)

Return                  

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �08/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()
Local aRotina := { 	{ OemToAnsi("Pesquisar")	  , "AxPesqui"	, 0 , 1},;  //
						{ OemToAnsi("Visualizar") , "AxVisual"	, 0 , 2},;  //
				   		{ OemToAnsi("Bco Dia")	  , "U_PFINA01DIA"	, 0 , 3},; //"Baixar" 
				   		{ OemToAnsi("Bco Pref.")  , "U_PFINA01PRE"	, 0 , 4},; //"Baixar"
				   		{ OemToAnsi("Lib Vinculo")  , "U_PFINA01VIN"	, 0 , 5},; //"Baixar"				   		
						{ OemToAnsi("Legenda")	  , "U_PFINA01LEG"	, 0 , 6, ,.F.} } //"Legenda"
Return(aRotina)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFINA01   �Autor  �Microsiga           � Data �  10/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o Banco do Dia                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFINA01DIA()
Local nRec := SEE->(Recno())

DbSelectArea("SEE")
DbGoTop()

While SEE->(!Eof())
   
   If SEE->EE_ZZBCDIA == "S"
      RecLock("SEE",.F.)
      SEE->EE_ZZBCDIA := " "
      MsUnlock()
   EndIf                
   DbSkip()
End

//Atribuo o Flag de Bco do dia Bco Selecionado
SEE->(DbGoTo(nRec))
RecLock("SEE",.F.)
SEE->EE_ZZBCDIA := "S"
//SEE->EE_DT_USO := dDataBase
MsUnlock()
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFINA01   �Autor  �Microsiga           � Data �  10/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o Banco Preferencial..                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFINA01PRE()
Local nRec := SEE->(Recno())

DbSelectArea("SEE")
DbGoTop()

While SEE->(!Eof())
   
   If SEE->EE_ZZBCDIA == "P"
      RecLock("SEE",.F.)
      SEE->EE_ZZBCDIA := " "
      MsUnlock()
   EndIf                
   DbSkip()

End

//Atribuo o Flag de Bco do dia Bco Selecionado
SEE->(DbGoTo(nRec))
RecLock("SEE",.F.)
SEE->EE_ZZBCDIA := "P"
//SEE->EE_DT_USO := dDataBase
MsUnlock()

Return/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFINA01   �Autor  �Microsiga           � Data �  10/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o Banco Preferencial..                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFINA01VIN()
Local nRec := SEE->(Recno())

//Atribuo o Flag de Bco do dia Bco Selecionado
SEE->(DbGoTo(nRec))
RecLock("SEE",.F.)
SEE->EE_ZZBCDIA := " "
MsUnlock()

Return



User Function PFINA01LEG() 

BrwLegenda("Definicao do Banco","Legenda",{	{"ENABLE","Banco sem vinculo"},; //"Legenda" //"Bem sem Baixa" 
	{"DISABLE",OemToAnsi("Banco do Dia")},; //"Baixa Legislacao"
	{"BR_AZUL",OemToAnsi("Banco Preferencial")}} ) //"Bem com baixa de Legislacao"

Return