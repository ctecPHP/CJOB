
/*
  STATUS DE PEDIDOS SOBEL
  COMERCIAL        = 'S'
  MARGEM           = 'M'
  CREDITO          = 'C'
  REJEITADO        = 'R'
  AGENDAR          = 'A'
  ADM. PED. VENDA  = 'L'
  LIBERADO         = 'D'
  ROMANEIO         = 'T'
  OUTROS PEDIDOS   = 'O'
  PED. PALLET      = 'P'
  FATURADO         = 'F'
*/

/* CONSULTA PEDIDO NO SC9 - 'PEDIDOS LIBERADOS' */
SELECT * 
FROM SC9020 AS SC9
WHERE C9_PEDIDO = '087287'
AND D_E_L_E_T_ = '*'
GO

/* CONSULTA PEDIDO SC5  - 'PEDIDOS DE VENDA' */
SELECT C5_NUM,
       C5_STAPED,
	     C5_STATUS,
	     C5_CLIENT,
	     C5_ROMANEI
FROM SC5010 
WHERE C5_NUM = '046440'
GO  

/* SP DETALHES DAS COLUNAS */
sp_columns SC1010
GO

/* 
  Liberação para faturamento
  C9_BLEST = 02    
  Remove o '02'
*/

SELECT C5_NUM,
       C5_STAPED
FROM SC5010
WHERE C5_ROMANEI = '000743'