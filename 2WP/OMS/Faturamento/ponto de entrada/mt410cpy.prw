#Include "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410CPY  �Autor  �Carlos R Moreira    � Data �  01/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Limpa as variaveis de campos de usuario                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT410CPY()
Local aArea := GetArea()

M->C5_STAPED := " "
M->C5_USLIBC := " " 
M->C5_NOLIBC := " " 
M->C5_DTLIBC := Ctod("")
M->C5_HRLIBC := " " 
M->C5_USLIBM := " " 
M->C5_NOLIBM := " " 
M->C5_DTLIBM := Ctod("")
M->C5_HRLIBM := " " 
M->C5_USCUS  := " "
M->C5_NOMCUST := " " 
M->C5_DTLBCUS := Ctod("")
M->C5_HRLIBCU := " "
M->C5_USFAT   := " "
M->C5_NOFATUR := " "
M->C5_DTFAT   := Ctod("")
M->C5_HRFAT   := " "
M->C5_PEDBON  := " "
M->C5_DTLIBF  := Ctod("")
M->C5_HRLIBF  := " " 
M->C5_USLIBF  := " " 
M->C5_NOLIBF  := " "
M->C5_ROMANEI := " " 
M->C5_DTAGEN  := Ctod("")
M->C5_HRAGEN  := " "
M->C5_DTAGEN1  := Ctod("")
M->C5_HRAGEN2  := " "
M->C5_DTAGEN2  := Ctod("")
M->C5_HRAGEN3  := " "

RestArea(aArea)

Return