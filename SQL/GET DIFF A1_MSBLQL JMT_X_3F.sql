SELECT IIF(A.A1_MSBLQL = 1, 'ATIVO', 'BLQ') AS A1_MSBLQL_JMT, 
	   IIF(B.A1_MSBLQL = 1, 'ATIVO', 'BLQ') AS A1_MSBLQL_3F,
	   A.A1_COD,
	   A.A1_NOME 
FROM SA1020 A, SA1040 B
WHERE A.A1_COD = B.A1_COD
AND A.D_E_L_E_T_ = ''
AND B.D_E_L_E_T_ = ''
AND A.A1_MSBLQL <> B.A1_MSBLQL

