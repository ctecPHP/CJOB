/* OBSERVAÇÕES DAS ROTINAS 
   Libera Romaneio Para carregamento
   -Tabelas envolvidas ?
    SC9 e ZZQ

    Antes da Liberação de carregamento. 
	SC9 -> C9_BLEST = 02 (Bloqueio de estoque)
	ZZQ -> ZZQ_STATUS = B

	Após Liberação de carregamento. 
	SC9 -> C9_BLEST = ''
	ZZQ -> ZZQ_STATUS = 

   Libera Romaneio Para Faturamento
   -Tabelas envolvidas ?      
    SC9 e ZZQ

    Antes da Liberação de carregamento. 
	SC9 -> C9_BLEST = 02 (Bloqueio de estoque)
	ZZQ -> ZZQ_STATUS = B

	Após Liberação de carregamento. 
	SC9 -> C9_BLEST = ''
	ZZQ -> ZZQ_STATUS = 'L' 

*/


SELECT D_E_L_E_T_,C9_BLEST,*
FROM SC9020 WHERE C9_PEDIDO IN (SELECT C5_NUM FROM SC5020 WHERE C5_ROMANEI = '002908' AND D_E_L_E_T_ = '')
--AND D_E_L_E_T_ = '*'
GO

SELECT C9_BLEST,*
FROM SC9010 WHERE C9_PEDIDO = '050929'
AND D_E_L_E_T_ = ''
--AND D_E_L_E_T_ = '*'
GO

SELECT *
FROM SC6010 WHERE C6_NUM IN (SELECT C5_NUM FROM SC5010 WHERE C5_ROMANEI = '003032' AND D_E_L_E_T_ = '')
AND D_E_L_E_T_ = ''
ORDER BY C6_PRODUTO ASC
GO


SELECT * FROM ZZQ010 
WHERE ZZQ_ROMANE = '003032'
GO

SELECT * 
FROM SC5020 
WHERE C5_NOTA = '000082'
AND D_E_L_E_T_ = ''
GO

SELECT * 
FROM SC6040 
WHERE C6_NOTA = '001999' 
--AND C6_PRODUTO = '1301.15.03X05L'
--AND D_E_L_E_T_ = ''
GO


SELECT * 
FROM SC9040 
WHERE C9_NFISCAL = '001999' 
--AND C6_PRODUTO = '1301.15.03X05L'
--AND D_E_L_E_T_ = ''
GO


SELECT  *
FROM SD2040 
WHERE D2_DOC = '001999'
GO


SELECT * FROM SF2040
WHERE F2_DOC = '001999'
GO


SELECT D_E_L_E_T_,* FROM SC5020 WHERE C5_NUM = '093635'
GO

SELECT D_E_L_E_T_,* FROM SC5040 WHERE C5_NUM = '093635'
GO