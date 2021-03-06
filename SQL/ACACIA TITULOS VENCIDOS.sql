SELECT *
FROM AFVServer_SOBEL_PRD.dbo.TE_TITULO
WHERE CODIGOCLIENTE = '013776.01.01'  ---- esse cara
ORDER BY DATAVENCIMENTO ASC
GO

SELECT RTRIM(LTRIM(A.E1_CLIENTE)) + '.' + A.E1_LOJA + '.' + '01' AS CODIGOCLIENTE, 
       A.E1_NUM AS NRODOCUMENTO, 
       A.E1_PARCELA AS NROPARCELA,
       A.E1_TIPO AS CODIGOTIPODOCUMENTO,
       A.E1_EMISSAO AS DATAEMISSAO, 
       A.E1_VENCTO AS DATAVENCIMENTO, 
       A.E1_VALOR AS VALORORIGINAL, 
       A.E1_SALDO AS SALDOTITULO,
       A.E1_NUMNOTA AS NRONOTAFISCAL, 
       A.E1_VALJUR AS TAXAJUROS,
       A.E1_VALLIQ VALORPAGO,
       A.E1_BAIXA AS DATAPAGO,
       A.E1_VEND1 + '.' + '01' AS CODIGOVENDEDORESP
FROM Protheus_Producao.dbo.SE1010 A
INNER JOIN AFVServer_SOBEL_PRD.dbo.TE_CLIENTE B ON (B.CODIGO COLLATE Latin1_General_CI_AS = RTRIM(LTRIM(A.E1_CLIENTE)) + '.' + A.E1_LOJA + '.' + '04')
WHERE A.E1_STATUS = 'A'
AND A.D_E_L_E_T_ <> '*'
AND A.E1_TIPO = 'NF'
AND A.E1_SALDO <> 0
AND A.E1_CLIENTE = '013776'
GO




--BEGIN TRANSACTION
--UPDATE AFVServer_SOBEL_PRD.dbo.TESP_BLOQTITULOUNIDFAT
--SET FLAGBLOQUEIA = 1
--WHERE CODIGOUNIDFAT = '04'
--GO
--SELECT *
--FROM AFVServer_SOBEL_PRD.dbo.TESP_BLOQTITULOUNIDFAT
--GO
--commit
----ROLLBACK


SELECT * 
FROM AFVServer_SOBEL_PRD.dbo.TESP_BLOQTITULOUNIDFAT

SELECT *
FROM T_TIPOBLOQUEIO
GO

SELECT *
FROM TE_CLIENTE 
WHERE CODIGO =  '015534.01.01'
GO

SELECT *
FROM T_STATUSCLIENTE
GO