#include "protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSOBFAT05  บAutor  ณMicrosiga           บ Data ณ  09/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Relatorio consolidado romaneiro em carteira              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SOBFAT05()

Local aCabExcel :={}
Local aItensExcel :={}
Private cPerg       := "SOBFAT05"                              
If cEmpAnt <> "01"
	MsgAlert("Executar o relatorio pela Sobel")
	Return()
EndIf	

ValidPerg()
pergunte(cPerg,.T.)


AADD(aCabExcel, {"TP" 			,"C", 02, 0})
AADD(aCabExcel, {"TIPO" 		,"C", 02, 0})
AADD(aCabExcel, {"PRODUTO" 		,"C", 15, 0})
AADD(aCabExcel, {"DESCRICAO"	,"C", 40, 0})
AADD(aCabExcel, {"FAMILIA"  	,"C", 04, 0})
AADD(aCabExcel, {"NUM.PEDIDO" 	,"C", 06, 0})
AADD(aCabExcel, {"ROMANEIO" 	,"C", 06, 0})
AADD(aCabExcel, {"EMISSAO" 		,"C", 10, 0})
AADD(aCabExcel, {"ENTREGA" 		,"C", 10, 0})
//AADD(aCabExcel, {"DT.PREVISTA.EXPEDICAO" 		,"C", 10, 0})
AADD(aCabExcel, {"ITEM" 		,"C", 03, 0})
AADD(aCabExcel, {"SALDO" 		,"C", 10, 0})
AADD(aCabExcel, {"COD.CLIENTE"  ,"C", 06, 0})
AADD(aCabExcel, {"CLIENTE" 		,"C", 40, 0})
AADD(aCabExcel, {"REDE"  		,"C", 50, 0})
AADD(aCabExcel, {"ESTADO" 		,"C", 06, 0})
AADD(aCabExcel, {"MUNICIPIO" 	,"C", 20, 0})
AADD(aCabExcel, {"COD.VEND" 	,"C", 08, 0})
AADD(aCabExcel, {"VENDEDOR" 	,"C", 40, 0})
AADD(aCabExcel, {"COD.SUPER" 	,"C", 08, 0})
AADD(aCabExcel, {"SUPERVISOR" 	,"C", 40, 0})
AADD(aCabExcel, {"TIPO.FRETE" 	,"C", 30, 0})          
AADD(aCabExcel, {"RESERVA" 		,"C", 10, 0})
AADD(aCabExcel, {"STATUS"		,"C", 25, 0})
AADD(aCabExcel, {"ROTA" 		,"C", 50, 0})
AADD(aCabExcel, {"PESO.LIQUIDO"	,"C", 10, 0})
AADD(aCabExcel, {"PESO.BRUTO"	,"C", 10, 0})
AADD(aCabExcel, {"TP.VEICULO" 	,"C", 30, 0})
AADD(aCabExcel, {"OBS.PEDIDO"	,"C",100, 0})
AADD(aCabExcel, {"OBS.SOBEL"	,"C",100, 0})
AADD(aCabExcel, {"OBS.PROTHEUS"	,"C",100, 0})
AADD(aCabExcel, {"REQ.AGENDA"	,"C", 01, 0})
AADD(aCabExcel, {"DT.AGENDAMENTO 1"		,"C", 10, 0})
AADD(aCabExcel, {"HORA.AGENDAMENTO 1"	,"C", 10, 0})
AADD(aCabExcel, {"DT.AGENDAMENTO 2"		,"C", 10, 0})
AADD(aCabExcel, {"HORA.AGENDAMENTO 2"	,"C", 10, 0})
AADD(aCabExcel, {"DT.AGENDAMENTO 3"		,"C", 10, 0})
AADD(aCabExcel, {"HORA.AGENDAMENTO 3"	,"C", 10, 0})
AADD(aCabExcel, {"DT.CARREGAMENTO"		,"C", 10, 0})
AADD(aCabExcel, {"TRANSP.ROMANEIO"		,"C", 10, 0})
AADD(aCabExcel, {"DESCRICAO.TRANSP.ROMANEIO","C", 50, 0})
AADD(aCabExcel, {"TIPO.VEICULO"			,"C", 30, 0})
AADD(aCabExcel, {"TIPO.CARGA"			,"C", 30, 0})
AADD(aCabExcel, {""						,"C", 01, 0})


MsgRun("Favor Aguardar.....", "Selecionando os Registros",{|| GProcItens(aCabExcel, @aItensExcel)})

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS","ROMANEIO",aCabExcel,aItensExcel}})})

Return


Static Function GProcItens(aHeader, aCols)

Local aItem		:= {}
Local cTMP  	:= GetNextAlias()
Local cTMP2 	:= GetNextAlias()
Local cDataE    := DtoS(dDataBase-120)

cCampos	:= " C6_PRODUTO, C6_DESCRI, B1_ZZFAMIL, C5_NUM, C6_ITEM, C5_CLIENTE, C5_LOJACLI, B1_DESC, C5_ROMANEI,C5_STAPED,A1_ZZROTA, C5_EMISSAO, "
cCampos	+= " C5_FECENT,C6_ITEM,C6_QTDVEN-C6_QTDENT SALDO,A1_NOME, A1_COD,A1_EST,A1_MUN,C5_VEND1,A3_NOME,A3_SUPER,C6_VALOR,C5_TPFRETE,C9_QTDLIB RESERVA, "
cCampos	+= " C5_ZZOBS1 ,A1_ZZREDE, A1_ZZOBSER, A1_OBSERV,B1_PESBRU*C6_QTDVEN PESBRUTO,B1_PESO*C6_QTDVEN PESLIQ,A1_TPVEICU,A1_TPFRET, A1_REQAGEN, "
cCampos	+= " C9_DTCARRE,A1_ZZPALET,C5_DTAGEN,C5_DTAGEN1,C5_DTAGEN2,C5_HRAGEN,C5_HRAGEN2,C5_HRAGEN3,C5_ZZTIPO "


//cQuery += " (SELECT ZZ2_ROMANE FROM ZZ2010 ZZ2 WHERE ZZ2.D_E_L_E_T_ = '' AND C5_NUM = ZZ2_PEDIDO AND ZZ2_EMP = '01') ROMANEIO, "
//cQuery += " (SELECT C9_QTDLIB  FROM SC9010 C9  WHERE C9.D_E_L_E_T_ = ''  AND C9_BLEST 	= '' AND C9_BLCRED = '' " 
//cQuery += "  AND C9_PEDIDO 	= C6.C6_NUM  AND C9_ITEM 	= C6.C6_ITEM  AND C9_PRODUTO	= C6.C6_PRODUTO) RESERVA,  "

cQuery := " SELECT	"+cCampos
cQuery += " FROM SC5010 C5 "
cQuery += " INNER JOIN SC6010 AS SC6 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENT AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA1010 AS SA1 ON A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SB1010 AS SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA3010 AS SA3 ON A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SC9010 AS SC9 ON C9_PEDIDO = SC6.C6_NUM AND C9_ITEM = SC6.C6_ITEM AND C9_PRODUTO = SC6.C6_PRODUTO AND SC9.D_E_L_E_T_ = ' ' AND C9_BLEST 	= '' AND C9_BLCRED = '' "
cQuery += " WHERE C5.D_E_L_E_T_ = '' "
cQuery += " AND C6_QTDVEN-C6_QTDENT > 0 "
cQuery += " AND C6_NOTA = '' "  
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
cQuery += " AND C5_CLIENT <> '002268'  "
cQuery += " AND C5_CLIENT <> '015699'  "
cQuery += " AND C6_PRODUTO <> 'VERBA' "    
cQuery += " AND C6_PRODUTO <> '1000.00.00001' "                  
cQuery += " AND C5_ZZTIPO IN ('N','F','X') "
cQuery += " AND C6_BLQ <> 'R' "
cQuery += " AND B1_TIPO = 'PA' "
cQuery += " AND C5_EMISSAO >= '"+cDataE+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTMP,.T.,.T.)

dbSelectArea(cTMP)
While (cTMP)->(!Eof())
/*	
	cQuery := " SELECT	* "
	cQuery += " FROM SC9010 C9 "
	cQuery += " WHERE C9.D_E_L_E_T_ = '' "
	cQuery += " AND C9_BLEST 	= '' AND C9_BLCRED = '' "
	cQuery += " AND C9_PEDIDO 	= '"+(cTMP)->C5_NUM+"' "
	cQuery += " AND C9_ITEM 	= '"+(cTMP)->C6_ITEM+"' "
	cQuery += " AND C9_CLIENTE	= '"+(cTMP)->C5_CLIENTE+"' "
	cQuery += " AND C9_LOJA 	= '"+(cTMP)->C5_LOJACLI+"' "
	cQuery += " AND C9_PRODUTO	= '"+(cTMP)->C6_PRODUTO+"' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTMP2,.T.,.T.)
	dbSelectArea(cTMP2)
	If (cTMP2)->(!Eof())
		nReser	:= (cTMP2)->C9_QTDLIB
	Else
		nReser	:= 0
	Endif
	
	(cTMP2)->(dbCloseArea())
	*/
	If (cTMP)->A1_TPFRET == "C"
		cTpFret	:= "CIF"
	ElseIf (cTMP)->A1_TPFRET == "F"
		cTpFret	:= "FOB"
	ElseIf (cTMP)->A1_TPFRET == "T"
		cTpFret	:= "POR CONTA DE TERCEIROS"
	ElseIf (cTMP)->A1_TPFRET == "R"
		cTpFret	:= "POR CONTA DO REMETENTE"
	ElseIf (cTMP)->A1_TPFRET == "D"
		cTpFret	:= "POR CONTA DO DESTINATARIO"
	ElseIf (cTMP)->A1_TPFRET == "S"
		cTpFret	:= "SEM FRETE"
	Else
		cTpFret	:= ""
	EndIf

	If (cTMP)->C5_STAPED == "S"
     	cStatus	:= "BLOQUEIO COMERCIAL" 
	ElseIf (cTMP)->C5_STAPED == "M"
     	cStatus	:= "MARGEM" 
	ElseIf (cTMP)->C5_STAPED == "C"
     	cStatus	:= "CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "A"
     	cStatus	:= "AGENDAR" 
	ElseIf (cTMP)->C5_STAPED == "P"
     	cStatus	:= "PALLET" 
	ElseIf (cTMP)->C5_STAPED == "O"
     	cStatus	:= "OUTROS" 
	ElseIf (cTMP)->C5_STAPED == "R"
     	cStatus	:= "REJEITADO CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "L"
     	cStatus	:= "ADM. PEDIDO" 
	ElseIf (cTMP)->C5_STAPED == "D"
     	cStatus	:= "LIB P/ GERAR ROM" 
	ElseIf (cTMP)->C5_STAPED == "T"
     	cStatus	:= "EM ROMANEIO" 
	ElseIf (cTMP)->C5_STAPED == "F"
     	cStatus	:= "FATURADO/ENCERRADO" 
	Else
		cStatus	:= "" 
	EndIf	
	
	DbSelectArea("DUT")
	DUT->(DbSetOrder(1))
	If DUT->(DbSeek(xFilial("DUT")+(cTMP)->A1_TPVEICU))
		cTpVei	:= DUT->DUT_DESCRI
	Else
		cTpVei	:= ""
	EndIf
	       
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+(cTMP)->A3_SUPER))
		cSuper	:= SA3->A3_NOME
	EndIf

	DbSelectArea("ZZQ")
	ZZQ->(DbSetOrder(1))
	If ZZQ->(DbSeek(xFilial("ZZQ")+(cTMP)->C5_ROMANEI))
		cTraCR	:= ZZQ->ZZQ_TRANSP
		cTraDR	:= ZZQ->ZZQ_DESTRA
		SDtCar	:= DtoS(ZZQ->ZZQ_DTCARR)
		cTpVeic	:= ZZQ->ZZQ_DESVEI
	Else                          
		cTraCR	:= ""
		cTraDR	:= ""                 
		SDtCar	:= "" 
		cTpVeic	:= ""
	EndIf

	If (cTMP)->A1_ZZPALET == "1"
		cTpCarg	:= "BATIDO"                                                                                                                    
	ElseIf (cTMP)->A1_ZZPALET == "2"
		cTpCarg	:= "PALETIZADO"
	Else	
		cTpCarg	:= ""
	EndIf	                                       
/*
	dDtA1	:= IIF(Empty((cTMP)->C5_DTAGEN),StoD("20000101"),StoD((cTMP)->C5_DTAGEN))
	dDtA2	:= IIF(Empty((cTMP)->C5_DTAGEN1),StoD("20000101"),StoD((cTMP)->C5_DTAGEN1))
	dDtA3	:= IIF(Empty((cTMP)->C5_DTAGEN2),StoD("20000101"),StoD((cTMP)->C5_DTAGEN2))
	
	dDtAgen := Max(dDtA1,dDtA2,dDtA3)	//,C5_HRAGEN,C5_HRAGEN2,C5_HRAGEN3		
    
    If DateDiffDay(dDtAgen,StoD("20000101")) >= 1
		dDtAgen	:= DtoS(dDtAgen)
		If dDtAgen == (cTMP)->C5_DTAGEN
			cHrAgen	:= (cTMP)->C5_HRAGEN
		ElseIf dDtAgen == (cTMP)->C5_DTAGEN1 
			cHrAgen	:= (cTMP)->C5_HRAGEN2
		ElseIf dDtAgen == (cTMP)->C5_DTAGEN2 
			cHrAgen	:= (cTMP)->C5_HRAGEN3
		Else
			cHrAgen	:= ""
		EndIf
	Else                 
		cHrAgen	:= "" 
		dDtAgen	:= ""
	EndIf	
  */		
	aItem	:= {"PVS",IIF((cTMP)->C5_ZZTIPO == "N","NORMAL","BONIFICACAO"),(cTMP)->C6_PRODUTO,(cTMP)->B1_DESC,chr(160)+(cTMP)->B1_ZZFAMIL,chr(160)+(cTMP)->C5_NUM,chr(160)+(cTMP)->C5_ROMANEI,;
	SubStr((cTMP)->C5_EMISSAO,7,2)+"/"+SubStr((cTMP)->C5_EMISSAO,5,2)+"/"+SubStr((cTMP)->C5_EMISSAO,1,4),;
	SubStr((cTMP)->C5_FECENT,7,2)+"/"+SubStr((cTMP)->C5_FECENT,5,2)+"/"+SubStr((cTMP)->C5_FECENT,1,4),;
	chr(160)+(cTMP)->C6_ITEM,(cTMP)->SALDO,chr(160)+(cTMP)->A1_COD,(cTMP)->A1_NOME,(cTMP)->A1_ZZREDE,(cTMP)->A1_EST,(cTMP)->A1_MUN,;
	(cTMP)->C5_VEND1,(cTMP)->A3_NOME,(cTMP)->A3_SUPER,cSuper, cTpFret,Transform((cTMP)->RESERVA,"@e 9,999,999.99"),;
	cStatus,(cTMP)->A1_ZZROTA,Transform((cTMP)->PESBRUTO,"@e 9,999,999.99"),Transform((cTMP)->PESLIQ,"@e 9,999,999.99"),;
	cTpVei,(cTMP)->C5_ZZOBS1,(cTMP)->A1_ZZOBSER, (cTMP)->A1_OBSERV,(cTMP)->A1_REQAGEN,;
	SubStr((cTMP)->C5_DTAGEN ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN,1,4),;
	SubStr((cTMP)->C5_HRAGEN,1,2)+":"+SubStr((cTMP)->C5_HRAGEN,3,2),;
	SubStr((cTMP)->C5_DTAGEN1  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN1  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN1 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN2,1,2)+":"+SubStr((cTMP)->C5_HRAGEN2,3,2),;
	SubStr((cTMP)->C5_DTAGEN2  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN2  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN2 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN3,1,2)+":"+SubStr((cTMP)->C5_HRAGEN3,3,2),;
	SubStr(SDtCar,7,2)+"/"+SubStr(SDtCar,5,2)+"/"+SubStr(SDtCar,1,4),;
	chr(160)+cTraCR,cTraDR,cTpVeic,cTpCarg,""} 
	//	SubStr((cTMP)->C5_XXXXXX,7,2)+"/"+SubStr((cTMP)->C5_XXXXX,5,2)+"/"+SubStr((cTMP)->C5_XXXXX,1,4),; ,A1_TPVEICU,DUT_DESCRI
	AADD(aCols,aItem)
	(cTMP)->(dbSkip())
	
EndDo

(cTMP)->(dbCloseArea())

//JMT                        
cQuery := " SELECT	"+cCampos
cQuery += " FROM SC5020 C5 "
cQuery += " INNER JOIN SC6020 AS SC6 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENT AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA1020 AS SA1 ON A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SB1020 AS SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA3020 AS SA3 ON A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SC9020 AS SC9 ON C9_PEDIDO = SC6.C6_NUM AND C9_ITEM = SC6.C6_ITEM AND C9_PRODUTO = SC6.C6_PRODUTO AND SC9.D_E_L_E_T_ = ' ' AND C9_BLEST 	= '' AND C9_BLCRED = '' "
cQuery += " WHERE C5.D_E_L_E_T_ = '' "
cQuery += " AND C6_QTDVEN-C6_QTDENT > 0 "
cQuery += " AND C6_NOTA = '' "    
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
cQuery += " AND C5_CLIENT <> '002268'  "
cQuery += " AND C6_PRODUTO <> 'VERBA' "                        
cQuery += " AND C6_PRODUTO <> '1000.00.00001' "                  
cQuery += " AND C5_CONTRA <> '3F' "	//PEDIDOS TRANSFERIDOS PARA A EMPRESA 3F
cQuery += " AND C5_ZZTIPO IN ('N','F','X') "
cQuery += " AND C6_BLQ <> 'R' "
cQuery += " AND B1_TIPO = 'PA' "
cQuery += " AND C5_EMISSAO >= '"+cDataE+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTMP,.T.,.T.)

dbSelectArea(cTMP)
While (cTMP)->(!Eof())
/*
	cQuery := " SELECT	* "
	cQuery += " FROM SC9020 C9 "
	cQuery += " WHERE C9.D_E_L_E_T_ = '' "
	cQuery += " AND C9_BLEST 	= '' AND C9_BLCRED = '' "
	cQuery += " AND C9_PEDIDO 	= '"+(cTMP)->C5_NUM+"' "
	cQuery += " AND C9_ITEM 	= '"+(cTMP)->C6_ITEM+"' "
	cQuery += " AND C9_CLIENTE	= '"+(cTMP)->C5_CLIENTE+"' "
	cQuery += " AND C9_LOJA 	= '"+(cTMP)->C5_LOJACLI+"' "
	cQuery += " AND C9_PRODUTO	= '"+(cTMP)->C6_PRODUTO+"' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTMP2,.T.,.T.)
	dbSelectArea(cTMP2)
	If (cTMP2)->(!Eof())
		nReser	:= (cTMP2)->C9_QTDLIB
	Else
		nReser	:= 0
	Endif
	
	(cTMP2)->(dbCloseArea())
 */	
	If (cTMP)->A1_TPFRET == "C"
		cTpFret	:= "CIF"
	ElseIf (cTMP)->A1_TPFRET == "F"
		cTpFret	:= "FOB"
	ElseIf (cTMP)->A1_TPFRET == "T"
		cTpFret	:= "POR CONTA DE TERCEIROS"
	ElseIf (cTMP)->A1_TPFRET == "R"
		cTpFret	:= "POR CONTA DO REMETENTE"
	ElseIf (cTMP)->A1_TPFRET == "D"
		cTpFret	:= "POR CONTA DO DESTINATARIO"
	ElseIf (cTMP)->A1_TPFRET == "S"
		cTpFret	:= "SEM FRETE"
	Else
		cTpFret	:= ""
	EndIf

	If (cTMP)->C5_STAPED == "S"
     	cStatus	:= "BLOQUEIO COMERCIAL" 
	ElseIf (cTMP)->C5_STAPED == "M"
     	cStatus	:= "MARGEM" 
	ElseIf (cTMP)->C5_STAPED == "C"
     	cStatus	:= "CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "A"
     	cStatus	:= "AGENDAR" 
	ElseIf (cTMP)->C5_STAPED == "P"
     	cStatus	:= "PALLET" 
	ElseIf (cTMP)->C5_STAPED == "O"
     	cStatus	:= "OUTROS" 
	ElseIf (cTMP)->C5_STAPED == "R"
     	cStatus	:= "REJEITADO CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "L"
     	cStatus	:= "ADM. PEDIDO" 
	ElseIf (cTMP)->C5_STAPED == "D"
     	cStatus	:= "LIB P/ GERAR ROM" 
	ElseIf (cTMP)->C5_STAPED == "T"
     	cStatus	:= "EM ROMANEIO" 
	ElseIf (cTMP)->C5_STAPED == "F"
     	cStatus	:= "FATURADO/ENCERRADO" 
	Else
		cStatus	:= "" 
	EndIf	

	DbSelectArea("DUT")
	DUT->(DbSetOrder(1))
	If DUT->(DbSeek(xFilial("DUT")+(cTMP)->A1_TPVEICU))
		cTpVei	:= DUT->DUT_DESCRI
	Else
		cTpVei	:= ""
	EndIf
	    
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+(cTMP)->A3_SUPER))
		cSuper	:= SA3->A3_NOME
	EndIf
	 
	DbSelectArea("ZZQ")
	ZZQ->(DbSetOrder(1))
	If ZZQ->(DbSeek(xFilial("ZZQ")+(cTMP)->C5_ROMANEI))
		cTraCR	:= ZZQ->ZZQ_TRANSP
		cTraDR	:= ZZQ->ZZQ_DESTRA
		SDtCar	:= DtoS(ZZQ->ZZQ_DTCARR)
	Else                          
		cTraCR	:= ""
		cTraDR	:= ""                 
		SDtCar	:= ""
	EndIf


	aItem	:= {"PVJ",IIF((cTMP)->C5_ZZTIPO == "N","NORMAL","BONIFICACAO"),(cTMP)->C6_PRODUTO,(cTMP)->B1_DESC,chr(160)+(cTMP)->B1_ZZFAMIL,chr(160)+(cTMP)->C5_NUM,chr(160)+(cTMP)->C5_ROMANEI,;
	SubStr((cTMP)->C5_EMISSAO,7,2)+"/"+SubStr((cTMP)->C5_EMISSAO,5,2)+"/"+SubStr((cTMP)->C5_EMISSAO,1,4),;
	SubStr((cTMP)->C5_FECENT,7,2)+"/"+SubStr((cTMP)->C5_FECENT,5,2)+"/"+SubStr((cTMP)->C5_FECENT,1,4),;
	chr(160)+(cTMP)->C6_ITEM,(cTMP)->SALDO,chr(160)+(cTMP)->A1_COD,(cTMP)->A1_NOME,(cTMP)->A1_ZZREDE,(cTMP)->A1_EST,(cTMP)->A1_MUN,;
	(cTMP)->C5_VEND1,(cTMP)->A3_NOME,(cTMP)->A3_SUPER,cSuper, cTpFret,Transform((cTMP)->RESERVA,"@e 9,999,999.99"),;
	cStatus,(cTMP)->A1_ZZROTA,Transform((cTMP)->PESBRUTO,"@e 9,999,999.99"),Transform((cTMP)->PESLIQ,"@e 9,999,999.99"),;
	cTpVei,(cTMP)->C5_ZZOBS1,(cTMP)->A1_ZZOBSER, (cTMP)->A1_OBSERV,(cTMP)->A1_REQAGEN,;
	SubStr((cTMP)->C5_DTAGEN ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN,1,4),;
	SubStr((cTMP)->C5_HRAGEN,1,2)+":"+SubStr((cTMP)->C5_HRAGEN,3,2),;
	SubStr((cTMP)->C5_DTAGEN1  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN1  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN1 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN2,1,2)+":"+SubStr((cTMP)->C5_HRAGEN2,3,2),;
	SubStr((cTMP)->C5_DTAGEN2  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN2  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN2 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN3,1,2)+":"+SubStr((cTMP)->C5_HRAGEN3,3,2),;
	SubStr(SDtCar,7,2)+"/"+SubStr(SDtCar,5,2)+"/"+SubStr(SDtCar,1,4),;
	chr(160)+cTraCR,cTraDR,cTpVeic,cTpCarg,""} 

	                                                                                                   //	SubStr((cTMP)->C5_XXXXX,7,2)+"/"+SubStr((cTMP)->C5_XXXXX,5,2)+"/"+SubStr((cTMP)->C5_XXXXX,1,4),;
	AADD(aCols,aItem)
	(cTMP)->(dbSkip())
	
EndDo

(cTMP)->(dbCloseArea())
     
//3F
cQuery := " SELECT	"+cCampos
cQuery += " FROM SC5040 C5 "
cQuery += " INNER JOIN SC6040 AS SC6 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENT AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA1040 AS SA1 ON A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SB1040 AS SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN SA3040 AS SA3 ON A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SC9040 AS SC9 ON C9_PEDIDO = SC6.C6_NUM AND C9_ITEM = SC6.C6_ITEM AND C9_PRODUTO = SC6.C6_PRODUTO AND SC9.D_E_L_E_T_ = ' ' AND C9_BLEST 	= '' AND C9_BLCRED = '' "
cQuery += " WHERE C5.D_E_L_E_T_ = '' "
cQuery += " AND C6_QTDVEN-C6_QTDENT > 0 "
cQuery += " AND C6_NOTA = '' "  
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
cQuery += " AND C5_CLIENT <> '002268'  "
cQuery += " AND C6_PRODUTO <> 'VERBA' " 
cQuery += " AND C6_PRODUTO <> '1000.00.00001' "                  
cQuery += " AND C5_ZZTIPO IN ('N','F','X') "
cQuery += " AND C6_BLQ <> 'R' "
cQuery += " AND B1_TIPO = 'PA' "
cQuery += " AND C5_EMISSAO >= '"+cDataE+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTMP,.T.,.T.)

dbSelectArea(cTMP)
While (cTMP)->(!Eof())

	If (cTMP)->A1_TPFRET == "C"
		cTpFret	:= "CIF"
	ElseIf (cTMP)->A1_TPFRET == "F"
		cTpFret	:= "FOB"
	ElseIf (cTMP)->A1_TPFRET == "T"
		cTpFret	:= "POR CONTA DE TERCEIROS"
	ElseIf (cTMP)->A1_TPFRET == "R"
		cTpFret	:= "POR CONTA DO REMETENTE"
	ElseIf (cTMP)->A1_TPFRET == "D"
		cTpFret	:= "POR CONTA DO DESTINATARIO"                     
	ElseIf (cTMP)->A1_TPFRET == "S"
		cTpFret	:= "SEM FRETE"
	Else
		cTpFret	:= ""
	EndIf

	If (cTMP)->C5_STAPED == "S"
     	cStatus	:= "BLOQUEIO COMERCIAL" 
	ElseIf (cTMP)->C5_STAPED == "M"
     	cStatus	:= "MARGEM" 
	ElseIf (cTMP)->C5_STAPED == "C"
     	cStatus	:= "CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "A"
     	cStatus	:= "AGENDAR" 
	ElseIf (cTMP)->C5_STAPED == "P"
     	cStatus	:= "PALLET" 
	ElseIf (cTMP)->C5_STAPED == "O"
     	cStatus	:= "OUTROS" 
	ElseIf (cTMP)->C5_STAPED == "R"
     	cStatus	:= "REJEITADO CREDITO" 
	ElseIf (cTMP)->C5_STAPED == "L"
     	cStatus	:= "ADM. PEDIDO" 
	ElseIf (cTMP)->C5_STAPED == "D"
     	cStatus	:= "LIB P/ GERAR ROM" 
	ElseIf (cTMP)->C5_STAPED == "T"
     	cStatus	:= "EM ROMANEIO" 
	ElseIf (cTMP)->C5_STAPED == "F"
     	cStatus	:= "FATURADO/ENCERRADO" 
	Else
		cStatus	:= "" 
	EndIf	

	DbSelectArea("DUT")
	DUT->(DbSetOrder(1))
	If DUT->(DbSeek(xFilial("DUT")+(cTMP)->A1_TPVEICU))
		cTpVei	:= DUT->DUT_DESCRI
	Else
		cTpVei	:= ""
	EndIf
	    
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+(cTMP)->A3_SUPER))
		cSuper	:= SA3->A3_NOME
	EndIf
	
	DbSelectArea("ZZQ")
	ZZQ->(DbSetOrder(1))
	If ZZQ->(DbSeek(xFilial("ZZQ")+(cTMP)->C5_ROMANEI))
		cTraCR	:= ZZQ->ZZQ_TRANSP
		cTraDR	:= ZZQ->ZZQ_DESTRA
		SDtCar	:= DtoS(ZZQ->ZZQ_DTCARR)
	Else                          
		cTraCR	:= ""
		cTraDR	:= ""                 
		SDtCar	:= ""
	EndIf

	
	aItem	:= {"PV3F",IIF((cTMP)->C5_ZZTIPO == "N","NORMAL","BONIFICACAO"),(cTMP)->C6_PRODUTO,(cTMP)->B1_DESC,chr(160)+(cTMP)->B1_ZZFAMIL,chr(160)+(cTMP)->C5_NUM,chr(160)+(cTMP)->C5_ROMANEI,;
	SubStr((cTMP)->C5_EMISSAO,7,2)+"/"+SubStr((cTMP)->C5_EMISSAO,5,2)+"/"+SubStr((cTMP)->C5_EMISSAO,1,4),;
	SubStr((cTMP)->C5_FECENT,7,2)+"/"+SubStr((cTMP)->C5_FECENT,5,2)+"/"+SubStr((cTMP)->C5_FECENT,1,4),;
	chr(160)+(cTMP)->C6_ITEM,(cTMP)->SALDO,chr(160)+(cTMP)->A1_COD,(cTMP)->A1_NOME,(cTMP)->A1_ZZREDE,(cTMP)->A1_EST,(cTMP)->A1_MUN,;
	(cTMP)->C5_VEND1,(cTMP)->A3_NOME,(cTMP)->A3_SUPER,cSuper, cTpFret,Transform((cTMP)->RESERVA,"@e 9,999,999.99"),;
	cStatus,(cTMP)->A1_ZZROTA,Transform((cTMP)->PESBRUTO,"@e 9,999,999.99"),Transform((cTMP)->PESLIQ,"@e 9,999,999.99"),;
	cTpVei,(cTMP)->C5_ZZOBS1,(cTMP)->A1_ZZOBSER, (cTMP)->A1_OBSERV,(cTMP)->A1_REQAGEN,;
	SubStr((cTMP)->C5_DTAGEN ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN,1,4),;
	SubStr((cTMP)->C5_HRAGEN,1,2)+":"+SubStr((cTMP)->C5_HRAGEN,3,2),;
	SubStr((cTMP)->C5_DTAGEN1  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN1  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN1 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN2,1,2)+":"+SubStr((cTMP)->C5_HRAGEN2,3,2),;
	SubStr((cTMP)->C5_DTAGEN2  ,7,2)+"/"+SubStr((cTMP)->C5_DTAGEN2  ,5,2)+"/"+SubStr((cTMP)->C5_DTAGEN2 ,1,4),;
	SubStr((cTMP)->C5_HRAGEN3,1,2)+":"+SubStr((cTMP)->C5_HRAGEN3,3,2),;
	SubStr(SDtCar,7,2)+"/"+SubStr(SDtCar,5,2)+"/"+SubStr(SDtCar,1,4),;
	chr(160)+cTraCR,cTraDR,cTpVeic,cTpCarg,""} 

	       //	SubStr((cTMP)->C9_DTCARRE,7,2)+"/"+SubStr((cTMP)->C9_DTCARRE,5,2)+"/"+SubStr((cTMP)->C9_DTCARRE,1,4),;
	AADD(aCols,aItem)
	(cTMP)->(dbSkip())
	
EndDo

(cTMP)->(dbCloseArea())

Return
Static Function ValidPerg


U_XPutSx1(cPerg,"01","Emis De?"		,"","","mv_ch1","D",08,0,0,"C","","","","",   "mv_par01","","","","","","","","","","","","","","","","","","","","")
U_XPutSx1(cPerg,"02","Emis Ate?"	,"","","mv_ch2","D",08,0,0,"C","","","","",   "mv_par02","","","","","","","","","","","","","","","","","","","","")
Return()