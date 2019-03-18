#include "protheus.ch"
#include "TBICONN.ch"
#include "rwmake.ch"
#include "apvt100.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SFACA002     บAutor  ณ   Elvis Kinuta    บ Data ณ  09/01/19บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  JOB Acacia integra CLIENTES tabela Acacia e Protheus      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
T_CLIENTENOVO_SOBEL

1 - Criei o campo T_CLIENTENOVO_SOBEL.DATAGRAVACAOACACIA, esse campo Acแcia irแ gravar quando enviou o pedido para tabela intermediแria.
2 - Criei o campo T_CLIENTENOVO_SOBEL.DATAINTEGRACAOERP, esse campo ้ para quando o ERP importar gravar a data em que essa a็ใo ocorreu.
3 - Criei o campo T_CLIENTENOVO_SOBEL.MSGIMPORTACAO,  esse campo ้ para o ERP gravar alguma mensagem de sucesso ou erro durante a importa็ใo.
4 - O  campo T_CLIENTENOVO_SOBEL.CODIGOUNIDFAT, identifica para qual empresa deve ser importado esse cliente.
*/

User Function SFACA002()
Private cAliasQr1 := GetNextAlias()
Private cAliasQr2 := GetNextAlias()
Private aCabec 	:= {}
Private aItens 	:= {}
Private aLinha 	:= {}
Private cDoc	:= ""
Private cCamGrv := "ACACIA\CLIENTES"+"\ERRO_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","") +".LOG"
Private cCamGr2 := "ACACIA\CLIENTES"+"\OK_"+ DTOS(DATE())+".LOG"	// +"_"+ STRTRAN(TIME(),":","")+"_"
Private aVetor	:= {}
Private lMsErroAuto := .F.
Private lOK	:= .F.


//SOLBEL
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" // voltar
EndIf

cQuery := " SELECT "
cQuery += " ISNULL(CESP_CODIGOIBGE ,'') CESP_CODIGOIBGE		,"	
cQuery += " ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT			,"
cQuery += " ISNULL(LOJACLIENTE ,'') LOJACLIENTE				,"
cQuery += " ISNULL(RAZAOSOCIAL ,'') RAZAOSOCIAL				,"
cQuery += " ISNULL(NOMEREDUZIDO ,'') NOMEREDUZIDO			,"
cQuery += " ISNULL(ENDERECO ,'') ENDERECO					,"
cQuery += " ISNULL(ESTADO ,'') ESTADO						,"
cQuery += " ISNULL(CODIGONOMECIDADE ,'') CODIGONOMECIDADE	,"
cQuery += " ISNULL(BAIRRO ,'') BAIRRO						,"
cQuery += " ISNULL(CEP ,'') CEP								,"
cQuery += " ISNULL(CNPJ ,'') CNPJ							,"
cQuery += " ISNULL(NOMECONTADOR ,'') NOMECONTADOR			,"
cQuery += " ISNULL(INSCRICAOESTADUAL ,'') INSCRICAOESTADUAL	,"
cQuery += " ISNULL(EMAIL ,'') EMAIL							,"
cQuery += " ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP	,"
cQuery += " ISNULL(CESP_DDD ,'') CESP_DDD					,"
cQuery += " ISNULL(TELEFONE ,'') TELEFONE					"
cQuery += " FROM T_CLIENTENOVO_SOBEL SA1 "					"
cQuery += " WHERE CODIGOUNIDFAT = '01' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.  	//cDoc 	:= GetSxeNum("SA1","A1_COD")
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cCGc	:= (cAliasQr1)->CNPJ
	
	aVetor:={{"A1_LOJA"  ,(cAliasQr1)->LOJACLIENTE  ,Nil},; // Loja//"A1_COD"   ,cDoc		           	,Nil},; // Codigo
	{"A1_NOME"      ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_ZZCNOME"   ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_PESSOA"    ,"J"					 		,Nil},; //*
	{"A1_NREDUZ"    ,(cAliasQr1)->NOMEREDUZIDO		,Nil},;
	{"A1_TIPO"      ,"F"			,Nil},;	//	TROCA POR TIPOCLI - ELVIS
	{"A1_END"       ,(cAliasQr1)->ENDERECO			,Nil},;
	{"A1_EST"       ,(cAliasQr1)->ESTADO    		,Nil},;
	{"A1_COD_MUN"   ,(cAliasQr1)->CESP_CODIGOIBGE	,Nil},;						
	{"A1_MUN"       ,(cAliasQr1)->CODIGONOMECIDADE	,Nil},;
	{"A1_BAIRRO"    ,(cAliasQr1)->BAIRRO			,Nil},;
	{"A1_CEP"   	,(cAliasQr1)->CEP				,Nil},;
	{"A1_PAIS"   	,"105"							,Nil},;
	{"A1_CGC"   	,(cAliasQr1)->CNPJ				,Nil},;
	{"A1_CONTATO"   ,(cAliasQr1)->NOMECONTADOR		,Nil},;
	{"A1_INSCR"   	,(cAliasQr1)->INSCRICAOESTADUAL	,Nil},;
	{"A1_EMAIL"   	,(cAliasQr1)->EMAIL				,Nil},;
	{"A1_NATUREZ"   ,"1002001"						,Nil},;//*
	{"A1_VEND"   	,(cAliasQr1)->CODIGOVENDEDORESP	,Nil},;
	{"A1_CONTA"   	,"1121000300"          			,Nil},;//*  //ELVIS - VER QUAL A CONTA CORRETA.
	{"A1_TPFRET"   	,"C"							,Nil},;//*
	{"A1_CODPAIS"   ,"01058"						,Nil},;
	{"A1_XREGIAO"   ,"999"							,Nil},;//*
	{"A1_RISCO"   	,"E"							,Nil},;//*
	{"A1_TABELA"    ,"999"							,Nil},;//*
	{"A1_DDD"    	,(cAliasQr1)->CESP_DDD			,Nil},;
	{"A1_TEL"    	,(cAliasQr1)->TELEFONE			,Nil},;
	{"A1_MSBLQL"   	,"1"							,Nil},; // SOBE BLOQUEADO
	{"A1_ZZBOL"   	,"N"							,Nil}} //*
	
	SFACAGRV()
	If lOK
		cGRVA1	:= " UPDATE T_CLIENTENOVO_SOBEL SET DATAINTEGRACAOERP = '"+DtoS(dDataBase)+"' WHERE CODIGOUNIDFAT = '01' AND CNPJ = '"+cCGc+"' "
		TCSqlExec(cGRVA1)
	EndIf
	(cAliasQr1)->(DbSkip())
	
EndDo
(cAliasQr1)->(dbCloseArea())
If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf


// JMT
//SOLBEL
If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" // voltar
EndIf

cQuery := " SELECT "
cQuery += " ISNULL(CESP_CODIGOIBGE ,'') CESP_CODIGOIBGE		,"	
cQuery += " ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT			,"
cQuery += " ISNULL(LOJACLIENTE ,'') LOJACLIENTE				,"
cQuery += " ISNULL(RAZAOSOCIAL ,'') RAZAOSOCIAL				,"
cQuery += " ISNULL(NOMEREDUZIDO ,'') NOMEREDUZIDO			,"
cQuery += " ISNULL(ENDERECO ,'') ENDERECO					,"
cQuery += " ISNULL(ESTADO ,'') ESTADO						,"
cQuery += " ISNULL(CODIGONOMECIDADE ,'') CODIGONOMECIDADE	,"
cQuery += " ISNULL(BAIRRO ,'') BAIRRO						,"
cQuery += " ISNULL(CEP ,'') CEP								,"
cQuery += " ISNULL(CNPJ ,'') CNPJ							,"
cQuery += " ISNULL(NOMECONTADOR ,'') NOMECONTADOR			,"
cQuery += " ISNULL(INSCRICAOESTADUAL ,'') INSCRICAOESTADUAL	,"
cQuery += " ISNULL(EMAIL ,'') EMAIL							,"
cQuery += " ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP	,"
cQuery += " ISNULL(CESP_DDD ,'') CESP_DDD					,"
cQuery += " ISNULL(TELEFONE ,'') TELEFONE					"
cQuery += " FROM T_CLIENTENOVO_SOBEL SA1 "					"
cQuery += " WHERE CODIGOUNIDFAT = '02' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.  	//cDoc 	:= GetSxeNum("SA1","A1_COD")
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cCGc	:= (cAliasQr1)->CNPJ
	
	aVetor:={{"A1_LOJA"  ,(cAliasQr1)->LOJACLIENTE  ,Nil},; // Loja//"A1_COD"   ,cDoc		           	,Nil},; // Codigo
	{"A1_NOME"      ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_ZZCNOME"   ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_PESSOA"    ,"J"					 		,Nil},; //*
	{"A1_NREDUZ"    ,(cAliasQr1)->NOMEREDUZIDO		,Nil},;
	{"A1_TIPO"      ,"F"			,Nil},;	//	TROCA POR TIPOCLI - ELVIS
	{"A1_END"       ,(cAliasQr1)->ENDERECO			,Nil},;
	{"A1_EST"       ,(cAliasQr1)->ESTADO    		,Nil},;
	{"A1_COD_MUN"   ,(cAliasQr1)->CESP_CODIGOIBGE	,Nil},;						
	{"A1_MUN"       ,(cAliasQr1)->CODIGONOMECIDADE	,Nil},;
	{"A1_BAIRRO"    ,(cAliasQr1)->BAIRRO			,Nil},;
	{"A1_CEP"   	,(cAliasQr1)->CEP				,Nil},;
	{"A1_PAIS"   	,"105"							,Nil},;
	{"A1_CGC"   	,(cAliasQr1)->CNPJ				,Nil},;
	{"A1_CONTATO"   ,(cAliasQr1)->NOMECONTADOR		,Nil},;
	{"A1_INSCR"   	,(cAliasQr1)->INSCRICAOESTADUAL	,Nil},;
	{"A1_EMAIL"   	,(cAliasQr1)->EMAIL				,Nil},;
	{"A1_NATUREZ"   ,"1002001"						,Nil},;//*
	{"A1_VEND"   	,(cAliasQr1)->CODIGOVENDEDORESP	,Nil},;
	{"A1_CONTA"   	,"1121000300"          			,Nil},;//*  //ELVIS - VER QUAL A CONTA CORRETA.
	{"A1_TPFRET"   	,"C"							,Nil},;//*
	{"A1_CODPAIS"   ,"01058"						,Nil},;
	{"A1_XREGIAO"   ,"999"							,Nil},;//*
	{"A1_RISCO"   	,"E"							,Nil},;//*
	{"A1_TABELA"    ,"999"							,Nil},;//*
	{"A1_DDD"    	,(cAliasQr1)->CESP_DDD			,Nil},;
	{"A1_TEL"    	,(cAliasQr1)->TELEFONE			,Nil},;
	{"A1_ZZBOL"   	,"N"							,Nil}} //*
	
	SFACAGRV()
	If lOK
		cGRVA1	:= " UPDATE T_CLIENTENOVO_SOBEL SET DATAINTEGRACAOERP = '"+DtoS(dDataBase)+"' WHERE CODIGOUNIDFAT = '02' AND CNPJ = '"+cCGc+"' "
		TCSqlExec(cGRVA1)
	EndIf
	(cAliasQr1)->(DbSkip())
	
EndDo
(cAliasQr1)->(dbCloseArea())
If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf



//3F

If !(Type("oMainWnd")=="O")	  //Se via schedule
	PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01' MODULO "FAT" // voltar
EndIf

cQuery := " SELECT "
cQuery += " ISNULL(CESP_CODIGOIBGE ,'') CESP_CODIGOIBGE		,"	
cQuery += " ISNULL(CODIGOUNIDFAT ,'') CODIGOUNIDFAT			,"
cQuery += " ISNULL(LOJACLIENTE ,'') LOJACLIENTE				,"
cQuery += " ISNULL(RAZAOSOCIAL ,'') RAZAOSOCIAL				,"
cQuery += " ISNULL(NOMEREDUZIDO ,'') NOMEREDUZIDO			,"
cQuery += " ISNULL(ENDERECO ,'') ENDERECO					,"
cQuery += " ISNULL(ESTADO ,'') ESTADO						,"
cQuery += " ISNULL(CODIGONOMECIDADE ,'') CODIGONOMECIDADE	,"
cQuery += " ISNULL(BAIRRO ,'') BAIRRO						,"
cQuery += " ISNULL(CEP ,'') CEP								,"
cQuery += " ISNULL(CNPJ ,'') CNPJ							,"
cQuery += " ISNULL(NOMECONTADOR ,'') NOMECONTADOR			,"
cQuery += " ISNULL(INSCRICAOESTADUAL ,'') INSCRICAOESTADUAL	,"
cQuery += " ISNULL(EMAIL ,'') EMAIL							,"
cQuery += " ISNULL(CODIGOVENDEDORESP ,'') CODIGOVENDEDORESP	,"
cQuery += " ISNULL(CESP_DDD ,'') CESP_DDD					,"
cQuery += " ISNULL(TELEFONE ,'') TELEFONE					"
cQuery += " FROM T_CLIENTENOVO_SOBEL SA1 "					"
cQuery += " WHERE CODIGOUNIDFAT = '04' "
cQuery += " AND (DATAINTEGRACAOERP IS NULL OR DATAINTEGRACAOERP = '') "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),cAliasQr1, .F., .T.)

While !(cAliasQr1)->(EOF())
	lOK	:= .F.  	//cDoc 	:= GetSxeNum("SA1","A1_COD")
	cUniFat	:= (cAliasQr1)->CODIGOUNIDFAT
	cCGc	:= (cAliasQr1)->CNPJ
	
	aVetor:={{"A1_LOJA"  ,(cAliasQr1)->LOJACLIENTE  ,Nil},; // Loja//"A1_COD"   ,cDoc		           	,Nil},; // Codigo
	{"A1_NOME"      ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_ZZCNOME"   ,(cAliasQr1)->RAZAOSOCIAL  		,Nil},;
	{"A1_PESSOA"    ,"J"					 		,Nil},; //*
	{"A1_NREDUZ"    ,(cAliasQr1)->NOMEREDUZIDO		,Nil},;
	{"A1_TIPO"      ,"F"			,Nil},;	//	TROCA POR TIPOCLI - ELVIS
	{"A1_END"       ,(cAliasQr1)->ENDERECO			,Nil},;
	{"A1_EST"       ,(cAliasQr1)->ESTADO    		,Nil},;
	{"A1_COD_MUN"   ,(cAliasQr1)->CESP_CODIGOIBGE	,Nil},;						
	{"A1_MUN"       ,(cAliasQr1)->CODIGONOMECIDADE	,Nil},;
	{"A1_BAIRRO"    ,(cAliasQr1)->BAIRRO			,Nil},;
	{"A1_CEP"   	,(cAliasQr1)->CEP				,Nil},;
	{"A1_PAIS"   	,"105"							,Nil},;
	{"A1_CGC"   	,(cAliasQr1)->CNPJ				,Nil},;
	{"A1_CONTATO"   ,(cAliasQr1)->NOMECONTADOR		,Nil},;
	{"A1_INSCR"   	,(cAliasQr1)->INSCRICAOESTADUAL	,Nil},;
	{"A1_EMAIL"   	,(cAliasQr1)->EMAIL				,Nil},;
	{"A1_NATUREZ"   ,"1002001"						,Nil},;//*
	{"A1_VEND"   	,(cAliasQr1)->CODIGOVENDEDORESP	,Nil},;
	{"A1_CONTA"   	,"1121000300"          			,Nil},;//*  //ELVIS - VER QUAL A CONTA CORRETA.
	{"A1_TPFRET"   	,"C"							,Nil},;//*
	{"A1_CODPAIS"   ,"01058"						,Nil},;
	{"A1_XREGIAO"   ,"999"							,Nil},;//*
	{"A1_RISCO"   	,"E"							,Nil},;//*
	{"A1_TABELA"    ,"999"							,Nil},;//*
	{"A1_DDD"    	,(cAliasQr1)->CESP_DDD			,Nil},;
	{"A1_TEL"    	,(cAliasQr1)->TELEFONE			,Nil},;
	{"A1_ZZBOL"   	,"N"							,Nil}} //*
	
	SFACAGRV()
	If lOK
		cGRVA1	:= " UPDATE T_CLIENTENOVO_SOBEL SET DATAINTEGRACAOERP = '"+DtoS(dDataBase)+"' WHERE CODIGOUNIDFAT = '04' AND CNPJ = '"+cCGc+"' "
		TCSqlExec(cGRVA1)
	EndIf
	(cAliasQr1)->(DbSkip())
	
EndDo
(cAliasQr1)->(dbCloseArea())
If !(Type("oMainWnd")=="O")	  //Se via schedule
	RESET ENVIRONMENT
EndIf


Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSFACA001  บAutor  ณMicrosiga           บ Data ณ  01/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   ExecAuto                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SFACAGRV()
Private lMsErroAuto := .F.

MSExecAuto({|x,y| Mata030(x,y)},aVetor,3)


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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSFACA001  บAutor  ณMicrosiga           บ Data ณ  01/11/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava็ใo de LOG                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SFACALOG(nOpc)
Local cMsg1	:= "LOG	- "+DtoC(dDataBase)+" "+Time()+ Chr(13) + Chr(10)
Local cMsg2	:= "ERRO - EMPRESA -"+cUniFat+" CNJP "+cCGc+ Chr(13) + Chr(10)
Local cMsg3	:= "OK - EMPRESA -"+cUniFat+" CNJP "+cCGc+ Chr(13) + Chr(10)
Local cRand := AllTrim(Str(Randomize(1,999999)))+".LOG"

If nOpc	== 1	// erro
	nHandle :=  fCreate(cCamGrv+cRand)
	If nHandle == -1
		ConOut("SFACA002 - Erro de abertura : FERROR "+str(ferror(),4))
	Else
		fWrite(nHandle,cMsg1)
		fWrite(nHandle,cMsg2)
		fWrite(nHandle,MostraErro())
		fclose(nHandle)
	Endif
Else
	nHandle :=  fCreate(cCamGr2+cRand)
	If nHandle == -1
		ConOut("SFACA002 - Erro de abertura : FERROR "+str(ferror(),4))
	Else
		fWrite(nHandle,cMsg1)
		fWrite(nHandle,cMsg2)
		fWrite(nHandle,MostraErro())
		fclose(nHandle)
	Endif
EndIf
Return()
