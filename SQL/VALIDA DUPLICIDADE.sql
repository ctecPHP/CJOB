SELECT C5_HASHPT , COUNT(C5_HASHPT) AS TOT 
FROM SC5020
WHERE D_E_L_E_T_ <> '*' 
AND C5_EMISSAO >= '20190330'
GROUP BY C5_HASHPT
HAVING COUNT(C5_HASHPT) > 1
ORDER BY TOT DESC


SELECT D_E_L_E_T_,
       C5_STAPED, 
       C5_ZZPEDCL, *
FROM SC5040 
WHERE C5_HASHPT = 'W1550304191148554'
GO







SELECT *
FROM SC5040 
WHERE C5_NUM IN ('098482', '098485')
GO

SELECT CODIGOUNIDFAT,  *
FROM T_PEDIDO_SOBEL 
WHERE NUMPEDIDOSOBEL IN ('098482', '098485')
GO