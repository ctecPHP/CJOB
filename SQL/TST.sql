SELECT COUNT(R_E_C_N_O_) AS "JMT" 
FROM SB1020
WHERE D_E_L_E_T_ = ''
GO

SELECT COUNT(R_E_C_N_O_) AS "3F"
FROM SB1040
WHERE D_E_L_E_T_ = ''
GO

SELECT LEFT(B1_COD,5) "TST"
FROM SB1020 
WHERE B1_COD LIKE '3%'
GO