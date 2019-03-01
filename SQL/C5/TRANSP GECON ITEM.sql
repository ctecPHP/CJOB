/* 
	---------------------------------------------------------------------------------------------------------------------------------------------
	@description 	transporta produto da base de produção para base de teste do GECON	
	@version    	1.0
	@package    
	@author     	Ademilson Nunes
	@copyright  	Sobel Suprema Ind. 
	@license  		 
	----------------------------------------------------------------------------------------------------------------------------------------------
*/

/* Transporta produto */
INSERT INTO [SOBEL TESTE].tbproduto1 SELECT * FROM tbproduto1 WHERE tbproduto1.IDPRO = 817

/* Transporta embalagens  */
INSERT INTO [SOBEL TESTE].tbembalagem SELECT * FROM tbembalagem WHERE IDPRO = 817 AND IDEMB IN (1252,1293)