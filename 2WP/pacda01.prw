#include "protheus.ch"
#include "TBICONN.ch"
#include "rwmake.ch"
#include "apvt100.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �   Autor � Elvis Kinuta �                          30/05/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de entrada no estoque Logistica                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PACDA01()  
	Local bkey05
	Local bkey09
	Local bkey24
	Local nYesNo  := 0

	Private cZzLote := Space(10)

	Private nQTD    := 0
	Private aProdCD := {}
	Private lMSErroAuto:= .F.
	Private cOP := space(Len(SH6->H6_OP))
	Private cTM := space(Len(SF5->F5_CODIGO))

	Private cCodBar := Space(15)


	//??CBChkTemplate()
	// -- Verifica se data do Protheus esta diferente da data do sistema.
	DLDataAtu()

	If IsTelnet() .AND.  VtModelo() == "RF"
		bKey05 := VTSetKey(05,{|| CB020Encer()}, "Encerrar")   // "Encerrar"
		bkey09 := VTSetKey(09,{|| AIV020Hist()}, "Informacao") //"Informacao"
		bKey24 := VTSetKey(24,{|| Estorna()}, "Estorno")   // CTRL+X //"Estorno"
	EndIf

	While .T.

		cOP := space(Len(SH6->H6_OP))
		nQTD:= 0
		cCodBar  := Space(15)
		cCodEtiq := Space(10)
		cDesPrd  := Space(30)

		VTCLEAR()
		cZzLote := Space(10)

		@ 0,0 vtSay "Produto:"
		@ 1,0 VTGET cCodBar  Valid chkProd() F3 "SB1" 

		@ 2,0 VTGET cDesPrd   WHEN .F.  

		@ 3,0 VTSAY "Etiqueta:"
		@ 3,10 VTGET cCodEtiq   Valid ChkEtiq() F3 "SD3" 

		@ 4,0  VTSAY "Quantidade: " 
		@ 4,12 VTGET nQTD   Valid VldQTD() .And. vtlastkey() # 38  when .t. // .And. 

		@ 6,0 VTSAY "OP: "
		@ 6,5 VTGET cOP  WHEN .F. 

		@ 7,0 VTSAY "Lote: " VTGET cZzLote when .F. 


		VTREAD

		If vtLastKey() == 27
			Exit
		Else

			If vtlastkey() == 38 .And. Empty(cCodEtiq)
				Loop
			Else     
				If VTYesNo("Confirma a operacao","Atencao",.T.)
					GravaMov()
				EndIf 
			EndIf 
		EndIf

	EndDo

	/*	If nQtd > 0  //?.AND. CBYesNo(STR0005,STR0006,.T.) //"Confirma apontamento?"###"ATENCAO"
	While .T.
	VTCLEAR()
	nYesNo := 0
	@ 1,0 vtSay "Confirma Apontamento?"
	@ 2,0 VTGET nYesNo pict '9' When nYesNo<=2

	VTREAD
	If !(vtLastKey() == 27) .And. (nYesNo = 1 .Or. nYesNo = 2)
	VTCLEAR()
	Exit
	EndIf
	EndDo

	If nYesNo = 1	//-Sim
	GravaMov()
	EndIf

	EndIf

	*/
	If IsTelnet() .and. VtModelo() == "RF"
		vtsetkey(05,bkey05)
		vtsetkey(09,bkey09)
		vtsetkey(24,bkey24)
	Else
		TerCls()
		TerIsQuit()
	EndIf

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �   Autor � Elvis Kinuta �                          30/05/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de entrada no estoque Logistica                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ChkProd()
	Local lRet := .T.

	If !Empty(cCodBar) 

		DbSelectArea("SB1")
		DbSetOrder(12)

		If ! DbSeek(xFilial("SB1")+cCodBar )

			CBAlert("Produto nao cadastrado","Aviso",.T.,4000,2)  //"Tipo de movimento"###"nao existe!"###"Aviso"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			Else
				cCodBar := space(15)
			EndIf
			Return .F.

		Else

			cCodBar := SB1->B1_COD
			cDesPrd := SB1->B1_DESC 

			@ 1,0 VTGET cCodBar
			@ 2,0 VTGET cDesPrd


		EndIf 

	EndIf 
Return lRet 


Static Function ChkEtiq()

	Local lRet := .T.

	If !Empty(cCodEtiq) 

		DbSelectArea("SD3")
		SD3->(DbOrderNickName("ETCB0"))
		//SD3->(DbSetOrder(14))

		If ! SD3->(DbSeek(xFilial("SD3")+cCodEtiq ))

			VTAlert("Etiqueta nao cadastrado","Aviso",.T.,4000,2)  //"Tipo de movimento"###"nao existe!"###"Aviso"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			Else
				cCodEtiq := space(10)
			EndIf
			Return .F.

		Else 

			If SD3->D3_COD # cCodBar 

				VTAlert("Produto divergente  da Etiqueta","Alert",.T.,4000,2)  //"Tipo de movimento"###"nao existe!"###"Aviso"    
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				Else
					cCodEtiq := space(10)
				EndIf

				Return .F.

			Else  

				DbSelectArea("ZZL")
				DbSetOrder(4)

				If DbSeek(xFilial("ZZL")+cCodEtiq )

					VTAlert("Etiqueta ja cadastrada.","Alert",.T.,4000,2)  //"Tipo de movimento"###"nao existe!"###"Aviso"    
					If IsTelnet() .and. VtModelo() == "RF"
						VTKeyBoard(chr(20))
					Else
						cCodEtiq := space(10)
					EndIf

					Return .F. 
				EndIf 
				cCodBar := SD3->D3_COD 

				@ 1,0 VTGET cCodBar  

				cOP := SD3->D3_OP 

				@ 6,5 VTGET cOP  WHEN .F.

				cZZLote := SD3->D3_ZZLOTE 

				@ 7,0 VTSAY "Lote: " VTGET cZzLote when .F.				    

			EndIf 

		EndIf 

	Else

		If vtLastkey() = 38 
			Return .T. 
		EndIf 

	EndIf 

Return lRet 

/*/

Grava a movimentacao 

/*/
Static Function GravaMov()

	cProxNum := NextNumero("ZZL",1,"ZZL_NUM",.T.)

	DbSelectArea('ZZL')
	RecLock("ZZL",.T.)
	ZZL->ZZL_FILIAL := xFilial("ZZL")
	ZZL->ZZL_NUM    := cProxNum 
	ZZL->ZZL_EMISSA := dDataBase
	ZZL->ZZL_CODBAR := SB1->B1_ZZCODBA 
	ZZL->ZZL_PRODUT := cCodBar
	ZZL->ZZL_QUANT  := nQtd 
	ZZL->ZZL_ETIQUE := cCodEtiq
	ZZL->ZZL_OP     := cOP
	ZZL->ZZL_LOTE   := cZZlote
	ZZL->ZZL_DOC    := SD3->D3_DOC  
	ZZL->ZZL_PROETQ := cCodBar
	ZZL->ZZL_QTDETQ := nQtd 

	MsUnlock()

Return 


/*/

Ira validar a qtde digitada

/*/

Static function VldQTD()
	Local lRet := .F. 

	If nQtd > 0 

		If nQtd # SD3->D3_QUANT  

			VTAlert("Quantidade divergente do apontamento","Aviso",.T.,4000,2)  //"Tipo de movimento"###"nao existe!"###"Aviso"    
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			Else
				nQtd := 0 
			EndIf

			nQtd := 0 
			Return .F.      

		Else

			Return .T. 

		EndIf 

	EndIf 

Return lRet  