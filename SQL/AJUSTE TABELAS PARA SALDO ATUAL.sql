/* SCRIPT AJUSTE - PROTHEUS SALDO ATUAL */
USE Protheus_Teste12
GO
UPDATE SD1040 SET D1_CUSTO  = 1,
				  D1_CUSTO2 = 1			 
GO
UPDATE SD2040 SET D2_CUSTO1 = 1,
				  D2_CUSTO2 = 1
GO
--UPDATE SD3040 SET D3_CUSTO1 = 1,
--				  D3_CUSTO2 = 1
--GO
UPDATE SB2040 SET B2_CM1 = 1,
				  B2_CM1 = 1
GO