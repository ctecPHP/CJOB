/* 
	---------------------------------------------------------------
	@description 	Ajusta custo nas tabelas SD1 e SD2 		
	@version    	1.0
	@package    
	@author     	Ademilson Nunes
	@copyright  
	@license  
	@recomendação SCRIPT Educativo, nunca rodar em produção sem validar em teste antes.
	---------------------------------------------------------------
*/

DECLARE @VLRMOEDA2 AS FLOAT
SET @VLRMOEDA2 = 3.66 --> COTAÇÃO ATUAL DO DOLAR

BEGIN TRANSACTION

/* AJUSTA CUSTO EM SD1 ITENS DE NOTA FISCAL DE ENTRADA - USANDO COMO BASE B1_UPRC */
UPDATE SD1040 SET D1_CUSTO  = (SELECT D1_QUANT  * (SELECT B1_UPRC FROM SB1040 WHERE B1_COD = D1_COD)),
				  D1_CUSTO2 = (SELECT (D1_QUANT * (SELECT B1_UPRC FROM SB1040 WHERE B1_COD = D1_COD) / @VLRMOEDA2))

/* AJUSTA CUSTO EM SDS ITENS DE NOTA FISCAL DE SAÍDA - USANDO COMO BASE B1_UPRC */
UPDATE SD2040 SET D2_CUSTO1  = (SELECT D2_QUANT * (SELECT B1_UPRC FROM SB1040 WHERE B1_COD = D2_COD)),
				  D2_CUSTO2  = (SELECT (D2_QUANT * (SELECT B1_UPRC FROM SB1040 WHERE B1_COD = D2_COD) / @VLRMOEDA2))

--ROLLBACK
GO

/* VALIDAR RESULTADO DO UPDATE SD1 */
SELECT * FROM SD1040
GO

/*VALIDAR RESULTADO DO UPDATE SD2*/
SELECT * FROM SD2040
GO

/* CASO O RESULTADO ESTEJA OK DESCOMENTAR E EXECUTAR O COMANDO A BAIXO */
--COMMIT

/* CASO O RESULTADO NÃO ESTEJA DENTRO DO PREVISTO  SELECIONAR O SCRIPT DA LINHA 1 ATÉ A LINHA 26 JUNTO AO COMANDO ROLLBACK 
   PARA DESFAZER AS ALTERAÇÕES NA BASE DE DADOS.  
*/


/*
	APÓS RODAR O SCRIPT, EXECUTAR AS ROTINAS DO PROTHEUS:
---------------------------------------------------------------------------------------------------------
		PROCESSO: RECÁLCULO DO CUSTO MÉDIO PROTHEUS 
---------------------------------------------------------------------------------------------------------
	1 - Custo de Entrada 
		Ambiente: SIGAEST (04) Estoque/Custos
		Caminho:  Miscelanea->Acertos->Custo de Entrada.
---------------------------------------------------------------------------------------------------------
	2 - Saldo Atual
		Ambiente: SIGAEST (04) Estoque/Custos
		Caminho:  Miscelanea->Acertos->Saldo Atual. 		
---------------------------------------------------------------------------------------------------------
	3 - Recálculo custo médio
		Ambiente: SIGAEST (04) Estoque/Custos
		Caminho:  Miscelanea->recalculo->Custo Medio. 
---------------------------------------------------------------------------------------------------------

	
*/
