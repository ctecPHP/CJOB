
USE Protheus_Producao
GO
/* CAB. NF SA�DA */
SELECT DISTINCT RTRIM(SF2.F2_DOC) + '-' + SF2.F2_SERIE AS NUMNOTAFISCAL,
				SF2.F2_EMISSAO AS DATAEMISSAO,
				SF2.F2_CLIENTE + '.' + SF2.F2_LOJA AS CODIGOCLIENTE,
				SF2.F2_VALBRUT AS VALORNOTAFISCAL,
				SF2.F2_ZZTIPO  AS TIPONOTA, -- N - NORMAL - F BONIFICA��O 
				(SELECT C5_NUM FROM SC5010 WHERE C5_NOTA = SF2.F2_DOC) AS NUMPEDIDOEMP,
				NULL           AS MOTIVODEVOLUCAO,
				(SELECT D2_CF FROM SD2010 WHERE D2_DOC = SF2.F2_DOC) AS CODIGONATOPER,
				SF2.F2_COND    AS CODIGOCONDPAGTO,
				SF2.F2_VEND1   AS CODIGOVENDEDORESSP,
				CASE SF2.D_E_L_E_T_ 
         			 WHEN '*' THEN '101'	 
					 ELSE '100'
                END AS STATUSNFE --100 NOTA OK - 101 NOTA CANCELADA
FROM SF2010 SF2 WITH (NOLOCK)
LEFT JOIN SD2010 SD2 WITH (NOLOCK) ON (SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE)
LEFT JOIN SA1010 SA1 WITH (NOLOCK) ON (SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA)
WHERE SF2.F2_EMISSAO >= GETDATE() - 90
  AND SA1.A1_MSBLQL <> 1 -- 1 -SIM 2 - N�O  
  AND SF2.F2_CHVNFE <> '' 
  AND SF2.F2_ZZTIPO IN ('N', 'F') -- N - NORMAL F - BONIFICA��O  

UNION ALL   

/* CAB NF ENTRADA */
SELECT DISTINCT SF1.F1_DOC + '-' + SF1.F1_SERIE AS NUMNOTAFISCAL, 
				SF1.F1_EMISSAO AS DATAEMISSAO,
				SF1.F1_FORNECE + '.' + SF1.F1_LOJA AS CODIGOCLIENTE,
				SF1.F1_VALBRUT AS VALORNOTAFISCAL,
				SF1.F1_TIPO    AS TIPONOTA, -- D DEVOLU��O
				'0'            AS NUMPEDIDOEMP,
				SF3.F3_OBSERV  AS MOTIVODEVOLUCAO,
				SF3.F3_CFO     AS CODIGONATOPER,
				SF1.F1_COND    AS CODIGOCONDPAGTO,
				SA1.A1_VEND    AS CODIGOVENDEDORESSP,
				CASE SF1.D_E_L_E_T_ 
         			 WHEN '*' THEN '101'	 
					 ELSE '100'
                END AS STATUSNFE --100 NOTA OK - 101 NOTA CANCELADA
FROM SF1010 SF1 WITH (NOLOCK) 
LEFT  JOIN SD2010 SD2 WITH (NOLOCK) ON (SF1.F1_DOC = SD2.D2_DOC AND SF1.F1_SERIE = SD2.D2_SERIE )
LEFT  JOIN SF3010 SF3 WITH (NOLOCK) ON (SF1.F1_DOC = SF3.F3_NFISCAL AND SF1.F1_SERIE = SF3.F3_SERIE)
LEFT  JOIN SA1010 SA1 WITH (NOLOCK) ON (SF1.F1_FORNECE = SA1.A1_COD  AND SF1.F1_LOJA = SA1.A1_LOJA) 
WHERE SF1.F1_TIPO = 'D'
AND SF1.F1_EMISSAO >= GETDATE() - 90
GO



SELECT DISTINCT D2_DOC, D2_CF FROM SD2010
WHERE  D_E_L_E_T_ = ''
GROUP BY D2_DOC, 
         D2_CF

ORDER BY D2_DOC ASC 
GO 