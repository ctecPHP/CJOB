USE controle_acesso
DECLARE
       @CONT INT,
	   @ID INT,
	   @TPESSOA INT,
	   @DATA_INI DATE,
	   @DATA_FIN DATE, 
	   @QUERY varchar(max) 	      	     
BEGIN 
        SET @CONT = 1
		SET @DATA_INI = '20181101'
		SET @DATA_FIN = '20181129'	
		SET @QUERY  =  'USE controle_acesso '	
		SET @QUERY +=  'SET DATEFORMAT ymd '
        
		IF OBJECT_ID('tempdb.dbo.TEMP_REPORT', 'U') IS NOT NULL
        DROP TABLE tempdb.dbo.TEMP_REPORT   

        /* RETORNA ID DAS PESSOAS, NÚMERA AS LINHAS DE 1 A X E GRAVA NA TEBELA TEMPORÁRIA */
		SELECT ID, ROW_NUMBER() OVER(ORDER BY ID ASC) AS ROW 
		INTO tempdb.dbo.TEMP_REPORT
		FROM PESSOA WHERE STATUS = 'A'
        
        /* CONTA NÚMERO DE REGISTROS NA TABELA TEMPORÁRIA */
    	SELECT @TPESSOA = COUNT(ID) FROM tempdb.dbo.TEMP_REPORT

		WHILE @CONT <= @TPESSOA
		BEGIN
		      --SET @ID = (SELECT ID FROM tempdb.dbo.TEMP_REPORT WHERE ROW = @CONT)		       
		      SELECT @ID = ID FROM tempdb.dbo.TEMP_REPORT WHERE ROW = @CONT
			  
              SET @QUERY += 'SELECT A.ID_PESSOA, '
	          SET @QUERY += 'A.ACESSO, '
	          SET @QUERY += 'P.NOME, ' 
              SET @QUERY += 'CONVERT(VARCHAR(5),A.ACESSO,108) AS HORA_ACESSO ' 
              SET @QUERY += 'FROM ACESSO A '
              SET @QUERY += 'INNER JOIN PESSOA P on P.ID = A.ID_PESSOA '
              SET @QUERY +=	'WHERE ID_PESSOA = ' + CAST(@ID AS VARCHAR) + ' AND A.ACESSO ' 
              SET @QUERY += 'BETWEEN ''' + CAST(@DATA_INI AS VARCHAR) + ''' AND DATEADD(DAY, 1,''' + CAST(@DATA_FIN AS VARCHAR) + ''')'

			  IF @CONT = @TPESSOA
			  BEGIN 										
			        SET @QUERY += ''	
			  END      
			  ELSE
			  BEGIN
			    	SET @QUERY += ' UNION '
			  END   
			 
		      SET @CONT = @CONT + 1
		END 
		EXEC(@QUERY)				
END
GO
