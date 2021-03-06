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

/*
# Changelog
All notable changes to this project will be documented in this file.

## [0.0.1]	- 18-02-2019
### Changed
Static Function CARGAC5()
Line 275 - concatena��o da string 'portal' + (cAliasQr1)->ORDEMCOMPRA
## [0.0.2]  - 20-02-2019
Line 120, 173, 227 - Query UPDATE modificada para grava��o da data e hora da integra��o com o ERP
'DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME)'

## [0.0.1] - 18-02-2019
### Added
Change query
Line 88, 141 e 195 - add column " ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA  "  foi adicionada.

## [0.0.1] - 11-03-2019
### Added
Tratamendo da amarra��o de pedido de venda normal + bonifica��o
Cria��o das static functions que contemplam o a amarra��o.

*/


User Function SFACA001()
Private cAliasQr1 := GetNextAlias()
Private cAliasQr2 := GetNextAlias()
Private aCabec 	:= {}
Private aItens 	:= {}
Private aLinha 	:= {}
Private aPvBon  := {}//array recebe NUMPEDIDOAFV de pedidos de bonifica��o
Private aRes    := {}
Private cVar    := ''
Private cDoc	:= ""
Private cTpVen  := ''
Private cNumAFV	:= ""
Private nX      := 0
Private nI      := 0
Private cCamGrv := "ACACIA\ERRO"+"\PV_ERRO_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","")+"_"
Private cCamGr2 := "ACACIA\OK"+"\PV_"+ DTOS(DATE())+".LOG"	// +"_"+ STRTRAN(TIME(),":","")+"_"
Private lOK	:= .F.
Private nSecC6	:= 0
Private cNumSetBon := ''

//Debug
//Private cFileLog  := "ACACIA"+"\debug.log
//Private cLogObj   := FCreate(cFileLog)


/*
cFileLog := "ACACIA\ERRO"+"\LOG_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","") +".log"
nFileLog :=  fCreate( cFileLog  )
clog	:= "112233"
fWrite(nFileLog,cLog)
*/

Conout("JOB ACACIA - SFACA001 - "+time())
// INTEGRA DATAINTEGRACAOERP VAZIO OU NULL

//SOLBEL
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
EndIf


cQuery := " SELECT Convert (Varchar, CAST(DATAPEDIDO As date),112) XDATAPEDIDO, "
cQuery += " Convert (Varchar, CAST(DATAENTREGA As date),112) XDATAENTREGA, "
cQuery += " ISNULL(CODIGOCLIENTE ,'') CODIGOCLIENTE, ISNULL(LOJACLIENTE ,'') LOJACLIENTE, ISNULL(CODIGOCONDPAGTO ,'') CODIGOCONDPAGTO, "
cQuery += " ISNULL(NUMPEDIDOAFV ,'') NUMPEDIDOAFV, ISNULL(VOLUME ,'') VOLUME, ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP, "
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA, ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPVASSOC, ISNULL(CODIGOTIPOPEDIDO ,'') CODTPPV "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '01' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)


While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cTpVen  := Alltrim((cAliasQr1)->CODTPPV)
	nSecC6	:= 0
	
	//Se bonifica��o - aPvBon recebe cNumAFV
	If cTpVen == 'F'
		AAdd( aPvBon, cNumAFV )
	EndIf
	
	
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
	cDoc := getC5Num(cNumAFV)
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '01' AND NUMPEDIDOAFV = '"+cNumAFV+"' "
		TCSqlExec(cGRVC5)
	EndIf
	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())

//Trata amarra��o dos pedidos normais com a bonifica��o
If Len(aPvBon) > 0
	For nX:= 1 to Len( aPvBon )
		// Retorna array com pedidos de venda NORMAL associados a Bonifica��o
		aRes := getC5NumV( getPvAss(aPvBon[nX]) )
		// converte array para string no padr�o C5_PEDBON
		cVar := arrToStr( aRes )
		//Grava em C5_PEDBON, string com 'lote' de pedidos associados a bonifica��o separados por virgula.
		setC5PedBon( getC5Num(aPvBon[nX]),  cVar)
		
		//Grava C5_NUM Bonifica��o em cada pedido normal associado
		cNumSetBon := getPVToB( aPvBon[nX] )

		If cNumSetBon != ''
			setC5PedBon(  cNumSetBon, getC5Num( aPvBon[nX] ) )
		EndIf
			

	Next
EndIf

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
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA, ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPVASSOC, ISNULL(CODIGOTIPOPEDIDO ,'') CODTPPV "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '02' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cTpVen  := AllTrim( (cAliasQr1)->CODTPPV )
	nSecC6	:= 0
	
	
	//Se bonifica��o - aPvBon recebe cNumAFV
	If cTpVen == 'F'
		AAdd( aPvBon, cNumAFV )
	EndIf
	
	
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
	cDoc := getC5Num(cNumAFV)
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '02' AND NUMPEDIDOAFV = '"+cNumAFV+"' "
		TCSqlExec(cGRVC5)
	EndIf
	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())


//Trata amarra��o dos pedidos normais com a bonifica��o
If Len(aPvBon) > 0
	For nX:= 1 to Len( aPvBon )
		// Retorna array com pedidos de venda NORMAL associados a Bonifica��o
		aRes := getC5NumV( getPvAss(aPvBon[nX]) )
		// converte array para string no padr�o C5_PEDBON
		cVar := arrToStr( aRes )
		//Grava em C5_PEDBON, string com 'lote' de pedidos associados a bonifica��o separados por virgula.
		setC5PedBon( getC5Num(aPvBon[nX]),  cVar)
		
		//Grava C5_NUM Bonifica��o em cada pedido normal associado
		cNumSetBon := getPVToB( aPvBon[nX] )

		If cNumSetBon != ''
			setC5PedBon(  cNumSetBon, getC5Num( aPvBon[nX] ) )
		EndIf
			
	Next
EndIf

If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf


//3F
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
EndIf


cQuery := " SELECT Convert (Varchar, CAST(DATAPEDIDO As date),112) XDATAPEDIDO, "
cQuery += " Convert (Varchar, CAST(DATAENTREGA As date),112) XDATAENTREGA, "
cQuery += " ISNULL(CODIGOCLIENTE ,'') CODIGOCLIENTE, ISNULL(LOJACLIENTE ,'') LOJACLIENTE, ISNULL(CODIGOCONDPAGTO ,'') CODIGOCONDPAGTO, "
cQuery += " ISNULL(NUMPEDIDOAFV ,'') NUMPEDIDOAFV, ISNULL(VOLUME ,'') VOLUME, ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP, "
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA, ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPVASSOC, ISNULL(CODIGOTIPOPEDIDO ,'') CODTPPV  "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '04' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cTpVen  := Alltrim((cAliasQr1)->CODTPPV)
	nSecC6	:= 0
	
	//Se bonifica��o - aPvBon recebe cNumAFV
	If  cTpVen == 'F'
		AAdd( aPvBon, cNumAFV )
	EndIf
	
	
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
	cDoc := getC5Num(cNumAFV)
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '04' AND NUMPEDIDOAFV = '"+cNumAFV+"' " //elvis colocar um iff verificando se a variavel cDoc esta preenchida , se nao grava "K"
		TCSqlExec(cGRVC5)
	EndIf
	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())


//Trata amarra��o dos pedidos normais com a bonifica��o
If Len(aPvBon) > 0
	For nX:= 1 to Len( aPvBon )
		// Retorna array com pedidos de venda NORMAL associados a Bonifica��o
		aRes := getC5NumV( getPvAss(aPvBon[nX]) )
		// converte array para string no padr�o C5_PEDBON
		cVar := arrToStr( aRes )
		//Grava em C5_PEDBON, string com 'lote' de pedidos associados a bonifica��o separados por virgula.
		setC5PedBon( getC5Num(aPvBon[nX]),  cVar)
		
		//Grava C5_NUM Bonifica��o em cada pedido normal associado
		cNumSetBon := getPVToB( aPvBon[nX] )

		If cNumSetBon != ''
			setC5PedBon(  cNumSetBon, getC5Num( aPvBon[nX] ) )
		EndIf
			
	Next
EndIf


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
//cDoc 	:= GetSxeNum("SC5","C5_NUM")
//RollbackSx8()
aCabec 	:= {}
aItens	:= {}

cCliente	:= (cAliasQr1)->CODIGOCLIENTE
cLojaCli	:= (cAliasQr1)->LOJACLIENTE
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
aadd(aCabec,{"C5_MENNOTA"	,(cAliasQr1)->OBS2, Nil})
aadd(aCabec,{"C5_ZZOBS1"	,(cAliasQr1)->OBS1, Nil})
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
//Private nComis	:=  0
Private	cGrpPrd := ""
Private	nPprod	:= 0
Private	nValDig	:= 0

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+(cAliasQr2)->CODIGOPRODUTO))
	nPprod	:= SB1->B1_COMIS
	cGrpPrd := SubStr(SB1->B1_COD,1,2)
	nValDig := (cAliasQr2)->VALORVENDA
EndIf

//COMISESC()	//Carrega valor da Comiss�o	nComis
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
//aadd(aLinha,{"C6_COMIS1"	,nComis, Nil})


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


//-------------------------------------------------------------------
/*/{Protheus.doc} getPVToB
	Retorna C5_NUM referente ao pedido que será associado a bonificação
@author  Ademilson Nunes
@since   12/04/2019
@version 12.0.0
@param cNumAFV, caracter, código do pedido AFV
@return cNumPV, caracter, código do pedido Protheus
/*/
//-------------------------------------------------------------------
Static Function getPVToB( cNumAFV)
Local aArea   := GetArea()
Local cResult := ''

	BeginSQL Alias 'AFV'
		SELECT NUMPEDIDOSOBEL
			FROM(SELECT NUMPEDIDOSOBEL,
				        CODIGOCLIENTE,
				        NUMPEDIDOAFV,
				        CODIGOTIPOPEDIDO 
		         FROM T_PEDIDO_SOBEL B 
		         WHERE B.NUMPEDIDOAFV IN 
		         (SELECT TAB.ITENS 
			      FROM T_PEDIDO_SOBEL PED 
			      CROSS APPLY F_SPLIT(ISNULL(PED.CESP_NUMPEDIDOASSOC,''),';') TAB 
			      WHERE PED.NUMPEDIDOAFV = %Exp:cNumAFV%)) C 
				  WHERE C.CODIGOCLIENTE =  (SELECT CODIGOCLIENTE 
						  				    FROM T_PEDIDO_SOBEL 
						  				    WHERE NUMPEDIDOAFV = %Exp:cNumAFV%) 
	EndSQL

	While ! AFV->(EoF())
		cResult := cValToChar( AFV->NUMPEDIDOSOBEL )
		AFV->(DbSkip())	
	End

	AFV->(DbCloseArea())
	RestArea(aArea)

Return cResult




/*/{Protheus.doc} getC5Num
Retorna o C5_NUM do pedido de venda a partir do NUMPEDIDO AFV Ac�cia
@type  Static Function
@author Ademilson Nunes
@since 28/02/2019
@version 12.0.0
@param cNumAFV, caracter, n�mero do pedido no AFV (T_PEDIDO_SOBEL->NUMPEDIDOAFV)
@return cResult, caracter, retorna o C5_NUM do pedido de venda
/*/
Static Function getC5Num( cNumAFV )
Local aArea   := GetArea()
Local cResult := ''

BeginSQL Alias 'SQLSC5'
	SELECT C5_NUM
	FROM %table:SC5% SC5
	WHERE
	C5_FILIAL = %xFilial:SC5%
	AND C5_HASHPT = %Exp:cNumAFV%
	AND SC5.%notDel%
EndSQL

While ! SQLSC5->(EoF())
	cResult := cValToChar( SQLSC5->C5_NUM )
	SQLSC5->(DbSkip())
EndDo

SQLSC5->(DbCloseArea())
RestArea(aArea)
Return cResult


/*/{Protheus.doc} setC5PedBon
Atualiza campo C5_PEDBON na tabela SC5
@type  Static Function
@author Ademilson Nunes
@since 28/02/2019
@version 12.0.0
@param cC5Num, caracter, C5_NUM do pedido que ser� alterado
@param cC5PedBon, caracter, valor a ser gravado no campo C5_PEDBON
/*/
Static Function setC5PedBon( cC5Num, cC5PedBon )
Local aArea := GetArea()
//Local cLoja := '01'

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek( xFilial('SC5') + cC5Num )
	Begin Transaction
	RecLock("SC5", .F.)
	SC5->C5_PEDBON := cC5PedBon
	SC5->(MsUnLock() )
	End Transaction
EndIf

SC5->(DbCloseArea())
RestArea(aArea)
Return Nil


/*/{Protheus.doc} getC5NumV
Retorna um array com todos os pedidos de venda (C5_NUM) a partir de um lote ou um �nico NUMPEDIDOAFV
armazenado na coluna CESP_NUMPEDIDOASSOC da tabela T_PEDIDO_SOBEL
@type  Static Function
@author Ademilson Nunes
@since 07/03/2019
@version 12.0.0
@param cNumPvAss, caracter, c�digos NUMPEDIDOAFV (lote separado por virgula ou c�digo �nico)
/*/
static function getC5NumV( cNumPvAss )
Local aVetor  := {}
Local aResult := {}
Local nX      := 0

//No minimo 2 pedidos vindos do tablet concatenados por ,
If ';' $ cNumPvAss .And. Len( cNumPvAss ) >= 27
	aVetor := Strtokarr( cNumPvAss, ';' )
	If Len(aVetor) <> 0
		For nX:= 1 to Len(aVetor)
			AAdd( aResult, getC5Num(cValToChar(aVetor[nX]) ) )
		Next
	EndIf
else
	AAdd(aResult, getC5Num(cNumPvAss) )
EndIf

Return aResult


//-------------------------------------------------------------------
/*/{Protheus.doc} getPvAss
Retorna CESP_NUMPEDIDOASSOC, a partir do NUMPEDIDOAFV
Este campo pode conter, um ou mais c�digo NUMPEDIDOAFV
separados por virgula relacionados a um pedido de bonifica��o
@author  Ademilson Nunes
@since   08/03/2019
@version 12.0.0
@param cNumAFV, caracter, NUMPEDIDOAFV
/*/
//-------------------------------------------------------------------
static function getPvAss( cNumAFV )
Local cResult := ''
Local aArea   := GetArea()

BeginSQL Alias 'AFV'
	SELECT CESP_NUMPEDIDOASSOC AS NPVASS
	FROM  T_PEDIDO_SOBEL
	WHERE
	NUMPEDIDOAFV = %Exp:cNumAFV%
EndSQL

While !AFV->(EoF())
	cResult := AllTrim(cValToChar( AFV->NPVASS ))
	AFV->(DbSkip())
EndDo

AFV->(DbCloseArea())
RestArea(aArea)
Return cResult


//-------------------------------------------------------------------
/*/{Protheus.doc} arrToStr
Converte Array para string - no formato a ser gravado em C5_PEDBON
na tabela SC5.
@author  Ademilson Nunes
@since   11/03/2019
@version 12.0.0
/*/
//-------------------------------------------------------------------
static function arrToStr( aResult )
Local cResult := ''

If len(aResult) <> 0
	cResult :=  AsString( aResult )         //Converte para string
	cResult :=  StrTran( cResult, '{', '' ) //Remove caracter especial do lado esquerdo
	cResult :=  StrTran( cResult, '}', '' ) //Remove caracter especial do lado direito
else
	cResult := ''
EndIf

Return cResult


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFACA001  �Autor  �Microsiga           � Data �  03/22/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Comiss�o Escalonada                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function COMISESC()
Local cTpFrete	:= M->C5_TPFRETE
Local cRegiao	:= ""
Local nVlDescar	:= 0
Local nValFre	:= 0
Local nValTot	:= 0
Local nPerct	:= 0  
Local nValTab	:= 0
Local cTabPre	:= ""

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+cCliente+cLojaCli))
	cRegiao		:= SA1->A1_XREGIAO
	nVlDescar 	:= SA1->A1_XVLDSCR 
	cTabPre	    := SA1->A1_TABELA
EndIf

If !Empty(cRegiao)
	DbSelectArea("ZZB")
	DbsetOrder(1) //ZZB_FILIAL+COD+ZZB_REGIAO
	If DbSeek(xFilial("ZZB")+cRegiao)
		nValFre := ZZB->ZZB_VLFRET+nVlDescar
	EndIf
EndIf
                        
//ELVIS CONTINUAR - BUSCAR O VALOR DA TABELA DE PRE�O

nValTot	:= nValTab+nValFre
nPerct := Round(((nValDig-nValTot)/nValTot)*100,2)  // Valor perncentual da diferen�a nPosPRR      // ((Valor Digitado - Valor da tabela)/Valor da tabela)*100

While ZZC->(!Eof())
	If nPerct >= 0
		If cGrpPrd $ ZZC->ZZC_GRUPO .AND. nPerct >= ZZC->ZZC_PERINI .AND. nPerct <= ZZC->ZZC_PERFIN
			nRes := ZZC->ZZC_COMISS+nPprod
			Exit
		EndIf
	Else
		If cGrpPrd $ ZZC->ZZC_GRUPO .AND. nPerct*(-1) >= ZZC->ZZC_PERINI*(-1) .AND. nPerct*(-1) <= ZZC->ZZC_PERFIN*(-1)   //com a logica da tabela ZZC hj conseguimos tratar desta forma . mas o ideal seria pegar sem inverter o valor. nao tevimemos tempo neste momento. Para que continue funcionando com esta logica o valor da propor��o do positivo deve ser igual ao negativo exemplo 1 e -1 / 1,5 e -1,5 / 5,5 e -5,5
			nRes := nPprod-(ZZC->ZZC_COMISS*(-1)) //((ZZC->ZZC_COMISS+0.5)*(-1))+nPprod
			Exit
		EndIf
	EndIf
	ZZC->(DbSkip())
EndDo

If nPerct == 0
	nRes := nPprod
ElseIf nRes < 0
	nRes := 0
EndIf

nComis	:= nRes
Return()
