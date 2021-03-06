#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpNFEnt  �Autor  �Carlos R. Moreira   � Data �  26/05/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o Centro de Custo do Tomador de Servicos          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AceSF2()


	If MsgYesNo("Deseja atualizar o SF2 ..")

		Processa({||ProcSF2()},"Gerando o SF2 .. ")

	EndIf

Return


Static Function ProcSF2()

	DbSelectArea("SF2")
	DbGoTop()

	ProcRegua(RecCount())

	While SF2->(!Eof())

        IncProc("Ajustando o arquivo SF2.. ")
        
        SD2->(DbSetOrder(3))
        SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE ))
        
        SC5->(DbSetOrder(1))
        SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))
        
     	DbSelectArea("SF2")
		RecLock("SF2",.F.)
		SF2->F2_ZZTIPO := SC5->C5_ZZTIPO  
		SF2->(MsUnLock())

		DbSelectArea("SF2")
		DbSkip()

	End

Return