#include "protheus.ch"
#include "TBICONN.ch"
#include "rwmake.ch"
#include "apvt100.ch"
#include "fileio.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �   Elvis Kinuta     � Data �  09/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  JOB Acacia integra pedidos tabela Acacia e Protheus       ���
���          �  Faturados na 3F                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//elvis testar com a cria��o do schedule

/*
T_PEDIDO_SOBEL

1 - Criei o campo T_PEDIDO_SOBEL.DATAGRAVACAOACACIA, esse campo Ac�cia ir� gravar quando enviou o pedido para tabela intermedi�ria.
2 - Criei o campo T_PEDIDO_SOBEL.DATAINTEGRACAOERP, esse campo � para quando o ERP importar gravar a data em que essa a��o ocorreu.
3 - Criei o campo T_PEDIDO_SOBEL.QTDEITENS, quando o ERP estiver importando ou assim que terminar de importar os itens dos pedidos, deve consistir se quantidade informada nesse campo � igual a quantidade de itens importados com sucesso.
4 - Criei o campo T_PEDIDO_SOBEL.MSGIMPORTACAO,  esse campo � para o ERP gravar alguma mensagem de sucesso ou erro durante a importa��o.
5 - O  campo T_PEDIDO_SOBEL. CODIGOUNIDFAT, identifica para qual empresa deve ser importado esse pedido.

T_PEDIDOITEM_SOBEL

1 - Criei o campo T_PEDIDOITEM_SOBEL. MSGIMPORTACAO, esse campo � para o ERP gravar alguma mensagem de sucesso ou erro durante a importa��o desse item especificamente.

*/

User Function SFACA001()
Private cAliasQr1 := GetNextAlias()
Private cAliasQr2 := GetNextAlias()
Private aCabec 	:= {}
Private aItens 	:= {}
Private aLinha 	:= {}
Private cDoc	:= ""
Private cNumAFV	:= ""
Private cCamGrv := "ACACIA\ERRO"+"\PV_ERRO_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","")+"_"
Private cCamGr2 := "ACACIA\OK"+"\PV_"+ DTOS(DATE())+".LOG"	// +"_"+ STRTRAN(TIME(),":","")+"_"
Private lOK	:= .F.
Private nSecC6	:= 0
/*
cFileLog := "ACACIA\ERRO"+"\LOG_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","") +".log"
nFileLog :=  fCreate( cFileLog  )
clog	:= "112233"
fWrite(nFileLog,cLog)
*/

// INTEGRA DATAINTEGRACAOERP VAZIO OU NULL

//SOLBEL
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
EndIf


cQuery := " SELECT Convert (Varchar, CAST(DATAPEDIDO As date),112) XDATAPEDIDO, "
cQuery += " Convert (Varchar, CAST(DATAENTREGA As date),112) XDATAENTREGA, "
cQuery += " ISNULL(CODIGOCLIENTE ,'') CODIGOCLIENTE, ISNULL(LOJACLIENTE ,'') LOJACLIENTE, ISNULL(CODIGOCONDPAGTO ,'') CODIGOCONDPAGTO, "
cQuery += " ISNULL(NUMPEDIDOAFV ,'') NUMPEDIDOAFV, ISNULL(VOLUME ,'') VOLUME, ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP, "
cQuery += " ISNULL(OBSERVACAOI ,'') OBSERVACAOI, ISNULL(OBSERVACAOII ,'') OBSERVACAOII,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  "
//cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO  "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA  "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '01' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	nSecC6	:= 0
	
	CARGAC5()
	
	cQuery := " SELECT ISNULL(NUMITEM ,'') NUMITEM, ISNULL(CODIGOPRODUTO ,'') CODIGOPRODUTO, ISNULL(QTDEVENDA ,'') QTDEVENDA, "
	cQuery += " ISNULL(VALORVENDA ,'') VALORVENDA, ISNULL(VALORBRUTO ,'') VALORBRUTO, ISNULL(NUMPEDIDOAFV ,'') NUMPEDIDOAFV "
	cQuery += " FROM T_PEDIDOITEM_SOBEL SC6 "
	cQuery += " WHERE NUMPEDIDOAFV = '"+(cAliasQr1)->NUMPEDIDOAFV+"' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr2, .F., .T.)
	
	While !(cAliasQr2)->(EOF())
		CARGAC6()
		(cAliasQr2)->(DbSkip())
	EndDo
	(cAliasQr2)->(dbCloseArea())
	
	// CHAMA EXECAUTO
	SFACAGRV()
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = '"+DtoS(dDataBase)+"' WHERE CODIGOUNIDFAT = '01' AND NUMPEDIDOAFV = '"+cNumAFV+"' "
		TCSqlExec(cGRVC5)
	EndIf
	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())
If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf

//JMT
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '02' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
EndIf


cQuery := " SELECT Convert (Varchar, CAST(DATAPEDIDO As date),112) XDATAPEDIDO, "
cQuery += " Convert (Varchar, CAST(DATAENTREGA As date),112) XDATAENTREGA, "
cQuery += " ISNULL(CODIGOCLIENTE ,'') CODIGOCLIENTE, ISNULL(LOJACLIENTE ,'') LOJACLIENTE, ISNULL(CODIGOCONDPAGTO ,'') CODIGOCONDPAGTO, "
cQuery += " ISNULL(NUMPEDIDOAFV ,'') NUMPEDIDOAFV, ISNULL(VOLUME ,'') VOLUME, ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP, "
'>::cQuery += " ISNULL(OBSERVACAOI ,'') OBSERVACAOI, ISNULL(OBSERVACAOII ,'') OBSERVACAOII,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  "
//cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO  "

If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf

// JMT


Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFACA001  �Autor  �Microsiga           � Data �  01/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Carrega aray do SC5                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CARGAC5()
cDoc 	:= GetSxeNum("SC5","C5_NUM")
RollbackSx8()
aCabec 	:= {}
aItens	:= {}

//aadd(aCabec,{"C5_FILIAL"	,cFilAnt, Nil})
//aadd(aCabec,{"C5_NUM"   	,cDoc,Nil})
aadd(aCabec,{"C5_TIPO" 		,"N",Nil})	// ver
aadd(aCabec,{"C5_CLIENTE"	,(cAliasQr1)->CODIGOCLIENTE,Nil})
aadd(aCabec,{"C5_LOJACLI"	,(cAliasQr1)->LOJACLIENTE,Nil})
aadd(aCabec,{"C5_CONDPAG"	,(cAliasQr1)->CODIGOCONDPAGTO,Nil})
aadd(aCabec,{"C5_HASHPT"	,(cAliasQr1)->NUMPEDIDOAFV, Nil})
aadd(aCabec,{"C5_ZZTIPO"	,AllTrim((cAliasQr1)->CODIGOTIPOPEDIDO), Nil})	// ver
aadd(aCabec,{"C5_TRANSP"	,"000001", Nil})	//mesma regra do day2
aadd(aCabec,{"C5_ZZUSER"	,"PORTAL", Nil})
aadd(aCabec,{"C5_VOLUME1"	,(cAliasQr1)->VOLUME, Nil}) // sera criada na tabela um campo com a quantidade total do pedido
aadd(aCabec,{"C5_ESPECI1"	,"CX", Nil})
aadd(aCabec,{"C5_VEND1"		,(cAliasQr1)->CODIGOVENDEDORESP, Nil})
aadd(aCabec,{"C5_EMISSAO"	,StoD((cAliasQr1)->XDATAPEDIDO), Nil})	//StoD((cAliasQr1)->DATAPEDIDO), Nil})
aadd(aCabec,{"C5_ZZPEDCL"	,"Portal " + (cAliasQr1)->ORDEMCOMPRA, Nil}) // tirei  o + numero de cliente
aadd(aCabec,{"C5_MENNOTA"	,(cAliasQr1)->OBSERVACAOII, Nil})
aadd(aCabec,{"C5_ZZOBS1"	,(cAliasQr1)->OBSERVACAOI, Nil})
aadd(aCabec,{"C5_FECENT"	,StoD((cAliasQr1)->XDATAENTREGA), Nil}) //Data de entrega

Return

/*                                                      ,
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFACA001  �Autor  �Microsiga           � Data �  01/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Carrega aray do SC6                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CARGAC6()
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+(cAliasQr2)->CODIGOPRODUTO))

nSecC6	+= 1

aLinha := {}
//aadd(aLinha,{"C6_FILIAL"	,cFilAnt, Nil})
aadd(aLinha,{"C6_ITEM"		,StrZero(nSecC6,2),Nil})
aadd(aLinha,{"C6_PRODUTO"	,(cAliasQr2)->CODIGOPRODUTO,Nil})
aadd(aLinha,{"C6_QTDVEN"	,(cAliasQr2)->QTDEVENDA,Nil})
aadd(aLinha,{"C6_PRCVEN"	,(cAliasQr2)->VALORVENDA,Nil})
aadd(aLinha,{"C6_VALOR"		,Round((cAliasQr2)->QTDEVENDA*(cAliasQr2)->VALORVENDA,2),Nil})
aadd(aLinha,{"C6_TES"		,SB1->B1_TS,Nil})
aadd(aLinha,{"C6_HASHPT"	,(cAliasQr2)->NUMPEDIDOAFV, Nil})

// ELVIS VER DESCONTO
aadd(aItens,aLinha)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFACA001  �Autor  �Microsiga           � Data �  01/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �   ExecAuto                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SFACAGRV()
Private lMsErroAuto := .F.

MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,3)

If ! lMsErroAuto
	ConfirmSx8()
	SFACALOG(2) //GraVa Log
	
	lOk	:= .T.
Else
	RollbackSx8()
	SFACALOG(1) //GraVa Log
	//DisarmTransaction()
	//Break
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFACA001  �Autor  �Microsiga           � Data �  01/11/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Grava��o de LOG                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SFACALOG(nOpc)
Local cMsg1	:= "LOG	- "+DtoC(dDataBase)+" "+Time()+ Chr(13) + Chr(10)
Local cMsg2	:= "ERRO - EMPRESA -"+cUniFat+" PEDIDO "+cDoc+" PVHASH "+cNumAFV+ Chr(13) + Chr(10)
Local cMsg3	:= "OK - EMPRESA -"+cUniFat+" PEDIDO "+cDoc+" PVHASH "+cNumAFV+ Chr(13) + Chr(10)
Local cRand := AllTrim(Str(Randomize(1,999999)))+".LOG"
//Sleep(2000)

If nOpc	== 1	// erro
	nHandle :=  fCreate(cCamGrv+cRand)
	If nHandle == -1
		ConOut("SFACA001 - Erro de abertura : FERROR "+str(ferror(),4))
	Else
		fWrite(nHandle,cMsg1)
		fWrite(nHandle,cMsg2)
		fWrite(nHandle,MostraErro())
		fclose(nHandle)
	Endif
Else
	nHandle := fopen(cCamGr2 , FO_READWRITE + FO_SHARED )
	
	If nHandle == -1
		nHandle := fCreate(cCamGr2)
		If nHandle == -1
			ConOut("SFACA001 - Erro de abertura : FERROR "+str(ferror(),4))
		Else
			fWrite(nHandle,cMsg1)
			fWrite(nHandle,cMsg3)
			fclose(nHandle)
		EndIf
	Else
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		// FWrite(nHandle, "Nova Linha", 10) // Insere texto no arquivo
		fWrite(nHandle,cMsg1)
		fWrite(nHandle,cMsg3)
		fclose(nHandle)
	EndIf
EndIf
Return()