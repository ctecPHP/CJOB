SELECT SC5.C5_NUM,
       SC5.C5_QTDPED,
	   SUM(SC6.C6_QTDVEN) AS C6_QTDVEN, 
	   SUM(SD2.D2_QUANT) AS D2_QUANT
FROM SC5040 SC5
INNER JOIN SC6040 SC6 ON (SC5.C5_NUM = SC6.C6_NUM)
LEFT JOIN SD2040 SD2 ON (SD2.D2_PEDIDO = SC5.C5_NUM)
WHERE SC5.D_E_L_E_T_ = ''
AND   SC5.C5_STAPED = 'F'
AND   SC6.D_E_L_E_T_ = ''
AND   SD2.D_E_L_E_T_ = ''
AND   C5_ZZTIPO <> 'L'
GROUP BY SC5.C5_NUM,
         SC5.C5_QTDPED
GO