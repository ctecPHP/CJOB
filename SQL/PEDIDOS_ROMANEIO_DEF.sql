set statistics io,time on
SELECT C6_PRODUTO,
       C6_DESCRI,
	   B1_ZZFAMIL,
	   C5_NUM,
	   C6_ITEM,
	   C5_CLIENTE,
	   C5_LOJACLI,
	   B1_DESC,
	   C5_ROMANEI,
	   C5_STAPED,
	   A1_ZZROTA,
	   C5_EMISSAO,
	   C5_FECENT,
	   C6_ITEM,
	   C6_QTDVEN-C6_QTDENT SALDO,
	   A1_NOME,
	   A1_COD,
	   A1_EST,
	   A1_MUN,
	   C5_VEND1,
	   A3_NOME,
	   A3_SUPER,
	   C6_VALOR,
	   C5_TPFRETE,
	   C9_QTDLIB RESERVA,
	   C5_ZZOBS1,
	   A1_ZZREDE,
	   A1_ZZOBSER,
	   A1_OBSERV,
	   B1_PESBRU*C6_QTDVEN PESBRUTO,
	   B1_PESO*C6_QTDVEN PESLIQ,
	   A1_TPVEICU,
	   A1_TPFRET,
	   A1_REQAGEN,
	   C9_DTCARRE,
	   A1_ZZPALET,
	   C5_DTAGEN,
	   C5_DTAGEN1,
	   C5_DTAGEN2,
	   C5_HRAGEN,
	   C5_HRAGEN2,
	   C5_HRAGEN3,
	   C5_ZZTIPO 
	   FROM SC5020 C5 
	   INNER JOIN SC6020 AS SC6 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENT AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ = ' ' 
	   INNER JOIN SA1020 AS SA1 ON A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '
	   INNER JOIN SB1020 AS SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' 
	   INNER JOIN SA3020 AS SA3 ON A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' 
	   LEFT JOIN SC9020 AS SC9 ON C9_PEDIDO = SC6.C6_NUM AND C9_ITEM = SC6.C6_ITEM AND C9_PRODUTO = SC6.C6_PRODUTO AND SC9.D_E_L_E_T_ = ' ' AND C9_BLEST = ' ' AND C9_BLCRED = ' ' 
	   WHERE  C5.D_E_L_E_T_ = ' ' 
	   AND C6_QTDVEN-C6_QTDENT > 0 
	   AND C6_NOTA = ' ' 
	   AND C5_EMISSAO BETWEEN '20180701' AND '20190213' 
	   AND C5_CLIENT <> '002268' 
	   AND C6_PRODUTO <> 'VERBA' 
	   AND C6_PRODUTO <> '1000.00.00001' 
	   AND C5_CONTRA <> '3F' 
	   AND C5_ZZTIPO IN ('N','F','X') 
	   AND C6_BLQ <> 'R' 
	   AND B1_TIPO = 'PA' 
	   AND C5_EMISSAO >= '20181014' 