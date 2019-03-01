
/*  
  C5_STAPED (STATUS DE PEDIDOS SOBEL)
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

/*
C5_TIPO (TIPO PEDIDO)
N-> Pedidos Normais.
D-> Pedidos para Devolução de Compras.
C-> Compl. Preços/Quantidades.(Excl.
P-> Compl. de IPI.
I-> Compl. de ICMS. (Excl. Brasil)  
B-> Apres. Fornec. qdo material p/Benef.
*/

/*
  C5_ZZTIPO(TIPO SOBEL)
  N - NORMAL
  C - CI.PC
  P - C.IPI
  D - D.CPAS
  B - U.FORN
  O - DOA
  F - BONIF.
  V - VERBA
  T - CONT
  A - AMBOS
  L - PALLET
  R - TROCA
  E - FRETE
  S - SUC
  X - ENXOVAL    
*/

/*  
  C5_TPFRETE (TIPO FRETE)  
  C - CIF
  F - FOB
  T - POR CONTA DE TERCEIROS
  R - POR CONTA DO REMETENTE
  D - POR CONTA DO DESTINATÁRIO
  S - S/ FRETE
*/

/*
SELECT C5_NUM,
       C5_STAPED,
       C5_ZZTIPO
FROM SC5020 AS SC5
WHERE C5_ZZTIPO <> 'N'
AND D_E_L_E_T_ = ''
AND C5_STAPED = 'C'
GO
*/


/*
ZZQ, ZZR
Posição do Romaneio

L - Liberado Faturamento
B - Bloqueado
  - Aguardando Liberação
O - Com Ocorrência
F - Faturado/Encerrado  
*/

SELECT SC5.C5_NUM,
       SC5.C5_CLIENTE,
       IIF(SA1.A1_MSBLQL = 1, 'BLOQ','ATIVO') AS STATUS_CLIENTE, --> 1 = Bloqueado | 2 - Ativo       
       SA1.A1_NOME,
       SC5.C5_STAPED,
       SC5.C5_NOTA,
       "STATUS_PEDIDO" =
       CASE SC5.C5_STAPED
          WHEN 'S' THEN 'COMERCIAL' 
          WHEN 'M' THEN 'MARGEM'
          WHEN 'C' THEN 'CREDITO'
          WHEN 'R' THEN 'REJEITADO'
          WHEN 'A' THEN 'AGENDAR'
          WHEN 'L' THEN 'ADM.PED.VENDA'
          WHEN 'D' THEN 'LIBERADO'
          WHEN 'T' THEN 'ROMANEIO' 
          WHEN 'O' THEN 'OUTROS PEDIDOS'
          WHEN 'P' THEN 'PED. PALLET'
          WHEN 'F' THEN 'FATURADO'
       END, 
       SC5.C5_ZZTIPO,          
       "TIPO_PED" = 
       CASE SC5.C5_ZZTIPO
          WHEN 'N' THEN 'NORMAL'
          WHEN 'C' THEN 'CI.PC'
          WHEN 'P' THEN 'C.IPI'
          WHEN 'D' THEN 'D.CPAS'
          WHEN 'B' THEN 'U.FORN'
          WHEN 'O' THEN 'DOA'
          WHEN 'F' THEN 'BONIF.'
          WHEN 'V' THEN 'VERBA'
          WHEN 'T' THEN 'CONT'
          WHEN 'A' THEN 'AMBOS'
          WHEN 'L' THEN 'PALLET'
          WHEN 'R' THEN 'TROCA'
          WHEN 'E' THEN 'FRETE'
          WHEN 'S' THEN 'SUC'
          WHEN 'X' THEN 'ENXOVAL'
      END,    
       SC5.C5_PEDBON,
       SC5.C5_ROMANEI,
       SC5.C5_TPFRETE,
       "TIPO_FRETE" = 
       CASE SC5.C5_TPFRETE
          WHEN 'C' THEN 'CIF'
          WHEN 'F' THEN 'FOB'
       END,   
       SC5.C5_EMISSAO,
       SC5.C5_TRANSP,
       SC5.C5_FECENT,
       SC5.C5_NOTA,
       SC5.C5_ESPECI1,
       SA1.A1_ZZPALET,
       "TIPO_CARGA" =        
          CASE SA1.A1_ZZPALET
            WHEN '1' THEN 'PALLETIZADA'
            WHEN '2' THEN 'BATIDA'
          END  
FROM SC5040 SC5
INNER JOIN SA1040 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE
--WHERE SC5.C5_NUM   = '052568'
WHERE SC5.C5_ROMANEI   = '003730'
--WHERE SC5.C5_NUM IN ('092933','093042')
--AND C5_STAPED  = 'D' --> STATUS DO PEDIDO
AND SC5.D_E_L_E_T_ = ''
GO




SELECT C9_BLEST, * 
FROM SC9010 
WHERE C9_PEDIDO = '052568' AND
D_E_L_E_T_ = ''






//---------------------------------------------------------------------------------------------------------

/*CONSULTA DE CLIENTES*/
SELECT * FROM SA1040 WHERE A1_COD = '016161'
GO


SELECT * FROM SC6010 WHERE C6_NUM IN (SELECT C5_NUM FROM SC5010 WHERE C5_ROMANEI = '002460')
GO


/*QUANTIDADE PRODUTOS*/
SELECT SUM(C6_QTDVEN) AS "TOTAL", SUM(C6_QTDVEN) / 24 AS "TOTAL_CX" FROM SC6010 WHERE C6_NUM IN (SELECT C5_NUM FROM SC5010 WHERE C5_ROMANEI = '002249')
GO

/*35.332 UNIDADES.*/


SELECT * FROM SC5010 
WHERE C5_DTAGEN1 <> ''
GO

sp_columns_ex 'SC5010'
go


//---------------------------------------------------------------------------------------------------------


/** TESTE **/
SELECT SC5.C5_NUM,
       SC5.C5_CLIENTE,
       SC5.C5_STAPED,
       "STATUS_PEDIDO" =
       CASE SC5.C5_STAPED
          WHEN 'S' THEN 'COMERCIAL'
          WHEN 'M' THEN 'MARGEM'
          WHEN 'C' THEN 'CREDITO'
          WHEN 'R' THEN 'REJEITADO'
          WHEN 'A' THEN 'AGENDAR'
          WHEN 'L' THEN 'ADM.PED.VENDA'
          WHEN 'D' THEN 'LIBERADO'
          WHEN 'T' THEN 'ROMANEIO'
          WHEN 'O' THEN 'OUTROS PEDIDOS'
          WHEN 'P' THEN 'PED. PALLET'
          WHEN 'F' THEN 'FATURADO'
       END,           
       SC5.C5_ZZTIPO,
       SC5.C5_ROMANEI,
       SC5.C5_TPFRETE,
       SC5.C5_EMISSAO,
       SC5.C5_TRANSP,
       SC5.C5_FECENT,
       "TIPO_CARGA" =        
          CASE SA1.A1_ZZPALET
            WHEN '1' THEN 'PALLETIZADA'
            WHEN '2' THEN 'BATIDA'
          END  
FROM SC5020 SC5
INNER JOIN SA1020 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE
WHERE  C5_STAPED  <> 'F' --> STATUS DO PEDIDO
AND SC5.C5_NOTA = ''
AND SC5.C5_ROMANEI = ''
AND SC5.C5_ZZTIPO = 'F'
AND SC5.D_E_L_E_T_ = ''
GO


SELECT * 
FROM ZZQ010
WHERE ZZQ_ROMANE = '003194'
GO

SELECT *
FROM ZZR010 
WHERE ZZR_ROMANE = '003243'
GO


SELECT * FROM SC9010 WHERE C9_PEDIDO IN ('095027', '094714', '095027')

SELECT D_E_L_E_T_,* FROM SC9010 WHERE C9_ROMANEI = '003397'



SELECT 

