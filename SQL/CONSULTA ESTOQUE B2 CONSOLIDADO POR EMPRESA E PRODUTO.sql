
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
SET @CODPROD  = '1501.24.06X03L'

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

