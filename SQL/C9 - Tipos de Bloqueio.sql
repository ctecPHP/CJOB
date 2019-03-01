Como identifico os bloqueios gravados na tabela SC9 nos Pedidos de Venda?

C9_BLCRED

            Significa Liberado:

           01 - Bloqueio de Crédito por Valor   

           04 - Vencimento do Limite de Crédito - Data de Crédito Vencida 

           05 - Bloqueio Manual/Estorno.  

           10 - Significa FATURADO

C9_BLEST

          Significa Liberado:

          02 - Bloqueio de Estoque                        

          03 - Bloqueio Manual de Estoque

(Ocorre quando o Pedido já estava liberado por estoque, e é uma ação do usuário que invalida a liberação (que retorna para bloqueado).

Isso pode ocorrer quando se altera o Pedido de Vendas já liberado, ou quando estorna a liberação em MATA460A - 
Documento de Saída (Ações relacionadas > Estorn. Docs))

          10 - Significa FATURADO

C9_BLWMS

          01 - Bloqueio de Endereçamento do WMS/Somente SB2

          02 - Bloqueio de Endereçamento do WMS             

          03 - Bloqueio de WMS - Externo                 

          05 - Liberação para Bloqueio 01                 

          06 - Liberação para Bloqueio 02    

          07 - Liberação para Bloqueio 03  

Obs	
O campo C9_BLINF traz a informação do bloqueio, exemplo, se C9_BLCRED for igual a "01", C9_BLINF receberá "Bloqueio de Credito por Valor."; enquanto o campo C9_BLTMS

traz o tipo de bloqueio do TMS, se é 10 - Comercial ou 20- Operacional.

Ambos os campos não são utilizados pelo módulo de faturamento, desta forma não possuirão informações se o pedido foi gerado neste módulo.

Os campos em questão são utilizados pelo módulo de TMS, quaisquer dúvidas sobre os mesmos, contatar a equipe de Protheus Logística.
