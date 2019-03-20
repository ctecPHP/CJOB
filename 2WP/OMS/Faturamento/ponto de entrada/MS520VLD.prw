#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2520E   � Autor � Jonas L. Souza Jr  � Data �  09/04/11   ���
�������������������������������������������������������������������������͹��
���Descricao � PE antes da exclusao da NF, para chamada de rotina de      ���
���          � estorno e exclusao de NCCs                                 ���
�������������������������������������������������������������������������͹��
���Uso       � GTex                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MS520VLD()
Local aArea := GetArea()
Local cPedido := Space(6)

If SM0->M0_CODIGO # "01" .And. !Empty(SF2->F2_DOC_INT)

   MsgInfo("Esta nota possui vinculo. Deve ser feita pela rotina de exclusao de nota especifica" )
   
   Return .f.  
   
EndIf 

//Alert("Estou no ponto de entrada ")
RestArea(aArea)

Return .T. 
