#include "protheus.ch"
#include "TBICONN.ch"
#include "rwmake.ch"
#include "apvt100.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³   Elvis Kinuta     º Data ³  09/01/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  JOB Acacia integra pedidos tabela Acacia e Protheus       º±±
±±º          ³  Faturados na 3F                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//elvis testar com a criação do schedule

/*
T_PEDIDO_SOBEL

1 - Criei o campo T_PEDIDO_SOBEL.DATAGRAVACAOACACIA, esse campo Acácia irá gravar quando enviou o pedido para tabela intermediária.
2 - Criei o campo T_PEDIDO_SOBEL.DATAINTEGRACAOERP, esse campo é para quando o ERP importar gravar a data em que essa ação ocorreu.
3 - Criei o campo T_PEDIDO_SOBEL.QTDEITENS, quando o ERP estiver importando ou assim que terminar de importar os itens dos pedidos, deve consistir se quantidade informada nesse campo é igual a quantidade de itens importados com sucesso.
4 - Criei o campo T_PEDIDO_SOBEL.MSGIMPORTACAO,  esse campo é para o ERP gravar alguma mensagem de sucesso ou erro durante a importação.
5 - O  campo T_PEDIDO_SOBEL. CODIGOUNIDFAT, identifica para qual empresa deve ser importado esse pedido.

T_PEDIDOITEM_SOBEL

1 - Criei o campo T_PEDIDOITEM_SOBEL. MSGIMPORTACAO, esse campo é para o ERP gravar alguma mensagem de sucesso ou erro durante a importação desse item especificamente.

*/

/*
	# Changelog
		All notable changes to this project will be documented in this file.	

	## [0.0.1]	- 18-02-2019
	### Changed
		Static Function CARGAC5()
		Line 275 - concatenação da string 'portal' + (cAliasQr1)->ORDEMCOMPRA
  	## [0.0.2]  - 20-02-2019
				Line 120, 173, 227 - Query UPDATE modificada para gravação da data e hora da integração com o ERP
		  		'DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME)'
   
    ## [0.0.1] - 18-02-2019
	### Added 
		Change query
		Line 88, 141 e 195 - add column " ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA  "  foi adicionada.

*/ 


User Function SFACA001()
Private cAliasQr1 := GetNextAlias()
Private cAliasQr2 := GetNextAlias()
Private aCabec 	:= {}
Private aItens 	:= {}
Private aLinha 	:= {}
Private cBonif  := ""  
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
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2, ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  CODIGOTIPOPEDIDO CODTPPED, "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA, ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPDASS  "
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
	
    /* valida se o pedido é uma bonificação */ 
	If ( cAliasQr1->CODTPPED == 'F' )		
		cBonif := (cAliasQr1)->NUMPDASS 
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
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '01' AND NUMPEDIDOAFV = '"+cNumAFV+"' "
		TCSqlExec(cGRVC5)
	EndIf
	
	/* Trata associação de pedido com bonificação */
	If cBonif <> ''
		setC5PedBon( getC5Num(cNumAFV), cBonif )
		setC5PedBon( getC5Num( cBonif ), getC5Num( cNumAFV ) )
	Else
		cBonif := ''
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
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  CODIGOTIPOPEDIDO CODTPPED, "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA  ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPDASS "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '02' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	nSecC6	:= 0

	/* valida se o pedido é uma bonificação */ 
	If ( cAliasQr1->CODTPPED == 'F' )		
		cBonif := (cAliasQr1)->NUMPDASS 
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
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '02' AND NUMPEDIDOAFV = '"+cNumAFV+"' "
		TCSqlExec(cGRVC5)
	EndIf

		/* Trata associação de pedido com bonificação */
	If cBonif <> ''
		setC5PedBon( getC5Num(cNumAFV), cBonif )
		setC5PedBon( getC5Num( cBonif ), getC5Num( cNumAFV ) )
	Else
		cBonif := ''
	EndIf

	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())
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
cQuery += " ISNULL(OBSERVACAOI ,'') OBS1, ISNULL(OBSERVACAOII ,'') OBS2,ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT,  CODIGOTIPOPEDIDO CODTPPED, "
cQuery += " ISNULL(CODIGOTIPOPEDIDO ,'') CODIGOTIPOPEDIDO, ISNULL(ORDEMCOMPRA, '') ORDEMCOMPRA  ISNULL(CESP_NUMPEDIDOASSOC, '') NUMPDASS "
cQuery += " FROM T_PEDIDO_SOBEL SC5 "
cQuery += " WHERE CODIGOUNIDFAT = '04' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.
	cNumAFV	:= (cAliasQr1)->NUMPEDIDOAFV
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	nSecC6	:= 0

	/* valida se o pedido é uma bonificação */ 
	If ( cAliasQr1->CODTPPED == 'F' )		
		cBonif := (cAliasQr1)->NUMPDASS 
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
	If lOK
		cGRVC5	:= " UPDATE T_PEDIDO_SOBEL SET NUMPEDIDOSOBEL = '"+cDoc+"' , DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME) WHERE CODIGOUNIDFAT = '04' AND NUMPEDIDOAFV = '"+cNumAFV+"' " //elvis colocar um iff verificando se a variavel cDoc esta preenchida , se nao grava "K"
		TCSqlExec(cGRVC5)
	EndIf

		/* Trata associação de pedido com bonificação */
	If cBonif <> ''
		setC5PedBon( getC5Num(cNumAFV), cBonif )
		setC5PedBon( getC5Num( cBonif ), getC5Num( cNumAFV ) )
	Else
		cBonif := ''
	EndIf


	(cAliasQr1)->(DbSkip())
EndDo
(cAliasQr1)->(dbCloseArea())


If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf

// JMT


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SFACA001  ºAutor  ³Microsiga           º Data ³  01/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Carrega aray do SC5                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
aadd(aCabec,{"C5_MENNOTA"	,(cAliasQr1)->OBS2, Nil})
aadd(aCabec,{"C5_ZZOBS1"	,(cAliasQr1)->OBS1, Nil})
aadd(aCabec,{"C5_FECENT"	,StoD((cAliasQr1)->XDATAENTREGA), Nil}) //Data de entrega

Return

/*                                                      ,
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SFACA001  ºAutor  ³Microsiga           º Data ³  01/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Carrega aray do SC6                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SFACA001  ºAutor  ³Microsiga           º Data ³  01/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   ExecAuto                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SFACA001  ºAutor  ³Microsiga           º Data ³  01/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gravação de LOG                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


/*/{Protheus.doc} getC5Num
    Retorna o C5_NUM do pedido de venda a partir do NUMPEDIDO AFV Acácia
    @type  Static Function
    @author Ademilson Nunes
    @since 28/02/2019
    @version 12.0.0
    @param cNumAFV, caracter, número do pedido no AFV (T_PEDIDO_SOBEL->NUMPEDIDOAFV)
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
    Atualiza campo C5_PEDBON
    @type  Static Function
    @author Ademilson Nunes
    @since 28/02/2019
    @version 12.0.0
    @param cC5Num, caracter, C5_NUM do pedido que será alterado
    /*/
Static Function setC5PedBon( cC5Num, cC5PedBon )
    Local aArea := GetArea()
    Local cLoja := '01'

    DbSelectArea("SC5")
    DbSetOrder(1)
    If DbSeek( xFilial('SC5') + cC5Num + cLoja )
        Begin Transaction 	
            RecLock("SC5", .F.)		
            SC5->C5_PEDBON := cC5PedBon		
            MsUnLock() 
        End Transaction
    EndIf

   SC5->(DbCloseArea())
   RestArea(aArea)
Return Nil

