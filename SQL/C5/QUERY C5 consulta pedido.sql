USE Protheus_Producao
SELECT C5_NUM,
       C5_STAPED,
       C5_ZZTIPO,
       C5_ROMANEI
FROM SC5010 AS SC5
WHERE C5_NUM IN ('046996', '046998', '047003','900294')
AND D_E_L_E_T_ = ''
GO