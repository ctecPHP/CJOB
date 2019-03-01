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




/* CONSULTA PEDIDOS DE VENDA POR STATUS */
SELECT C5_NUM,
       C5_STAPED,
       C5_ZZTIPO
FROM SC5010 AS SC5
WHERE C5_STAPED = 'L'
AND D_E_L_E_T_ = ''
GO


/* CONSULTA PEDIDOS DE VENDA POR STATUS */
SELECT C5_NUM,
       C5_CLIENTE,
       C5_STAPED,
       C5_ZZTIPO,
       C5_ROMANEI,
       C5_TPFRETE,
       C5_EMISSAO,
       C5_FECENT
FROM SC5020 SC5
WHERE C5_NUM IN ('091242','045531', '045551')
--WHERE C5_NUM = '091242' --> STATUS DO PEDIDO
--AND C5_STAPED = 'D'  --> CÓDIGO DO CLIENTE
AND D_E_L_E_T_ = ''
GO


/* */
SELECT SC5.C5_NUM,
       SC5.C5_CLIENTE,
       SC5.C5_STAPED,       
       SC5.C5_ZZTIPO,
       SC5.C5_ROMANEI,
       SC5.C5_TPFRETE,
       SC5.C5_EMISSAO,
       SC5.C5_FECENT,
       "TIPO_CARGA" =        
          CASE SA1.A1_ZZPALET
            WHEN '1' THEN 'PALLETIZADA'
            WHEN '2' THEN 'BATIDA'
          END  
FROM SC5020 SC5
INNER JOIN SA1020 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE
--WHERE SC5.C5_NUM   = '900273'
WHERE SC5.C5_NUM IN ('900273','091478', '900274')
--AND C5_STAPED  = 'D' --> STATUS DO PEDIDO
AND SC5.D_E_L_E_T_ = ''
GO


