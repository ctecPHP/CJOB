
/* 
	---------------------------------------------------------------------------------------------------------------------------------------------
	@description 	Consulta saldo em estoque do produto nas empresas Sobel(01), JMT(02) e 3F(04). 		
	@version    	1.0
	@package    
	@author     	Ademilson Nunes
	@copyright  	Sobel Suprema Ind. 
	@license  		 
	----------------------------------------------------------------------------------------------------------------------------------------------
*/
DECLARE @CODPROD AS VARCHAR(14)
SET @CODPROD  = '1401.20.24X500L'

SELECT 	'ITEM'       = @CODPROD,
	   	'DESC' 		 = (SELECT B1_DESC FROM SB1010 WHERE B1_COD = @CODPROD),
	    'QTDE_SOBEL' = (SELECT (B2_QATU - B2_RESERVA - B2_QEMP - B2_QACLASS - B2_QEMPSA - B2_QEMPPRJ - B2_QTNP  - B2_QEMPPRE)  AS SOBEL_QTDE
						FROM SB2010
						WHERE B2_COD = @CODPROD
						AND B2_QATU <> 0 
						AND D_E_L_E_T_ = ''),

	    'QTDE_JMT'   = (SELECT (B2_QATU - B2_RESERVA - B2_QEMP - B2_QACLASS - B2_QEMPSA - B2_QEMPPRJ - B2_QTNP  - B2_QEMPPRE)  AS SOBEL_QTDE
						FROM SB2020
						WHERE B2_COD = @CODPROD
						AND B2_QATU <> 0 
						AND D_E_L_E_T_ = ''),

	  	'QTDE_3F'    = (SELECT (B2_QATU - B2_RESERVA - B2_QEMP - B2_QACLASS - B2_QEMPSA - B2_QEMPPRJ - B2_QTNP  - B2_QEMPPRE)  AS SOBEL_QTDE
						FROM SB2040
						WHERE B2_COD = @CODPROD
						AND B2_QATU <> 0 
						AND D_E_L_E_T_ = '')	
GO





SELECT	A.B1_COD + '.' + '01' AS CODIGO,
	A.B1_GRUPO + '.' + '01' AS CODIGOGRUPOPROD, 
	RTRIM(A.B1_ZZFAMIL) + '.' + '01' AS CODIGOCATEGORIA, 
	RTRIM(B1_DESC) AS DESCRICAO,
	CASE WHEN A.B1_XBLQVEN = 1 THEN 1
	ELSE 2 END AS CODIGOSTATUSPROD,
	A.B1_ZZCODBA AS DUN14,
	A.B1_CODBAR AS EAN13,
	A.B1_PESBRU AS PESOBRUTO, 
	A.B1_PESO AS PESOLIQUIDO, 
	A.B1_QE AS QTDEEMBALAGEM,
	A.B1_UM AS UNIDPRODUTO,
	10.0 AS PERCACRESCMAX,
    CASE WHEN (A.B1_MSBLQL = 1) THEN 0
	     WHEN A.B1_MSBLQL = 2 THEN 1		 
	END AS FLAGUSO,
	CASE WHEN LTRIM(RTRIM(A.B1_COD)) = 'VERBA' THEN 1
	ELSE 0 END AS CESP_FLAGVERBA
FROM Protheus_Producao.dbo.SB1010 A
INNER JOIN T_GRUPOPRODUTO GRP ON (GRP.CODIGO COLLATE Latin1_General_CI_AS = A.B1_GRUPO + '.' + '01')
INNER JOIN T_CATEGORIA CAT ON (CAT.CODIGO COLLATE Latin1_General_CI_AS = RTRIM(A.B1_ZZFAMIL) + '.' + '01')
WHERE A.D_E_L_E_T_ <> '*'
AND A.B1_TIPO = 'PA'
AND A.B1_COD <> '9010.01.01X01U' 
AND A.B1_COD <> '1000.00.00001'