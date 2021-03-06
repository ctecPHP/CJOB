DECLARE @NUMPEDIDO AS INT
	SET @NUMPEDIDO = 940

/* CAB PV ACACIA - WORKFLOW */
SELECT PD.CODIGOCLIENTE,         
       CL.RAZAOSOCIAL,        
	   PD.CODIGOVENDEDOR,         
	   E.NOME,        
	   PD.NUMPEDIDO,         
	   PD.NUMPEDIDOAFV,         
	   CONVERT(VARCHAR(10), PD.DATAPEDIDO, 103) AS DATAPEDIDO,     
	   CP.CODIGO + ' - ' + CP.DESCRICAO AS CONDPAGTOPEDIDO,        
	   CC.CODIGODESCRICAO AS CONDPAGTOCLIENTE,          
	   PD.HORAFINAL,         
	   PD.CODIGOTABPRECO,         
	   TPD.DESCRICAO AS DESCRICAOTIPOPEDIDO,         
	   'R$ ' + CAST(REPLACE(CONVERT(VARCHAR,CAST(ROUND( COALESCE(PD.VALORBRUTO, 0.0000) , 2) AS MONEY), 1), ',','.') AS VARCHAR(30)) AS VALORBRUTO,         
	   'R$ ' + CAST(REPLACE(CONVERT(VARCHAR,CAST(ROUND( COALESCE(PD.VALORLIQUIDO, 0.0000) , 2) AS MONEY), 1), ',','.') AS VARCHAR(30)) AS VALORLIQUIDO,        
	   PD.CESP_NUMPEDIDOASSOC AS PEDIDOASSOCIADO,     
	   'R$ ' + CAST(REPLACE(CONVERT(VARCHAR,CAST(ROUND( COALESCE((SELECT SUM(ISNULL(IT.QTDEVENDA,0) * ISNULL(IT.VALORVENDA,0)) AS TOTALVENDA                   
	   FROM T_PEDIDOITEM IT                  
	   WHERE IT.NUMPEDIDOAFV IN (SELECT TAB.ITENS 
	                             FROM T_PEDIDO PED CROSS APPLY dbo.F_SPLIT(ISNULL(PED.CESP_NUMPEDIDOASSOC,''),';') TAB
	                             WHERE PED.NUMPEDIDO = PD.NUMPEDIDO)), 0.0000) , 2) AS MONEY), 1), ',','.') AS VARCHAR(30))  AS VALORTOTALPEDASSOC,        
	                             RG.DESCRICAO AS MOTIVOBLOQUEIO 
	                             FROM T_PEDIDO PD          
	                             INNER JOIN TE_CLIENTE CL ON (CL.CODIGO =  PD.CODIGOCLIENTE)   
	                             INNER JOIN VW_CLIENTECONDPAGTO CC ON (CC.CODIGO = PD.CODIGOCLIENTE)         
	                             INNER JOIN T_EMPRESA E ON (E.CODIGO = PD.CODIGOVENDEDOR)   
	                             INNER JOIN T_CONDPAGTO CP ON (CP.CODIGO = PD.CODIGOCONDPAGTO)         
	                             LEFT JOIN  T_TIPOPEDIDO TPD ON (TPD.CODIGO =  PD.CODIGOTIPOPEDIDO)  
	                             INNER JOIN TWF_PEDIDOBLOQ PDB ON (PDB.NUMPEDIDO = PD.NUMPEDIDO)   
	                             INNER JOIN T_REGRAWORKFLOW RG ON (RG.CODIGO = PDB.CODIGOMOTBLOQ) 
	                             WHERE  PD.NUMPEDIDO = @NUMPEDIDO
GO	    						   

/*ITENS PV ACACIA*/
SELECT    PDI.NUMPEDIDO,    
          PDI.NUMITEM,   
		  PDI.CODIGOPRODUTO,   
		  PR.DESCRICAO ,   
		  PDI.QTDEVENDA,   
		  'R$ ' + CAST(REPLACE(CONVERT(VARCHAR,CAST(ROUND( COALESCE(PDI.VALORBRUTO, 0.0000) , 2) AS MONEY), 1), ',','.') AS VARCHAR(30)) AS VALORBRUTO,    
		  --COALESCE(PDI.DESCONTOI, 0) AS DESCI,   
		  CAST(COALESCE(PDI.DESCONTOI, 0) AS DECIMAL(10,2)) AS DESCI,   
		  COALESCE(PDI.DESCONTOII, 0) AS DESCII,   
		  COALESCE(PDI.DESCONTOIII, 0) AS DESCIII,   
		  'R$ ' + CAST(REPLACE(CONVERT(VARCHAR,CAST(ROUND( COALESCE(PDI.VALORVENDA, 0.0000) , 2) AS MONEY), 1), ',','.') AS VARCHAR(30)) AS VALORLIQUIDO   
		  FROM T_PEDIDOITEM PDI   INNER JOIN TE_PRODUTO PR ON (PR.CODIGO = PDI.CODIGOPRODUTO)  
		  WHERE NUMPEDIDO = @NUMPEDIDO
GO

/* Tabela Configura Layout de E-mail*/
SELECT *
FROM AFVServer_SOBEL_PRD.dbo.T$_LAYOUTEMAIL
GO

