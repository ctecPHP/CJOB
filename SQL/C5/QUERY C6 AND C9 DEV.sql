SELECT C9_BLEST,D_E_L_E_T_,* 
FROM SC9010
WHERE C9_PEDIDO IN ('048711')
ORDER BY R_E_C_N_O_
GO


SELECT C6_OK, D_E_L_E_T_,*  
FROM SC6010
WHERE C6_NUM = '048711'
ORDER BY R_E_C_N_O_
GO


/*Consulta B2 validar códigos de barras*/
SELECT * FROM SB2010
WHERE B2_COD = '2211.03.06X240'
GO


/*Consulta status Romaneio tabela de romaneios customizada. ZZQ*/
SELECT * FROM ZZQ010
WHERE ZZQ_ROMANE IN ('001732','001722','001769')
GO

